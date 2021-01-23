# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { $count } ট্র্যাকার গত সপ্তাহে { -brand-short-name } ব্লক করেছে
       *[other] { $count } ট্র্যাকার গত সপ্তাহে { -brand-short-name } ব্লক করেছে
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } থেকে <b>{ $count }</b> ট্র্যাকার ব্লক করা হয়েছে
       *[other] { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } থেকে <b>{ $count }</b> ট্র্যাকার ব্লক করা হয়েছে
    }

protection-report-etp-card-content-custom-not-blocking = সকল সুরক্ষা বর্তমানে বন্ধ আছে। কোন ট্র্যাকারকে ব্লক করবেন তা নির্বাচন করতে { -brand-short-name } সুরক্ষা সেটিংস থেকে পরিচালনা করুন।
protection-report-manage-protections = সেটিং পরিচালনা

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = আজ

# This string is used to describe the graph for screenreader users.
graph-legend-description = এই সপ্তাহে ব্লক করা প্রত্যেক ধরনের ট্র্যাকারের মোট সংখ্যা ধারণকারী একটি গ্রাফ।

social-tab-title = সোশ্যাল মিডিয়া ট্র্যাকার
social-tab-contant = আপনি যা করেন, যা দেখেন এবং যা অনলাইনে দেখেন তা জানার জন্য সোশ্যাল নেটওয়ার্কগুলি অন্যান্য ওয়েবসাইটে ট্র্যাকার রাখে। এই সোশ্যাল মিডিয়া কোম্পানীগুলি আপনার সামাজিক মিডিয়া প্রোফাইলে আপনি যা শেয়ার করেন তার বাইরেও আপনার সম্পর্কে জানতে দেয়। <a data-l10n-name="learn-more-link"> আরও জানুন </a>

cookie-tab-title = ক্রস-সাইট ট্র্যাকিং কুকিজ
cookie-tab-content = এই কুকিগুলি আপনি অনলাইনে কি করেন সে সম্পর্কে ডাটা সংগ্রহের জন্য সাইট থেকে সাইটে আপনাকে অনুসরণ করে। তারা বিজ্ঞাপনদাতাদের এবং বিশ্লেষণ সংস্থাগুলির মত তৃতীয় পক্ষ দ্বারা সেট করা থাকে। ক্রস-সাইট ট্র্যাকিং কুকিগুলি ব্লক করে আপনার আশেপাশের অনুসরণকারী বিজ্ঞাপনের সংখ্যা হ্রাস করে। <a data-l10n-name="learn-more-link">আরও জানুন</a>

tracker-tab-title = ট্র্যাকিং কন্টেন্ট
tracker-tab-description = ওয়েবসাইট হয়তো ট্র্যাকিং কোডসহ বাহ্যিক বিজ্ঞাপন, ভিডিও এবং অন্যান্য কন্টেন্ট লোড করতে পারে। ট্র্যাকিং কন্টেন্ট ব্লক করা সাইটকে দ্রুত লোড করতে সহায়তা করে তবে কিছু বোতাম, ফর্ম এবং লগইন ক্ষেত্র কাজ নাও করতে পারে। <a data-l10n-name="learn-more-link"> আরও জানুন </a>

fingerprinter-tab-title = ফিঙ্গারপ্রিন্টারস
fingerprinter-tab-content = আপনার প্রোফাইল তৈরি করতে ফিঙ্গারপিন্টার আপনার ব্রাউজার এবং কম্পিউটার থেকে সেটিংস সংগ্রহ করে। এই ডিজিটাল ফিঙ্গারপ্রিন্ট ব্যবহার করে, তারা বিভিন্ন ওয়েবসাইট জুড়ে আপনাকে ট্র্যাক করতে পারে। <a data-l10n-name="learn-more-link">আরও জানুন</a>

