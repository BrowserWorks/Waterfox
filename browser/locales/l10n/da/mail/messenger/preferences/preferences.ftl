# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Luk
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Indstillinger
           *[other] Indstillinger
        }
preferences-doc-title = Indstillinger
category-list =
    .aria-label = Kategorier
pane-general-title = Generelt
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = Redigering
category-compose =
    .tooltiptext = Redigering
pane-privacy-title = Privatliv & sikkerhed
category-privacy =
    .tooltiptext = Privatliv & sikkerhed
pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat
pane-calendar-title = Kalender
category-calendar =
    .tooltiptext = Kalender
general-language-and-appearance-header = Sprog og udseende
general-incoming-mail-header = Indgående meddelelser
general-files-and-attachment-header = Filer og vedhæftninger
general-tags-header = Mærker
general-reading-and-display-header = Læsning & visning
general-updates-header = Opdateringer
general-network-and-diskspace-header = Netværk & diskplads
general-indexing-label = Indeksering
composition-category-header = Skrivning
composition-attachments-header = Vedhæftede filer
composition-spelling-title = Stavning
compose-html-style-title = HTML-stil
composition-addressing-header = Adresser
privacy-main-header = Privatliv
privacy-passwords-header = Adgangskoder
privacy-junk-header = Spam
collection-header = Indsamling og brug af data i { -brand-short-name }
collection-description = Vi stræber efter at give dig mulighed for selv at vælge og indsamler kun, hvad vi har brug for til at forbedre { -brand-short-name } for alle. Vi spørger altid om din tilladelse, før vi modtager personlig information.
collection-privacy-notice = Privatlivspolitik
collection-health-report-telemetry-disabled = Du tillader ikke længere, at { -vendor-short-name } indsamler teknisk data og data om brug. Alle tidligere data vil blive slettet indenfor 30 dage.
collection-health-report-telemetry-disabled-link = Læs mere
collection-health-report =
    .label = Tillad at { -brand-short-name } indsender tekniske data og data om brug til { -vendor-short-name }
    .accesskey = i
collection-health-report-link = Læs mere
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Data-rapportering er deaktiveret for denne build-konfiguration
collection-backlogged-crash-reports =
    .label = Tillad at { -brand-short-name } sender ophobede fejlrapporter på dine vegne
    .accesskey = f
collection-backlogged-crash-reports-link = Læs mere
privacy-security-header = Sikkerhed
privacy-scam-detection-title = Svindelmails
privacy-anti-virus-title = Antivirus
privacy-certificates-title = Certifikater
chat-pane-header = Chat
chat-status-title = Status
chat-notifications-title = Beskeder
chat-pane-styling-header = Stil
choose-messenger-language-description = Vælg det sprog, der skal bruges i brugerfladen i { -brand-short-name }.
manage-messenger-languages-button =
    .label = Vælg alternativer…
    .accesskey = l
confirm-messenger-language-change-description = Genstart { -brand-short-name } for at anvende ændringerne
confirm-messenger-language-change-button = Anvend og genstart
update-setting-write-failure-title = Kunne ikke gemme indstillinger for opdatering
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message = { -brand-short-name } stødte på en fejl og gemte ikke ændringen. Bemærk, at for at kunne gemme ændringer, skal der være tilladelse til at skrive til den nedennævnte fil. Du eller en systemadministrator kan måske løse problemet ved at give gruppen Users fuld kontrol over filen.
update-in-progress-title = Opdaterer…
update-in-progress-message = Skal { -brand-short-name } fortsætte med denne opdatering?
update-in-progress-ok-button = &Annuller
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Fortsæt
addons-button = Udvidelser og temaer
account-button = Kontoindstillinger
open-addons-sidebar-button = Tilføjelser og temaer

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Indtast dine login-informationer til Windows for at oprette en hovedadgangskode. Dette hjælper med at beskytte dine kontis sikkerhed.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = oprette en hovedadgangskode
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = For at oprette en hovedadgangskode skal du indtaste dine login-oplysninger til Windows. Dette hjælper dig med at holde dine konti sikre.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = oprette en hovedadgangskode
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend = { -brand-short-name } startside
start-page-label =
    .label = Vis startsiden i meddelelsesområdet, når { -brand-short-name } starter
    .accesskey = V
