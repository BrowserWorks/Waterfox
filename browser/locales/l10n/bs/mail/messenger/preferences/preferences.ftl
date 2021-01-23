# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


close-button =
    .aria-label = Zatvori

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Opcije
           *[other] Postavke
        }

pane-compose-title = Sastavljanje
category-compose =
    .tooltiptext = Sastavljanje

pane-chat-title = Razgovor
category-chat =
    .tooltiptext = Razgovor

pane-calendar-title = Kalendar
category-calendar =
    .tooltiptext = Kalendar

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name } početna stranica

start-page-label =
    .label = Kad se { -brand-short-name } pokrene, prikaži početnu stranicu u prostoru za poruke
    .accesskey = W

location-label =
    .value = Lokacija:
    .accesskey = o
restore-default-label =
    .label = Vrati zadano
    .accesskey = R

default-search-engine = Zadani pretraživač

new-message-arrival = Kada stigne nova poruka:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Reproduciraj sljedeću zvučnu datoteku:
           *[other] Reproduciraj zvuk
        }
    .accesskey =
        { PLATFORM() ->
            [macos] d
           *[other] d
        }
mail-play-button =
    .label = Reproduciraj
    .accesskey = P

change-dock-icon = Promjeni postavke za aplikacijsku ikonu
app-icon-options =
    .label = Opcije aplikacijske ikone…
    .accesskey = n

notification-settings = Upozorenja i zadani zvukovi se mogu isključiti u okviru obavijesti u postavkama sistema.

animated-alert-label =
    .label = Prikaži upozorenje
    .accesskey = S
customize-alert-label =
    .label = Prilagodi…
    .accesskey = C

tray-icon-label =
    .label = Prikaži ikonu u sistemskoj traci
    .accesskey = t

mail-custom-sound-label =
    .label = Koristi sljedeću zvučnu datoteku
    .accesskey = U
mail-browse-sound-button =
    .label = Odaberi…
    .accesskey = B

enable-gloda-search-label =
    .label = Omogući globalno pretraživanje i indeksiranje
    .accesskey = e

datetime-formatting-legend = Oblikovanje datuma i vremena

allow-hw-accel =
    .label = Koristi hardversko ubrzanje kada je dostupno
    .accesskey = h

store-type-label =
    .value = Tip pohrane poruka za nove račune:
    .accesskey = T

mbox-store-label =
    .label = Datoteka po direktoriju (mbox)
maildir-store-label =
    .label = Datoteka po poruci (maildir)

scrolling-legend = Skrolanje
autoscroll-label =
    .label = Koristi automatsko skrolanje
    .accesskey = u
smooth-scrolling-label =
    .label = Koristi glatko skrolanje
    .accesskey = g

system-integration-legend = Sistemska integracija
always-check-default =
    .label = Prilikom pokretanja uvijek provjeri da li je { -brand-short-name } glavni email klijent
    .accesskey = a
check-default-button =
    .label = Provjeri sada…
    .accesskey = P

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows pretraga
       *[other] { "" }
    }

search-integration-label =
    .label = Dozvoli da { search-engine-name } pretražuje poruke
    .accesskey = D

config-editor-button =
    .label = Uređivač postavki…
    .accesskey = U

return-receipts-description = Odredite kako će { -brand-short-name } rukovati s potvrdama čitanja
return-receipts-button =
    .label = Potvrde čitanja…
    .accesskey = r

update-app-legend = { -brand-short-name } ažuriranja

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Verzija { $version }

automatic-updates-label =
    .label = Automatski instaliraj nadogradnje (preporučeno: unaprijeđena sigurnost)
    .accesskey = A
check-updates-label =
    .label = Provjeri za nadogradnje, ali me pitaj da li ih želim instalirati
    .accesskey = C

update-history-button =
    .label = Prikaži historijat nadogradnji
    .accesskey = P

use-service =
    .label = Koristi pozadinski servis za instalaciju nadogradnji
    .accesskey = K

networking-legend = Konekcija
proxy-config-description = Podesite kako se { -brand-short-name } konektuje na internet

network-settings-button =
    .label = Postavke…
    .accesskey = s

offline-legend = Offline
offline-settings = Podesite offline postavke

offline-settings-button =
    .label = Offline…
    .accesskey = O

diskspace-legend = Prostor na disku
offline-compact-folder =
    .label = Sažmi sve direktorije kada će uštedjeti više od
    .accesskey = a

compact-folder-size =
    .value = Ukupno MB

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Koristi do
    .accesskey = K

use-cache-after = MB prostora za keš

##

smart-cache-label =
    .label = Premosti automatsko upravljanje kešom
    .accesskey = v

clear-cache-button =
    .label = Očisti odmah
    .accesskey = O

fonts-legend = Fontovi i boje

default-font-label =
    .value = Zadani font:
    .accesskey = D

default-size-label =
    .value = Veličina:
    .accesskey = S

font-options-button =
    .label = Napredno…
    .accesskey = A

color-options-button =
    .label = Boje…
    .accesskey = C

display-width-legend = Poruke s običnim tekstom

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Grafički prikaži smješke
    .accesskey = e

