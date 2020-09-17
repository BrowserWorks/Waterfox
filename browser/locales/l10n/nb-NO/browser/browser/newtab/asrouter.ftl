# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Anbefalte utvidelser
cfr-doorhanger-feature-heading = Anbefalt funksjon
cfr-doorhanger-pintab-heading = Prøv dette: fest fanen

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Hvorfor ser jeg dette

cfr-doorhanger-extension-cancel-button = Ikke nå
    .accesskey = n

cfr-doorhanger-extension-ok-button = Legg til nå
    .accesskey = e
cfr-doorhanger-pintab-ok-button = Fest denne fanen
    .accesskey = F

cfr-doorhanger-extension-manage-settings-button = Behandle anbefalingsinnstillinger
    .accesskey = B

cfr-doorhanger-extension-never-show-recommendation = Ikke vis meg denne anbefalingen
    .accesskey = s

cfr-doorhanger-extension-learn-more-link = Les mer

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = av { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Anbefaling
cfr-doorhanger-extension-notification2 = Anbefaling
    .tooltiptext = Utvidelsesanbefaling
    .a11y-announcement = Utvidelsesanbefaling tilgjengelig

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Anbefaling
    .tooltiptext = Funksjonsanbefaling
    .a11y-announcement = Funksjonsanbefaling tilgjengelig

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
        [one] { $total } bruker
       *[other] { $total } brukere
    }

cfr-doorhanger-pintab-description = Få enkel tilgang til de mest brukte nettstedene dine. Hold nettsteder åpne i en fane (selv når du starter på nytt).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Høyreklikk</b> på fanen du vil feste.
cfr-doorhanger-pintab-step2 = Velg <b>Fest fane</ b> fra menyen.
cfr-doorhanger-pintab-step3 = Om nettstedet har en oppdatering, vil du se en blå prikk på din festede fane.

cfr-doorhanger-pintab-animation-pause = Pause
cfr-doorhanger-pintab-animation-resume = Fortsett


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synkroniser bokmerkene dine overalt.
cfr-doorhanger-bookmark-fxa-body = Bra funn! Mangler du bokmerket på dine mobile enheter. Få en { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Synkroniser bokmerker nå…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Lukk-knapp
    .title = Lukk

## Protections panel

cfr-protections-panel-header = Surf uten å bli fulgt
cfr-protections-panel-body = Hold dataene for deg selv. { -brand-short-name } beskytter deg mot mange av de vanligste sporere som følger det du gjør på nettet.
cfr-protections-panel-link-text = Les mer

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Ny funksjon:

cfr-whatsnew-button =
    .label = Hva er nytt
    .tooltiptext = Hva er nytt

cfr-whatsnew-panel-header = Hva er nytt

cfr-whatsnew-release-notes-link-text = Les utgivelsesnotatene

cfr-whatsnew-fx70-title = { -brand-short-name } jobber nå enda mer for ditt personvern
cfr-whatsnew-fx70-body =
    Den siste oppdateringen forbedrer sporingsbeskyttelsesfunksjonen og gjør det
    enklere enn noen gang å lage sikre passord for hvert nettsted.

cfr-whatsnew-tracking-protect-title = Beskytt deg mot sporere
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } blokkerer mange vanlige sporere fra sosiale medier og sporing på tvers av nettsteder som
    følg det du gjør på nettet.
cfr-whatsnew-tracking-protect-link-text = Vis din rapport

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Sporer blokkert
       *[other] Sporere blokkert
    }
