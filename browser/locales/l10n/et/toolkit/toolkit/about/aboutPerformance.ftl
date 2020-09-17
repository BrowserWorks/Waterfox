# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Tegumihaldur

## Column headers

column-name = Nimi
column-type = Tüüp
column-energy-impact = Mõju energiatarbele
column-memory = Mälu

## Special values for the Name column

ghost-windows = Hiljuti suletud kaardid
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Eellaaditud: { $title }

## Values for the Type column

type-tab = Kaart
type-subframe = Alampaneel
type-tracker = Jälitaja
type-addon = Lisa
type-browser = Brauser
type-worker = Tööline
type-other = Muu

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Kõrge ({ $value })
energy-impact-medium = Keskmine ({ $value })
energy-impact-low = Madal ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KiB
size-MB = { $value } MiB
size-GB = { $value } GiB

## Tooltips for the action buttons

close-tab =
    .title = Sulge kaart
show-addon =
    .title = Kuva lisade halduris

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occurred for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occurred in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Dispatches since load: { $totalDispatches } ({ $totalDuration }ms)
        Dispatches in the last seconds: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
