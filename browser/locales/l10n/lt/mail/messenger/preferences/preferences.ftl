# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Užverti
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Nuostatos
           *[other] Nuostatos
        }
preferences-tab-title =
    .title = Nuostatos
preferences-doc-title = Nuostatos
category-list =
    .aria-label = Kategorijos
pane-general-title = Bendrosios
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = Laiškų rašymas
category-compose =
    .tooltiptext = Laiškų rašymas
pane-privacy-title = Privatumas ir saugumas
category-privacy =
    .tooltiptext = Privatumas ir saugumas
pane-chat-title = Pokalbiai
category-chat =
    .tooltiptext = Pokalbiai
pane-calendar-title = Kalendorius
category-calendar =
    .tooltiptext = Kalendorius
general-language-and-appearance-header = Kalba ir išvaizda
general-incoming-mail-header = Gauti laiškai
general-files-and-attachment-header = Failai ir priedai
general-tags-header = Žymos
general-reading-and-display-header = Skaitymas ir rodymas
general-updates-header = Naujiniai
general-network-and-diskspace-header = Tinklas ir vieta diske
general-indexing-label = Indeksavimas
composition-category-header = Laiškų rašymas
composition-attachments-header = Laiškų priedai
composition-spelling-title = Rašybos tikrinimas
compose-html-style-title = HTML stilius
composition-addressing-header = Adresavimas
privacy-main-header = Privatumas
privacy-passwords-header = Slaptažodžiai
privacy-junk-header = Brukalas
collection-header = „{ -brand-short-name }“ duomenų rinkimas ir naudojimas
collection-description = Mes siekiame jums leisti rinktis, ir rinkti tik tai, ko reikia tobulinant „{ -brand-short-name }“ . Mes visuomet paprašome leidimo prieš gaudami asmeninę informaciją.
collection-privacy-notice = Privatumo pranešimas
collection-health-report-telemetry-disabled = Jūs nebeleidžiate „{ -vendor-short-name }“ rinkti techninių ir naudojimosi duomenų. Visi ankstesni duomenys bus pašalinti per 30 dienų.
collection-health-report-telemetry-disabled-link = Sužinokite daugiau
collection-health-report =
    .label = Leisti „{ -brand-short-name }“ siųsti techninius ir naudojimosi duomenis „{ -vendor-short-name }“
    .accesskey = L
collection-health-report-link = Sužinokite daugiau
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Šios programos duomenų siuntimo galimybė išjungta jos kompiliavimo metu
collection-backlogged-crash-reports =
    .label = Leisti „{ -brand-short-name }“ siųsti sukauptus strigčių pranešimus jūsų vardu
    .accesskey = L
collection-backlogged-crash-reports-link = Sužinokite daugiau
privacy-security-header = Saugumas
privacy-scam-detection-title = Suktybių aptikimas
privacy-anti-virus-title = Antivirusas
privacy-certificates-title = Liudijimai
chat-pane-header = Pokalbiai
chat-status-title = Būsena
chat-notifications-title = Pranešimai
chat-pane-styling-header = Stiliai
choose-messenger-language-description = Pasirinkite kalbas, kurios bus naudojamos „{ -brand-short-name }“ meniu, žinutėms ir pranešimams.
manage-messenger-languages-button =
    .label = Alternatyvos…
    .accesskey = A
confirm-messenger-language-change-description = Šie pakeitimai bus pritaikyti i naujo paleidus „{ -brand-short-name }“
confirm-messenger-language-change-button = Pritaikyti ir perleisti
update-setting-write-failure-title = Klaida įrašant naujinimų nuostatas
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    „{ -brand-short-name }“ susidūrė su klaida ir neįrašė šio pakeitimo. Atminkite, kad norint pakeisti šią naujinimų nuostatą, reikalingas leidimas rašyti į žemiau nurodytą failą. Jūs, arba sistemos prižiūrėtojas, gali pabandyti tai sutvarkyti, suteikiant atitinkamas šio failo valdymo teises „Users“ grupei.
    
    Nepavyko rašymas į failą: { $path }
