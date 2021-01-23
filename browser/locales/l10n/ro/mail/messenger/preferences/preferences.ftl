# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Închide

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Opțiuni
           *[other] Preferințe
        }

pane-general-title = General
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Redactare
category-compose =
    .tooltiptext = Redactare

pane-privacy-title = Confidențialitate și securitate
category-privacy =
    .tooltiptext = Confidențialitate și securitate

pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat

pane-calendar-title = Calendar
category-calendar =
    .tooltiptext = Calendar

general-language-and-appearance-header = Limbă și aspect

general-incoming-mail-header = Mesaje primite

general-files-and-attachment-header = Fișiere și atașamente

general-tags-header = Etichete

general-reading-and-display-header = Citire și afișare

general-updates-header = Actualizări

general-network-and-diskspace-header = Rețea și spațiu pe disc

general-indexing-label = Indexare

composition-category-header = Redactare

composition-attachments-header = Atașamente

composition-spelling-title = Ortografie

compose-html-style-title = Stil HTML

composition-addressing-header = Adrese

privacy-main-header = Confidențialitate

privacy-passwords-header = Parole

privacy-junk-header = Mesaje nesolicitate

collection-header = Date colectate și utilizarea lor în { -brand-short-name }

collection-description = Ne străduim să vă oferim opțiuni și să colectăm numai ceea ce este necesar ca să oferim și să îmbunătățim { -brand-short-name } pentru toți. Cerem întotdeauna permisiunea înainte de a primi date personale.
collection-privacy-notice = Notificare privind confidențialitatea

collection-health-report-telemetry-disabled = Nu mai permiți { -vendor-short-name } să captureze date tehnice și de interacțiune. Toate datele anterioare vor fi șterse în 30 de zile.
collection-health-report-telemetry-disabled-link = Află mai multe

collection-health-report =
    .label = Permite { -brand-short-name } să transmită date tehnice și de interacțiune către { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Află mai multe

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Raportarea datelor este dezactivată în configurația folosită

collection-backlogged-crash-reports =
    .label = Permite { -brand-short-name } să transmită în numele tău rapoarte de defecțiuni înregistrate
    .accesskey = c
collection-backlogged-crash-reports-link = Află mai multe

privacy-security-header = Securitate

privacy-scam-detection-title = Detectarea de înșelăciuni

privacy-anti-virus-title = Antivirus

privacy-certificates-title = Certificate

chat-pane-header = Chat

chat-status-title = Stare

chat-notifications-title = Notificări

chat-pane-styling-header = Stil

choose-messenger-language-description = Alege limba de folosit pentru afișarea meniurilor, mesajelor și a notificărilor de la { -brand-short-name }.
manage-messenger-languages-button =
    .label = Setează alternative...
    .accesskey = I
confirm-messenger-language-change-description = Repornește { -brand-short-name } pentru a aplica aceste modificări
confirm-messenger-language-change-button = Aplică și repornește

update-setting-write-failure-title = Eroare la salvarea preferințelor de actualizare

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } a întâmpinat o eroare și nu a salvat această modificare. Reține că setarea acestei preferințe de actualizare necesită permisiunea de a scrie în fișierul de mai jos. Poți rezolva eroarea tu sau administratorul sistemului acordând grupului de utilizatori control deplin asupra acestui fișier.
    
    Nu s-a putut scrie în fișierul: { $path }

update-in-progress-title = Actualizare în curs

update-in-progress-message = Vrei ca { -brand-short-name } să continue această actualizare?

update-in-progress-ok-button = E&limină
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = C&ontinuă

addons-button = Extensii și teme

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Pentru a crea o parolă generală, introdu-ți datele de autentificare pentru Windows. Ajută la protejarea securității conturilor tale.

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = creează o parolă generală

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Pentru a crea o parolă primară, introdu-ți datele de autentificare pentru Windows. Ajută la protejarea securității conturilor tale.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = creează o parolă primară

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = Pagina de pornire { -brand-short-name }

start-page-label =
    .label = Afișează pagina de start în zona de mesaje la pornirea { -brand-short-name }
    .accesskey = A

location-label =
    .value = Locație:
    .accesskey = A
