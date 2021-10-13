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

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

spotlight-public-wifi-vpn-header = Offenbar verwenden Sie öffentliches WLAN
spotlight-public-wifi-vpn-body = Um Ihren Standort und Ihre Surfaktivitäten zu verbergen, sollten Sie ein virtuelles privates Netzwerk in Betracht ziehen. Es schützt Sie beim Surfen an öffentlichen Orten wie Flughäfen und Cafés.
spotlight-public-wifi-vpn-primary-button = Schützen Sie Ihre Privatsphäre mit { -mozilla-vpn-brand-name }
    .accesskey = P
spotlight-public-wifi-vpn-link = Nicht jetzt
    .accesskey = N
