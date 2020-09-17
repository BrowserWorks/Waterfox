# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Upravitelj opravil

## Column headers

column-name = Ime
column-type = Vrsta
column-energy-impact = Vpliv na energijo
column-memory = Pomnilnik

## Special values for the Name column

ghost-windows = Nedavno zaprti zavihki
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Prednaloženo: { $title }

## Values for the Type column

type-tab = Zavihek
type-subframe = Podokvir
type-tracker = Sledilec
type-addon = Dodatek
type-browser = Brskalnik
type-worker = Worker
type-other = Drugo

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = velik ({ $value })
energy-impact-medium = srednji ({ $value })
energy-impact-low = majhen ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Zapri zavihek
show-addon =
    .title = Prikaži v upravitelju dodatkov

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Odpošiljanj od nalaganja strani: { $totalDispatches } ({ $totalDuration } ms)
        Odpošiljanj v zadnjih sekundah: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
