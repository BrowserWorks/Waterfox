# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Ajánlott kiegészítő
cfr-doorhanger-feature-heading = Ajánlott szolgáltatás

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Miért látom ezt
cfr-doorhanger-extension-cancel-button = Most nem
    .accesskey = N
cfr-doorhanger-extension-ok-button = Hozzáadás most
    .accesskey = a
cfr-doorhanger-extension-manage-settings-button = Ajánlási beállítások kezelése
    .accesskey = A
cfr-doorhanger-extension-never-show-recommendation = Ne mutassa ezt az ajánlást
    .accesskey = N
cfr-doorhanger-extension-learn-more-link = További tudnivalók
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = szerző: { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Javaslat
cfr-doorhanger-extension-notification2 = Javaslat
    .tooltiptext = Kiegészítőjavaslat
    .a11y-announcement = Kiegészítőjavaslat érhető el
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Javaslat
    .tooltiptext = Funkciójavaslat
    .a11y-announcement = Funkciójavaslat érhető el

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } csillag
           *[other] { $total } csillag
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } felhasználó
       *[other] { $total } felhasználó
    }

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Szinkronizálja a könyvjelzőit mindenhol.
cfr-doorhanger-bookmark-fxa-body = Nagyszerű találat! Ne maradjon könyvjelzők nélkül a mobileszközein sem. Kezdjen egy { -fxaccount-brand-name }kal.
cfr-doorhanger-bookmark-fxa-link-text = Könyvjelzők szinkronizálása most…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Bezárás gomb
    .title = Bezárás

## Protections panel

cfr-protections-panel-header = Böngésszen anélkül, hogy követnék
cfr-protections-panel-body = Tartsa meg az adatait. A { -brand-short-name } megvédi a leggyakoribb nyomkövetőktől, amelyek követik az online tevékenységét.
cfr-protections-panel-link-text = További tudnivalók

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Új funkciók:
cfr-whatsnew-button =
    .label = Újdonságok
    .tooltiptext = Újdonságok
cfr-whatsnew-release-notes-link-text = Olvassa el a kiadási megjegyzéseket

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] A { -brand-short-name } több mint <b>{ $blockedCount }</b> követőt blokkolt { DATETIME($date, month: "long", year: "numeric") } óta!
       *[other] A { -brand-short-name } több mint <b>{ $blockedCount }</b> követőt blokkolt { DATETIME($date, month: "long", year: "numeric") } óta!
    }
cfr-doorhanger-milestone-ok-button = Összes megjelenítése
    .accesskey = m
cfr-doorhanger-milestone-close-button = Bezárás
    .accesskey = B

## DOH Message

cfr-doorhanger-doh-body = Számít az adatvédelem. A { -brand-short-name }, amikor csak lehet, biztonságosan továbbítja a DNS-kéréseit egy partnerszolgáltatóhoz, hogy megvédje Önt, miközben böngészik.
cfr-doorhanger-doh-header = Biztonságosabb, titkosított DNS-keresések
cfr-doorhanger-doh-primary-button-2 = Rendben
    .accesskey = R
cfr-doorhanger-doh-secondary-button = Letiltás
    .accesskey = t

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Számít az adatvédelme. A { -brand-short-name } mostantól elkülöníti egymástól a webhelyeket, ami megnehezíti a hackerek számára a jelszavak, bankkártyaszámok és egyéb kényes információk ellopását.
cfr-doorhanger-fission-header = Oldalak elkülönítése
cfr-doorhanger-fission-primary-button = Rendben, értem
    .accesskey = R
cfr-doorhanger-fission-secondary-button = További tudnivalók
    .accesskey = T

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Előfordulhat, hogy az oldalon található videók nem játszhatók le a { -brand-short-name } ezen verziójában. A teljes videótámogatásért frissítse most a { -brand-short-name(case: "accusative") }.
cfr-doorhanger-video-support-header = A videó lejátszásához frissítse a { -brand-short-name(case: "accusative") }
cfr-doorhanger-video-support-primary-button = Frissítés most
    .accesskey = F

## Spotlight modal shared strings

spotlight-learn-more-collapsed = További tudnivalók
    .title = Kinyitás, hogy többet tudjon meg a funkcióról
spotlight-learn-more-expanded = További tudnivalók
    .title = Bezárás

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Úgy néz ki, hogy nyilvános Wi-Fi-t használ
spotlight-public-wifi-vpn-body = A tartózkodási helye és a böngészési tevékenysége elrejtéséhez fontolja meg egy virtuális magánhálózat használatát. Ez segít megvédeni Önt, ha nyilvános helyen, például repülőtéren és kávézóban böngészik.
spotlight-public-wifi-vpn-primary-button = Maradjon privát a { -mozilla-vpn-brand-name } használatával
    .accesskey = M
spotlight-public-wifi-vpn-link = Most nem
    .accesskey = n

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header =
    Tesztelje az eddigi leghatékonyabb
    adatvédelmi élményt
spotlight-total-cookie-protection-body = A Teljes sütivédelem megakadályozza, hogy a nyomkövetők a sütiket arra használhassák, hogy kövessék a világhálón.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = A { -brand-short-name } kerítést épít a sütik köré, oly módon korlátozva őket, hogy a nyomkövetők ne használhassák az Ön követésére. A korai hozzáféréssel segít nekünk optimalizálni a funkciót, így egy mindenki számára jobb webet építhetünk.
spotlight-total-cookie-protection-primary-button = A Teljes sütivédelem bekapcsolása
spotlight-total-cookie-protection-secondary-button = Most nem
cfr-total-cookie-protection-header = Önnek köszönhetően a { -brand-short-name } privátabb és biztonságosabb, mint valaha
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch". Only those who received it and accepted are shown this message.
cfr-total-cookie-protection-body = A Teljes sütivédelem az eddigi legerősebb adatvédelmi megoldásunk – és mostantól mindenhol ez az alapértelmezett beállítás a { -brand-short-name }-felhasználók számára. Nem tudtuk volna megtenni az olyan korai hozzáférésű résztvevők nélkül, mint Ön. Ezért köszönjük, hogy segített egy jobb, privátabb internet létrehozásában.

## Emotive Continuous Onboarding

spotlight-better-internet-header = A jobb internet Önnel kezdődik
spotlight-better-internet-body = Amikor a { -brand-short-name(case: "accusative") } használja, akkor egy nyílt és hozzáférhető internetre szavaz, amely jobb mindenki számára.
spotlight-peace-mind-header = Fedezzük Önt
spotlight-peace-mind-body = Minden hónapban, a { -brand-short-name } átlagosan 3.000 nyomkövetőt blokkol felhasználónként. Mert semmi nem állhat Ön és a jó internet közé, az adatvédelmi szempontból aggályos követők különösen nem.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] A Dockban tartás
       *[other] Rögzítés a tálcára
    }
spotlight-pin-secondary-button = Most nem
