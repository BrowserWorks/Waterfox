# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Tehtävienhallinta

## Column headers

column-name = Nimi
column-type = Tyyppi
column-energy-impact = Energiavaikutus
column-memory = Muisti

## Special values for the Name column

ghost-windows = Suljetut välilehdet
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Esiladattu: { $title }

## Values for the Type column

type-tab = Välilehti
type-subframe = Alikehys
type-tracker = Seurain
type-addon = Lisäosa
type-browser = Selain
type-worker = Työsäie
type-other = Muu

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Suuri ({ $value })
energy-impact-medium = Kohtalainen ({ $value })
energy-impact-low = Pieni ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } kt
size-MB = { $value } Mt
size-GB = { $value } Gt

## Tooltips for the action buttons

close-tab =
    .title = Sulje välilehti
show-addon =
    .title = Näytä lisäosien hallinnassa

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Suoritinkäyttö latautumisesta lähtien: { $totalDispatches } ({ $totalDuration } ms)
        Suoritinkäyttö viime sekuntien aikana: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
