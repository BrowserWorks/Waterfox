# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Sluiten
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Opties
           *[other] Voorkeuren
        }
preferences-tab-title =
    .title = Voorkeuren
preferences-doc-title = Voorkeuren
category-list =
    .aria-label = Categorieën
pane-general-title = Algemeen
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = Opstellen
category-compose =
    .tooltiptext = Opstellen
pane-privacy-title = Privacy & Beveiliging
category-privacy =
    .tooltiptext = Privacy & Beveiliging
pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat
pane-calendar-title = Agenda
category-calendar =
    .tooltiptext = Agenda
general-language-and-appearance-header = Taal & Vormgeving
general-incoming-mail-header = Inkomende berichten
general-files-and-attachment-header = Bestanden & Bijlagen
general-tags-header = Labels
general-reading-and-display-header = Lezen & Weergave
general-updates-header = Updates
general-network-and-diskspace-header = Netwerk & Schijfruimte
general-indexing-label = Indexering
composition-category-header = Opstellen
composition-attachments-header = Bijlagen
composition-spelling-title = Spelling
compose-html-style-title = HTML-stijl
composition-addressing-header = Adressering
privacy-main-header = Privacy
privacy-passwords-header = Wachtwoorden
privacy-junk-header = Ongewenste berichten
collection-header = { -brand-short-name }-gegevensverzameling en -gebruik
collection-description = We streven ernaar u keuzes te bieden en alleen te verzamelen wat we nodig hebben om { -brand-short-name } voor iedereen beschikbaar te maken en te verbeteren. We vragen altijd toestemming voordat we persoonlijke gegevens ontvangen.
collection-privacy-notice = Privacyverklaring
collection-health-report-telemetry-disabled = U staat { -vendor-short-name } niet langer toe technische en interactiegegevens vast te leggen. Alle eerdere gegevens worden binnen 30 dagen verwijderd.
collection-health-report-telemetry-disabled-link = Meer info
collection-health-report =
    .label = { -brand-short-name } toestaan om technische en interactiegegevens naar { -vendor-short-name } te verzenden
    .accesskey = r
collection-health-report-link = Meer info
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Gegevensrapportage is uitgeschakeld voor deze buildconfiguratie
collection-backlogged-crash-reports =
    .label = { -brand-short-name } toestaan om namens u achterstallige crashrapporten te verzenden
    .accesskey = c
collection-backlogged-crash-reports-link = Meer info
privacy-security-header = Beveiliging
privacy-scam-detection-title = Scamdetectie
privacy-anti-virus-title = Antivirus
privacy-certificates-title = Certificaten
chat-pane-header = Chat
chat-status-title = Status
chat-notifications-title = Notificaties
chat-pane-styling-header = Vormgeving
choose-messenger-language-description = Kies de talen die worden gebruikt voor het weergeven van menu’s, berichten en notificaties van { -brand-short-name }.
manage-messenger-languages-button =
    .label = Alternatieven instellen…
    .accesskey = l
confirm-messenger-language-change-description = Herstart { -brand-short-name } om deze wijzigingen toe te passen.
confirm-messenger-language-change-button = Toepassen en herstarten
update-setting-write-failure-title = Fout bij opslaan updatevoorkeuren
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } heeft een fout aangetroffen en heeft deze wijziging niet opgeslagen. Merk op dat voor het instellen van deze updatevoorkeur schrijfrechten voor onderstaand bestand benodigd zijn. U of uw systeembeheerder kan deze fout oplossen door de groep Gebruikers volledige toegang tot dit bestand te geven.
    
    Kon niet schrijven naar bestand: { $path }
update-in-progress-title = Update wordt uitgevoerd
update-in-progress-message = Wilt u dat { -brand-short-name } doorgaat met deze update?
update-in-progress-ok-button = &Verwerpen
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Doorgaan
addons-button = Extensies & Thema’s
account-button = Accountinstellingen
open-addons-sidebar-button = Add-ons en thema’s

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Voer uw aanmeldgegevens voor Windows in om een hoofdwachtwoord in te stellen. Hierdoor wordt de beveiliging van uw accounts beschermd.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = een hoofdwachtwoord aan te maken
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Voer uw aanmeldgegevens voor Windows in om een hoofdwachtwoord in te stellen. Hierdoor wordt de beveiliging van uw accounts beschermd.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = een hoofdwachtwoord aanmaken
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend = { -brand-short-name }-startpagina
start-page-label =
    .label = Wanneer { -brand-short-name } start, de startpagina in het berichtgedeelte tonen
    .accesskey = W
