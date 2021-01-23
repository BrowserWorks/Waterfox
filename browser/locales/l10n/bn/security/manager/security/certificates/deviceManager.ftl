# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = ডিভাইস ব্যবস্থাপক
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = নিরাপত্তা মডিউল ও ডিভাইস

devmgr-header-details =
    .label = বিবরণ

devmgr-header-value =
    .label = মান

devmgr-button-login =
    .label = লগইন (n)
    .accesskey = n

devmgr-button-logout =
    .label = লগআউট (O)
    .accesskey = O

devmgr-button-changepw =
    .label = পাসওয়ার্ড পরিবর্তন করুন (P)
    .accesskey = P

devmgr-button-load =
    .label = লোড (L)
    .accesskey = L

devmgr-button-unload =
    .label = আনলোড (U)
    .accesskey = U

devmgr-button-enable-fips =
    .label = FIPS সক্রিয় করা হবে
    .accesskey = F

devmgr-button-disable-fips =
    .label = FIPS নিষ্ক্রিয় করা হবে
    .accesskey = F

## Strings used for load device

load-device =
    .title = PKCS#11 ডিভাইস ড্রাইভার লোড করুন

load-device-info = আপনি যে মডিউলটি যোগ করতে ইচ্ছুক সেটি সম্পর্কে তথ্য দিন।

load-device-modname =
    .value = মডিউলের নাম
    .accesskey = M

load-device-modname-default =
    .value = নতুন PKCS#11 মডিউল

load-device-filename =
    .value = মডিউল ফাইলের নাম
    .accesskey = f

load-device-browse =
    .label = ব্রাউজ...
    .accesskey = B

## Token Manager

devinfo-status =
    .label = অবস্থা

devinfo-status-disabled =
    .label = নিষ্ক্রিয়

devinfo-status-not-present =
    .label = উপস্থিত নেই

devinfo-status-uninitialized =
    .label = প্রারম্ভ করা হয়নি

devinfo-status-not-logged-in =
    .label = লগইন করা হয়নি

devinfo-status-logged-in =
    .label = লগইন করা হয়েছে

devinfo-status-ready =
    .label = প্রস্তুত

devinfo-desc =
    .label = বিবরণ

devinfo-man-id =
    .label = প্রস্তুতকারক

devinfo-hwversion =
    .label = HW সংস্করণ
devinfo-fwversion =
    .label = FW সংস্করণ

devinfo-modname =
    .label = মডিউল

devinfo-modpath =
    .label = পাথ

login-failed = লগইন করতে ব্যর্থ

devinfo-label =
    .label = লেবেল

devinfo-serialnum =
    .label = ক্রমিক সংখ্যা

fips-nonempty-password-required = FIPS মোডের ক্ষেত্রে প্রতিটি নিরাপত্তা ডিভাইসের জন্য একটি মাস্টার পাসওয়ার্ড নির্ধারণ করা আবশ্যক। FIPS মোড সক্রিয় করার পূর্বে অনুগ্রহ করে পাসওয়ার্ড নির্ধারণ করুন।

unable-to-toggle-fips = নিরাপত্তা যন্ত্রের FIPS মোড পরিবর্তন করা সম্ভব হয় নাই। আপনাকে এপ্লিকেশন টি বন্ধ করে পুনরায় চালু করতে সুপারিশ করা হচ্ছে।
load-pk11-module-file-picker-title = লোড করার জন্য PKCS #11 ডিভাইস ড্রাইভার নির্বাচন করুন

# Load Module Dialog
load-module-help-empty-module-name =
    .value = মডিউল নাম খালি থাকতে পারে না।

add-module-failure = মডিউল যোগ করতে ব্যর্থ
del-module-warning = আপনি কি নিশ্চিতভাবে এই নিরাপত্তা মডিউলটি মুছে ফেলতে ইচ্ছুক?
del-module-error = মডিউল মুছে ফেলতে ব্যর্থ
