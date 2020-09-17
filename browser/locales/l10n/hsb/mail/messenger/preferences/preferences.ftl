# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Začinić
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Nastajenja
           *[other] Nastajenja
        }
pane-general-title = Powšitkowne
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = Pisać
category-compose =
    .tooltiptext = Pisać
pane-privacy-title = Priwatnosć a wěstota
category-privacy =
    .tooltiptext = Priwatnosć a wěstota
pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat
pane-calendar-title = Protyka
category-calendar =
    .tooltiptext = Protyka
general-language-and-appearance-header = Rěč a zwonkowne
general-incoming-mail-header = Dochadźace mejlki
general-files-and-attachment-header = Dataje a přiwěški
general-tags-header = Znački
general-reading-and-display-header = Čitanje a zwobraznjenje
general-updates-header = Aktualizacije
general-network-and-diskspace-header = Syć a tačelowy rum
general-indexing-label = Indeksowanje
composition-category-header = Pisać
composition-attachments-header = Přiwěški
composition-spelling-title = Prawopis
compose-html-style-title = HTML-stil
composition-addressing-header = Adresować
privacy-main-header = Priwatnosć
privacy-passwords-header = Hesła
privacy-junk-header = Čapor
collection-header = Hromadźenje a wužiwanje datow { -brand-short-name }
collection-description = Chcemy was z wuběrami wobstarać a jenož to zběrać, štož dyrbimy poskićić, zo bychmy { -brand-short-name } za kóždeho polěpšili. Prosymy přeco wo dowolnosć, prjedy hač wosobinske daty dóstanjemy.
collection-privacy-notice = Zdźělenka priwatnosće
collection-health-report-telemetry-disabled = Sće { -vendor-short-name } dowolnosć zebrał, techniske a interakciske daty hromadźić. Wšě dotal zhromadźene daty so w běhu 30 dnjow zhašeja.
collection-health-report-telemetry-disabled-link = Dalše informacije
collection-health-report =
    .label = { -brand-short-name } zmóžnić, techniske a interakciske daty na { -vendor-short-name } pósłać
    .accesskey = t
collection-health-report-link = Dalše informacije
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Datowe rozprawjenje je znjemóžnjene za tutu programowu konfiguraciju
collection-backlogged-crash-reports =
    .label = { -brand-short-name } dowolić, njewobdźěłane spadowe rozprawy we wašim mjenje pósłać
    .accesskey = s
collection-backlogged-crash-reports-link = Dalše informacije
privacy-security-header = Wěstota
privacy-scam-detection-title = Wotkrywanje wobšudstwa
privacy-anti-virus-title = Antiwirusowy program
privacy-certificates-title = Certifikaty
chat-pane-header = Chat
chat-status-title = Status
chat-notifications-title = Zdźělenja
chat-pane-styling-header = Formatowanje
choose-messenger-language-description = Wubjerće rěče, kotrež so wužiwaja, zo bychu menije, powěsće a zdźělenki z { -brand-short-name } pokazali.
manage-messenger-languages-button =
    .label = Alternatiwy definować…
    .accesskey = l
confirm-messenger-language-change-description = Startujće { -brand-short-name } znowa. zo byšće tute změny nałožił
confirm-messenger-language-change-button = Nałožić a znowa startować
update-setting-write-failure-title = Zmylk při składowanju aktualizowanskich nastajenjow
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } je na zmylk storčił a njeje tutu změnu składował. Dźiwajće na to, zo sej tute aktualizowanske nastajenje pisanske prawo za slědowacu dataju wužaduje. Wy abo systemowy administrator móžetej zmylk porjedźić, hdyž wužiwarskej skupinje połnu kontrolu nad tutej dataju datej.
    
    Njeda so do dataje pisać: { $path }
update-in-progress-title = Aktualizacija běži
update-in-progress-message = Chceće, zo { -brand-short-name } z tutej aktualizaciju pokročuje?
update-in-progress-ok-button = &Zaćisnyć
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Dale
addons-button = Rozšěrjenja a drasty

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Zapodajće swoje přizjewjenske daty Windows, zo byšće hłowne hesło wutworił. To wěstotu wašich kontow škita.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = hłowne hesło wutworić
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Zapodajće swoje přizjewjenske daty Windows, zo byšće hłowne hesło wutworił. To wěstotu wašich kontow škita.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = Hłowne hesło wutworić
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend = { -brand-short-name } - startowa strona
start-page-label =
    .label = Hdyž so { -brand-short-name } startuje, startowa strona w powěsćym wobłuku pokazać
    .accesskey = H
