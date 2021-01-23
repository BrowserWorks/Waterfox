#!/usr/bin/env bash

set -ve

test "$(whoami)" == 'root'

mkdir -p /setup
cd /setup

apt_packages=()

apt_packages+=('alsa-base')
apt_packages+=('alsa-utils')
apt_packages+=('autoconf2.13')
apt_packages+=('bluez-cups')
apt_packages+=('build-essential')
apt_packages+=('ca-certificates')
apt_packages+=('ccache')
apt_packages+=('curl')
apt_packages+=('fonts-kacst')
apt_packages+=('fonts-kacst-one')
apt_packages+=('fonts-liberation')
apt_packages+=('fonts-stix')
apt_packages+=('fonts-unfonts-core')
apt_packages+=('fonts-unfonts-extra')
apt_packages+=('fonts-vlgothic')
apt_packages+=('g++-multilib')
apt_packages+=('gcc-multilib')
apt_packages+=('gir1.2-gnomebluetooth-1.0')
apt_packages+=('git')
apt_packages+=('gstreamer0.10-alsa')
apt_packages+=('gstreamer0.10-plugins-base')
apt_packages+=('gstreamer0.10-plugins-good')
apt_packages+=('gstreamer0.10-tools')
apt_packages+=('language-pack-en-base')
apt_packages+=('libasound2-dev')
apt_packages+=('libcanberra-pulse')
apt_packages+=('libcurl4-openssl-dev')
apt_packages+=('libdbus-1-dev')
apt_packages+=('libdbus-glib-1-dev')
apt_packages+=('libgconf2-dev')
apt_packages+=('libgstreamer-plugins-base0.10-dev')
apt_packages+=('libgstreamer0.10-dev')
apt_packages+=('libgtk2.0-dev')
apt_packages+=('libiw-dev')
apt_packages+=('libnotify-dev')
apt_packages+=('libpulse-dev')
apt_packages+=('libsox-fmt-alsa')
apt_packages+=('libxt-dev')
apt_packages+=('libxxf86vm1')
apt_packages+=('llvm')
apt_packages+=('llvm-dev')
apt_packages+=('llvm-runtime')
apt_packages+=('nano')
apt_packages+=('net-tools')
apt_packages+=('pulseaudio')
apt_packages+=('pulseaudio-module-bluetooth')
apt_packages+=('pulseaudio-module-gconf')
apt_packages+=('qemu-kvm')
apt_packages+=('rlwrap')
apt_packages+=('screen')
apt_packages+=('software-properties-common')
apt_packages+=('sudo')
apt_packages+=('tar')
apt_packages+=('ttf-dejavu')
apt_packages+=('ubuntu-desktop')
apt_packages+=('unzip')
apt_packages+=('uuid')
apt_packages+=('vim')
apt_packages+=('wget')
apt_packages+=('xvfb')
apt_packages+=('yasm')
apt_packages+=('zip')
apt_packages+=('libsecret-1-0:i386')

# Make sure we have X libraries for 32-bit tests
apt_packages+=('libxt6:i386')
apt_packages+=('libpulse0:i386')
apt_packages+=('libasound2:i386')
apt_packages+=('libxtst6:i386')
apt_packages+=('libgtk2.0-0:i386')

# get xvinfo for test-linux.sh to monitor Xvfb startup
apt_packages+=('x11-utils')

# Bug 1232407 - this allows the user to start vnc
apt_packages+=('x11vnc')

# Bug 1176031: need `xset` to disable screensavers
apt_packages+=('x11-xserver-utils')

# use Ubuntu's Python-2.7 (2.7.3 on Precise)
apt_packages+=('python-dev')
apt_packages+=('python-pip')

apt_packages+=('python3-pip')

apt-get update
# This allows ubuntu-desktop to be installed without human interaction
export DEBIAN_FRONTEND=noninteractive
apt-get install -y -f "${apt_packages[@]}"

dpkg-reconfigure locales

. /setup/common.sh
. /setup/install-mercurial.sh

pip install pip==9.0.3
pip install virtualenv==15.2.0
pip install zstandard==0.13.0
pip3 install zstandard==0.13.0

