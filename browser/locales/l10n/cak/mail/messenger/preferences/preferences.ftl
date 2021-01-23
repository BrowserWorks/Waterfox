# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Titz'apïx

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Taq cha'oj
           *[other] Taq ajowab'äl
        }

pane-general-title = Chijun
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Ruch'akulal
category-compose =
    .tooltiptext = Ruch'akulal

pane-privacy-title = Ichinanem & Jikomal
category-privacy =
    .tooltiptext = Ichinanem & Jikomal

pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat

general-language-and-appearance-header = Ch'ab'äl & Rutzub'al

general-incoming-mail-header = Okinel taq Taqoya'l

general-files-and-attachment-header = Taq Yakb'äl & Taq Tz'aqat

general-tags-header = Taq etal

general-reading-and-display-header = Sik'inem & Tz'etoj

general-updates-header = Taq K'exoj

general-network-and-diskspace-header = K'amab'ey & Rupam Rujolom

composition-category-header = Ruch'akulal

composition-attachments-header = Taq taqoj

composition-spelling-title = Tz'ib'anikil

compose-html-style-title = HTML Rub'anikil

composition-addressing-header = Taq ochochib'äl

privacy-main-header = Ichinanem

privacy-passwords-header = Ewan taq tzij

privacy-junk-header = Seq'

privacy-security-header = Jikomal

privacy-anti-virus-title = Chapöy chikopil

privacy-certificates-title = Taq ruwujil b'i'aj

chat-pane-header = Chat

chat-status-title = B'anikil

chat-notifications-title = Taq rutzijol

chat-pane-styling-header = Rub'anikil

choose-messenger-language-description = Kecha' ri taq ch'ab'äl e'okisan richin yek'ut taq molsamajib'äl, taq rutzijol taqoj, taq rutzijol { -brand-short-name }.
manage-messenger-languages-button =
    .label = Keya' taq Cha'oj
    .accesskey = h
confirm-messenger-language-change-description = Titikirisäx chik { -brand-short-name } richin ye'okisäx ri taq k'exoj
confirm-messenger-language-change-button = Tisamajïx chuqa' Titikirisäx chik

update-setting-write-failure-title = Xsach toq xyak ri Ruk'exoj taq ajowab'äl

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } xrïl jun sachoj ruma ri' toq man xuyäk ta re jaloj re'. Tatz'eta' chi re runuk'ulem re rajowab'al jaloj re' nrajo' chi niya' q'ij richin nitz'ib'äx pa ri yakb'äl. Rik'in jub'a' rat o jun runuk'samajel q'inoj yixtikïr nisöl re sachoj, rik'in ruchajixik chijun ri yakb'äl ruma ri molaj okisanela'.
    
    Man tikirel ta xtz'ib'äx chupam ri yakb'äl: { $path }

update-in-progress-title = Tajin Nik'ex

update-in-progress-message = ¿La nawajo' chi ri { -brand-short-name } nuk'isib'ej ri k'exoj?

update-in-progress-ok-button = &Tich'aqïx
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Titikïr chik el

addons-button = Taq k'amal & taq Wachinel

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name } Rutikirib'al Ruxaq

start-page-label =
    .label = Toq nitikirisäx { -brand-short-name } tik'ut ri Tikirib'äl Ruxaq pa ruk'ojlemal tzijol
    .accesskey = T

location-label =
    .value = Ochochib'al:
    .accesskey = o
restore-default-label =
    .label = Titzolïx ri K'o wi
    .accesskey = T

default-search-engine = K'o wi chi Kanob'äl
add-search-engine =
    .label = Titz'aqatisäx rik'in yakb'äl
    .accesskey = T
remove-search-engine =
    .label = Tiyuj
    .accesskey = y

new-message-arrival = Toq ye'uqa k'ak'a' taq tzijol:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Titzij re ruyakb'al k'oxom re':
           *[other] Titzij jun k'oxom
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] o
        }
mail-play-button =
    .label = Titzij
    .accesskey = T

change-dock-icon = Kejal taq rajowab'al ruwachaj chokoy
app-icon-options =
    .label = Kicha'oj Ruwachaj Chokoy…
    .accesskey = w

notification-settings = Kitzijol k'ayewal chuqa' k'oxom k'o wi yatikïr ye'achüp ri ketal pa rupas Kitzijol Kajowab'al Q'inoj.

animated-alert-label =
    .label = Tik'ut jun retal k'ayewal
    .accesskey = T
