# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


pane-compose-title = ਲਿਖਣ
category-compose =
    .tooltiptext = ਲਿਖਣ

pane-chat-title = ਗੱਲਬਾਤ
category-chat =
    .tooltiptext = ਗੱਲਬਾਤ

pane-calendar-title = Calendar
category-calendar =
    .tooltiptext = Calendar

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name } ਸ਼ੁਰੂਆਤੀ ਪੇਜ਼

start-page-label =
    .label = ਜਦੋਂ { -brand-short-name } ਚਾਲੂ ਹੋਵੇ ਤਾਂ ਸੁਨੇਹਾ ਖੇਤਰ ਵਿੱਚ ਸ਼ੁਰੂਆਤੀ ਪੇਜ਼ ਵੇਖੋ
    .accesskey = W

location-label =
    .value = ਟਿਕਾਣਾ:
    .accesskey = o
restore-default-label =
    .label = ਡਿਫਾਲਟ ਮੁੜ-ਸਟੋਰ ਕਰੋ
    .accesskey = R

new-message-arrival = ਜਦੋਂ ਨਵੇਂ ਸੁਨੇਹੇ ਆਉਣ:
mail-play-button =
    .label = ਚਲਾਓ
    .accesskey = P

animated-alert-label =
    .label = ਚੇਤਾਵਨੀ ਵੇਖੋ
    .accesskey = S
customize-alert-label =
    .label = ਕਸਟਮਾਈਜ਼…
    .accesskey = C

mail-custom-sound-label =
    .label = ਹੇਠ ਦਿੱਤੀ ਫਾਇਲ ਵਰਤੋਂ
    .accesskey = U
mail-browse-sound-button =
    .label = ...ਝਲਕ
    .accesskey = B

enable-gloda-search-label =
    .label = Enable Global Search and Indexer
    .accesskey = E

scrolling-legend = Scrolling
autoscroll-label =
    .label = Use autoscrolling
    .accesskey = U
smooth-scrolling-label =
    .label = Use smooth scrolling
    .accesskey = m

system-integration-legend = System Integration
always-check-default =
    .label = Always check to see if { -brand-short-name } is the default mail client on startup
    .accesskey = A
check-default-button =
    .label = Check Now…
    .accesskey = N

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

search-integration-label =
    .label = Allow { search-engine-name } to search messages
    .accesskey = S

config-editor-button =
    .label = Config Editor…
    .accesskey = C

return-receipts-description = Determine how { -brand-short-name } handles return receipts
return-receipts-button =
    .label = Return Receipts…
    .accesskey = R

use-service =
    .label = Use a background service to install updates
    .accesskey = b

networking-legend = Connection
proxy-config-description = Configure how { -brand-short-name } connects to the Internet

network-settings-button =
    .label = Settings…
    .accesskey = S

offline-legend = Offline
offline-settings = Configure offline settings

offline-settings-button =
    .label = Offline…
    .accesskey = O

diskspace-legend = Disk Space
offline-compact-folder =
    .label = Compact all folders when it will save over
    .accesskey = a

compact-folder-size =
    .value = MB in total

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Use up to
    .accesskey = U

use-cache-after = MB of space for the cache

##

clear-cache-button =
    .label = Clear Now
    .accesskey = C

default-font-label =
    .value = Default font:
    .accesskey = D

default-size-label =
    .value = Size:
    .accesskey = S

font-options-button =
    .label = Advanced…
    .accesskey = A

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
    .value = Size:
    .accesskey = s

regular-size-item =
    .label = Regular
bigger-size-item =
    .label = Bigger
smaller-size-item =
    .label = Smaller

search-input =
    .placeholder = Search

type-column-label =
    .label = Content Type
    .accesskey = T

action-column-label =
    .label = Action
    .accesskey = A

save-to-label =
    .label = Save files to
    .accesskey = S

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Choose…
           *[other] Browse…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] B
        }

always-ask-label =
    .label = Always ask me where to save files
    .accesskey = A


display-tags-text = Tags can be used to categorize and prioritize your messages.

delete-tag-button =
    .label = Delete
    .accesskey = D

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).


##


## Compose Tab

forward-label =
    .value = ਸੁਨੇਹੇ ਅੱਗੇ ਭੇਜੋ:
    .accesskey = w

inline-label =
    .label = ਲਾਈਨ ਵਿੱਚ

as-attachment-label =
    .label = ਅਟੈਚਮੈਂਟ ਵਾਂਗ

extension-label =
    .label = ਫਾਇਲ ਨਾਂ ਲਈ ਇੱਕ ਇਕਸਟੈਨਸ਼ਨ
    .accesskey = f

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = ਆਪਣੇ ਆਪ ਸੰਭਾਲੋ ਹਰੇਕ
    .accesskey = u

auto-save-end = ਮਿੰਟ

##

warn-on-send-accel-key =
    .label = Confirm when using keyboard shortcut to send message
    .accesskey = i

spellcheck-label =
    .label = ਭੇਜਣ ਤੋਂ ਪਹਿਲਾਂ ਸਪੈਲਿੰਗ ਚੈੱਕ ਕਰੋ
    .accesskey = C

