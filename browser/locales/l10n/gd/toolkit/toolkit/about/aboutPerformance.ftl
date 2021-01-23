# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Manaidsear nan saothair

## Column headers

column-name = Ainm
column-type = Seòrsa
column-energy-impact = Buaidh air caitheamh dealain
column-memory = Cuimhne

## Special values for the Name column

ghost-windows = Tabaichean a dhùin thu o chionn ghoirid
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Air ro-luchdadh: { $title }

## Values for the Type column

type-tab = Taba
type-subframe = Fo-fhrèam
type-tracker = Tracaiche
type-addon = Tuilleadan
type-browser = Brabhsair
type-worker = Worker
type-other = Eile

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Àrd ({ $value })
energy-impact-medium = Meadhanach ({ $value })
energy-impact-low = Ìseal ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Dùin an taba
show-addon =
    .title = Seall ann am manaidsear nan tuilleadan

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Dispatches since load: { $totalDispatches } ({ $totalDuration }ms)
        Dispatches in the last seconds: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
