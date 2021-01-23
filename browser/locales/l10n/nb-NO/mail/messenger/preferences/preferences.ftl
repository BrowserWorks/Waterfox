# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Lukk

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Innstillinger
           *[other] Innstillinger
        }

pane-general-title = Generelt
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Skriving
category-compose =
    .tooltiptext = Skriving

pane-privacy-title = Personvern og sikkerhet
category-privacy =
    .tooltiptext = Personvern og sikkerhet

pane-chat-title = Nettprat
category-chat =
    .tooltiptext = Nettprat

pane-calendar-title = Kalender
category-calendar =
    .tooltiptext = Kalender

general-language-and-appearance-header = Språk og utseende

general-incoming-mail-header = Innkommende e-post

general-files-and-attachment-header = Filer og vedlegg

general-tags-header = Etiketter

general-reading-and-display-header = Lesing og visning

general-updates-header = Oppdateringer

general-network-and-diskspace-header = Nettverk og diskplass

general-indexing-label = Indeksering

composition-category-header = Utforming

composition-attachments-header = Vedlegg

composition-spelling-title = Stavekontroll

compose-html-style-title = HTML-stil

composition-addressing-header = Adressering

privacy-main-header = Personvern

privacy-passwords-header = Passord

privacy-junk-header = Uønsket

collection-header = Datainnsamling og bruk for { -brand-short-name }

collection-description = Vi prøver alltid å gi deg valg og samler bare det vi trenger for å levere og forbedre { -brand-short-name } for alle. Vi ber alltid om tillatelse før vi aksepterer personopplysninger.
collection-privacy-notice = Personvernerklæring

collection-health-report-telemetry-disabled = Du tillater ikke lenger { -vendor-short-name } å samle inn teknisk data og data om bruk. Alle tidligere data vil bli slettet innen 30 dager.
collection-health-report-telemetry-disabled-link = Les mer

collection-health-report =
    .label = Tillat { -brand-short-name } å sende tekniske data og data for bruk til { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Les mer

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Datarapportering er deaktivert for denne byggekonfigurasjonen

collection-backlogged-crash-reports =
    .label = Tillat { -brand-short-name } å sende etterslepne krasjrapporter på dine vegne
    .accesskey = k
collection-backlogged-crash-reports-link = Les mer

privacy-security-header = Sikkerhet

privacy-scam-detection-title = Svindeldetektering

privacy-anti-virus-title = Antivirus

privacy-certificates-title = Sertifikater

chat-pane-header = Nettprat

chat-status-title = Status

chat-notifications-title = Varsler

chat-pane-styling-header = Stil

choose-messenger-language-description = Velg språkene som brukes til å vise menyer, meldinger og varsler fra { -brand-short-name }.
manage-messenger-languages-button =
    .label = Angi alternativ…
    .accesskey = l
confirm-messenger-language-change-description = Start om { -brand-short-name } for å bruke disse endringene
confirm-messenger-language-change-button = Bruk og start om

update-setting-write-failure-title = Kunne ikke lagre oppdateringsinnstillinger

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } oppdaget en feil og lagret ikke denne endringen. Merk, for å kunne lagre endringen av denne oppdateringsinnstillingen, kreves det tillatelse til å skrive til filen nedenfor. Du eller en systemadministrator kan muligens løse feilen ved å gi gruppen Brukere full tilgang til denne filen.
    
    Kunne ikke skrive til filen: { $path }

update-in-progress-title = Oppdatering pågår

update-in-progress-message = Vil du at { -brand-short-name } skal fortsette med denne oppdateringen?

update-in-progress-ok-button = &Avvis
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Fortsett

addons-button = Utvidelser og temaer

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Skriv inn innloggingsinformasjonen for Windows for å opprette et hovedpassord. Dette vil gjøre kontoene dine tryggere.

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = opprette et hovedpassord

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Skriv inn innloggingsinformasjonen for Windows for å opprette et hovedpassord. Dette vil gjøre kontoene dine tryggere.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = opprett et hovedpassord

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name }-startside

start-page-label =
    .label = Vis startsiden i meldingsområdet når { -brand-short-name } starter
    .accesskey = V

location-label =
    .value = Adresse:
    .accesskey = A
restore-default-label =
    .label = Bruk standard
    .accesskey = u

default-search-engine = Standard søkemotor
add-search-engine =
    .label = Legg til fra fil
    .accesskey = e
remove-search-engine =
    .label = Fjern
    .accesskey = e

minimize-to-tray-label =
    .label = Når { -brand-short-name } er minimert, flytt den til systemstatusfeltet
    .accesskey = m

new-message-arrival = Når en ny melding ankommer:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Spill av følgende lydfil:
           *[other] Spill av en lyd
        }
    .accesskey =
        { PLATFORM() ->
            [macos] d
           *[other] S
        }
