# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Ajánlott kiegészítő
cfr-doorhanger-feature-heading = Ajánlott szolgáltatás
cfr-doorhanger-pintab-heading = Próbálja ki ezt: Lap rögzítése

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Miért látom ezt
cfr-doorhanger-extension-cancel-button = Most nem
    .accesskey = N
cfr-doorhanger-extension-ok-button = Hozzáadás most
    .accesskey = a
cfr-doorhanger-pintab-ok-button = Lap rögzítése
    .accesskey = r
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
cfr-doorhanger-pintab-description = Kapjon könnyű hozzáférést a leggyakrabban használt webhelyekhez. Tartsa nyitva a webhelyeket egy lapon (akkor is, ha újraindítja a böngészőt).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Kattintson a jobb egérgombbal</b> a rögzítendő lapra.
cfr-doorhanger-pintab-step2 = Válassza a <b>Lap rögzítése</b> lehetőséget a menüből.
cfr-doorhanger-pintab-step3 = Ha a webhely frissült, akkor egy kék pont jelenik meg a rögzített lapon.
cfr-doorhanger-pintab-animation-pause = Szünet
cfr-doorhanger-pintab-animation-resume = Folytatás

## Firefox Accounts Message

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
cfr-whatsnew-panel-header = Újdonságok
cfr-whatsnew-release-notes-link-text = Olvassa el a kiadási megjegyzéseket
cfr-whatsnew-fx70-title = A { -brand-short-name } mostantól még keményebben küzd az adatvédelemért
cfr-whatsnew-fx70-body =
    A legújabb frissítés továbbfejleszti a Követésvédelem funkciót, és könnyebbé
    teszi a biztonságos jelszavak létrehozását, mint valaha, minden oldalon.
cfr-whatsnew-tracking-protect-title = Védje magát a nyomkövetőktől
cfr-whatsnew-tracking-protect-body =
    A { -brand-short-name } számos közismert közösségi média és weboldalak közti
    nyomkövetőt blokkol, melyek követik Önt online.
cfr-whatsnew-tracking-protect-link-text = Tekintse meg a jelentését
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Követő blokkolva
       *[other] Követők blokkolva
    }
cfr-whatsnew-tracking-blocked-subtitle = { DATETIME($earliestDate, month: "long", year: "numeric") } óta
cfr-whatsnew-tracking-blocked-link-text = Jelentés megtekintése
cfr-whatsnew-lockwise-backup-title = Készítsen biztonsági másolatot a jelszavairól
cfr-whatsnew-lockwise-backup-body = Állítson elő biztonságos jelszavakat, amelyeket elérhet, bárhol is jelentkezzen be.
cfr-whatsnew-lockwise-backup-link-text = Kapcsolja be a biztonsági mentéseket
cfr-whatsnew-lockwise-take-title = Vigye magával a jelszavait
cfr-whatsnew-lockwise-take-body = A { -lockwise-brand-short-name } mobilalkalmazással bárhol biztonságosan hozzáférhet a jelszavaihoz.
cfr-whatsnew-lockwise-take-link-text = Alkalmazás beszerzése

## Search Bar

cfr-whatsnew-searchbar-title = Gépeljen kevesebbet, találjon meg több mindent a címsorban
cfr-whatsnew-searchbar-body-topsites = Most válassza ki a címsort, és a doboz kibővül a legnépszerűbb webhelyeire mutató hivatkozásokkal.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Nagyító ikon

## Picture-in-Picture

cfr-whatsnew-pip-header = Nézzen videókat böngészés közben
cfr-whatsnew-pip-body = A kép a képben mód egy lebegő ablakba teszi a videót, így nézheti, miközben más lapokon dolgozik.
cfr-whatsnew-pip-cta = További tudnivalók

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Kevesebb idegesítő felugró ablak
cfr-whatsnew-permission-prompt-body = A { -brand-shorter-name } most már blokkolja azokat az oldalakat, melyek automatikusan azt kérik, hogy felugró üzeneteket küldjenek.
cfr-whatsnew-permission-prompt-cta = További tudnivalók

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Ujjlenyomat-készítő blokkolva
       *[other] Ujjlenyomat-készítők blokkolva
    }
