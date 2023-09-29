# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Tilrådde utvidingar
cfr-doorhanger-feature-heading = Tilrådd funksjon

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Kvifor ser eg dette
cfr-doorhanger-extension-cancel-button = Ikkje no
    .accesskey = n
cfr-doorhanger-extension-ok-button = Legg til no
    .accesskey = e
cfr-doorhanger-extension-manage-settings-button = Handsam tilrådingsinnstillingar
    .accesskey = H
cfr-doorhanger-extension-never-show-recommendation = Ikkje vis meg denne tilrådinga
    .accesskey = s
cfr-doorhanger-extension-learn-more-link = Les meir
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = av { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Tilråding
cfr-doorhanger-extension-notification2 = Tilråding
    .tooltiptext = Utvidingstilråding
    .a11y-announcement = Utvidingstilråding tilgjengeleg
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Tilråding
    .tooltiptext = Funksjonstilråding
    .a11y-announcement = Funksjonstilråding tilgjengeleg

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
        [one] { $total } brukar
       *[other] { $total } brukarar
    }

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synkroniser bokmerka dine overalt.
cfr-doorhanger-bookmark-fxa-body = Bra funn! Manglar du bokmerket på dei mobile einingane dine. Kom i gang med ein { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Synkroniser bokmerke no…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Lat att-knapp
    .title = Lat att

## Protections panel

cfr-protections-panel-header = Surf utan å bli følgd
cfr-protections-panel-body = Behald dine data for deg sjølv. { -brand-short-name } beskyttar deg mot mange av dei vanlegaste sporarane som følgjer det du gjer på nettet.
cfr-protections-panel-link-text = Les meir

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Ny funksjon:
cfr-whatsnew-button =
    .label = Kva er nytt
    .tooltiptext = Kva er nytt
cfr-whatsnew-release-notes-link-text = Les versjonsnotatet

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } blokkerte over <b>{ $blockedCount }</b> sporarar sidan { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = Vis alle
    .accesskey = s
cfr-doorhanger-milestone-close-button = Lat att
    .accesskey = L

## DOH Message

cfr-doorhanger-doh-body = Personvernet ditt betyr noko. { -brand-short-name } rutar no DNS-førespurnadane dine trygt når det er mogleg, til ei teneste levert av ein partnar, for å beskytte deg medan du surfar.
cfr-doorhanger-doh-header = Sikrare og krypterte DNS-oppslag
cfr-doorhanger-doh-primary-button-2 = OK
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Slå av
    .accesskey = S

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Personvernet ditt er viktig. { -brand-short-name } isolerer no nettstadar frå kvarandre, noko som gjer det vanskelegare for hackarar å stele passord, kreditkortnummer og annan sensitiv informasjon.
cfr-doorhanger-fission-header = Nettstadisolering
cfr-doorhanger-fission-primary-button = Ok, eg forstår
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Les meir
    .accesskey = L

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Videoar på dnne nettstaden kan ikkje spelast av rett på denne versjonen av { -brand-short-name }. For full videostøtte, oppdater { -brand-short-name } no.
cfr-doorhanger-video-support-header = Oppdater { -brand-short-name } for å spele av video
cfr-doorhanger-video-support-primary-button = Oppdater no
    .accesskey = O

## Spotlight modal shared strings

spotlight-learn-more-collapsed = Les meir
    .title = Utvid for å lære meir om denne funksjonen
spotlight-learn-more-expanded = Les meir
    .title = Lat att

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Det ser ut til at du brukar offentleg Wi-Fi
spotlight-public-wifi-vpn-body = For å skjule posisjonen din og nettlesingsaktiviteten, bør du vurdere eit virtuelt privat nettverk. Det vil bidra til å halde deg beskytta når du surfar på offentlege stadar som flyplassar og kaféar.
spotlight-public-wifi-vpn-primary-button = Hald deg privat med { -mozilla-vpn-brand-name }
    .accesskey = H
spotlight-public-wifi-vpn-link = Ikkje no
    .accesskey = I

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header =
    Test ut vår kraftigaste
    personvernfunksjon nokon gong
spotlight-total-cookie-protection-body = Totalt vern mot infokapslar stoppar sporarar frå å bruke infokapslar til å forfølgje deg rundt om på nettet.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = { -brand-short-name }byggjer eit gjerde rundt infokapslar, og avgrensar dei til nettstaden du er på, slik at sporarar ikkje kan bruke dei til å følgje deg. Med tidleg tilgang hjelper du til med å optimalisere denne funksjonen slik at vi kan fortsetje å byggje eit betre nett for alle.
spotlight-total-cookie-protection-primary-button = Slå på total vern mot infokapslar
spotlight-total-cookie-protection-secondary-button = Ikkje no
cfr-total-cookie-protection-header = Takka vere deg er { -brand-short-name } meir privat og sikrare enn nokon gong
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch". Only those who received it and accepted are shown this message.
cfr-total-cookie-protection-body = Totalt vern mot infokapslar er vårt sterkaste personvern til no – og det er no ei standardinnstilling for { -brand-short-name }-brukarar overalt. Vi kunne ikkje ha gjort det utan deltakarar med tidleg tilgang som deg. Så takk for at du hjelper oss med å skape eit betre, meir privat internett.

## Emotive Continuous Onboarding

spotlight-better-internet-header = Eit betre internett byrjar med deg
spotlight-better-internet-body = Når du brukar { -brand-short-name }, stemmer du for eit ope og tilgjengeleg internett som er betre for alle.
spotlight-peace-mind-header = Vi beskyttar deg
spotlight-peace-mind-body = Kvar månad blokkerer { -brand-short-name } i gjennomsnitt over 3000 sporarar per brukar. Fordi ingenting, spesielt personvernplager som sporarar, skal stå mellom deg og eit godt internett.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Behald i dokk
       *[other] Fest til oppgåvelinja
    }
spotlight-pin-secondary-button = Ikkje no
