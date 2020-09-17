# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = ਟਾਸਕ ਮੈਨੇਜਰ

## Column headers

column-name = ਨਾਂ
column-type = ਕਿਸਮ
column-energy-impact = ਊਰਜਾ ਅਸਰ
column-memory = ਮੈਮੋਰੀ

## Special values for the Name column

ghost-windows = ਤਾਜ਼ਾ ਬੰਦ ਕੀਤੀਆਂ ਟੈਬਾਂ
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = ਪਹਿਲਾਂ ਲੋਡ ਕੀਤੇ: { $title }

## Values for the Type column

type-tab = ਟੈਬ
type-subframe = ਸਬ-ਫਰੇਮ
type-tracker = ਟਰੈਕਰ
type-addon = ਐਡ-ਆਨ
type-browser = ਬਰਾਊਜ਼ਰ
type-worker = ਵਰਕਰ
type-other = ਹੋਰ

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = ਉੱਚ ({ $value })
energy-impact-medium = ਮੱਧਮ ({ $value })
energy-impact-low = ਘੱਟ ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = ਟੈਬ ਬੰਦ ਕਰੋ
show-addon =
    .title = ਐਡ-ਆਨ ਮੈਨੇਜਰ ਵਿੱਚ ਵੇਖੋ

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        ਲੋਡ ਕਰਨ ਤੋਂ ਬਾਅਦ ਘੱਲੇ: { $totalDispatches } ({ $totalDuration }ms)
        ਆਖਰੀ ਸਕਿੰਟਾਂ ਵਿੱਚ ਘੱਲੇ: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
