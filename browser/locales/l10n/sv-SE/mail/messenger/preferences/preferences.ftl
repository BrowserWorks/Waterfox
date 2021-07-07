# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Stäng
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Inställningar
           *[other] Inställningar
        }
preferences-tab-title =
    .title = Inställningar
preferences-doc-title = Inställningar
category-list =
    .aria-label = Kategorier
pane-general-title = Allmänt
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = Skriva
category-compose =
    .tooltiptext = Skriva
pane-privacy-title = Sekretess & säkerhet
category-privacy =
    .tooltiptext = Sekretess & säkerhet
pane-chat-title = Chatt
category-chat =
    .tooltiptext = Chatt
pane-calendar-title = Kalender
category-calendar =
    .tooltiptext = Kalender
general-language-and-appearance-header = Språk & utseende
general-incoming-mail-header = Inkommande e-post
general-files-and-attachment-header = Filer & bilagor
general-tags-header = Etiketter
general-reading-and-display-header = Läsning & visning
general-updates-header = Uppdateringar
general-network-and-diskspace-header = Nätverk & diskutrymme
general-indexing-label = Indexering
composition-category-header = Skriva meddelande
composition-attachments-header = Bilagor
composition-spelling-title = Stavning
compose-html-style-title = HTML-stil
composition-addressing-header = Adressering
privacy-main-header = Sekretess
privacy-passwords-header = Lösenord
privacy-junk-header = Skräp
collection-header = { -brand-short-name } Datainsamling och användning
collection-description = Vi strävar alltid efter att ge dig val och samlar endast in vad vi behöver för tillhandahålla och förbättra { -brand-short-name } för alla. Vi ber alltid om tillåtelse innan vi tar emot personliga uppgifter.
collection-privacy-notice = Sekretesspolicy
collection-health-report-telemetry-disabled = Du tillåter inte längre { -vendor-short-name } att fånga in tekniska data och interaktionsdata. Alla tidigare data kommer att raderas inom 30 dagar.
collection-health-report-telemetry-disabled-link = Läs mer
collection-health-report =
    .label = Tillåt { -brand-short-name } att automatiskt skicka teknisk och interaktionsdata till { -vendor-short-name }
    .accesskey = T
collection-health-report-link = Läs mer
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Datarapportering är inaktiverad för denna byggkonfiguration
collection-backlogged-crash-reports =
    .label = Tillåt { -brand-short-name } att skicka eftersläpande kraschrapporter för din räkning
    .accesskey = T
collection-backlogged-crash-reports-link = Läs mer
privacy-security-header = Säkerhet
privacy-scam-detection-title = Bluffdetektering
privacy-anti-virus-title = Antivirus
privacy-certificates-title = Certifikat
chat-pane-header = Chatt
chat-status-title = Status
chat-notifications-title = Aviseringar
chat-pane-styling-header = Formatering
choose-messenger-language-description = Välj språk som används för att visa menyer, meddelanden och aviseringar från { -brand-short-name }.
manage-messenger-languages-button =
    .label = Ange alternativ...
    .accesskey = A
confirm-messenger-language-change-description = Starta om { -brand-short-name } för att tillämpa ändringarna
confirm-messenger-language-change-button = Tillämpa och starta om
update-setting-write-failure-title = Det gick inte att spara uppdateringsinställningar
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } stötte på ett fel och lagrade inte den här ändringen. Observera att ange denna uppdateringsinställning kräver tillstånd att skriva till filen nedan. Du eller en systemadministratör kan eventuellt lösa felet genom att ge användargruppen fullständig kontroll till den här filen.
    
    Kunde inte skriva till fil: { $path }
update-in-progress-title = Uppdatering pågår
update-in-progress-message = Vill du att { -brand-short-name } ska fortsätta med denna uppdatering?
update-in-progress-ok-button = &Ignorera
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Fortsätt
addons-button = Tillägg & teman
account-button = Kontoinställningar
open-addons-sidebar-button = Tillägg och teman

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Om du vill skapa ett huvudlösenord anger du dina inloggningsuppgifter för Windows. Detta skyddar dina kontons säkerhet.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = skapa ett huvudlösenord
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Om du vill skapa ett huvudlösenord anger du dina inloggningsuppgifter för Windows. Detta skyddar dina kontons säkerhet.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = skapa ett huvudlösenord
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend = { -brand-short-name } startsida
start-page-label =
    .label = Visa startsidan i förhandsgranskningen när { -brand-short-name } startar
    .accesskey = ö