update-in-progress-title = Vyksta naujinimas
update-in-progress-message = Ar norite, kad „{ -brand-short-name }“ tęstų šį naujinimą?
update-in-progress-ok-button = &Atsisakyti
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Tęsti
addons-button = Priedai ir grafiniai apvalkalai
account-button = Paskyros nuostatos
open-addons-sidebar-button = Priedai ir grafiniai apvalkalai

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Norėdami sukurti pagrindinį slaptažodį, įveskite savo „Windows“ prisijungimo duomenis. Tai padeda apsaugoti jūsų paskyras.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = sukurti pagrindinį slaptažodį
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Norėdami sukurti pagrindinį slaptažodį, įveskite savo „Windows“ prisijungimo duomenis. Tai padeda apsaugoti jūsų paskyras.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = sukurti pagrindinį slaptažodį
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend = „{ -brand-short-name }“ pradžios tinklalapis
start-page-label =
    .label = Paleidžiant programą „{ -brand-short-name }“ laiškų polangyje rodyti pradžios tinklalapį
    .accesskey = P
location-label =
    .value = Adresas:
    .accesskey = A
restore-default-label =
    .label = Atstatyti numatytąsias nuostatas
    .accesskey = t
default-search-engine = Numatytoji paieškos sistema
add-search-engine =
    .label = Pridėti iš failo
    .accesskey = A
remove-search-engine =
    .label = Pašalinti
    .accesskey = v
minimize-to-tray-label =
    .label = Kai „{ -brand-short-name }“ sumažinamas iki minimumo, perkelti į dėklą
    .accesskey = m
new-message-arrival = Gavus naują laišką:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Naudoti kitą garso failą:
           *[other] Pranešti garsu
        }
    .accesskey =
        { PLATFORM() ->
            [macos] u
           *[other] g
        }
mail-play-button =
    .label = Perklausyti
    .accesskey = k
change-dock-icon = Keisti pritvirtinamos piktogramos nuostatas
app-icon-options =
    .label = Piktogramos nuostatos…
    .accesskey = n
notification-settings = Įspėjimus ir numatytuosius garsus galite išjungti Sistemos nuostatų Pranešimų polangyje.
animated-alert-label =
    .label = Parodyti įspėjimą
    .accesskey = ė
customize-alert-label =
    .label = Kitkas…
    .accesskey = K
tray-icon-label =
    .label = Rodyti piktogramą pranešimų srityje
    .accesskey = t
biff-use-system-alert =
    .label = Naudoti sistemos pranešimus
tray-icon-unread-label =
    .label = Rodyti neskaitytų pranešimų dėklo piktogramą
    .accesskey = R
tray-icon-unread-description = Rekomenduojama kai naudojate mažus užduočių juostos mygtukus
mail-system-sound-label =
    .label = Sistemos numatytasis garsas gavus naują laišką
    .accesskey = S
mail-custom-sound-label =
    .label = Naudoti kitą garso failą:
    .accesskey = u
mail-browse-sound-button =
    .label = Parinkti…
    .accesskey = r
enable-gloda-search-label =
    .label = Įjungti globalią laiškų paiešką ir indeksavimą
    .accesskey = g
datetime-formatting-legend = Datos ir laiko formatas
language-selector-legend = Kalba
allow-hw-accel =
    .label = Jei įmanoma, naudoti aparatinį spartinimą
    .accesskey = a
store-type-label =
    .value = Laiškų saugojimo būdas naujoms paskyroms:
    .accesskey = b
mbox-store-label =
    .label = Atskiras failas kiekvienam aplankui („mbox“)
maildir-store-label =
    .label = Atskiras failas kiekvienam laiškui („Maildir“)
scrolling-legend = Slinkimas
autoscroll-label =
    .label = Slinkti automatiškai
    .accesskey = a
