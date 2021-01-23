# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Zapri

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Možnosti
           *[other] Nastavitve
        }

pane-general-title = Splošno
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Sestavljanje
category-compose =
    .tooltiptext = Sestavljanje

pane-privacy-title = Zasebnost in varnost
category-privacy =
    .tooltiptext = Zasebnost in varnost

pane-chat-title = Klepet
category-chat =
    .tooltiptext = Klepet

pane-calendar-title = Lightning
category-calendar =
    .tooltiptext = Lightning

general-language-and-appearance-header = Jezik in videz

general-incoming-mail-header = Dohodna pošta

general-files-and-attachment-header = Datoteke in priponke

general-tags-header = Oznake

general-reading-and-display-header = Branje in prikaz

general-updates-header = Posodobitve

general-network-and-diskspace-header = Omrežje in prostor na disku

general-indexing-label = Indeksiranje

composition-category-header = Sestavljanje

composition-attachments-header = Priponke

composition-spelling-title = Črkovanje

compose-html-style-title = Slog HTML

composition-addressing-header = Naslavljanje

privacy-main-header = Zasebnost

privacy-passwords-header = Gesla

privacy-junk-header = Neželeno

collection-header = Zbiranje in uporaba podatkov { -brand-short-name }a

collection-description = Trudimo se, da vam ponudimo izbiro in da zbiramo samo tisto, kar potrebujemo za razvoj in izboljšave { -brand-short-name }a za vse uporabnike. Pred sprejemanjem osebnih podatkov vas vedno vprašamo za dovoljenje.
collection-privacy-notice = Obvestilo o zasebnosti

collection-health-report-telemetry-disabled = Organizaciji { -vendor-short-name } ne dovoljujete več zajemanja tehničnih podatkov in podatkov o uporabi. Vsi pretekli podatki bodo izbrisani v 30 dneh.
collection-health-report-telemetry-disabled-link = Več o tem

collection-health-report =
    .label = { -brand-short-name }u dovoli pošiljanje tehničnih podatkov in podatkov o uporabi organizaciji { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Več o tem

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Pošiljanje podatkov je onemogočeno za to nastavitev graditve

collection-backlogged-crash-reports =
    .label = { -brand-short-name }u dovoli, da v vašem imenu pošilja poročila o sesutju iz zaloge
    .accesskey = č
collection-backlogged-crash-reports-link = Več o tem

privacy-security-header = Varnost

privacy-scam-detection-title = Odkrivanje prevar

privacy-anti-virus-title = Protivirusna zaščita

privacy-certificates-title = Digitalna potrdila

chat-pane-header = Klepet

chat-status-title = Stanje

chat-notifications-title = Obvestila

chat-pane-styling-header = Oblikovanje

choose-messenger-language-description = Izberite jezike za prikaz menijev, sporočil in obvestil v { -brand-short-name }u.
manage-messenger-languages-button =
    .label = Nastavi pomožne jezike …
    .accesskey = m
confirm-messenger-language-change-description = Za uveljavitev sprememb ponovno zaženite { -brand-short-name }
confirm-messenger-language-change-button = Uporabi in znova zaženi

update-setting-write-failure-title = Napaka pri shranjevanju nastavitev posodobitev

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } je naletel na napako in te spremembe ni shranil. Upoštevajte, da takšna nastavitev posodobitev zahteva dovoljenje za pisanje v spodnjo datoteko. Napako lahko morda odpravite sami ali vaš skrbnik sistema, tako da skupini Users omogoči popoln dostop do te datoteke.
    
    Ni mogoče pisati v datoteko: { $path }

update-in-progress-title = Posodobitev je v teku

update-in-progress-message = Želite, da { -brand-short-name } nadaljuje s to posodobitvijo?

update-in-progress-ok-button = &Opusti
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Nadaljuj

addons-button = Razširitve in teme

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Če želite ustvariti glavno geslo, vnesite svoje podatke za prijavo v sistem Windows. To pomaga zaščititi varnost vaših računov.

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = ustvari glavno geslo

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Če želite ustvariti glavno geslo, vnesite svoje podatke za prijavo v sistem Windows. To pomaga zaščititi varnost vaših računov.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = create a Primary Password

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = D
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name }: začetna stran

start-page-label =
    .label = Ko se { -brand-short-name } zažene, prikaži začetno stran v polju sporočila
    .accesskey = K