cfr-whatsnew-fingerprinter-counter-body = A { -brand-shorter-name } számos ujjlenyomat-készítőt blokkol, amelyek titokban információt gyűjtenek az eszközéről és a műveleteiről, hogy hirdetési profilt építsenek Önről.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Ujjlenyomat-készítők
cfr-whatsnew-fingerprinter-counter-body-alt = A { -brand-shorter-name } képes blokkolni az ujjlenyomat-készítőket, amelyek titokban információt gyűjtenek az eszközéről és a műveleteiről, hogy hirdetési profilt építsenek Önről.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Vigye át ezt a könyvjelzőt a telefonjára
cfr-doorhanger-sync-bookmarks-body = Vigye magával a könyvjelzőit, jelszavait, előzményeit és egyebeit bárhová, ahol be van jelentkezve a { -brand-product-name }be.
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name } bekapcsolása
    .accesskey = b

## Login Sync

cfr-doorhanger-sync-logins-header = Ne veszítsen el egyetlen jelszót sem
cfr-doorhanger-sync-logins-body = Tárolja biztonságosan, és szinkronizálja a jelszavait az összes eszközén.
cfr-doorhanger-sync-logins-ok-button = A { -sync-brand-short-name } bekapcsolása
    .accesskey = k

## Send Tab

cfr-doorhanger-send-tab-header = Olvassa el ezt útközben
cfr-doorhanger-send-tab-recipe-header = Vigye a konyhába ezt a receptet
cfr-doorhanger-send-tab-body = A Lap küldése segítségével könnyedén megoszthatja ezt a hivatkozást a telefonjával, vagy elküldheti bárhová, ahol be van jelentkezve a { -brand-product-name }be.
cfr-doorhanger-send-tab-ok-button = Próbálja ki a Lap küldését
    .accesskey = P

## Firefox Send

cfr-doorhanger-firefox-send-header = Ossza meg biztonságosan ezt a PDF-fájlt
cfr-doorhanger-firefox-send-body = Tartsa biztonságban a bizalmas dokumentumait a kíváncsi szemek elől a végpontok közötti titkosítással, és a hivatkozással, amely eltűnik, ha végzett.
cfr-doorhanger-firefox-send-ok-button = Próbálja ki a { -send-brand-name }et
    .accesskey = P

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Lásd: Adatvédelem
    .accesskey = A
cfr-doorhanger-socialtracking-close-button = Bezárás
    .accesskey = B
cfr-doorhanger-socialtracking-dont-show-again = Ne jelenítse meg ezeket az üzeneteket többet
    .accesskey = N
cfr-doorhanger-socialtracking-heading = A { -brand-short-name } megakadályozta, hogy egy közösségi hálózat kövesse itt
cfr-doorhanger-socialtracking-description = Számít az adatvédelem. A { -brand-short-name } most már blokkolja a gyakori közösségimédia-követőket, korlátozva hogy mennyi adatot gyűjthessenek az Ön online tevékenységéről.
cfr-doorhanger-fingerprinters-heading = A { -brand-short-name } blokkolt egy ujjlenyomat-készítőt ezen az oldalon
cfr-doorhanger-fingerprinters-description = Számít az adatvédelem. A { -brand-short-name } most már blokkolja az ujjlenyomat-készítőket, melyek egyedileg azonosítható információkat gyűjtenek az eszközéről, hogy követhessék Önt.
cfr-doorhanger-cryptominers-heading = A { -brand-short-name } blokkolt egy kriptobányászt ezen az oldalon
cfr-doorhanger-cryptominers-description = Számít az adatvédelem. A { -brand-short-name } most már blokkolja a kriptobányászokat, melyek a rendszere számítási erőforrásait használják, hogy digitális pénzeket bányásszanak.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] A { -brand-short-name } több mint <b>{ $blockedCount }</b> követőt blokkolt { $date } óta!
       *[other] A { -brand-short-name } több mint <b>{ $blockedCount }</b> követőt blokkolt { $date } óta!
    }
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

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Hozzon létre könnyedén biztonságos jelszavakat
cfr-whatsnew-lockwise-body = Nehéz minden fiókhoz egyedi, biztonságos jelszót kitalálni. Jelszó létrehozásakor válassza ki a jelszómezőt, hogy biztonságos, generált jelszót használjon a { -brand-shorter-name }ból.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } ikon

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Kapjon figyelmeztetéseket a sebezhető jelszavakról
cfr-whatsnew-passwords-body = A hackerek tudják, hogy az emberek többször is ugyanazt a jelszót használják. Ha ugyanazt a jelszót használta több webhelyen, és az egyik ilyen weboldalon adatsértés történt, akkor a { -lockwise-brand-short-name } figyelmeztetést jelenít meg a jelszó megváltoztatásához ezeken a webhelyeken.
cfr-whatsnew-passwords-icon-alt = Sebezhető jelszó kulcs ikonja

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Tegye teljes képernyőre a kép a képben funkciót
cfr-whatsnew-pip-fullscreen-body = Ha egy videót lebegő ablakba tesz, akkor most már dupla kattintással teljes képernyőjűvé teheti az ablakot.
cfr-whatsnew-pip-fullscreen-icon-alt = Kép a képben ikon

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Bezárás
    .accesskey = B

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = A védelmekről röviden
cfr-whatsnew-protections-body = A Védelmi vezérlőpult összefoglaló jelentéseket tartalmaz az adatsértésekről és a jelszókezelésről. Most már nyomon tudja követni, hogy hány adatsértés történt, és megnézheti, hogy a mentett jelszavai megjelentek-e egy adatsértésben.
cfr-whatsnew-protections-cta-link = Védelmi vezérlőpult megtekintése
cfr-whatsnew-protections-icon-alt = Pajzs ikon

