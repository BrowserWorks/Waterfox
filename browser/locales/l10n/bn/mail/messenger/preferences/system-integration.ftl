# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = সিস্টেম ইন্টিগ্রেশন

default-client-intro = যার জন্য ডিফল্ট ক্লায়েন্ট হিসেবে { -brand-short-name } ব্যবহার করা হবে:

checkbox-email-label =
    .label = ইমেইল
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = নিউজগ্রুপ
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = ফিড
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] কেন্দ্রবিন্দু
        [windows] উইন্ডোজ অনুসন্ধান
       *[other] { "" }
    }

system-search-integration-label =
    .label = বার্তা খুঁজতে { system-search-engine-name } কে অনুমোদন দেয়া হবে (s)
    .accesskey = s

check-on-startup-label =
    .label = { -brand-short-name } শুরু করার সময় প্রতিবার এই পরীক্ষা করা হবে (A)
    .accesskey = A