location-label =
    .value = Adress:
    .accesskey = A
restore-default-label =
    .label = Återställ standard
    .accesskey = Å
default-search-engine = Standardsökmotor
add-search-engine =
    .label = Lägg till från fil
    .accesskey = L
remove-search-engine =
    .label = Ta bort
    .accesskey = T
minimize-to-tray-label =
    .label = När { -brand-short-name } minimeras, flytta den till aktivitetsfält
    .accesskey = m
new-message-arrival = När ny e-post kommer:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Spela upp följande ljudfil:
           *[other] Spela ett ljud
        }
    .accesskey = d
mail-play-button =
    .label = Spela upp
    .accesskey = e
change-dock-icon = Ändra inställningar för programsymbol
app-icon-options =
    .label = Alternativ för programsymbol…
    .accesskey = n
notification-settings = Varningar och standardljud kan stängas av aviseringsfältet i Systeminställningar.
animated-alert-label =
    .label = Visa en meddelanderuta
    .accesskey = V
customize-alert-label =
    .label = Anpassa…
    .accesskey = n
tray-icon-label =
    .label = Visa en ikon i aktivitetsfältet
    .accesskey = a
biff-use-system-alert =
    .label = Använd systemavisering
tray-icon-unread-label =
    .label = Visa en ikon i aktivitetsfältet för olästa meddelanden
    .accesskey = a
tray-icon-unread-description = Rekommenderas när du använder små knappar i aktivitetsfältet
mail-system-sound-label =
    .label = Systemets standardljud för ny e-post
    .accesskey = S
mail-custom-sound-label =
    .label = Använd följande ljudfil
    .accesskey = d
mail-browse-sound-button =
    .label = Bläddra…
    .accesskey = B
enable-gloda-search-label =
    .label = Aktivera global sökning och indexering
    .accesskey = A
datetime-formatting-legend = Formatering av datum och tid
language-selector-legend = Språk
allow-hw-accel =
    .label = Använd hårdvaruacceleration när det finns
    .accesskey = h
store-type-label =
    .value = Lagringstyp för meddelande i nya konton:
    .accesskey = t
mbox-store-label =
    .label = Fil per mapp (mbox)
maildir-store-label =
    .label = Fil per meddelande (maildir)
scrolling-legend = Scrollning
autoscroll-label =
    .label = Använd automatisk scrollning
    .accesskey = u
smooth-scrolling-label =
    .label = Använd mjuk scrollning
    .accesskey = m
system-integration-legend = Systemintegration
always-check-default =
    .label = Kontrollera vid start om { -brand-short-name } är standardklient för e-post
    .accesskey = o
check-default-button =
    .label = Kontrollera nu…
    .accesskey = n
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Sök
       *[other] { "" }
    }
search-integration-label =
    .label = Låt { search-engine-name } söka igenom meddelanden
    .accesskey = L
config-editor-button =
    .label = Konfigurationsredigerare…
    .accesskey = K
return-receipts-description = Ange hur { -brand-short-name } ska hantera mottagningskvitto
return-receipts-button =
    .label = Mottagningskvitton…
    .accesskey = M
update-app-legend = { -brand-short-name } uppdateringar
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Version { $version }
allow-description = Tillåt { -brand-short-name } att
automatic-updates-label =
    .label = Installera uppdateringar automatiskt (rekommenderas: förbättrad säkerhet)
    .accesskey = I
check-updates-label =
    .label = Sök efter uppdateringar, men låt mig välja om de ska installeras
    .accesskey = S
update-history-button =
    .label = Visa uppdateringshistorik
    .accesskey = h
use-service =
    .label = Använd en bakgrundstjänst för att installera uppdateringar
    .accesskey = b
cross-user-udpate-warning = Den här inställningen gäller för alla Windows-konton och { -brand-short-name } profiler som använder den här installationen av { -brand-short-name }.
networking-legend = Anslutning
proxy-config-description = Ange hur { -brand-short-name } ansluter till Internet
network-settings-button =
    .label = Inställningar…
    .accesskey = I