location-label =
    .value = Startside:
    .accesskey = S
restore-default-label =
    .label = Gendan standard
    .accesskey = G
default-search-engine = Standardsøgetjeneste
add-search-engine =
    .label = Tilføj fra fil
    .accesskey = F
remove-search-engine =
    .label = Fjern
    .accesskey = r
minimize-to-tray-label =
    .label = Flyt { -brand-short-name } til systembakken, når programmet minimeres
    .accesskey = m
new-message-arrival = Når der kommer nye meddelelser:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Afspil den følgende lydfil:
           *[other] Afspil en lyd
        }
    .accesskey =
        { PLATFORM() ->
            [macos] n
           *[other] d
        }
mail-play-button =
    .label = Afspil
    .accesskey = A
change-dock-icon = Skift indstillinger for app-ikon
app-icon-options =
    .label = Indstillinger for app-ikon…
    .accesskey = I
notification-settings = Meddelelser og standardlyden kan deaktiveres på meddelelsessiden i systemindstillingerne.
animated-alert-label =
    .label = Vis en pop op-meddelelse
    .accesskey = p
customize-alert-label =
    .label = Tilpas…
    .accesskey = T
tray-icon-label =
    .label = Vis ikon i systembakken
    .accesskey = k
biff-use-system-alert =
    .label = Brug systemmeddelelse
tray-icon-unread-label =
    .label = Vis ikon i systembakken for ulæste meddelelser
    .accesskey = k
tray-icon-unread-description = Anbefales, når du bruges små knapper på proceslinjen
mail-system-sound-label =
    .label = Standard systemlyd ved modtagelse af ny mail
    .accesskey = y
mail-custom-sound-label =
    .label = Anvend følgende lydfil
    .accesskey = n
mail-browse-sound-button =
    .label = Gennemse…
    .accesskey = e
enable-gloda-search-label =
    .label = Aktiver global søgning og indeksering
    .accesskey = A
datetime-formatting-legend = Dato- og tidsformat
language-selector-legend = Sprog
allow-hw-accel =
    .label = Brug hardware-acceleration hvor muligt
    .accesskey = h
store-type-label =
    .value = Lagertype for meddelelser for nye konti:
    .accesskey = L
mbox-store-label =
    .label = En fil pr. mappe (mbox)
maildir-store-label =
    .label = En fil pr. meddelelse (maildir)
scrolling-legend = Scrolling
autoscroll-label =
    .label = Brug autoscrolling
    .accesskey = B
smooth-scrolling-label =
    .label = Brug blød scrolling
    .accesskey = r
system-integration-legend = Systemintegration
always-check-default =
    .label = Undersøg altid om { -brand-short-name } er standardmailprogrammet, når det startes
    .accesskey = U
check-default-button =
    .label = Undersøg nu…
    .accesskey = n
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Søgning
       *[other] { "" }
    }
search-integration-label =
    .label = Tillad { search-engine-name } at søge efter meddelelser
    .accesskey = T
config-editor-button =
    .label = Avancerede indstillinger…
    .accesskey = r
return-receipts-description = Vælg hvordan { -brand-short-name } skal håndtere kvitteringer
return-receipts-button =
    .label = Kvitteringer…
    .accesskey = v
update-app-legend = { -brand-short-name }-opdateringer
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Version { $version }
allow-description = Giv { -brand-short-name } tilladelse til at
automatic-updates-label =
    .label = Installere opdateringer automatisk (anbefalet, forbedrer sikkerheden)
    .accesskey = I
check-updates-label =
    .label = Søge efter opdateringer, men lade mig vælge om de skal installeres
    .accesskey = ø
update-history-button =
    .label = Vis opdateringshistorik
    .accesskey = V
use-service =
    .label = Brug en baggrundsservice til at installere opdateringer
    .accesskey = b
cross-user-udpate-warning = Denne indstilling gælder for alle Windows-konti og { -brand-short-name }-profiler der bruger denne installation af { -brand-short-name }.
networking-legend = Forbindelse
proxy-config-description = Konfigurer hvordan { -brand-short-name } forbinder til internettet
network-settings-button =
    .label = Indstillinger…
    .accesskey = I
