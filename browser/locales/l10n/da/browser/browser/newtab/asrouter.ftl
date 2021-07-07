# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Anbefalet udvidelse
cfr-doorhanger-feature-heading = Anbefalet udvidelse
cfr-doorhanger-pintab-heading = Prøv: Fastgør faneblad

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Hvorfor får jeg vist dette?
cfr-doorhanger-extension-cancel-button = Ikke nu
    .accesskey = I
cfr-doorhanger-extension-ok-button = Tilføj nu
    .accesskey = T
cfr-doorhanger-pintab-ok-button = Fastgør dette faneblad
    .accesskey = F
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
cfr-doorhanger-pintab-description = Få nem adgang til de websteder, du bruger mest. Dine fastgjorte faneblade er der stadig, når du genstarter.

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Højreklik</b> på det faneblad, du vil fastgøre.
cfr-doorhanger-pintab-step2 = Vælg <b>Fastgør faneblad</b> i menuen.
cfr-doorhanger-pintab-step3 = En blå prik på det fastgjorte faneblad viser, at webstedet er blevet opdateret.
cfr-doorhanger-pintab-animation-pause = Pause
cfr-doorhanger-pintab-animation-resume = Fortsæt

## Firefox Accounts Message

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
cfr-whatsnew-panel-header = Nyheder
cfr-whatsnew-release-notes-link-text = Læs udgivelsesnoterne
cfr-whatsnew-fx70-title = { -brand-short-name } kæmper nu hårdere for din ret til et privatliv
cfr-whatsnew-fx70-body =
    Den nyeste version har forbedret funktionen Beskyttelse mod sporing og gør det
    nemmere end nogensinde før at lave sikre adgangskoder.
cfr-whatsnew-tracking-protect-title = Beskyt dig selv mod at blive sporet på nettet
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } blokerer mange udbredte sporings-teknologier fra sociale netværk
    og andre virksomheder, der følger med i, hvad du laver på nettet.
cfr-whatsnew-tracking-protect-link-text = Se din rapport
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] sporings-mekanisme blokeret
       *[other] sporings-mekanismer blokeret
    }
cfr-whatsnew-tracking-blocked-subtitle = siden { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Se rapport
cfr-whatsnew-lockwise-backup-title = Lav backup af dine adgangskoder
cfr-whatsnew-lockwise-backup-body = Og opret sikre adgangskoder, du har adgang til overalt, hvor du logger ind.
cfr-whatsnew-lockwise-backup-link-text = Slå backup til
cfr-whatsnew-lockwise-take-title = Tag dine adgangskoder med dig
cfr-whatsnew-lockwise-take-body =
    Med apppen { -lockwise-brand-short-name } får du sikker adgang til dine adgangskoder,
    uanset hvor du er.
cfr-whatsnew-lockwise-take-link-text = Hent appen

## Search Bar

cfr-whatsnew-searchbar-title = Skriv mindre, find mere med adressefeltet
cfr-whatsnew-searchbar-body-topsites = Vælg adressefeltet, og en boks med links til dine mest besøgte websteder vil blive vist.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Forstørrelsesglas-ikon

## Picture-in-Picture

cfr-whatsnew-pip-header = Se videoer, mens du browser
cfr-whatsnew-pip-body = Billede-i-billede viser video i et løsrevet vindue, så du kan se videoer, mens du bruger andre faneblade.
cfr-whatsnew-pip-cta = Læs mere

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Færre irriterende pop op-beskeder
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } forhindrer nu websteder i automatisk at spørge, om du vil have vist beskeder.
cfr-whatsnew-permission-prompt-cta = Læs mere

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Fingerprinter blokeret
       *[other] Fingerprinters blokeret
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } blokerer nu mange af de fingerprinters, der i det skjulte indsamler informationer om din enhed og dine handlinger med henblik på at skabe en markedsførings-profil på dig.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Fingerprinters
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } kan blokere fingerprinters, der i det skjulte indsamler informationer om din enhed og dine handlinger med henblik på at skabe en markedsførings-profil på dig.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Få dette bogmærke på din telefon
cfr-doorhanger-sync-bookmarks-body = Tag dine bogmærker, adgangskoder, din historik og meget mere med dig på alle dine enheder med { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Aktiver { -sync-brand-short-name }
    .accesskey = A

## Login Sync

cfr-doorhanger-sync-logins-header = Mist aldrig en adgangskode igen
cfr-doorhanger-sync-logins-body = Gem og synkroniser dine adgangskoder sikkert på alle dine enheder.
cfr-doorhanger-sync-logins-ok-button = Aktiver { -sync-brand-short-name }
    .accesskey = A

## Send Tab

cfr-doorhanger-send-tab-header = Læs på farten
cfr-doorhanger-send-tab-recipe-header = Tag opskriften med ud i køkkenet
cfr-doorhanger-send-tab-body = Med funktionen Send faneblade kan du hurtigt dele dette link med din telefon eller andre enheder med { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Prøv Send faneblade
    .accesskey = P

## Firefox Send

cfr-doorhanger-firefox-send-header = Del denne PDF-fil sikkert
cfr-doorhanger-firefox-send-body = Hold dine fortrolige dokumenter sikre med stærk kryptering og et link, der automatisk udløber
cfr-doorhanger-firefox-send-ok-button = Prøv { -send-brand-name }
    .accesskey = P

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Se beskyttelse
    .accesskey = b
cfr-doorhanger-socialtracking-close-button = Luk
    .accesskey = L
cfr-doorhanger-socialtracking-dont-show-again = Vis mig ikke meddelelser som denne igen
    .accesskey = V
cfr-doorhanger-socialtracking-heading = { -brand-short-name } forhindrede et socialt netværk i at spore dig på denne side
cfr-doorhanger-socialtracking-description = Du har ret til et privatliv. { -brand-short-name } blokerer nu de mest almindelige sporings-teknologier fra sociale medier for at begrænse, hvor meget data de kan indsamle om din adfærd på nettet.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } blokerede en fingerprinter på denne side
cfr-doorhanger-fingerprinters-description = Du har ret til et privatliv. { -brand-short-name } blokerer nu fingerprinters, der indsamler unikke informationer om din enhed for at spore dig.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } blokerede en cryptominer på denne side
cfr-doorhanger-cryptominers-description = Du har ret til et privatliv. { -brand-short-name } blokerer nu cryptominers, der bruger dit systems ressourcer til at udvinde digital valuta.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] { -brand-short-name } har blokeret flere end <b>{ $blockedCount }</b> sporings-mekanismer siden { $date }!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } har blokeret flere end <b>{ $blockedCount }</b> sporings-mekanismer siden { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = Vis alle
    .accesskey = V

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Opret nemt sikre adgangskoder
cfr-whatsnew-lockwise-body = Det er svært at finde på unikke og sikre adgangskoder til alle dine konti. Vælg feltet adgangskode, når du opretter en ny adgangskode. Så opretter { -brand-shorter-name } en sikker adgangskode til dig.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name }-ikon

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Få advarsler om usikre adgangskoder
cfr-whatsnew-passwords-body = Hackere ved, at folk genbruger deres adgangskoder. Hvis du har den samme adgangskode på flere forskellige websteder, så viser { -lockwise-brand-short-name } dig en advarsel og beder dig om at ændre din adgangskode på disse websteder.
cfr-whatsnew-passwords-icon-alt = Ikon for usikker adgangskode

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Brug billede-i-billede i fuld skærm
cfr-whatsnew-pip-fullscreen-body = Når du får vist en video i et flydende vindue kan du nu dobbeltklikke på vinduet for at få det vist i fuld skærm.
cfr-whatsnew-pip-fullscreen-icon-alt = Ikon for billede-i-billede

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Luk
    .accesskey = L

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Overblik over, hvordan du er beskyttet
cfr-whatsnew-protections-body = Oversigten over beskyttelse inkluderer sammendrag af rapporter om datalæk og håndtering af adgangskoder. Du kan se, hvor mange datalæk du har løst - og om nogle af dine gemte adgangskoder er blevet ramt af et datalæk.
cfr-whatsnew-protections-cta-link = Se oversigt over beskyttelse
cfr-whatsnew-protections-icon-alt = Skjold-ikon