offline-legend = Nedkopplat läge
offline-settings = Ange inställningar för nedkopplat läge
offline-settings-button =
    .label = Nedkopplat läge…
    .accesskey = N
diskspace-legend = Diskutrymme
offline-compact-folder =
    .label = Komprimera alla mappar när det kommer spara över
    .accesskey = K
compact-folder-size =
    .value = MB totalt

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Använd upp till
    .accesskey = A
use-cache-after = MB utrymme för cachen

##

smart-cache-label =
    .label = Åsidosätt automatisk cachehantering
    .accesskey = s
clear-cache-button =
    .label = Rensa nu
    .accesskey = R
fonts-legend = Teckensnitt & färger
default-font-label =
    .value = Standardteckensnitt:
    .accesskey = d
default-size-label =
    .value = Storlek:
    .accesskey = S
font-options-button =
    .label = Avancerat…
    .accesskey = A
color-options-button =
    .label = Färger…
    .accesskey = F
display-width-legend = Oformaterade meddelanden
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Visa smilisar (gubbar som uttrycker känslor).
    .accesskey = m
display-text-label = Vid visning av citerade oformaterade meddelanden:
style-label =
    .value = Stil:
    .accesskey = S
regular-style-item =
    .label = Normal
bold-style-item =
    .label = Fet
italic-style-item =
    .label = Kursiv
bold-italic-style-item =
    .label = Fet kursiv
size-label =
    .value = Storlek:
    .accesskey = o
regular-size-item =
    .label = Normal
bigger-size-item =
    .label = Större
smaller-size-item =
    .label = Mindre
quoted-text-color =
    .label = Färg:
    .accesskey = F
search-input =
    .placeholder = Sök
search-handler-table =
    .placeholder = Filtrera innehållstyper och åtgärder
type-column-label =
    .label = Typ av innehåll
    .accesskey = T
action-column-label =
    .label = Åtgärd
    .accesskey = Å
save-to-label =
    .label = Spara filer till
    .accesskey = S
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Välj…
           *[other] Bläddra…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] V
           *[other] B
        }
always-ask-label =
    .label = Fråga alltid var jag vill spara filerna
    .accesskey = F
display-tags-text = Etiketter kan användas för att kategorisera och prioritera meddelanden.
new-tag-button =
    .label = Ny…
    .accesskey = N
edit-tag-button =
    .label = Redigera…
    .accesskey = R
delete-tag-button =
    .label = Ta bort
    .accesskey = T
auto-mark-as-read =
    .label = Märk automatiskt meddelanden som lästa
    .accesskey = M
mark-read-no-delay =
    .label = Omedelbart vid visning
    .accesskey = O

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Efter att ha visats i
    .accesskey = E
seconds-label = sekunder

##

open-msg-label =
    .value = Öppna meddelanden i:
open-msg-tab =
    .label = en ny flik
    .accesskey = n
open-msg-window =
    .label = ett nytt fönster
    .accesskey = e
open-msg-ex-window =
    .label = befintligt fönster
    .accesskey = b
close-move-delete =
    .label = Stäng meddelandefönstret/fliken vid flyttning eller borttagning
    .accesskey = S
display-name-label =
    .value = Visningsnamn:
condensed-addresses-label =
    .label = Visa endast kortnamn för personer som finns i adressboken
    .accesskey = V

## Compose Tab

forward-label =
    .value = Vidarebefordra meddelanden:
    .accesskey = V
inline-label =
    .label = Infogade
as-attachment-label =
    .label = Bifogade
extension-label =
    .label = med ett filnamnstillägg
    .accesskey = m

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Autospara var
    .accesskey = u
auto-save-end = minut

##

warn-on-send-accel-key =
    .label = Bekräfta när du skickar meddelanden med tangentbordskommando
    .accesskey = ä
spellcheck-label =
    .label = Kontrollera stavningen innan meddelanden skickas
    .accesskey = K
spellcheck-inline-label =
    .label = Använd automatisk stavningskontroll
    .accesskey = A
