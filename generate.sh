#!/bin/bash

# Check flatpak installed
if ! type "flatpak" &> /dev/null
then
	echo "'flatpak' command not found :("
	exit 1
fi

# Locate (and update) Monodevelop
MDFDIR="$HOME/.local/share/flatpak/app/com.xamarin.MonoDevelop/current/active/files"
MDU="$(flatpak list | grep com.xamarin.MonoDevelop | grep user)"
MDS="$(flatpak list | grep com.xamarin.MonoDevelop | grep system)"

if [ -n "$MDS" ]
then
	MDFDIR="/var/lib/flatpak/app/com.xamarin.MonoDevelop/current/active/files"
	flatpak update com.xamarin.MonoDevelop
elif [ -n "$MDU" ] 
then
	flatpak update --user com.xamarin.MonoDevelop
else
	flatpak install --user --from https://download.mono-project.com/repo/monodevelop.flatpakref
fi

if [ ! -d $MDFDIR ]
then
	echo "Could not locate MonoDevelop from flatpak, please make sure it is installed."
	exit 1
fi

mkdir tmp
cd tmp

# Copy installer source
echo "Copying installer data..."
mkdir installer
cp -rf ../src/. installer

# Copy MonoDevelop binaries
mkdir installer/MonoDevelop
cp -rf $MDFDIR/lib/monodevelop/. installer/MonoDevelop
# Lets not include git version control addin so that people don't ask me why it's not working...
rm -rf installer/MonoDevelop/AddIns/VersionControl/MonoDevelop.VersionControl.Git.dll

echo "Building the Installer..."
rm -rf ../bin
mkdir ../bin
../makeself/makeself.sh installer/ ../bin/monodevelop.run "MonoDevelop .run installer" ./postinstall.sh

echo "Cleaning Up..."
cd ..
rm -rf tmp

echo "Done :)"
