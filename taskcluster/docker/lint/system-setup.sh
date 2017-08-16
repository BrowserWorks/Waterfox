#!/usr/bin/env bash
# This allows ubuntu-desktop to be installed without human interaction
export DEBIAN_FRONTEND=noninteractive

set -ve

test `whoami` == 'root'

mkdir -p /setup
cd /setup

apt_packages=()
apt_packages+=('curl')
apt_packages+=('locales')
apt_packages+=('python')
apt_packages+=('python-pip')
apt_packages+=('sudo')
apt_packages+=('wget')
apt_packages+=('xz-utils')

apt-get update
apt-get install -y ${apt_packages[@]}

# Without this we get spurious "LC_ALL: cannot change locale (en_US.UTF-8)" errors,
# and python scripts raise UnicodeEncodeError when trying to print unicode characters.
locale-gen en_US.UTF-8
dpkg-reconfigure locales

tooltool_fetch() {
    cat >manifest.tt
    /build/tooltool.py fetch
    rm manifest.tt
}

cd /build
. install-mercurial.sh

###
# ESLint Setup
###

# install node

. install-node.sh

###
# Flake8 Setup
###

cd /setup

pip install --require-hashes -r /tmp/flake8_requirements.txt

###
# tox Setup
###

cd /setup

pip install --require-hashes -r /tmp/tox_requirements.txt

cd /
rm -rf /setup
