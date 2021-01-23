# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


close-button =
    .aria-label = Sulge

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Valikud
           *[other] Eelistused
        }

pane-general-title = Üldine
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Koostamine
category-compose =
    .tooltiptext = Koostamine

pane-privacy-title = Privaatsus ja turvalisus
category-privacy =
    .tooltiptext = Privaatsus ja turvalisus

pane-chat-title = Kiirsuhtlus
category-chat =
    .tooltiptext = Kiirsuhtlus

pane-calendar-title = Kalender
category-calendar =
    .tooltiptext = Kalender

general-language-and-appearance-header = Keel ja välimus

general-incoming-mail-header = Saabuvad kirjad:

general-files-and-attachment-header = Failid ja manused

general-tags-header = Sildid

general-reading-and-display-header = Lugemine ja kuvamine

general-updates-header = Uuendused

general-network-and-diskspace-header = Võrk ja kettaruum

general-indexing-label = Indekseerimine

composition-category-header = Koostamine

composition-attachments-header = Manused

composition-spelling-title = Õigekiri

compose-html-style-title = HTML-stiil

composition-addressing-header = Adresseerimine

privacy-main-header = Privaatsus

privacy-passwords-header = Paroolid

privacy-junk-header = Rämpspost

privacy-security-header = Turvalisus

privacy-scam-detection-title = Kelmuse tuvastamine

privacy-anti-virus-title = Viirusetõrje

privacy-certificates-title = Serdid

chat-pane-header = Kiirsuhtlus

chat-status-title = Olek

chat-notifications-title = Teavitused

chat-pane-styling-header = Kujundus

choose-messenger-language-description = Vali keeled, mida kasutatakse menüüde, sõnumite ja { -brand-short-name }ilt tulevate teavituste kuvamiseks.
manage-messenger-languages-button =
    .label = Määra alternatiivsed keeled…
    .accesskey = M
confirm-messenger-language-change-description = Muudatuste rakendamiseks taaskäivita { -brand-short-name }
confirm-messenger-language-change-button = Rakenda ja taaskäivita

update-setting-write-failure-title = Uuendamise sätete salvestamisel esines viga

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name }il esines viga ja muudatust ei salvestatud. Antud sätte muutmiseks on vajalikud õigused alloleva faili muutmiseks. Probleem võib laheneda, kui sina või sinu süsteemiadministraator annab Users grupile täielikud muutmise õigused sellele failile.
    
    Järgmist faili polnud võimalik muuta: { $path }

update-in-progress-title = Uuendamine

update-in-progress-message = Kas soovid, et { -brand-short-name } jätkaks uuendamisega?

update-in-progress-ok-button = &Loobu
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Jätka

addons-button = Laiendused ja teemad

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = F
focus-search-shortcut-alt =
    .key = K

general-legend = { -brand-short-name }i avaleht

start-page-label =
    .label = { -brand-short-name }i käivitumisel näidatakse kirja alas avalehte
    .accesskey = i

location-label =
    .value = Asukoht:
    .accesskey = o
restore-default-label =
    .label = Taasta algväärtus
    .accesskey = T

default-search-engine = Vaikeotsingumootor
add-search-engine =
    .label = Lisa failist
    .accesskey = f
remove-search-engine =
    .label = Eemalda
    .accesskey = E

new-message-arrival = Uue kirja saabumisel:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Esitatakse järgmist helifaili:
           *[other] mängitakse helifaili
        }
    .accesskey =
        { PLATFORM() ->
            [macos] h
           *[other] g
        }
mail-play-button =
    .label = Esita
    .accesskey = E

change-dock-icon = Rakenduse ikooni sätete muutmine
app-icon-options =
    .label = Rakenduse ikooni sätted…
    .accesskey = n

notification-settings = Teated ja vaikimisi heli saab välja lülitada paneelilt Teavitused süsteemi eelistustes.

animated-alert-label =
    .label = kuvatakse teadet
    .accesskey = u
customize-alert-label =
    .label = Kohanda...
    .accesskey = K

tray-icon-label =
    .label = Kuvatakse süsteemisalve ikooni
    .accesskey = v

mail-custom-sound-label =
    .label = kasutatakse järgnevat helifaili
    .accesskey = e
mail-browse-sound-button =
    .label = Lehitse...
    .accesskey = L

enable-gloda-search-label =
    .label = Lubatakse kirjade üldotsing ja indekseerimine
    .accesskey = L

datetime-formatting-legend = Kuupäeva ja kellaaja vorming
language-selector-legend = Keel

allow-hw-accel =
    .label = Võimalusel kasutatakse riistvaralist kiirendust
    .accesskey = V

store-type-label =
    .value = Uute kontode kirjade salvestamise viis:
    .accesskey = U

