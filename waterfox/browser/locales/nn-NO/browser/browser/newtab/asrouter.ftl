# This Source Code Form is subject to the terms of the BrowserWorks Public
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

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Videoar på dnne nettstaden kan ikkje spelast av rett på denne versjonen av { -brand-short-name }. For full videostøtte, oppdater { -brand-short-name } no.
cfr-doorhanger-video-support-header = Oppdater { -brand-short-name } for å spele av video
cfr-doorhanger-video-support-primary-button = Oppdater no
    .accesskey = O

## Spotlight modal shared strings

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the BrowserWorks VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Det ser ut til at du brukar offentleg Wi-Fi
spotlight-public-wifi-vpn-body = For å skjule posisjonen din og nettlesingsaktiviteten, bør du vurdere eit virtuelt privat nettverk. Det vil bidra til å halde deg beskytta når du surfar på offentlege stadar som flyplassar og kaféar.
spotlight-public-wifi-vpn-primary-button = Hald deg privat med { -mozilla-vpn-brand-name }
    .accesskey = H
spotlight-public-wifi-vpn-link = Ikkje no
    .accesskey = I

## Total Cookie Protection Rollout

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

mr2022-background-update-toast-title = Ny { -brand-short-name }. Meir privat. Færre sporarar. Ingen kompromiss.
mr2022-background-update-toast-text = Prøv den nyaste { -brand-short-name } no, oppgradert med det sterkaste anti-sporingsvernet vårt til no.

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it
# using a variable font like Arial): the button can only fit 1-2
# additional characters, exceeding characters will be truncated.
mr2022-background-update-toast-primary-button-label = Opne { -brand-shorter-name } no

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it using a
# variable font like Arial): the button can only fit 1-2 additional characters,
# exceeding characters will be truncated.
mr2022-background-update-toast-secondary-button-label = Minn meg på det seinare

## Waterfox View CFR

firefoxview-cfr-primarybutton = Prøv det
    .accesskey = t
firefoxview-cfr-secondarybutton = Ikkje no
    .accesskey = n
firefoxview-cfr-header-v2 = Hald fram raskt der du slutta
firefoxview-cfr-body-v2 = Få tilbake nyleg attlatne faner, og skift snøgt mellom einingar med { -firefoxview-brand-name }.

## Waterfox View Spotlight

firefoxview-spotlight-promo-title = Sei hei til { -firefoxview-brand-name }

# “Poof” refers to the expression to convey when something or someone suddenly disappears, or in this case, reappears. For example, “Poof, it’s gone.”
firefoxview-spotlight-promo-subtitle = Vil du ha den opne fana på telefonen din? Hent henne. Treng du sida du nettopp har besøkt? Hent henne tilbake med { -firefoxview-brand-name }.
firefoxview-spotlight-promo-primarybutton = Sjå korleis dette fungerer
firefoxview-spotlight-promo-secondarybutton = Hopp over

## Colorways expiry reminder CFR

colorways-cfr-primarybutton = Vel fargesamansetjing
    .accesskey = V

# "shades" refers to the different color options available to users in colorways.
colorways-cfr-body = Farg nettlesaren din med eksklusive { -brand-short-name }-fargenyansar inspirert av røyster som endra kulturen.
colorways-cfr-header-28days = Fargesamansetjinga «Uavhengige røyster» går ut 16. januar
colorways-cfr-header-14days = Fargesamansetjinga «Uavhengige røyster» går ut om to veker
colorways-cfr-header-7days = Fargesamansetjinga «Uavhengige røyster» går ut om to veker
colorways-cfr-header-today = Fargesamansetjinga «Uavhengige røyster» går ut i dag

## Cookie Banner Handling CFR

cfr-cbh-header = Tillate at { -brand-short-name } avviser infokapselbanner?
cfr-cbh-body = { -brand-short-name } kan automatisk avvise mange infokapselbanner-førespurnadar.
cfr-cbh-confirm-button = Avvis infokapselbanner
    .accesskey = A
cfr-cbh-dismiss-button = Ikkje no
    .accesskey = N

## These strings are used in the Fox doodle Pin/set default spotlights

july-jam-headline = Vi beskyttar deg
july-jam-body = Kvar månad blokkerer { -brand-short-name } i gjennomsnitt over 3000 sporarar per brukar, noko som gir deg trygg og rask tilgang til eit bra internett.
july-jam-set-default-primary = Opne lenkene mine med { -brand-short-name }
fox-doodle-pin-headline = Velkomen tilbake

# “indie” is short for the term “independent”.
# In this instance, free from outside influence or control.
fox-doodle-pin-body = Her er ei rask påminning om at du kan ha den uavhengige nettlesaren din eitt klikk unna.
fox-doodle-pin-primary = Opne lenkene mine med { -brand-short-name }
fox-doodle-pin-secondary = Ikkje no

## These strings are used in the Set Waterfox as Default PDF Handler for Existing Users experiment

set-default-pdf-handler-headline = <strong>PDF-filene dine vert no opna i { -brand-short-name }.</strong> Rediger eller fyll ut skjema direkte i nettlesaren din. For å endre, søk etter «PDF» i innstillingane.
set-default-pdf-handler-primary = Eg forstår

## FxA sync CFR

fxa-sync-cfr-header = Planlegg du å kjøpe ei ny eining i framtida?
fxa-sync-cfr-body = Pass på at dei siste bokmerka, passord og faner følgjer med deg kvar gong du opnar ein ny { -brand-product-name }-nettlesar.
fxa-sync-cfr-primary = Les meir
    .accesskey = L
fxa-sync-cfr-secondary = Minn meg på det seinare
    .accesskey = M

## Device Migration FxA Spotlight

device-migration-fxa-spotlight-header = Brukar du ei gammal eining?
device-migration-fxa-spotlight-body = Sikkerheitskopier dine data for å sikre at du ikkje mistar viktig informasjon som bokmerke og passord — spesielt viss du byter til ei ny eining.
device-migration-fxa-spotlight-primary-button = Korleis tryggingskopiere mine data
device-migration-fxa-spotlight-link = Minn meg på det seinare
