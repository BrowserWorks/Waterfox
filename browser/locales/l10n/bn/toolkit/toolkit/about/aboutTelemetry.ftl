# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = পিং তথ্যের উৎস:
about-telemetry-show-current-data = বর্তমান তথ্য
about-telemetry-show-archived-ping-data = আর্কাইভ পিং তথ্য
about-telemetry-show-subsession-data = সাবসেশনের তথ্য দেখান
about-telemetry-choose-ping = পিং নির্বাচন করুন:
about-telemetry-archive-ping-type = পিং টাইপ
about-telemetry-archive-ping-header = পিং
about-telemetry-option-group-today = আজ
about-telemetry-option-group-yesterday = গতকাল
about-telemetry-option-group-older = পুরানো
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = টেলিমেট্রি ডাটা
about-telemetry-more-information = আরও তথ্যে খুঁজছেন?
about-telemetry-show-in-Firefox-json-viewer = JSON ভিউয়ারে খুলুন
about-telemetry-home-section = নীড়
about-telemetry-general-data-section = সাধারণ তথ্য
about-telemetry-environment-data-section = পরিবেশ ডেটা
about-telemetry-session-info-section = সিস্টেম সংক্রান্ত তথ্য
about-telemetry-scalar-section = স্ক্যালারস
about-telemetry-keyed-scalar-section = কীড স্কেলারস
about-telemetry-histograms-section = বারলেখ
about-telemetry-keyed-histogram-section = উদ্দীপিত হিস্টোগ্রামসমূহ
about-telemetry-events-section = ইভেন্ট
about-telemetry-simple-measurements-section = সহজ পরিমাপ
about-telemetry-slow-sql-section = ধীর গতির এসকিউএল বিবৃতি
about-telemetry-addon-details-section = অ্যাড-অনের বিস্তারিত
about-telemetry-captured-stacks-section = বন্দী স্ট্যাক
about-telemetry-late-writes-section = বিলম্বিত লেখনী
about-telemetry-raw-payload-section = অপরিশোধিত পেলোড
about-telemetry-raw = পরিশোধিত JSON
about-telemetry-full-sql-warning = নোট: ধীর গতির SQL ডিবাগিং সক্রিয় করা হয়েছে।সম্পূর্ণ SQL স্ট্রিং নীচে প্রদর্শিত হতে পারে কিন্তু তাদের টেলিমেট্রিতে উপস্থাপন করা হবে না।
about-telemetry-fetch-stack-symbols = স্ট্যাকের জন্য ফাংশনের নামসমূহ আনো
about-telemetry-hide-stack-symbols = অপরিশোধিত স্ট্যাক ডাটা দেখাও
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] রিলিজ ডাটা
       *[prerelease] প্রি-রিলিজ ডাটা
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] সক্রিয়
       *[disabled] নিষ্ক্রিয়
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = এই পাতাটি টেলিমেট্রি কতৃক সংগৃহীত কার্যকারিতা,ব্যবহার,স্বনির্বাচনসমূহের তথ্য প্রদর্শন করে। এই তথ্য { $telemetryServerOwner } এর নিকট { -brand-full-name } এর উন্নতিতে সাহায্যের জন্য উপস্থাপিত হয়েছে।
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = তথ্যের প্রতিটি অংশ “<a data-l10n-name="ping-link">পিংস</a>” এ বান্ডেল করে পাঠানো হয়েছে। আপনি { $name }, { $timestamp } এ পিং করে দেখছেন।
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle } এ খুঁজুন
about-telemetry-filter-all-placeholder =
    .placeholder = সব বিভাগে খুঁজুন
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = "{ $searchTerms }" এর ফলাফল
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = দুঃখিত! "{ $currentSearchText }" এর জন্য { $sectionName } এ কোন ফলাফল নেই
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = দুঃখিত! "{ $searchTerms }" এর জন্য কোনও বিভাগে কোন ফলাফল নেই
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = দুঃখিত! বর্তমানে "{ $sectionName }" এ কোন ডেটা উপলব্ধ নেই
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = সব
# button label to copy the histogram
about-telemetry-histogram-copy = অনুলিপি
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = ধীর গতির প্রধান থ্রেডে SQLস্টেটমেন্ট
about-telemetry-slow-sql-other = ধীর গতির সহায়ক থ্রেডে SQL স্টেটমেন্ট
about-telemetry-slow-sql-hits = আঘাত
about-telemetry-slow-sql-average = Avg. Time (ms)
about-telemetry-slow-sql-statement = স্টেটমেন্ট
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = অ্যাড-অন ID
about-telemetry-addon-table-details = বিস্তারিত
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } প্রোভাইডার
about-telemetry-keys-header = বৈশিষ্ট্য
about-telemetry-names-header = নাম
about-telemetry-values-header = মান
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (ক্যাপচার গনণা: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = #{ $lateWriteCount } দেরিতে লেখা
about-telemetry-stack-title = স্তূপ:
about-telemetry-memory-map-title = মেমরি ম্যাপ:
about-telemetry-error-fetching-symbols = যখন প্রতীক আনা হয় তখন একটি ত্রুটি হয়েছে।পরীক্ষা করুন যে আপনি ইন্টারনেটের সাথে যুক্ত এবং আবার চেষ্টা করুন।
about-telemetry-time-stamp-header = টাইমস্ট্যাম্প
about-telemetry-category-header = বিষয়শ্রেণী
about-telemetry-method-header = পদ্ধতি
about-telemetry-object-header = অবজেক্ট
about-telemetry-extra-header = অতিরিক্ত
