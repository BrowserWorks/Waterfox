# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Zacyniś

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Nastajenja
           *[other] Nastajenja
        }

pane-general-title = Powšykne
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Pisaś
category-compose =
    .tooltiptext = Pisaś

pane-privacy-title = Priwatnosć a wěstota
category-privacy =
    .tooltiptext = Priwatnosć a wěstota

pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat

pane-calendar-title = Kalender
category-calendar =
    .tooltiptext = Kalender

general-language-and-appearance-header = Rěc a wuglěd

general-incoming-mail-header = Dochadajuce mejlki

general-files-and-attachment-header = Dataje a pśidanki

general-tags-header = Wobznamjenja

general-reading-and-display-header = Cytanje a zwobraznjenje

general-updates-header = Aktualizacije

general-network-and-diskspace-header = Seś a platowy rum

general-indexing-label = Indeksěrowanje

composition-category-header = Pisaś

composition-attachments-header = Pśidanki

composition-spelling-title = Pšawopis

compose-html-style-title = HTML-stil

composition-addressing-header = Adresěrowanje

privacy-main-header = Priwatnosć

privacy-passwords-header = Gronidła

privacy-junk-header = Cajk

collection-header = Gromaźenje a wužywanje datow { -brand-short-name }

collection-description = Comy was z wuběrkami wobstaraś a janož to zběraś, což musymy póbitowaś, aby my { -brand-short-name } za kuždego pólěpšili. Pšosymy pśecej wó dowólnosć, nježli až wósobinske daty dostanjomy.
collection-privacy-notice = Powěźeńka priwatnosći

collection-health-report-telemetry-disabled = Sćo zajmjeł { -vendor-short-name } dowólnosć, techniske a interakciske daty gromaźiś. Wšykne dotychměst zgromaźone daty se w běgu 30 dnjow wulašuju.
collection-health-report-telemetry-disabled-link = Dalšne informacije

collection-health-report =
    .label = { -brand-short-name } zmóžniś, techniske a interakciske daty na { -vendor-short-name } pósłaś
    .accesskey = m
collection-health-report-link = Dalšne informacije

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Datowe rozpšawjenje jo znjemóžnjone za toś tu programowu konfiguraciju

collection-backlogged-crash-reports =
    .label = { -brand-short-name } dowóliś, njewobźěłane wowaleńske rozpšawy we wašom mjenju pósłaś
    .accesskey = r
collection-backlogged-crash-reports-link = Dalšne informacije

privacy-security-header = Wěstota

privacy-scam-detection-title = Nadejźenje wobšudy

privacy-anti-virus-title = Antiwirusowy program

privacy-certificates-title = Certifikaty

chat-pane-header = Chat

chat-status-title = Status

chat-notifications-title = Zdźělenja

chat-pane-styling-header = Formatěrowanje

choose-messenger-language-description = Wubjeŕśo rěcy, kótarež se wužywaju, aby menije, powěsći a powěźeńki z { -brand-short-name } pokazali.
manage-messenger-languages-button =
    .label = Alternatiwy definěrowaś…
    .accesskey = l
confirm-messenger-language-change-description = Startujśo { -brand-short-name } znowego, aby toś te změny nałožył
confirm-messenger-language-change-button = Nałožyś a znowego startowaś

update-setting-write-failure-title = Zmólka pśi składowanju aktualizěrowańskich nastajenjow

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } jo starcył na zmólku a njejo toś tu změnu składł. Źiwajśo na to, až se toś to aktualizěrowańske nastajenje pisańske pšawo za slědujucu dataju pomina. Wy abo systemowy administrator móžotej zmólku pórěźiś, gaž wužywarskej kupce połnu kontrolu nad toś teju dataju dajotej.
    
    Njedajo se do dataje pisaś: { $path }

update-in-progress-title = Aktualizacija běžy

update-in-progress-message = Cośo, až { -brand-short-name } z toś teju aktualizaciju pókšacujo?

update-in-progress-ok-button = &Zachyśiś
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Dalej

addons-button = Rozšyrjenja a drastwy

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Zapódajśo swóje pśizjawjeńske daty Windows, aby głowne gronidło napórał. To wěstotu wašych kontow šćita.

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = głowne gronidło napóraś

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Zapódajśo swóje pśizjawjeńske daty Windows, aby głowne gronidło napórał. To wěstotu wašych kontow šćita.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = głowne gronidło napóraś

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name } startowy bok

start-page-label =
    .label = Gaž { -brand-short-name } se startujo, startowy bok w powěsćowym póli pokazaś
    .accesskey = G