smooth-scrolling-label =
    .label = Slinkti tolygiai
    .accesskey = t
system-integration-legend = Integracija su sistema
always-check-default =
    .label = Paleidžiant „{ -brand-short-name }“ tikrinti, ar ji yra numatytoji
    .accesskey = u
check-default-button =
    .label = Tikrinti dabar…
    .accesskey = d
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }
search-integration-label =
    .label = Leisti „{ search-engine-name }“ ieškoti laiškų
    .accesskey = L
config-editor-button =
    .label = Visų parametrų sąrašas…
    .accesskey = V
return-receipts-description = Nustatykite kaip „{ -brand-short-name }“ tvarko pažymas apie pristatytus laiškus
return-receipts-button =
    .label = Laiškų pristatymo pažymos…
    .accesskey = L
update-app-legend = „{ -brand-short-name }“ naujinimai
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Laida { $version }
allow-description = Leisti „{ -brand-short-name }“
automatic-updates-label =
    .label = Automatiškai įdiegti naujinimus (rekomenduojama – didesnis saugumas)
    .accesskey = A
check-updates-label =
    .label = Tikrinti, ar yra naujinimų, bet atsiklausti prieš juos įdiegiant
    .accesskey = T
update-history-button =
    .label = Rodyti atnaujinimo žurnalą
    .accesskey = R
use-service =
    .label = Naujinimams įdiegti naudoti fone veikiančią tarnybą
    .accesskey = f
cross-user-udpate-warning = Ši nuostata bus pritaikyta visoms „Windows“ paskyroms ir „{ -brand-short-name }“ profiliams, naudojantiems šią „{ -brand-short-name }“ įdiegtį.
networking-legend = Ryšys
proxy-config-description = Parinkite „{ -brand-short-name }“ ryšio su internetu nuostatas
network-settings-button =
    .label = Nuostatos…
    .accesskey = N
offline-legend = Atsijungimas nuo tinklo
offline-settings = Parinkite darbo neprisijungus prie tinklo nuostatas
offline-settings-button =
    .label = Darbas neprisijungus prie tinklo…
    .accesskey = D
diskspace-legend = Disko atmintis
offline-compact-folder =
    .label = Suglaudinti visus aplankus, jei sumoje tai padės sutaupyti daugiau kaip
    .accesskey = S
compact-folder-size =
    .value = MB

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Podėliui skirti iki
    .accesskey = P
use-cache-after = MB disko atminties

##

smart-cache-label =
    .label = Neleisti automatinio podėlio dydžio valdymo
    .accesskey = v
clear-cache-button =
    .label = Išvalyti dabar
    .accesskey = v
fonts-legend = Šriftai ir spalvos
default-font-label =
    .value = Numatytasis šriftas:
    .accesskey = u
default-size-label =
    .value = dydis:
    .accesskey = d
font-options-button =
    .label = Kitkas…
    .accesskey = t
color-options-button =
    .label = Spalvos…
    .accesskey = S
display-width-legend = Grynojo teksto laiškai
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Jaustukus rodyti grafiškai
    .accesskey = J
display-text-label = Citatų šriftas:
style-label =
    .value = Stilius:
    .accesskey = t
regular-style-item =
    .label = Normalusis
bold-style-item =
    .label = Pusjuodis
italic-style-item =
    .label = Kursyvas
bold-italic-style-item =
    .label = Pusjuodis kursyvas
size-label =
    .value = dydis:
    .accesskey = y
regular-size-item =
    .label = Normalusis
bigger-size-item =
    .label = Didesnis
smaller-size-item =
    .label = Mažesnis
quoted-text-color =
    .label = Citatų spalva:
    .accesskey = C
search-input =
    .placeholder = Ieškoti
search-handler-table =
    .placeholder = Filtruoti pagal turinio tipus ir veiksmus
type-column-label =
    .label = Turinio tipas
    .accesskey = t
action-column-label =
    .label = Veiksmas
    .accesskey = V