language-popup-label =
    .value = Språk:
    .accesskey = S
download-dictionaries-link = Hämta fler ordlistor
font-label =
    .value = Teckensnitt:
    .accesskey = T
font-size-label =
    .value = Storlek:
    .accesskey = S
default-colors-label =
    .label = Använd läsarens standardfärger
    .accesskey = d
font-color-label =
    .value = Textfärg:
    .accesskey = x
bg-color-label =
    .value = Bakgrundsfärg:
    .accesskey = B
restore-html-label =
    .label = Återställ standard
    .accesskey = Å
default-format-label =
    .label = Använd styckeformat istället för brödtext som standard
    .accesskey = t
format-description = Anpassa valet av textformat:
send-options-label =
    .label = Anpassa…
    .accesskey = A
autocomplete-description = Vid adressering av meddelanden, sök efter matchande e-postadresser i:
ab-label =
    .label = Lokala adressböcker
    .accesskey = L
directories-label =
    .label = Katalogserver:
    .accesskey = K
directories-none-label =
    .none = Ingen
edit-directories-label =
    .label = Redigera kataloger…
    .accesskey = R
email-picker-label =
    .label = Spara automatiskt utgående e-postadresser i:
    .accesskey = S
default-directory-label =
    .value = Standardstartkatalog i adressboksfönstret:
    .accesskey = S
default-last-label =
    .none = Senast använda katalog
attachment-label =
    .label = Kontrollera om bilagor saknas
    .accesskey = K
attachment-options-label =
    .label = Nyckelord…
    .accesskey = N
enable-cloud-share =
    .label = Erbjuder dig att dela filer större än
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = Lägg till…
    .accesskey = L
    .defaultlabel = Lägg till…
remove-cloud-account =
    .label = Ta bort
    .accesskey = T
find-cloud-providers =
    .value = Hitta fler leverantörer…
cloud-account-description = Lägg till en ny Filelink lagringstjänst

## Privacy Tab

mail-content = E-postinnehåll
remote-content-label =
    .label = Tillåt fjärrinnehåll i meddelanden
    .accesskey = T
exceptions-button =
    .label = Undantag…
    .accesskey = U
remote-content-info =
    .value = Läs mer om integritetsfrågor för fjärrinnehåll
web-content = Webbinnehåll
history-label =
    .label = Kom ihåg webbplatser och länkar som jag har besökt
    .accesskey = K
cookies-label =
    .label = Tillåt kakor från webbplatser
    .accesskey = T
third-party-label =
    .value = Tillåt tredjepartskakor:
    .accesskey = r
third-party-always =
    .label = Alltid
third-party-never =
    .label = Aldrig
third-party-visited =
    .label = Från besökta
keep-label =
    .value = Behålls tills:
    .accesskey = B
keep-expire =
    .label = de förfaller
keep-close =
    .label = { -brand-short-name } stängs
keep-ask =
    .label = fråga mig varje gång
cookies-button =
    .label = Visa kakor…
    .accesskey = V
do-not-track-label =
    .label = Skicka webbplatser en “Spåra inte”-signal att du inte vill bli spårad
    .accesskey = n
learn-button =
    .label = Läs mer
passwords-description = { -brand-short-name } kan spara lösenord för alla dina konton.
passwords-button =
    .label = Sparade lösenord…
    .accesskey = S
master-password-description = Ett huvudlösenord skyddar alla dina lösenord, men du måste ange det en gång per session.
master-password-label =
    .label = Använd ett huvudlösenord
    .accesskey = A
master-password-button =
    .label = Byt huvudlösenord…
    .accesskey = h
primary-password-description = Ett huvudlösenord skyddar alla dina lösenord, men du måste ange det en gång per session.
primary-password-label =
    .label = Använd ett huvudlösenord
    .accesskey = A
primary-password-button =
    .label = Ändra huvudlösenord…
    .accesskey = n
forms-primary-pw-fips-title = Du är för närvarande i FIPS-läge. FIPS kräver ett huvudlösenord.
forms-master-pw-fips-desc = Ändring av lösenordet misslyckades
junk-description = Ange inställningar för skräpposthantering. Kontospecifika skräppostinställningar kan göras i Kontoinställningar.
junk-label =
    .label = När jag märker meddelanden som skräppost:
    .accesskey = N
