# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Tilrådde utvidingar
cfr-doorhanger-feature-heading = Tilrådd funksjon
cfr-doorhanger-pintab-heading = Prøv dette: Fest fana

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Kvifor ser eg dette

cfr-doorhanger-extension-cancel-button = Ikkje no
    .accesskey = n

cfr-doorhanger-extension-ok-button = Legg til no
    .accesskey = e
cfr-doorhanger-pintab-ok-button = Fest denne fana
    .accesskey = F

cfr-doorhanger-extension-manage-settings-button = Handter tilrådingsinnstillingar
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

cfr-doorhanger-pintab-description = Få enkel tilgang til dei mest brukte nettstadane dine. Hald nettstadar opne i ei fane (sjølv når du starter på nytt).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Høgreklikk</b> på fana du vil feste.
cfr-doorhanger-pintab-step2 = Vel <b>Fest fane</ b> frå menyen.
cfr-doorhanger-pintab-step3 = Om nettstaden har ei oppdatering, vil du sjå ein blå prikk på den festa fana di.

cfr-doorhanger-pintab-animation-pause = Pause
cfr-doorhanger-pintab-animation-resume = Fortset


## Firefox Accounts Message

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

cfr-whatsnew-panel-header = Kva er nytt

cfr-whatsnew-release-notes-link-text = Les versjonsnotatet

cfr-whatsnew-fx70-title = { -brand-short-name } jobbar no endå meir for personvernet ditt
cfr-whatsnew-fx70-body =
    Den siste oppdateringa forbetrar sporingsbesvernfunksjonen og gjer det
    enklare enn nokon gong å lage sikre passord for kvar nettstad.

cfr-whatsnew-tracking-protect-title = Beskytt deg mot sporarar
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } blokkerer mange vanlege sporarar frå sosiale medium og sporing på tvers av nettstadar som
    følgjer det du gjer på nettet.
cfr-whatsnew-tracking-protect-link-text = Vis rapporten din

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Sporar blokkert
       *[other] Sporar blokkert
    }
cfr-whatsnew-tracking-blocked-subtitle = Sidan { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Vis rapport

cfr-whatsnew-lockwise-backup-title = Ta sikkerheitskopi av passorda dine
cfr-whatsnew-lockwise-backup-body = No kan du generere sikre passord du får tilgang til kvar som helst du loggar inn.
cfr-whatsnew-lockwise-backup-link-text = Slå på sikkerheitskopiering

cfr-whatsnew-lockwise-take-title = Ta med deg passorda dine
cfr-whatsnew-lockwise-take-body =
    Mobilappen { -lockwise-brand-short-name } lèt deg få tilgang til dei
    sikkerheitskopierte passorda dine kvar som helst.
cfr-whatsnew-lockwise-take-link-text = Last ned appen

## Search Bar

cfr-whatsnew-searchbar-title = Skriv mindre, finn meir med adressefeltet
cfr-whatsnew-searchbar-body-topsites = Vel adresselinja, og ein boks med lenker til dei mest besøkte nettstadane dine vil bli vist.
cfr-whatsnew-searchbar-icon-alt-text = Forstørringsglas-ikon

## Picture-in-Picture

cfr-whatsnew-pip-header = Sjå på videoar medan du surfar
cfr-whatsnew-pip-body = Bilde-i-bilde opnar opp video i eit flytande vindauge slik at du kan så på han medan du jobbar i andre faner.
cfr-whatsnew-pip-cta = Les meir

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Færre irriterande sprettoppmeldingar
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } blokkerer no nettstadar frå å automatisk be om å sende deg sprettopp-meldingar.
cfr-whatsnew-permission-prompt-cta = Les meir

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Fingerprinter blokkert
       *[other] Fingerprinters blokkerte
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } blokkerer mange fingerprintarar som i det skjulte samlar informasjon om eininga di og handlingane dine for å lage ein annonseringsprofil for deg.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Fingerprinters
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } kan blokkere fingerprintarar som i det skjulte samlar informasjon om eininga di og handlingane dine for å lage ein annonseringsprofil for deg.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Få dette bokmerket på telefonen din
cfr-doorhanger-sync-bookmarks-body = Ta med bokmerke, passord, historikk, og meir, overalt der du er logga inn på { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Slå på { -sync-brand-short-name }
    .accesskey = S

## Login Sync

cfr-doorhanger-sync-logins-header = Gløym aldri meir eit passord
cfr-doorhanger-sync-logins-body = Lagre og synkroniser passorda dine sikkert med alle einingane dine.
cfr-doorhanger-sync-logins-ok-button = Slå på { -sync-brand-short-name }
    .accesskey = S

## Send Tab

cfr-doorhanger-send-tab-header = Les dette medan du er påfarten
cfr-doorhanger-send-tab-recipe-header = Ta denne oppskrifta med på kjøkkenet
cfr-doorhanger-send-tab-body = Send fane lèt deg enkelt dele denne lenka til telefonen din eller kvar som helst du er logga inn på { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Prøv send fane
    .accesskey = P

## Firefox Send

cfr-doorhanger-firefox-send-header = Del denne PDF-fila sikkert
cfr-doorhanger-firefox-send-body = Hald dei sensitive dokumenta dine trygge mot nysgjerrige auge med ende-til-ende-kryptering og ei lenke som forsvinn når du er ferdig.
cfr-doorhanger-firefox-send-ok-button = Prøv { -send-brand-name }
    .accesskey = P

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Sjå vern
    .accesskey = S
cfr-doorhanger-socialtracking-close-button = Lat att
    .accesskey = L
cfr-doorhanger-socialtracking-dont-show-again = Ikkje vis meg meldingar som dette igjen
    .accesskey = I
cfr-doorhanger-socialtracking-heading = { -brand-short-name } hindra eit sosialt nettverk frå å spore deg her
cfr-doorhanger-socialtracking-description = Personvernet ditt betyr noko. { -brand-short-name } blokkerer no vanlege sporarar frå sosiale medium, og avgrensar kor mykje data dei kan samle inn om kva du gjer på nettet.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } blokkerte ein fingerprinter på denne sida
cfr-doorhanger-fingerprinters-description = Personvernet ditt betyr noko. { -brand-short-name } blokkerer no fingerprinters, som samlar inn delar av unikt identifiserbar informasjon om eininga di for å spore deg.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } blokkerte ein kryptominar på denne sida
cfr-doorhanger-cryptominers-description = Personvernet ditt betyr noko. { -brand-short-name } blokkerer no kryptoutvinnarar, som brukar datakrafta til systemet for å utvinne digitale pengar.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] { -brand-short-name } har blokkert over <b>{ $blockedCount }</b> sporarar sidan { $date }!
    }
