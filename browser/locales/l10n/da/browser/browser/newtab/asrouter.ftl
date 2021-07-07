# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Anbefalet udvidelse
cfr-doorhanger-feature-heading = Anbefalet udvidelse

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Hvorfor får jeg vist dette?
cfr-doorhanger-extension-cancel-button = Ikke nu
    .accesskey = I
cfr-doorhanger-extension-ok-button = Tilføj nu
    .accesskey = T
cfr-doorhanger-extension-manage-settings-button = Håndter indstillinger for anbefalinger
    .accesskey = H
cfr-doorhanger-extension-never-show-recommendation = Vis ikke denne anbefaling
    .accesskey = V
cfr-doorhanger-extension-learn-more-link = Læs mere
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = af { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Anbefaling
cfr-doorhanger-extension-notification2 = Anbefaling
    .tooltiptext = Anbefalet udvidelse
    .a11y-announcement = Anbefalet udvidelse tilgængelig
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Anbefaling
    .tooltiptext = Anbefalet funktion
    .a11y-announcement = Anbefalet funktion tilgængelig

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } stjerne
           *[other] { $total } stjerner
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } bruger
       *[other] { $total } brugere
    }

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synkroniser dine bogmærker overalt.
cfr-doorhanger-bookmark-fxa-body = Vidste du, at du automatisk kan overføre nye bogmærker til din telefon eller tablet? Få en { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Synkroniser bogmærker nu…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Luk-knap
    .title = Luk

## Protections panel

cfr-protections-panel-header = Brug nettet uden at blive overvåget
cfr-protections-panel-body = Dine data tilhører dig. { -brand-short-name } beskytter dig mod mange af de mest almindelige sporings-teknologier, der følger med i, hvad du laver på nettet.
cfr-protections-panel-link-text = Læs mere

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Ny funktion:
cfr-whatsnew-button =
    .label = Nyheder
    .tooltiptext = Nyheder
cfr-whatsnew-release-notes-link-text = Læs udgivelsesnoterne

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } har blokeret flere end <b>{ $blockedCount }</b> sporings-mekanismer siden { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = Vis alle
    .accesskey = V
cfr-doorhanger-milestone-close-button = Luk
    .accesskey = L

## DOH Message

cfr-doorhanger-doh-body = Du har ret til et privatliv. { -brand-short-name } dirigerer nu så vidt muligt dine DNS-forespørgsler sikkert via en tjeneste leveret af en partner for at beskytte dig på nettet.
cfr-doorhanger-doh-header = Sikrere, krypterede DNS-opslag
cfr-doorhanger-doh-primary-button-2 = Okay
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Deaktiver
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Dit privatliv er vigtigt. { -brand-short-name } isolerer nu websteder fra hinanden, så det er sværere for hackere at stjæle dine adgangskoder, oplysninger om dine betalingskort og andre følsomme oplysninger.
cfr-doorhanger-fission-header = Websteds-isolering
cfr-doorhanger-fission-primary-button = Ok, forstået
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Læs mere
    .accesskey = L

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Videoer på dette websted afspilles måske ikke korrekt i denne version af { -brand-short-name }. Opdater { -brand-short-name } nu for fuld understøttelse af video.
cfr-doorhanger-video-support-header = Opdater { -brand-short-name } for at afspille video
cfr-doorhanger-video-support-primary-button = Opdater nu
    .accesskey = O

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

spotlight-public-wifi-vpn-header = Det ser ud til, at du bruger et offentligt wi-fi
spotlight-public-wifi-vpn-body = Overvej at bruge VPN (Virtuelt Privat Netværk) for at skjule din placering og din aktivitet på nettet. Det vil sørge for at beskytte dig, når du går på nettet via offentlige netværk, fx i lufthavne eller på caféer.
spotlight-public-wifi-vpn-primary-button = Beskyt dit privatliv med { -mozilla-vpn-brand-name }
    .accesskey = B
spotlight-public-wifi-vpn-link = Ikke nu
    .accesskey = k