offline-legend = Offline
offline-settings = Rediger offline-indstillinger
offline-settings-button =
    .label = Offline…
    .accesskey = O
diskspace-legend = Diskplads
offline-compact-folder =
    .label = Optimer mapper, når det kan spare mere end
    .accesskey = k
compact-folder-size =
    .value = MB

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Benyt op til
    .accesskey = B
use-cache-after = MB til mellemlageret

##

smart-cache-label =
    .label = Tilsidesæt automatisk cachehåndtering
    .accesskey = s
clear-cache-button =
    .label = Ryd nu
    .accesskey = R
fonts-legend = Skrifttyper & farver
default-font-label =
    .value = Standardskrifttype:
    .accesskey = S
default-size-label =
    .value = Størrelse:
    .accesskey = ø
font-options-button =
    .label = Avanceret…
    .accesskey = A
color-options-button =
    .label = Farver…
    .accesskey = F
display-width-legend = Meddelelser i ren tekst
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Vis smiley-ansigter som grafik.
    .accesskey = V
display-text-label = Ved visning af citerede meddelelser i ren tekst-format:
style-label =
    .value = Stil:
    .accesskey = i
regular-style-item =
    .label = Normal
bold-style-item =
    .label = Fed
italic-style-item =
    .label = Kursiv
bold-italic-style-item =
    .label = Fed kursiv
size-label =
    .value = Størrelse:
    .accesskey = r
regular-size-item =
    .label = Normal
bigger-size-item =
    .label = Større
smaller-size-item =
    .label = Mindre
quoted-text-color =
    .label = Farve:
    .accesskey = e
search-input =
    .placeholder = Søg
search-handler-table =
    .placeholder = Filtrer indholdstyper og handlinger
type-column-label =
    .label = Indholdstype
    .accesskey = I
action-column-label =
    .label = Handling
    .accesskey = H
save-to-label =
    .label = Gem filer i
    .accesskey = f
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Vælg…
           *[other] Gennemse…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] G
           *[other] G
        }
always-ask-label =
    .label = Spørg mig altid, hvor filer skal gemmes
    .accesskey = S
display-tags-text = Mærkater kan bruges til at kategorisere og prioritere dine meddelelser
new-tag-button =
    .label = Nyt…
    .accesskey = N
edit-tag-button =
    .label = Rediger…
    .accesskey = R
delete-tag-button =
    .label = Slet
    .accesskey = S
auto-mark-as-read =
    .label = Marker automatisk som læst
    .accesskey = M
mark-read-no-delay =
    .label = Marker omgående
    .accesskey = a

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Efter visning i
    .accesskey = v
seconds-label = sekunder

##

open-msg-label =
    .value = Åbn meddelelse i:
open-msg-tab =
    .label = Et nyt faneblad
    .accesskey = f
open-msg-window =
    .label = Et nyt meddelelsesvindue
    .accesskey = n
open-msg-ex-window =
    .label = Et eksisterende meddelelsesvindue
    .accesskey = e
close-move-delete =
    .label = Luk meddelelsesvinduet/-fanen ved flytning eller sletning
    .accesskey = L
display-name-label =
    .value = Vist navn:
condensed-addresses-label =
    .label = Vis kun "Vis som"-feltet for personer i min adressebog
    .accesskey = p

## Compose Tab

forward-label =
    .value = Videresend meddelelser som:
    .accesskey = v
inline-label =
    .label = En del af selve meddelelsen
as-attachment-label =
    .label = Vedhæftet fil
extension-label =
    .label = tilføj filendelse til filnavn
    .accesskey = t

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Gem automatisk hvert
    .accesskey = m
auto-save-end = minut

##

warn-on-send-accel-key =
    .label = Bekræft når genvejstaster bruges til at sende meddelelser
    .accesskey = æ
spellcheck-label =
    .label = Udfør stavekontrol før meddelelsen sendes
    .accesskey = U
spellcheck-inline-label =
    .label = Anvend løbende stavekontrol
    .accesskey = n
language-popup-label =
    .value = Sprog:
    .accesskey = S