cryptominer-tab-title = ক্রিপ্টোমাইনার
cryptominer-tab-content = ক্রিপ্টোমাইনাররা গোপনে আপনার সিস্টেমের কম্পিউটিং শক্তি ডিজিটাল অর্থ মাইনিং এ ব্যবহার করে। ক্রিপ্টোমাইনিং স্ক্রিপ্টগুলি আপনার ব্যাটারি নিষ্কাশন করে, আপনার কম্পিউটারকে ধীর করে দেয় এবং আপনার বিদ্যুৎ বিল বাড়িয়ে দিতে পারে।<a data-l10n-name="learn-more-link">আরও জানুন</a>
  
lockwise-title = আবার কখনো পাসওয়ার্ড ভুলে যাবেন না
lockwise-header-content = { -lockwise-brand-name } নিরাপদভাবে ব্রাউজারে আপনার পাসওয়ার্ড সংরক্ষণ করে।
lockwise-header-content-logged-in = নিরাপদভাবে আপনার সকল ডিভাইসে আপনার পাসওয়ার্ড সংরক্ষণ করুন এবং সিঙ্ক করুন।

turn-on-sync = { -sync-brand-short-name } চালু করুন...
    .title = সিঙ্ক পছন্দগুলোতে যান

monitor-title = ডাটা ফাটল সন্ধান করুন
monitor-link = কিভাবে এটি কাজ করে
monitor-header-content-no-account = যাচাই করে দেখুন { -monitor-brand-name } জানা ডাটা লঙ্ঘনের অংশ হয়েছে কিনা এবং নতুন লঙ্ঘন সম্পর্কে সঙ্কেত পান।
monitor-header-content-signed-in = আপনার তথ্য যদি কোনও জানা ডাটা লঙ্ঘনে দেখা যায় তবে { -monitor-brand-name } আপনাকে সতর্ক করে।
auto-scan = আজ স্বয়ংক্রিয়ভাবে স্ক্যান করা হয়েছে

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] ইমেইল ঠিকানা পর্যবেক্ষণ করা হচ্ছে।
       *[other] ইমেইল ঠিকানাগুলো পর্যবেক্ষণ করা হচ্ছে।
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] জ্ঞাত ডাটা লঙ্ঘন আপনার তথ্য প্রকাশ করেছে
       *[other] জ্ঞাত ডাটা লঙ্ঘনগুলি আপনার তথ্য প্রকাশ করেছে
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] সমস্ত লঙ্ঘনে পাসওয়ার্ড উন্মুক্ত
       *[other] সমস্ত লঙ্ঘনে পাসওয়ার্ড উন্মুক্ত
    }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = সোশ্যাল মিডিয়া ট্র্যাকার
    .aria-label =
        { $count ->
            [one] { $count } সোশ্যাল মিডিয়া ট্র্যাকার ({ $percentage }%)
           *[other] { $count } সোশ্যাল মিডিয়া ট্র্যাকারগুলো ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = ক্রস-সাইট ট্র্যাকিং কুকিজ
    .aria-label =
        { $count ->
            [one] { $count } ক্রস-সাইট ট্র্যাকিং কুকি ({ $percentage }%)
           *[other] { $count } ক্রস-সাইট ট্র্যাকিং কুকিজ ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = ট্র্যাকিং কন্টেন্ট
    .aria-label =
        { $count ->
            [one] { $count } ট্র্যাকিং কন্টেন্ট ({ $percentage }%)
           *[other] { $count } ট্র্যাকিং কন্টেন্ট ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = ফিঙ্গারপ্রিন্টার
    .aria-label =
        { $count ->
            [one] { $count } ফিঙ্গারপ্রিন্টার ({ $percentage }%)
           *[other] { $count } ফিঙ্গারপ্রিন্টার ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = ক্রিপ্টোমাইনার
    .aria-label =
        { $count ->
            [one] { $count } ক্রিপ্টোমাইনার ({ $percentage }%)
           *[other] { $count } ক্রিপ্টোমাইনার ({ $percentage }%)
        }
