# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

MOZ_APP_DISPLAYNAME=Waterfox
MOZ_APP_REMOTINGNAME=waterfox
MOZ_DEV_EDITION=1
MOZ_TELEMETRY_REPORTING=
MOZ_SERVICES_HEALTHREPORT=
MOZ_NORMANDY=
MOZ_REQUIRE_SIGNING=
MOZ_DEFAULT_BROWSER_AGENT=0

if test "$OS_ARCH" = "WINNT"; then
  MOZ_APP_PROFILE=Waterfox
elif test "$OS_ARCH" = "Darwin"; then
  MOZ_APP_PROFILE=Waterfox
else
  MOZ_APP_PROFILE=Waterfox
fi