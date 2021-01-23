# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Manager de activități

## Column headers

column-name = Nume
column-type = Tip
column-energy-impact = Impact energetic
column-memory = Memorie

## Special values for the Name column

ghost-windows = File închise recent
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Preîncărcat: { $title }

## Values for the Type column

type-tab = Filă
type-subframe = Subcadru
type-tracker = Element de urmărire
type-addon = Supliment
type-browser = Browser
type-worker = Worker
type-other = Altul

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Ridicat ({ $value })
energy-impact-medium = Mediu ({ $value })
energy-impact-low = Scăzut ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Închide fila
show-addon =
    .title = Afișează în managerul de suplimente

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Expedieri de la încărcare: { $totalDispatches } ({ $totalDuration } ms)
        Expedieri din ultimele câteva secunde: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
