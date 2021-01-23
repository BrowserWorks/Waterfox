# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


preferences-title =
    .title =
        { PLATFORM() ->
            [windows] گزینه‌ها
           *[other] ترجیحات
        }

pane-compose-title = Composition
category-compose =
    .tooltiptext = Composition

pane-chat-title = گفت‌وگو
category-chat =
    .tooltiptext = گفت‌وگو

## OS Authentication dialog


## General Tab

general-legend = { -brand-short-name } Start Page

start-page-label =
    .label = When { -brand-short-name } launches, show the Start Page in the message area
    .accesskey = W

location-label =
    .value = مکان:
    .accesskey = o
restore-default-label =
    .label = Restore Default
    .accesskey = R

new-message-arrival = When new messages arrive:
mail-play-button =
    .label = پخش
    .accesskey = پ

animated-alert-label =
    .label = Show an alert
    .accesskey = S
customize-alert-label =
    .label = سفارشی‌سازی…
    .accesskey = س

mail-custom-sound-label =
    .label = Use the following sound file
    .accesskey = U
mail-browse-sound-button =
    .label = مرور…
    .accesskey = م

enable-gloda-search-label =
    .label = Enable Global Search and Indexer
    .accesskey = I

always-check-default =
    .label = Always check to see if { -brand-short-name } is the default mail client on startup
    .accesskey = l

config-editor-button =
    .label = Config Editor…
    .accesskey = g

return-receipts-description = Determine how { -brand-short-name } handles return receipts
return-receipts-button =
    .label = Return Receipts…
    .accesskey = R

networking-legend = اتصال
proxy-config-description = چگونگی اتصال { -brand-short-name } به اینترنت را پیکربندی کنید

network-settings-button =
    .label = تنظیمات…
    .accesskey = ت

offline-legend = Offline
offline-settings = Configure offline settings

offline-settings-button =
    .label = Offline…
    .accesskey = O

diskspace-legend = Disk Space

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = استفاده تا حداکثر
    .accesskey = ا

use-cache-after = مگابایت از فضای دیسک برای حافظهٔ نهان.

##

clear-cache-button =
    .label = هم‌اکنون پاک شود
    .accesskey = ه

default-size-label =
    .value = اندازه:
    .accesskey = ا

font-options-button =
    .label = Fonts…
    .accesskey = F

display-width-legend = Plain Text Messages

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Display emoticons as graphics
    .accesskey = D

display-text-label = When displaying quoted plain text messages:

style-label =
    .value = Style:
    .accesskey = y

regular-style-item =
    .label = Regular
bold-style-item =
    .label = Bold
italic-style-item =
    .label = Italic
bold-italic-style-item =
    .label = Bold Italic

size-label =
    .value = اندازه:
    .accesskey = ا

regular-size-item =
    .label = Regular
bigger-size-item =
    .label = Bigger
smaller-size-item =
    .label = Smaller

search-input =
    .placeholder = جست‌وجو

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] انتخاب…
           *[other] مرور…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ا
           *[other] م
        }


display-tags-text = Tags can be used to categorize and prioritize your messages.

delete-tag-button =
    .label = حذف
    .accesskey = ح

auto-mark-as-read =
    .label = Automatically mark messages as read
    .accesskey = A

mark-read-no-delay =
    .label = Immediately on display
    .accesskey = d

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = After displaying for
    .accesskey = e

seconds-label = seconds

##

open-msg-label =
    .value = Open messages in:

open-msg-window =
    .label = A new message window
    .accesskey = i

open-msg-ex-window =
    .label = An existing message window
    .accesskey = x

condensed-addresses-label =
    .label = Show only display name for people in my address book
    .accesskey = p

## Compose Tab

forward-label =
    .value = Forward messages:
    .accesskey = w

inline-label =
    .label = Inline

as-attachment-label =
    .label = As Attachment

extension-label =
    .label = add extension to file name
    .accesskey = f

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Auto Save every
    .accesskey = u

auto-save-end = minutes

##

warn-on-send-accel-key =
    .label = Confirm when using keyboard shortcut to send message
    .accesskey = i

spellcheck-label =
    .label = Check spelling before sending
    .accesskey = C

spellcheck-inline-label =
    .label = Enable spell check as you type
    .accesskey = k

language-popup-label =
    .value = زبان:
    .accesskey = L

download-dictionaries-link = Download More Dictionaries

font-label =
    .value = Font:
    .accesskey = n

font-color-label =
    .value = Text Color:
    .accesskey = x

bg-color-label =
    .value = Background Color:
    .accesskey = B

restore-html-label =
    .label = احیای تنظیمات پیش‌فرض
    .accesskey = ا

format-description = Configure text format behavior

send-options-label =
    .label = Send Options…
    .accesskey = S

autocomplete-description = When addressing messages, look for matching entries in:

ab-label =
    .label = Local Address Books
    .accesskey = A

directories-label =
    .label = Directory Server:
    .accesskey = D

directories-none-label =
    .none = هیچ

edit-directories-label =
    .label = Edit Directories…
    .accesskey = E

email-picker-label =
    .label = Automatically add outgoing e-mail addresses to my:
    .accesskey = t


## Privacy Tab

passwords-description = { -brand-short-name } می‌تواند گذرواژه‌ها را برای همهٔ حسابهای شما به خاطر بیاورد.


## Chat Tab

offline-label =
    .label = حساب گفت‌و‌گوی من را آفلاین نگه دار

auto-connect-label =
    .label = حساب گفت‌و‌گوی من را بطور خودکار متصل کن

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.


##

notification-label = وقتی پیام‌هایی که مستقیم برای شما هستند میرسند:

chat-play-button =
    .label = پخش
    .accesskey = پ

chat-system-sound-label =
    .label = صدای پیش فرض سیستم برای نامه جدید
    .accesskey = D

chat-custom-sound-label =
    .label = Use the following sound file
    .accesskey = U

chat-browse-sound-button =
    .label = مرور…
    .accesskey = م

## Preferences UI Search Results

