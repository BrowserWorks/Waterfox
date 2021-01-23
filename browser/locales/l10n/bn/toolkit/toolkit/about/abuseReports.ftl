# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = { $addon-name } এর জন্য প্রতিবেদন

abuse-report-title-extension = { -vendor-short-name } এর নিকট এই এক্সটেনশনটি রিপোর্ট করুন
abuse-report-title-theme = { -vendor-short-name } এর নিকট এই থিম টি রিপোর্ট করুন
abuse-report-subtitle = বিষয়টি টি কি?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = <a data-l10n-name="author-name">{ $author-name }</a> দ্বারা

abuse-report-learnmore =
    নিশ্চিত নন কোন সমস্যাটি নির্বাচন করবেন?
    <a data-l10n-name="learnmore-link">এক্সটেনশন এবং থিম রিপোর্ট করার বিষয়ে আরও জানুন</a>

abuse-report-submit-description = সমস্যাটি বর্ণনা করুন (ঐচ্ছিক)
abuse-report-textarea =
    .placeholder = কোন সমস্যার বিস্তারিত বিবরণ জানা থাকলে সেইটি সমাধান করা আমাদের জন্যে সহজ হয়। আপনি কিসের সম্মুখিন হচ্ছেন দয়া করে সেটি বর্ণনা করুন। ওয়েবকে সুস্থ রাখতে আমাদের সহায়তা করার জন্য আপনাকে ধন্যবাদ।
abuse-report-submit-note =
    নোট: ব্যক্তিগত তথ্য (যেমন নাম, ইমেল ঠিকানা, ফোন নম্বর, বাসস্থানের ঠিকানা) অন্তর্ভুক্ত করবেন না।
    { -vendor-short-name } এই রিপোর্টগুলির স্থায়ী রেকর্ড রাখে।

## Panel buttons.

abuse-report-cancel-button = বাতিল
abuse-report-next-button = পরবর্তী
abuse-report-goback-button = ফিরে যান
abuse-report-submit-button = জমা দিন

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = <span data-l10n-name="addon-name">{ $addon-name }</span>এর জন্য রিপোর্ট বাতিল করা হয়েছে।
abuse-report-messagebar-submitting = <span data-l10n-name="addon-name">{ $addon-name }</span>এর জন্য রিপোর্ট পাঠানো হচ্ছে।
abuse-report-messagebar-submitted = রিপোর্ট জমা দেওয়ার জন্য আপনাকে ধন্যবাদ। আপনি কি <span data-l10n-name="addon-name">{ $addon-name }</span> অপসারণ করতে চান?
abuse-report-messagebar-submitted-noremove = একটি প্রতিবেদন জমা দেওয়ার জন্য আপনাকে ধন্যবাদ।
abuse-report-messagebar-removed-extension = রিপোর্ট জমা দেওয়ার জন্য আপনাকে ধন্যবাদ। আপনি <span data-l10n-name="addon-name">{ $addon-name }</span> এক্সটেনশনটি অপসারণ করেছেন।
abuse-report-messagebar-removed-theme = রিপোর্ট জমা দেওয়ার জন্য আপনাকে ধন্যবাদ। আপনি <span data-l10n-name="addon-name">{ $addon-name }</span> থিমটি অপসারণ করেছেন।
abuse-report-messagebar-error = <span data-l10n-name="addon-name">{ $addon-name }</span> এর রিপোর্ট জমা দেওয়ার সময় এখানে সমস্যা ছিল।
abuse-report-messagebar-error-recent-submit = <span data-l10n-name="addon-name">{ $addon-name }</span> এর রিপোর্ট পাঠানো হয়নি কারণ সম্প্রতি অন্য একটি রিপোর্ট পাঠানো হয়েছে।

## Message bars actions.

abuse-report-messagebar-action-remove-extension = হ্যাঁ, এটি অপসারণ করুন
abuse-report-messagebar-action-keep-extension = না, আমি এটি রাখব
abuse-report-messagebar-action-remove-theme = হ্যাঁ, এটি সরান
abuse-report-messagebar-action-keep-theme = না, আমি এটি রাখব
abuse-report-messagebar-action-retry = পুনরায় চেষ্টা করুন
abuse-report-messagebar-action-cancel = বাতিল ক্রুন

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = এটি আমার কম্পিউটারের ক্ষতি করেছে বা আমার ডাটা চুরি করেছে
abuse-report-damage-example = উদাহরণ: ম্যালওয়্যার ইনজেক্ট করা বা ডাটা চুরি করা

