# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Lat att
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Innstillingar
           *[other] Innstillingar
        }
category-list =
    .aria-label = kategoriar
pane-general-title = Generelt
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = Skriving
category-compose =
    .tooltiptext = Skriving
pane-privacy-title = Personvern og sikkerheit
category-privacy =
    .tooltiptext = Personvern og sikkerheit
pane-chat-title = Nettprat
category-chat =
    .tooltiptext = Nettprat
pane-calendar-title = Kalender
category-calendar =
    .tooltiptext = Kalender
general-language-and-appearance-header = Språk og utsjånad
general-incoming-mail-header = Innkomande e-postar
general-files-and-attachment-header = Filer og vedlegg
general-tags-header = Etikettar
general-reading-and-display-header = Lesing og vising
general-updates-header = Oppdateringar
general-network-and-diskspace-header = Nettverk og diskplass
general-indexing-label = Indeksering
composition-category-header = Composition
composition-attachments-header = Vedlegg
composition-spelling-title = Stavekontroll
compose-html-style-title = HTML-stil
composition-addressing-header = Adressering
privacy-main-header = Personvern
privacy-passwords-header = Passord
privacy-junk-header = Uønskt
collection-header = { -brand-short-name } datainnsamling og bruk
collection-description = Vi strevar alltid etter å gje deg val og samlar berre inn det vi treng for å forbetre { -brand-short-name } for alle. Vi ber alltid om løyve før vi tar imot personlege opplysningar.
collection-privacy-notice = Personvernerklæring
collection-health-report-telemetry-disabled = Du tillèt ikkje lenger at{ -vendor-short-name } samlar inn tekniske data og brukardata. Alle tidlegare data vil bli sletta innan 30 dagar.
collection-health-report-telemetry-disabled-link = Les meir
collection-health-report =
    .label = Tillat { -brand-short-name } å sende tekniske data og data for bruk til { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Les meir
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Datarapportering er slått av for denne byggekonfigurasjonen
collection-backlogged-crash-reports =
    .label = Tillat { -brand-short-name } å sende etterslepne krasjrapportar på dine vegne
    .accesskey = k
collection-backlogged-crash-reports-link = Les meir
privacy-security-header = Sikkerheit
privacy-scam-detection-title = Svindeldetektering
privacy-anti-virus-title = Antivirus
privacy-certificates-title = Sertifikat
chat-pane-header = Nettprat
chat-status-title = Status
chat-notifications-title = Varsel
chat-pane-styling-header = Stil
choose-messenger-language-description = Vel språka som skal brukast til å visa menyer, meldingar og varsel frå { -brand-short-name }.
manage-messenger-languages-button =
    .label = Spesifiser alternativ…
    .accesskey = S
confirm-messenger-language-change-description = Start om { -brand-short-name } for å bruka disse endringane
confirm-messenger-language-change-button = Bruk og start om
update-setting-write-failure-title = Klarte ikkje å lagre oppdateringsinnstillingar
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } oppdaga ein feil og lagra ikkje denne endringa. Merk, for å kunne lagre endringa av denne oppdateringsinnstillinga, vert det krevd løyve til å skrive til fila nedanfor. Du eller ein systemadministrator kan kanskje løyse feilen ved å gje gruppa Brukarar full tilgang til denne fila.
    
    Klarte ikkje å skrive til fila: { $path }
update-in-progress-title = Oppdatering i framdrift
update-in-progress-message = Vil du at { -brand-short-name } skal fortsetje med denne oppdateringa?
update-in-progress-ok-button = &Avvis
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Fortset
account-button = Kontoinnstillingar
addons-button = Utvidingar og tema

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Skriv inn innloggingsinformasjonen for Windows for å lage eit hovudpassord. Dette vil gjere kontoane dine tryggare.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = lag eit hovudpassord
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Skriv inn innloggingsinformasjonen din for Windows for å lage eit hovydpassord. Dette vil gjere kontoane dine tryggare.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = lag eit hovudpassord
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend = { -brand-short-name }-startside
start-page-label =
    .label = Vis startsida i meldingsområdet når { -brand-short-name } startar
    .accesskey = V
