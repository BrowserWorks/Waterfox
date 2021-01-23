# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Tembiapo ñangarekohára

## Column headers

column-name = Téra
column-type = Peteĩchagua
column-energy-impact = Mba’erendy mbaretekue
column-memory = Mandu’arenda

## Special values for the Name column

ghost-windows = Tendayke oñemboty ramóva
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Henyhẽmbáva: { $title }

## Values for the Type column

type-tab = Tendayke
type-subframe = Subframe
type-tracker = Tapykuehohára
type-addon = Tembipuru’i
type-browser = Kundaha
type-worker = Mba’apohára
type-other = Ambue

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Epyta ({ $value })
energy-impact-medium = Mbyte ({ $value })
energy-impact-low = Karape ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Emboty tendayke
show-addon =
    .title = Ehechauka moĩmbaha ñangarekohápe
# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occurred for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occurred in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title = Ñemondo myenyhẽha guive: { $totalDispatches } ({ $totalDuration } ms) Ñemondo aravo’iete pahávapa: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