location-label =
    .value = Locatie:
    .accesskey = L
restore-default-label =
    .label = Standaardinstelling herstellen
    .accesskey = S
default-search-engine = Standaardzoekmachine
add-search-engine =
    .label = Uit bestand toevoegen
    .accesskey = U
remove-search-engine =
    .label = Verwijderen
    .accesskey = d
minimize-to-tray-label =
    .label = Naar de systeembalk verplaatsen wanneer { -brand-short-name } is geminimaliseerd
    .accesskey = m
new-message-arrival = Als nieuwe berichten binnenkomen:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Het volgende geluidsbestand afspelen:
           *[other] Een geluid afspelen
        }
    .accesskey =
        { PLATFORM() ->
            [macos] v
           *[other] u
        }
mail-play-button =
    .label = Afspelen
    .accesskey = f
change-dock-icon = Voorkeuren van het programmasymbool wijzigen
app-icon-options =
    .label = Programmasymboolopties…
    .accesskey = P
notification-settings = Waarschuwingen en het standaardgeluid kunnen worden uitgeschakeld via het paneel Berichtgeving in Systeemvoorkeuren.
animated-alert-label =
    .label = Een waarschuwing tonen
    .accesskey = r
customize-alert-label =
    .label = Aanpassen…
    .accesskey = A
tray-icon-label =
    .label = Een systeemvakpictogram tonen
    .accesskey = t
biff-use-system-alert =
    .label = De systeemmelding gebruiken
tray-icon-unread-label =
    .label = Een systeemvakpictogram voor ongelezen berichten tonen
    .accesskey = t
tray-icon-unread-description = Aanbevolen bij gebruik van kleine taakbalkknoppen
mail-system-sound-label =
    .label = Standaard systeemgeluid voor nieuwe e-mail
    .accesskey = S
mail-custom-sound-label =
    .label = Het volgende geluidsbestand gebruiken
    .accesskey = v
mail-browse-sound-button =
    .label = Bladeren…
    .accesskey = B
enable-gloda-search-label =
    .label = Globaal zoeken en indexeren activeren
    .accesskey = G
datetime-formatting-legend = Datum- en tijdopmaak
language-selector-legend = Taal
allow-hw-accel =
    .label = Hardwareversnelling gebruiken wanneer beschikbaar
    .accesskey = v
store-type-label =
    .value = Type berichtenopslag voor nieuwe accounts:
    .accesskey = b
mbox-store-label =
    .label = Eén bestand per map (mbox)
maildir-store-label =
    .label = Eén bestand per bericht (maildir)
scrolling-legend = Scrollen
autoscroll-label =
    .label = Automatisch scrollen gebruiken
    .accesskey = m
smooth-scrolling-label =
    .label = Vloeiend scrollen gebruiken
    .accesskey = e
system-integration-legend = Systeemintegratie
always-check-default =
    .label = Altijd tijdens het opstarten controleren of { -brand-short-name } de standaard e-mailclient is
    .accesskey = A
check-default-button =
    .label = Nu controleren…
    .accesskey = N
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Zoeken
       *[other] { "" }
    }
search-integration-label =
    .label = { search-engine-name } toestaan om berichten te doorzoeken
    .accesskey = t
config-editor-button =
    .label = Configuratie-editor…
    .accesskey = C
return-receipts-description = Bepalen hoe { -brand-short-name } omgaat met leesbevestigingen
return-receipts-button =
    .label = Leesbevestigingen…
    .accesskey = L
update-app-legend = { -brand-short-name }-updates
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Versie { $version }
allow-description = { -brand-short-name } mag
automatic-updates-label =
    .label = Updates automatisch installeren (aanbevolen: verbeterde beveiliging)
    .accesskey = U
check-updates-label =
    .label = Controleren op updates, maar mij laten kiezen of ik deze wil installeren
    .accesskey = C
update-history-button =
    .label = Updategeschiedenis tonen
    .accesskey = d
use-service =
    .label = Een achtergrondservice gebruiken om updates te installeren
    .accesskey = a
cross-user-udpate-warning = Deze instelling is van toepassing op alle Windows-accounts en { -brand-short-name }-profielen die deze installatie van { -brand-short-name } gebruiken.
networking-legend = Verbinding
proxy-config-description = Configureren hoe { -brand-short-name } verbinding maakt met het internet
network-settings-button =
    .label = Instellingen…
    .accesskey = I
