#!/bin/bash
# https://github.com/fusion809/PKGBUILDs/releases

MDFDIR="$HOME/.local/share/flatpak/app/com.xamarin.MonoDevelop/current/active/files"

mkdir tmp
cd tmp

echo "Copying installer data..."

# Copy installer source
mkdir installer
cp -rf ../src/. installer

# Copy MonoDevelop binaries
mkdir installer/MonoDevelop
cp -rf $MDFDIR/lib/monodevelop/. installer/MonoDevelop
# Lets not include git version control addin so that people don't ask me why it's not working...
rm -rf installer/MonoDevelop/AddIns/VersionControl/MonoDevelop.VersionControl.Git.dll

echo "Building the Installer..."
rm -f ../bin
mkdir ../bin
../makeself/makeself.sh installer/ ../bin/monodevelop.run "MonoDevelop .run installer" ./postinstall.sh

echo "Cleaning Up..."
cd ..
rm -rf tmp

echo "Done :)"