restore-default-label =
    .label = Restaurează
    .accesskey = R

default-search-engine = Motor de căutare implicit
add-search-engine =
    .label = Adaugă din fișier
    .accesskey = A
remove-search-engine =
    .label = Elimină
    .accesskey = v

minimize-to-tray-label =
    .label = Când { -brand-short-name } este minimalizat, mută-l în bara de sistem
    .accesskey = m

new-message-arrival = Când sosesc noi mesaje:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Redă fișierul sonor următor:
           *[other] Redă un sunet
        }
    .accesskey =
        { PLATFORM() ->
            [macos] d
           *[other] d
        }
mail-play-button =
    .label = Redă
    .accesskey = R

change-dock-icon = Schimbă preferințele pentru pictograma aplicației
app-icon-options =
    .label = Opțiuni pentru iconița aplicației…
    .accesskey = n

notification-settings = Alertele și sunetul implicit pot fi dezactivate din panoul de notificări al preferințelor sistemului.

animated-alert-label =
    .label = Afișează o alertă
    .accesskey = A
customize-alert-label =
    .label = Personalizează…
    .accesskey = P

tray-icon-label =
    .label = Afișează o pictogramă în bara de stare
    .accesskey = p

mail-system-sound-label =
    .label = Sunet de sistem implicit pentru mesaje noi
    .accesskey = D
mail-custom-sound-label =
    .label = Folosește următorul fișier de sunet
    .accesskey = U
mail-browse-sound-button =
    .label = Răsfoiește…
    .accesskey = f

enable-gloda-search-label =
    .label = Activează căutarea globală și indexarea
    .accesskey = i

datetime-formatting-legend = Formatarea datei și a orei
language-selector-legend = Limba

allow-hw-accel =
    .label = Folosește accelerarea hardware când este disponibilă
    .accesskey = h

store-type-label =
    .value = Tipul de stocare al mesajelor pentru conturile noi:
    .accesskey = T

mbox-store-label =
    .label = Fișier per dosar (mbox)
maildir-store-label =
    .label = Fișiere per mesaj (maildir)

scrolling-legend = Derulare
autoscroll-label =
    .label = Folosește derularea automată
    .accesskey = U
smooth-scrolling-label =
    .label = Folosește derularea lină
    .accesskey = o

system-integration-legend = Integrare cu sistemul
always-check-default =
    .label = Verifică întotdeauna la pornire dacă { -brand-short-name } este clientul implicit de e-mail
    .accesskey = a
check-default-button =
    .label = Verifică acum…
    .accesskey = V

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Căutare Windows
       *[other] { "" }
    }

search-integration-label =
    .label = Permite la { search-engine-name } să caute în mesaje
    .accesskey = P

config-editor-button =
    .label = Editor de configurație…
    .accesskey = g

return-receipts-description = Configurează cum gestionează { -brand-short-name } confirmările de primire
return-receipts-button =
    .label = Confirmări de primire…
    .accesskey = r

update-app-legend = Actualizări { -brand-short-name }

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Versiunea { $version }

allow-description = Permite ca { -brand-short-name } să
automatic-updates-label =
    .label = Instalează actualizări automat (recomandat: securitate sporită)
    .accesskey = a
check-updates-label =
    .label = Caută actualizări, dar lasă-mă pe mine să decid dacă să le instalez
    .accesskey = C

update-history-button =
    .label = Afișează istoricul actualizărilor
    .accesskey = p

use-service =
    .label = Folosește un serviciu în fundal pentru a instala actualizări
    .accesskey = s

cross-user-udpate-warning = Această setare se va aplica tuturor conturilor Windows și profilurilor { -brand-short-name } care folosesc această instalare { -brand-short-name }.

networking-legend = Conexiune
proxy-config-description = Configurează cum se conectează { -brand-short-name } la Internet

network-settings-button =
    .label = Setări…
    .accesskey = S

offline-legend = Offline
offline-settings = Configurează setările pentru modul offline

offline-settings-button =
    .label = Offline…
    .accesskey = O

diskspace-legend = Spațiu pe disc
offline-compact-folder =
    .label = Compactează toate dosarele și salvează peste
    .accesskey = C