abuse-report-spam-reason-v2 = এটিতে স্প্যাম বা অযাচিত বিজ্ঞাপন রয়েছে
abuse-report-spam-example = উদাহরণ: ওয়েবপেজে বিজ্ঞাপন স্থাপন

abuse-report-settings-reason-v2 = এটি আমাকে না জানিয়ে বা জিজ্ঞাসা না করে আমার অনসন্ধান ইঞ্জিন, হোমপেজ বা নতুন ট্যাব পরিবর্তন করেছে
abuse-report-settings-suggestions = এক্সটেনশান সম্পর্কে রিপোর্ট জমার আগে, আপনার সেটিংস পরিবর্তনের চেষ্টা করতে পারেন:
abuse-report-settings-suggestions-search = আপনার ডিফল্ট অনুসন্ধান সেটিংস পরিবর্তন করুন
abuse-report-settings-suggestions-homepage = আপনার হোমপেজ এবং নতুন ট্যাব পরিবর্তন করুন

abuse-report-deceptive-reason-v2 = এমন কিছু হওয়ার দাবি করে যা নয়
abuse-report-deceptive-example = উদাহরণ: বিভ্রান্তিকর বর্ণনা বা চিত্রাবলী

abuse-report-broken-reason-extension-v2 = এটি কাজ করে না, ওয়েবসাইটগুলি ভেঙে দেয় অথবা { -brand-product-name } ধীরগতির করে
abuse-report-broken-reason-theme-v2 = এটি কাজ করে না বা ব্রাউজার ডিসপ্লে নষ্ট করে
abuse-report-broken-example = উদাহরণ: বৈশিষ্ট্যগুলি ধীরগতি সম্পন্ন, ব্যবহার করা কঠিন, বা কাজ করে না; ওয়েবসাইটের অংশগুলি লোড করবে না বা অস্বাভাবিক দেখাবে
abuse-report-broken-suggestions-extension =
    দেখে মনে হচ্ছে আপনি কোনও বাগ চিহ্নিত করেছেন। এখানে রিপোর্ট জমা দেওয়ার পাশাপাশি সেরা উপায়
    হল কার্যকারিতা সমস্যার সমাধান করা জন্য এক্সটেনশন ডেভেলপারের সাথে যোগাযোগ করা।
    ডেভেলপারের তথ্য পেতে<a data-l10n-name="support-link">এক্সটেনশনের ওয়েবসাইট দেখুন</a>।
abuse-report-broken-suggestions-theme =
    দেখে মনে হচ্ছে আপনি কোনও বাগ চিহ্নিত করেছেন। এখানে রিপোর্ট জমা দেওয়ার পাশাপাশি সেরা উপায়
    হল কার্যকারিতা সমস্যার সমাধান করা জন্য এক্সটেনশন ডেভেলপারের সাথে যোগাযোগ করা।
    ডেভেলপারের তথ্য পেতে<a data-l10n-name="support-link">এক্সটেনশনের ওয়েবসাইটটি দেখুন</a>।

abuse-report-policy-reason-v2 = এটিতে ঘৃণ্য, হিংস্র বা অবৈধ কনটেন্ট রয়েছে
abuse-report-policy-suggestions =
    দ্রষ্টব্য: কপিরাইট এবং ট্রেডমার্ক সমস্যাগুলি অবশ্যই একটি আলাদা প্রক্রিয়াতে রিপোর্ট করা উচিত।
    <a data-l10n-name="report-infringement-link"> এই নির্দেশাবলী ব্যবহার করুন </a>
    সমস্যা রিপোর্ট করতে।

abuse-report-unwanted-reason-v2 = আমি কখনই এটি চাইনি এবং এটি থেকে কীভাবে মুক্তি পাবো তা আমি জানি না
abuse-report-unwanted-example = উদাহরণ: একটি অ্যাপ্লিকেশন আমার অনুমতি ব্যতীত ইনস্টল হয়েছে

abuse-report-other-reason = অন্য কিছু

