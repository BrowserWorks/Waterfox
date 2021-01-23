# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Zatvori

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Mogućnosti
           *[other] Postavke
        }

pane-general-title = Općenito
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Sastavljanje
category-compose =
    .tooltiptext = Sastavljanje

pane-privacy-title = Privatnost i sigurnost
category-privacy =
    .tooltiptext = Privatnost i sigurnost

pane-chat-title = Razgovor
category-chat =
    .tooltiptext = Razgovor

pane-calendar-title = Kalendar
category-calendar =
    .tooltiptext = Kalendar

general-language-and-appearance-header = Jezik i izgled

general-incoming-mail-header = Dolazna pošta

general-files-and-attachment-header = Datoteke i privici

general-tags-header = Oznake

general-reading-and-display-header = Čitanje i prikaz

general-updates-header = Ažuriranja

general-network-and-diskspace-header = Mreža i diskovni prostor

general-indexing-label = Indeksiranje

composition-category-header = Sastavljanje

composition-attachments-header = Privici

composition-spelling-title = Pravopis

compose-html-style-title = HTML stil

composition-addressing-header = Adresiranje

privacy-main-header = Privatnost

privacy-passwords-header = Lozinke

privacy-junk-header = Neželjena pošta

collection-header = { -brand-short-name } – prikupljanje i upotreba podataka

collection-description = Želimo ti omogućiti izbor i prikupljamo samo onoliko koliko nam treba da omogućimo i unaprijedimo { -brand-short-name } za sve. Uvijek pitamo za dozvolu prije nego što počnemo primati osobne podatke.
collection-privacy-notice = Napomena o privatnosti

collection-health-report-telemetry-disabled = Više ne dopuštaš { -vendor-short-name }u snimanje tehničkih podataka i podataka o interakciji. Svi stari podaci bit će izbrisani u roku od 30 dana.
collection-health-report-telemetry-disabled-link = Saznaj više

collection-health-report =
    .label = Dozvoli { -brand-short-name }u slati tehničke podatke i podatke o interakcijama organizaciji { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Saznaj više

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Izvještavanje podataka je deaktivirano za ovu konfiguraciju izgradnje

collection-backlogged-crash-reports =
    .label = Dozvoli { -brand-short-name }u slati zapise o rušenju u tvoje ime
    .accesskey = z
collection-backlogged-crash-reports-link = Saznaj više

privacy-security-header = Sigurnost

privacy-scam-detection-title = Otkrivanje prevara

privacy-anti-virus-title = Antivirus

privacy-certificates-title = Certifikati

chat-pane-header = Razgovor

chat-status-title = Status

chat-notifications-title = Obavijesti

chat-pane-styling-header = Stilsko oblikovanje

choose-messenger-language-description = Odaberite jezike koji će se koristiti za prikaz izbornika, poruka i obavijesti u { -brand-short-name }.
manage-messenger-languages-button =
    .label = Postavi alternative…
    .accesskey = o
confirm-messenger-language-change-description = Ponovno pokrenite { -brand-short-name } kako biste primjenili ove izmjene
confirm-messenger-language-change-button = Primjeni i ponovno pokreni

update-setting-write-failure-title = Pogreška prilikom spremanju postavki ažuriranja

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } je naišao na pogrešku i nije spremio ovu promjenu. Uzmite u obzir da postavljanje postavki za ovo ažuriranje zahtjeva dozvole za pisanje u niže navedenu datoteku. Vi ili vaš administrator sustava možda ste u mogućnosti otkloniti ovu grešku tako da dozvolite grupi korisnika potpunu kontrolu nad ovom datotekom.
    
    Nije moguće pisati u datoteku: { $path }

update-in-progress-title = Ažuriranje u tijeku

update-in-progress-message = Želiš li da { -brand-short-name } nastavi s ovim ažuriranjem?

update-in-progress-ok-button = O&dbaci
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Nastavi