customize-alert-label =
    .label = Tichinäx…
    .accesskey = c

tray-icon-label =
    .label = Tik'ut jun wachaj pa nuk'ulem
    .accesskey = n

mail-custom-sound-label =
    .label = Tokisäx re ruyakb'al k'oxom re'
    .accesskey = o
mail-browse-sound-button =
    .label = Tokik'amayin…
    .accesskey = T

enable-gloda-search-label =
    .label = Titzij Cholajin chuqa' Chijun Kanoxïk
    .accesskey = C

datetime-formatting-legend = Rub'anikil Q'ijul chuqa' Ramaj
language-selector-legend = Ch'ab'äl

allow-hw-accel =
    .label = Tokisäx rupararexik ch'akulakem toq xtiwachin pe
    .accesskey = c

store-type-label =
    .value = Ruwäch Ruyakoj Tzijol kichin k'ak'a' kib'i' taqoya'l:
    .accesskey = R

mbox-store-label =
    .label = Yakb'äl chi yakwuj (mbox)
maildir-store-label =
    .label = Jun yakb'äl chi rutzijol (maildir)

scrolling-legend = Q'axanem
autoscroll-label =
    .label = Tokisäx ruyonil rusiloxik
    .accesskey = T
smooth-scrolling-label =
    .label = Tokisäx jeb'ël q'axanïk
    .accesskey = j

system-integration-legend = Q'inoj Tunuj
always-check-default =
    .label = Junelïk tinik'öx we ri { -brand-short-name } ja ri' ri ruwinaqil taqoya'l k'o wi toq nitikirisäx
    .accesskey = J
check-default-button =
    .label = Tinik'öx Wakami…
    .accesskey = W

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Kikanoxik Windows
       *[other] { "" }
    }

search-integration-label =
    .label = Tiya' q'ij chi re { search-engine-name } richin yerukanoj taq tzijol
    .accesskey = S

config-editor-button =
    .label = Tib'an runuk'ulem ri Nuk'unel…
    .accesskey = r

return-receipts-description = Tijikib'äx rub'eyal ri { -brand-short-name } yerusamajij ri kiwujil ajil
return-receipts-button =
    .label = Tzolin taq Wujil…
    .accesskey = T

update-app-legend = { -brand-short-name } Taq Ruk'exoj

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Ruwäch { $version }

allow-description = Tiya' q'ij { -brand-short-name } chi re
automatic-updates-label =
    .label = Keyak ruyonil taq k'exoj ruwäch (chilab'en: utzilan jikimal)
    .accesskey = r
check-updates-label =
    .label = Kenik'öx ri taq k'exoj, xa xe chi tiya' q'ij chwe we ninwajo' chi yenyäk
    .accesskey = K

update-history-button =
    .label = Tik'ut Kinatab'al taq K'exoj
    .accesskey = x

use-service =
    .label = Tokisäx jun samaj pa ruka'n b'ey richin yeyak ri taq k'exoj
    .accesskey = n

networking-legend = Okem
proxy-config-description = Tanuk'samajij ri rub'eyal nok ri { -brand-short-name } pa k'amaya'l

network-settings-button =
    .label = Taq nuk'ulem…
    .accesskey = n

offline-legend = Chupül
offline-settings = Tib'an runuk'ulem rik'in chupül okem

offline-settings-button =
    .label = Chupül…
    .accesskey = C

diskspace-legend = Rupam Rujolom
offline-compact-folder =
    .label = Kesib' yakwuj toq yekol k'ïy
    .accesskey = a

compact-folder-size =
    .value = MB chi ronojel

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Tokisäx k'a
    .accesskey = T

use-cache-after = MB rupam richin ri jumejyak

##

smart-cache-label =
    .label = Tiyuj runuk'samajixïk ruyonil jumejyak
    .accesskey = y

clear-cache-button =
    .label = Tijosq'ïx Wakami
    .accesskey = j

fonts-legend = Kiwäch taq tz'ib' &' taq b'onil

default-font-label =
    .value = Ruwäch tzij kan k'o wi:
    .accesskey = k

default-size-label =
    .value = Nimilem:
    .accesskey = N

font-options-button =
    .label = Taq Q'axinäq…
    .accesskey = A

color-options-button =
    .label = Taq b'onil…
    .accesskey = b

display-width-legend = Kitzijol Li'an Cholan Tzij

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Kek'ut pe taq emotikon achi'el taq wachib'äl
    .accesskey = e

display-text-label = Toq yek'ut pe kitzijol li'an cholan tzij esik'in:

