# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Feladatkezelő

## Column headers

column-name = Név
column-type = Típus
column-energy-impact = Energiahatás
column-memory = Memória

## Special values for the Name column

ghost-windows = Nemrég bezárt lapok
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Előre betöltve: { $title }

## Values for the Type column

type-tab = Lap
type-subframe = Alkeret
type-tracker = Követő
type-addon = Kiegészítő
type-browser = Böngésző
type-worker = Worker
type-other = Egyéb

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Magas ({ $value })
energy-impact-medium = Közepes ({ $value })
energy-impact-low = Alacsony ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Lap bezárása
show-addon =
    .title = Megjelenítés a kiegészítőkezelőben

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Átküldések a betöltés óta: { $totalDispatches } ({ $totalDuration } ms)
        Átküldések az elmúlt két másodpercben: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