display-text-label = Kod prikaza citiranih poruka s običnim tekstom:

style-label =
    .value = Stil:
    .accesskey = y

regular-style-item =
    .label = Normalno
bold-style-item =
    .label = Podebljano
italic-style-item =
    .label = Iskošeno
bold-italic-style-item =
    .label = Podebljan iskošen

size-label =
    .value = Veličina:
    .accesskey = z

regular-size-item =
    .label = Normalno
bigger-size-item =
    .label = Veće
smaller-size-item =
    .label = Manje

quoted-text-color =
    .label = Boja:
    .accesskey = o

search-input =
    .placeholder = Traži

type-column-label =
    .label = Vrsta sadržaja
    .accesskey = t

action-column-label =
    .label = Radnja
    .accesskey = a

save-to-label =
    .label = Sačuvaj datoteke u
    .accesskey = S

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Odaberi…
           *[other] Odaberi…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] B
        }

always-ask-label =
    .label = Uvijek me pitaj gdje sačuvati datoteke
    .accesskey = A


display-tags-text = Oznake se mogu koristiti za kategoriziranje i određivanje prioriteta vaših poruka.

new-tag-button =
    .label = Nova…
    .accesskey = N

edit-tag-button =
    .label = Uredi…
    .accesskey = E

delete-tag-button =
    .label = Izbriši
    .accesskey = D

auto-mark-as-read =
    .label = Automatski označi poruku kao pročitanu
    .accesskey = A

mark-read-no-delay =
    .label = Odmah pri prikazu
    .accesskey = o

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Nakon prikazivanja u trajanju od
    .accesskey = d

seconds-label = sekundi

##

open-msg-label =
    .value = Otvori poruke u:

open-msg-tab =
    .label = Novom tabu
    .accesskey = t

open-msg-window =
    .label = Novom prozoru poruke
    .accesskey = n

open-msg-ex-window =
    .label = Postojećem prozoru poruke
    .accesskey = e

close-move-delete =
    .label = Zatvori prozor/tab poruke prilikom premještanja ili brisanja
    .accesskey = C

condensed-addresses-label =
    .label = Prikaži samo ime za prikaz osoba iz mog imenika
    .accesskey = S

## Compose Tab

forward-label =
    .value = Proslijedi poruke:
    .accesskey = F

inline-label =
    .label = Unutar linije

as-attachment-label =
    .label = Kao prilog

extension-label =
    .label = dodaj nastavak nazivu datoteke
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Automatski sačuvaj svakih
    .accesskey = A

auto-save-end = minuta

##

warn-on-send-accel-key =
    .label = Zatraži potvrdu kod slanja poruke pomoću prečice na tastaturi
    .accesskey = C

spellcheck-label =
    .label = Provjeri pravopis prije slanja
    .accesskey = C

spellcheck-inline-label =
    .label = Omogući provjeru pravopisa prilikom pisanja
    .accesskey = E

language-popup-label =
    .value = Jezik:
    .accesskey = L

download-dictionaries-link = Preuzmi više rječnika

font-label =
    .value = Font:
    .accesskey = n

font-color-label =
    .value = Boja teksta:
    .accesskey = T

bg-color-label =
    .value = Boja pozadine:
    .accesskey = B

restore-html-label =
    .label = Vrati zadane postavke
    .accesskey = R

default-format-label =
    .label = Koristi kao zadano oblik odlomka umjesto teksta tijela
    .accesskey = P

format-description = Podesite ponašanje prilikom oblikovanja teksta

send-options-label =
    .label = Opcije slanja…
    .accesskey = S

autocomplete-description = Kod adresiranja poruka, traži odgovarajuće adrese u:

ab-label =
    .label = Lokalnom imeniku
    .accesskey = L

directories-label =
    .label = Server imenika:
    .accesskey = D

directories-none-label =
    .none = Ništa

edit-directories-label =
    .label = Uredi imenike…
    .accesskey = E

email-picker-label =
    .label = Automatski dodaj adrese e-pošte iz poslanih poruka u moj:
    .accesskey = A

default-directory-label =
    .value = Zadani početni direktorij u prozoru imenika:
    .accesskey = S

default-last-label =
    .none = Zadnji korišteni direktorij

attachment-label =
    .label = Provjeravaj nedostaju li prilozi
    .accesskey = m

attachment-options-label =
    .label = Ključne riječi…
    .accesskey = K

enable-cloud-share =
    .label = Ponuda za razmjenu datoteka većih od
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Dodaj…
    .accesskey = A
    .defaultlabel = Dodaj…

remove-cloud-account =
    .label = Ukloni
    .accesskey = R

cloud-account-description = Dodaj novu Filelink uslugu pohrane


## Privacy Tab

mail-content = Sadržaj poruke

remote-content-label =
    .label = Dozvoli vanjski sadržaj u porukama
    .accesskey = a

exceptions-button =
    .label = Izuzeci…
    .accesskey = I

remote-content-info =
    .value = Saznajte više o problemima oko privatnosti kod vanjskog sadržaja