location-label =
    .value = Městno:
    .accesskey = M
restore-default-label =
    .label = Standard wótnowiś
    .accesskey = S

default-search-engine = Standardna pytnica
add-search-engine =
    .label = Z dataje pśidaś
    .accesskey = Z
remove-search-engine =
    .label = Wótwónoźeś
    .accesskey = t

minimize-to-tray-label =
    .label = Gaž { -brand-short-name } jo miniměrowany, pśesuńśo jen do wótkładnice.
    .accesskey = m

new-message-arrival = Gaž se nowe powěsći dojdu:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Slědujucu zukowu dataju wužywaś:
           *[other] Zuk wótgraś
        }
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] u
        }
mail-play-button =
    .label = Wótgraś
    .accesskey = g

change-dock-icon = Nastajenja za nałožeński symbol změniś
app-icon-options =
    .label = Nastajenja nałožeńskego symbola…
    .accesskey = N

notification-settings = Warnowanja a standardny zukk daju se w zdźěleńskem woknje systemowych nastajenjow znjemóžniś.

animated-alert-label =
    .label = Powěźeńku pokazaś
    .accesskey = P
customize-alert-label =
    .label = Pśiměriś…
    .accesskey = m

tray-icon-label =
    .label = Symbol we wótkładnicy pokazaś
    .accesskey = t

mail-system-sound-label =
    .label = Standardny systemowy zuk za nowu e-mail
    .accesskey = S
mail-custom-sound-label =
    .label = Slědujucu zukowu dataju wužywaś
    .accesskey = S
mail-browse-sound-button =
    .label = Pśepytaś…
    .accesskey = P

enable-gloda-search-label =
    .label = Globalne pytanje a indicěrowanje zmóžniś
    .accesskey = G

datetime-formatting-legend = Formatěrowanje datuma a casa
language-selector-legend = Rěc

allow-hw-accel =
    .label = Hardwarowe póspěšenje wužywaś, jolic jo k dispoziciji
    .accesskey = H

store-type-label =
    .value = Sładowański typ powěsćow za nowe konta:
    .accesskey = t

mbox-store-label =
    .label = Dataja na zarědnik (mbox)
maildir-store-label =
    .label = Dataja na powěsć (maildir)

scrolling-legend = Pśesuwanje
autoscroll-label =
    .label = Awtomatiske pśesuwanje wužywaś
    .accesskey = A
smooth-scrolling-label =
    .label = Pólažke pśesuwanje wužywaś
    .accesskey = l

system-integration-legend = Systemowa integracija
always-check-default =
    .label = Pśi startowanju pśecej kontrolěrowaś, lěc { -brand-short-name } jo standardny e-mailowy program
    .accesskey = P
check-default-button =
    .label = Něnto kontrolěrowaś…
    .accesskey = N

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windowsowe pytanje
       *[other] { "" }
    }

search-integration-label =
    .label = { search-engine-name } za pytanje za powěsćami dowóliś
    .accesskey = t

config-editor-button =
    .label = Konfiguraciski editor…
    .accesskey = K

return-receipts-description = Póstajiś, kak { -brand-short-name } ma z wobtwarźenjami dostaśa wobchadaś
return-receipts-button =
    .label = Wobtwarźenja dostaśa…
    .accesskey = t

update-app-legend = Aktualizacije { -brand-short-name }

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Wersija { $version }

allow-description = { -brand-short-name } zmóžniś:
automatic-updates-label =
    .label = Aktualizacije awtomatiski instalěrowaś (pśiraźijo se: pólěpšona wěstota)
    .accesskey = A
check-updates-label =
    .label = Aktualizacije pytaś, ale rozsud mě pśewóstajiś, lěc maju se instalěrowaś
    .accesskey = c

update-history-button =
    .label = Historiju aktualizacijow pokazaś
    .accesskey = H

use-service =
    .label = Slězynowu słužbu za instalěrowanje aktualizacijow wužywaś
    .accesskey = z

cross-user-udpate-warning = Toś to nastajenje se na wšykne konta Windows nałožyjo a na profile { -brand-short-name }, kótarež toś tu instalaciju { -brand-short-name } wužywaju.

networking-legend = Zwisk
proxy-config-description = Konfigurěrowaś, kak { -brand-short-name } zwězujo z Internetom

network-settings-button =
    .label = Nastajenja…
    .accesskey = N

offline-legend = Offline
offline-settings = Nastajenja za offline konfigurěrowaś

offline-settings-button =
    .label = Offline…
    .accesskey = O

diskspace-legend = Platowy rum
offline-compact-folder =
    .label = Wšykne zarědniki zgusćiś, gaž wopśimuju
    .accesskey = z