mail-play-button =
    .label = Spill av
    .accesskey = p

change-dock-icon = Endre innstillinger for app-ikonet
app-icon-options =
    .label = Innstillinger for app-ikon …
    .accesskey = n

notification-settings = Varsler og standardlyden kan deaktiveres i Varslinger-panelet i Systemvalg.

animated-alert-label =
    .label = Vis en beskjed
    .accesskey = n
customize-alert-label =
    .label = Avansert …
    .accesskey = e

tray-icon-label =
    .label = Vis et ikon i systemstatusfeltet
    .accesskey = t

mail-system-sound-label =
    .label = Standard systemlyd for ny e-post
    .accesskey = S
mail-custom-sound-label =
    .label = Bruk følgende lydfil
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
    .label = Bruk maskinvareakselerasjon når tilgjengelig
    .accesskey = m

store-type-label =
    .value = Meldingslagringstype for nye kontoer:
    .accesskey = d

mbox-store-label =
    .label = Fil per mappe (mbox)
maildir-store-label =
    .label = Fil per melding (maildir)

scrolling-legend = Rulling
autoscroll-label =
    .label = Bruk automatisk rulling
    .accesskey = B
smooth-scrolling-label =
    .label = Bruk jevn rulling
    .accesskey = r

system-integration-legend = Systemintegrasjon
always-check-default =
    .label = Alltid kontroller om { -brand-short-name } er standard e-postklient ved oppstart
    .accesskey = l
check-default-button =
    .label = Sjekk nå
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
    .label = Tillat { search-engine-name } å søke i meldinger
    .accesskey = s

config-editor-button =
    .label = Konfigurasjonseditor …
    .accesskey = o

return-receipts-description = Bestem hvordan { -brand-short-name } behandler kvitteringer
return-receipts-button =
    .label = Kvitteringer …
    .accesskey = K

update-app-legend = { -brand-short-name }-oppdateringer

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Versjon { $version }

allow-description = Tillat { -brand-short-name } å
automatic-updates-label =
    .label = Automatisk installer oppdateringer (anbefalt: bedre sikkerhet)
    .accesskey = A
check-updates-label =
    .label = Søk etter oppdateringer, men la meg velge om de skal installeres
    .accesskey = S

update-history-button =
    .label = Vis oppdateringshistorikk
    .accesskey = V

use-service =
    .label = Bruk en bakgrunnstjeneste for å installere oppdateringer
    .accesskey = B

cross-user-udpate-warning = Denne innstilling gjelder for alle Windows-kontoer og { -brand-short-name }-profiler som bruker denne installasjonen av { -brand-short-name }.

networking-legend = Tilkobling
proxy-config-description = Bestem hvordan { -brand-short-name } kobler til Internett

network-settings-button =
    .label = Innstillinger …
    .accesskey = I

offline-legend = Frakoblet
offline-settings = Konfigurer innstillinger for frakoblet modus

offline-settings-button =
    .label = Frakoblet …
    .accesskey = F

diskspace-legend = Diskplass
offline-compact-folder =
    .label = Komprimer alle mapper når det vil spare mer enn
    .accesskey = K

compact-folder-size =
    .value = MB totalt

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Bruk opptil
    .accesskey = B

use-cache-after = MB diskplass for hurtiglager

##

smart-cache-label =
    .label = Overstyr automatisk hurtigbufferadministrasjon
    .accesskey = v

clear-cache-button =
    .label = Tøm nå
    .accesskey = T

fonts-legend = Skrifttyper og farger

default-font-label =
    .value = Standard skrifttype:
    .accesskey = t

default-size-label =
    .value = Størrelse:
    .accesskey = ø

font-options-button =
    .label = Skrifttyper …
    .accesskey = r

color-options-button =
    .label = Farger …
    .accesskey = F

display-width-legend = Meldinger i normal tekst

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Vis smileansikter som bilder
    .accesskey = m

display-text-label = Ved visning av sitater i tekstmeldinger:

style-label =
    .value = Stil:
    .accesskey = S

regular-style-item =
    .label = Vanlig
bold-style-item =
    .label = Fet
italic-style-item =
    .label = Kursiv
bold-italic-style-item =
    .label = Fet og kursiv

size-label =
    .value = Størrelse:
    .accesskey = ø

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
    .label = Innholdstype
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
            [macos] Velg …
           *[other] Bla gjennom …
        }
    .accesskey =
        { PLATFORM() ->
            [macos] V
           *[other] B
        }

always-ask-label =
    .label = Alltid spør meg hvor jeg vil lagre filer
    .accesskey = A


display-tags-text = Etiketter kan brukes for å kategorisere og prioritere meldingene dine.

new-tag-button =
    .label = Ny…
    .accesskey = N

edit-tag-button =
    .label = Rediger …
    .accesskey = R

