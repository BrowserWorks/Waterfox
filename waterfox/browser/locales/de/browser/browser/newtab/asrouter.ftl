# This Source Code Form is subject to the terms of the Waterfox Public
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

cfr-doorhanger-fission-body-approved = Ihre Privatsphäre ist wichtig. { -brand-short-name } isoliert jetzt Websites voneinander, was es Hackern erschwert, Passwörter, Kreditkartendaten und andere vertrauliche Informationen zu stehlen.
cfr-doorhanger-fission-header = Seitenisolierung
cfr-doorhanger-fission-primary-button = Ok, verstanden
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Weitere Informationen
    .accesskey = W

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Videos auf dieser Website werden in dieser Version von { -brand-short-name } möglicherweise nicht richtig wiedergegeben. Aktualisieren Sie { -brand-short-name } jetzt für volle Videounterstützung.
cfr-doorhanger-video-support-header = { -brand-short-name } aktualisieren, um Videos abzuspielen
cfr-doorhanger-video-support-primary-button = Jetzt aktualisieren
    .accesskey = a

## Spotlight modal shared strings

spotlight-learn-more-collapsed = Weitere Informationen
    .title = Ausklappen, um mehr über die Funktion zu erfahren
spotlight-learn-more-expanded = Weitere Informationen
    .title = Schließen

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Offenbar verwenden Sie öffentliches WLAN
spotlight-public-wifi-vpn-body = Um Ihren Standort und Ihre Surfaktivitäten zu verbergen, sollten Sie ein virtuelles privates Netzwerk in Betracht ziehen. Es schützt Sie beim Surfen an öffentlichen Orten wie Flughäfen und Cafés.
spotlight-public-wifi-vpn-primary-button = Schützen Sie Ihre Privatsphäre mit { -mozilla-vpn-brand-name }
    .accesskey = P
spotlight-public-wifi-vpn-link = Nicht jetzt
    .accesskey = N

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header =
    Nutzen Sie vorab unsere leistungsstärkste
    Datenschutzerfahrung aller Zeiten
spotlight-total-cookie-protection-body = Der vollständige Cookie-Schutz hindert Elemente zur Aktivitätenverfolgung daran, Cookies zu verwenden, um Sie im Internet zu verfolgen.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = { -brand-short-name } baut einen Zaun um Cookies und beschränkt sie auf die Website, auf der Sie sich befinden, sodass Elemente zur Aktivitätenverfolgung sie nicht verwenden können, um Ihnen zu folgen. Durch die Vorab-Nutzung helfen Sie, diese Funktion zu optimieren, damit wir weiterhin ein besseres Web für alle aufbauen können.
spotlight-total-cookie-protection-primary-button = Vollständigen Cookie-Schutz aktivieren
spotlight-total-cookie-protection-secondary-button = Nicht jetzt
cfr-total-cookie-protection-header = Dank Ihnen ist { -brand-short-name } privater und sicherer denn je
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch". Only those who received it and accepted are shown this message.
cfr-total-cookie-protection-body = Der vollständige Cookie-Schutz ist unser bisher stärkster Datenschutz – und jetzt überall eine Standardeinstellung für { -brand-short-name }-Nutzer. Ohne Vorab-Nutzer wie Sie hätten wir das nicht geschafft. Vielen Dank, dass Sie uns dabei helfen, ein besseres, privateres Internet zu schaffen.

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
