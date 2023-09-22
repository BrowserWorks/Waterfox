# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Empfohlene Erweiterung
cfr-doorhanger-feature-heading = Empfohlene Funktion

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Warum wird das angezeigt?

cfr-doorhanger-extension-cancel-button = Nicht jetzt
    .accesskey = N

cfr-doorhanger-extension-ok-button = Jetzt hinzufügen
    .accesskey = h

cfr-doorhanger-extension-manage-settings-button = Einstellungen für Empfehlungen verwalten
    .accesskey = E

cfr-doorhanger-extension-never-show-recommendation = Diese Empfehlung nicht anzeigen
    .accesskey = D

cfr-doorhanger-extension-learn-more-link = Weitere Informationen

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = von { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Empfehlung
cfr-doorhanger-extension-notification2 = Empfehlung
    .tooltiptext = Erweiterungsempfehlung
    .a11y-announcement = Erweiterungsempfehlung verfügbar

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Empfehlung
    .tooltiptext = Funktionsempfehlung
    .a11y-announcement = Funktionsempfehlung verfügbar

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } Stern
           *[other] { $total } Sterne
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } Benutzer
       *[other] { $total } Benutzer
    }

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synchronisieren Sie Ihre Lesezeichen, um sie überall verfügbar zu haben.
cfr-doorhanger-bookmark-fxa-body = Jederzeit Zugriff auf dieses Lesezeichen - auch auf mobilen Geräten. Nutzen Sie dafür ein { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Lesezeichen jetzt synchronisieren…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Schließen-Schaltfläche
    .title = Schließen

## Protections panel

cfr-protections-panel-header = Surfen ohne verfolgt zu werden
cfr-protections-panel-body = Behalten Sie die Kontrolle über Ihre Daten. { -brand-short-name } schützt Sie vor den verbreitetsten Skripten, welche Ihre Online-Aktivitäten verfolgen.
cfr-protections-panel-link-text = Weitere Informationen

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Neue Funktion:

cfr-whatsnew-button =
    .label = Neue Funktionen und Änderungen
    .tooltiptext = Neue Funktionen und Änderungen

cfr-whatsnew-release-notes-link-text = Release Notes lesen

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] { -brand-short-name } hat seit { DATETIME($date, month: "long", year: "numeric") } mehr als <b>{ $blockedCount }</b> Element zur Aktivitätenverfolgung blockiert!
       *[other] { -brand-short-name } hat seit { DATETIME($date, month: "long", year: "numeric") } mehr als <b>{ $blockedCount }</b> Elemente zur Aktivitätenverfolgung blockiert!
    }
cfr-doorhanger-milestone-ok-button = Alle anzeigen
    .accesskey = A
cfr-doorhanger-milestone-close-button = Schließen
    .accesskey = c

## DOH Message

cfr-doorhanger-doh-body = Ihre Privatsphäre ist uns wichtig. { -brand-short-name } leitet Ihre DNS-Anfragen jetzt falls möglich sicher an einen Partnerdienst weiter, um Sie beim Surfen zu schützen.
cfr-doorhanger-doh-header = Sicherere, verschlüsselte DNS-Anfragen
cfr-doorhanger-doh-primary-button-2 = OK
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Deaktivieren
    .accesskey = D

## Fission Experiment Message

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Videos auf dieser Website werden in dieser Version von { -brand-short-name } möglicherweise nicht richtig wiedergegeben. Aktualisieren Sie { -brand-short-name } jetzt für volle Videounterstützung.
cfr-doorhanger-video-support-header = { -brand-short-name } aktualisieren, um Videos abzuspielen
cfr-doorhanger-video-support-primary-button = Jetzt aktualisieren
    .accesskey = a

## Spotlight modal shared strings

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the BrowserWorks VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Offenbar verwenden Sie öffentliches WLAN
spotlight-public-wifi-vpn-body = Um Ihren Standort und Ihre Surfaktivitäten zu verbergen, sollten Sie ein virtuelles privates Netzwerk in Betracht ziehen. Es schützt Sie beim Surfen an öffentlichen Orten wie Flughäfen und Cafés.
spotlight-public-wifi-vpn-primary-button = Schützen Sie Ihre Privatsphäre mit { -mozilla-vpn-brand-name }
    .accesskey = P
spotlight-public-wifi-vpn-link = Nicht jetzt
    .accesskey = N

## Total Cookie Protection Rollout

## Emotive Continuous Onboarding

spotlight-better-internet-header = Ein besseres Internet fängt bei Ihnen an
spotlight-better-internet-body = Wenn Sie { -brand-short-name } verwenden, stimmen Sie für ein offenes und zugängliches Internet, welches für jeden von uns von Vorteil ist.
spotlight-peace-mind-header = Wir haben für Sie vorgesorgt
spotlight-peace-mind-body = { -brand-short-name } blockiert jeden Monat durchschnittlich über 3.000 Elemente zur Aktivitätenverfolgung pro Nutzer. Denn nichts, besonders nicht Störer der Privatsphäre wie Elemente zur Aktivitätenverfolgung, sollte zwischen Ihnen und dem guten Internet stehen.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Im Dock behalten
       *[other] An Taskleiste anheften
    }
spotlight-pin-secondary-button = Nicht jetzt

## MR2022 Background Update Windows native toast notification strings.
##
## These strings will be displayed by the Windows operating system in
## a native toast, like:
##
## <b>multi-line title</b>
## multi-line text
## <img>
## [ primary button ] [ secondary button ]
##
## The button labels are fitted into narrow fixed-width buttons by
## Windows and therefore must be as narrow as possible.