offline-legend = Offline
offline-settings = Offline-instellingen configureren
offline-settings-button =
    .label = Offline…
    .accesskey = O
diskspace-legend = Schijfruimte
offline-compact-folder =
    .label = Alle mappen comprimeren als dit meer bespaart dan
    .accesskey = m
compact-folder-size =
    .value = MB in totaal

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Tot
    .accesskey = T
use-cache-after = MB ruimte gebruiken voor de buffer

##

smart-cache-label =
    .label = Automatisch bufferbeheer negeren
    .accesskey = A
clear-cache-button =
    .label = Nu wissen
    .accesskey = w
fonts-legend = Lettertypen & kleuren
default-font-label =
    .value = Standaardlettertype:
    .accesskey = S
default-size-label =
    .value = Grootte:
    .accesskey = G
font-options-button =
    .label = Geavanceerd…
    .accesskey = c
color-options-button =
    .label = Kleuren…
    .accesskey = K
display-width-legend = Plattetekstberichten
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Emoticons weergeven als afbeeldingen
    .accesskey = E
display-text-label = Geciteerde tekst in plattetekstberichten weergeven als:
style-label =
    .value = Stijl:
    .accesskey = t
regular-style-item =
    .label = Normaal
bold-style-item =
    .label = Vet
italic-style-item =
    .label = Cursief
bold-italic-style-item =
    .label = Vet en cursief
size-label =
    .value = Grootte:
    .accesskey = r
regular-size-item =
    .label = Normaal
bigger-size-item =
    .label = Groter
smaller-size-item =
    .label = Kleiner
quoted-text-color =
    .label = Kleur:
    .accesskey = u
search-input =
    .placeholder = Zoeken
search-handler-table =
    .placeholder = Inhoudstypen en acties filteren
type-column-label =
    .label = Inhoudstype
    .accesskey = t
action-column-label =
    .label = Actie
    .accesskey = A
save-to-label =
    .label = Bestanden opslaan in
    .accesskey = o
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Kiezen…
           *[other] Bladeren…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] z
           *[other] a
        }
always-ask-label =
    .label = Mij altijd vragen waar bestanden moeten worden opgeslagen
    .accesskey = v
display-tags-text = Labels kunnen worden gebruikt voor het categoriseren en prioriteren van uw berichten.
new-tag-button =
    .label = Nieuw…
    .accesskey = N
edit-tag-button =
    .label = Bewerken…
    .accesskey = B
delete-tag-button =
    .label = Verwijderen
    .accesskey = V
auto-mark-as-read =
    .label = Berichten automatisch als gelezen markeren
    .accesskey = B
mark-read-no-delay =
    .label = Direct bij weergeven
    .accesskey = D

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Na
    .accesskey = N
seconds-label = seconden weergeven

##

open-msg-label =
    .value = Nieuwe berichten openen in:
open-msg-tab =
    .label = Een nieuw tabblad
    .accesskey = t
open-msg-window =
    .label = Een nieuw berichtvenster
    .accesskey = i
open-msg-ex-window =
    .label = Een bestaand berichtvenster
    .accesskey = e
close-move-delete =
    .label = Berichtvenster/-tabblad sluiten bij verplaatsen of verwijderen
    .accesskey = s
display-name-label =
    .value = Weergavenaam:
condensed-addresses-label =
    .label = Van personen in mijn adresboek alleen weergavenaam tonen
    .accesskey = V

## Compose Tab

forward-label =
    .value = Berichten doorsturen:
    .accesskey = d
inline-label =
    .label = In het bericht
as-attachment-label =
    .label = Als bijlage
extension-label =
    .label = Extensie aan bestandsnaam toevoegen
    .accesskey = n

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Elke
    .accesskey = E
auto-save-end = minuten automatisch opslaan

##

warn-on-send-accel-key =
    .label = Bevestiging vragen bij het gebruik van sneltoets om bericht te verzenden
    .accesskey = B
spellcheck-label =
    .label = Spelling controleren voor het verzenden
    .accesskey = c
spellcheck-inline-label =
    .label = Spelling controleren tijdens het typen
    .accesskey = n
language-popup-label =
    .value = Taal:
    .accesskey = T
download-dictionaries-link = Meer woordenboeken downloaden
font-label =
    .value = Lettertype:
    .accesskey = L
font-size-label =
    .value = Grootte:
    .accesskey = G
