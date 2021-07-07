# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Rekommenderade tillägg
cfr-doorhanger-feature-heading = Rekommenderad funktion

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Varför ser jag detta

cfr-doorhanger-extension-cancel-button = Inte nu
    .accesskey = n

cfr-doorhanger-extension-ok-button = Lägg till nu
    .accesskey = L

cfr-doorhanger-extension-manage-settings-button = Hantera rekommendationsinställningar
    .accesskey = H

cfr-doorhanger-extension-never-show-recommendation = Visa mig inte denna rekommendation
    .accesskey = V

cfr-doorhanger-extension-learn-more-link = Läs mer

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = av { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Rekommendation
cfr-doorhanger-extension-notification2 = Rekommendation
    .tooltiptext = Rekommendation av tillägg
    .a11y-announcement = Rekommendation av tillägg tillgänglig

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Rekommendation
    .tooltiptext = Funktionsrekommendation
    .a11y-announcement = Funktionsrekommendation tillgänglig

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } stjärna
           *[other] { $total } stjärnor
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } användare
       *[other] { $total } användare
    }

## These messages are steps on how to use the feature and are shown together.

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synkronisera dina bokmärken överallt.
cfr-doorhanger-bookmark-fxa-body = Bra fynd! Saknar du bokmärket på dina mobila enheter. Kom igång med ett { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Synkronisera bokmärken nu...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Stäng knapp
    .title = Stäng

## Protections panel

cfr-protections-panel-header = Surfa utan att bli följd
cfr-protections-panel-body = Behåll dina data för dig själv. { -brand-short-name } skyddar dig från många av de vanligaste spårarna som följer vad du gör online.
cfr-protections-panel-link-text = Läs mer

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Ny funktion:

cfr-whatsnew-button =
    .label = Vad är nytt
    .tooltiptext = Vad är nytt

cfr-whatsnew-release-notes-link-text = Läs versionsfakta

## Search Bar

## Picture-in-Picture

## Permission Prompt

## Fingerprinter Counter

## Bookmark Sync

## Login Sync

## Send Tab

## Waterfox Send

## Social Tracking Protection

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] { -brand-short-name } blockerade <b>{ $blockedCount }</b> spårare sedan { DATETIME($date, month: "long", year: "numeric") }!
       *[other] { -brand-short-name } blockerade över <b>{ $blockedCount }</b> spårare sedan { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = Visa alla
    .accesskey = V

## What’s New Panel Content for Waterfox 76


## Lockwise message

## Vulnerable Passwords message

## Picture-in-Picture fullscreen message

## Protections Dashboard message

## Better PDF message

cfr-doorhanger-milestone-close-button = Stäng
    .accesskey = S

## DOH Message

cfr-doorhanger-doh-body = Din integritet är viktig. { -brand-short-name } dirigerar nu dina DNS-uppslag säkert, när det är möjligt, till en partnerservice för att skydda dig medan du surfar.
cfr-doorhanger-doh-header = Säkrare, krypterade DNS-uppslag
cfr-doorhanger-doh-primary-button-2 = Okej
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Inaktivera
    .accesskey = I

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Din integritet är viktig. { -brand-short-name } isolerar nu webbplatser från varandra, vilket gör det svårare för hackare att stjäla lösenord, kreditkortsnummer och annan känslig information.
cfr-doorhanger-fission-header = Webbplatsisolering
cfr-doorhanger-fission-primary-button = Ok, jag förstår
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Läs mer
    .accesskey = L

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Videor på den här webbplatsen kanske inte spelas upp korrekt i den här versionen av { -brand-short-name }. Uppdatera { -brand-short-name } nu för fullständig videosupport.
cfr-doorhanger-video-support-header = Uppdatera { -brand-short-name } för att spela upp video
cfr-doorhanger-video-support-primary-button = Uppdatera nu
    .accesskey = U

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

spotlight-public-wifi-vpn-header = Det verkar som om du använder ett offentligt Wi-Fi
spotlight-public-wifi-vpn-body = För att dölja din plats och surfaktivitet, överväg ett virtuellt privat nätverk. Det hjälper dig att skydda dig när du surfar på offentliga platser som flygplatser och kaféer.
spotlight-public-wifi-vpn-primary-button = Håll dig privat med { -mozilla-vpn-brand-name }
    .accesskey = p
spotlight-public-wifi-vpn-link = Inte nu
    .accesskey = I