. /setup/install-node.sh

# Install custom-built Debian packages.  These come from a set of repositories
# packaged in tarballs on tooltool to make them replicable.  Because they have
# inter-dependenices, we install all repositories first, then perform the
# installation.
cp /etc/apt/sources.list sources.list.orig

# Install Valgrind (trunk, late Jan 2016) and do some crude sanity
# checks.  It has to go in /usr/local, otherwise it won't work.  Copy
# the launcher binary to /usr/bin, though, so that direct invokations
# of /usr/bin/valgrind also work.  Also install libc6-dbg since
# Valgrind won't work at all without the debug symbols for libc.so and
# ld.so being available.
tooltool_fetch <<'EOF'
[
{
    "size": 41331092,
    "visibility": "public",
    "digest": "a89393c39171b8304fc262094a650df9a756543ffe9fbec935911e7b86842c4828b9b831698f97612abb0eca95cf7f7b3ff33ea7a9b0313b30c9be413a5efffc",
    "algorithm": "sha512",
    "filename": "valgrind-15775-3206-ubuntu1204.tgz"
}
]
EOF
cp valgrind-15775-3206-ubuntu1204.tgz /tmp
(cd / && tar xzf /tmp/valgrind-15775-3206-ubuntu1204.tgz)
rm /tmp/valgrind-15775-3206-ubuntu1204.tgz
cp /usr/local/bin/valgrind /usr/bin/valgrind
apt-get install -y libc6-dbg
valgrind --version
valgrind date

# Until bug 1511527 is fixed, remove the file from the image to ensure it's not there.
rm -f /usr/local/bin/linux64-minidump_stackwalk

# adding multiverse to get 'ubuntu-restricted-extras' below
apt-add-repository multiverse
apt-get update

# for mp4 codec (used in MSE tests)
apt-get -q -y -f install ubuntu-restricted-extras
# TEMPORARY: we do not want flash installed, but the above pulls it in (bug 1349208)
rm -f /usr/lib/flashplugin-installer/libflashplayer.so

apt-get -q -y -f install \
    libxcb1 \
    libxcb-render0 \
    libxcb-shm0 \
    libxcb-glx0 \
    libxcb-shape0

apt-get -q -y -f install \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    mesa-common-dev

# additional packages for linux32 tests
sudo dpkg --add-architecture i386
apt-get update
apt-get -q -y -f install \
    libavcodec-ffmpeg-extra56:i386 \
    libgtk-3-0:i386 \
    libdbus-glib-1-2:i386

# use fc-cache:i386 to pre-build the font cache for i386 binaries
apt-get -q -y -f install \
    fontconfig:i386 \

# revert the list of repos
cp sources.list.orig /etc/apt/sources.list

# Get some bionic packages
sed 's/xenial/bionic/g' /etc/apt/sources.list > /etc/apt/sources.list.d/bionic.list
cat <<EOF > /etc/apt/preferences.d/pinning
Package: *
Pin: release n=xenial
Pin-Priority: 900

Package: *
Pin: release a=bionic
Pin-Priority: 800
EOF
apt-get update
apt-get -y -f -t bionic install libfreetype6

# clean up
# Purge unneeded stuff from the image
apt-get -y purge cheese 'libcheese*'
apt-get -y purge gnome-user-guide
apt-get -y purge 'libreoffice*'
#apt-get -y purge firefox thunderbird
apt-get -y purge 'liboxideqt*'
apt-get -y purge gnome-mahjongg
apt-get -y purge ubuntu-docs
apt-get -y purge llvm-3.8-dev libllvm3.8
apt-get -y purge git
apt-get -y purge lintian
apt-get -y purge freepats
apt-get -y purge ubuntu-mobile-icons
apt-get -y purge hplip
apt-get -y purge rhythmbox
apt-get -y purge thunderbird
apt-get -y autoremove

# We don't need no docs!
rm -rf /usr/share/help /usr/share/doc /usr/share/man

cd /
rm -rf /setup ~/.ccache ~/.cache ~/.npm
apt-get clean
apt-get autoclean
rm -f "$0"