compact-folder-size =
    .value = MB dogromady

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Až k
    .accesskey = A

use-cache-after = MB platowego ruma za pufrowak wužywaś

##

smart-cache-label =
    .label = Awtomatiske zastojanje pufrowaka pśepisaś
    .accesskey = m

clear-cache-button =
    .label = Něnto wuprozniś
    .accesskey = u

fonts-legend = Pisma a barwy

default-font-label =
    .value = Standardne pismo:
    .accesskey = S

default-size-label =
    .value = Wjelikosć:
    .accesskey = W

font-options-button =
    .label = Rozšyrjone…
    .accesskey = R

color-options-button =
    .label = Barwy…
    .accesskey = B

display-width-legend = Powěsći lutnego teksta

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Emotikony ako wobraze zwobrazniś
    .accesskey = E

display-text-label = Gaž citěrowane lutne teksty se pokazuju:

style-label =
    .value = Stil:
    .accesskey = i

regular-style-item =
    .label = Regularny
bold-style-item =
    .label = Tucny
italic-style-item =
    .label = Kursiwny
bold-italic-style-item =
    .label = Tucny kursiwny

size-label =
    .value = Wjelikosć:
    .accesskey = l

regular-size-item =
    .label = Regularny
bigger-size-item =
    .label = Wětšy
smaller-size-item =
    .label = Mjeńšy

quoted-text-color =
    .label = Barwa:
    .accesskey = B

search-input =
    .placeholder = Pytać

type-column-label =
    .label = Typ wopśimjeśa
    .accesskey = T

action-column-label =
    .label = Akcija
    .accesskey = A

save-to-label =
    .label = Dataje składowaś do
    .accesskey = D

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Wubraś…
           *[other] Pśepytaś…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] u
           *[other] P
        }

always-ask-label =
    .label = Pśecej se pšašaś, gaž maju se dataje składowaś
    .accesskey = m


display-tags-text = Wobznamjenja daju se wužywaś, aby waše powěsći kategorizěrowali a prioritaty stajili.

new-tag-button =
    .label = Nowy…
    .accesskey = N

edit-tag-button =
    .label = Wobźěłaś…
    .accesskey = b

delete-tag-button =
    .label = Wulašowaś
    .accesskey = l

auto-mark-as-read =
    .label = Powěsći awtomatiski ako pśecytane markěrowaś
    .accesskey = P

mark-read-no-delay =
    .label = Ned pśi zwobraznjenju
    .accesskey = N

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Pó zwobraznjenju za
    .accesskey = z

seconds-label = sekundow

##

open-msg-label =
    .value = Powěsći wócyniś w:

open-msg-tab =
    .label = nowem rejtariku
    .accesskey = r

open-msg-window =
    .label = nowem powěsćowem woknje
    .accesskey = n

open-msg-ex-window =
    .label = eksistěrujucem powěsćowem woknje
    .accesskey = e

close-move-delete =
    .label = Powěsćowe wokno/Powěsćowy rejtarik pśi pśesuwanju abo lašowanju zacyniś
    .accesskey = P

display-name-label =
    .value = Zwobraznjone mě:

condensed-addresses-label =
    .label = Jano zwobraznjeńske mě za luźe w adresniku pokazaś
    .accesskey = J

## Compose Tab

forward-label =
    .value = Powěsći dalej pósrědniś:
    .accesskey = d

inline-label =
    .label = Zasajźony

as-attachment-label =
    .label = Ako pśidank

extension-label =
    .label = Sufiks datajowemu mjenjoju pśidaś
    .accesskey = u

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Awtomatiski składowaś kužde
    .accesskey = s

auto-save-end = minutow

##

warn-on-send-accel-key =
    .label = Wobkšuśiś, gaž tastowa skrotconka wužywa se za słanje powěsći
    .accesskey = t

spellcheck-label =
    .label = Pšawopis do słanja kontrolěrowaś
    .accesskey = P

spellcheck-inline-label =
    .label = Pšawopis pśi zapódaśu kontrolěrowaś
    .accesskey = z

language-popup-label =
    .value = Rěc:
    .accesskey = R

download-dictionaries-link = Dalšne słowniki ześěgnuś

font-label =
    .value = Pismo:
    .accesskey = P

font-size-label =
    .value = Wjelikosć:
    .accesskey = l

default-colors-label =
    .label = Standardne barwy cytaka wužywaś
    .accesskey = d

font-color-label =
    .value = Tekstowa barwa:
    .accesskey = T