style-label =
    .value = Taq b'anikil:
    .accesskey = n

regular-style-item =
    .label = Loman
bold-style-item =
    .label = Q'eqatz'ib'
italic-style-item =
    .label = Q'e'etz'ib'
bold-italic-style-item =
    .label = Q'ëq Q'e'etz'ib'

size-label =
    .value = Nimilem:
    .accesskey = m

regular-size-item =
    .label = Loman
bigger-size-item =
    .label = Chom
smaller-size-item =
    .label = Ko'öl

quoted-text-color =
    .label = B'onil:
    .accesskey = o

search-input =
    .placeholder = Tikanöx

type-column-label =
    .label = Ruwäch Rupam
    .accesskey = R

action-column-label =
    .label = B'anoj
    .accesskey = B

save-to-label =
    .label = Keyak yakb'äl pa
    .accesskey = y

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Ticha'…
           *[other] Tokik'amayin…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] c
           *[other] T
        }

always-ask-label =
    .label = Jantape' tik'utüx pe chwe akuchi' yeyak wi kan ri taq yakb'äl
    .accesskey = J


display-tags-text = Ri taq yaketal tikirel ye'okisäx richin niya' kiwäch o kiq'ij taq atzijol.

new-tag-button =
    .label = K'ak'a'…
    .accesskey = K

edit-tag-button =
    .label = Tinuk'…
    .accesskey = n

delete-tag-button =
    .label = Tiyuj
    .accesskey = y

auto-mark-as-read =
    .label = Ruyonil tiya' ketal taq tzijol achi'el sik'in
    .accesskey = R

mark-read-no-delay =
    .label = Anin pa ruwäch
    .accesskey = p

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Chi rij nik'ut chi
    .accesskey = n

seconds-label = taq xil ramaj

##

open-msg-label =
    .value = Kejaq taq tzijol pa:

open-msg-tab =
    .label = Jun k'ak'a' ruwi'
    .accesskey = r

open-msg-window =
    .label = Jun k'ak'a' rutzuwäch tzijol
    .accesskey = k

open-msg-ex-window =
    .label = K'o jun rutzuwäch tzijol
    .accesskey = o

close-move-delete =
    .label = Titz'apïx rutzuwäch/tab rutzijol toq nisilöx o niyuj
    .accesskey = T

display-name-label =
    .value = Tik'ut b'i'aj:

condensed-addresses-label =
    .label = Titz'et xa xe ri b'i'aj xtik'ut chi kiwäch ri winaqi' pa kitz'ib'awuj wochochib'al
    .accesskey = T

## Compose Tab

forward-label =
    .value = Ketaq chik kitzijol:
    .accesskey = T

inline-label =
    .label = Pa k'amab'ey

as-attachment-label =
    .label = Achi'el Rutz'aqat

extension-label =
    .label = titz'aqatisäx k'amal pa ri rub'i' yakb'äl
    .accesskey = k

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Jutaqil Ruyon Tiyak
    .accesskey = R

auto-save-end = taq ch'utiramaj

##

warn-on-send-accel-key =
    .label = Tijikib'äx toq ye'okisäx ruq'a' rokem pitz'b'äl richin nitaq rutzijol
    .accesskey = T

spellcheck-label =
    .label = Tinik'öx tz'ib'anikil chuwäch nitaq
    .accesskey = T

spellcheck-inline-label =
    .label = Tinik'öx tz'ib'anikil toq yatz'ib'an
    .accesskey = T

language-popup-label =
    .value = Ch'ab'äl:
    .accesskey = C

download-dictionaries-link = Keqasäx ch'aqa' chik taq Soltzij

font-label =
    .value = Ruwäch tz'ib':
    .accesskey = z

font-size-label =
    .value = Nimilem:
    .accesskey = e

default-colors-label =
    .label = Ke'okisäx ri taq b'onil erucha'on ri sik'inel
    .accesskey = e

font-color-label =
    .value = Rub'onil Rucholajem Tzij:
    .accesskey = T

bg-color-label =
    .value = Rub'onil Rupam:
    .accesskey = p

restore-html-label =
    .label = Ketzolïx ri taq wachinel e k'o wi
    .accesskey = K

default-format-label =
    .label = Tokisäx rub'anikil Motzaj chuwäch Ruch'akul Cholan Rutzij k'o wi
    .accesskey = M

format-description = Tib'an runuk'ulem runa'oj rub'anikil cholan tzij

