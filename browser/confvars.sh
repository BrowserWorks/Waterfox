#! /bin/sh
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

MOZ_APP_BASENAME=Firefox
MOZ_APP_VENDOR=Mozilla
MOZ_UPDATER=1
MOZ_PHOENIX=1

if test "$OS_ARCH" = "WINNT" -o \
        "$OS_ARCH" = "Linux"; then
  MOZ_BUNDLED_FONTS=1
fi

if test "$OS_ARCH" = "WINNT"; then
  MOZ_MAINTENANCE_SERVICE=1
  if ! test "$HAVE_64BIT_BUILD"; then
    if test "$MOZ_UPDATE_CHANNEL" = "nightly" -o \
            "$MOZ_UPDATE_CHANNEL" = "aurora" -o \
            "$MOZ_UPDATE_CHANNEL" = "beta" -o \
            "$MOZ_UPDATE_CHANNEL" = "beta-dev" -o \
            "$MOZ_UPDATE_CHANNEL" = "release" -o \
            "$MOZ_UPDATE_CHANNEL" = "release-dev"; then
      if ! test "$MOZ_DEBUG"; then
        MOZ_STUB_INSTALLER=1
      fi
    fi
  fi
fi

# Enable building ./signmar and running libmar signature tests
MOZ_ENABLE_SIGNMAR=1

MOZ_APP_VERSION=$FIREFOX_VERSION
MOZ_APP_VERSION_DISPLAY=$FIREFOX_VERSION_DISPLAY
MOZ_EXTENSIONS_DEFAULT=" gio"
# MOZ_APP_DISPLAYNAME will be set by branding/configure.sh
# MOZ_BRANDING_DIRECTORY is the default branding directory used when none is
# specified. It should never point to the "official" branding directory.
# For mozilla-beta, mozilla-release, or mozilla-central repositories, use
# "unofficial" branding.
# For the mozilla-aurora repository, use "aurora".
MOZ_BRANDING_DIRECTORY=browser/branding/unofficial
MOZ_OFFICIAL_BRANDING_DIRECTORY=browser/branding/official
MOZ_APP_ID={ec8030f7-c20a-464f-9b0e-13a3a9e97384}
# This should usually be the same as the value MAR_CHANNEL_ID.
# If more than one ID is needed, then you should use a comma separated list
# of values.
ACCEPTED_MAR_CHANNEL_IDS=firefox-mozilla-release
# The MAR_CHANNEL_ID must not contain the following 3 characters: ",\t "
MAR_CHANNEL_ID=firefox-mozilla-release
MOZ_PROFILE_MIGRATOR=1
MOZ_APP_STATIC_INI=1
MOZ_WEBGL_CONFORMANT=1
MOZ_JSDOWNLOADS=1
MOZ_RUST_MP4PARSE=1
MOZ_RUST_URLPARSE=1

# Enable checking that add-ons are signed by the trusted root
MOZ_ADDON_SIGNING=1

# Include the DevTools client, not just the server (which is the default)
MOZ_DEVTOOLS=all
