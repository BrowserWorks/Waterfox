# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Zrjadowak nadawkow

## Column headers

column-name = Mjeno
column-type = Typ
column-energy-impact = Energijowa ćeža
column-memory = Skład

## Special values for the Name column

ghost-windows = Runje začinjene rajtarki
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Dočasa začitany: { $title }

## Values for the Type column

type-tab = Rajtark
type-subframe = Podwobłuk
type-tracker = Přesćěhowak
type-addon = Přidatk
type-browser = Wobhladowak
type-worker = Worker
type-other = Druhe

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Wysoki ({ $value })
energy-impact-medium = Srjedźny ({ $value })
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
    .title = Rajtark začinić
show-addon =
    .title = W zrjadowaku přidatkow pokazać

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Rozpósłanja wot začitanja: { $totalDispatches } ({ $totalDuration } ms)
        Rozpósłanja za zańdźene sekundy: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