## Better PDF message

cfr-whatsnew-better-pdf-header = Jobb PDF-élmény
cfr-whatsnew-better-pdf-body = A PDF-dokumentumok már közvetlenül a { -brand-short-name }ban nyílnak meg, így a munkafolyamata egyszerű maradhat.

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

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Automatikus védelem az alattomos követési taktikákkal szemben
cfr-whatsnew-clear-cookies-body = Egyes nyomkövetők más weboldalakra irányítják át, melyek titokban sütiket állítanak be. A { -brand-short-name } most már automatikusa törli ezeket a sütiket, így nem tudják követni Önt.
cfr-whatsnew-clear-cookies-image-alt = Sütiblokkolási illusztráció

## What's new: Media controls message

cfr-whatsnew-media-keys-header = További médiavezérlők
cfr-whatsnew-media-keys-body = Lejátszhatja és szüneteltetheti a hangot vagy a videót közvetlenül a billentyűzetről vagy a fejhallgatóról, megkönnyítve ezzel a média vezérlését egy másik lapról, programból vagy akár akkor is, ha a számítógép zárolt. A számok között az előre és a vissza gombokkal válthat.
cfr-whatsnew-media-keys-button = Tudja meg, hogyan

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Gyors keresések a címsávban
cfr-whatsnew-search-shortcuts-body = Ha most beír egy keresőszolgáltatás vagy egy konkrét oldal nevét a címsávba, akkor egy kék ikon fog alatta megjelenni a keresési javaslatoknál. Válassza ki a gyorskeresőt, hogy befejezze a keresést közvetlenül a címsávból.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Védelem a rosszindulatú szupersütik ellen
cfr-whatsnew-supercookies-body = A webhelyek titkon „szupersütit” csatolhatnak böngészőjéhez, amely nyomon követheti Önt az interneten, még a sütik törlése után is. A { -brand-short-name } most már erős védelmet nyújt a szupersütikkel szemben, így azokat nem lehet a webhelyek közti online tevékenysége nyomon követésére használni.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Jobb könyvjelzőkezelés
cfr-whatsnew-bookmarking-body = Könnyebb nyomon követni kedvenc webhelyeit. A { -brand-short-name } most megjegyzi az elmentett könyvjelzői kedvelt helyét, alapértelmezés szerint megjeleníti a könyvjelzők eszköztárat az új lapokon, s az eszköztármappán keresztül könnyen hozzáférhet a többi könyvjelzőhöz.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Átfogó védelem a webhelyek közötti sütik követése ellen
cfr-whatsnew-cross-site-tracking-body = Mostantól jobban védve lehet a sütik általi nyomon követéstől. A { -brand-short-name } elkülönítheti tevékenységeit és adatait az épp használt weblaptól, így a böngészőben tárolt információ nem kerül webhelyközi megosztásra.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Előfordulhat, hogy az oldalon található videók nem játszhatók le a { -brand-short-name } ezen verziójában. A teljes videótámogatásért frissítse most a { -brand-short-name }ot.
cfr-doorhanger-video-support-header = A videó lejátszásához frissítse a { -brand-short-name }ot
cfr-doorhanger-video-support-primary-button = Frissítés most
    .accesskey = F