mbox-store-label =
    .label = üks fail kausta kohta (mbox)
maildir-store-label =
    .label = iga kiri eraldi failis (maildir)

scrolling-legend = Kerimine
autoscroll-label =
    .label = Kasutatakse automaatset kerimist
    .accesskey = u
smooth-scrolling-label =
    .label = Kasutatakse sujuvat kerimist
    .accesskey = s

system-integration-legend = Süsteemi integratsioon
always-check-default =
    .label = Käivitumisel kontrollitakse alati, kas { -brand-short-name } on e-posti vaikeklient
    .accesskey = a
check-default-button =
    .label = Kontrolli nüüd…
    .accesskey = n

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

search-integration-label =
    .label = Rakendusel { search-engine-name } on kirjade otsimine lubatud
    .accesskey = R

config-editor-button =
    .label = Konfiguratsiooni redaktor...
    .accesskey = n

return-receipts-description = Määra, kuidas { -brand-short-name } käsitleb kättesaamise kinnitusi
return-receipts-button =
    .label = Kättesaamise kinnitused...
    .accesskey = M

update-app-legend = { -brand-short-name }i uuendused

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Versioon { $version }

allow-description = { -brand-short-name }il lubatakse
automatic-updates-label =
    .label = uuendused automaatselt paigaldada (soovitatav: parem turvalisus)
    .accesskey = u
check-updates-label =
    .label = kontrollida uuenduste olemasolu, paigaldamise kohta küsitakse kinnitust
    .accesskey = k

update-history-button =
    .label = Näita uuenduste ajalugu
    .accesskey = j

use-service =
    .label = Uuenduste paigaldamiseks kasutatakse taustateenust
    .accesskey = U

cross-user-udpate-warning = See säte rakendub kõigile Windowsi kontodele ja { -brand-short-name }i profiilidele, mis kasutavad seda { -brand-short-name }i paigaldust.

networking-legend = Ühendus
proxy-config-description = Määra, kuidas { -brand-short-name } ühendub internetti.

network-settings-button =
    .label = Sätted...
    .accesskey = d

offline-legend = Ühenduseta
offline-settings = Võrguta režiimi häälestamine

offline-settings-button =
    .label = Sätted
    .accesskey = S

diskspace-legend = Kettaruum
offline-compact-folder =
    .label = Kõik kaustad surutakse kokku, kui see säästab kokku rohkem kui
    .accesskey = b

compact-folder-size =
    .value = MiB

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Vahemäluks kasutatakse kuni
    .accesskey = V

use-cache-after = MiB mälu

##

smart-cache-label =
    .label = Keelatakse automaatne vahemälu haldamine
    .accesskey = u

clear-cache-button =
    .label = Puhasta nüüd
    .accesskey = P

fonts-legend = Fondid ja värvid

default-font-label =
    .value = Vaikimisi font:
    .accesskey = V

default-size-label =
    .value = Suurus:
    .accesskey = S

font-options-button =
    .label = Fondid...
    .accesskey = F

color-options-button =
    .label = Värvid…
    .accesskey = r

display-width-legend = Lihttekstis kirjad

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Emotikonide graafiline esitamine
    .accesskey = m

display-text-label = Tsiteeritud lihttekstiga kirjade kuvamine:

style-label =
    .value = Stiil:
    .accesskey = t

regular-style-item =
    .label = tavaline
bold-style-item =
    .label = paks
italic-style-item =
    .label = kaldkiri
bold-italic-style-item =
    .label = paks kaldkiri

size-label =
    .value = Suurus:
    .accesskey = S

regular-size-item =
    .label = tavaline
bigger-size-item =
    .label = suurem
smaller-size-item =
    .label = väiksem

quoted-text-color =
    .label = Värv:
    .accesskey = V

search-input =
    .placeholder = Otsi

type-column-label =
    .label = Sisu tüüp
    .accesskey = S

action-column-label =
    .label = Tegevus
    .accesskey = T

save-to-label =
    .label = Failid salvestatakse asukohta
    .accesskey = F

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Lehitse…
           *[other] Lehitse…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] L
           *[other] L
        }

always-ask-label =
    .label = Alati küsitakse, kuhu failid salvestatakse
    .accesskey = A


display-tags-text = Silte saab kasutada kirjade kategoriseerimiseks ja prioriteedi määramiseks.

new-tag-button =
    .label = Uus…
    .accesskey = U

edit-tag-button =
    .label = Redigeeri…
    .accesskey = R

delete-tag-button =
    .label = Kustuta
    .accesskey = K

auto-mark-as-read =
    .label = Kirjad märgitakse automaatselt loetuks
    .accesskey = K