bg-color-label =
    .value = Slězynowa barwa:
    .accesskey = z

restore-html-label =
    .label = Standardy wótnowiś
    .accesskey = S

default-format-label =
    .label = Pó standarźe wótstawkowy format město wopśimjeśowego teksta wužywaś
    .accesskey = P

format-description = Zaźaržanje tekstowego formata konfigurěrowaś

send-options-label =
    .label = Wótesćełańske nastajenja…
    .accesskey = t

autocomplete-description = Pśi adresěrowanju powěsći za pśigódnymi zapiskami pytaś:

ab-label =
    .label = w lokalnych adresnikach
    .accesskey = l

directories-label =
    .label = Zapisowy serwer:
    .accesskey = Z

directories-none-label =
    .none = Žeden

edit-directories-label =
    .label = Zapise wobźěłaś…
    .accesskey = b

email-picker-label =
    .label = Městno za awtomatiske dodanje adresow wuchadajuceje e-maila:
    .accesskey = M

default-directory-label =
    .value = Standardny startowy zapis we woknje adresnika:
    .accesskey = S

default-last-label =
    .none = Slědny wužyty zapis

attachment-label =
    .label = Za felujucymi pśidankami pytaś
    .accesskey = f

attachment-options-label =
    .label = Klucowe słowa…
    .accesskey = K

enable-cloud-share =
    .label = Póbitowaś, aby dataje źělił, kótarež su wětše ako
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Pśidaś…
    .accesskey = d
    .defaultlabel = Pśidaś…

remove-cloud-account =
    .label = Wótpóraś
    .accesskey = W

find-cloud-providers =
    .value = Dalšnych póbitowarjow namakaś…

cloud-account-description = Nowu składowańsku słužbu Filelink pśidaś


## Privacy Tab

mail-content = E-mailowe wopśimjeśe

remote-content-label =
    .label = Daloke wopśimjeśe w powěsćach dowóliś
    .accesskey = o

exceptions-button =
    .label = Wuwześa…
    .accesskey = u

remote-content-info =
    .value = Zgońśo wěcej wó problemach priwatnosći dalokego wopśimjeśa

web-content = Webwopśimjeśe

history-label =
    .label = Woglědane websedła a wótkaze se spomnjeś
    .accesskey = l

cookies-label =
    .label = Cookieje ze sedłow akceptěrowaś
    .accesskey = C

third-party-label =
    .value = Cookieje tśeśich póbitowarjow akceptěrowaś:
    .accesskey = C

third-party-always =
    .label = Pśecej
third-party-never =
    .label = Nigda
third-party-visited =
    .label = Wót woglědanych tśeśich póbitowarjow

keep-label =
    .value = Wobchowaś:
    .accesskey = b

keep-expire =
    .label = až njepśepadnu
keep-close =
    .label = až { -brand-short-name } se njezacynja
keep-ask =
    .label = Kuždy raz se pšašaś

cookies-button =
    .label = Cookieje pokazaś…
    .accesskey = o

do-not-track-label =
    .label = Websedłam signal “Njeslědowaś” pósłaś, až njocośo, až wóne was slěduju
    .accesskey = s

learn-button =
    .label = Dalšne informacije

passwords-description = { -brand-short-name } móžo gronidła za wšykne waše konta składowaś.

passwords-button =
    .label = Składowane gronidła…
    .accesskey = S

master-password-description = Głowne gronidło šćita wšykne waše gronidła, ale musyśo jo jaden raz na pósejźenje zapódaś.

master-password-label =
    .label = Głowne gronidło wužywaś
    .accesskey = G

master-password-button =
    .label = Głowne gronidło změniś…
    .accesskey = o


primary-password-description = Głowne gronidło šćita wšykne waše gronidła, ale musyśo jo jaden raz na pósejźenje zapódaś.

primary-password-label =
    .label = Głowne gronidło wužywaś
    .accesskey = G

primary-password-button =
    .label = Głowne gronidło změniś…
    .accesskey = z

forms-primary-pw-fips-title = Sćo tuchylu we FIPS-modusu. FIPS pomina se głowne gronidło.
forms-master-pw-fips-desc = Změnjanje gronidła njejo se raźiło


junk-description = Nastajśo swóje standardne nastajenja za cajkowu e-mail. Nastajenja cajkoweje e-maile, specifiske za konto, daju se w kontowych nastajenjach konfigurěrowaś.

junk-label =
    .label = Gaž powěsći markěruju se ako cajk:
    .accesskey = G

junk-move-label =
    .label = Je do kontowego zarědnika "Cajk" pśesunuś
    .accesskey = k