location-label =
    .value = Městno:
    .accesskey = M
restore-default-label =
    .label = Standard wobnowić
    .accesskey = b
default-search-engine = Standardna pytawa
add-search-engine =
    .label = Z dataje přidać
    .accesskey = Z
remove-search-engine =
    .label = Wotstronić
    .accesskey = t
minimize-to-tray-label =
    .label = Hdyž { -brand-short-name } je miniměrowany, přesuńće jón do žłobika.
    .accesskey = m
new-message-arrival = Hdyž nowe powěsće dochadźeja:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Slědowacu zynkowu dataju wužić:
           *[other] Zynk wotehrać
        }
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] y
        }
mail-play-button =
    .label = Wotehrać
    .accesskey = h
change-dock-icon = Nastajenja za nałoženski symbol změnić
app-icon-options =
    .label = Nastajenja nałoženskeho symbola…
    .accesskey = N
notification-settings = Warnowanja a standardny zynk dadźa so w zdźělenskim woknje systemowych nastajenjow znjemóžnić.
animated-alert-label =
    .label = Warnowanje pokazać
    .accesskey = W
customize-alert-label =
    .label = Přiměrić…
    .accesskey = i
tray-icon-label =
    .label = Symbol w žłobiku pokazać
    .accesskey = S
mail-system-sound-label =
    .label = Standardny sytemowy zynk za nowu e-mejl
    .accesskey = S
mail-custom-sound-label =
    .label = Slědowacu zynkowu dataju wužić
    .accesskey = l
mail-browse-sound-button =
    .label = Přepytać…
    .accesskey = P
enable-gloda-search-label =
    .label = Globalne pytanje a indeksowanje zmóžnić
    .accesskey = G
datetime-formatting-legend = Formatowanje datuma a časa
language-selector-legend = Rěč
allow-hw-accel =
    .label = Hardwarowe pospěšenje wužiwać, jeli je k dispoziciji
    .accesskey = H
store-type-label =
    .value = Sładowanski typ powěsćow za nowe konta:
    .accesskey = t
mbox-store-label =
    .label = Dataja na rjadowak (mbox)
maildir-store-label =
    .label = Dataja na powěsć (maildir)
scrolling-legend = Přesuwanje
autoscroll-label =
    .label = Awtomatiske přesuwanje wužiwać
    .accesskey = A
smooth-scrolling-label =
    .label = Łahodne přesuwanje wužiwać
    .accesskey = h
system-integration-legend = Systemowa integracija
always-check-default =
    .label = Při startowanju přeco kontrolować, hač { -brand-short-name } je standardny e-mejlowy program
    .accesskey = P
check-default-button =
    .label = Nětko kontrolować…
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
    .label = { search-engine-name } za pytanje za powěsćemi dowolić
    .accesskey = t
config-editor-button =
    .label = Konfiguraciski editor…
    .accesskey = K
return-receipts-description = Postajić, kak { -brand-short-name } ma z wobkrućenjemi přijeća wobeńć
return-receipts-button =
    .label = Wobkrućenja přijeća…
    .accesskey = k
update-app-legend = Aktualizacije { -brand-short-name }
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Wersija { $version }
allow-description = { -brand-short-name } zmóžnić:
automatic-updates-label =
    .label = Aktualizacije awtomatisce instalować (poruča so: polěpšena wěstota)
    .accesskey = A
check-updates-label =
    .label = Aktualizacije pytać, ale rozsud mi přewostajić, hač maja so instalować
    .accesskey = c
update-history-button =
    .label = Historiju aktualizacijow pokazać
    .accesskey = H
use-service =
    .label = Pozadkowu słužbu za instalowanje aktualizacijow wužiwać
    .accesskey = z
cross-user-udpate-warning = Tute nastajenje so na wšě konta Windows nałoži a na profile { -brand-short-name }, kotrež tutu instalaciju { -brand-short-name } wužiwaja.
networking-legend = Zwisk
proxy-config-description = Konfigurować, kak { -brand-short-name } z Internetom zwjazuje
network-settings-button =
    .label = Nastajenja…
    .accesskey = N
offline-legend = Offline
offline-settings = Nastajenja za offline konfigurować
offline-settings-button =
    .label = Offline…
    .accesskey = O
diskspace-legend = Tačelowy rum
offline-compact-folder =
    .label = Wšě rjadowaki zhusćić, hdyž wopřijimaja so přez
    .accesskey = h
