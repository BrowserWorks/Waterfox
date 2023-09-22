# This Source Code Form is subject to the terms of the BrowserWorks Public
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

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Video’s op deze website worden mogelijk in deze versie van { -brand-short-name } niet correct afgespeeld. Werk { -brand-short-name } nu bij voor volledige video-ondersteuning.
cfr-doorhanger-video-support-header = Werk { -brand-short-name } bij om video af te spelen
cfr-doorhanger-video-support-primary-button = Nu bijwerken
    .accesskey = w

## Spotlight modal shared strings

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the BrowserWorks VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Het lijkt erop dat u openbare wifi gebruikt
spotlight-public-wifi-vpn-body = Overweeg een Virtual Private Network om uw locatie en surfactiviteit te verbergen. Het helpt u beschermd te blijven tijdens het navigeren op openbare plaatsen, zoals luchthavens en koffiebars.
spotlight-public-wifi-vpn-primary-button = Blijf privé met { -mozilla-vpn-brand-name }
    .accesskey = B
spotlight-public-wifi-vpn-link = Niet nu
    .accesskey = N

## Total Cookie Protection Rollout

## Emotive Continuous Onboarding

spotlight-better-internet-header = Een beter internet begint bij uzelf
spotlight-better-internet-body = Als u { -brand-short-name } gebruikt, stemt u voor een open en toegankelijk internet dat beter is voor iedereen.
spotlight-peace-mind-header = Bij ons bent u veilig
spotlight-peace-mind-body = Elke maand blokkeert { -brand-short-name } gemiddeld meer dan 3000 trackers per gebruiker. Want niets mag tussen u en het goede internet staan, vooral geen privacy-overlast zoals trackers.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] In de Dock houden
       *[other] Aan taakbalk vastzetten
    }
spotlight-pin-secondary-button = Niet nu

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

mr2022-background-update-toast-title = Nieuwe { -brand-short-name }. Meer privé. Minder trackers. Geen compromissen.
mr2022-background-update-toast-text = Probeer nu de nieuwste { -brand-short-name }, geüpgraded met onze krachtigste bescherming tegen volgen tot nu toe.

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it
# using a variable font like Arial): the button can only fit 1-2
# additional characters, exceeding characters will be truncated.
mr2022-background-update-toast-primary-button-label = { -brand-shorter-name } nu openen

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it using a
# variable font like Arial): the button can only fit 1-2 additional characters,
# exceeding characters will be truncated.
mr2022-background-update-toast-secondary-button-label = Later herinneren

## Waterfox View CFR

firefoxview-cfr-primarybutton = Uitproberen
    .accesskey = U
firefoxview-cfr-secondarybutton = Niet nu
    .accesskey = N
firefoxview-cfr-header-v2 = Ga snel verder waar u was gebleven
firefoxview-cfr-body-v2 = Ontvang onlangs gesloten tabbladen terug en schakel naadloos tussen apparaten met { -firefoxview-brand-name }.

## Waterfox View Spotlight

firefoxview-spotlight-promo-title = Zeg hallo tegen { -firefoxview-brand-name }

# “Poof” refers to the expression to convey when something or someone suddenly disappears, or in this case, reappears. For example, “Poof, it’s gone.”
firefoxview-spotlight-promo-subtitle = Behoefte aan dat open tabblad op uw telefoon? Pak het. Hebt u die website nodig die u net hebt bezocht? Poef, hij is terug met { -firefoxview-brand-name }.
firefoxview-spotlight-promo-primarybutton = Zien hoe het werkt
firefoxview-spotlight-promo-secondarybutton = Overslaan

## Colorways expiry reminder CFR

colorways-cfr-primarybutton = Kleurstelling kiezen
    .accesskey = k

# "shades" refers to the different color options available to users in colorways.
colorways-cfr-body = Kleur uw browser met voor { -brand-short-name } exclusieve tinten, geïnspireerd door stemmen die de cultuur hebben veranderd.
colorways-cfr-header-28days = Independent Voices-kleurstellingen verlopen op 16 januari
colorways-cfr-header-14days = Independent Voices-kleurstellingen verlopen over twee weken
colorways-cfr-header-7days = Independent Voices-kleurstellingen verlopen deze week
colorways-cfr-header-today = Independent Voices-kleurstellingen verlopen vandaag

## Cookie Banner Handling CFR

cfr-cbh-header = { -brand-short-name } toestaan om cookiebanners te weigeren?
cfr-cbh-body = { -brand-short-name } kan veel cookiebannerverzoeken automatisch weigeren.
cfr-cbh-confirm-button = Cookiebanners weigeren
    .accesskey = w
cfr-cbh-dismiss-button = Niet nu
    .accesskey = N

## These strings are used in the Fox doodle Pin/set default spotlights

july-jam-headline = Bij ons bent u veilig
july-jam-body = Elke maand blokkeert { -brand-short-name } gemiddeld meer dan 3.000 trackers per gebruiker, waardoor u veilig en snel toegang hebt tot het goede internet.
july-jam-set-default-primary = Mijn koppelingen openen met { -brand-short-name }
fox-doodle-pin-headline = Welkom terug

# “indie” is short for the term “independent”.
# In this instance, free from outside influence or control.
fox-doodle-pin-body = Dit is een korte herinnering dat u uw favoriete indiebrowser op slechts één klik afstand kunt houden.
fox-doodle-pin-primary = Mijn koppelingen openen met { -brand-short-name }
fox-doodle-pin-secondary = Niet nu

## These strings are used in the Set Waterfox as Default PDF Handler for Existing Users experiment

set-default-pdf-handler-headline = <strong>Uw PDF’s worden nu geopend in { -brand-short-name }.</strong> Bewerk of onderteken formulieren rechtstreeks in uw browser. Zoek naar ‘PDF’ in instellingen om te wijzigen.
set-default-pdf-handler-primary = Begrepen

## FxA sync CFR

fxa-sync-cfr-header = Nieuw apparaat in de toekomst?
fxa-sync-cfr-body = Zorg ervoor dat u uw nieuwste bladwijzers, wachtwoorden en tabbladen altijd bij de hand hebt wanneer u een nieuwe { -brand-product-name }-browser opent.
fxa-sync-cfr-primary = Meer info
    .accesskey = M
fxa-sync-cfr-secondary = Later herinneren
    .accesskey = L

## Device Migration FxA Spotlight

device-migration-fxa-spotlight-header = Gebruikt u een ouder apparaat?
device-migration-fxa-spotlight-body = Maak een back-up van uw gegevens om ervoor te zorgen dat u geen belangrijke informatie, zoals bladwijzers en wachtwoorden kwijtraakt, vooral als u overschakelt naar een nieuw apparaat.
device-migration-fxa-spotlight-primary-button = Hoe maak ik een back-up van mijn gegevens
device-migration-fxa-spotlight-link = Later herinneren