location-label =
    .value = Mesto:
    .accesskey = M
restore-default-label =
    .label = Ponastavi privzeto
    .accesskey = P

default-search-engine = Privzeti iskalnik
add-search-engine =
    .label = Dodaj iz datoteke
    .accesskey = D
remove-search-engine =
    .label = Odstrani
    .accesskey = s

minimize-to-tray-label =
    .label = Ob pomanjšanju premakni { -brand-short-name } v pladenj opravilne vrstice
    .accesskey = m

new-message-arrival = Ko prispejo nova sporočila:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Predvajaj naslednjo zvočno datoteko:
           *[other] predvajaj zvok
        }
    .accesskey =
        { PLATFORM() ->
            [macos] P
           *[other] e
        }
mail-play-button =
    .label = Predvajaj
    .accesskey = d

change-dock-icon = Spremeni možnosti ikone programa
app-icon-options =
    .label = Možnosti ikone programa …
    .accesskey = o

notification-settings = Opozorila in privzeti zvok lahko onemogočite na plošči Obvestila v sistemskih nastavitvah.

animated-alert-label =
    .label = prikaži opozorilo
    .accesskey = o
customize-alert-label =
    .label = Prilagodi …
    .accesskey = a

tray-icon-label =
    .label = prikaži ikono sistemske vrstice
    .accesskey = n

mail-system-sound-label =
    .label = Privzeti sistemski zvok za novo pošto
    .accesskey = z
mail-custom-sound-label =
    .label = Uporabi naslednjo zvočno datoteko
    .accesskey = U
mail-browse-sound-button =
    .label = Prebrskaj …
    .accesskey = B

enable-gloda-search-label =
    .label = Omogoči splošno iskanje in kazalo
    .accesskey = m

datetime-formatting-legend = Oblika datuma in časa
language-selector-legend = Jezik

allow-hw-accel =
    .label = Uporabi strojno pospeševanje, kadar je na voljo
    .accesskey = n

store-type-label =
    .value = Vrsta shrambe sporočil za nove račune:
    .accesskey = V

mbox-store-label =
    .label = Ena datoteka na mapo (mbox)
maildir-store-label =
    .label = Ena datoteka na sporočilo (maildir)

scrolling-legend = Drsenje
autoscroll-label =
    .label = Uporabi samodejno drsenje
    .accesskey = s
smooth-scrolling-label =
    .label = Uporabi gladko drsenje
    .accesskey = a

system-integration-legend = Vključitev v sistem
always-check-default =
    .label = Ob zagonu vedno preveri, ali je { -brand-short-name } privzeti odjemalec elektronske pošte
    .accesskey = O
check-default-button =
    .label = Preveri zdaj …
    .accesskey = e

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] iskalniku Spotlight
        [windows] iskanju Windows
       *[other] { "" }
    }

search-integration-label =
    .label = Dovoli { search-engine-name }, da preišče sporočila
    .accesskey = D

config-editor-button =
    .label = Urejevalnik nastavitev …
    .accesskey = U

return-receipts-description = Določite, kako { -brand-short-name } obravnava povratnice
return-receipts-button =
    .label = Povratnice …
    .accesskey = P

update-app-legend = Posodobitve { -brand-short-name }a

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Različica { $version }

allow-description = { -brand-short-name } naj
automatic-updates-label =
    .label = Samodejno nameščaj posodobitve (priporočeno za večjo varnost)
    .accesskey = S
check-updates-label =
    .label = Preverjaj posodobitve, vendar mi prepusti odločitev o nameščanju
    .accesskey = P

update-history-button =
    .label = Prikaži zgodovino posodobitev
    .accesskey = o

use-service =
    .label = Uporabi storitev za nameščanje posodobitev v ozadju
    .accesskey = Z

cross-user-udpate-warning = Ta nastavitev bo uveljavljena v vseh uporabniških računih sistema Windows in { -brand-short-name }ovih profilih, ki uporabljajo to različico { -brand-short-name }a.

networking-legend = Povezava
proxy-config-description = Nastavite, kako naj se { -brand-short-name } poveže na internet.

network-settings-button =
    .label = Nastavitve …
    .accesskey = N

offline-legend = Brez povezave
offline-settings = Uredite nastavitve za stanje brez povezave

