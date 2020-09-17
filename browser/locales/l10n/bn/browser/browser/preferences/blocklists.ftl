# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = ব্লক তালিকা
    .style = width: 55em

blocklist-description = সেই তালিকা নির্বাচন করুন যা { -brand-short-name } অনলাইন ট্র্যাকার ব্লক করতে ব্যবহার করবে। তালিকা সরবরাহ করেছে <a data-l10n-name="disconnect-link" title="Disconnect">বিচ্ছন্ন</a>।
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = তালিকা

blocklist-button-cancel =
    .label = বাতিল
    .accesskey = C

blocklist-button-ok =
    .label = পরিবর্তন সংরক্ষণ করুন
    .accesskey = S

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = স্তর ১ বাঁধা তালিকা (প্রস্তাবিত)।
blocklist-item-moz-std-description = কিছু ট্র্যাকার অনুমতি দেয় যেন ওয়েবসাইট কম বিগড়ায়।
blocklist-item-moz-full-listName = লেভেল 2 ব্লক লিস্ট।
blocklist-item-moz-full-description = সকল সনাক্তকৃত ট্র্যাকার কে ব্লক করে। কিছু ওয়েব সাইট অথবা কন্টেন্ট সঠিকভাবে লোড নাও হতে পারে।