save-to-label =
    .label = Įrašyti failus į aplanką
    .accesskey = f
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Parinkti…
           *[other] Parinkti…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] r
           *[other] r
        }
always-ask-label =
    .label = Visada klausti, kur įrašyti failus
    .accesskey = V
display-tags-text = Pagal gaires galima grupuoti laiškus ir nustatyti jų prioritetus.
new-tag-button =
    .label = Nauja…
    .accesskey = N
edit-tag-button =
    .label = Keisti…
    .accesskey = K
delete-tag-button =
    .label = Pašalinti
    .accesskey = š
auto-mark-as-read =
    .label = Atvertą laišką pažymėti kaip skaitytą
    .accesskey = ž
mark-read-no-delay =
    .label = iškart
    .accesskey = i

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = praėjus
    .accesskey = p
seconds-label = sek.

##

open-msg-label =
    .value = Atveriamą laišką rodyti:
open-msg-tab =
    .label = naujoje kortelėje
    .accesskey = k
open-msg-window =
    .label = naujame lange
    .accesskey = n
open-msg-ex-window =
    .label = tame pačiame (atvertame) lange
    .accesskey = t
close-move-delete =
    .label = Perkėlus ar pašalinus laišką, užverti langą ar kortelę su juo
    .accesskey = v
display-name-label =
    .value = Rodomas vardas:
condensed-addresses-label =
    .label = Jei asmens duomenys įrašyti į adresų knygą, tai rodyti tik jo asmenvardį (be adreso)
    .accesskey = a

## Compose Tab

forward-label =
    .value = Persiųsti laiškus:
    .accesskey = P
inline-label =
    .label = tiesiogiai
as-attachment-label =
    .label = kaip priedus
extension-label =
    .label = failo vardui suteikti prievardį
    .accesskey = v

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Automatiškai įrašyti kas
    .accesskey = u
auto-save-end = min.

##

warn-on-send-accel-key =
    .label = Parodyti patvirtinimą, kai laiškas siunčiamas naudojant sparčiuosius klavišus
    .accesskey = o
spellcheck-label =
    .label = Tikrinti rašybą prieš išsiunčiant laišką
    .accesskey = T
spellcheck-inline-label =
    .label = Tikrinti rašybą rašant tekstą
    .accesskey = r
language-popup-label =
    .value = Kalba:
    .accesskey = K
download-dictionaries-link = Atsiųsti kitų kalbų žodynus
font-label =
    .value = Šriftas:
    .accesskey = Š
font-size-label =
    .value = Dydis:
    .accesskey = z
default-colors-label =
    .label = Naudokite numatytasias skaitymo spalvas
    .accesskey = d
font-color-label =
    .value = Teksto spalva:
    .accesskey = T
bg-color-label =
    .value = Fono spalva:
    .accesskey = F
restore-html-label =
    .label = Atstatyti numatytąsias nuostatas
    .accesskey = A
default-format-label =
    .label = Numatytuoju atveju naudoti pastraipos formatą vietoj paprastojo teksto formato
    .accesskey = p
format-description = Parinkite siunčiamų laiškų tekstų tipus:
send-options-label =
    .label = Siuntimo parinktys…
    .accesskey = S
autocomplete-description = Adresų, kurių pradžios sutampa su surinktu tekstu, ieškoti:
ab-label =
    .label = adresų knygose
    .accesskey = a
directories-label =
    .label = katalogų serveryje:
    .accesskey = s
directories-none-label =
    .none = Nėra
edit-directories-label =
    .label = Tvarkyti katalogus…
    .accesskey = T
email-picker-label =
    .label = Išsiunčiamų laiškų el. pašto adresus automatiškai įtraukti į:
    .accesskey = s
default-directory-label =
    .value = Numatytasis paleidimo katalogas adresų knygos lange:
    .accesskey = S
default-last-label =
    .none = Paskiausiai naudotas katalogas
