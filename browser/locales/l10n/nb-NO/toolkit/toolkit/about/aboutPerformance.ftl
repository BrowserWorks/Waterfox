# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Aktivitetsbehandler

## Column headers

column-name = Navn
column-type = Type
column-energy-impact = Energipåvirkning
column-memory = Minne

## Special values for the Name column

ghost-windows = Nylig lukkede faner
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Forhåndslastet: { $title }

## Values for the Type column

type-tab = Fane
type-subframe = Underfane
type-tracker = Sporer
type-addon = Utvidelse
type-browser = Nettleser
type-worker = Worker
type-other = Annet

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Høy ({ $value })
energy-impact-medium = Medium ({ $value })
energy-impact-low = Lav ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Lukk fane
show-addon =
    .title = Åpne i utvidelsesbehandler

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Forsendelser siden belastning: { $totalDispatches } ({ $totalDuration } ms)
        Forsendelser de siste sekundene: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
