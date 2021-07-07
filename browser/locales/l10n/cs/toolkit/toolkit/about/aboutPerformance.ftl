# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Správce úloh

## Column headers

column-name = Název
column-type = Typ
column-energy-impact = Energetický dopad
column-memory = Paměť

## Special values for the Name column

ghost-windows = Nedávno zavřené panely
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Přednačteno: { $title }

## Values for the Type column

type-tab = Panel
type-subframe = Podrám
type-tracker = Sledovací prvek
type-addon = Doplněk
type-browser = Prohlížeč
type-worker = Worker
type-other = Jiný

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Vysoký ({ $value })
energy-impact-medium = Střední ({ $value })
energy-impact-low = Nízký ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Zavřít panel
show-addon =
    .title = Zobrazit ve správci doplňků

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Počet spuštění od načtení: { $totalDispatches } ({ $totalDuration }ms)
        Počet spuštění za poslední vteřinu: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
