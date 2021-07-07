# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Profilok
profiles-subtitle = Ez az oldal segít a profilok kezelésében. Minden profil egy külön világ, amelyhez külön előzmények, könyvjelzők, beállítások és kiegészítők tartoznak.
profiles-create = Új profil létrehozása
profiles-restart-title = Újraindítás
profiles-restart-in-safe-mode = Újraindítás letiltott kiegészítőkkel…
profiles-restart-normal = Normál újraindítás…
profiles-conflict = A { -brand-product-name } másik példánya módosította a profilokat. A további változtatások előtt újra kell indítania a { -brand-short-name }ot.
profiles-flush-fail-title = A módosítások nincsenek mentve
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Egy váratlan hiba megakadályozta a módosítások mentését.
profiles-flush-restart-button = A { -brand-short-name } újraindítása

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Alapértelmezett profil
profiles-rootdir = Gyökérkönyvtár

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Helyi könyvtár
profiles-current-profile = A profil használatban van, és nem törölhető.
profiles-in-use-profile = Ezt a profilt egy másik alkalmazás használja, és nem törölhető.

profiles-rename = Átnevezés
profiles-remove = Eltávolítás
profiles-set-as-default = Alapértelmezett profil beállítása
profiles-launch-profile = Profilozás indítása új böngészőben

profiles-cannot-set-as-default-title = Az alapértelmezett nem állítható be
profiles-cannot-set-as-default-message = Az alapértelmezett profil nem módosítható a { -brand-short-name }nál.

profiles-yes = igen
profiles-no = nem

profiles-rename-profile-title = Profil átnevezése
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = { $name } profil átnevezése

profiles-invalid-profile-name-title = Érvénytelen profilnév
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = A(z) „{ $name }” profilnév nem használható.

profiles-delete-profile-title = Profil törlése
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    A törlés eltávolítja a profilt a rendelkezésre álló profilok listájából, és ez nem vonható vissza.
    Emellett kérheti a profilhoz tartozó adatfájlok, úgymint a levelezés, beállítások és tanúsítványok törlését is. Ez törli a(z) „{ $dir }” mappát, ami szintén nem vonható vissza.
    Valóban törölni kívánja a profilhoz tartozó adatfájlokat?
profiles-delete-files = Fájlok törlése
profiles-dont-delete-files = Fájlok megtartása

profiles-delete-profile-failed-title = Hiba
profiles-delete-profile-failed-message = Hiba történt a profil törlési kísérlete során.


profiles-opendir =
    { PLATFORM() ->
        [macos] Megjelenítés a Finderben
        [windows] Mappa megnyitása
       *[other] Könyvtár megnyitása
    }