offline-settings-button =
    .label = Brez povezave …
    .accesskey = B

diskspace-legend = Prostor na disku
offline-compact-folder =
    .label = Strni mape, kadar bo to skupaj prihranilo več kot
    .accesskey = S

compact-folder-size =
    .value = MB

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Porabi do
    .accesskey = P

use-cache-after = MB prostora za predpomnjenje.

##

smart-cache-label =
    .label = Prezri samodejno upravljanje predpomnilnika
    .accesskey = r

clear-cache-button =
    .label = Počisti zdaj
    .accesskey = o

fonts-legend = Pisave in barve

default-font-label =
    .value = Privzeta pisava:
    .accesskey = P

default-size-label =
    .value = Velikost:
    .accesskey = V

font-options-button =
    .label = Napredno …
    .accesskey = N

color-options-button =
    .label = Barve …
    .accesskey = B

display-width-legend = Sporočila v golem besedilu

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Prikaži smeške kot grafiko
    .accesskey = r

display-text-label = Pri prikazu navedenih sporočil v golem besedilu:

style-label =
    .value = Slog:
    .accesskey = S

regular-style-item =
    .label = Običajni
bold-style-item =
    .label = Krepki
italic-style-item =
    .label = Ležeči
bold-italic-style-item =
    .label = Krepko ležeči

size-label =
    .value = Velikost:
    .accesskey = e

regular-size-item =
    .label = Običajna
bigger-size-item =
    .label = Večja
smaller-size-item =
    .label = Manjša

quoted-text-color =
    .label = Barva:
    .accesskey = a

search-input =
    .placeholder = Išči

type-column-label =
    .label = Vrsta vsebine
    .accesskey = r

action-column-label =
    .label = Dejanje
    .accesskey = n

save-to-label =
    .label = Shrani datoteke v
    .accesskey = S

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Izberi …
           *[other] Prebrskaj …
        }
    .accesskey =
        { PLATFORM() ->
            [macos] z
           *[other] B
        }

always-ask-label =
    .label = Vsakokrat me vprašaj, kam shraniti posamezno datoteko
    .accesskey = V


display-tags-text = Oznake lahko uporabite za označevanje prednosti in kategorij svojih sporočil.

new-tag-button =
    .label = Nova …
    .accesskey = N

edit-tag-button =
    .label = Uredi …
    .accesskey = U

delete-tag-button =
    .label = Izbriši
    .accesskey = z

auto-mark-as-read =
    .label = Samodejno označi sporočila kot prebrana
    .accesskey = S

mark-read-no-delay =
    .label = takoj na zaslonu
    .accesskey = a

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = potem, ko so prikazana za
    .accesskey = o

seconds-label = sekund

##

open-msg-label =
    .value = Odpri sporočila v:

open-msg-tab =
    .label = novem zavihku
    .accesskey = h

open-msg-window =
    .label = novem oknu
    .accesskey = k

open-msg-ex-window =
    .label = obstoječem oknu za sporočila
    .accesskey = o

close-move-delete =
    .label = Zapri okno/zavihek s sporočilom ob premikanju ali brisanju
    .accesskey = Z

display-name-label =
    .value = Prikazno ime:

condensed-addresses-label =
    .label = Za osebe v mojem imeniku prikaži le prikazano ime
    .accesskey = a

## Compose Tab

forward-label =
    .value = Posreduj sporočila:
    .accesskey = P

inline-label =
    .label = v besedilu

as-attachment-label =
    .label = kot priponko

extension-label =
    .label = Dodaj končnico imenu datoteke
    .accesskey = D

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Samodejno shrani vsakih
    .accesskey = S

auto-save-end = minut

##

warn-on-send-accel-key =
    .label = Potrdi pošiljanje ob pritisku tipkovne bližnjice za pošiljanje sporočila
    .accesskey = o

spellcheck-label =
    .label = Pred pošiljanjem preveri črkovanje
    .accesskey = P

spellcheck-inline-label =
    .label = Omogoči preverjanje črkovanja med tipkanjem
    .accesskey = O

language-popup-label =
    .value = Jezik:
    .accesskey = J

download-dictionaries-link = Prenesi dodatne slovarje

font-label =
    .value = Pisava:
    .accesskey = s

font-size-label =
    .value = Velikost:
    .accesskey = V

default-colors-label =
    .label = Uporabi privzete barve bralnika
    .accesskey = p

