# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Verkstjóri

## Column headers

column-name = Nafn
column-type = Gerð
column-energy-impact = Umfang orku
column-memory = Minni

## Special values for the Name column

ghost-windows = Nýlokaðir flipar
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Forhlaðið: { $title }

## Values for the Type column

type-tab = Flipi
type-subframe = Undirrammi
type-tracker = Rekjari
type-addon = Viðbót
type-browser = Vafri
type-worker = Vinnuafl
type-other = Annað

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Hátt ({ $value })
energy-impact-medium = Miðlungis ({ $value })
energy-impact-low = Lágt ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = ({ $value }) KB
size-MB = ({ $value }) MB
size-GB = ({ $value }) GB

## Tooltips for the action buttons

close-tab =
    .title = Loka flipa
show-addon =
    .title = Sýna í viðbótastjóra

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Klukkutíðni frá hleðslu: { $totalDispatches } ({ $totalDuration }ms)
        Klukkutíðni á seinustu sek: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
