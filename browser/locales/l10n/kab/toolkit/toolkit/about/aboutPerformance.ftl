# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Amsefrak n twuri

## Column headers

column-name = Isem
column-type = Tawsit
column-energy-impact = Gellu n tezmert
column-memory = Takatut

## Special values for the Name column

ghost-windows = Iccaren imedlen melmi kan
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Seld usali: { $title }

## Values for the Type column

type-tab = Iccer
type-subframe = Akatar n ddaw
type-tracker = Aneḍfar
type-addon = Azegrir
type-browser = Iminig
type-worker = Anmahal
type-other = Wiyaḍ

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Afellay { $value }
energy-impact-medium = Alemmas { $value }
energy-impact-low = Adday { $value }

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KAṬ
size-MB = { $value } MAṬ
size-GB = { $value } GAṬ

## Tooltips for the action buttons

close-tab =
    .title = Mdel Iccer
show-addon =
    .title = Sken-d deg umsefrak n izegrar

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Aneqqis seg usali: { $totalDispatches } ({ $totalDuration } ms)
        Ineqqisen imiranen n tasinin tineggura: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
