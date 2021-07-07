# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Jobliste

## Column headers
column-name = Navn
column-type = Type
column-energy-impact = Energi-forbrug

column-memory = Hukommelse

## Special values for the Name column
ghost-windows = Nyligt lukkede faneblade
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Forhåndsindlæst: { $title }

## Values for the Type column
type-tab = Faneblad
type-subframe = Subframe
type-tracker = Tracker
type-addon = Tilføjelse
type-browser = Browser
type-worker = Worker
type-other = Andet

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)
energy-impact-high = Høj ({ $value })
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
    .title = Luk faneblad
show-addon =
    .title = Vis i fanebladet Tilføjelser

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Udsendelser siden indlæsning: { $totalDispatches } ({ $totalDuration }ms)
        Udsendelser de seneste sekunder: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
