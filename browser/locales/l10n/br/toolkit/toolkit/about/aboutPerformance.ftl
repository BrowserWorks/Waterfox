# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Ardoer trevelloù

## Column headers

column-name = Anv
column-type = Rizh
column-energy-impact = Skog gremm
column-memory = Memor

## Special values for the Name column

ghost-windows = Ivinelloù serret nevez zo
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Ragkarget: { $title }

## Values for the Type column

type-tab = Ivinell
type-subframe = Is-steuñv
type-tracker = Heulier
type-addon = Askouezh
type-browser = Merdeer
type-worker = Labourer
type-other = All

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Uhel ({ $value })
energy-impact-medium = Etre ({ $value })
energy-impact-low = Izel ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } Ke
size-MB = { $value } Me
size-GB = { $value } Ge

## Tooltips for the action buttons

close-tab =
    .title = Serriñ an ivinell
show-addon =
    .title = Diskouez en ardoer askouezhioù

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Danevelloù abaoe ar c'hargadenn: { $totalDispatches } ({ $totalDuration } me)
        Danevelloù en eilennoù diwezhañ: { $dispatchesSincePrevious } ({ $durationSincePrevious }me)