junk-move-label =
    .label = Flytta dem till kontots ”Skräp”-mapp
    .accesskey = F
junk-delete-label =
    .label = Ta bort dem
    .accesskey = T
junk-read-label =
    .label = Märk skräpklassade meddelanden som lästa
    .accesskey = M
junk-log-label =
    .label = Aktivera loggning av skräppostfiltret
    .accesskey = A
junk-log-button =
    .label = Visa logg
    .accesskey = V
reset-junk-button =
    .label = Återställ träningsdata
    .accesskey = Å
phishing-description = { -brand-short-name } kan granska meddelanden efter misstänkta e-postbluffar genom att leta efter vanliga knep som används för att lura dig.
phishing-label =
    .label = Varna mig om meddelandet jag läser är en misstänkt e-postbluff
    .accesskey = V
antivirus-description = { -brand-short-name } kan göra det lätt för antivirusprogram att granska inkommande e-postmeddelanden innan de sparas lokalt.
antivirus-label =
    .label = Låt antivirusprogram sätta inkommande meddelanden i karantän
    .accesskey = L
certificate-description = När en server efterfrågar mitt personliga certifikat:
certificate-auto =
    .label = Välj ett automatiskt
    .accesskey = a
certificate-ask =
    .label = Fråga varje gång
    .accesskey = F
ocsp-label =
    .label = Använd OCSP-mekanism för att bekräfta giltigheten på certifikaten
    .accesskey = o
certificate-button =
    .label = Hantera certifikat…
    .accesskey = H
security-devices-button =
    .label = Säkerhetsenheter…
    .accesskey = k

## Chat Tab

startup-label =
    .value = När { -brand-short-name } startar:
    .accesskey = s
offline-label =
    .label = Håll mina chattkonton offline
auto-connect-label =
    .label = Anslut mina chattkonton automatiskt

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Låt mina kontakter veta att jag är Inaktiv efter
    .accesskey = I
idle-time-label = minuters inaktivitet

##

away-message-label =
    .label = och sätt min status till Borta med statusmeddelandet:
    .accesskey = B
send-typing-label =
    .label = Skicka skrivmeddelanden i konversationer
    .accesskey = k
notification-label = När meddelanden riktade till dig kommer:
show-notification-label =
    .label = Visa avisering
    .accesskey = V
notification-all =
    .label = med avsändarens namn och förhandsvisning
notification-name =
    .label = med avsändarens namn endast
notification-empty =
    .label = utan någon info
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animera dockikonen
           *[other] Blinka i aktivitetsfältet
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] B
        }
chat-play-sound-label =
    .label = Spela ett ljud
    .accesskey = d
chat-play-button =
    .label = Spela
    .accesskey = S
chat-system-sound-label =
    .label = Systemets standardljud för ny e-post
    .accesskey = D
chat-custom-sound-label =
    .label = Använd följande ljudfil
    .accesskey = A
chat-browse-sound-button =
    .label = Bläddra…
    .accesskey = B
theme-label =
    .value = Tema:
    .accesskey = T
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Bubblor
style-dark =
    .label = Mörkt
style-paper =
    .label = Pappersark
style-simple =
    .label = Enkelt
preview-label = Förhandsgranskning:
no-preview-label = Ingen förhandsgranskning tillgänglig
no-preview-description = Det här temat är inte giltigt eller är för närvarande inte tillgängligt (inaktivera tillägg, säkert läge, …).
chat-variant-label =
    .value = Variant:
    .accesskey = V
chat-header-label =
    .label = Visa rubrik
    .accesskey = r
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
            [windows] Sök i inställningar
           *[other] Sök i inställningar
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
    .placeholder = Sök i inställningar

## Preferences UI Search Results

search-results-header = Sökresultat
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Tyvärr! Det finns inga resultat i Inställningar för "<span data-l10n-name="query"></span>".
       *[other] Tyvärr! Det finns inga resultat i Inställningar för "<span data-l10n-name="query"></span>".
    }
search-results-help-link = Behöver du hjälp? <a data-l10n-name="url">{ -brand-short-name } supporten</a>
