# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Správca úloh

## Column headers

column-name = Názov
column-type = Typ
column-energy-impact = Energetický dopad
column-memory = Pamäť

## Special values for the Name column

ghost-windows = Nedávno zatvorené karty
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Prednačítané: { $title }

## Values for the Type column

type-tab = Karta
type-subframe = Podrám
type-tracker = Sledovací prvok
type-addon = Doplnok
type-browser = Prehliadač
type-worker = Worker
type-other = Iný

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Vysoký ({ $value })
energy-impact-medium = Stredný ({ $value })
energy-impact-low = Nízky ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } kB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Zavrieť kartu
show-addon =
    .title = Zobraziť v správcovi doplnkov

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Počet spustení od načítania: { $totalDispatches } ({ $totalDuration } ms)
        Počet spustení za posledné sekundy: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
