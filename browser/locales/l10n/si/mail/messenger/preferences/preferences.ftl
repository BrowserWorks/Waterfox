# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


pane-compose-title = ලිපි ලිවීම
category-compose =
    .tooltiptext = ලිපි ලිවීම

pane-chat-title = චැට්
category-chat =
    .tooltiptext = චැට්

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name } ආරම්භක පිටුව

start-page-label =
    .label = { -brand-short-name } දියත් කිරීමේදී, ආරම්භක පිටුව ලිපි පෙදෙසේ (message area) පෙන්වන්න
    .accesskey = W

location-label =
    .value = ස්ථානය:
    .accesskey = o
restore-default-label =
    .label = පෙරනිමි නැවත පිහිටුවන්න
    .accesskey = R

new-message-arrival = නව ලිපි ලැබීමේදී:
mail-play-button =
    .label = වාදනය කරන්න
    .accesskey = P

animated-alert-label =
    .label = සංඥාවක් කරන්න
    .accesskey = S
customize-alert-label =
    .label = රිසිකරණය...
    .accesskey = C

tray-icon-label =
    .label = Show a tray icon
    .accesskey = t

mail-custom-sound-label =
    .label = පහත නාද ගොනුව භාවිතා කරන්න
    .accesskey = U
mail-browse-sound-button =
    .label = පිරික්සන්න...
    .accesskey = B

enable-gloda-search-label =
    .label = Enable Global Search and Indexer
    .accesskey = i

scrolling-legend = Scrolling
autoscroll-label =
    .label = Use autoscrolling
    .accesskey = U
smooth-scrolling-label =
    .label = Use smooth scrolling
    .accesskey = m

system-integration-legend = පද්ධති ඒකාබද්ධ කිරීම
always-check-default =
    .label = සෑමවිටම ආරම්භයේදී, තණ්ඩබර්ඩ් පෙරනිමි වි.තැ. යෙදුමදැයි (default mail client) පරීක්ෂා කරන්න
    .accesskey = l
check-default-button =
    .label = දැන් පරීක්ෂා කරන්න…
    .accesskey = N

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] වින්ඩෝස් සෙවුම
       *[other] { "" }
    }

search-integration-label =
    .label = ලිපි සෙවීමට { search-engine-name } ට ඉඩදෙන්න
    .accesskey = S

config-editor-button =
    .label = Config Editor...
    .accesskey = g

return-receipts-description = { -brand-short-name } ලදුපත් හසුරුවන ආකාරය නිර්ණය කිරීම
return-receipts-button =
    .label = ලදුපත්...
    .accesskey = R

use-service =
    .label = යාවත්කාලීන ස්ථාපනය සඳහා පසුබිම් සේවාවන් භාවිතා කරන්න
    .accesskey = b

networking-legend = සම්බන්ධතාවය
proxy-config-description = { -brand-short-name } අන්තර්ජාලයට සම්බන්ධ වන්නේ කෙසේදැයි වින්‍යාස කරන්න

network-settings-button =
    .label = සැකසුම්…
    .accesskey = n

offline-legend = අසම්බන්ධිත
offline-settings = අසම්බන්ධිත සැකසුම් වින්‍යාස කරන්න

offline-settings-button =
    .label = අසම්බන්ධිත...
    .accesskey = O

diskspace-legend = ඩිස්ක ඉඩ
offline-compact-folder =
    .label = සුරකින්නේ නම් සියළු ෆෝලඩර සංයුක්ත (Compact) කරන්න
    .accesskey = a

compact-folder-size =
    .value = MB (මුළු එකතුව)

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = කෑච් (Cache) සඳහා මෙගාබයිට (MB)
    .accesskey = U

use-cache-after = දක්වා ප්‍රමාණයක් භාවිතා කරන්න

##

clear-cache-button =
    .label = දැන් හිස් කරන්න
    .accesskey = C

fonts-legend = ෆොන්ට සහ වර්ණ

default-font-label =
    .value = පෙරනිමි ෆොන්ටය:
    .accesskey = D

default-size-label =
    .value = තරම:
    .accesskey = S

font-options-button =
    .label = අකුරු...
    .accesskey = A

color-options-button =
    .label = වර්ණ…
    .accesskey = C

