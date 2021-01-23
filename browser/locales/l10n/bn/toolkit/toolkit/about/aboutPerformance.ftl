# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = কাজ ব্যবস্থাপক

## Column headers

column-name = নাম
column-type = ধরন
column-energy-impact = শক্তির প্রভাব
column-memory = মেমরি

## Special values for the Name column

ghost-windows = সম্প্রতি বন্ধ করা ট্যাব
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = প্রাকলোড: { $title }

## Values for the Type column

type-tab = ট্যাব
type-subframe = সাবফ্রেম
type-tracker = ট্র্যাকার
type-addon = অ্যাড-অন
type-browser = ব্রাউজার
type-worker = কর্মী
type-other = অন্যান্য

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = উচ্চ ({ $value })
energy-impact-medium = মধ্যম ({ $value })
energy-impact-low = নিম্ন ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = ট্যাব বন্ধ করুন
show-addon =
    .title = অ্যাড-অন ম্যানেজারে দেখাও

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        লোড থেকে ডিসপ্যাচ: { $totalDispatches } ({ $totalDuration }ms)
        শেষ সেকেন্ডে ডিসপ্যাচ: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