compact-folder-size =
    .value = MB în total

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Utilizează până la
    .accesskey = U

use-cache-after = MB de spațiu pentru cache

##

smart-cache-label =
    .label = Înlocuiește gestionarea automată a cache-ului
    .accesskey = v

clear-cache-button =
    .label = Șterge acum
    .accesskey = c

fonts-legend = Fonturi și culori

default-font-label =
    .value = Font implicit:
    .accesskey = F

default-size-label =
    .value = Mărime:
    .accesskey = M

font-options-button =
    .label = Avansat…
    .accesskey = A

color-options-button =
    .label = Culori…
    .accesskey = C

display-width-legend = Mesaje text

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Afișează emoticoanele în format grafic
    .accesskey = e

display-text-label = Pentru afișarea mesajelor text citate:

style-label =
    .value = Stil
    .accesskey = S

regular-style-item =
    .label = Normal
bold-style-item =
    .label = Îngroșat
italic-style-item =
    .label = Înclinat
bold-italic-style-item =
    .label = Îngroșat și înclinat

size-label =
    .value = Mărime:
    .accesskey = M

regular-size-item =
    .label = Normală
bigger-size-item =
    .label = Mai mare
smaller-size-item =
    .label = Mai mic

quoted-text-color =
    .label = Culoare:
    .accesskey = l

search-input =
    .placeholder = Căutare

type-column-label =
    .label = Tip de conținut
    .accesskey = T

action-column-label =
    .label = Acțiune
    .accesskey = A

save-to-label =
    .label = Salvează fișierele în
    .accesskey = S

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Alege…
           *[other] Răsfoiește…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] A
           *[other] f
        }

always-ask-label =
    .label = Întreabă-mă întotdeauna unde să se salveze fișierele
    .accesskey = a


display-tags-text = Etichetele pot fi folosite pentru a organiza mesajele tale pe categorii și după priorități.

new-tag-button =
    .label = Etichetă nouă…
    .accesskey = n

edit-tag-button =
    .label = Editează…
    .accesskey = E

delete-tag-button =
    .label = Șterge
    .accesskey = t

auto-mark-as-read =
    .label = Marchează automat mesajele ca citite
    .accesskey = A

mark-read-no-delay =
    .label = Imediat la afișare
    .accesskey = d

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = După ce sunt afișate
    .accesskey = d

seconds-label = secunde

##

open-msg-label =
    .value = Deschide mesajele într-o:

open-msg-tab =
    .label = Filă nouă
    .accesskey = t

open-msg-window =
    .label = Fereastră de mesaj nouă
    .accesskey = n

open-msg-ex-window =
    .label = Fereastră de mesaj existentă
    .accesskey = e

close-move-delete =
    .label = Închide fereastra sau fila cu mesajul la mutare sau ștergere
    .accesskey = c

display-name-label =
    .value = Nume afișat:

condensed-addresses-label =
    .label = Afișează numai numele de afișaj ale persoanelor din agenda mea de contacte
    .accesskey = S

## Compose Tab

forward-label =
    .value = Redirecționează mesajele:
    .accesskey = n

inline-label =
    .label = Inclus

as-attachment-label =
    .label = Ca atașament

extension-label =
    .label = adaugă extensia la numele fișierului
    .accesskey = f

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Salvează automat la fiecare
    .accesskey = u

auto-save-end = minute

##

warn-on-send-accel-key =
    .label = Confirmă trimiterea când se folosește comanda rapidă de la tastatură
    .accesskey = i

spellcheck-label =
    .label = Verifică ortografia înainte de a trimite
    .accesskey = c

spellcheck-inline-label =
    .label = Activează corectarea ortografică în timpul scrierii
    .accesskey = n

language-popup-label =
    .value = Limba:
    .accesskey = L

download-dictionaries-link = Descarcă mai multe dicționare

font-label =
    .value = Font:
    .accesskey = n

font-size-label =
    .value = Dimensiune:
    .accesskey = z

default-colors-label =
    .label = Folosește culorile implicite ale cititorului
    .accesskey = d

font-color-label =
    .value = Culoare text:
    .accesskey = x

bg-color-label =
    .value = Culoare fundal:
    .accesskey = C