addons-button = Proširenja i motivi

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Za stvaranje glavne lozinke, upiši svoje podatke za prijavu na Windows. To pomaže zaštiti sigurnost tvojih računa.

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = stvori glavnu lozinku

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Za stvaranje glavne lozinke, upiši svoje podatke za prijavu na Windows. To pomaže u zaštiti vaših računa.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = stvori glavnu lozinku

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name } početna stranica

start-page-label =
    .label = Kad se { -brand-short-name } pokrene, prikaži početnu stranicu u prostoru za poruke
    .accesskey = K

location-label =
    .value = Lokacija:
    .accesskey = o
restore-default-label =
    .label = Vrati zadano
    .accesskey = r

default-search-engine = Zadani pretraživač
add-search-engine =
    .label = Dodaj iz datoteke
    .accesskey = a
remove-search-engine =
    .label = Ukloni
    .accesskey = U

minimize-to-tray-label =
    .label = Kada je { -brand-short-name } smanjen, premjesti ga u sistemsku traku
    .accesskey = m

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
           *[other] v
        }
mail-play-button =
    .label = Reproduciraj
    .accesskey = c

change-dock-icon = Promjeni postavke za aplikacijsku ikonu
app-icon-options =
    .label = Mogućnosti aplikacijske ikone…
    .accesskey = n

notification-settings = Obavijesti i zadani zvukovi se mogu isključiti u okviru obavijesti u postavkama sustava.

animated-alert-label =
    .label = Prikaži obavijest
    .accesskey = P
customize-alert-label =
    .label = Prilagodi…
    .accesskey = a

tray-icon-label =
    .label = Prikaži ikonu u sistemskoj traci
    .accesskey = s

mail-system-sound-label =
    .label = Standardni zvuk sustava za novu poštu
    .accesskey = S
mail-custom-sound-label =
    .label = Koristi sljedeću zvučnu datoteku
    .accesskey = u
mail-browse-sound-button =
    .label = Odaberi…
    .accesskey = b

enable-gloda-search-label =
    .label = Omogući globalno pretraživanje i indeksiranje
    .accesskey = e

datetime-formatting-legend = Oblikovanje datuma i vremena
language-selector-legend = Jezik

allow-hw-accel =
    .label = Koristi hardversku akceleraciju kad je moguće
    .accesskey = h

store-type-label =
    .value = Tip pohrane poruka za nove račune:
    .accesskey = T

mbox-store-label =
    .label = Datoteka po mapi (mbox)
maildir-store-label =
    .label = Datoteka po poruci (maildir)

scrolling-legend = Klizanje
autoscroll-label =
    .label = Koristi automatsko klizanje
    .accesskey = t
smooth-scrolling-label =
    .label = Koristi glatko klizanje
    .accesskey = g

system-integration-legend = Sistemska integracija
always-check-default =
    .label = Prilikom pokretanja uvijek provjeri je li { -brand-short-name } zadani program za e-poštu
    .accesskey = a
check-default-button =
    .label = Provjeri sada…
    .accesskey = P

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows pretraživanje
       *[other] { "" }
    }

search-integration-label =
    .label = Dopusti da { search-engine-name } pretražuje poruke
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
update-app-version = Inačica { $version }

allow-description = Dozvoli { -brand-short-name } da
automatic-updates-label =
    .label = Automatski instaliraj dopune (preporučeno: poboljšana sigurnost)
    .accesskey = A
check-updates-label =
    .label = Provjeri dostupnost dopuna, ali mi ponudi želim li ih instalirati
    .accesskey = d

update-history-button =
    .label = Prikaži povijest ažuriranja
    .accesskey = P

use-service =
    .label = Koristi pozadinski proces za instalaciju nadogradnji
    .accesskey = K

cross-user-udpate-warning = Ove postavke će se primijeniti na sve Windows račune i { -brand-short-name } profile koji koriste ovu { -brand-short-name } instalaciju.

networking-legend = Veza
proxy-config-description = Podesite način na koji se{ -brand-short-name } povezuje na Internet

