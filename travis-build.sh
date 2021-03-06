#!/bin/bash

apt-get --yes update
apt-get --yes install wget gnupg2

### Add KDENeon Repository
echo 'deb http://archive.neon.kde.org/dev/stable/ bionic main' | tee /etc/apt/sources.list.d/neon-stable.list
wget -qO - 'http://archive.neon.kde.org/public.key' | apt-key add -

### Add NXOS Repository
echo 'deb http://repo.nxos.org/testing nxos main' | tee /etc/apt/sources.list.d/nxos-testing.list
wget -qO - 'http://repo.nxos.org/public.key' | apt-key add -

### Install Dependencies
apt-get --yes update
apt-get --yes dist-upgrade
apt-get --yes install devscripts lintian build-essential automake autotools-dev equivs qt5-default qtdeclarative5-dev qtquickcontrols2-5-dev qtwebengine5-dev cmake debhelper extra-cmake-modules libkf5config-dev libkf5coreaddons-dev libkf5i18n-dev libkf5kio-dev libkf5notifications-dev libkf5service-dev libqt5svg5-dev qtbase5-dev  qml-module-org-kde-kirigami2 qml-module-qtquick-controls2 qml-module-qtwebengine qml-module-qmltermwidget libmauikit qml-module-org-kde-mauikit mauikit-dev

mk-build-deps -i -t "apt-get --yes" -r

### Build Deb
mkdir source
mv ./* source/ # Hack for debuild
cd source
debuild -b -uc -us
