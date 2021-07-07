# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

history-title = Update-Chronik
history-intro = Folgende Updates wurden installiert:

close-button-label =
    .buttonlabelcancel = Schließen
    .title = Update-Chronik

no-updates-label = Bisher wurden keine Updates installiert
name-header = Update-Name
date-header = Installationsdatum
type-header = Typ
state-header = Status

# Used to display update history
#
# Variables:
#   $name (String): name of the update
#   $buildID (String): build identifier from the local updates.xml
update-full-build-name = { $name } ({ $buildID })

update-details = Details
update-installed-on = Installiert am: { $date }
update-status = Status: { $status }
