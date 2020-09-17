# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


pane-compose-title = মেইল রচনা
category-compose =
    .tooltiptext = মেইল রচনা

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name } প্রারম্ভিক পৃষ্ঠা

start-page-label =
    .label = { -brand-short-name } চালু করা হলে, বার্তা এলাকায় প্রারম্ভিক পৃষ্ঠাটি প্রদর্শিত হয় (W)
    .accesskey = W

location-label =
    .value = অবস্থান:
    .accesskey = o
restore-default-label =
    .label = ডিফল্ট পুনরায় সংরক্ষন (R)
    .accesskey = R

new-message-arrival = যখন নতুন বার্তা আসে:
mail-play-button =
    .label = চালানো হবে (P)
    .accesskey = P

animated-alert-label =
    .label = সতর্কবার্তা দেখানো হবে (S)
    .accesskey = S
customize-alert-label =
    .label = স্বনির্বাচন... (C)
    .accesskey = C

mail-custom-sound-label =
    .label = নিম্নে নির্ধারিত শব্দ ফাইল (U)
    .accesskey = U
mail-browse-sound-button =
    .label = ব্রাউজ... (B)
    .accesskey = B

enable-gloda-search-label =
    .label = সার্বজনীন অনুসন্ধান এবং ইনডেক্সার সক্রিয় করা হবে (I)
    .accesskey = I

system-integration-legend = সিস্টেম ইন্টিগ্রেশন
always-check-default =
    .label = আরম্ভের সময় সবসময় যাচাই করা হবে { -brand-short-name } ডিফল্ট মেইল ক্লায়েন্ট কিনা (A)
    .accesskey = A

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] কেন্দ্রবিন্দু
        [windows] উইন্ডোজ অনুসন্ধান
       *[other] { "" }
    }

search-integration-label =
    .label = বার্তা খুঁজতে { search-engine-name } কে অনুমোদন দেয়া হবে (s)
    .accesskey = s

config-editor-button =
    .label = কনফিগারেশন সম্পাদক... (g)
    .accesskey = g

return-receipts-description = { -brand-short-name } কিভাবে প্রাপ্তি জ্ঞাপন নিয়ন্ত্রণ করবে তা নির্ধারণ করা হবে
return-receipts-button =
    .label = প্রাপ্তি জ্ঞাপন... (R)
    .accesskey = R

networking-legend = সংযোগ
proxy-config-description = { -brand-short-name } কিভাবে ইন্টারনেটের সাথে সংযুক্ত হয় তা কনফিগার করা হবে

network-settings-button =
    .label = সেটিং... (S)
    .accesskey = S

offline-legend = অফলাইন
offline-settings = অফলাইন সেটিং কনফিগার করা হবে

offline-settings-button =
    .label = অফলাইন… (O)
    .accesskey = O

diskspace-legend = ডিস্কের জায়গা

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = সর্বোচ্চ ব্যবহার করা হবে (U)
    .accesskey = U

use-cache-after = ক্যাশের জন্য মেগাবাইট পর্যন্ত জায়গা

##

clear-cache-button =
    .label = এখন পরিষ্কার (C)
    .accesskey = C

default-font-label =
    .value = ডিফল্ট ফন্ট (D):
    .accesskey = D

default-size-label =
    .value = আকার ‌(S):
    .accesskey = S

font-options-button =
    .label = ফন্ট... (F)
    .accesskey = F

display-width-legend = সরল টেক্সট বার্তা

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = ইমোটিকন গ্রাফিক্স হিসেবে প্রদর্শন করা হবে (D)
    .accesskey = D

display-text-label = উদ্ধৃতি চিহ্ন যুক্ত সরল টেক্সট বার্তা প্রদর্শনে:

style-label =
    .value = শৈলী (y):
    .accesskey = y

regular-style-item =
    .label = স্বাভাবিক
bold-style-item =
    .label = গাঢ়
italic-style-item =
    .label = তীর্যক
bold-italic-style-item =
    .label = গাঢ় তীর্যক

size-label =
    .value = আকার (S):
    .accesskey = S

regular-size-item =
    .label = স্বাভাবিক
bigger-size-item =
    .label = অপেক্ষাকৃত বড়
smaller-size-item =
    .label = অপেক্ষাকৃত ছোট

search-input =
    .placeholder = অনুসন্ধান

type-column-label =
    .label = বিষয়বস্তুর ধরন (T)
    .accesskey = T

action-column-label =
    .label = কাজ (A)
    .accesskey = A

save-to-label =
    .label = এখানে ফাইল সংরক্ষণ করা হবে (S)
    .accesskey = S

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] নির্বাচন… (C)
           *[other] ব্রাউজ… (B)
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] B
        }

always-ask-label =
    .label = ফাইল সংরক্ষণের স্থান জিজ্ঞেস করা হবে (A)
    .accesskey = A


display-tags-text = আপনার বার্তা শ্রেনীবিভক্ত এবং অগ্রাধিকারভুক্ত করতে ট্যাগ ব্যবহার করা যায়।

delete-tag-button =
    .label = অপসারণ (D)
    .accesskey = D

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).


##


## Compose Tab

forward-label =
    .value = বার্তা ফরওয়ার্ড হবে (F):
    .accesskey = F

inline-label =
    .label = ইনলাইন হিসেবে

as-attachment-label =
    .label = সংযুক্তি হিসেবে

extension-label =
    .label = ফাইল নামের এক্সটেনশন দেয়া হবে (e)
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = স্বয়ংক্রিয়ভাবে সংরক্ষণ করা হবে প্রতি (A)
    .accesskey = A

auto-save-end = মিনিট