attachment-label =
    .label = Tikrinti, ar neužmiršta pridėti failo
    .accesskey = t
attachment-options-label =
    .label = Reikšminiai žodžiai…
    .accesskey = ž
enable-cloud-share =
    .label = Siūlyti siųsti failus per debesį, kai jų dydis viršija
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = Pridėti…
    .accesskey = P
    .defaultlabel = Pridėti…
remove-cloud-account =
    .label = Pašalinti
    .accesskey = š
find-cloud-providers =
    .value = Rasti daugiau teikėjų…
cloud-account-description = Pridėkite failų talpinimo debesyje tarnybą

## Privacy Tab

mail-content = Laiškų intarpai
remote-content-label =
    .label = Leisti intarpus iš tinklo laiškuose
    .accesskey = L
exceptions-button =
    .label = Išimtys…
    .accesskey = š
remote-content-info =
    .value = Sužinoti daugiau apie privatumo problemas, leidžiant intarpus iš tinklo
web-content = Saityno turinys
history-label =
    .label = Įsiminti lankytas svetaines ir saitus
    .accesskey = m
cookies-label =
    .label = Leisti įrašyti slapukus
    .accesskey = s
third-party-label =
    .value = Leisti trečiųjų šalių slapukus:
    .accesskey = t
third-party-always =
    .label = visada
third-party-never =
    .label = niekada
third-party-visited =
    .label = tik lankytų
keep-label =
    .value = Laikyti iki:
    .accesskey = k
keep-expire =
    .label = jų galiojimo laiko pabaigos
keep-close =
    .label = „{ -brand-short-name }“ seanso pabaigos
keep-ask =
    .label = klausti prieš priimant slapuką
cookies-button =
    .label = Rodyti slapukus…
    .accesskey = R
do-not-track-label =
    .label = Siųsti svetainėms „Do Not Track“ signalą, nurodantį jūsų pageidavimą nebūti sekamiems
    .accesskey = n
learn-button =
    .label = Sužinokite daugiau
passwords-description = Programa „{ -brand-short-name }“ gali įsiminti visų paskyrų slaptažodžius.
passwords-button =
    .label = Įrašyti slaptažodžiai…
    .accesskey = s
master-password-description = Pagrindinis slaptažodis apsaugos visus slaptažodžius. Jis turi būti pateikiamas programai kartą per seansą.
master-password-label =
    .label = Naudoti pagrindinį slaptažodį
    .accesskey = N
master-password-button =
    .label = Pakeisti pagrindinį slaptažodį…
    .accesskey = k
primary-password-description = Pagrindinis slaptažodis apsaugo visus slaptažodžius, bet jį turite įvesti kaskart paleidus programą.
primary-password-label =
    .label = Naudoti pagrindinį slaptažodį
    .accesskey = N
primary-password-button =
    .label = Pakeisti pagrindinį slaptažodį…
    .accesskey = P
forms-primary-pw-fips-title = Šiuo metu pasirinkta FIPS veiksena. Jai reikia pagrindinio slaptažodžio.
forms-master-pw-fips-desc = Slaptažodžio pakeisti nepavyko
junk-description = Brukalo kontrolės nuostatos atskiroms paskyroms parenkamos paskyrų nuostatų lange.
junk-label =
    .label = Pažymėjus, kad laiškai yra brukalas:
    .accesskey = P
junk-move-label =
    .label = perkelti juos į paskyros aplanką „Brukalas“
    .accesskey = k
junk-delete-label =
    .label = pašalinti juos
    .accesskey = š
junk-read-label =
    .label = Laiškus, įgijusius brukalo statusą, žymėti kaip skaitytus
    .accesskey = L
junk-log-label =
    .label = Įrašyti adaptyviojo brukalo filtro veiksmus
    .accesskey = r
junk-log-button =
    .label = Rodyti žurnalą
    .accesskey = ž
reset-junk-button =
    .label = Atstatyti automatinės kontrolės duomenis
    .accesskey = t