location-label =
    .value = Adresse:
    .accesskey = A
restore-default-label =
    .label = Bruk standard
    .accesskey = u
default-search-engine = Standard søkjemotor
add-search-engine =
    .label = Legg til frå fil
    .accesskey = e
remove-search-engine =
    .label = Fjern
    .accesskey = e
minimize-to-tray-label =
    .label = Når { -brand-short-name } er minimert, flytt han til systemstatusfeltet
    .accesskey = m
new-message-arrival = Når ei ny melding kjem:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Bruk følgjande lydfil:
           *[other] Spel av ein lyd
        }
    .accesskey =
        { PLATFORM() ->
            [macos] r
           *[other] S
        }
mail-play-button =
    .label = Spel av
    .accesskey = e
change-dock-icon = Endra innstillingar for app-ikonet
app-icon-options =
    .label = Innstillingar for app-ikon …
    .accesskey = n
notification-settings = Åtvaringar og standardlyden kan slåast av i varslingsfeltet i Systeminnstillingar.
animated-alert-label =
    .label = Vis eit varsel
    .accesskey = V
customize-alert-label =
    .label = Avansert…
    .accesskey = A
tray-icon-label =
    .label = Vis eit ikon i systemstatusfeltet
    .accesskey = t
mail-system-sound-label =
    .label = Standard systemlyd for ny e-post
    .accesskey = S
mail-custom-sound-label =
    .label = Bruk følgjande lydfil
    .accesskey = r
mail-browse-sound-button =
    .label = Bla gjennom …
    .accesskey = B
enable-gloda-search-label =
    .label = Slå på globalt søk og indeksering
    .accesskey = S
datetime-formatting-legend = Formatering av dato og tid
language-selector-legend = Språk
allow-hw-accel =
    .label = Bruk maskinvareakselerasjon når tilgjengeleg
    .accesskey = m
store-type-label =
    .value = Lagringstype for meldingar i nye kontoar:
    .accesskey = d
mbox-store-label =
    .label = Fil per mappe (mbox)
maildir-store-label =
    .label = Fil per melding (maildir)
scrolling-legend = Rulling
autoscroll-label =
    .label = Bruk autorulling
    .accesskey = B
smooth-scrolling-label =
    .label = Bruk jamn rulling
    .accesskey = r
system-integration-legend = Systemintegrasjon
always-check-default =
    .label = Alltid kontroller om { -brand-short-name } er standard e-postklient ved oppstart
    .accesskey = l
check-default-button =
    .label = Sjekk no …
    .accesskey = n
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows-søk
       *[other] { "" }
    }
search-integration-label =
    .label = Tillat { search-engine-name } å søkja i meldingar
    .accesskey = T
config-editor-button =
    .label = Konfigurasjonseditor …
    .accesskey = o
return-receipts-description = Avgjer korleis { -brand-short-name } skal handsama kvitteringar
return-receipts-button =
    .label = Kvitteringar …
    .accesskey = K
update-app-legend = { -brand-short-name }-oppdateringar
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Versjon { $version }
allow-description = Tillat { -brand-short-name } å
automatic-updates-label =
    .label = Automatisk installer oppdateringar (tilrådd: betre sikkerheit)
    .accesskey = A
check-updates-label =
    .label = Sjå etter oppdateringar, men la meg velja om dei skal installerast
    .accesskey = S
update-history-button =
    .label = Vis oppdateringshistorikk
    .accesskey = V
use-service =
    .label = Bruk ei bakgrunnsteneste for å installera oppdateringar
    .accesskey = B
cross-user-udpate-warning = Denne innstillinga gjeld for alle Windows-kontoar og { -brand-short-name }-profilar som brukar denne installasjonen av { -brand-short-name }.
networking-legend = Tilkopling
proxy-config-description = Still inn korleis { -brand-short-name } koplar seg til Internett
network-settings-button =
    .label = Innstillingar …
    .accesskey = I
offline-legend = Fråkopla
offline-settings = Konfigurer innstillingar for fråkopla modus
offline-settings-button =
    .label = Fråkopla …
    .accesskey = F
diskspace-legend = Diskplass
offline-compact-folder =
    .label = Komprimer alle mapper når det vil spara meir enn
    .accesskey = K