network-settings-button =
    .label = Postavke…
    .accesskey = s

offline-legend = Izvanmrežno
offline-settings = Podesi izvanmrežne postavke

offline-settings-button =
    .label = Izvanmrežno…
    .accesskey = I

diskspace-legend = Diskovni prostor
offline-compact-folder =
    .label = Sažmi sve mape kada će uštedjeti više od
    .accesskey = a

compact-folder-size =
    .value = MB ukupno

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Koristi do
    .accesskey = K

use-cache-after = MB prostora za priručnu memoriju

##

smart-cache-label =
    .label = Premosti automatsko upravljanje priručnom memorijom
    .accesskey = v

clear-cache-button =
    .label = Očisti sada
    .accesskey = O

fonts-legend = Fontovi i boje

default-font-label =
    .value = Zadani font:
    .accesskey = d

default-size-label =
    .value = Veličina:
    .accesskey = l

font-options-button =
    .label = Napredno…
    .accesskey = N

color-options-button =
    .label = Boje…
    .accesskey = B

display-width-legend = Poruke s običnim tekstom

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Grafički prikaži smješke
    .accesskey = r

display-text-label = Kod prikaza citiranih poruka s običnim tekstom:

style-label =
    .value = Stil:
    .accesskey = i

regular-style-item =
    .label = Normalno
bold-style-item =
    .label = Podebljano
italic-style-item =
    .label = Kurziv
bold-italic-style-item =
    .label = Podebljani kurziv

size-label =
    .value = Veličina:
    .accesskey = V

regular-size-item =
    .label = Normalno
bigger-size-item =
    .label = Veće
smaller-size-item =
    .label = Manje

quoted-text-color =
    .label = Boja:
    .accesskey = B

search-input =
    .placeholder = Traži

type-column-label =
    .label = Vrsta sadržaja
    .accesskey = t

action-column-label =
    .label = Radnja
    .accesskey = a

save-to-label =
    .label = Spremi datoteke u
    .accesskey = S

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Odaberi…
           *[other] Odaberi…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] i
           *[other] i
        }

always-ask-label =
    .label = Uvijek me pitaj gdje spremiti datoteke
    .accesskey = U


display-tags-text = Oznake se mogu koristiti za kategoriziranje i određivanje prioriteta vaših poruka.

new-tag-button =
    .label = Nova…
    .accesskey = N

edit-tag-button =
    .label = Uredi…
    .accesskey = e

delete-tag-button =
    .label = Obriši
    .accesskey = O

auto-mark-as-read =
    .label = Automatski označi poruku kao pročitanu
    .accesskey = A

mark-read-no-delay =
    .label = Odmah pri prikazu
    .accesskey = O

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
    .label = Novoj kartici
    .accesskey = t

open-msg-window =
    .label = Novom prozoru poruke
    .accesskey = N

open-msg-ex-window =
    .label = Postojećem prozoru poruke
    .accesskey = e

close-move-delete =
    .label = Zatvori prozor/karticu poruke prilikom premještanja ili brisanja
    .accesskey = Z

display-name-label =
    .value = Ime za prikaz:

condensed-addresses-label =
    .label = Prikaži samo ime za prikaz osoba iz mojeg adresara
    .accesskey = P

## Compose Tab

forward-label =
    .value = Proslijedi poruke:
    .accesskey = P

inline-label =
    .label = Ugrađeno

as-attachment-label =
    .label = Kao privitak

extension-label =
    .label = dodaj nastavak nazivu datoteke
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Automatski spremi svakih
    .accesskey = A

auto-save-end = minuta

##

warn-on-send-accel-key =
    .label = Zatraži potvrdu kod slanja poruke pomoću tipkovničke kratice
    .accesskey = o

spellcheck-label =
    .label = Provjeri pravopis prije slanja
    .accesskey = P

spellcheck-inline-label =
    .label = Omogući provjeru pravopisa prilikom pisanja
    .accesskey = e

