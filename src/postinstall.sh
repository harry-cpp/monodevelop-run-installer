#!/bin/bash

# Check installation priviledge
if [ "$(id -u)" != "0" ]; then
	echo "Please make sure you are running this installer with sudo or as root." 1>&2
	exit 1
fi

# Check previous versions
if type "monodevelop-stable-uninstall" > /dev/null 2>&1
then
	echo "Previous version detected, uninstalling..."
	monodevelop-stable-uninstall
fi

echo "Copying MonoDevelop binaries..."
cp -rf MonoDevelop/ /opt/MonoDevelop/

echo "Adding terminal commands..."
cp monodevelop-stable /usr/bin/monodevelop-stable
chmod +x /usr/bin/monodevelop-stable
cp mdtool-stable /usr/bin/mdtool-stable
chmod +x /usr/bin/mdtool-stable
cp monodevelop-stable-uninstall /usr/bin/monodevelop-stable-uninstall
chmod +x /usr/bin/monodevelop-stable-uninstall

echo "Adding application icon..."
mkdir -p /usr/share/icons/hicolor/scalable/apps
cp monodevelop-stable.svg /usr/share/icons/hicolor/scalable/apps/monodevelop-stable.svg
gtk-update-icon-cache /usr/share/icons/hicolor/ -f &> /dev/null

echo "Adding application launcher..."
cat > /usr/share/applications/monodevelop-stable.desktop <<'endmsg'
[Desktop Entry]
Version=1.0
Encoding=UTF-8
Name=MonoDevelop Stable
GenericName=Integrated Development Environment
GenericName[ja]=統合開発環境
Comment=Develop .NET applications in an Integrated Development Environment
Exec=monodevelop-stable %F
TryExec=monodevelop-stable
Icon=monodevelop-stable
StartupNotify=true
Terminal=false
Type=Application
MimeType=text/x-csharp;application/x-mds;application/x-mdp;application/x-cmbx;application/x-prjx;application/x-csproj;application/x-vbproj;application/x-sln;application/x-aspx;
Categories=GNOME;GTK;Development;IDE;
X-GNOME-Bugzilla-Bugzilla=Ximian
X-GNOME-Bugzilla-Product=MonoDevelop
X-GNOME-Bugzilla-OtherBinaries=monodevelop
endmsg