mark-read-no-delay =
    .label = kohe pärast kuvamist
    .accesskey = o

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = märgitakse loetuks pärast
    .accesskey = m

seconds-label = sekundit

##

open-msg-label =
    .value = Kirjad avatakse:

open-msg-tab =
    .label = uuel kaardil
    .accesskey = u

open-msg-window =
    .label = uues aknas
    .accesskey = a

open-msg-ex-window =
    .label = samas aknas
    .accesskey = s

close-move-delete =
    .label = Kustutamisel või liigutamisel kirja aken/kaart suletakse
    .accesskey = K

display-name-label =
    .value = Kuvatav nimi:

condensed-addresses-label =
    .label = Aadressiraamatus olevate kontaktide puhul näidatakse ainult kuvatavat nime
    .accesskey = k

## Compose Tab

forward-label =
    .value = Kirjad edastatakse:
    .accesskey = K

inline-label =
    .label = tekstina

as-attachment-label =
    .label = manusena

extension-label =
    .label = failinimele lisatakse laiend
    .accesskey = f

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Salvestatakse automaatselt iga
    .accesskey = o

auto-save-end = minuti järel

##

warn-on-send-accel-key =
    .label = Küsitakse kinnitust, kui kiri saadetakse klahvide kiirkombinatsiooni abil
    .accesskey = t

spellcheck-label =
    .label = Enne saatmist kontrollitakse õigekirja
    .accesskey = E

spellcheck-inline-label =
    .label = Sisestamisel kontrollitakse õigekirja
    .accesskey = k

language-popup-label =
    .value = Keel:
    .accesskey = K

download-dictionaries-link = Hangi veel sõnaraamatuid

font-label =
    .value = Font:
    .accesskey = n

font-size-label =
    .value = Suurus:
    .accesskey = u

default-colors-label =
    .label = Kasutatakse kuvamise vaikevärve
    .accesskey = v

font-color-label =
    .value = Teksti värv:
    .accesskey = k

bg-color-label =
    .value = Taustavärv:
    .accesskey = v

restore-html-label =
    .label = Lähtesta
    .accesskey = a

default-format-label =
    .label = Vaikimisi kasututatakse lõiguvormingut
    .accesskey = e

format-description = Muuda saadetavate kirjade teksti vormingut

send-options-label =
    .label = Saatmise valikud...
    .accesskey = S

autocomplete-description = Kirjade adresseerimisel otsitakse sobivaid vasteid:

ab-label =
    .label = kohalikest aadressiraamatutest
    .accesskey = a

directories-label =
    .label = kataloogiserverist:
    .accesskey = k

directories-none-label =
    .none = puudub

edit-directories-label =
    .label = Redigeeri katalooge...
    .accesskey = R

email-picker-label =
    .label = Väljuvate kirjade adressaadid lisatakse automaatselt:
    .accesskey = k

default-directory-label =
    .value = Käivitumisel aadressiraamatu aknas kuvatav vaikekataloog:
    .accesskey = i

default-last-label =
    .none = Viimasena kasutatud kataloog

attachment-label =
    .label = Kontrollitakse puuduvat manust
    .accesskey = K

attachment-options-label =
    .label = Võtmesõnad…
    .accesskey = V

enable-cloud-share =
    .label = Pilveteenuste kasutamist pakutakse suuremate failide puhul kui
cloud-share-size =
    .value = MiB

add-cloud-account =
    .label = Lisa…
    .accesskey = L
    .defaultlabel = Lisa…

remove-cloud-account =
    .label = Eemalda
    .accesskey = E

find-cloud-providers =
    .value = Leia veel teenusepakkujaid…

cloud-account-description = Lisa uus pilveteenus


## Privacy Tab

mail-content = E-posti sisu

remote-content-label =
    .label = Kirjades lubatakse väline sisu
    .accesskey = i

exceptions-button =
    .label = Erandid…
    .accesskey = E

remote-content-info =
    .value = Rohkem teavet välise sisuga seonduvatest privaatsuse probleemidest

web-content = Veebisisu

history-label =
    .label = Külastatud saidid ja lingid peetakse meeles
    .accesskey = a

cookies-label =
    .label = Küpsised lubatakse
    .accesskey = K

third-party-label =
    .value = Kolmanda osapoole küpsised lubatakse:
    .accesskey = o

third-party-always =
    .label = alati
third-party-never =
    .label = mitte kunagi
third-party-visited =
    .label = varem külastatud saitidelt

keep-label =
    .value = Säilitatakse kuni:
    .accesskey = l

keep-expire =
    .label = nad aeguvad
keep-close =
    .label = { -brand-short-name } suletakse
keep-ask =
    .label = küsitakse iga kord

cookies-button =
    .label = Näita küpsiseid…
    .accesskey = S

