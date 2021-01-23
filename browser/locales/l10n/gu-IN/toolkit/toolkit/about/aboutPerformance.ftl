# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = કાર્ય વ્યવસ્થાપક

## Column headers

column-name = નામ
column-type = પ્રકાર
column-energy-impact = ઊર્જા અસર
column-memory = મેમરી

## Special values for the Name column

ghost-windows = છેલ્લે બધ થયેલ ટૅબ્સ
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = પહેલેથી લોડ કરેલું: { $title }

## Values for the Type column

type-tab = ટૅબ
type-subframe = સબફ્રેમ
type-tracker = ટ્રેકર
type-addon = ઍડ-ઓન
type-browser = બ્રાઉઝર
type-worker = કાર્યકર
type-other = અન્ય

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = ઉચ્ચ ({ $value })
energy-impact-medium = મધ્યમ ({ $value })
energy-impact-low = નિમ્ન ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = ટૅબ બંધ કરો
show-addon =
    .title = ઍડ-ઑન્સ મેનેજરમાં બતાવો

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        લોડ પછી મોકલે છે: { $totalDispatches } ({ $totalDuration }ms) 
        છેલ્લા સેકન્ડમાં મોકલે છે: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