font-color-label =
    .value = Barva besedila:
    .accesskey = b

bg-color-label =
    .value = Barva ozadja:
    .accesskey = z

restore-html-label =
    .label = Ponastavi privzeto
    .accesskey = n

default-format-label =
    .label = Privzeto uporabi obliko odstavka namesto telesa besedila
    .accesskey = k

format-description = Nastavi vedenje oblikovanja besedila

send-options-label =
    .label = Možnosti pošiljanja …
    .accesskey = M

autocomplete-description = Pri naslavljanju sporočil išči ustrezne vnose v:

ab-label =
    .label = krajevnih imenikih
    .accesskey = k

directories-label =
    .label = imeniškem strežniku:
    .accesskey = m

directories-none-label =
    .none = Brez

edit-directories-label =
    .label = Uredi imenike …
    .accesskey = U

email-picker-label =
    .label = Samodejno dodaj odhodne e-poštne naslove v:
    .accesskey = S

default-directory-label =
    .value = Privzeta začetna mapa v oknu imenika:
    .accesskey = P

default-last-label =
    .none = Nazadnje uporabljena mapa

attachment-label =
    .label = Preveri, ali morda manjkajo priponke
    .accesskey = r

attachment-options-label =
    .label = Ključne besede …
    .accesskey = K

enable-cloud-share =
    .label = Ponudi spletno shranjevanje datotek, večjih od
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Dodaj …
    .accesskey = D
    .defaultlabel = Dodaj …

remove-cloud-account =
    .label = Odstrani
    .accesskey = O

find-cloud-providers =
    .value = Poišči več ponudnikov …

cloud-account-description = Dodaj novega ponudnika storitve za shranjevanje podatkov Filelink


## Privacy Tab

mail-content = Vsebina pošte

remote-content-label =
    .label = Dovoli oddaljeno vsebino v sporočilih
    .accesskey = a

exceptions-button =
    .label = Izjeme …
    .accesskey = z

remote-content-info =
    .value = Več o vprašanjih zasebnosti oddaljene vsebine

web-content = Spletna vsebina

history-label =
    .label = Zapomni si spletna mesta in povezave, ki sem jih obiskal
    .accesskey = Z

cookies-label =
    .label = Dovoli stranem, da shranjujejo piškotke
    .accesskey = s

third-party-label =
    .value = Sprejemaj piškotke tretjih strani:
    .accesskey = š

third-party-always =
    .label = Vedno
third-party-never =
    .label = Nikoli
third-party-visited =
    .label = Od obiskanih

keep-label =
    .value = Obdrži jih:
    .accesskey = O

keep-expire =
    .label = dokler ne pretečejo
keep-close =
    .label = dokler ne zaprem { -brand-short-name }a
keep-ask =
    .label = vsakokrat me vprašaj

cookies-button =
    .label = Prikaži piškotke …
    .accesskey = P

do-not-track-label =
    .label = S signalom “Brez sledenja” sporočaj spletnim stranem, naj vam ne sledijo
    .accesskey = b

learn-button =
    .label = Več o tem

passwords-description = { -brand-short-name } si lahko zapomni gesla za vse vaše račune.

passwords-button =
    .label = Shranjena gesla …
    .accesskey = S

master-password-description = Glavno geslo varuje vsa vaša gesla, vendar ga morate vnesti vsaj enkrat na sejo.

master-password-label =
    .label = Uporabi glavno geslo
    .accesskey = U

master-password-button =
    .label = Nastavi glavno geslo …
    .accesskey = N


primary-password-description = Glavno geslo varuje vsa vaša gesla, vendar ga morate vnesti vsaj enkrat na sejo.

primary-password-label =
    .label = Uporabi glavno geslo
    .accesskey = U

primary-password-button =
    .label = Spremeni glavno geslo …
    .accesskey = S

forms-primary-pw-fips-title = Trenutno ste v načinu FIPS. FIPS zahteva glavno geslo, ki ni prazno.
forms-master-pw-fips-desc = Sprememba gesla neuspešna


junk-description = Nastavite svoje privzete nastavitve za neželeno pošto. Nastavitve neželene pošte za posamezni račun lahko prilagodite v nastavitvah računa.

junk-label =
    .label = Ko označim sporočila kot neželena:
    .accesskey = M