language-popup-label =
    .value = Jezik:
    .accesskey = J

download-dictionaries-link = Preuzmi više rječnika

font-label =
    .value = Font:
    .accesskey = F

font-size-label =
    .value = Veličina:
    .accesskey = V

default-colors-label =
    .label = Koristi zadane boje čitatelja
    .accesskey = d

font-color-label =
    .value = Boja teksta:
    .accesskey = t

bg-color-label =
    .value = Boja pozadine:
    .accesskey = B

restore-html-label =
    .label = Vrati zadane postavke
    .accesskey = r

default-format-label =
    .label = Koristi kao zadano oblik odlomka umjesto teksta tijela
    .accesskey = o

format-description = Podesite ponašanje prilikom oblikovanja teksta

send-options-label =
    .label = Mogućnosti slanja…
    .accesskey = s

autocomplete-description = Kod adresiranja poruka, traži odgovarajuće adrese u:

ab-label =
    .label = Lokalnom adresaru
    .accesskey = L

directories-label =
    .label = Poslužiteljskom imeniku:
    .accesskey = P

directories-none-label =
    .none = Nepostojeći

edit-directories-label =
    .label = Uredi imenike…
    .accesskey = e

email-picker-label =
    .label = Automatski dodaj adrese e-pošte iz poslanih poruka u moj:
    .accesskey = A

default-directory-label =
    .value = Zadana početna mapa u prozoru adresara:
    .accesskey = s

default-last-label =
    .none = Zadnje korištena mapa

attachment-label =
    .label = Provjeravaj nedostaju li privici
    .accesskey = n

attachment-options-label =
    .label = Ključne riječi…
    .accesskey = K

enable-cloud-share =
    .label = Ponuda za razmjenu datoteka većih od
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Dodaj…
    .accesskey = a
    .defaultlabel = Dodaj…

remove-cloud-account =
    .label = Ukloni
    .accesskey = U

find-cloud-providers =
    .value = Pronađite više davatelja usluga…

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
    .label = Zapamti web stranice i poveznice koje sam posjetio
    .accesskey = r

cookies-label =
    .label = Prihvati kolačiće od stranica
    .accesskey = r

third-party-label =
    .value = Prihvati kolačiće trećih strana:
    .accesskey = h

third-party-always =
    .label = Uvijek
third-party-never =
    .label = Nikada
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
    .label = pitaj me svaki puta

cookies-button =
    .label = Prikaži kolačiće…
    .accesskey = k

do-not-track-label =
    .label = Šalji “Ne prati me” signal web stranicama (stranice ga ne moraju poštivati)
    .accesskey = N

learn-button =
    .label = Saznajte više

passwords-description = { -brand-short-name } može zapamtiti lozinke za sve vaše račune.

passwords-button =
    .label = Spremljene lozinke…
    .accesskey = S

master-password-description = Glavna lozinka štiti sve vaše lozinke, ali se mora unijeti jednom za svaku prijavu.

master-password-label =
    .label = Koristi glavnu lozinku
    .accesskey = u

master-password-button =
    .label = Promjeni glavnu lozinku…
    .accesskey = P


primary-password-description = Glavna lozinka štiti sve vaše lozinke, ali se mora unijeti jednom za svaku prijavu.

primary-password-label =
    .label = Koristi glavnu lozinku
    .accesskey = u

primary-password-button =
    .label = Promijeni glavnu lozinku…
    .accesskey = m

forms-primary-pw-fips-title = Trenutačno ste u FIPS načinu rada. FIPS ne dopušta praznu glavnu lozinku.
forms-master-pw-fips-desc = Promjena lozinke nije uspjela


junk-description = Postavite svoje zadane postavke neželjene pošte. Specifične postavke za pojedini račun se mogu podesiti u postavkama računa.

junk-label =
    .label = Kada označim poruke kao neželjenu poštu:
    .accesskey = K

junk-move-label =
    .label = Premjesti ih u mapu "Neželjena pošta"
    .accesskey = j

