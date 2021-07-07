# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Rekommenderade tillägg
cfr-doorhanger-feature-heading = Rekommenderad funktion
cfr-doorhanger-pintab-heading = Prova detta: Fäst flik

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Varför ser jag detta
cfr-doorhanger-extension-cancel-button = Inte nu
    .accesskey = n
cfr-doorhanger-extension-ok-button = Lägg till nu
    .accesskey = L
cfr-doorhanger-pintab-ok-button = Fäst denna flik
    .accesskey = F
cfr-doorhanger-extension-manage-settings-button = Hantera rekommendationsinställningar
    .accesskey = H
cfr-doorhanger-extension-never-show-recommendation = Visa mig inte denna rekommendation
    .accesskey = V
cfr-doorhanger-extension-learn-more-link = Läs mer
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = av { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Rekommendation
cfr-doorhanger-extension-notification2 = Rekommendation
    .tooltiptext = Rekommendation av tillägg
    .a11y-announcement = Rekommendation av tillägg tillgänglig
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Rekommendation
    .tooltiptext = Funktionsrekommendation
    .a11y-announcement = Funktionsrekommendation tillgänglig

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } stjärna
           *[other] { $total } stjärnor
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } användare
       *[other] { $total } användare
    }
cfr-doorhanger-pintab-description = Få enkel åtkomst till dina mest använda webbplatser. Behåll webbplatser öppna i en flik (även när du startar om).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Högerklicka</b> på en av flikarna du vill fästa.
cfr-doorhanger-pintab-step2 = Välj <b>Fäst flik</b> från menyn.
cfr-doorhanger-pintab-step3 = Om webbplatsen har en uppdatering ser du en blå punkt på din fästa flik.
cfr-doorhanger-pintab-animation-pause = Pausa
cfr-doorhanger-pintab-animation-resume = Återuppta

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synkronisera dina bokmärken överallt.
cfr-doorhanger-bookmark-fxa-body = Bra fynd! Saknar du bokmärket på dina mobila enheter. Kom igång med ett { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Synkronisera bokmärken nu...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Stäng knapp
    .title = Stäng

## Protections panel

cfr-protections-panel-header = Surfa utan att bli följd
cfr-protections-panel-body = Behåll dina data för dig själv. { -brand-short-name } skyddar dig från många av de vanligaste spårarna som följer vad du gör online.
cfr-protections-panel-link-text = Läs mer

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Ny funktion:
cfr-whatsnew-button =
    .label = Vad är nytt
    .tooltiptext = Vad är nytt
cfr-whatsnew-panel-header = Vad är nytt
cfr-whatsnew-release-notes-link-text = Läs versionsfakta
cfr-whatsnew-fx70-title = { -brand-short-name } kämpar ännu mer för din integritet
cfr-whatsnew-fx70-body =
    Den senaste uppdateringen förbättrar funktionen Spårningsskydd och gör det
    lättare än någonsin att skapa säkra lösenord för varje webbplats.
cfr-whatsnew-tracking-protect-title = Skydda dig från spårare
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } blockerar många vanliga sociala och globala spårare som
    följer vad du gör online.
cfr-whatsnew-tracking-protect-link-text = Visa din rapport
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Spårare blockerad
       *[other] Spårare blockerade
    }
