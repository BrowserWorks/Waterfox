# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Aanbevolen extensie
cfr-doorhanger-feature-heading = Aanbevolen functie

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Waarom zie ik dit?
cfr-doorhanger-extension-cancel-button = Niet nu
    .accesskey = N
cfr-doorhanger-extension-ok-button = Nu toevoegen
    .accesskey = t
cfr-doorhanger-extension-manage-settings-button = Instellingen voor aanbevelingen beheren
    .accesskey = I
cfr-doorhanger-extension-never-show-recommendation = Deze aanbeveling niet tonen
    .accesskey = D
cfr-doorhanger-extension-learn-more-link = Meer info
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = door { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Aanbeveling
cfr-doorhanger-extension-notification2 = Aanbeveling
    .tooltiptext = Aanbeveling voor extensie
    .a11y-announcement = Aanbeveling voor extensie beschikbaar
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Aanbeveling
    .tooltiptext = Aanbeveling voor functie
    .a11y-announcement = Aanbeveling voor functie beschikbaar

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } ster
           *[other] { $total } sterren
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } gebruiker
       *[other] { $total } gebruikers
    }

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synchroniseer uw bladwijzers overal.
cfr-doorhanger-bookmark-fxa-body = Goed gevonden! Zorg er nu voor dat u niet zonder bladwijzers zit op uw mobiele apparaten. Ga van start met { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Bladwijzers nu synchroniseren…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Knop Sluiten
    .title = Sluiten

## Protections panel

cfr-protections-panel-header = Surf zonder te worden gevolgd
cfr-protections-panel-body = Houd uw gegevens voor uzelf. { -brand-short-name } beschermt u tegen veel van de meest voorkomende trackers die volgen wat u online doet.
cfr-protections-panel-link-text = Meer info

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nieuwe functie:
cfr-whatsnew-button =
    .label = Wat is er nieuw
    .tooltiptext = Wat is er nieuw
cfr-whatsnew-release-notes-link-text = Uitgaveopmerkingen lezen

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] { -brand-short-name } heeft sinds { DATETIME($date, month: "long", year: "numeric") } b>{ $blockedCount }</b> tracker geblokkeerd!
       *[other] { -brand-short-name } heeft sinds { DATETIME($date, month: "long", year: "numeric") } meer dan <b>{ $blockedCount }</b> trackers geblokkeerd!
    }
cfr-doorhanger-milestone-ok-button = Alles bekijken
    .accesskey = A
cfr-doorhanger-milestone-close-button = Sluiten
    .accesskey = S

## DOH Message

cfr-doorhanger-doh-body = Uw privacy is belangrijk. { -brand-short-name } leidt nu waar mogelijk uw DNS-verzoeken veilig naar een partnerservice om u te beschermen terwijl u surft.
cfr-doorhanger-doh-header = Veiligere, versleutelde DNS-lookups
cfr-doorhanger-doh-primary-button-2 = Oké
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Uitschakelen
    .accesskey = U

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Uw privacy is belangrijk. { -brand-short-name } isoleert, of sandboxt, websites nu van elkaar, waardoor het voor hackers moeilijker wordt om wachtwoorden, creditcardnummers en andere gevoelige informatie te stelen.
cfr-doorhanger-fission-header = Website-isolatie
cfr-doorhanger-fission-primary-button = OK, begrepen
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Meer info
    .accesskey = M

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Video’s op deze website worden mogelijk in deze versie van { -brand-short-name } niet correct afgespeeld. Werk { -brand-short-name } nu bij voor volledige video-ondersteuning.
cfr-doorhanger-video-support-header = Werk { -brand-short-name } bij om video af te spelen
cfr-doorhanger-video-support-primary-button = Nu bijwerken
    .accesskey = w

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

spotlight-public-wifi-vpn-header = Het lijkt erop dat u openbare wifi gebruikt
spotlight-public-wifi-vpn-body = Overweeg een Virtual Private Network om uw locatie en surfactiviteit te verbergen. Het helpt u beschermd te blijven tijdens het navigeren op openbare plaatsen, zoals luchthavens en koffiebars.
spotlight-public-wifi-vpn-primary-button = Blijf privé met { -mozilla-vpn-brand-name }
    .accesskey = B
spotlight-public-wifi-vpn-link = Niet nu
    .accesskey = N
