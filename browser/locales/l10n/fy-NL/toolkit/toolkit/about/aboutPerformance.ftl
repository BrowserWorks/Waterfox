# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Taakbehearder

## Column headers

column-name = Namme
column-type = Type
column-energy-impact = Enerzjy-ympakt
column-memory = Unthâld

## Special values for the Name column

ghost-windows = Koartlyn sluten ljepblêden
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Yn it foar laden: { $title }

## Values for the Type column

type-tab = Ljepblêd
type-subframe = Subframe
type-tracker = Tracker
type-addon = Add-on
type-browser = Browser
type-worker = Worker
type-other = Oars

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Heech ({ $value })
energy-impact-medium = Gemiddeld ({ $value })
energy-impact-low = Leech ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Ljepblêd slute
show-addon =
    .title = Toane yn Add-onbehearder

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Ynstjoeringen sûnt laden: { $totalDispatches } ({ $totalDuration } ms)
        Ynstjoeringen yn de ôfrûne sekonden: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