display-width-legend = සාමාන්‍ය පාඨ ලිපි

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = ඉමෝටිකෝන (emoticons) පිංතූර ලෙස පෙන්වන්න
    .accesskey = D

display-text-label = උදෘත (quoted) සාමාන්‍ය පාඨ ලිපි පෙන්වන විටදී:

style-label =
    .value = විලාසය:
    .accesskey = y

regular-style-item =
    .label = සාමාන්‍ය
bold-style-item =
    .label = තද
italic-style-item =
    .label = ඇල
bold-italic-style-item =
    .label = තද ඇල

size-label =
    .value = විශාලත්වය:
    .accesskey = S

regular-size-item =
    .label = සාමාන්‍ය
bigger-size-item =
    .label = වඩා විශාල
smaller-size-item =
    .label = වඩා කුඩා

quoted-text-color =
    .label = වර්ණය:
    .accesskey = o

search-input =
    .placeholder = සෙවීම

type-column-label =
    .label = අන්තර්ගත ආකාරය
    .accesskey = T

action-column-label =
    .label = ක්‍රියාව
    .accesskey = A

save-to-label =
    .label = ගොනු සුරකින්නේ (මෙතුළට)
    .accesskey = S

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] තෝරන්න…
           *[other] පිරික්සන්න…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] B
        }

always-ask-label =
    .label = ගොනු සුරකින්නේ කොතනටදැයි සෑම විටම විමසන්න
    .accesskey = A


display-tags-text = ඔබගේ ලිපි ප්‍රමුඛතාවයට හා වර්ගීකරණයට ටැග්ස් භාවිතා කළ හැකිය.

delete-tag-button =
    .label = මකන්න
    .accesskey = l

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).


##


## Compose Tab

forward-label =
    .value = ලිපි යොමුකිරීම:
    .accesskey = F

inline-label =
    .label = ලිපිය තුළ

as-attachment-label =
    .label = ඇමුණුමක් ලෙස

extension-label =
    .label = දිගු කිරීම ගොනු නමට එක් කරන්න
    .accesskey = f

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = සෑම විනාඩි
    .accesskey = u

auto-save-end = ට වරක් ස්වයංව සුරකින්න

##

warn-on-send-accel-key =
    .label = ලිපි යැවීමට යතුරුපුවරු කෙටිමං (keyboard shortcut) භාවිතා කරන විටදී තහවුරු කරන්න
    .accesskey = i

spellcheck-label =
    .label = යැවීමට පෙර අක්ෂර වින්‍යාසය පරීක්ෂා කරන්න
    .accesskey = C

spellcheck-inline-label =
    .label = ලියන විටදීම අක්ෂර වින්‍යාස පරීක්ෂාව බලැති කරන්න
    .accesskey = k

language-popup-label =
    .value = භාෂාව:
    .accesskey = g

download-dictionaries-link = තවත් ශබ්දකෝෂ බාගත කිරීම

font-label =
    .value = අකුරු:
    .accesskey = n

font-color-label =
    .value = අකුරු වර්ණය:
    .accesskey = x

bg-color-label =
    .value = පසුබිම් වර්ණය:
    .accesskey = B

restore-html-label =
    .label = පෙරනිමි නැවත පිහිටුවන්න
    .accesskey = R

format-description = පාඨ හැඩතල හැසිරීම් වින්‍යාස කිරීම

send-options-label =
    .label = යැවීම් විකල්ප...
    .accesskey = S

autocomplete-description = ලිපින යෙදීමේදී, ගැලපෙන යෙදීම් බලන්නේ:

ab-label =
    .label = ස්ථානීය (Local) ලිපින පොත්
    .accesskey = A

directories-label =
    .label = ඩිරෙක්ටරි සේවාදායකය:
    .accesskey = D

directories-none-label =
    .none = කිසිවක් නැත

edit-directories-label =
    .label = ඩිරෙක්ටරි සැකසුම්...
    .accesskey = E

email-picker-label =
    .label = ලිපි යවන ලිපින ස්වයංක්‍රීයවම එක් කරන්නේ මගේ:
    .accesskey = t

attachment-label =
    .label = මඟහැරුනු ඇමුණුම් සඳහා පරීක්ෂා කරන්න
    .accesskey = m