phishing-description = Analizuodama gaunamus laiškus programa „{ -brand-short-name }“ gali patikrinti, ar jais nebandoma jūsų apgauti.
phishing-label =
    .label = Tikrinti, ar gaunamuose laiškuose nėra apgaulės
    .accesskey = T
antivirus-description = Prieš įrašydama gaunamus laiškus programa „{ -brand-short-name }“ gali leisti antivirusinei programai patikrinti ar juose nėra virusų.
antivirus-label =
    .label = Leisti antivirusinei programai izoliuoti atskirus įtartinus laiškus
    .accesskey = L
certificate-description = Serveriui paprašius mano liudijimo:
certificate-auto =
    .label = parinkti jį automatiškai
    .accesskey = a
certificate-ask =
    .label = visada klausti
    .accesskey = k
ocsp-label =
    .label = Tikrinti liudijimų galiojimą, užklausiant OCSP atsakiklių
    .accesskey = O
certificate-button =
    .label = Tvarkyti liudijimus…
    .accesskey = M
security-devices-button =
    .label = Saugumo priemonės…
    .accesskey = D

## Chat Tab

startup-label =
    .value = Paleidus „{ -brand-short-name }“:
    .accesskey = P
offline-label =
    .label = pokalbių paskyras palikti neprijungtas
auto-connect-label =
    .label = prijungti pokalbių paskyras automatiškai

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Pranešti adresatams apie jūsų neveiklumą po
    .accesskey = n
idle-time-label = min.

##

away-message-label =
    .label = ir pakeisti būseną į „nesu“, nurodant šį būsenos pranešimą:
    .accesskey = b
send-typing-label =
    .label = Pranešti pašnekovams, kai rašote pokalbyje
    .accesskey = š
notification-label = Gavus jums skirtą pranešimą:
show-notification-label =
    .label = Rodyti įspėjimą
    .accesskey = ė
notification-all =
    .label = su siuntėjo vardu ir laiško ištrauka
notification-name =
    .label = tik su siuntėjo vardu
notification-empty =
    .label = be informacijos apie laišką
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animuoti doko piktogramą
           *[other] Animuoti užduočių juostoje
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] F
        }
chat-play-sound-label =
    .label = Pranešti garsu
    .accesskey = g
chat-play-button =
    .label = Perklausyti
    .accesskey = k
chat-system-sound-label =
    .label = Sistemos numatytasis naujų laiškų gavimo garsas
    .accesskey = S
chat-custom-sound-label =
    .label = Naudoti kitą garso failą
    .accesskey = u
chat-browse-sound-button =
    .label = Parinkti…
    .accesskey = r
theme-label =
    .value = Grafinis apvalkalas:
    .accesskey = T
style-thunderbird =
    .label = „Thunderbird“
style-bubbles =
    .label = Burbulai
style-dark =
    .label = Tamsus
style-paper =
    .label = Popieriaus lapai
style-simple =
    .label = Paprastas
preview-label = Peržiūra:
no-preview-label = Peržiūra negalima
no-preview-description = Ši tema netinkama arba šiuo metu nepasiekiama (išjungtas priedas, saugusis režimas, …).
chat-variant-label =
    .value = Variantas:
    .accesskey = V
chat-header-label =
    .label = Rodyti antraštę
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
            [windows] ieškoti nuostatose
           *[other] ieškoti nuostatose
        }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-preferences-input =
    .style = width: 15.4em
    .placeholder = Find in Preferences

## Preferences UI Search Results

search-results-header = Paieškos rezultatai
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Deja! Nuostatose nėra rezultatų, atitinkančių „<span data-l10n-name="query"></span>“.
       *[other] Deja! Nuostatose nėra rezultatų, atitinkančių „<span data-l10n-name="query"></span>“.
    }
search-results-help-link = Reikia pagalbos? Aplankykite <a data-l10n-name="url">„{ -brand-short-name }“</a>