default-colors-label =
    .label = Standaardkleuren van lezer gebruiken
    .accesskey = k
font-color-label =
    .value = Tekstkleur:
    .accesskey = T
bg-color-label =
    .value = Achtergrondkleur:
    .accesskey = A
restore-html-label =
    .label = Standaardwaarden herstellen
    .accesskey = S
default-format-label =
    .label = Standaard tekstopmaak Alinea gebruiken in plaats van Tekst
    .accesskey = r
format-description = Tekstopmaakgedrag configureren
send-options-label =
    .label = Verzendopties…
    .accesskey = V
autocomplete-description = Bij het adresseren van berichten, naar overeenkomsten zoeken in:
ab-label =
    .label = Lokale adresboeken
    .accesskey = L
directories-label =
    .label = Directoryserver:
    .accesskey = D
directories-none-label =
    .none = Geen
edit-directories-label =
    .label = Directory’s bewerken…
    .accesskey = b
email-picker-label =
    .label = E-mailadressen van uitgaande berichten automatisch toevoegen aan mijn:
    .accesskey = E
default-directory-label =
    .value = Standaard opstartmap in het adresboekvenster:
    .accesskey = S
default-last-label =
    .none = Laatst gebruikte map
attachment-label =
    .label = Controleren op ontbrekende bijlagen
    .accesskey = C
attachment-options-label =
    .label = Sleutelwoorden…
    .accesskey = w
enable-cloud-share =
    .label = Delen voorstellen bij bestanden groter dan
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = Toevoegen…
    .accesskey = T
    .defaultlabel = Toevoegen…
remove-cloud-account =
    .label = Verwijderen
    .accesskey = V
find-cloud-providers =
    .value = Meer providers zoeken…
cloud-account-description = Een nieuwe Filelink-opslagservice toevoegen

## Privacy Tab

mail-content = E-mailinhoud
remote-content-label =
    .label = Externe inhoud in berichten toestaan
    .accesskey = E
exceptions-button =
    .label = Uitzonderingen…
    .accesskey = U
remote-content-info =
    .value = Meer info over de privacyproblemen van externe inhoud
web-content = Webinhoud
history-label =
    .label = Websites en koppelingen die ik heb bezocht onthouden
    .accesskey = W
cookies-label =
    .label = Cookies van websites accepteren
    .accesskey = C
third-party-label =
    .value = Cookies van derden accepteren:
    .accesskey = o
third-party-always =
    .label = Altijd
third-party-never =
    .label = Nooit
third-party-visited =
    .label = Van bezochte
keep-label =
    .value = Bewaren totdat:
    .accesskey = B
keep-expire =
    .label = ze verlopen
keep-close =
    .label = ik { -brand-short-name } afsluit
keep-ask =
    .label = mij elke keer vragen
cookies-button =
    .label = Cookies tonen…
    .accesskey = t
do-not-track-label =
    .label = Websites een ‘Niet volgen’-signaal sturen om te laten weten dat u niet gevolgd wilt worden
    .accesskey = N
learn-button =
    .label = Meer info
passwords-description = { -brand-short-name } kan wachtwoordinformatie voor al uw accounts onthouden.
passwords-button =
    .label = Opgeslagen wachtwoorden…
    .accesskey = O
master-password-description = Een hoofdwachtwoord beveiligt al uw wachtwoorden, maar u moet het eens per sessie invoeren.
master-password-label =
    .label = Een hoofdwachtwoord gebruiken
    .accesskey = h
master-password-button =
    .label = Hoofdwachtwoord wijzigen…
    .accesskey = w
primary-password-description = Een hoofdwachtwoord beveiligt al uw wachtwoorden, maar u moet het eens per sessie invoeren.
primary-password-label =
    .label = Een hoofdwachtwoord gebruiken
    .accesskey = h
primary-password-button =
    .label = Hoofdwachtwoord wijzigen…
    .accesskey = w
forms-primary-pw-fips-title = U bent momenteel in FIPS-modus. FIPS vereist een ingesteld hoofdwachtwoord.
forms-master-pw-fips-desc = Wachtwoordwijziging mislukt
junk-description = Stel uw standaardinstellingen voor ongewensteberichtendetectie in. Accountspecifieke instellingen kunnen worden geconfigureerd in Accountinstellingen.
junk-label =
    .label = Wanneer ik berichten markeer als ongewenst:
    .accesskey = W
junk-move-label =
    .label = ze verplaatsen naar de map ‘Ongewenst’ van de account
    .accesskey = z