delete-tag-button =
    .label = Slett
    .accesskey = S

auto-mark-as-read =
    .label = Automatisk merk meldinger som lest
    .accesskey = A

mark-read-no-delay =
    .label = Umiddelbart etter de er vist
    .accesskey = U

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Etter de er vist i
    .accesskey = E

seconds-label = sekunder

##

open-msg-label =
    .value = Åpne meldinger i:

open-msg-tab =
    .label = En ny fane
    .accesskey = n

open-msg-window =
    .label = Et nytt meldingsvindu
    .accesskey = E

open-msg-ex-window =
    .label = Et eksisterende meldingsvindu
    .accesskey = t

close-move-delete =
    .label = Lukk meldingsvindu/fane ved flytting eller sletting
    .accesskey = L

display-name-label =
    .value = Visningsnavn:

condensed-addresses-label =
    .label = Vis bare visningsnavnet for personer i adresseboken
    .accesskey = V

## Compose Tab

forward-label =
    .value = Videresend meldinger:
    .accesskey = V

inline-label =
    .label = Innbundet

as-attachment-label =
    .label = Som vedlegg

extension-label =
    .label = Legg til etternavn på filnavnet
    .accesskey = L

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Lagre meldinger automatisk hvert
    .accesskey = a

auto-save-end = minutt

##

warn-on-send-accel-key =
    .label = Bekreft når tastatursnarvei brukes for å sende meldinger
    .accesskey = e

spellcheck-label =
    .label = Stavekontroller før meldinger sendes
    .accesskey = S

spellcheck-inline-label =
    .label = Stavekontroller mens meldinger skrives
    .accesskey = a

language-popup-label =
    .value = Språk:
    .accesskey = k

download-dictionaries-link = Last ned flere ordbøker

font-label =
    .value = Skrifttype:
    .accesskey = S

font-size-label =
    .value = Størrelse:
    .accesskey = e

default-colors-label =
    .label = Bruk leserens standardfarger
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
    .label = Bruk paragrafformat i stedet for brødtekst som standard
    .accesskey = p

format-description = Konfigurer oppførselen til tekstformatet

send-options-label =
    .label = Sendeinnstillinger …
    .accesskey = n

autocomplete-description = Ved adressering av meldinger, søk etter treff i:

ab-label =
    .label = Lokale adressebøker
    .accesskey = L

directories-label =
    .label = Katalogserver:
    .accesskey = K

directories-none-label =
    .none = Ingen

edit-directories-label =
    .label = Rediger kataloger …
    .accesskey = R

email-picker-label =
    .label = Automatisk legg til adresser fra utgående e-post i:
    .accesskey = A

default-directory-label =
    .value = Standard startkatalog i adressbokvinduet.
    .accesskey = S

default-last-label =
    .none = Sist brukte katalog

attachment-label =
    .label = Advar dersom vedlegg mangler
    .accesskey = o

attachment-options-label =
    .label = Nøkkelord …
    .accesskey = N

enable-cloud-share =
    .label = Tilby å dele for filer større enn
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Legg til …
    .accesskey = L
    .defaultlabel = Legg til …

remove-cloud-account =
    .label = Fjern
    .accesskey = F

find-cloud-providers =
    .value = Finn flere leverandører…

cloud-account-description = Legg til en Filelink lagringstjeneste


## Privacy Tab

mail-content = E-postinnhold

remote-content-label =
    .label = Tillat eksternt innhold i meldinger
    .accesskey = T

exceptions-button =
    .label = Unntak …
    .accesskey = U

remote-content-info =
    .value = Les mer om personvernutfordringene ved eksternt innhold

web-content = Webinnhold

history-label =
    .label = Husk nettsider og lenker jeg har besøkt
    .accesskey = H

cookies-label =
    .label = Tillat infokapsler fra nettsteder
    .accesskey = T

third-party-label =
    .value = Tillat tredjeparts infokapsler:
    .accesskey = i

third-party-always =
    .label = Alltid
third-party-never =
    .label = Aldri
third-party-visited =
    .label = Fra besøkte

keep-label =
    .value = Behold inntil:
    .accesskey = e

keep-expire =
    .label = de utgår på dato
keep-close =
    .label = jeg lukker { -brand-short-name }
keep-ask =
    .label = spør meg hver gang

cookies-button =
    .label = Vis infokapsler …
    .accesskey = V

do-not-track-label =
    .label = Send nettsider et «Ikke spor»-signal om at du ikke vil bli sporet
    .accesskey = n

learn-button =
    .label = Les mer

passwords-description = { -brand-short-name } kan huske passordene for alle kontoene dine.

passwords-button =
    .label = Lagrede passord …
    .accesskey = L

master-password-description = Du kan bruke et hovedpassord for å beskytte alle passordene, men da må du skrive inn passordet en gang for hver programøkt.

