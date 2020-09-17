# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Kinuk'samajel taq Samaj

## Column headers

column-name = B'i'aj
column-type = Ruwäch
column-energy-impact = Uchuq'anel Q'ilonel
column-memory = Rupam rujolom

## Special values for the Name column

ghost-windows = Taq ruwi' k'a b'a' ketz'apïx
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Samajib'en wi: { $title }

## Values for the Type column

type-tab = Ruwi'
type-subframe = Achkajtz'ik
type-tracker = Ojqanel
type-addon = Tz'aqat
type-browser = Okik'amaya'l
type-worker = Samajel
type-other = Juley chik

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Chawon ({ $value })
energy-impact-medium = Loman ({ $value })
energy-impact-low = Ko'öl ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Titz'apïx ruwi'
show-addon =
    .title = Tik't Kinuk'usamajel taq Tz'aqat

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title = Ya'oj pa ri samajib'enïk: { $totalDispatches } ({ $totalDuration }ms) Taq ya'oj pa ri ruk'isib'äl ch'utiramaj: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