##

warn-on-send-accel-key =
    .label = বার্তা প্রেরণের ক্ষেত্রে কীবোর্ড শর্টকাট ব্যবহার করলে পুনঃনিশ্চিত করা হবে (C)
    .accesskey = C

spellcheck-label =
    .label = প্রেরণের পূর্বে বানান পরীক্ষা করা হবে (C)
    .accesskey = C

spellcheck-inline-label =
    .label = টাইপ করার সময় বানান পরীক্ষণ সক্রিয় করা হবে
    .accesskey = E

language-popup-label =
    .value = ভাষা (L):
    .accesskey = L

download-dictionaries-link = আরও অভিধান ডাউনলোড করা হবে

font-label =
    .value = ফন্ট (n):
    .accesskey = n

font-color-label =
    .value = লেখার রং (T):
    .accesskey = T

bg-color-label =
    .value = পটভূমির রং (B):
    .accesskey = B

restore-html-label =
    .label = ডিফল্ট মান পুনঃনির্ধারণ (R)
    .accesskey = R

format-description = লেখা বিন্যাসের বৈশিষ্ট্য কনফিগার করুন

send-options-label =
    .label = প্রেরণ অপশন... (S)
    .accesskey = S

autocomplete-description = বার্তার ঠিকানা দেয়ার সময়, যেখানে মিল খোঁজা হবে:

ab-label =
    .label = স্থানীয় ঠিকানা বই (L)
    .accesskey = L

directories-label =
    .label = ডিরেক্টরি সার্ভার (D):
    .accesskey = D

directories-none-label =
    .none = কোনটি নয়

edit-directories-label =
    .label = ডিরেক্টরি সম্পাদনা... (E)
    .accesskey = E

email-picker-label =
    .label = যেখানে স্বয়ংক্রিয়ভাবে বহিঃর্গামী ই-মেইল ঠিকানা যোগ করা হবে:
    .accesskey = A

attachment-label =
    .label = অনুপস্থিত সংযুক্তির জন্য পরীক্ষা করা হবে (m)
    .accesskey = m

attachment-options-label =
    .label = কীওয়ার্ড… (K)
    .accesskey = K


## Privacy Tab

passwords-description = সকল অ্যাকাউন্টের পাসওয়ার্ড { -brand-short-name } মনে রাখতে পারে।

passwords-button =
    .label = সংরক্ষিত পাসওয়ার্ড… (S)
    .accesskey = S

master-password-description = মাস্টার পাসওয়ার্ড আপনার সকল পাসওয়ার্ড সুরক্ষিত রাখে, কিন্তু প্রতিটি সেশনে তা কমপক্ষে একবার প্রবেশ করাতে হবে।

master-password-label =
    .label = মাস্টার পাসওয়ার্ড ব্যবহার করুন (U)
    .accesskey = U

master-password-button =
    .label = মাস্টার পাসওয়ার্ড পরিবর্তন... (C)
    .accesskey = C


junk-description = আপনার ডিফল্ট অপ্রয়োজনীয় মেইলের সেটিং নির্ধারণ করুন। অ্যাকাউন্ট অনুযায়ী অপ্রয়োজনীয় মেইলের বৈশিষ্ট্য নির্ধারণ করতে  অ্যাকাউন্ট সেটিং এ যান।

junk-label =
    .label = যখন বার্তাসমূহকে অপ্রয়োজনীয় হিসেবে চিহ্নিত করা হয়, বার্তাগুলোকে (W):
    .accesskey = W

junk-move-label =
    .label = অ্যাকাউন্টের "অপ্রয়োজনীয় মেইল" ফোল্ডারে সরিয়ে নেয়া হবে (o)
    .accesskey = o

junk-delete-label =
    .label = মুছে ফেলা হবে (D)
    .accesskey = D

junk-read-label =
    .label = অপ্রয়োজনীয় মেইল হিসেবে চিহ্নিত বার্তা পঠিত হিসেবে চিহ্নিত করা হবে (M)
    .accesskey = M

junk-log-button =
    .label = লগ প্রদর্শন (S)
    .accesskey = S

reset-junk-button =
    .label = প্রশিক্ষণ ডাটা পুনঃনির্ধারণ করা হবে (R)
    .accesskey = R

phishing-description = সাধারণভাবে ব্যবহৃত ইমেইল জালিয়াতি চিহ্নিত করার লক্ষ্যে { -brand-short-name }  বার্তাসমূহ বিশ্লেষণ করতে পারে।

phishing-label =
    .label = আমি যে বার্তাটি পড়ছি, তা যদি সন্দেহজনক ইমেইল জালিয়াতি হয়, আমাকে বলা হবে (T)
    .accesskey = T

antivirus-description = { -brand-short-name } আসন্ন মেইল বার্তাসমূহ স্থানীয়ভাবে সংরক্ষণ করার পূর্বে, তারা ভাইরাস যুক্ত কিনা তা পরীক্ষা করতে, এন্টি-ভাইরাস সফটওয়্যারকে সাহায্য করে।

antivirus-label =
    .label = এন্টি-ভাইরাস ক্লায়েন্টকে আসন্ন বার্তা আটকে রাখতে অনুমোদন করা হবে (A)
    .accesskey = A

certificate-description = যখন সার্ভার আমার ব্যক্তিগত সার্টিফিকেট চায়:

certificate-auto =
    .label = স্বয়ংক্রিয় ভাবে নির্বাচন
    .accesskey = m

certificate-ask =
    .label = প্রতিবার জিজ্ঞেস করা হবে
    .accesskey = A

## Chat Tab


## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.


##


## Preferences UI Search Results