send-options-label =
    .label = Kejaq Cha'oj…
    .accesskey = K

autocomplete-description = Toq nitz'ib'äx jun ochochib'äl, kekanöx ri nikik'äm ki' rik'in pa:

ab-label =
    .label = Aj Wawe' Kiwujil Ochochib'äl
    .accesskey = W

directories-label =
    .label = Rucholb'al K'uxasamaj:
    .accesskey = R

directories-none-label =
    .none = Majun

edit-directories-label =
    .label = Kenuk' taq Soltzij…
    .accesskey = K

email-picker-label =
    .label = Ruyonil ketz'aqatisäx ri kochochib'al taqoya'l ye'el pa nu:
    .accesskey = R

default-directory-label =
    .value = Rucholb'al tikirib'äl k'o wi pa ri rutzuwäch kitz'ib'awuj ochochib'äl:
    .accesskey = S

default-last-label =
    .none = Ruk'isib'äl cholb'äl okisan

attachment-label =
    .label = Kenik'öx taq taqoj nrajo' na
    .accesskey = n

attachment-options-label =
    .label = Kik'u'x tzij…
    .accesskey = K

enable-cloud-share =
    .label = Tisuj richin yekomonïx taq yakb'äl ye'ik'o chi re
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Titz'aqatisäx…
    .accesskey = t
    .defaultlabel = Titz'aqatisäx…

remove-cloud-account =
    .label = Tiyuj
    .accesskey = y

find-cloud-providers =
    .value = Kekanöx ch'aqa' chik taq ajya'öl…

cloud-account-description = Titz'aqatisäx jun k'ak'a' Filelink richin kiyakik samaj


## Privacy Tab

mail-content = Rupam Taqotz'ib'

remote-content-label =
    .label = Tiya' q'ij näj rupam pa rutzijol
    .accesskey = n

exceptions-button =
    .label = Taq man relik ta…
    .accesskey = m

remote-content-info =
    .value = Tetamäx ch'aqa' chik chi kij ri taq ruk'ayewal richinanem näj rupam

web-content = Ajk'amaya'l Rupam

history-label =
    .label = Kenatäx ajk'amaya'l ruxaq chuqa' taq ximonel enutz'eton
    .accesskey = K

cookies-label =
    .label = Kek'ulutäj taq rukaxlanwey ri ruxaq k'amaya'l
    .accesskey = K

third-party-label =
    .value = Kek'ul taq kaxlanwey kichin aj rox winaqi':
    .accesskey = k

third-party-always =
    .label = Junelïk
third-party-never =
    .label = Majub'ey
third-party-visited =
    .label = Etz'eton

keep-label =
    .value = Tik'oje' k'a:
    .accesskey = k

keep-expire =
    .label = tik'o kiq'ij
keep-close =
    .label = Tintz'apij { -brand-short-name }
keep-ask =
    .label = junelïk tik'utüx pe chwe

cookies-button =
    .label = Kek'ut taq Kaxlanwey…
    .accesskey = k

do-not-track-label =
    .label = Ketaq ri taq ruxaq ajk'amaya'l jun “Mani Tojqäx” raqän kumal chi man nojowäx ta chi tikanöx
    .accesskey = t

learn-button =
    .label = Tetamäx ch'aqa' chik

passwords-description = { -brand-short-name } nitikïr yerunataj ri ewan taq atzij kichin konojel ri taq rub'i' ataqoya'l.

passwords-button =
    .label = Xeyak taq Ewan Tzij…
    .accesskey = X

master-password-description = Jun Ajtij Ewan Tzij yeruchajij konojel ri ewan taq atzij, xa xe chi k'o chi natz'ib'aj jub'ey chi jujun molojri'ïl.

master-password-label =
    .label = Tokisäx ri ajtïj ewan tzij
    .accesskey = o

master-password-button =
    .label = Tijal Ajtij Ewan Tzij…
    .accesskey = j


junk-description = Runuk'ulem k'o wi pa seq' taqoya'l. Ri taq runuk'ulem chi kijujunal ri taq taqoya'l k'o chi yeb'an pa Kinuk'ulem Rub'i' Taqoya'l.

junk-label =
    .label = Toq ninya' ketal taq rutzijol achi'el seq':
    .accesskey = T

junk-move-label =
    .label = Kesilöx pa kiyakwuj "Seq'" rub'i' taqoya'l
    .accesskey = o

junk-delete-label =
    .label = Keyuj
    .accesskey = K

