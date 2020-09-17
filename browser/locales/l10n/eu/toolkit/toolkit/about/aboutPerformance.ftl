# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Ataza-kudeatzailea

## Column headers

column-name = Izena
column-type = Mota
column-energy-impact = Energia-eragina
column-memory = Memoria

## Special values for the Name column

ghost-windows = Itxitako azken fitxak
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Aurrekargatuta: { $title }

## Values for the Type column

type-tab = Fitxa
type-subframe = Azpimarkoa
type-tracker = Jarraipen-elementua
type-addon = Gehigarria
type-browser = Nabigatzailea
type-worker = Langilea
type-other = Bestelakoa

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Altua ({ $value })
energy-impact-medium = Ertaina ({ $value })
energy-impact-low = Baxua ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Itxi fitxa
show-addon =
    .title = Erakutsi gehigarrien kudeatzailean

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occurred for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occurred in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Igorpenak kargaz geroztik: { $totalDispatches } ({ $totalDuration }ms)
        Igorpenak azken segundoetan: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
