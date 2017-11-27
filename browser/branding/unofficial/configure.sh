# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

MOZ_APP_DISPLAYNAME=Waterfox

# Hard code profile locations due to rebranding changing the default location
if test "$OS_ARCH" = "WINNT"; then
  MOZ_APP_PROFILE=Waterfox
elif test "$OS_ARCH" = "Linux"; then
  MOZ_APP_PROFILE=Waterfox
elif test "$OS_ARCH" = "Darwin"; then
  MOZ_APP_PROFILE=Waterfox
fi