compact-folder-size =
    .value = MB dohromady

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Hač k
    .accesskey = H
use-cache-after = MB tačeloweho ruma za pufrowak wužiwać

##

smart-cache-label =
    .label = Awtomatiske rjadowanje pufrowaka přepisać
    .accesskey = m
clear-cache-button =
    .label = Nětko wuprózdnić
    .accesskey = u
fonts-legend = Pisma a barby
default-font-label =
    .value = Standardne pismo:
    .accesskey = S
default-size-label =
    .value = Wulkosć:
    .accesskey = W
font-options-button =
    .label = Rozšěrjeny…
    .accesskey = R
color-options-button =
    .label = Barby…
    .accesskey = B
display-width-legend = Powěsće luteho teksta
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Emotikony jako wobrazy zwobraznić
    .accesskey = E
display-text-label = Hdyž so citowane lute teksty pokazuja:
style-label =
    .value = Stil:
    .accesskey = i
regular-style-item =
    .label = Regularny
bold-style-item =
    .label = Tołsty
italic-style-item =
    .label = Kursiwny
bold-italic-style-item =
    .label = Tołsty kursiwny
size-label =
    .value = Wulkosć:
    .accesskey = l
regular-size-item =
    .label = Regularny
bigger-size-item =
    .label = Wjetši
smaller-size-item =
    .label = Mjeńši
quoted-text-color =
    .label = Barba:
    .accesskey = B
search-input =
    .placeholder = Pytać
type-column-label =
    .label = Typ wobsaha
    .accesskey = T
action-column-label =
    .label = Akcija
    .accesskey = A
save-to-label =
    .label = Dataje składować do
    .accesskey = s
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Wubrać…
           *[other] Přepytać…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] u
           *[other] P
        }
always-ask-label =
    .label = Přeco so prašeć, hdźež maja so dataje składować
    .accesskey = h
display-tags-text = Znački dadźa so wužić, zo bychu waše powěsće kategorizowali a prioritaty stajili.
new-tag-button =
    .label = Nowy…
    .accesskey = N
edit-tag-button =
    .label = Wobdźěłać…
    .accesskey = b
delete-tag-button =
    .label = Zhašeć
    .accesskey = Z
auto-mark-as-read =
    .label = Powěsće awtomatisce jako přečitane markěrować
    .accesskey = P
mark-read-no-delay =
    .label = Hnydom při zwobraznjenju
    .accesskey = H

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Po zwobraznjenju za
    .accesskey = z
seconds-label = sekundow

##

open-msg-label =
    .value = Powěsće wočinić w:
open-msg-tab =
    .label = nowym rajtarku
    .accesskey = r
open-msg-window =
    .label = nowym powěsćowym woknje
    .accesskey = n
open-msg-ex-window =
    .label = eksistowacym powěsćowym woknje
    .accesskey = e
close-move-delete =
    .label = Powěsćowe wokno/Powěsćowy rajtark při přesuwanju abo hašenju začinić
    .accesskey = P
display-name-label =
    .value = Pokazowane mjeno:
condensed-addresses-label =
    .label = Jenož zwobraznjenske mjeno za ludźi w adresniku pokazać
    .accesskey = J

## Compose Tab

forward-label =
    .value = Powěsće dale sposrědkować:
    .accesskey = d
inline-label =
    .label = Zasadźeny
as-attachment-label =
    .label = Jako přiwěšk
extension-label =
    .label = Sufiks datajowemu mjenu přidać
    .accesskey = f

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Awtomatisce składować kóžde
    .accesskey = s
auto-save-end = mjeńšin

##

warn-on-send-accel-key =
    .label = Wobkrućić, hdyž so tastowa skrótšenka za słanje powěsće wužiwa
    .accesskey = t
spellcheck-label =
    .label = Prawopis do słanja pruwować
    .accesskey = s
spellcheck-inline-label =
    .label = Prawopis při zapodaću pruwować
    .accesskey = z
language-popup-label =
    .value = Rěč:
    .accesskey = R
download-dictionaries-link = Dalše słowniki sćahnyć
font-label =
    .value = Pismo:
    .accesskey = P
font-size-label =
    .value = Wulkosć:
    .accesskey = u
default-colors-label =
    .label = Standardne barby čitaka wužiwać
    .accesskey = d
font-color-label =
    .value = Tekstowa barba:
    .accesskey = T