cfr-doorhanger-milestone-ok-button = Vis alle
    .accesskey = s

cfr-doorhanger-milestone-close-button = Lat att
    .accesskey = L

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Lag enkelt trygge passord
cfr-whatsnew-lockwise-body = Det er vanskeleg å kome på unike, trygge passord for kvar konto. Når du lagar eit passord, vel du passordfeltet for å bruke eit trygt, generert passord frå { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name }-ikon

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Få varsel om sårbare passord
cfr-whatsnew-passwords-body = Hackarar veit at folk brukar dei same passorda på nytt. Dersom du brukar det same passordet på fleire nettstadar, og ein av desse nettstadane er i ein datalekkasje, vil du sjå eit varsel i { -lockwise-brand-short-name } om å endre passordet ditt på desse nettstadane.
cfr-whatsnew-passwords-icon-alt = Sårbart passord, nøkkelikon

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Ta bilde-i-bilde fullskjerm
cfr-whatsnew-pip-fullscreen-body = Når du sprett ein video inn i eit flytande vindauge, kan du no dobbelklikke på det vindauget for å gå i fullskjerm.
cfr-whatsnew-pip-fullscreen-icon-alt = Bilde-i-bilde ikon

## Protections Dashboard message

cfr-whatsnew-protections-header = Vern på ein augneblink
cfr-whatsnew-protections-body = Tryggingsoversikta inneheld samandragsrapportar om datalekkasjar og passordhandtering. Du kan no spore kor mange datalekkasjar du har løyst, og sjå om nokon av dei lagra passorda dine kan ha blitt eksponerte i ein datalekkasje.
cfr-whatsnew-protections-cta-link = Vis tryggingsoversyn
cfr-whatsnew-protections-icon-alt = Skjoldikon

## Better PDF message

cfr-whatsnew-better-pdf-header = Betre PDF-oppleving
cfr-whatsnew-better-pdf-body = PDF-dokument vert no opna direkte i { -brand-short-name }, og held arbeidsflyten innan same program.

## DOH Message

cfr-doorhanger-doh-body = Personvernet ditt betyr noko. { -brand-short-name } rutar no DNS-førespurnadane dine sikkert når det er mogleg, til ei teneste levert av ein partnar, for å beskytte deg mens du surfar.
cfr-doorhanger-doh-header = Sikrare og krypterte DNS-oppslag
cfr-doorhanger-doh-primary-button = OK, eg skjønar
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Slå av
    .accesskey = S

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Automatisk vern mot lure sporingsmetodar
cfr-whatsnew-clear-cookies-body = Nokre sporarar vidarekoplar deg til andre nettstadar som i hemmelegheit stiller inn infokapslar. { -brand-short-name } fjernar no automatisk infokapslane slik at du ikkje kan bli spora.
cfr-whatsnew-clear-cookies-image-alt = Illustrasjon for blokkert infokapsel
