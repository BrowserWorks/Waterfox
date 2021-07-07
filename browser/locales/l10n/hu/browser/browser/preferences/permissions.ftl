# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

permissions-window =
    .title = Kivételek
    .style = width: 55em
permissions-close-key =
    .key = w
permissions-address = Weboldal címe
    .accesskey = o
permissions-block =
    .label = Tiltás
    .accesskey = T
permissions-session =
    .label = Engedélyezés a munkamenetben
    .accesskey = m
permissions-allow =
    .label = Engedélyezés
    .accesskey = E
permissions-button-off =
    .label = Kikapcsolás
    .accesskey = K
permissions-button-off-temporarily =
    .label = Ideiglenes kikapcsolás
    .accesskey = I
permissions-site-name =
    .label = Weboldal
permissions-status =
    .label = Állapot
permissions-remove =
    .label = Weboldal eltávolítása
    .accesskey = v
permissions-remove-all =
    .label = Minden weboldal eltávolítása
    .accesskey = M
permissions-button-cancel =
    .label = Mégse
    .accesskey = M
permissions-button-ok =
    .label = Változtatások mentése
    .accesskey = V
permission-dialog =
    .buttonlabelaccept = Változtatások mentése
    .buttonaccesskeyaccept = V
permissions-autoplay-menu = Alapértelmezés az összes webhelyhez:
permissions-searchbox =
    .placeholder = Weboldal keresése
permissions-capabilities-autoplay-allow =
    .label = Hang és videó engedélyezése
permissions-capabilities-autoplay-block =
    .label = Hang blokkolása
permissions-capabilities-autoplay-blockall =
    .label = Hang és videó blokkolása
permissions-capabilities-allow =
    .label = Engedélyezés
permissions-capabilities-block =
    .label = Tiltás
permissions-capabilities-prompt =
    .label = Rákérdezés mindig
permissions-capabilities-listitem-allow =
    .value = Engedélyezés
permissions-capabilities-listitem-block =
    .value = Tiltás
permissions-capabilities-listitem-allow-session =
    .value = Engedélyezés a munkamenetben
permissions-capabilities-listitem-off =
    .value = Ki
permissions-capabilities-listitem-off-temporarily =
    .value = Ideiglenesen ki

## Invalid Hostname Dialog

permissions-invalid-uri-title = Érvénytelen gépnév
permissions-invalid-uri-label = Írjon be egy érvényes gépnevet.

## Exceptions - Tracking Protection

permissions-exceptions-etp-window =
    .title = Kivételek a fokozott követés elleni védelemhez
    .style = { permissions-window.style }
permissions-exceptions-etp-desc = Ezeken a webhelyeken kikapcsolta a védelmeket.

## Exceptions - Cookies

permissions-exceptions-cookie-window =
    .title = Kivételek – Sütik és oldaladatok
    .style = { permissions-window.style }
permissions-exceptions-cookie-desc = Megadhatja mely webhelyek nem használhatnak soha sütiket és oldaladatokat, illetve melyek használhatnak mindig. Írja be a kezelendő oldal pontos címét, majd kattintson a Tiltás, Engedélyezés a munkamenetben, vagy az Engedélyezés gombra.

## Exceptions - HTTPS-Only Mode

permissions-exceptions-https-only-window =
    .title = Kivételek – Csak HTTPS mód
    .style = { permissions-window.style }
permissions-exceptions-https-only-desc = Az egyes webhelyeknél kikapcsolhatja a Csak HTTPS módot. A { -brand-short-name } nem próbálja meg biztonságos HTTPS-re frissíteni a kapcsolatot ezeknél a webhelyeknél. A kivételek nem vonatkoznak a privát ablakokra.

## Exceptions - Pop-ups

permissions-exceptions-popup-window =
    .title = Engedélyezett webhelyek – Felugró ablakok
    .style = { permissions-window.style }
permissions-exceptions-popup-desc = Megadhatja azokat a webhelyeket, amelyek felugró ablakot nyithatnak. Írja be a kezelni kívánt webhely pontos nevét, majd kattintson az Engedélyezés gombra.

## Exceptions - Saved Logins

permissions-exceptions-saved-logins-window =
    .title = Kivételek – mentett bejelentkezések
    .style = { permissions-window.style }
permissions-exceptions-saved-logins-desc = A bejelentkezések a következő oldalakhoz nem lesznek mentve

## Exceptions - Add-ons

