# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

MOZ_APP_DISPLAYNAME=Waterfox

# Hard code profile locations due to rebranding changing the default location
if test "$OS_ARCH" = "WINNT"; then
  MOZ_APP_PROFILE=Mozilla/Firefox
elif test "$OS_ARCH" = "Linux"; then
  MOZ_APP_PROFILE=mozilla/Firefox
elif test "$OS_ARCH" = "Darwin"; then
  MOZ_APP_PROFILE=Firefox
fi

MOZ_TELEMETRY_REPORTING=0
#MOZ_ADDON_SIGNING=0
#MOZ_REQUIRE_SIGNING=0
MOZ_ADOBE_EME=0
MOZ_WIDEVINE_EME=0
MOZ_SERVICES_HEALTHREPORT=0
MOZ_CRASHREPORTER=0
MOZ_DATA_REPORTING=0