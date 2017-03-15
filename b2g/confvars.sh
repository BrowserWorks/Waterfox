# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

MOZ_APP_BASENAME=B2G
MOZ_APP_VENDOR=Mozilla

MOZ_APP_VERSION=$FIREFOX_VERSION
MOZ_APP_UA_NAME=Firefox

MOZ_UA_OS_AGNOSTIC=1

MOZ_B2G_VERSION=2.6.0.0-prerelease
MOZ_B2G_OS_NAME=Boot2Gecko

MOZ_BRANDING_DIRECTORY=b2g/branding/unofficial
MOZ_OFFICIAL_BRANDING_DIRECTORY=b2g/branding/official
# MOZ_APP_DISPLAYNAME is set by branding/configure.sh

MOZ_NO_SMART_CARDS=1
MOZ_APP_STATIC_INI=1

if test "$OS_TARGET" = "Android"; then
MOZ_CAPTURE=1
MOZ_RAW=1
MOZ_AUDIO_CHANNEL_MANAGER=1
fi

# use custom widget for html:select
MOZ_USE_NATIVE_POPUP_WINDOWS=1

MOZ_XULRUNNER=

MOZ_APP_ID={3c2e2abc-06d4-11e1-ac3b-374f68613e61}

MOZ_TIME_MANAGER=1

MOZ_TOOLKIT_SEARCH=
MOZ_B2G=1

MOZ_JSDOWNLOADS=1

MOZ_BUNDLED_FONTS=1

export JS_GC_SMALL_CHUNK_SIZE=1