compact-folder-size =
    .value = MB totalt

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Bruk opptil
    .accesskey = B
use-cache-after = MB diskplass for snøgglageret

##

smart-cache-label =
    .label = Sett til side automatisk cachehandsaming
    .accesskey = s
clear-cache-button =
    .label = Tøm no
    .accesskey = T
fonts-legend = Skrifttypar og fargar
default-font-label =
    .value = Standard skrifttype:
    .accesskey = t
default-size-label =
    .value = Storleik:
    .accesskey = o
font-options-button =
    .label = Skrifttypar …
    .accesskey = r
color-options-button =
    .label = Fargar…
    .accesskey = F
display-width-legend = Meldingar i normal tekst
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Vis smilefjes som bilde
    .accesskey = V
display-text-label = Når ein viser sitat i tekstmeldingar:
style-label =
    .value = Stil:
    .accesskey = S
regular-style-item =
    .label = Vanleg
bold-style-item =
    .label = Feit
italic-style-item =
    .label = Kursiv
bold-italic-style-item =
    .label = Feit og kursiv
size-label =
    .value = Størrelse:
    .accesskey = t
regular-size-item =
    .label = Normal
bigger-size-item =
    .label = Større
smaller-size-item =
    .label = Mindre
quoted-text-color =
    .label = Farge:
    .accesskey = F
search-input =
    .placeholder = Søk
type-column-label =
    .label = Innhaldstype
    .accesskey = I
action-column-label =
    .label = Handling
    .accesskey = H
save-to-label =
    .label = Lagre filer til
    .accesskey = L
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Vel…
           *[other] Bla gjennom …
        }
    .accesskey =
        { PLATFORM() ->
            [macos] V
           *[other] B
        }
always-ask-label =
    .label = Alltid spør meg om kvar eg vil lagre filer
    .accesskey = A
display-tags-text = Merkelapp-stikkord kan brukast for å kategorisera og prioritera meldingane dine.
new-tag-button =
    .label = Ny…
    .accesskey = N
edit-tag-button =
    .label = Rediger…
    .accesskey = R
delete-tag-button =
    .label = Slett
    .accesskey = S
auto-mark-as-read =
    .label = Automatisk merk meldingar som lesne
    .accesskey = A
mark-read-no-delay =
    .label = Med ein gong dei er viste
    .accesskey = M

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Etter dei er viste i
    .accesskey = E
seconds-label = sekund

##

open-msg-label =
    .value = Opne meldingar i:
open-msg-tab =
    .label = Ei ny fane
    .accesskey = E
open-msg-window =
    .label = Eit nytt meldingsvindauge
    .accesskey = i
open-msg-ex-window =
    .label = Eit eksisterande meldingsvindauge
    .accesskey = t
close-move-delete =
    .label = Lat att meldingsvindauge/fane ved flytting eller sletting
    .accesskey = L
display-name-label =
    .value = Visingsnamn:
condensed-addresses-label =
    .label = Vis berre visings-namnet for personar i adresseboka
    .accesskey = V

## Compose Tab

forward-label =
    .value = Vidaresend meldingar:
    .accesskey = V
inline-label =
    .label = Innebygd
as-attachment-label =
    .label = Som vedlegg
extension-label =
    .label = legg til filtype i filnamnet
    .accesskey = l

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Lagre meldingar automatisk kvart
    .accesskey = L
auto-save-end = minutt

##

warn-on-send-accel-key =
    .label = Stadfest når tastatursnarveg vert brukt for å sende meldingar
    .accesskey = f
spellcheck-label =
    .label = Stavekontroll før meldingar vert sende
    .accesskey = S
spellcheck-inline-label =
    .label = Stavekontroll medan du skriv
    .accesskey = a
language-popup-label =
    .value = Språk:
    .accesskey = k
download-dictionaries-link = Last ned fleire ordbøker
font-label =
    .value = Skrifttype:
    .accesskey = S
font-size-label =
    .value = Storleik:
    .accesskey = e
default-colors-label =
    .label = Bruk standardfargane til lesaren
    .accesskey = d
