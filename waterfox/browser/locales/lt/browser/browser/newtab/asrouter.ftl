# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Rekomenduojamas priedas
cfr-doorhanger-feature-heading = Rekomenduojama funkcija

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Kodėl tai matau

cfr-doorhanger-extension-cancel-button = Ne dabar
    .accesskey = N

cfr-doorhanger-extension-ok-button = Pridėti dabar
    .accesskey = P

cfr-doorhanger-extension-manage-settings-button = Tvarkyti rekomendacijų nuostatas
    .accesskey = T

cfr-doorhanger-extension-never-show-recommendation = Nerodyti man šios rekomendacijos
    .accesskey = N

cfr-doorhanger-extension-learn-more-link = Sužinoti daugiau

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = sukūrė { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Rekomendacija
cfr-doorhanger-extension-notification2 = Rekomendacija
    .tooltiptext = Priedo rekomendacija
    .a11y-announcement = Siūloma priedo rekomendacija

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Rekomendacija
    .tooltiptext = Funkcijos rekomendacija
    .a11y-announcement = Siūloma funkcijos rekomendacija

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } žvaigždutė
            [few] { $total } žvaigždutės
           *[other] { $total } žvaigždučių
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } naudotojas
        [few] { $total } naudotojai
       *[other] { $total } naudotojų
    }

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sinchronizuokite adresyną visuose įrenginiuose.
cfr-doorhanger-bookmark-fxa-body = Puikus radinys! O kad nepasigestumėte šio įrašo kituose įrenginiuose, susikurkite „{ -fxaccount-brand-name }“ paskyrą.
cfr-doorhanger-bookmark-fxa-link-text = Sinchronizuoti adresyną dabar…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Užvėrimo mygtukas
    .title = Užverti

## Protections panel

cfr-protections-panel-header = Nebūkite stebimi naršant
cfr-protections-panel-body = Jūsų duomenys skirti tik jums. „{ -brand-short-name }“ saugo jus nuo daugelio dažniausių stebėjimo elementų, stebinčių jūsų veiklą internete.
cfr-protections-panel-link-text = Sužinoti daugiau

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Naujovė:

cfr-whatsnew-button =
    .label = Kas naujo
    .tooltiptext = Kas naujo

cfr-whatsnew-release-notes-link-text = Skaityti laidos apžvalgą

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] Nuo { DATETIME($date, month: "long", year: "numeric") } „{ -brand-short-name }“ užblokavo virš <b>{ $blockedCount }</b> stebėjimo elemento!
        [few] Nuo { DATETIME($date, month: "long", year: "numeric") } „{ -brand-short-name }“ užblokavo virš <b>{ $blockedCount }</b> stebėjimo elementų!
       *[other] Nuo { DATETIME($date, month: "long", year: "numeric") } „{ -brand-short-name }“ užblokavo virš <b>{ $blockedCount }</b> stebėjimo elementų!
    }
cfr-doorhanger-milestone-ok-button = Rodyti viską
    .accesskey = R
cfr-doorhanger-milestone-close-button = Užverti
    .accesskey = v

## DOH Message

cfr-doorhanger-doh-body = Jūsų privatumas yra svarbus. „{ -brand-short-name }“ dabar saugiai nukreipia jūsų DNS užklausas, kai tik įmanoma, į partnerių tarnybą, kad apsaugotų jus naršant.
cfr-doorhanger-doh-header = Saugesnės, šifruotos DNS užklausos
cfr-doorhanger-doh-primary-button-2 = Gerai
    .accesskey = G
cfr-doorhanger-doh-secondary-button = Išjungti
    .accesskey = I

## Fission Experiment Message

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Šios svetainės vaizdo įrašai gali būti rodomi netinkamai su šia „{ -brand-short-name }“ versija. Norėdami gauti geriausią palaikymą, atnaujinkite „{ -brand-short-name }“.
cfr-doorhanger-video-support-header = Atnaujinkite „{ -brand-short-name }“, norėdami paleisti vaizdo įrašą
cfr-doorhanger-video-support-primary-button = Atnaujinti dabar
    .accesskey = A

## Spotlight modal shared strings

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the BrowserWorks VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Panašu, kad naudojatės viešu „Wi-Fi“
spotlight-public-wifi-vpn-body = Norėdami paslėpti savo buvimo vietą ir naršymo veiklą, naudokite virtualų privatų tinklą (VPN). Tai leis apsisaugoti naršant viešose vietose, pvz., oro uostuose ir kavinėse.
spotlight-public-wifi-vpn-primary-button = Išsaugoti privatumą su „{ -mozilla-vpn-brand-name }“
    .accesskey = I
spotlight-public-wifi-vpn-link = Ne dabar
    .accesskey = N

## Total Cookie Protection Rollout

## Emotive Continuous Onboarding

spotlight-better-internet-header = Geresnis internetas prasideda nuo jūsų
spotlight-better-internet-body = Kai naudojate „{ -brand-short-name }“, balsuojate už atvirą ir prieinamą internetą, kuris būtų geresnis visiems.
spotlight-peace-mind-header = Mes su jumis
spotlight-peace-mind-body = Kiekvieną mėnesį „{ -brand-short-name }“ blokuoja vidutiniškai daugiau nei 3000 stebėjimo elementų, tenkančių vienam naudotojui. Nes niekas, ypač privatumo trikdžiai, tokie kaip sekimo elementai, neturėtų įsiterpti tarp jūsų ir gerojo interneto.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Laikyti užduočių juostoje
       *[other] Įsegti į užduočių juostą
    }
spotlight-pin-secondary-button = Ne dabar

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

## Waterfox View CFR

## Waterfox View Spotlight

## Colorways expiry reminder CFR

## Cookie Banner Handling CFR

## These strings are used in the Fox doodle Pin/set default spotlights

## These strings are used in the Set Waterfox as Default PDF Handler for Existing Users experiment

## FxA sync CFR

## Device Migration FxA Spotlight

