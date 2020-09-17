# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Ekunokukhethwa kuko
           *[other] Preferences
        }

pane-compose-title = Uhlanganiselo
category-compose =
    .tooltiptext = Uhlanganiselo

pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat

## OS Authentication dialog


## General Tab

general-legend = I-{ -brand-short-name } Ikhasi Lokuqalisa

start-page-label =
    .label = Xa i-{ -brand-short-name } indululwa, bonisa Ikhasi Lokuqalisa kummandla womyalezo
    .accesskey = X

location-label =
    .value = Indawo yokuthile:
    .accesskey = o
restore-default-label =
    .label = Buyisela Okuhlala KukhoRestore Default
    .accesskey = B

default-search-engine = Default Search Engine

new-message-arrival = Xa kufika imiyalezo emitsha:
mail-play-button =
    .label = Play
    .accesskey = P

change-dock-icon = Change preferences for the app icon
app-icon-options =
    .label = App Icon Options…
    .accesskey = n

animated-alert-label =
    .label = Bonisa isiqaphelisi
    .accesskey = B
customize-alert-label =
    .label = Customize…
    .accesskey = C

tray-icon-label =
    .label = Show a tray icon
    .accesskey = t

mail-custom-sound-label =
    .label = Use the following sound file
    .accesskey = U
mail-browse-sound-button =
    .label = Browse…
    .accesskey = B

enable-gloda-search-label =
    .label = Enable Global Search and Indexer
    .accesskey = E

allow-hw-accel =
    .label = Use hardware acceleration when available
    .accesskey = h

store-type-label =
    .value = Message Store Type for new accounts:
    .accesskey = T

mbox-store-label =
    .label = File per folder (mbox)
maildir-store-label =
    .label = File per message (maildir)

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

search-integration-label =
    .label = Allow { search-engine-name } to search messages
    .accesskey = S

config-editor-button =
    .label = Umhleli Wobumbeko...
    .accesskey = m

return-receipts-description = Determine how { -brand-short-name } handles return receipts
return-receipts-button =
    .label = Return Receipts…
    .accesskey = R

automatic-updates-label =
    .label = Automatically install updates (recommended: improved security)
    .accesskey = A
check-updates-label =
    .label = Check for updates, but let me choose whether to install them
    .accesskey = C

update-history-button =
    .label = Show Update History
    .accesskey = p

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

diskspace-legend = Isithuba Kwidisk
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

fonts-legend = Fonts & Colors

default-font-label =
    .value = Default font:
    .accesskey = D

default-size-label =
    .value = Size:
    .accesskey = S

font-options-button =
    .label = Iifonti...
    .accesskey = I

color-options-button =
    .label = Colors…
    .accesskey = C

display-width-legend = Imiyalezo Yesiqendu Engaxutywanga

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Bonisa imiqondiso yokuqulathiweyo enentshukumo njengezazobe
    .accesskey = B

display-text-label = Xa kuboniswa imiyalezo yesiqendu ecatshulweyo nengaxutywanga:

style-label =
    .value = Isimbo:
    .accesskey = m

regular-style-item =
    .label = Okwesiqhelo
bold-style-item =
    .label = Ngqindilili
italic-style-item =
    .label = Ubhalo olukekeleyo
bold-italic-style-item =
    .label = Ubhalo Olungqindilili Olukekeleyo

size-label =
    .value = Ubukhulu:
    .accesskey = U

regular-size-item =
    .label = Okwesiqhelo
bigger-size-item =
    .label = Obuthe chatha ngobukhulu
smaller-size-item =
    .label = Kuncinci kunokunye

quoted-text-color =
    .label = Color:
    .accesskey = o


display-tags-text = Tags can be used to categorize and prioritize your messages.

delete-tag-button =
    .label = Delete
    .accesskey = D

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).


##


## Compose Tab

forward-label =
    .value = Gqithisela phambili imiyalezo:
    .accesskey = G

inline-label =
    .label = Emgceni

as-attachment-label =
    .label = Njengesiqhoboshelo

extension-label =
    .label = add extension to file name
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Kugcineka Ngokuzenzekela konke
    .accesskey = n

auto-save-end = imizuzu

##

warn-on-send-accel-key =
    .label = Qinisekisa xa usebenzisa indlela enqumlayo yebhodi yokuchwetheza ukuba uthumela umyalezo
    .accesskey = s

spellcheck-label =
    .label = Qwalasela upelo phambi kokuthumela
    .accesskey = Q

spellcheck-inline-label =
    .label = Nika isakhono kupelo ngoku usachwethezayo
    .accesskey = E

language-popup-label =
    .value = Ulwimi:
    .accesskey = i

download-dictionaries-link = Thoba Umthwalo Wezichazimagama Ezongezelelweyo

font-label =
    .value = Font:
    .accesskey = n

font-color-label =
    .value = Text Color:
    .accesskey = T

bg-color-label =
    .value = Background Color:
    .accesskey = B

restore-html-label =
    .label = Restore Defaults
    .accesskey = R

format-description = Bumba ukuziphatha kolungiselelo lwesiqendu

send-options-label =
    .label = Thumela Ekunokukhethwa Kuko...
    .accesskey = T

autocomplete-description = Xa kufakwa iidilesi kwimiyalezo, jonga amangeniso ahambelanayo phakathi:

ab-label =
    .label = Iincwadi Zeedilesi Zalapha
    .accesskey = Z

directories-label =
    .label = Iseva Kavimba Weefayili:
    .accesskey = I

directories-none-label =
    .none = None

edit-directories-label =
    .label = Hlela Oovimba Beefayili...
    .accesskey = H

email-picker-label =
    .label = Fakela ngokuzenzekela iidilesi zemeyile ephumayo kweyam:
    .accesskey = k

attachment-label =
    .label = Check for missing attachments
    .accesskey = m

attachment-options-label =
    .label = Keywords…
    .accesskey = K


## Privacy Tab

mail-content = Mail Content

remote-content-label =
    .label = Allow remote content in messages
    .accesskey = m

exceptions-button =
    .label = Exceptions…
    .accesskey = E

remote-content-info =
    .value = Learn more about the privacy issues of remote content

web-content = Web Content

history-label =
    .label = Remember websites and links I've visited
    .accesskey = R

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


certificate-description = When a server requests my personal certificate:

certificate-auto =
    .label = Select one automatically
    .accesskey = S

certificate-ask =
    .label = Ask me every time
    .accesskey = A

ocsp-label =
    .label = Query OCSP responder servers to confirm the current validity of certificates
    .accesskey = Q

## Chat Tab


## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.


##


## Preferences UI Search Results