cfr-whatsnew-tracking-blocked-subtitle = Siden { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Vis rapport

cfr-whatsnew-lockwise-backup-title = Ta sikkerhetskopi av passordene dine
cfr-whatsnew-lockwise-backup-body = Nå kan du generere sikre passord du får tilgang til hvor som helst du logger inn.
cfr-whatsnew-lockwise-backup-link-text = Slå på sikkerhetskopiering

cfr-whatsnew-lockwise-take-title = Ta med deg dine passord
cfr-whatsnew-lockwise-take-body =
    Mobilappen { -lockwise-brand-short-name } lar deg få tilgang til dine
    sikkerhetskopierte passord hvor som helst.
cfr-whatsnew-lockwise-take-link-text = Last ned appen

## Search Bar

cfr-whatsnew-searchbar-title = Skriv mindre, finn mer med adressefeltet
cfr-whatsnew-searchbar-body-topsites = Velg adresselinjen, og en boks med lenker til dine mest besøkte nettsteder vil bli vist.
cfr-whatsnew-searchbar-icon-alt-text = Forstørrelsesglassikon

## Picture-in-Picture

cfr-whatsnew-pip-header = Se på videoer mens du surfer
cfr-whatsnew-pip-body = Bilde-i-bilde åpner opp video i et flytende vindu slik at du kan se på den mens du jobber i andre faner.
cfr-whatsnew-pip-cta = Les mer

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Færre irriterende sprettoppmeldinger
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } blokkerer nå nettsteder fra å automatisk be om å sende deg sprettopp-meldinger.
cfr-whatsnew-permission-prompt-cta = Les mer

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Fingerprinter blokkert
       *[other] Fingerprinters blokkerte
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } blokkerer mange fingerprintere som i det skjulte samler informasjon om enheten din og dine handlinger for å lage en annonseringsprofil for deg.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Fingerprinters
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } kan blokkere fingerprintere som i det skjulte samler informasjon om enheten din og dine handlinger for å lage en annonseringsprofil for deg.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Få dette bokmerket på din telefon
cfr-doorhanger-sync-bookmarks-body = Ta med bokmerker, passord, historikk og mer overalt hvor du er logget inn på { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Slå på { -sync-brand-short-name }
    .accesskey = S

## Login Sync

cfr-doorhanger-sync-logins-header = Glem aldri et passord igjen
cfr-doorhanger-sync-logins-body = Lagre og synkroniser passordene dine sikkert med alle enhetene dine.
cfr-doorhanger-sync-logins-ok-button = Slå på { -sync-brand-short-name }
    .accesskey = S

## Send Tab

cfr-doorhanger-send-tab-header = Les dette mens du er på farten
cfr-doorhanger-send-tab-recipe-header = Ta denne oppskriften med på kjøkkenet
cfr-doorhanger-send-tab-body = Send fane lar deg enkelt dele denne lenken til telefonen din eller hvor som helst du er logget inn på { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Prøv send fane
    .accesskey = P

## Firefox Send

cfr-doorhanger-firefox-send-header = Del denne PDF-filen sikkert
cfr-doorhanger-firefox-send-body = Hold de sensitive dokumentene dine trygge mot nysgjerrige øyne med ende-til-ende-kryptering og en lenke som forsvinner når du er ferdig.
cfr-doorhanger-firefox-send-ok-button = Prøv { -send-brand-name }
    .accesskey = P

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Se beskyttelser
    .accesskey = b
cfr-doorhanger-socialtracking-close-button = Lukk
    .accesskey = L
cfr-doorhanger-socialtracking-dont-show-again = Ikke vis meg meldinger som dette igjen
    .accesskey = I
cfr-doorhanger-socialtracking-heading = { -brand-short-name } forhindret et sosialt nettverk fra å spore deg her
cfr-doorhanger-socialtracking-description = Ditt personvern betyr noe. { -brand-short-name } blokkerer nå vanlige sporere fra sosiale medier, og begrenser hvor mye data de kan samle inn om hva du gjør på nettet.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } blokkerte en fingerprinter på denne siden
cfr-doorhanger-fingerprinters-description = Ditt personvern betyr noe. { -brand-short-name } blokkerer nå fingerprinters, som samler deler av unikt identifiserbar informasjon om enheten din for å spore deg.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } blokkerte en kryptoutvinning på denne siden
cfr-doorhanger-cryptominers-description = Ditt personvern betyr noe. { -brand-short-name } blokkerer nå kryptoutvinnere, som bruker systemets datakraft til å utvinne digitale penger.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] { -brand-short-name } har blokkert over <b>{ $blockedCount }</b> sporere siden { $date }!
    }
cfr-doorhanger-milestone-ok-button = Vis alle
    .accesskey = s

cfr-doorhanger-milestone-close-button = Lukk
    .accesskey = L

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Lag enkelt sikre passord
cfr-whatsnew-lockwise-body = Det er vanskelig å tenke på unike, sikre passord for hver konto. Når du oppretter et passord, velger du passordfeltet for å bruke et sikkert, generert passord fra { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name }-ikon

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Få varsler om sårbare passord
cfr-whatsnew-passwords-body = Hackere vet at folk bruker de samme passordene på nytt. Hvis du brukte det samme passordet på flere nettsteder, og et av disse nettstedene var i en datalekkasje, vil du se et varsel i { -lockwise-brand-short-name } om å endre passordet ditt på disse nettstedene.
cfr-whatsnew-passwords-icon-alt = Sårbart passord nøkkelikon

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Ta bilde-i-bilde fullskjerm
cfr-whatsnew-pip-fullscreen-body = Når du spretter en video inn i et flytende vindu, kan du nå dobbeltklikke på det vinduet for å gå i fullskjerm.
cfr-whatsnew-pip-fullscreen-icon-alt = Ikon for bilde-i-bilde

## Protections Dashboard message

cfr-whatsnew-protections-header = Beskyttelse på et øyeblikk
cfr-whatsnew-protections-body = Sikkerhetsoversikten inneholder sammendragsrapporter om datalekkasjer og passordbehandling. Du kan nå spore hvor mange datalekkasjer du har løst, og se om noen av de lagrede passordene dine kan ha blitt eksponert i en datalekkasje.
cfr-whatsnew-protections-cta-link = Vis sikkerhetsoversikt
cfr-whatsnew-protections-icon-alt = Skjoldikon

## Better PDF message

cfr-whatsnew-better-pdf-header = Bedre PDF-opplevelse
cfr-whatsnew-better-pdf-body = PDF-dokumenter åpnes nå direkte i { -brand-short-name }, og holder arbeidsflyten innen samme program.

## DOH Message

cfr-doorhanger-doh-body = Ditt personvern betyr noe. { -brand-short-name } ruter nå dine DNS-forespørsler sikkert når det er mulig, til en tjeneste levert av en partner, for å beskytte deg mens du surfer.
cfr-doorhanger-doh-header = Sikrere, krypterte DNS-oppslag
cfr-doorhanger-doh-primary-button = OK, jeg skjønner
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Slå av
    .accesskey = S

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Automatisk beskyttelse mot lure sporingsmetoder
cfr-whatsnew-clear-cookies-body = Noen sporere viderekobler deg til andre nettsteder som i hemmelighet setter infokapsler. { -brand-short-name } fjerner nå automatisk infokapslene slik at du ikke kan bli sporet.
cfr-whatsnew-clear-cookies-image-alt = Illustrasjon for blokkert infokapsel