cfr-whatsnew-tracking-blocked-subtitle = Sedan { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Visa rapport
cfr-whatsnew-lockwise-backup-title = Säkerhetskopiera dina lösenord
cfr-whatsnew-lockwise-backup-body = Generera nu säkra lösenord som du kan komma åt var du än loggar in.
cfr-whatsnew-lockwise-backup-link-text = Slå på säkerhetskopior
cfr-whatsnew-lockwise-take-title = Ta dina lösenord med dig
cfr-whatsnew-lockwise-take-body =
    Mobilappen { -lockwise-brand-short-name } låter dig säkert komma åt din
    säkerhetskopierade lösenord var som helst.
cfr-whatsnew-lockwise-take-link-text = Hämta appen

## Search Bar

cfr-whatsnew-searchbar-title = Skriv mindre, hitta mer med adressfältet
cfr-whatsnew-searchbar-body-topsites = Välj adressfältet och en ruta kommer att utvidgas med länkar till dina mest besökta webbplatser.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Förstoringsglasikonen

## Picture-in-Picture

cfr-whatsnew-pip-header = Titta på videor medans du surfar
cfr-whatsnew-pip-body = Bild-i-bild visar upp en video i ett flytande fönster så att du kan titta medans du arbetar i andra flikar.
cfr-whatsnew-pip-cta = Läs mer

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Färre irriterande popup-fönster
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } blockerar nu webbplatser från att automatiskt fråga dig om att skicka popup-meddelanden.
cfr-whatsnew-permission-prompt-cta = Läs mer

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Fingeravtrycksspårare blockerade
       *[other] Fingeravtrycksspårare blockerade
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } blockerar många fingeravtrycksspårare som i hemlighet samlar in information om din enhet och åtgärder för att skapa en reklamprofil av dig.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Fingeravtrycksspårare
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } kan blockera många fingeravtrycksspårare som i hemlighet samlar in information om din enhet och åtgärder för att skapa en reklamprofil av dig.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Få det här bokmärket på din telefon
cfr-doorhanger-sync-bookmarks-body = Ta med dig dina bokmärken, lösenord, historik, med mera överallt där du är inloggad på { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Slå på { -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = Förlora aldrig ett lösenord igen
cfr-doorhanger-sync-logins-body = Lagra och synkronisera dina lösenord på ett säkert sätt på alla dina enheter.
cfr-doorhanger-sync-logins-ok-button = Slå på { -sync-brand-short-name }
    .accesskey = S

## Send Tab

cfr-doorhanger-send-tab-header = Läs detta var du än är
cfr-doorhanger-send-tab-recipe-header = Ta med det här receptet till köket
cfr-doorhanger-send-tab-body = Send Tab låter dig enkelt dela den här länken till din telefon eller var du än är inloggad på { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Prova Send Tab
    .accesskey = S

## Firefox Send

cfr-doorhanger-firefox-send-header = Dela denna PDF säkert
cfr-doorhanger-firefox-send-body = Håll dina känsliga dokument säkra från nyfikna ögon med end-to-end-kryptering och en länk som försvinner när du är klar.
cfr-doorhanger-firefox-send-ok-button = Prova { -send-brand-name }
    .accesskey = P

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Se skydd
    .accesskey = S
cfr-doorhanger-socialtracking-close-button = Stäng
    .accesskey = S
cfr-doorhanger-socialtracking-dont-show-again = Visa mig inte meddelanden som dessa igen
    .accesskey = V
cfr-doorhanger-socialtracking-heading = { -brand-short-name } hindrade ett socialt nätverk från att spåra dig här
cfr-doorhanger-socialtracking-description = Din integritet är viktig. { -brand-short-name } blockerar nu vanliga spårare för sociala medier, vilket begränsar hur mycket data de kan samla in om vad du gör online.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } blockerade en fingeravtrycksspårare på den här sidan
cfr-doorhanger-fingerprinters-description = Din integritet är viktig. { -brand-short-name } blockerar nu fingeravtrycksspårare, som samlar in delar av unik identifierbar information om din enhet för att spåra dig.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } blockerade en kryptogrävare på den här sidan
cfr-doorhanger-cryptominers-description = Din integritet är viktig. { -brand-short-name } blockerar nu kryptogrävare, som använder ditt systems datakraft för att utvinna digitala pengar.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } blockerade <b>{ $blockedCount }</b> spårare sedan { $date }!
       *[other] { -brand-short-name } blockerade över <b>{ $blockedCount }</b> spårare sedan { $date }!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] { -brand-short-name } blockerade <b>{ $blockedCount }</b> spårare sedan { DATETIME($date, month: "long", year: "numeric") }!
       *[other] { -brand-short-name } blockerade över <b>{ $blockedCount }</b> spårare sedan { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = Visa alla
    .accesskey = V

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Skapa säkra lösenord enkelt
cfr-whatsnew-lockwise-body = Det är svårt att tänka ut unika, säkra lösenord för varje konto. När du skapar ett lösenord väljer du lösenordsfältet för att använda ett säkert, genererat lösenord från { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } ikon

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Få varningar om sårbara lösenord
cfr-whatsnew-passwords-body = Hackare vet att människor återanvänder samma lösenord. Om du använder samma lösenord på flera webbplatser och en av dessa webbplatser vart med om ett dataintrång, ser du en varning i { -lockwise-brand-short-name } att du behöver ändra ditt lösenord på dessa webbplatser.
cfr-whatsnew-passwords-icon-alt = Ikon för sårbar lösenordsnyckel

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Ta bild-i-bild helskärm
cfr-whatsnew-pip-fullscreen-body = När du placerar en video i ett flytande fönster kan du nu dubbelklicka på det fönstret för att gå till helskärm.
cfr-whatsnew-pip-fullscreen-icon-alt = Ikon för bild-i-bild

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Stäng
    .accesskey = S

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Överblick över skydd
cfr-whatsnew-protections-body = Skyddsöversikten innehåller sammanfattande rapporter om dataintrång och lösenordshantering. Du kan nu spåra hur många intrång du har löst och se om något av dina sparade lösenord kan ha blivit exponerat i ett dataintrång.
cfr-whatsnew-protections-cta-link = Visa säkerhetsöversikt
cfr-whatsnew-protections-icon-alt = Sköldikon

## Better PDF message

cfr-whatsnew-better-pdf-header = Bättre PDF-upplevelse
cfr-whatsnew-better-pdf-body = PDF-dokument öppnas nu direkt i { -brand-short-name } och håller ditt arbetsflöde inom räckhåll.

## DOH Message

cfr-doorhanger-doh-body = Din integritet är viktig. { -brand-short-name } dirigerar nu dina DNS-uppslag säkert, när det är möjligt, till en partnerservice för att skydda dig medan du surfar.
cfr-doorhanger-doh-header = Säkrare, krypterade DNS-uppslag
cfr-doorhanger-doh-primary-button-2 = Okej
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Inaktivera
    .accesskey = I

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Din integritet är viktig. { -brand-short-name } isolerar nu webbplatser från varandra, vilket gör det svårare för hackare att stjäla lösenord, kreditkortsnummer och annan känslig information.
cfr-doorhanger-fission-header = Webbplatsisolering
cfr-doorhanger-fission-primary-button = Ok, jag förstår
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Läs mer
    .accesskey = L

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Automatiskt skydd mot lömsk spårningstaktik
cfr-whatsnew-clear-cookies-body = Vissa spårare omdirigerar dig till andra webbplatser som i hemlighet ställer in kakor. { -brand-short-name } rensar nu automatiskt de kakorna så att du inte kan följas.
cfr-whatsnew-clear-cookies-image-alt = Kaka blockerade illustration

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Fler mediekontroller
cfr-whatsnew-media-keys-body = Spela upp och pausa ljud eller video direkt från tangentbordet eller headsetet, vilket gör det enkelt att styra media från en annan flik, ett annat program eller till och med när din dator är låst. Du kan också flytta mellan spår med framåt- och bakåtknapparna.
cfr-whatsnew-media-keys-button = Lär dig hur

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Sökgenvägar i adressfältet
cfr-whatsnew-search-shortcuts-body = När du nu skriver en sökmotor eller specifik webbplats i adressfältet visas en blå genväg i sökförslagen nedan. Välj den genvägen för att slutföra din sökning direkt från adressfältet.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Skydd mot skadliga superkakor
cfr-whatsnew-supercookies-body = Webbplatser kan i hemlighet lägga till en "superkaka" i din webbläsare som kan följa dig runt på nätet, även efter att du har rensat dina kakor. { -brand-short-name } ger nu starkt skydd mot superkakor så att de inte kan användas för att spåra dina onlineaktiviteter från en webbplats till en annan.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Bättre bokmärkning
cfr-whatsnew-bookmarking-body = Det är lättare att hålla koll på dina favoritsidor. { -brand-short-name } kommer nu ihåg din önskade plats för sparade bokmärken, visar bokmärkesverktygsfältet som standard på nya flikar och ger dig enkel åtkomst till resten av dina bokmärken via en verktygsfältmapp.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Omfattande skydd mot spårning av globala kakor
cfr-whatsnew-cross-site-tracking-body = Du kan nu välja bättre skydd mot kakspårning. { -brand-short-name } kan isolera dina aktiviteter och data till den webbplats du befinner dig på, så att information som lagras i webbläsaren inte delas mellan webbplatser.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Videor på den här webbplatsen kanske inte spelas upp korrekt i den här versionen av { -brand-short-name }. Uppdatera { -brand-short-name } nu för fullständig videosupport.
cfr-doorhanger-video-support-header = Uppdatera { -brand-short-name } för att spela upp video
cfr-doorhanger-video-support-primary-button = Uppdatera nu
    .accesskey = U