restore-html-label =
    .label = Revenire la valorile implicite
    .accesskey = R

default-format-label =
    .label = Folosește implicit formatarea „Paragraf” în loc de „Corp text”
    .accesskey = P

format-description = Configurează aspectul textului

send-options-label =
    .label = Opțiuni de trimitere…
    .accesskey = O

autocomplete-description = La introducerea adresei destinatarului, caută rezultate corespondente în:

ab-label =
    .label = Agende locale de contacte
    .accesskey = A

directories-label =
    .label = Server de directoare:
    .accesskey = d

directories-none-label =
    .none = Niciunul

edit-directories-label =
    .label = Editează directoarele…
    .accesskey = E

email-picker-label =
    .label = Adaugă automat adresele de e-mail din mesajele trimise la:
    .accesskey = a

default-directory-label =
    .value = Dosarul implicit de pornire în fereastra agendei:
    .accesskey = S

default-last-label =
    .none = Ultimul dosar folosit

attachment-label =
    .label = Verifică dacă lipsesc atașamentele
    .accesskey = m

attachment-options-label =
    .label = Cuvinte cheie…
    .accesskey = C

enable-cloud-share =
    .label = Oferă partajarea fișierelor mai mari decât
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Adaugă…
    .accesskey = A
    .defaultlabel = Adaugă…

remove-cloud-account =
    .label = Elimină
    .accesskey = r

find-cloud-providers =
    .value = Caută mai mulți furnizori…

cloud-account-description = Adaugă un serviciu nou de stocare Filelink


## Privacy Tab

mail-content = Conținutul mesajelor

remote-content-label =
    .label = Permite conținuturi de la distanță în mesaje
    .accesskey = m

exceptions-button =
    .label = Excepții…
    .accesskey = E

remote-content-info =
    .value = Află mai multe despre problemele de confidențialitate ale conținutului de la distanță

web-content = Conținut web

history-label =
    .label = Reține site-urile și linkurile vizitate
    .accesskey = R

cookies-label =
    .label = Acceptă cookie-uri de la site-uri
    .accesskey = c

third-party-label =
    .value = Acceptă cookie-uri de la terți:
    .accesskey = c

third-party-always =
    .label = Întotdeauna
third-party-never =
    .label = Niciodată
third-party-visited =
    .label = De la site-urile vizitate

keep-label =
    .value = Păstrează-le până când:
    .accesskey = K

keep-expire =
    .label = expiră
keep-close =
    .label = Închid { -brand-short-name }
keep-ask =
    .label = întreabă de fiecare dată

cookies-button =
    .label = Afișează cookie-urile…
    .accesskey = S

do-not-track-label =
    .label = Trimite site-urilor web un semnal „Nu urmări” pentru a indica faptul că nu vrei să fii urmărit
    .accesskey = n

learn-button =
    .label = Află mai multe

passwords-description = { -brand-short-name } poate reține parolele tuturor conturilor tale.

passwords-button =
    .label = Parole salvate…
    .accesskey = s

master-password-description = O parolă generală îți protejează toate parolele, dar trebuie să o introduci la fiecare sesiune nouă deschisă.

master-password-label =
    .label = Folosește o parolă generală
    .accesskey = U

master-password-button =
    .label = Schimbă parola generală…
    .accesskey = c


primary-password-description = O parolă primară îți protejează toate parolele, dar trebuie să o introduci la fiecare sesiune nouă deschisă.

primary-password-label =
    .label = Folosește o parolă primară
    .accesskey = U

primary-password-button =
    .label = Schimbă parola primară...
    .accesskey = C

forms-primary-pw-fips-title = Acum ești în modul FIPS. FIPS nu permite inexistența unei parole primare.
forms-master-pw-fips-desc = Schimbarea parolei a eșuat


junk-description = Definește setările implicite pentru mesaje nesolicitate. Setările specifice contului pentru mesaje nesolicitate pot fi configurate în setările contului.

junk-label =
    .label = Când marchez mesaje ca nesolicitate:
    .accesskey = C

junk-move-label =
    .label = Mută-le în dosarul cu mesaje nesolicitate al contului
    .accesskey = o

junk-delete-label =
    .label = Șterge-le
    .accesskey = t