attachment-options-label =
    .label = මූලපද (Keywords)…
    .accesskey = K

enable-cloud-share =
    .label = මෙයට වඩා විශාල ගොනු සඳහා බෙදාගන්න
cloud-share-size =
    .value = MB

remove-cloud-account =
    .label = ඉවත්කරන්න
    .accesskey = R

cloud-account-description = නව ගොනු-ඈඳුම් සංචිත සේවයක් එක්කරන්න


## Privacy Tab

passwords-description = { -brand-short-name } ට ඔබගේ සියළු ගිණුම් සඳහා වන රහස්පද මතක තබාගත හැකිය, එවිට ඔබට පිරුම් විස්තර නැවත ඇතුළු කිරීම අවශ්‍ය නොවේ.

passwords-button =
    .label = සුරැකූ රහස්පද…
    .accesskey = S

master-password-description = සැකසූ විට, ප්‍රධාන රහස්පදය සියළු රහස්පද ආරක්ෂා කරයි - නමුත් සැසියකට එක් වරක් ඔබ එය ඇතුළු කළ යුතුමය.

master-password-label =
    .label = ප්‍රධාන රහස්පදයක් (Master Password) භාවිතා කරන්න
    .accesskey = m

master-password-button =
    .label = ප්‍රධාන රහස්පදය (Master Password) වෙනස් කිරීම…
    .accesskey = C


junk-description = ඔබගේ පෙරනිමි නිසරු ලිපි සැකසුම් සාදන්න. ගිණුමට විශේෂිත වූ නිසරු ලිපි සැකසුම් ගිණුමේ සැකසුම් තුළ දී වින්‍යාස කළ හැකිය.

junk-label =
    .label = මම ලිපි නිසරු ලෙස සළකුණු කළ විටදී:
    .accesskey = W

junk-move-label =
    .label = ඒවා ගිණුමේ "නිසරු ලිපි" ෆෝල්ඩරයට ගෙන යන්න
    .accesskey = o

junk-delete-label =
    .label = ඒවා මකන්න
    .accesskey = t

junk-read-label =
    .label = කියවන විට නිසරු සේ හඳුනා ගැනීම සඳහා සළකුණු කරන්න
    .accesskey = k

junk-log-label =
    .label = නිසරු ලිපි පෙරණය ලොග් කිරීම බලැති කරන්න
    .accesskey = E

junk-log-button =
    .label = ලොග් සටහන පෙන්වන්න
    .accesskey = h

reset-junk-button =
    .label = Reset Training Data
    .accesskey = D

phishing-description = { -brand-short-name } can analyse messages for suspected email scams by looking for common techniques used to deceive you.

phishing-label =
    .label = Tell me if the message I'm reading is a suspected email scam
    .accesskey = e

antivirus-description = { -brand-short-name } can make it easy for anti-virus software to analyse incoming mail messages for viruses before they are stored locally.

antivirus-label =
    .label = Allow anti-virus clients to quarantine individual incoming messages
    .accesskey = l

certificate-description = සේවාදායකයක් මගේ පෞද්ගලික සහතික ඉල්ලන විටදී:

certificate-auto =
    .label = ස්වයංක්‍රීයව එකක් තෝරන්න
    .accesskey = m

certificate-ask =
    .label = සෑම විටම විමසන්න
    .accesskey = A

## Chat Tab

startup-label =
    .value = { -brand-short-name } ආරම්භ කිරීමේදී:
    .accesskey = s

offline-label =
    .label = මාගේ චැට් ගිණුම අසම්බන්ධිතව තබන්න

auto-connect-label =
    .label = මාගේ චැට් ගිණුම ස්වයංක්‍රීයව සම්බන්ධ කරන්න

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = විනාඩි
    .accesskey = I

idle-time-label = නිෂ්ක්‍රීයව සිටි විට මා සමඟ සම්බන්ධ වූවන්ට සන්වන්න

##

away-message-label =
    .label = මෙම පණුවුඩය සමඟ තත්ත්වය Away ලෙස සකසන්න:
    .accesskey = A

send-typing-label =
    .label = සාකච්ඡාවේදී ටයිපු කරන දැන්වීම් (typing notifications) යවන්න
    .accesskey = t

## Preferences UI Search Results

