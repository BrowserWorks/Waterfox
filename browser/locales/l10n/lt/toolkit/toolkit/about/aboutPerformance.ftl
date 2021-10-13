# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Užduočių tvarkytuvė

## Column headers

column-name = Pavadinimas
column-type = Tipas
column-energy-impact = Energijos poveikis
column-memory = Atmintis

## Special values for the Name column

ghost-windows = Paskiausiai užvertos kortelės
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Įkelta iš anksto: { $title }

## Values for the Type column

type-tab = Kortelė
type-subframe = Sub-kadras
type-tracker = Stebėjimo elementas
type-addon = Priedas
type-browser = Naršyklė
type-worker = Scenarijus
type-other = Kitas

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Aukštas ({ $value })
energy-impact-medium = Vidutinis ({ $value })
energy-impact-low = Žemas ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Užverti kortelę
show-addon =
    .title = Rodyti priedų tvarkytuvėje

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Išsiuntimai nuo įkėlimo: { $totalDispatches } ({ $totalDuration }ms)
        Išsiuntimai per paskutines sekundes: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