junk-delete-label =
    .label = Je lašowaś
    .accesskey = l

junk-read-label =
    .label = Powěsći, kótarež su cajk, ako pśecytane markěrowaś
    .accesskey = P

junk-log-label =
    .label = Protokolěrowanje pśiměrjobnego cajkowego filtra změniś
    .accesskey = r

junk-log-button =
    .label = Protokol pokazaś
    .accesskey = t

reset-junk-button =
    .label = Treněrowańske daty slědk stajiś
    .accesskey = d

phishing-description = { -brand-short-name } móžo powěsći za pódglědneju e-mailoweju wobšudu analyzěrowaś, z tym až pyta za zwuconymi technikami, kótarež se wužywaju, aby wam wobšuźili.

phishing-label =
    .label = K wěsći daś, lěc powěsć, kótaraž so cyta, jo pódglědna e-mailowa wobšuda
    .accesskey = K

antivirus-description = { -brand-short-name } móžo antiwirusowej softwarje wólažcyś, dochadajuce e-mailowe powěsći za wirusami analyzěrowaś, nježli až se lokalnje składuju.

antivirus-label =
    .label = Antiwirusowym programam dowóliś, jadnotliwe dochadajuce powěsći pód karantenu stajiś
    .accesskey = A

certificate-description = Gaž serwer pomina se wósobinski certifikat:

certificate-auto =
    .label = Někaki awtomatiski wubraś
    .accesskey = N

certificate-ask =
    .label = Kuždy raz se pšašaś
    .accesskey = K

ocsp-label =
    .label = Pla wótegronowych serwerow OCSP se napšašowaś, aby se aktualna płaśiwosć certifikatow wobkšuśiło
    .accesskey = P

certificate-button =
    .label = Certifikaty zastojaś…
    .accesskey = C

security-devices-button =
    .label = Wěstotne rědy…
    .accesskey = W

## Chat Tab

startup-label =
    .value = Gaž { -brand-short-name } startujo:
    .accesskey = s

offline-label =
    .label = Chatowe konto offline wóstajiś

auto-connect-label =
    .label = Chatowe konta awtomatiski zwězaś

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Kontakty informěrowaś, až som pótom
    .accesskey = i

idle-time-label = minutow pšec

##

away-message-label =
    .label = a stajśo mój status na Pšec z toś teju statusoweju powěsću:
    .accesskey = P

send-typing-label =
    .label = W konwersaciji powěźeńki pisaś
    .accesskey = k

notification-label = Gaž powěsći za was pśichadaju:

show-notification-label =
    .label = Powěźeńku pokazaś:
    .accesskey = w

notification-all =
    .label = z mjenim wótpósłarja a powěsćowym pśeglědom
notification-name =
    .label = jano z mjenim wótpósłarja
notification-empty =
    .label = bźez někakich informacijow

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Dokowy symbol animěrowaś
           *[other] Zapisk nadawkoweje rědki zablendowaś
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] Z
        }

chat-play-sound-label =
    .label = Zuk wótgraś
    .accesskey = u

chat-play-button =
    .label = Wótgraś
    .accesskey = W

chat-system-sound-label =
    .label = Standardny systemowy zuk za nowu e-mail
    .accesskey = S

chat-custom-sound-label =
    .label = Slědujucu zukowu dataju wužywaś
    .accesskey = S

chat-browse-sound-button =
    .label = Pśepytaś…
    .accesskey = P

theme-label =
    .value = Drastwa:
    .accesskey = D

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Puchorje
style-dark =
    .label = Śamny
style-paper =
    .label = Łopjena papjery
style-simple =
    .label = Jadnora

preview-label = Pśeglěd:
no-preview-label = Žeden pśeglěd k dispoziciji
no-preview-description = Toś ta drastwa njejo płaśiwa abo njejo tuchylu k dispoziciji (žnjemóžnjony dodank, wěsty modus …).

chat-variant-label =
    .value = Warianta:
    .accesskey = W

chat-header-label =
    .label = Głowu pokazaś
    .accesskey = G

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] W nastajenjach pytaś
           *[other] W nastajenjach pytaś
        }

## Preferences UI Search Results

search-results-header = Pytańske wuslědki

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Bóžko žedne wuslědki njejsu w nastajenjach za “<span data-l10n-name="query"></span>”.
       *[other] Bóžko žedne wuslědki njejsu w nastajenjach za “<span data-l10n-name="query"></span>”.
    }

search-results-help-link = Trjebaśo pomoc? Woglědajśo k <a data-l10n-name="url">Pomoc za { -brand-short-name }</a>

## Preferences UI Search Results