download-dictionaries-link = Hent flere ordbøger
font-label =
    .value = Skrifttype:
    .accesskey = S
font-size-label =
    .value = Størrelse:
    .accesskey = ø
default-colors-label =
    .label = Brug læserens standardfarver
    .accesskey = u
font-color-label =
    .value = Tekstfarve:
    .accesskey = F
bg-color-label =
    .value = Baggrundsfarve:
    .accesskey = B
restore-html-label =
    .label = Gendan standard
    .accesskey = G
default-format-label =
    .label = Benyt afsnitsformat som standard i stedet for formatet for almindelig tekst
    .accesskey = e
format-description = Konfigurering af meddelelsesindholdet:
send-options-label =
    .label = Afsendelsesindstillinger…
    .accesskey = A
autocomplete-description = Søg efter adresser i:
ab-label =
    .label = Lokale adressebøger
    .accesskey = L
directories-label =
    .label = LDAP-server:
    .accesskey = s
directories-none-label =
    .none = Ingen
edit-directories-label =
    .label = Rediger LDAP-servere…
    .accesskey = R
email-picker-label =
    .label = Tilføj automatisk modtageres mailadresser i:
    .accesskey = A
default-directory-label =
    .value = Standardmappe ved start i vinduet Adressebog:
    .accesskey = t
default-last-label =
    .none = Senest brugte mappe
attachment-label =
    .label = Kontroller for manglende vedhæftede filer
    .accesskey = K
attachment-options-label =
    .label = Stikord…
    .accesskey = i
enable-cloud-share =
    .label = Tilbyd at bruge Filelink ved filer større end
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = Tilføj…
    .accesskey = T
    .defaultlabel = Tilføj…
remove-cloud-account =
    .label = Fjern
    .accesskey = F
find-cloud-providers =
    .value = Find flere udbydere…
cloud-account-description = Tilføj en ny Filelink-tjeneste

## Privacy Tab

mail-content = Meddelelsesindhold
remote-content-label =
    .label = Tillad eksternt indhold i meddelelser
    .accesskey = T
exceptions-button =
    .label = Undtagelser…
    .accesskey = n
remote-content-info =
    .value = Læs mere om problemer med privatliv i forbindelse med eksternt indhold
web-content = Webindhold
history-label =
    .label = Husk websteder og links jeg har besøgt
    .accesskey = H
cookies-label =
    .label = Accepter cookies fra websteder
    .accesskey = A
third-party-label =
    .value = Accepter tredjeparts cookies:
    .accesskey = c
third-party-always =
    .label = Altid
third-party-never =
    .label = Aldrig
third-party-visited =
    .label = Fra besøgte
keep-label =
    .value = Behold indtil:
    .accesskey = B
keep-expire =
    .label = De udløber
keep-close =
    .label = Jeg lukker { -brand-short-name }
keep-ask =
    .label = Spørg mig hver gang
cookies-button =
    .label = Vis cookies…
    .accesskey = V
do-not-track-label =
    .label = Send et “Spor mig ikke”-signal til websider som tegn på, at du ikke ønsker at blive sporet
    .accesskey = n
learn-button =
    .label = Læs mere
passwords-description = { -brand-short-name } kan huske adgangskoder til alle dine konti, så du ikke behøver at indtaste dem.
passwords-button =
    .label = Gemte adgangskoder…
    .accesskey = G
master-password-description = Hovedadgangskoden beskytter alle dine adgangskoder, men du skal indtaste den ved hver opstart.
master-password-label =
    .label = Brug hovedadgangskode
    .accesskey = U
master-password-button =
    .label = Skift hovedadgangskode…
    .accesskey = S
primary-password-description = Hovedadgangskoden beskytter alle dine adgangskoder, men du skal indtaste den ved hver opstart.
primary-password-label =
    .label = Brug hovedadgangskode
    .accesskey = u
primary-password-button =
    .label = Skift hovedadgangskode…
    .accesskey = S
forms-primary-pw-fips-title = Du er i FIPS-tilstand. FIPS kræver at hovedadgangskoden er sat.
forms-master-pw-fips-desc = Ændring af adgangskode mislykkedes
junk-description = Du kan redigere kontospecifikke spam-indstillinger i vinduet Kontoindstillinger.
junk-label =
    .label = Når du markerer meddelelsen som spam:
    .accesskey = å
