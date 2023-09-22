# This Source Code Form is subject to the terms of the BrowserWorks Public
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

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Előfordulhat, hogy az oldalon található videók nem játszhatók le a { -brand-short-name } ezen verziójában. A teljes videótámogatásért frissítse most a { -brand-short-name(case: "accusative") }.
cfr-doorhanger-video-support-header = A videó lejátszásához frissítse a { -brand-short-name(case: "accusative") }
cfr-doorhanger-video-support-primary-button = Frissítés most
    .accesskey = F

## Spotlight modal shared strings

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the BrowserWorks VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Úgy néz ki, hogy nyilvános Wi-Fi-t használ
spotlight-public-wifi-vpn-body = A tartózkodási helye és a böngészési tevékenysége elrejtéséhez fontolja meg egy virtuális magánhálózat használatát. Ez segít megvédeni Önt, ha nyilvános helyen, például repülőtéren és kávézóban böngészik.
spotlight-public-wifi-vpn-primary-button = Maradjon privát a { -mozilla-vpn-brand-name } használatával
    .accesskey = M
spotlight-public-wifi-vpn-link = Most nem
    .accesskey = n

## Total Cookie Protection Rollout

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

mr2022-background-update-toast-title = Új { -brand-short-name }. Még privátabb. Kevesebb nyomkövető. Kompromisszumok nélkül.
mr2022-background-update-toast-text = Próbálja ki most a legújabb { -brand-short-name } verziót, amely az eddigi legerősebb nyomkövetés elleni védelmünkkel rendelkezik.

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it
# using a variable font like Arial): the button can only fit 1-2
# additional characters, exceeding characters will be truncated.
mr2022-background-update-toast-primary-button-label = A { -brand-shorter-name } megnyitása most

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it using a
# variable font like Arial): the button can only fit 1-2 additional characters,
# exceeding characters will be truncated.
mr2022-background-update-toast-secondary-button-label = Figyelmeztetés később

## Waterfox View CFR

firefoxview-cfr-primarybutton = Próbálja ki
    .accesskey = P
firefoxview-cfr-secondarybutton = Most nem
    .accesskey = n
firefoxview-cfr-header-v2 = Folytassa gyorsan ott, ahol abbahagyta
firefoxview-cfr-body-v2 = Szerezze vissza a nemrég bezárt lapokat, és zökkenőmentesen váltson az eszközök között a { -firefoxview-brand-name } segítségével.

## Waterfox View Spotlight

firefoxview-spotlight-promo-title = Köszöntse a { -firefoxview-brand-name }t

# “Poof” refers to the expression to convey when something or someone suddenly disappears, or in this case, reappears. For example, “Poof, it’s gone.”
firefoxview-spotlight-promo-subtitle = Szeretné ezt a nyitott lapot a telefonján? Vegye át. Szüksége van arra az oldalra, amelyet most látogatott meg? Puff, vissza is jött a { -firefoxview-brand-name }sel.
firefoxview-spotlight-promo-primarybutton = Nézze meg a működését
firefoxview-spotlight-promo-secondarybutton = Kihagyás

## Colorways expiry reminder CFR

colorways-cfr-primarybutton = Válasszon színvilágot
    .accesskey = V

# "shades" refers to the different color options available to users in colorways.
colorways-cfr-body = Színezze böngészőjét a { -brand-short-name } exkluzív árnyalataival, amelyeket a kultúrát megváltoztató hangok ihlettek.
colorways-cfr-header-28days = A „Független hangok” színvilágok január 16-án járnak le
colorways-cfr-header-14days = A „Független hangok” színvilágok két hét múlva járnak le
colorways-cfr-header-7days = A „Független hangok” színvilágok a héten járnak le
colorways-cfr-header-today = A „Független hangok” színvilágok ma járnak le

## Cookie Banner Handling CFR

cfr-cbh-header = Engedélyezi a { -brand-short-name } számára a sütibannerek elutasítását?
cfr-cbh-body = A { -brand-short-name } automatikusan elutasíthat számos sütibanneres kérést.
cfr-cbh-confirm-button = Sütibannerek elutasítása
    .accesskey = u
cfr-cbh-dismiss-button = Most nem
    .accesskey = n

## These strings are used in the Fox doodle Pin/set default spotlights

july-jam-headline = Fedezzük Önt
july-jam-body = A { -brand-short-name } havonta átlagosan több mint 3000 nyomkövetőt blokkol felhasználónként, így biztonságos és gyors hozzáférést biztosít a jó internethez.
july-jam-set-default-primary = Saját hivatkozások megnyitása a { -brand-short-name(case: "instrumental") }
fox-doodle-pin-headline = Üdvözöljük újra

# “indie” is short for the term “independent”.
# In this instance, free from outside influence or control.
fox-doodle-pin-body = Itt egy gyors emlékeztető, hogy egyetlen kattintásnyira tudhatja kedvenc független böngészőjét.
fox-doodle-pin-primary = Saját hivatkozások megnyitása a { -brand-short-name(case: "instrumental") }
fox-doodle-pin-secondary = Most nem

## These strings are used in the Set Waterfox as Default PDF Handler for Existing Users experiment

set-default-pdf-handler-headline = <strong>A PDF-jei mostantól a { -brand-short-name }szal nyílnak meg.</strong> Szerkessze vagy írja alá az űrlapokat közvetlenül a böngészőjében. A módosításhoz keressen a „PDF” kifejezésre a beállításokban.
set-default-pdf-handler-primary = Megértettem

## FxA sync CFR

fxa-sync-cfr-header = Új eszköz a jövőben?
fxa-sync-cfr-body = Győződjön meg arról, hogy a legfrissebb könyvjelzőit, jelszavait és lapjait magával viszi, amikor új { -brand-product-name } böngészőt nyit meg.
fxa-sync-cfr-primary = További tudnivalók
    .accesskey = T
fxa-sync-cfr-secondary = Figyelmeztetés később
    .accesskey = F

## Device Migration FxA Spotlight

device-migration-fxa-spotlight-header = Régebbi eszközt használ?
device-migration-fxa-spotlight-body = Készítsen biztonsági mentést az adatairól, hogy ne veszítsen el olyan fontos információkat, mint a könyvjelzők és a jelszavak – különösen, ha új eszközre vált.
device-migration-fxa-spotlight-primary-button = Hogyan kell biztonsági mentést készíteni az adatokról
device-migration-fxa-spotlight-link = Figyelmeztetés később