master-password-label =
    .label = Bruk et hovedpassord
    .accesskey = B

master-password-button =
    .label = Endre hovedpassord …
    .accesskey = E


primary-password-description = Du kan bruke et hovedpassord for å beskytte alle passordene, men da må du skrive inn passordet en gang for hver programøkt.

primary-password-label =
    .label = Bruk et hovedpassord
    .accesskey = B

primary-password-button =
    .label = Endre hovedpassord…
    .accesskey = E

forms-primary-pw-fips-title = Du er for tiden i FIPS-modus. FIPS krever at du bruker et hovedpassord.
forms-master-pw-fips-desc = Passordendring mislyktes


junk-description = Angi standard oppførsel for uønsket e-post. Konto-spesifikke innstillinger for uønsket e-post kan angis i Kontoinnstillinger.

junk-label =
    .label = Når jeg markerer meldinger som uønskede:
    .accesskey = N

junk-move-label =
    .label = Flytt dem til kontoens «Uønsket»-mappe
    .accesskey = F

junk-delete-label =
    .label = Slett dem
    .accesskey = S

junk-read-label =
    .label = Marker uønskede meldinger som lest
    .accesskey = M

junk-log-label =
    .label = Slå på logging for adaptiv filter for uønsket e-post
    .accesskey = l

junk-log-button =
    .label = Vis logg
    .accesskey = V

reset-junk-button =
    .label = Tilbakestill treningsdata
    .accesskey = T

phishing-description = { -brand-short-name } kan analysere meldinger og oppdage mulige e-postsvindler ved å se etter vanlige teknikker brukt for å lure deg.

phishing-label =
    .label = Fortell meg dersom meldinger jeg leser er mistenkte e-postsvindler
    .accesskey = F

antivirus-description = { -brand-short-name } kan gjøre det enkelt for antivirus-programmer å analysere e-post du laster ned for virus før de lagres.

antivirus-label =
    .label = Tillat antivirus-programmer å sette innkommende meldinger i karantene
    .accesskey = T

certificate-description = Når en server spør etter mitt personlige sertifikat:

certificate-auto =
    .label = Velg ett automatisk
    .accesskey = e

certificate-ask =
    .label = Spør meg hver gang
    .accesskey = S

ocsp-label =
    .label = Spør OCSP-serverne om å bekrefte gyldigheten til sertifikater
    .accesskey = S

certificate-button =
    .label = Behandle sertifikater…
    .accesskey = B

security-devices-button =
    .label = Sikkerhetsenheter…
    .accesskey = e

## Chat Tab

startup-label =
    .value = Når { -brand-short-name } starter:
    .accesskey = N

offline-label =
    .label = Behold nettprat-kontoene frakoblet

auto-connect-label =
    .label = Koble til nettprat-kontoene automatisk

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = La kontaktene mine vite at jeg er inaktiv etter
    .accesskey = L

idle-time-label = minutter med inaktivitet

##

away-message-label =
    .label = og sett status til borte med denne statusmeldingen:
    .accesskey = o

send-typing-label =
    .label = Send varsler om at jeg skriver i samtaler
    .accesskey = S

notification-label = Når meldinger sendt til deg ankommer:

show-notification-label =
    .label = Vis et varsel
    .accesskey = V

notification-all =
    .label = med avsenderens navn og forhåndsvisning
notification-name =
    .label = bare med avsenderens navn
notification-empty =
    .label = uten noe info

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animer dock-ikonet
           *[other] Blink i oppgavelinjen
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] B
        }

chat-play-sound-label =
    .label = Spill av en lyd
    .accesskey = l

chat-play-button =
    .label = Spill av
    .accesskey = p

chat-system-sound-label =
    .label = Standard systemlyd for ny e-post
    .accesskey = t

chat-custom-sound-label =
    .label = Bruk lydfil
    .accesskey = B

chat-browse-sound-button =
    .label = Bla gjennom …
    .accesskey = l

theme-label =
    .value = Tema:
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

preview-label = Forhåndsvisning:
no-preview-label = Ingen forhåndsvisning tilgjengelig
no-preview-description = Dette temaet er ikke gyldig eller er for øyeblikket utilgjengelig (deaktivert utvidelse, sikker modus, ...).

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
            [windows] Søk i innstillinger
           *[other] Søk i innstillinger
        }

## Preferences UI Search Results

search-results-header = Søkeresultat

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Beklager! Det er ingen resultat i innstillinger for «<span data-l10n-name="query"></span>».
       *[other] Beklager! Det er ingen resultat i innstillinger for «<span data-l10n-name="query"></span>».
    }

search-results-help-link = Trenger du hjelp? Gå til <a data-l10n-name="url">{ -brand-short-name } brukerstøtte</a>

## Preferences UI Search Results