## Better PDF message

cfr-whatsnew-better-pdf-header = Bedre visning af PDF-dokumenter
cfr-whatsnew-better-pdf-body = PDF-dokumenter åbnes nu direkte i { -brand-short-name }, så du har dem lige ved hånden.

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

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Automatisk beskyttelse mod listige sporings-taktikker
cfr-whatsnew-clear-cookies-body = Nogle sporings-mekanismer omdirigerer dig til andre websteder, der gemmer hemmelige cookies. { -brand-short-name } sletter nu automatisk disse cookies, så du ikke kan spores.
cfr-whatsnew-clear-cookies-image-alt = Illustration af blokeret cookie

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Flere mediekontroller
cfr-whatsnew-media-keys-body = Kontroller afspilning af lyd eller video direkte fra dit tastatur eller dit headset. På den måde er det nemt at have kontrol over medie-indhold fra et andet faneblad, et andet program - eller endda hvis du computer er låst. Du kan også skifte mellem numre ved at bruge piletasterne.
cfr-whatsnew-media-keys-button = Mere information

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Søge-genveje i adressefeltet
cfr-whatsnew-search-shortcuts-body = Når du indtaster navnet eller adressen på en søgetjeneste, så vil der nu blive vist en blå genvej i søgeforslagene nedenunder. Vælg denne genvej for at fuldføre din søgning direkte fra adressefeltet.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Beskyttelse mod skadelige super-cookies
cfr-whatsnew-supercookies-body = Websteder kan i hemmelighed føje en "super-cookie" til din browser, der kan følge dig rundt på nettet - selv efter at du har slettet dine cookies. { -brand-short-name } beskytter dig nu mod super-cookies, så de ikke kan bruges til at spore din online aktivitet på tværs af websteder.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Bedre bogmærker
cfr-whatsnew-bookmarking-body = Det er blevet nemmere at holde styr på dine yndings-websteder. { -brand-short-name } husker nu din foretrukne placering for gemte bogmærker, viser som standard bogmærkelinjen på nye faneblade og giver dig nem adgang til resten af dine bogmærker med en bogmærkemappe.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Omfattende beskyttelse mod cookie-sporing på tværs af websteder
cfr-whatsnew-cross-site-tracking-body = Du kan du vælge at blive endnu bedre beskyttet mod sporing via cookies. { -brand-short-name } kan isolere dine aktiviteter og data til det websted, du besøger. På dén måde bliver information gemt i browseren ikke delt mellem websteder.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Videoer på dette websted afspilles måske ikke korrekt i denne version af { -brand-short-name }. Opdater { -brand-short-name } nu for fuld understøttelse af video.
cfr-doorhanger-video-support-header = Opdater { -brand-short-name } for at afspille video
cfr-doorhanger-video-support-primary-button = Opdater nu
    .accesskey = O