junk-delete-label =
    .label = Obriši ih
    .accesskey = O

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

phishing-description = { -brand-short-name } može analizirati poruke e-pošte kako bi otkrio prijevaru, tražeći tehnike koje se često koriste da bi vas zavarali.

phishing-label =
    .label = Obavjesti me ako se sumnja da je poruka koju čitam prijevara
    .accesskey = O

antivirus-description = { -brand-short-name } može olakšati antivirusnim programima analizu primljenih poruka e-pošte na viruse prije nego se pohrane lokalno.

antivirus-label =
    .label = Dozvoli antivirusnim programima da izoliraju pojedine primljene poruke
    .accesskey = a

certificate-description = Kada poslužitelj zatraži moj osobni certifikat:

certificate-auto =
    .label = Automatski odaberi jedan
    .accesskey = A

certificate-ask =
    .label = Pitaj me svaki put
    .accesskey = a

ocsp-label =
    .label = Upitajte OCSP poslužitelje da biste potvrdili validnost certifikata
    .accesskey = U

certificate-button =
    .label = Upravljanje certifikatima…
    .accesskey = U

security-devices-button =
    .label = Sigurnosni uređaji…
    .accesskey = S

## Chat Tab

startup-label =
    .value = Kada se { -brand-short-name } pokrene:
    .accesskey = s

offline-label =
    .label = Ostavi moj račun za razgovore odjavljenim

auto-connect-label =
    .label = Automatski spoji moje računa za razgovor

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Obavjesti moje kontakte da sam neaktivan nakon
    .accesskey = i

idle-time-label = minuta neaktivnosti

##

away-message-label =
    .label = i postavi moj status na Odsutan s ovom porukom:
    .accesskey = a

send-typing-label =
    .label = Šalji obavjest o tipkanju u razgovorima
    .accesskey = t

notification-label = Kada stignu poruke naslovljene na vas:

show-notification-label =
    .label = Prikaži obavijest:
    .accesskey = k

notification-all =
    .label = s imenom pošiljatelja i pregledom poruke
notification-name =
    .label = samo s imenom pošiljatelja
notification-empty =
    .label = bez bilo kakvih informacija

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animiraj ikonu pristanka
           *[other] Bljesak stavke alatne trake
        }
    .accesskey =
        { PLATFORM() ->
            [macos] A
           *[other] B
        }

chat-play-sound-label =
    .label = Reproduciraj zvuk
    .accesskey = d

chat-play-button =
    .label = Reproduciraj
    .accesskey = p

chat-system-sound-label =
    .label = Zadani sistemski zvuk za novu poruku
    .accesskey = Z

chat-custom-sound-label =
    .label = Koristi sljedeću zvučnu datoteku
    .accesskey = u

chat-browse-sound-button =
    .label = Odaberi…
    .accesskey = d

theme-label =
    .value = Motiv:
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Mjehurići
style-dark =
    .label = Tamno
style-paper =
    .label = Papirnati listovi
style-simple =
    .label = Jednostavno

preview-label = Pregled:
no-preview-label = Nema dostupnog pregleda
no-preview-description = Ovaj motiv je neispravan ili trenutačno nedostupan (isključen dodatak, siguran način rada, …).

chat-variant-label =
    .value = Varijanta:
    .accesskey = V

chat-header-label =
    .label = Prikaži zaglavlje
    .accesskey = z

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
            [windows] Nađi u mogućnostima
           *[other] Nađi u postavkama
        }

## Preferences UI Search Results

search-results-header = Rezultati pretrage

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Žao nam je! U mogućnostima nema rezultata za „<span data-l10n-name="query"></span>”.
       *[other] Žao nam je! U postavkama nema rezultata za „<span data-l10n-name="query"></span>”.
    }

search-results-help-link = Trebaš pomoć? Posjeti <a data-l10n-name="url">{ -brand-short-name } podršku</a>

## Preferences UI Search Results

