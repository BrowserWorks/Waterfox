# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Rheolwr Tasgau

## Column headers

column-name = Enw
column-type = Math
column-energy-impact = Effaith Ynni
column-memory = Cof

## Special values for the Name column

ghost-windows = Tabiau Wedi'u Cau'n Ddiweddar
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Rhaglwytho: { $title }

## Values for the Type column

type-tab = Tab
type-subframe = Is-ffrâm
type-tracker = Traciwr
type-addon = Ychwanegyn
type-browser = Porwr
type-worker = Gweithiwr
type-other = Arall

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Uchel ({ $value })
energy-impact-medium = Canolig ({ $value })
energy-impact-low = Isel ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Cau tab
show-addon =
    .title = Dangos yn y Rheolwr Ychwanegion

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Negeseuon ers llwytho: { $totalDispatches } ({ $totalDuration } ms)
        Negeseuon yn yr eiliadau diwethaf: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