font-color-label =
    .value = Tekstfarge:
    .accesskey = T
bg-color-label =
    .value = Bakgrunnsfarge:
    .accesskey = B
restore-html-label =
    .label = Bruk standard
    .accesskey = d
default-format-label =
    .label = Bruk paragrafformat i staden for brødtekst som standard
    .accesskey = p
format-description = Konfigurer åtferda til tekstformatet
send-options-label =
    .label = Sende-innstillingar …
    .accesskey = n
autocomplete-description = Ved adressering av meldingar, sjå etter treff i:
ab-label =
    .label = Lokale adressebøker
    .accesskey = L
directories-label =
    .label = Katalogtenar:
    .accesskey = K
directories-none-label =
    .none = Ingen
edit-directories-label =
    .label = Rediger katalogar …
    .accesskey = R
email-picker-label =
    .label = Automatisk legg utgåande e-postadresser til i:
    .accesskey = A
default-directory-label =
    .value = Standard startkatalog i adressbokvindauget:
    .accesskey = S
default-last-label =
    .none = Sist brukte katalog
attachment-label =
    .label = Åtvar meg dersom vedlegg manglar
    .accesskey = Å
attachment-options-label =
    .label = Nykelord…
    .accesskey = N
enable-cloud-share =
    .label = Tilby å dele for filer større enn
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = Legg til…
    .accesskey = L
    .defaultlabel = Legg til…
remove-cloud-account =
    .label = Fjern
    .accesskey = F
find-cloud-providers =
    .value = Finn fleire leverandørar…
cloud-account-description = Legg til ei Filelink-lagringsteneste

## Privacy Tab

mail-content = E-postinnhald
remote-content-label =
    .label = Tillat eksternt innhald i meldingar
    .accesskey = T
exceptions-button =
    .label = Unntak…
    .accesskey = U
remote-content-info =
    .value = Les meir om personvernutfordringane ved eksternt innhald
web-content = Nettinnhald
history-label =
    .label = Hugs nettsider og lenker eg har besøkt
    .accesskey = H
cookies-label =
    .label = Tillat infokapslar frå nettstadar
    .accesskey = a
third-party-label =
    .value = Tillat tredjeparts infokapslar:
    .accesskey = i
third-party-always =
    .label = Alltid
third-party-never =
    .label = Aldri
third-party-visited =
    .label = Frå besøkte
keep-label =
    .value = Ta vare på dei til:
    .accesskey = e
keep-expire =
    .label = Dei går ut på dato
keep-close =
    .label = Eg lukkar { -brand-short-name }
keep-ask =
    .label = Spør meg kvar gong
cookies-button =
    .label = Vis infokapslar…
    .accesskey = V
do-not-track-label =
    .label = Send nettsider eit «Ikkje spor»-signal om at du ikkje vil bli spora
    .accesskey = n
learn-button =
    .label = Les meir
passwords-description = { -brand-short-name } kan hugse passordinformasjon for alle kontoane dine, slik at du ikkje treng å skriva inn innloggingsdetaljane fleire gonger.
passwords-button =
    .label = Lagra passord…
    .accesskey = L
master-password-description = Du kan bruka eit hovudpassord for å verna alle passorda dine, men du må skriva inn passordet ein gong for kvar programøkt.
master-password-label =
    .label = Bruk eit hovudpassord
    .accesskey = B
master-password-button =
    .label = Endra hovudpassord …
    .accesskey = E
primary-password-description = Du kan bruke eit hovudpassord for å beskytte alle passorda, men då må du skrive inn passorda ein gong for kvar programøkt.
primary-password-label =
    .label = Bruk eit hovudpassord
    .accesskey = B
primary-password-button =
    .label = Endre hovudpassord…
    .accesskey = E
forms-primary-pw-fips-title = Du er for tida i FIPS-modus. FIPS krev at du brukar eit hovudpassord.
forms-master-pw-fips-desc = Mislykka passordendring
junk-description = Vel standard-innstilling for uønskt e-post. Konto-spesifikke innstillingar for uønskt e-post kan stillast inn i Konto-innstillingar.
junk-label =
    .label = Når eg merkar meldingar som uønskte:
    .accesskey = N