web-content = Web sadržaj

history-label =
    .label = Zapamti web stranice i linkove koje sam posjetio
    .accesskey = R

cookies-label =
    .label = Prihvati kolačiće od stranica
    .accesskey = r

third-party-label =
    .value = Prihvati kolačiće trećih strana:
    .accesskey = h

third-party-always =
    .label = Uvijek
third-party-never =
    .label = Nikad
third-party-visited =
    .label = Od posjećenih

keep-label =
    .value = Zadrži do:
    .accesskey = Z

keep-expire =
    .label = iteka roka
keep-close =
    .label = zatvaranja { -brand-short-name }-a
keep-ask =
    .label = pitaj me svaki put

cookies-button =
    .label = Prikaži kolačiće…
    .accesskey = k

passwords-description = { -brand-short-name } može zapamtiti lozinke za sve vaše račune.

passwords-button =
    .label = Sačuvane lozinke…
    .accesskey = S

master-password-description = Glavna lozinka štiti sve vaše lozinke, ali se mora unijeti jednom za svaku prijavu.

master-password-label =
    .label = Koristi glavnu lozinku
    .accesskey = u

master-password-button =
    .label = Promjeni glavnu lozinku…
    .accesskey = P


junk-description = Postavite svoje zadane postavke neželjene pošte. Specifične postavke za pojedini račun se mogu podesiti u postavkama računa.

junk-label =
    .label = Kada označim poruke kao neželjenu poštu:
    .accesskey = K

junk-move-label =
    .label = Premjesti ih u direktorij "Neželjena pošta"
    .accesskey = j

junk-delete-label =
    .label = Izbriši ih
    .accesskey = I

junk-read-label =
    .label = Poruke za koje se utvrdi da su neželjena pošta označi kao pročitane
    .accesskey = u

junk-log-label =
    .label = Omogući prilagodljivi zapisnik filtera neželjene pošte
    .accesskey = m

junk-log-button =
    .label = Prikaži zapisnik
    .accesskey = P

reset-junk-button =
    .label = Vrati na početne postavke
    .accesskey = r

phishing-description = { -brand-short-name } može analizirati poruke e-pošte kako bi otkrio prevaru, tražeći tehnike koje se često koriste da bi vas zavarali.

phishing-label =
    .label = Obavjesti me ako se sumnja da je poruka koju čitam prevara
    .accesskey = O

antivirus-description = { -brand-short-name } može olakšati antivirusnim programima analizu primljenih poruka e-pošte na viruse prije nego se pohrane lokalno.

antivirus-label =
    .label = Dozvoli antivirusnim programima da izoliraju pojedine primljene poruke
    .accesskey = a

certificate-description = Kada server zatraži moj lični certifikat:

certificate-auto =
    .label = Automatski izaberi jedan
    .accesskey = A

certificate-ask =
    .label = Pitaj me svaki put
    .accesskey = a

ocsp-label =
    .label = Upitaj OCSP responsder servere za potvrdu ispravnosti certifikata
    .accesskey = U

## Chat Tab

startup-label =
    .value = Kada se { -brand-short-name } pokrene:
    .accesskey = s

offline-label =
    .label = Ostavi moj račun za razgovore odjavljenim

auto-connect-label =
    .label = Automatski spoji moje račune za razgovor

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Obavjesti moje kontakte da sam neaktivan nakon
    .accesskey = I

idle-time-label = minuta neaktivnosti

##

away-message-label =
    .label = i postavi moj status na Odsutan s ovom porukom:
    .accesskey = A

send-typing-label =
    .label = Šalji obavjest o tipkanju u razgovorima
    .accesskey = t

notification-label = Kada poruke adresirane na vas stignu:

show-notification-label =
    .label = Prikaži obavijest:
    .accesskey = c

notification-all =
    .label = s imenom pošiljaoca i pregledom poruke
notification-name =
    .label = samo s imenom pošiljaoca
notification-empty =
    .label = bez bilo kakvih informacija

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animiraj ikonicu u docku
           *[other] Zatreperi stavku u traci zadataka
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] F
        }

chat-play-sound-label =
    .label = Reproduciraj zvuk
    .accesskey = d

chat-play-button =
    .label = Reproduciraj
    .accesskey = P

chat-system-sound-label =
    .label = Zadani sistemski zvuk za novu poruku
    .accesskey = D

chat-custom-sound-label =
    .label = Koristi sljedeću zvučnu datoteku
    .accesskey = U

chat-browse-sound-button =
    .label = Odaberi…
    .accesskey = B

theme-label =
    .value = Tema:
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Mjehurići
style-dark =
    .label = Tamno
style-paper =
    .label = Papirni listovi
style-simple =
    .label = Jednostavno

preview-label = Pregled:
no-preview-label = Nije dostupan pregled
no-preview-description = Ova tema nije važeća ili trenutno nije dostupna (onemogućeni dodatak, siguran režim, ...).

chat-variant-label =
    .value = Varijanta:
    .accesskey = V

chat-header-label =
    .label = Prikaži zaglavlje
    .accesskey = H

## Preferences UI Search Results

