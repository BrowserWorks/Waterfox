# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = ইতিহাস অপসারণের সেটিং
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = সাম্প্রতিক ইতিহাস অপসারণ
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = সব ইতিহাস অপসারণ
    .style = width: 34em

clear-data-settings-label = যখন বন্ধ করা হয়, { -brand-short-name } স্বয়ংক্রিয়ভাবে সব পরিষ্কার করে ফেলে

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = ইতিহাস অপসারণের সময়ের পরিসর:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = গত ১ ঘন্টা

clear-time-duration-value-last-2-hours =
    .label = গত ২ ঘন্টা

clear-time-duration-value-last-4-hours =
    .label = গত ৪ ঘন্টা

clear-time-duration-value-today =
    .label = আজ সারাদিন

clear-time-duration-value-everything =
    .label = সব

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = ইতিহাস

item-history-and-downloads =
    .label = ব্রাউজিং B এবং ডাউনলোড ইতিহাস
    .accesskey = B

item-cookies =
    .label = কুকি (C)
    .accesskey = C

item-active-logins =
    .label = সক্রিয় লগইন (L)
    .accesskey = L

item-cache =
    .label = ক্যাশ (a)
    .accesskey = a

item-form-search-history =
    .label = ফর্ম ও অনুসন্ধানের ইতিহাস F
    .accesskey = F

data-section-label = তথ্য

item-site-preferences =
    .label = সাইট সংক্রান্ত পছন্দসমূহ (S)
    .accesskey = S

item-offline-apps =
    .label = অফলাইন ওয়েবসাইটের তথ্য (O)
    .accesskey = O

sanitize-everything-undo-warning = এই পরিবর্তনটি অপরিবর্তনীয়!

window-close =
    .key = w

sanitize-button-ok =
    .label = এখনি মুছে ফেলা হবে

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = পরিষ্কার করা হচ্ছে

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = সব ইতিহাস মুছে ফেলা হয়েছে।

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = নির্বাচিত আইটেম মুছে ফেলা হবে।
