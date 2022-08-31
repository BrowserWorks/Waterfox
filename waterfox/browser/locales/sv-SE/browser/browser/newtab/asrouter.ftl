# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Rekommenderade tillägg
cfr-doorhanger-feature-heading = Rekommenderad funktion

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Varför ser jag detta
cfr-doorhanger-extension-cancel-button = Inte nu
    .accesskey = n
cfr-doorhanger-extension-ok-button = Lägg till nu
    .accesskey = L
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

## Waterfox Accounts Message

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
cfr-whatsnew-release-notes-link-text = Läs versionsfakta

## Enhanced Tracking Protection Milestones

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
cfr-doorhanger-milestone-close-button = Stäng
    .accesskey = S

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

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Videor på den här webbplatsen kanske inte spelas upp korrekt i den här versionen av { -brand-short-name }. Uppdatera { -brand-short-name } nu för fullständig videosupport.
cfr-doorhanger-video-support-header = Uppdatera { -brand-short-name } för att spela upp video
cfr-doorhanger-video-support-primary-button = Uppdatera nu
    .accesskey = U

## Spotlight modal shared strings

spotlight-learn-more-collapsed = Läs mer
    .title = Expandera för att läsa mer om denna funktionen
spotlight-learn-more-expanded = Läs mer
    .title = Stäng

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Det verkar som om du använder ett offentligt Wi-Fi
spotlight-public-wifi-vpn-body = För att dölja din plats och surfaktivitet, överväg ett virtuellt privat nätverk. Det hjälper dig att skydda dig när du surfar på offentliga platser som flygplatser och kaféer.
spotlight-public-wifi-vpn-primary-button = Håll dig privat med { -mozilla-vpn-brand-name }
    .accesskey = p
spotlight-public-wifi-vpn-link = Inte nu
    .accesskey = I

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header =
    Förhandstesta vår mest kraftfulla
    sekretessfunktion någonsin
spotlight-total-cookie-protection-body = Totalt skydd mot kakor stoppar spårare från att använda kakor för att följa dig på webben.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = { -brand-short-name } bygger ett staket runt kakor och begränsar dem till webbplatsen du är på så att spårare inte kan använda dem för att följa dig. Med tidig åtkomst hjälper du till att optimera den här funktionen så att vi kan fortsätta bygga en bättre webb för alla.
spotlight-total-cookie-protection-primary-button = Aktivera totalt skydd mot kakor
spotlight-total-cookie-protection-secondary-button = Inte nu
cfr-total-cookie-protection-header = Tack vare dig är { -brand-short-name } mer privat och säkrare än någonsin
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch". Only those who received it and accepted are shown this message.
cfr-total-cookie-protection-body = Totalt skydd mot kakor är vårt starkaste integritetsskydd hittills – och det är nu en standardinställning för { -brand-short-name } användare överallt. Vi hade inte kunnat göra det utan deltagare med tidig tillgång som du. Så tack för att du hjälper oss att skapa ett bättre, mer privat internet.

## Emotive Continuous Onboarding

spotlight-better-internet-header = Ett bättre internet börjar med dig
spotlight-better-internet-body = När du använder { -brand-short-name } röstar du för ett öppet och tillgängligt internet som är bättre för alla.
spotlight-peace-mind-header = Vi skyddar dig
spotlight-peace-mind-body = Varje månad blockerar { -brand-short-name } i genomsnitt över 3 000 spårare per användare. För ingenting, särskilt integritetsstörningar som spårare, ska stå mellan dig och det bra internet.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Behåll i Dock
       *[other] Fäst till aktivitetsfältet
    }
spotlight-pin-secondary-button = Inte nu
