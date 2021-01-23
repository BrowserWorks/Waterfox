# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Zastojnik nadawkow

## Column headers

column-name = Mě
column-type = Typ
column-energy-impact = Energijowa śěža
column-memory = Skład

## Special values for the Name column

ghost-windows = Rowno zacynjone rejtariki
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Doprědka zacytany: { $title }

## Values for the Type column

type-tab = Rejtarik
type-subframe = Pódwobłuk
type-tracker = Pśeslědowak
type-addon = Dodank
type-browser = Wobglědowak
type-worker = Worker
type-other = Druge

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Wusoki ({ $value })
energy-impact-medium = Srjejźny ({ $value })
energy-impact-low = Niski ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Rejtarik zacyniś
show-addon =
    .title = W zastojniku dodankow pokazaś

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occurred for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occurred in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Rozpósłanja wót zacytanja: { $totalDispatches } ({ $totalDuration } ms)
        Rozpósłanja za zajźone sekundy: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