bg-color-label =
    .value = Pozadkowa barba:
    .accesskey = z
restore-html-label =
    .label = Standardy wobnowić
    .accesskey = b
default-format-label =
    .label = Po standardźe wotstawkowy format město wobsahoweho teksta wužiwać
    .accesskey = P
format-description = Zadźerženje tekstoweho formata konfigurować
send-options-label =
    .label = Wotesyłanske nastajenja…
    .accesskey = o
autocomplete-description = Při adresowanju powěsće za přihódnymi zapiskami pytać:
ab-label =
    .label = w lokalnych adresnikach
    .accesskey = l
directories-label =
    .label = Zapisowy serwer:
    .accesskey = Z
directories-none-label =
    .none = Žadyn
edit-directories-label =
    .label = Zapisy wobdźěłać…
    .accesskey = b
email-picker-label =
    .label = Městno za awtomatiske dodaće adresow wuchadźaceho e-mejla:
    .accesskey = t
default-directory-label =
    .value = Standardny startowy zapis we woknje adresnika:
    .accesskey = S
default-last-label =
    .none = Posledni wužity zapis
attachment-label =
    .label = Za falowacymi přiwěškami pruwować
    .accesskey = f
attachment-options-label =
    .label = Klučowe hesła…
    .accesskey = K
enable-cloud-share =
    .label = Poskićić, zo by dataje dźělił, kotrež su wjetše hač
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = Přidać…
    .accesskey = d
    .defaultlabel = Přidać…
remove-cloud-account =
    .label = Wotstronić
    .accesskey = W
find-cloud-providers =
    .value = Dalšich poskićowarjow namakać…
cloud-account-description = Nowu składowansku słužbu Filelink přidać

## Privacy Tab

mail-content = E-mejlowy wobsah
remote-content-label =
    .label = Zdaleny wobsah w powěsćach dowolić
    .accesskey = d
exceptions-button =
    .label = Wuwzaća…
    .accesskey = u
remote-content-info =
    .value = Zhońće wjace wo problemach priwatnosće zdaleneho wobsaha
web-content = Webwobsah
history-label =
    .label = Wopytane websydła a wotkazy sej spomjatkować
    .accesskey = t
cookies-label =
    .label = Placki ze sydłow akceptować
    .accesskey = l
third-party-label =
    .value = Placki třećich poskićowarjow akceptować:
    .accesskey = c
third-party-always =
    .label = Přeco
third-party-never =
    .label = Ženje
third-party-visited =
    .label = Wot wopytanych třećich poskićowarjow
keep-label =
    .value = Wobchować, doniž:
    .accesskey = b
keep-expire =
    .label = njespadnu
keep-close =
    .label = { -brand-short-name } so začini
keep-ask =
    .label = kóždy raz so prašeć
cookies-button =
    .label = Placki pokazać…
    .accesskey = c
do-not-track-label =
    .label = Websydłam signal “Njeslědować” pósłać, zo nochceće, zo wone was slěduja
    .accesskey = s
learn-button =
    .label = Dalše informacije
passwords-description = { -brand-short-name } móže hesła za wšě waše konta składować.
passwords-button =
    .label = Składowane hesła…
    .accesskey = S
master-password-description = Hłowne hesło škita wšě waše hesła, ale dyrbiće jo jedyn raz na posedźenje zapodać.
master-password-label =
    .label = Hłowne hesło wužiwać
    .accesskey = H
master-password-button =
    .label = Hłowne hesło změnić…
    .accesskey = o
primary-password-description = Hłowne hesło škita wšě waše hesła, ale dyrbiće jo jedyn raz na posedźenje zapodać.
primary-password-label =
    .label = Hłowne hesło wužiwać
    .accesskey = H
primary-password-button =
    .label = Hłowne hesło změnić…
    .accesskey = z
forms-primary-pw-fips-title = Sće tuchwilu we FIPS-modusu. FIPS sej hłowne hesło žada.
forms-master-pw-fips-desc = Změnjenje hesła njeje so poradźiło
junk-description = Nastajće swoje standardne nastajenja za čaporowu e-mejl. Nastajenja čaporoweje e-mejle specifiske za konto dadźa so w Kontowych nastajenjach konfigurować.
junk-label =
    .label = Hdyž so powěsće jako čapor markěruja:
    .accesskey = H
junk-move-label =
    .label = Je do kontoweho rjadowaka "Čapor" přesunyć
    .accesskey = k