junk-move-label =
    .label = Flyt dem til mappen Spam på kontoen
    .accesskey = F
junk-delete-label =
    .label = Slet dem
    .accesskey = S
junk-read-label =
    .label = Marker spam-meddelelser som læste
    .accesskey = M
junk-log-label =
    .label = Aktiver logning af spam-filter
    .accesskey = A
junk-log-button =
    .label = Vis log
    .accesskey = V
reset-junk-button =
    .label = Nulstil indlærte data
    .accesskey = N
phishing-description = { -brand-short-name } kan analysere meddelelser for mailsvindel ved at se efter standardteknikker, som benyttes til at snyde dig.
phishing-label =
    .label = Fortæl mig, hvis meddelelsen jeg læser er mailsvindel
    .accesskey = F
antivirus-description = { -brand-short-name } kan gøre det lettere for antivirusprogrammer at analysere indkommende meddelelser for virus, før de gemmes lokalt.
antivirus-label =
    .label = Tillad antivirusprogrammer at sætte indkommende meddelelser i karantæne
    .accesskey = T
certificate-description = Når en server forespørger mit personlige certifikat:
certificate-auto =
    .label = Vælg et automatisk
    .accesskey = a
certificate-ask =
    .label = Spørg mig hver gang
    .accesskey = ø
ocsp-label =
    .label = Send forespørgsel til OCSP responder-servere for at bekræfte certifikaters aktuelle gyldighed
    .accesskey = e
certificate-button =
    .label = Håndter certifikater…
    .accesskey = H
security-devices-button =
    .label = Sikkerhedsenheder…
    .accesskey = E

## Chat Tab

startup-label =
    .value = Når { -brand-short-name } startes:
    .accesskey = s
offline-label =
    .label = Lad mine chat-konti være offline
auto-connect-label =
    .label = Forbind automatisk mine chat-konti

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Skift min status til Ikke til stede efter
    .accesskey = i
idle-time-label = minutter uden aktivitet

##

away-message-label =
    .label = og vis denne meddelelse:
    .accesskey = m
send-typing-label =
    .label = Vis, når der skrives i samtaler
    .accesskey = n
notification-label = Når meddelelser til dig ankommer:
show-notification-label =
    .label = Vis en besked
    .accesskey = V
notification-all =
    .label = med afsenderens navn og en forhåndsvisning af indholdet
notification-name =
    .label = med afsenderens navn og intet andet
notification-empty =
    .label = uden info fra mailen
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animér dock-ikon
           *[other] Blink på proceslinje
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] k
        }
chat-play-sound-label =
    .label = Afspil lyd
    .accesskey = l
chat-play-button =
    .label = Afspil
    .accesskey = A
chat-system-sound-label =
    .label = Standard systemlyd ved modtagelse af ny mail
    .accesskey = y
chat-custom-sound-label =
    .label = Brug denne lydfil
    .accesskey = B
chat-browse-sound-button =
    .label = Gennemse…
    .accesskey = G
theme-label =
    .value = Tema:
    .accesskey = T
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Bobler
style-dark =
    .label = Mørk
style-paper =
    .label = Papirark
style-simple =
    .label = Simpel
preview-label = Forhåndsvisning:
no-preview-label = Ingen forhåndsvisning
no-preview-description = Temaet er ikke gyldigt eller kan ikke vises lige nu (tilføjelse deaktiveret, fejlsikret tilstand ...).
chat-variant-label =
    .value = Variant:
    .accesskey = V
chat-header-label =
    .label = Vis hoved
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
            [windows] Søg i indstillinger
           *[other] Søg i indstillinger
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
    .placeholder = Søg i indstillinger

## Preferences UI Search Results

search-results-header = Søgeresultater
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Beklager! Der er ingen resultater for "<span data-l10n-name="query"></span>" i Indstillingerne.
       *[other] Beklager! Der er ingen resultater for "<span data-l10n-name="query"></span>" i Indstillingerne.
    }
search-results-help-link = Har du brug for hjælp? Besøg <a data-l10n-name="url">Hjælp til { -brand-short-name }</a>