junk-delete-label =
    .label = ze verwijderen
    .accesskey = v
junk-read-label =
    .label = Berichten die zijn gedetecteerd als ongewenst, markeren als gelezen
    .accesskey = B
junk-log-label =
    .label = Logboek van zelflerend ongewensteberichtenfilter inschakelen
    .accesskey = o
junk-log-button =
    .label = Logboek tonen
    .accesskey = L
reset-junk-button =
    .label = Trainingsgegevens herinitialiseren
    .accesskey = T
phishing-description = { -brand-short-name } kan berichten analyseren op vermoedelijke e-mailscams door te kijken naar veelvoorkomende technieken die worden gebruikt om u te misleiden.
phishing-label =
    .label = Mij vertellen of het gelezen bericht een vermoedelijke e-mailscam is
    .accesskey = M
antivirus-description = { -brand-short-name } kan het antivirussoftware makkelijk maken om inkomende e-mailberichten op virussen te controleren voordat ze lokaal worden opgeslagen.
antivirus-label =
    .label = Antivirusprogramma’s toestaan om individuele inkomende berichten in quarantaine te plaatsen
    .accesskey = A
certificate-description = Wanneer een server om mijn persoonlijke certificaat vraagt:
certificate-auto =
    .label = Er automatisch een selecteren
    .accesskey = a
certificate-ask =
    .label = Mij elke keer vragen
    .accesskey = e
ocsp-label =
    .label = OCSP-responderservers vragen om de huidige geldigheid van certificaten te bevestigen
    .accesskey = v
certificate-button =
    .label = Certificaten beheren…
    .accesskey = C
security-devices-button =
    .label = Beveiligingsapparaten…
    .accesskey = B

## Chat Tab

startup-label =
    .value = Als { -brand-short-name } start:
    .accesskey = s
offline-label =
    .label = Mijn chataccounts offline houden
auto-connect-label =
    .label = Mijn chataccounts automatisch verbinden

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Mijn contacten na
    .accesskey = c
idle-time-label = minuten inactiviteit laten weten dat ik niet actief ben

##

away-message-label =
    .label = en mijn status op Afwezig instellen met dit statusbericht:
    .accesskey = A
send-typing-label =
    .label = Typemeldingen verzenden in conversaties
    .accesskey = T
notification-label = Als er aan u geadresseerde berichten binnenkomen:
show-notification-label =
    .label = Een melding tonen
    .accesskey = m
notification-all =
    .label = met naam van de afzender en voorbeeld van het bericht
notification-name =
    .label = met alleen de naam van de afzender
notification-empty =
    .label = zonder informatie
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Het programmasymbool bewegen
           *[other] Het taakbalkitem laten knipperen
        }
    .accesskey =
        { PLATFORM() ->
            [macos] r
           *[other] k
        }
chat-play-sound-label =
    .label = Een geluid afspelen
    .accesskey = u
chat-play-button =
    .label = Afspelen
    .accesskey = f
chat-system-sound-label =
    .label = Standaard systeemgeluid voor nieuwe e-mail
    .accesskey = d
chat-custom-sound-label =
    .label = Het volgende geluidsbestand gebruiken
    .accesskey = v
chat-browse-sound-button =
    .label = Bladeren…
    .accesskey = B
theme-label =
    .value = Thema:
    .accesskey = T
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Tekstballonnen
style-dark =
    .label = Donker
style-paper =
    .label = Vellen papier
style-simple =
    .label = Eenvoudig
preview-label = Voorbeeld:
no-preview-label = Geen voorbeeld beschikbaar
no-preview-description = Dit thema is ongeldig of momenteel niet beschikbaar (uitgeschakelde add-on, veilige modus, …).
chat-variant-label =
    .value = Variant:
    .accesskey = V
chat-header-label =
    .label = Kop tonen
    .accesskey = K
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
            [windows] In Opties zoeken
           *[other] In Voorkeuren zoeken
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
    .placeholder = Zoeken in Voorkeuren

## Preferences UI Search Results

search-results-header = Zoekresultaten
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Sorry! Er zijn geen resultaten in Opties voor ‘<span data-l10n-name="query"></span>’.
       *[other] Sorry! Er zijn geen resultaten in Voorkeuren voor ‘<span data-l10n-name="query"></span>’.
    }
search-results-help-link = Hulp nodig? Bezoek <a data-l10n-name="url">{ -brand-short-name } Ondersteuning</a>
