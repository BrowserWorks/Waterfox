# This Source Code Form is subject to the terms of the BrowserWorks Public
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

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Videoer på dette websted afspilles måske ikke korrekt i denne version af { -brand-short-name }. Opdater { -brand-short-name } nu for fuld understøttelse af video.
cfr-doorhanger-video-support-header = Opdater { -brand-short-name } for at afspille video
cfr-doorhanger-video-support-primary-button = Opdater nu
    .accesskey = O

## Spotlight modal shared strings

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the BrowserWorks VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Det ser ud til, at du bruger et offentligt wi-fi
spotlight-public-wifi-vpn-body = Overvej at bruge VPN (Virtuelt Privat Netværk) for at skjule din placering og din aktivitet på nettet. Det vil sørge for at beskytte dig, når du går på nettet via offentlige netværk, fx i lufthavne eller på caféer.
spotlight-public-wifi-vpn-primary-button = Beskyt dit privatliv med { -mozilla-vpn-brand-name }
    .accesskey = B
spotlight-public-wifi-vpn-link = Ikke nu
    .accesskey = k

## Total Cookie Protection Rollout

## Emotive Continuous Onboarding

spotlight-better-internet-header = Et bedre internet begynder med dig
spotlight-better-internet-body = Ved at bruge { -brand-short-name } stemmer du for et åbent og tilgængeligt internet, der er bedre for alle.
spotlight-peace-mind-header = Vi beskytter dig
spotlight-peace-mind-body = Hver måned blokerer { -brand-short-name } i gennemsnit 3.000 sporings-mekanismer pr. bruger. For ingenting - og især ikke trusler mod dit privatliv som sporings-mekanismer - bør stå mellem dig og et godt internet.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Behold i Dock
       *[other] Fastgør til proceslinjen
    }
spotlight-pin-secondary-button = Ikke nu

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

mr2022-background-update-toast-title = Den nye { -brand-short-name }. Mere privat. Færre sporings-mekanismer. Ingen kompromisser.
mr2022-background-update-toast-text = Prøv den nyeste { -brand-short-name }, opgraderet med vores hidtil stærkeste beskyttelse mod sporing.

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it
# using a variable font like Arial): the button can only fit 1-2
# additional characters, exceeding characters will be truncated.
mr2022-background-update-toast-primary-button-label = Åbn { -brand-shorter-name } nu

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it using a
# variable font like Arial): the button can only fit 1-2 additional characters,
# exceeding characters will be truncated.
mr2022-background-update-toast-secondary-button-label = Påmind mig senere

## Waterfox View CFR

firefoxview-cfr-primarybutton = Prøv det
    .accesskey = P
firefoxview-cfr-secondarybutton = Ikke nu
    .accesskey = n
firefoxview-cfr-header-v2 = Fortsæt hurtigt hvor du slap
firefoxview-cfr-body-v2 = Få nyligt lukkede faneblade tilbage og skift hurtigt mellem enheder med { -firefoxview-brand-name }.

## Waterfox View Spotlight

firefoxview-spotlight-promo-title = Prøv { -firefoxview-brand-name }

# “Poof” refers to the expression to convey when something or someone suddenly disappears, or in this case, reappears. For example, “Poof, it’s gone.”
firefoxview-spotlight-promo-subtitle = Vil du se et åbent faneblad på din telefon? Hent det. Har du brug for en side, du besøgte tidligere? Find den i { -firefoxview-brand-name }.
firefoxview-spotlight-promo-primarybutton = Se, hvordan det fungerer
firefoxview-spotlight-promo-secondarybutton = Spring over

## Colorways expiry reminder CFR

colorways-cfr-primarybutton = Vælg farvekombination
    .accesskey = V

# "shades" refers to the different color options available to users in colorways.
colorways-cfr-body = Sæt farve på din browser med eksklusive { -brand-short-name }-farvetemaer inspireret af stemmer, der ændrer kulturen.
colorways-cfr-header-28days = Farvekombinationerne "Uafhængige stemmer" udløber den 16. januar
colorways-cfr-header-14days = Farvekombinationerne "Uafhængige stemmer" udløber om to uger
colorways-cfr-header-7days = Farvekombinationerne "Uafhængige stemmer" udløber i denne uge
colorways-cfr-header-today = Farvekombinationerne "Uafhængige stemmer" udløber i dag

## Cookie Banner Handling CFR

cfr-cbh-header = Tillad { -brand-short-name } at afvise cookie-bannere?
cfr-cbh-body = { -brand-short-name } kan automatisk afvise mange cookie-banner-anmodninger.
cfr-cbh-confirm-button = Afvis cookie-bannere
    .accesskey = A
cfr-cbh-dismiss-button = Ikke nu
    .accesskey = n

## These strings are used in the Fox doodle Pin/set default spotlights

july-jam-headline = Vi beskytter dig
july-jam-body = Hver måned blokerer { -brand-short-name } i gennemsnit mere end 3000 sporings-tjenester per bruger, så du kan få sikker og hurtig adgang til internettet.
july-jam-set-default-primary = Åbn mine links med { -brand-short-name }
fox-doodle-pin-headline = Velkommen tilbage

# “indie” is short for the term “independent”.
# In this instance, free from outside influence or control.
fox-doodle-pin-body = Her er en hurtig påmindelse om, at du kan have din uafhængige favorit-browser et enkelt klik borte.
fox-doodle-pin-primary = Åbn mine links med { -brand-short-name }
fox-doodle-pin-secondary = Ikke nu

## These strings are used in the Set Waterfox as Default PDF Handler for Existing Users experiment

set-default-pdf-handler-headline = <strong>PDF-filer åbnes nu i { -brand-short-name }.</strong> Rediger eller udfyld formularer direkte i browseren. Søg efter "PDF" i indstillinger, hvis du vil ændre dette.
set-default-pdf-handler-primary = Forstået

## FxA sync CFR

fxa-sync-cfr-header = Skal du snart have en ny enhed?
fxa-sync-cfr-body = Sørg for at have dine seneste bogmærker, adgangskoder og faneblade med dig, hver gang du åbner en ny { -brand-product-name }-browser.
fxa-sync-cfr-primary = Læs mere
    .accesskey = L
fxa-sync-cfr-secondary = Påmind mig senere
    .accesskey = P

## Device Migration FxA Spotlight

device-migration-fxa-spotlight-header = Bruger du en ældre enhed?
device-migration-fxa-spotlight-body = Tag en sikkerhedskopi af dine data for at sikre, at du ikke mister vigtige oplysninger som bogmærker og adgangskoder - især hvis du skifter til en ny enhed.
device-migration-fxa-spotlight-primary-button = Sådan sikkerhedskopierer du dine data
device-migration-fxa-spotlight-link = Påmind mig senere