mr2022-background-update-toast-title = Neuer { -brand-short-name }. Mehr Privatsphäre. Weniger Tracker. Keine Kompromisse.
mr2022-background-update-toast-text = Testen Sie jetzt den neuesten { -brand-short-name }, aktualisiert mit unserem bisher stärksten Anti-Tracking-Schutz.

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it
# using a variable font like Arial): the button can only fit 1-2
# additional characters, exceeding characters will be truncated.
mr2022-background-update-toast-primary-button-label = { -brand-shorter-name } jetzt öffnen

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it using a
# variable font like Arial): the button can only fit 1-2 additional characters,
# exceeding characters will be truncated.
mr2022-background-update-toast-secondary-button-label = Später erinnern

## Waterfox View CFR

firefoxview-cfr-primarybutton = Ausprobieren
    .accesskey = A
firefoxview-cfr-secondarybutton = Nicht jetzt
    .accesskey = N
firefoxview-cfr-header-v2 = Machen Sie schnell da weiter, wo Sie aufgehört haben
firefoxview-cfr-body-v2 = Holen Sie sich kürzlich geschlossene Tabs zurück und wechseln Sie nahtlos zwischen Geräten mit { -firefoxview-brand-name }.

## Waterfox View Spotlight

firefoxview-spotlight-promo-title = Begrüßen Sie { -firefoxview-brand-name }

# “Poof” refers to the expression to convey when something or someone suddenly disappears, or in this case, reappears. For example, “Poof, it’s gone.”
firefoxview-spotlight-promo-subtitle = Möchten Sie diesen offenen Tab auf Ihrem Telefon? Nehmen Sie ihn. Brauchen Sie diese Website, die Sie gerade besucht haben? Schon ist sie wieder da mit { -firefoxview-brand-name }.
firefoxview-spotlight-promo-primarybutton = Wie es funktioniert
firefoxview-spotlight-promo-secondarybutton = Überspringen

## Colorways expiry reminder CFR

colorways-cfr-primarybutton = Farbwelt wählen
    .accesskey = w

# "shades" refers to the different color options available to users in colorways.
colorways-cfr-body = Färben Sie Ihren Browser mit exklusiven Farbtönen von { -brand-short-name }, die von Stimmen inspiriert sind, die die Kultur verändert haben.
colorways-cfr-header-28days = Farbwelten "Unabhängige Stimmen" laufen am 16. Januar ab
colorways-cfr-header-14days = Farbwelten "Unabhängige Stimmen" laufen in zwei Wochen ab
colorways-cfr-header-7days = Farbwelten "Unabhängige Stimmen" laufen diese Woche ab
colorways-cfr-header-today = Farbwelten "Unabhängige Stimmen" laufen heute ab

## Cookie Banner Handling CFR

cfr-cbh-header = { -brand-short-name } erlauben, Cookie-Banner abzulehnen?
cfr-cbh-body = { -brand-short-name } kann viele Cookie-Banner-Anfragen automatisch ablehnen.
cfr-cbh-confirm-button = Cookie-Banner ablehnen
    .accesskey = a
cfr-cbh-dismiss-button = Nicht jetzt
    .accesskey = N

## These strings are used in the Fox doodle Pin/set default spotlights

july-jam-headline = Wir haben für Sie vorgesorgt
july-jam-body = Jeden Monat blockiert { -brand-short-name } durchschnittlich mehr als 3000 Tracker pro Nutzer und ermöglicht so einen sicheren, schnellen Zugriff auf das gute Internet.
july-jam-set-default-primary = Meine Links mit { -brand-short-name } öffnen
fox-doodle-pin-headline = Willkommen zurück

# “indie” is short for the term “independent”.
# In this instance, free from outside influence or control.
fox-doodle-pin-body = Hier ist eine kurze Erinnerung, dass Sie Ihren unabhängigen Lieblings-Browser in Klickweite haben können.
fox-doodle-pin-primary = Meine Links mit { -brand-short-name } öffnen
fox-doodle-pin-secondary = Nicht jetzt

## These strings are used in the Set Waterfox as Default PDF Handler for Existing Users experiment

set-default-pdf-handler-headline = <strong>Ihre PDFs werden jetzt in { -brand-short-name } geöffnet.</strong> Bearbeiten oder unterschreiben Sie Formulare direkt in Ihrem Browser. Zum Ändern suchen Sie in den Einstellungen nach "PDF".
set-default-pdf-handler-primary = OK

## FxA sync CFR

fxa-sync-cfr-header = Planen Sie die Anschaffung eines neuen Geräts?
fxa-sync-cfr-body = Stellen Sie sicher, dass Sie Ihre neuesten Lesezeichen, Passwörter und Tabs immer dabei haben, wenn Sie einen neuen { -brand-product-name }-Browser öffnen.
fxa-sync-cfr-primary = Weitere Informationen
    .accesskey = W
fxa-sync-cfr-secondary = Später erinnern
    .accesskey = S

## Device Migration FxA Spotlight

device-migration-fxa-spotlight-header = Verwenden Sie ein älteres Gerät?
device-migration-fxa-spotlight-body = Sichern Sie Ihre Daten, um wichtige Informationen wie Lesezeichen und Passwörter nicht zu verlieren – insbesondere, wenn Sie zu einem neuen Gerät wechseln.
device-migration-fxa-spotlight-primary-button = Wie die Datensicherung funktioniert
device-migration-fxa-spotlight-link = Später erinnern