spellcheck-inline-label =
    .label = ਟਾਈਪ ਕਰਨ ਦੇ ਨਾਲ ਦੀ ਨਾਲ ਹੀ ਸਪੈੱਲ ਚੈੱਕ
    .accesskey = k

language-popup-label =
    .value = ਭਾਸ਼ਾ:
    .accesskey = g

download-dictionaries-link = ਹੋਰ ਡਿਕਸ਼ਨਰੀਆਂ ਡਾਊਨਲੋਡ ਕਰੋ

font-label =
    .value = ਫੋਂਟ:
    .accesskey = n

font-color-label =
    .value = ਟੈਕਸਟ ਰੰਗ:
    .accesskey = x

bg-color-label =
    .value = ਬੈਕਗਰਾਊਂਡ ਰੰਗ:
    .accesskey = B

restore-html-label =
    .label = ਡਿਫਾਲਟ ਰੀ-ਸਟੋਰ ਕਰੋ
    .accesskey = R

format-description = ਟੈਕਸਟ ਫਾਰਮੈਟ ਰਵੱਈਆ ਸੰਰਚਨਾ

send-options-label =
    .label = ਭੇਜਣ ਚੋਣਾਂ…
    .accesskey = S

autocomplete-description = When addressing messages, look for matching entries in:

ab-label =
    .label = ਲੋਕਲ ਐਡਰੈੱਸ ਬੁੱਕ
    .accesskey = A

directories-label =
    .label = ਡਾਇਰੈਕਟਰੀ ਸਰਵਰ:
    .accesskey = D

directories-none-label =
    .none = ਕੋਈ ਨਹੀ

edit-directories-label =
    .label = ਡਾਇਰੈਕਟਰੀਆਂ ਸੋਧ…
    .accesskey = E

email-picker-label =
    .label = Automatically add outgoing e-mail addresses to my:
    .accesskey = t

attachment-label =
    .label = ਗੁੰਮ ਅਟੈਚਮੈਂਟ ਲਈ ਚੈੱਕ ਕਰੋ
    .accesskey = m

attachment-options-label =
    .label = ਸ਼ਬਦ…
    .accesskey = K

enable-cloud-share =
    .label = Offer to share for files larger than
cloud-share-size =
    .value = MB

remove-cloud-account =
    .label = Remove
    .accesskey = R

cloud-account-description = Add a new Filelink storage service


## Privacy Tab

mail-content = Mail Content

remote-content-label =
    .label = Allow remote content in messages
    .accesskey = A

exceptions-button =
    .label = Exceptions…
    .accesskey = E

remote-content-info =
    .value = Learn more about the privacy issues of remote content

web-content = Web Content

cookies-label =
    .label = Accept cookies from sites
    .accesskey = A

third-party-label =
    .value = Accept third-party cookies:
    .accesskey = c

third-party-always =
    .label = Always
third-party-never =
    .label = Never
third-party-visited =
    .label = From visited

keep-label =
    .value = Keep until:
    .accesskey = K

keep-expire =
    .label = they expire
keep-close =
    .label = I close { -brand-short-name }
keep-ask =
    .label = ask me every time

cookies-button =
    .label = Show Cookies…
    .accesskey = S

passwords-description = { -brand-short-name } can remember passwords for all of your accounts.

passwords-button =
    .label = Saved Passwords…
    .accesskey = S

master-password-description = A Master Password protects all your passwords, but you must enter it once per session.

master-password-label =
    .label = Use a master password
    .accesskey = U

master-password-button =
    .label = Change Master Password…
    .accesskey = C


junk-description = Set your default junk mail settings. Account-specific junk mail settings can be configured in Account Settings.

junk-label =
    .label = When I mark messages as junk:
    .accesskey = W

junk-move-label =
    .label = Move them to the account's "Junk" folder
    .accesskey = o

junk-delete-label =
    .label = Delete them
    .accesskey = D

junk-read-label =
    .label = Mark messages determined to be Junk as read
    .accesskey = M

junk-log-label =
    .label = Enable adaptive junk filter logging
    .accesskey = E

junk-log-button =
    .label = Show log
    .accesskey = S

reset-junk-button =
    .label = Reset Training Data
    .accesskey = R

phishing-description = { -brand-short-name } can analyze messages for suspected email scams by looking for common techniques used to deceive you.

phishing-label =
    .label = Tell me if the message I'm reading is a suspected email scam
    .accesskey = T

antivirus-description = { -brand-short-name } can make it easy for anti-virus software to analyze incoming mail messages for viruses before they are stored locally.

antivirus-label =
    .label = Allow anti-virus clients to quarantine individual incoming messages
    .accesskey = A

certificate-description = When a server requests my personal certificate:

certificate-auto =
    .label = Select one automatically
    .accesskey = m

certificate-ask =
    .label = Ask me every time
    .accesskey = A

## Chat Tab

startup-label =
    .value = When { -brand-short-name } starts:
    .accesskey = s

offline-label =
    .label = Keep my Chat Accounts offline

auto-connect-label =
    .label = Connect my chat accounts automatically

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Let my contacts know that I am Idle after
    .accesskey = I

idle-time-label = minutes of inactivity

##

away-message-label =
    .label = and set my status to Away with this status message:
    .accesskey = A

send-typing-label =
    .label = Send typing notifications in conversations
    .accesskey = t

## Preferences UI Search Results