junk-delete-label =
    .label = Je zhašeć
    .accesskey = z
junk-read-label =
    .label = Powěsće, kotrež su čapor, jako přečitane markěrować
    .accesskey = P
junk-log-label =
    .label = Protokolowanje priměrjomneho čaporoweho filtra změnić
    .accesskey = r
junk-log-button =
    .label = Protokol pokazać
    .accesskey = t
reset-junk-button =
    .label = Trenowanske daty wróćo stajić
    .accesskey = d
phishing-description = { -brand-short-name } móže powěsće za podhladnym e-mejlowym jebanstwom analyzować, pytajo za zwučenymi technikami, kotrež wužiwaja so, zo bychu wam jebali.
phishing-label =
    .label = Zdźělić, hač powěsć, kotraž so čita, je podhladne e-mejlowe jebanstwo
    .accesskey = Z
antivirus-description = { -brand-short-name } móže antiwirusowej softwarje wosnadnić, dochadźace e-mejlowe powěsće za wirusami analyzować, prjedy hač so lokalnje składuja.
antivirus-label =
    .label = Antiwirusowym programam dowolić, jednotliwe dochadźace powěsće pod karantenu stajić
    .accesskey = A
certificate-description = Hdyž serwer sej wosobinski certifikat žada:
certificate-auto =
    .label = Někajki awtomatisce wubrać
    .accesskey = N
certificate-ask =
    .label = Kóždy raz so prašeć
    .accesskey = K
ocsp-label =
    .label = Pola wotmołwnych serwerow OCSP so naprašować, zo by so aktualna płaćiwosć certifikatow wobkrućiło
    .accesskey = P
certificate-button =
    .label = Certifikaty rjadować…
    .accesskey = C
security-devices-button =
    .label = Wěstotne graty…
    .accesskey = W

## Chat Tab

startup-label =
    .value = Hdyž { -brand-short-name } startuje:
    .accesskey = s
offline-label =
    .label = Chatowe konto offline wostajić
auto-connect-label =
    .label = Chatowe konta awtomatisce zwjazać

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Kontakty informować, zo sym potom
    .accesskey = i
idle-time-label = mjeńšin preč

##

away-message-label =
    .label = a stajće mój status na Preč z tutej statusowej powěsću:
    .accesskey = P
send-typing-label =
    .label = W konwersaciji zdźělenki pisać
    .accesskey = k
notification-label = Hdyž powěsće za was přichadźeja:
show-notification-label =
    .label = Zdźělenku pokazać:
    .accesskey = Z
notification-all =
    .label = z mjenom wotpósłarja a powěsćowym přehladom
notification-name =
    .label = jenož z mjenom wotpósłarja
notification-empty =
    .label = bjez někajkich informacijow
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Dokowy symbol animěrować
           *[other] Zapisk nadawkoweje lajsty zablendować
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] Z
        }
chat-play-sound-label =
    .label = Zynk wothrać
    .accesskey = h
chat-play-button =
    .label = Wothrać
    .accesskey = r
chat-system-sound-label =
    .label = Standardny sytemowy zynk za nowu e-mejl
    .accesskey = S
chat-custom-sound-label =
    .label = Slědowacu zynkowu dataju wužić
    .accesskey = l
chat-browse-sound-button =
    .label = Přepytać…
    .accesskey = P
theme-label =
    .value = Drasta:
    .accesskey = D
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Puchery
style-dark =
    .label = Ćmowe
style-paper =
    .label = Papjerowe łopjena
style-simple =
    .label = Jednora
preview-label = Přehlad:
no-preview-label = Přehlad k dispoziciji njeje
no-preview-description = Tuta drasta płaćiwa njeje abo njeje tuchwilu k dispoziciji (žnjemóžnjeny přidatk, wěsty modus …).
chat-variant-label =
    .value = Warianta:
    .accesskey = W
chat-header-label =
    .label = Hłowu pokazać
    .accesskey = H
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
            [windows] W nastajenjach pytać
           *[other] W nastajenjach pytać
        }

## Preferences UI Search Results

search-results-header = Pytanske wuslědki
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Bohužel žane wuslědki w nastajenjach za “<span data-l10n-name="query"></span>” njejsu.
       *[other] Bohužel žane wuslědki w nastajenjach za “<span data-l10n-name="query"></span>” njejsu.
    }
search-results-help-link = Trjebaće pomoc? Wopytajće <a data-l10n-name="url">Pomoc za { -brand-short-name }</a>