junk-move-label =
    .label = Flytt dei til «Uønskt»-mappa på kontoen
    .accesskey = F
junk-delete-label =
    .label = Slett dei
    .accesskey = t
junk-read-label =
    .label = Merk uønskte søppelmeldingar som lesne
    .accesskey = M
junk-log-label =
    .label = Slå på logging for adaptiv filter for uønskt e-post
    .accesskey = l
junk-log-button =
    .label = Vis logg
    .accesskey = V
reset-junk-button =
    .label = Still tilbake treningsdata
    .accesskey = t
phishing-description = { -brand-short-name } kan analysere meldingar og oppdage mogleg e-postsvindel ved å sjå etter vanlege teknikkar brukt for å lure deg.
phishing-label =
    .label = Fortel meg om meldinga eg les er mistenkt e-postsvindel
    .accesskey = F
antivirus-description = { -brand-short-name } kan gjere det enkelt for antivirus-program å analysere innkomande e-postmeldingar for virus før dei vert lagra.
antivirus-label =
    .label = Tillat antivirus-program å leggja innkomande meldingar i karantene
    .accesskey = T
certificate-description = Når ein tenar ber om det personlege sertifikatet mitt:
certificate-auto =
    .label = Vel eit automatisk
    .accesskey = e
certificate-ask =
    .label = Spør meg kvar gong
    .accesskey = S
ocsp-label =
    .label = Spør OCSP-tenaren om å stadfesta at sertifikat gjeld
    .accesskey = S
certificate-button =
    .label = Handter sertifikat…
    .accesskey = s
security-devices-button =
    .label = Tryggingseiningar…
    .accesskey = e

## Chat Tab

startup-label =
    .value = Når { -brand-short-name } startar:
    .accesskey = s
offline-label =
    .label = Behald nettprat-kontoane fråkopla
auto-connect-label =
    .label = Kopla til nettprat-kontoane automatisk

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = La kontaktane mine vita at eg er inaktiv etter
    .accesskey = i
idle-time-label = minutt med inaktivitet

##

away-message-label =
    .label = og set status til borte med denne statusmeldinga:
    .accesskey = a
send-typing-label =
    .label = Send varsel om at eg skriv i samtalar
    .accesskey = t
notification-label = Når meldingar sendt til deg kjem:
show-notification-label =
    .label = Vis eit varsel
    .accesskey = V
notification-all =
    .label = med namnet åt avsendaren og førehandsvising
notification-name =
    .label = berre med namnet åt avsendaren
notification-empty =
    .label = utan nokon info
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animer dock-ikonet
           *[other] Blink i oppgåvelinja
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] B
        }
chat-play-sound-label =
    .label = Spel ein lyd
    .accesskey = l
chat-play-button =
    .label = Spel av
    .accesskey = p
chat-system-sound-label =
    .label = Standard systemlyd for ny e-post
    .accesskey = d
chat-custom-sound-label =
    .label = Bruk lydfil
    .accesskey = B
chat-browse-sound-button =
    .label = Bla gjennom …
    .accesskey = B
theme-label =
    .value = Tema
    .accesskey = T
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Bobler
style-dark =
    .label = Mørkt
style-paper =
    .label = Papirark
style-simple =
    .label = Enkelt
preview-label = Førehandsvising:
no-preview-label = Inga førehandsvising tilgjengeleg
no-preview-description = Dette temaet er ikkje gyldig eller er for tida utilgjengeleg (deaktivert utviding, trygg modus, ...).
chat-variant-label =
    .value = Variant:
    .accesskey = V
chat-header-label =
    .label = Vis overskrift
    .accesskey = o
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
            [windows] Søk i innstillingar
           *[other] Søk i innstillingar
        }

## Preferences UI Search Results

search-results-header = Søkjeresultat
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Beklagar! Det er ingen resultat i innstillingar for «<span data-l10n-name="query"></span>».
       *[other] Beklagar! Det er ingen resultat i innstillingar for «<span data-l10n-name="query"></span>».
    }
search-results-help-link = Treng du hjelp? Gå til <a data-l10n-name="url">{ -brand-short-name } brukarstøtte</a>