junk-move-label =
    .label = jih prestavi v mapo "Neželeno"
    .accesskey = r

junk-delete-label =
    .label = jih izbriši
    .accesskey = b

junk-read-label =
    .label = Označi neželena sporočila kot prebrana
    .accesskey = O

junk-log-label =
    .label = Omogoči dnevnik prilagodljivega filtra neželenih sporočil
    .accesskey = m

junk-log-button =
    .label = Pokaži dnevnik
    .accesskey = P

reset-junk-button =
    .label = Ponastavi podatke za učenje
    .accesskey = n

phishing-description = { -brand-short-name } lahko z iskanjem pogostih metod za zavajanje preverja sporočila in vas obvesti, če sumi, da vsebujejo e-poštno prevaro.

phishing-label =
    .label = Sporoči, če obstaja sum, da je prikazano sporočilo e-poštna prevara
    .accesskey = S

antivirus-description = { -brand-short-name } lahko omogoči protivirusnemu programu, da dohodna sporočila analizira, preden se krajevno shranijo.

antivirus-label =
    .label = Dovoli protivirusnim programom, da posamezna dohodna sporočila spravijo v karanteno
    .accesskey = D

certificate-description = Ko strežnik zahteva moje osebno potrdilo:

certificate-auto =
    .label = ga izberi samodejno
    .accesskey = s

certificate-ask =
    .label = me vsakokrat vprašaj
    .accesskey = v

ocsp-label =
    .label = Poizvej po odzivnih strežnikih OCSP za potrditev trenutne veljavnosti potrdil
    .accesskey = P

certificate-button =
    .label = Upravljanje potrdil …
    .accesskey = U

security-devices-button =
    .label = Varnostne naprave …
    .accesskey = V

## Chat Tab

startup-label =
    .value = Ko se { -brand-short-name } zažene:
    .accesskey = K

offline-label =
    .label = pusti moje račune za klepet nepovezane

auto-connect-label =
    .label = samodejno poveži moje račune za klepet

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Naj moji stiki vedo, da sem odsoten, po
    .accesskey = N

idle-time-label = minutah nedejavnosti

##

away-message-label =
    .label = in mojo odsotnost objavi s sporočilom stanja:
    .accesskey = o

send-typing-label =
    .label = Med pogovori pošiljaj obvestila o tipkanju
    .accesskey = M

notification-label = Kadar prispejo sporočila, namenjena meni:

show-notification-label =
    .label = prikaži obvestilo:
    .accesskey = a

notification-all =
    .label = s pošiljateljevim imenom in predogledom sporočila
notification-name =
    .label = samo s pošiljateljevim imenom
notification-empty =
    .label = brez podatkov

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animiraj ikono v doku
           *[other] Utripaj z gumbom opravilne vrstice
        }
    .accesskey =
        { PLATFORM() ->
            [macos] A
           *[other] U
        }

chat-play-sound-label =
    .label = predvajaj zvok
    .accesskey = r

chat-play-button =
    .label = Predvajaj
    .accesskey = e

chat-system-sound-label =
    .label = Privzeti sistemski zvok za novo pošto
    .accesskey = v

chat-custom-sound-label =
    .label = Uporabi naslednjo zvočno datoteko
    .accesskey = U

chat-browse-sound-button =
    .label = Prebrskaj …
    .accesskey = B

theme-label =
    .value = Tema:
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Oblački
style-dark =
    .label = Temno
style-paper =
    .label = Listi papirja
style-simple =
    .label = Preprosto

preview-label = Predogled:
no-preview-label = Predogled ni na voljo
no-preview-description = Ta tema ni veljavna ali trenutno ni na voljo (onemogočen dodatek, varni način …).

chat-variant-label =
    .value = Inačica:
    .accesskey = I

chat-header-label =
    .label = Prikaži glavo
    .accesskey = g

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
            [windows] Najdi v možnostih
           *[other] Najdi v nastavitvah
        }

## Preferences UI Search Results

search-results-header = Rezultati iskanja

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Oprostite! V možnostih ni zadetkov za “<span data-l10n-name="query"></span>”.
       *[other] Oprostite! V nastavitvah ni zadetkov za “<span data-l10n-name="query"></span>”.
    }

search-results-help-link = Potrebujete pomoč? Obiščite <a data-l10n-name="url">podporo za { -brand-short-name }</a>
