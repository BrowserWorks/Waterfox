# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = একটি ব্যক্তিগত উইন্ডো খুলুন
    .accesskey = P
about-private-browsing-search-placeholder = ওয়েবে অনুসন্ধান করুন
about-private-browsing-info-title = আপনি একটি ব্যাক্তিগত উইন্ডোতে আছেন
about-private-browsing-info-myths = ব্যাক্তিগত ব্রাউজিং সম্পর্কে কিছু ভুল ধারণা
about-private-browsing =
    .title = ওয়েবে অনুসন্ধান করুন
about-private-browsing-not-private = আপনি বর্তমানে কোনো ব্যক্তিগত উইন্ডোতে নেই।
about-private-browsing-info-description = আপনি যখন অ্যাপ বা সকল ব্যক্তিগত ব্রাউজিং ট্যাব ও উইন্ডোজ বন্ধ করবেন তখন { -brand-short-name } আপনার অনুসন্ধান ও ব্রাউজিং ইতিহাস মুছে ফেলবে। যদিও এতে ওয়েবসাইট ও আপনার ইন্টারনেট সেবাদানকারী আপনাকে অজ্ঞাতনামা করে না, এটি এই কম্পিউটারে অন্য ব্যবহারকারীর কাছ থেকে আপনার অনলাইন কর্মকান্ড গোপন রাখতে সহজ করে।

# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } আপনার ব্যক্তিগত উইন্ডো-র ডিফল্ট সার্চ ইঞ্জিন
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] ভিন্ন একটি সার্চ ইঞ্জিন নির্বাচন করার জন্য <a data-l10n-name="link-options">অপশন</a> পাতায় যান
       *[other] ভিন্ন একটি সার্চ ইঞ্জিন নির্বাচন করার জন্য <a data-l10n-name="link-options">পছন্দসমূহ</a> পাতায় যান
    }
about-private-browsing-search-banner-close-button =
    .aria-label = বন্ধ
