# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = প্রোফাইল পরিচিতি
profiles-subtitle = এই পাতা আপনাকে আপনার প্রোফাইল পরিচালনা করতে সাহায্য করবে। প্রতিটি প্রোফাইলের একটি পৃথক জগৎ রয়েছে সেখানে ইতিহাস, বুকমার্ক, সেটিং, অ্যাড-অন রয়েছে।
profiles-create = একটি নতুন প্রোফাইল তৈরি করুন
profiles-restart-title = পুনরারম্ভ
profiles-restart-in-safe-mode = অ্যাড-অন নিষ্ক্রিয় করে পুনরারম্ভ করুন…
profiles-restart-normal = স্বাভাবিকভাবে রিস্টার্ট করুন…
profiles-conflict = { -brand-product-name } এর আরেকটি অনুলিপি আপনার প্রোফাইলে পরিবর্তন এনেছে। আরও পরিবর্তন করার পূর্বে অবশ্যই { -brand-short-name } রিস্টার্ট করুন।
profiles-flush-fail-title = পরিবর্তনগুলো সংরক্ষণ করা হয়নি
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = একটি অপ্রত্যাশিত ত্রুটি আপনার পরিবর্তনগুলি সংরক্ষণ করা থেকে নিবারণ করেছে।
profiles-flush-restart-button = পুনরায় শুরু করুন { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = প্রোফাইল: { $name }
profiles-is-default = ডিফল্ট প্রোফাইল
profiles-rootdir = রুট ডিরেক্টরি

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = স্থানীয় ডিরেক্টরি
profiles-current-profile = এই প্রোফাইলটি ব্যবহার করা হচ্ছে এবং এটি মুছে ফেলা যাবে না।
profiles-in-use-profile = এই প্রোফাইল অন্য অ্যাপলিকেশনে ব্যবহৃত হচ্ছে তাই মুছে দেওয়া যাবে না।

profiles-rename = পুনঃনামকরণ
profiles-remove = অপসারণ
profiles-set-as-default = ডিফল্ট প্রোফাইল হিসেবে নির্ধারণ করুন
profiles-launch-profile = নতুন ব্রাউজারে প্রোফাইল চালু করুন।

profiles-cannot-set-as-default-title = ডিফল্ট সেট করতে অক্ষম
profiles-cannot-set-as-default-message = ডিফল্ট প্রোফাইলটি { -brand-short-name } এর জন্য পরিবর্তন করা যাবে না

profiles-yes = হ্যাঁ
profiles-no = না

profiles-rename-profile-title = প্রোফাইলের নাম পরিবর্তন
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = { $name } প্রোফাইলের নাম পরিবর্তন

profiles-invalid-profile-name-title = অকার্যকর প্রোফাইলের নাম
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = প্রোফাইলের নাম হিসাবে "{ $name }" ব্যবহার করা যাবে না।

profiles-delete-profile-title = প্রোফাইল মুছে ফেলুন
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    কোনো প্রোফাইল মুছে ফেলা হলে তা উপলব্ধ প্রোফাইলের তালিকা থেকে অপসারিত হবে এবং পুনরুদ্ধার করা সম্ভব হবে না।
    আপনি প্রোফাইল ডাটা ফাইল অর্থাৎ সংরক্ষিত বৈশিষ্ট্য, সার্টিফিকেট প্রভৃতি মুছে ফেলতে পারেন। এই বিকল্পের দ্বারা "{ $dir }" ফোল্ডারটি মুছে ফেলা হবে এবং তা পুনরুদ্ধার করা সম্ভব হবে না।
    আপনি কি প্রোফাইল ডাটা ফাইল মুছে ফেলতে ইচ্ছুক?
profiles-delete-files = ফাইল অপসারণ
profiles-dont-delete-files = ফাইল মুছে ফেলা হবে না

profiles-delete-profile-failed-title = ত্রুটি
profiles-delete-profile-failed-message = এই প্রোফাইল মুছে ফেলার সময় সমস্যা হয়েছে।


profiles-opendir =
    { PLATFORM() ->
        [macos] ফাইন্ডারে প্রদর্শন করুন
        [windows] ফোল্ডার খুলুন
       *[other] ডিরেক্টরি খুলুন
    }
