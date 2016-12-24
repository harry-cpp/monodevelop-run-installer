#!/bin/bash
# https://github.com/fusion809/PKGBUILDs/releases

mkdir tmp
cd tmp

echo "Downloading metadata..."
{
	URLS="$(
	curl https://github.com/fusion809/PKGBUILDs/releases | \
	grep 'monodevelop' | \
	grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | \
	sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' \
	)"
} &> /dev/null
for URL in $URLS
do
    URL="https://www.github.com$URL"
done

echo "Downloading MonoDevelop... ($URL)"
wget -O monodevelop.tar.xz $URL &> /dev/null

echo "Extracting archive..."
tar xf monodevelop.tar.xz

echo "Copying installer data..."

# Copy installer source
mkdir installer
cp -rf ../src/. installer

# Copy MonoDevelop binaries
mkdir installer/MonoDevelop
cp -rf usr/lib/monodevelop/. installer/MonoDevelop
# Lets not include version control addin so that people don't ask me why it's not working...
rm -rf installer/MonoDevelop/AddIns/VersionControl

# Copy MonoDevelop icon
cp usr/share/icons/hicolor/scalable/apps/monodevelop.svg installer/monodevelop-stable.svg

echo "Building the Installer..."
rm -f ../bin
mkdir ../bin
../makeself/makeself.sh installer/ ../bin/monodevelop.run "MonoDevelop .run installer" ./postinstall.sh

echo "Cleaning Up..."
cd ..
rm -rf tmp

echo "Done :)"
