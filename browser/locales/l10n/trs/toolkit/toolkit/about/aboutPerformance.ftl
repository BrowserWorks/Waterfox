# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Sa nikaj ñu'unj nej Suun

## Column headers

column-name = Si yugui
column-type = Dugui'
column-energy-impact = Daj arâj sunj ña'aan
column-memory = Memôria

## Special values for the Name column

ghost-windows = Rakïj ñanj hiaj narán nakà
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Nga gisij nachra: { $title }

## Values for the Type column

type-tab = Rakïj ñaj
type-subframe = chrún lij
type-tracker = Sa naga'naj
type-addon = Sa ga'ue nutò'
type-browser = Natsij ni'iajt
type-worker = Sa ri suun
type-other = A'ngoj

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Xàn' ({ $value })
energy-impact-medium = Da'aj ({ $value })
energy-impact-low = Nikà' ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Narán rakïj ñanj
show-addon =
    .title = Ni¿iaj riña si administrado nej extensiûn

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title = Gachra asîj riña karga: { $totalDispatches } ({ $totalDuration }ms) Sa nachra hisj akuan' nïn: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