permissions-exceptions-addons-window =
    .title = Engedélyezett webhelyek – Kiegészítők telepítése
    .style = { permissions-window.style }
permissions-exceptions-addons-desc = Megadhatja azokat a webhelyeket, amelyekről engedélyezett a kiegészítők telepítése. Írja be a kezelni kívánt webhely pontos nevét, majd kattintson az Engedélyezés gombra.

## Site Permissions - Autoplay

permissions-site-autoplay-window =
    .title = Beállítások – Automatikus lejátszás
    .style = { permissions-window.style }
permissions-site-autoplay-desc = Itt kezelheti azokat a webhelyeket, amelyek nem követik az alapértelmezett automatikus lejátszási beállításokat.

## Site Permissions - Notifications

permissions-site-notification-window =
    .title = Beállítások – Értesítési engedélyek
    .style = { permissions-window.style }
permissions-site-notification-desc = A következő weboldalak kérték, hogy küldhessenek értesítéseket. Megadhatja, hogy mely weboldalak küldhetnek értesítéseket. Az új értesítés engedélyezési kéréseket is blokkolhatja.
permissions-site-notification-disable-label =
    .label = Új értesítés engedélyezési kérések blokkolása
permissions-site-notification-disable-desc = Ez megakadályozza, hogy a fent fel nem sorolt weboldalak értesítésküldést kérjenek. Az értesítések blokkolása működésképtelenné tehet néhány weboldal-funkciót.

## Site Permissions - Location

permissions-site-location-window =
    .title = Beállítások – Tartózkodási hely engedélyek
    .style = { permissions-window.style }
permissions-site-location-desc = A következő weboldalak a helyadatait kérték. Megadhatja, hogy mely weboldalak érhetik el a tartózkodási helyét. Az új helyadat-kéréseket is blokkolhatja.
permissions-site-location-disable-label =
    .label = Új tartózkodási hely kérések blokkolása
permissions-site-location-disable-desc = Ez megakadályozza, hogy a fent fel nem sorolt weboldalak helyadatokat kérjenek. A helyadatok blokkolása működésképtelenné tehet néhány weboldal-funkciót.

## Site Permissions - Virtual Reality

permissions-site-xr-window =
    .title = Beállítások – Virtuális valóság engedélyek
    .style = { permissions-window.style }
permissions-site-xr-desc = A következő weboldalak hozzáférést kértek a virtuális valóság eszközeihez. Megadhatja, hogy mely weboldalak érhetik el a virtuális valóság eszközeit. Az új virtuális valóság eszközkéréseket is blokkolhatja.
permissions-site-xr-disable-label =
    .label = Új virtuális valóság eszközkérések blokkolása
permissions-site-xr-disable-desc = Ez megakadályozza, hogy a fent fel nem sorolt weboldalak engedélyt kérjenek a virtuális valóság eszközeihez. A virtuális valóság eszközök blokkolása működésképtelenné tehet néhány weboldal-funkciót.

## Site Permissions - Camera

permissions-site-camera-window =
    .title = Beállítások – Kamera engedélyek
    .style = { permissions-window.style }
permissions-site-camera-desc = A következő weboldalak kérték, hogy hozzáférhessenek a kamerájához. Megadhatja, hogy mely weboldalak férjenek hozzá a kamerájához. Az új kamera hozzáférési kéréseket is blokkolhatja.
permissions-site-camera-disable-label =
    .label = Új kamera hozzáfés kérések blokkolása
permissions-site-camera-disable-desc = Ez megakadályozza, hogy a fent fel nem sorolt weboldalak kamera hozzáférést kérjenek. A kamera hozzáférés blokkolása működésképtelenné tehet néhány weboldal-funkciót.

## Site Permissions - Microphone

permissions-site-microphone-window =
    .title = Beállítások – Mikrofon engedélyek
    .style = { permissions-window.style }
permissions-site-microphone-desc = A következő weboldalak kérték, hogy hozzáférhessenek a mikrofonjához. Megadhatja, hogy mely weboldalak férjenek hozzá a mikrofonjához. Az új mikrofon hozzáférési kéréseket is blokkolhatja.
permissions-site-microphone-disable-label =
    .label = Új mikrofon hozzáférés kérések blokkolása
permissions-site-microphone-disable-desc = Ez megakadályozza, hogy a fent fel nem sorolt weboldalak mikrofon hozzáférést kérjenek. A mikrofon hozzáférés blokkolása működésképtelenné tehet néhány weboldal-funkciót.