junk-read-label =
    .label = Marchează mesajele detectate ca nesolicitate ca fiind citite
    .accesskey = M

junk-log-label =
    .label = Activează jurnalizarea filtrării adaptive de mesaje nesolicitate
    .accesskey = e

junk-log-button =
    .label = Afișează jurnalul
    .accesskey = A

reset-junk-button =
    .label = Resetează datele de antrenament
    .accesskey = R

phishing-description = { -brand-short-name } poate analiza mesajele pentru a depista o eventuală înșelăciune prin e-mail, căutând tehnici frecvente menite să inducă în eroare.

phishing-label =
    .label = Spune-mi dacă mesajul pe care-l citesc este suspectat de înșelăciune prin e-mail
    .accesskey = t

antivirus-description = { -brand-short-name } poate ușura munca programelor antivirus scanând mesajele primite de viruși înainte de a le stoca pe disc.

antivirus-label =
    .label = Permite programelor antivirus să pună în carantină individual mesajele primite
    .accesskey = a

certificate-description = Când un server cere certificatul meu personal:

certificate-auto =
    .label = Selectează automat unul
    .accesskey = S

certificate-ask =
    .label = Întreabă-mă de fiecare dată
    .accesskey = A

ocsp-label =
    .label = Interoghează serverele de răspuns OCSP pentru confirmarea valabilității actuale a certificatelor
    .accesskey = e

certificate-button =
    .label = Gestionează certificatele…
    .accesskey = M

security-devices-button =
    .label = Dispozitive de securitate…
    .accesskey = D

## Chat Tab

startup-label =
    .value = La deschiderea { -brand-short-name }:
    .accesskey = p

offline-label =
    .label = Păstrează-mi conturile de chat deconectate

auto-connect-label =
    .label = Conectează-mă automat la conturile de chat

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Permite contactelor să știe când sunt inactiv(ă) după
    .accesskey = P

idle-time-label = minute de inactivitate

##

away-message-label =
    .label = și setează-mi starea ca Plecat cu acest mesaj de stare:
    .accesskey = s

send-typing-label =
    .label = Trimite notificări de tastare în conversații
    .accesskey = t

notification-label = La sosirea mesajelor care îți sunt adresate:

show-notification-label =
    .label = Afișează o notificare:
    .accesskey = c

notification-all =
    .label = cu numele expeditorului și previzualizarea mesajului
notification-name =
    .label = doar cu numele expeditorului
notification-empty =
    .label = fără nicio informație

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animează pictograma de andocare
           *[other] Pâlpâie în bara de activități
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] I
        }

chat-play-sound-label =
    .label = Redă un sunet
    .accesskey = d

chat-play-button =
    .label = Redă
    .accesskey = R

chat-system-sound-label =
    .label = Sunet de sistem implicit pentru mesaje noi
    .accesskey = S

chat-custom-sound-label =
    .label = Folosește următorul fișier de sunet
    .accesskey = U

chat-browse-sound-button =
    .label = Răsfoiește…
    .accesskey = f

theme-label =
    .value = Temă:
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Bule
style-dark =
    .label = Întunecată
style-paper =
    .label = Foi de hârtie
style-simple =
    .label = Simplă

preview-label = Previzualizare:
no-preview-label = Nicio previzualizare disponibilă
no-preview-description = Această temă nu este validă sau nu este disponibilă acum (supliment dezactivat, mod-de-siguranță, …).

chat-variant-label =
    .value = Variantă:
    .accesskey = V

chat-header-label =
    .label = Afișează antetul
    .accesskey = a

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
            [windows] Caută în Opțiuni
           *[other] Caută în Preferințe
        }

## Preferences UI Search Results

search-results-header = Rezultatele căutării

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Ne pare rău! Nu sunt rezultate în Opțiuni pentru „<span data-l10n-name="query"></span>”.
       *[other] Ne pare rău! Nu sunt rezultate în Preferințe pentru „<span data-l10n-name="query"></span>”.
    }

search-results-help-link = Ai nevoie de ajutor? Intră pe <a data-l10n-name="url">Asistență { -brand-short-name }</a>

## Preferences UI Search Results