do-not-track-label =
    .label = Saitidele saadetakse signaal, et sa ei soovi olla jälitatud
    .accesskey = s

learn-button =
    .label = Rohkem teavet

passwords-description = { -brand-short-name } võib paroolide infot meeles pidada, et sa ei peaks logimisel neid uuesti sisestama.

passwords-button =
    .label = Salvestatud paroolid…
    .accesskey = S

master-password-description = Kui ülemparool on määratud, kaitseb see sinu paroole, kuid sa pead sisestama selle seansi alguses.

master-password-label =
    .label = Kasutatakse ülemparooli
    .accesskey = K

master-password-button =
    .label = Muuda ülemparooli…
    .accesskey = M


junk-description = Määra oma vaikimisi rämpsposti sätted. Kontopõhiseid rämpsposti sätteid saab häälestada konto sätetes.

junk-label =
    .label = Kui kirjad märgitakse rämpspostiks:
    .accesskey = K

junk-move-label =
    .label = liigutatakse nad konto "Rämpspost" kausta
    .accesskey = l

junk-delete-label =
    .label = need kustutatakse
    .accesskey = t

junk-read-label =
    .label = Rämpspostiks määratud kirjad märgitakse loetuks
    .accesskey = k

junk-log-label =
    .label = Kohastuva rämpsposti filtri logimine lubatakse
    .accesskey = f

junk-log-button =
    .label = Kuva logi
    .accesskey = u

reset-junk-button =
    .label = Lähtesta rämpsposti filtrid
    .accesskey = r

phishing-description = { -brand-short-name } saab kirju analüüsida, et avastada tuntumaid e-posti pettuste skeeme, millega üritatakse kasutajaid tüssata.

phishing-label =
    .label = Teavitatakse, kui kirja peetakse petukirjaks
    .accesskey = T

antivirus-description = { -brand-short-name } võib saabuvate kirjade analüüsimise enne nende lokaalset salvestamist viirustõrje tarkvarale lihtsamaks teha.

antivirus-label =
    .label = Viirustõrje tarkvaral lubatakse üksikuid saabuvaid kirju karantiini panna
    .accesskey = i

certificate-description = Kui server nõuab kasutaja isiklikku sertifikaati:

certificate-auto =
    .label = valitakse üks automaatselt
    .accesskey = v

certificate-ask =
    .label = küsitakse iga kord
    .accesskey = k

ocsp-label =
    .label = Sertifikaatide valideeruvust kontrollitakse OCSP abil
    .accesskey = S

certificate-button =
    .label = Halda sertifikaate…
    .accesskey = H

security-devices-button =
    .label = Turvaseadmed…
    .accesskey = T

## Chat Tab

startup-label =
    .value = { -brand-short-name }i käivitumisel:
    .accesskey = k

offline-label =
    .label = jäetakse kiirsuhtluse kontod ühendamata

auto-connect-label =
    .label = ühendatakse kiirsuhtluse kontod automaatselt

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Kontaktidele antakse jõudeolekust teada
    .accesskey = o

idle-time-label = minuti möödumisel

##

away-message-label =
    .label = ning eemaloleku teateks määratakse:
    .accesskey = n

send-typing-label =
    .label = Teist poolt teavitatakse teksti sisestamisest vestlustes
    .accesskey = T

notification-label = Uue sõnumi saabumisel:

show-notification-label =
    .label = Teavitusi kuvatakse
    .accesskey = u

notification-all =
    .label = koos saatja nime ja sõnumi eelvaatega
notification-name =
    .label = koos saatja nimega
notification-empty =
    .label = ilma lisainfota

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animeeritakse doki ikooni
           *[other] Vilgutatakse tegumiriba nuppu
        }
    .accesskey =
        { PLATFORM() ->
            [macos] i
           *[other] V
        }

chat-play-sound-label =
    .label = antakse märku heliga
    .accesskey = h

chat-play-button =
    .label = Esita
    .accesskey = E

chat-system-sound-label =
    .label = süsteemi vaikimisi uue kirja heli
    .accesskey = s

chat-custom-sound-label =
    .label = kasutatakse järgnevat helifaili
    .accesskey = a

chat-browse-sound-button =
    .label = Lehitse…
    .accesskey = L

theme-label =
    .value = Teema:
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Mullid
style-dark =
    .label = Tume
style-paper =
    .label = Paberilehed
style-simple =
    .label = Lihtne

preview-label = Eelvaade:
no-preview-label = Eelvaade pole saadaval
no-preview-description = See teema pole korrektne või pole praegu saadaval (keelatud lisa, ohutu režiim, …).

chat-variant-label =
    .value = Variant:
    .accesskey = V

chat-header-label =
    .label = Kuva päist
    .accesskey = K

## Preferences UI Search Results