junk-read-label =
    .label = Tiya' ketal ri taq rutzijol yetz'et chi e Seq' achi'el esik'in chik
    .accesskey = T

junk-log-label =
    .label = Titzij ri kitz'ib'axik ruchayub'al k'amonel seq'
    .accesskey = T

junk-log-button =
    .label = Tik'ut pe tz'ib'anïk
    .accesskey = T

reset-junk-button =
    .label = Titzolïx Tojtob'enïk
    .accesskey = T

phishing-description = { -brand-short-name } nitikïr yerunik'oj taq rutzijol toq yerukanoj ruq'ab'axel ruq'oloj taqoya'l akuchi' yerukanoj ri etamanel taq kob'eyal achoq ik'in yatkiq'öl.

phishing-label =
    .label = Tiya' pe rutzijol chwe we ri rutzijol ninsik'ij rik'in jub'a' jun eleq'
    .accesskey = T

antivirus-description = { -brand-short-name } nitikïr yeruto' ri chapöy chikopil chi tikinik'oj ri taqoya'l chuwäch yeyak qa.

antivirus-label =
    .label = Tiya' q'ij chi ke ri chapöy chikopil kekiya' pa kawinaqinem chi jujun taq rutzijol
    .accesskey = T

certificate-description = Toq ri ruk'u'x samaj xtrajo' pe ri ruwujil nub'i':

certificate-auto =
    .label = Pa ruyonil ticha' jun
    .accesskey = t

certificate-ask =
    .label = Junelïk tik'utüx pe chwe
    .accesskey = t

ocsp-label =
    .label = Rutzolixik rutzij ri OCSP peyon tzij, ri ruk'u'x taq samaj nikijikib'a' ri kutzil ri taq ruwujil rub'i'
    .accesskey = R

certificate-button =
    .label = Kenuk'samajiïx Kiwujil B'i'aj…
    .accesskey = K

security-devices-button =
    .label = Taq Rokisab'al Jikomal…
    .accesskey = R

## Chat Tab

startup-label =
    .value = Toq { -brand-short-name } xtitikirisäx:
    .accesskey = x

offline-label =
    .label = Tichup kokem ri Chat Rub'i' Nutaqoya'l

auto-connect-label =
    .label = Pa ruyonil tokisäx ri chat rub'i' nutaqoya'l

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Tib'an chi ri kib'i' wachib'il tiqetamaj chi man in k'o ta chi rij ri
    .accesskey = I

idle-time-label = ch'utiramaj man k'o ta

##

away-message-label =
    .label = chuqa' tijikib'äx ri nub'anikil achi'el Mek'o rik'in re rutzijol b'anikil re':
    .accesskey = A

send-typing-label =
    .label = Titaq tz'ib'anem rutzijol pa taq tzijonem
    .accesskey = t

notification-label = Toq ye'apon taq rutzijol chawe:

show-notification-label =
    .label = Tik'ut jun rutzijol:
    .accesskey = k

notification-all =
    .label = rik'in rub'i' taqonel chuqa' nab'ey rutzub'al tzijol
notification-name =
    .label = xa xe rik'in rub'i' taqonel
notification-empty =
    .label = majun chik etamab'äl

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Tisilöx ruwachib'al dock
           *[other] Tiyuk'umäx ri ruch'akulal kikajtz'ik samaj
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] T
        }

chat-play-sound-label =
    .label = Titzij jun k'oxom
    .accesskey = m

chat-play-button =
    .label = Titzij
    .accesskey = T

chat-system-sound-label =
    .label = Ruk'oxom q'inoj k'o wi richin k'ak'a' taqoya'l
    .accesskey = R

chat-custom-sound-label =
    .label = Tokisäx re ruyakb'al k'oxom re'
    .accesskey = T

chat-browse-sound-button =
    .label = Tokik'amayin…
    .accesskey = T

theme-label =
    .value = Wachinïk:
    .accesskey = W

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Taq roqowinïk
style-dark =
    .label = Q'equ'm
style-paper =
    .label = Taq Ruxaq Wuj
style-simple =
    .label = Relik

preview-label = Nab'ey tzub'al:
no-preview-label = Majun nab'ey rutzub'al
no-preview-description = Man okel ta re wachinïk re' o man wachel ta wakami (chupül tz'aqat, ütz-rub'anikil, …).

chat-variant-label =
    .value = Rujalik:
    .accesskey = R

chat-header-label =
    .label = Tik'ut Jub'i'aj
    .accesskey = J

## Preferences UI Search Results


## Preferences UI Search Results

