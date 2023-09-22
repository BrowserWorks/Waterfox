# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = Megnyitás
    .accesskey = e
places-open-in-tab =
    .label = Megnyitás új lapon
    .accesskey = l
places-open-in-container-tab =
    .label = Megnyitás új konténerlapban
    .accesskey = j
places-open-all-bookmarks =
    .label = Minden könyvjelző megnyitása
    .accesskey = M
places-open-all-in-tabs =
    .label = Mindegyik megnyitása külön lapon
    .accesskey = m
places-open-in-window =
    .label = Megnyitás új ablakban
    .accesskey = a
places-open-in-private-window =
    .label = Megnyitás új privát ablakban
    .accesskey = p

places-empty-bookmarks-folder =
    .label = (Üres)

places-add-bookmark =
    .label = Könyvjelzők hozzáadása…
    .accesskey = K
places-add-folder-contextmenu =
    .label = Mappa hozzáadása…
    .accesskey = M
places-add-folder =
    .label = Mappa hozzáadása…
    .accesskey = M
places-add-separator =
    .label = Elválasztó hozzáadása
    .accesskey = E

places-view =
    .label = Megjelenítés
    .accesskey = M
places-by-date =
    .label = Dátum szerint
    .accesskey = D
places-by-site =
    .label = Kiszolgáló szerint
    .accesskey = K
places-by-most-visited =
    .label = Látogatottság szerint
    .accesskey = L
places-by-last-visited =
    .label = Utolsó látogatás ideje szerint
    .accesskey = U
places-by-day-and-site =
    .label = Dátum és kiszolgáló szerint
    .accesskey = m

places-history-search =
    .placeholder = Előzmények keresése
places-history =
    .aria-label = Előzmények
places-bookmarks-search =
    .placeholder = Könyvjelzők keresése

places-delete-domain-data =
    .label = Webhely elfelejtése
    .accesskey = W
places-sortby-name =
    .label = Rendezés név szerint
    .accesskey = n
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = Könyvjelző szerkesztése…
    .accesskey = e
places-edit-generic =
    .label = Szerkesztés…
    .accesskey = e
places-edit-folder2 =
    .label = Mappa szerkesztése…
    .accesskey = e
places-delete-folder =
    .label =
        { $count ->
            [1] Mappa törlése
            [one] Mappa törlése
           *[other] Mappák törlése
        }
    .accesskey = t
# Variables:
#   $count (number) - The number of pages selected for removal.
places-delete-page =
    .label =
        { $count ->
            [1] Lap törlése
           *[other] Lapok törlése
        }
    .accesskey = t

# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = Menedzsel könyvjelzők
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = Almappa

# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = Más könyvjelzők

places-show-in-folder =
    .label = Megjelenítés mappában
    .accesskey = M

# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] Könyvjelző törlése
            [one] Könyvjelző törlése
           *[other] Könyvjelzők törlése
        }
    .accesskey = t

# Variables:
#   $count (number) - The number of bookmarks being added.
places-create-bookmark =
    .label =
        { $count ->
            [1] Lap könyvjelzőzése…
           *[other] Lapok könyvjelzőzése…
        }
    .accesskey = k

places-untag-bookmark =
    .label = Címke eltávolítása
    .accesskey = t

places-manage-bookmarks =
    .label = Könyvjelzők kezelése
    .accesskey = K

places-forget-about-this-site-confirmation-title = Webhely elfelejtése

# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-msg = Ez a művelet eltávolítja a(z) { $hostOrBaseDomain } domainhez kapcsolódó összes adatot, beleértve az előzményeket, a sütiket, a gyorsítótárat és a tartalmi beállításokat. A kapcsolódó könyvjelzők és jelszavak nem lesznek eltávolítva. Biztos, hogy folytatja?

places-forget-about-this-site-forget = Elfelejtés

places-library3 =
    .title = Könyvtár

places-organize-button =
    .label = Rendszerezés
    .tooltiptext = Könyvjelzők rendszerezése
    .accesskey = R

places-organize-button-mac =
    .label = Rendszerezés
    .tooltiptext = Könyvjelzők rendszerezése

places-file-close =
    .label = Bezárás
    .accesskey = B

places-cmd-close =
    .key = w

places-view-button =
    .label = Nézetek
    .tooltiptext = A nézet megváltoztatása
    .accesskey = N

places-view-button-mac =
    .label = Nézetek
    .tooltiptext = A nézet megváltoztatása

places-view-menu-columns =
    .label = Oszlopok megjelenítése
    .accesskey = O

places-view-menu-sort =
    .label = Rendezés
    .accesskey = R

places-view-sort-unsorted =
    .label = Rendezetlen
    .accesskey = R

places-view-sort-ascending =
    .label = A > Z
    .accesskey = A

places-view-sort-descending =
    .label = Z > A
    .accesskey = Z

places-maintenance-button =
    .label = Importálás és mentés
    .tooltiptext = Könyvjelzők importálása és biztonsági mentése
    .accesskey = I

places-maintenance-button-mac =
    .label = Importálás és mentés
    .tooltiptext = Könyvjelzők importálása és biztonsági mentése

places-cmd-backup =
    .label = Mentés…
    .accesskey = M

places-cmd-restore =
    .label = Visszaállítás
    .accesskey = V

places-cmd-restore-from-file =
    .label = Tallózás…
    .accesskey = T

places-import-bookmarks-from-html =
    .label = Könyvjelzők importálása HTML-ből…
    .accesskey = i

places-export-bookmarks-to-html =
    .label = Könyvjelzők exportálása HTML-be…
    .accesskey = e

places-import-other-browser =
    .label = Adatok importálása másik böngészőből…
    .accesskey = A

places-view-sort-col-name =
    .label = Név

places-view-sort-col-tags =
    .label = Címkék

places-view-sort-col-url =
    .label = Hely

places-view-sort-col-most-recent-visit =
    .label = Legutóbbi látogatás

places-view-sort-col-visit-count =
    .label = Látogatások száma

places-view-sort-col-date-added =
    .label = Hozzáadva

places-view-sort-col-last-modified =
    .label = Utoljára módosítva

places-view-sortby-name =
    .label = Rendezés név szerint
    .accesskey = n
places-view-sortby-url =
    .label = Rendezés hely szerint
    .accesskey = h
places-view-sortby-date =
    .label = Rendezés a legutóbbi látogatás szerint
    .accesskey = u
places-view-sortby-visit-count =
    .label = Rendezés a látogatás száma szerint
    .accesskey = s
places-view-sortby-date-added =
    .label = Rendezés a hozzáadás ideje szerint
    .accesskey = e
places-view-sortby-last-modified =
    .label = Rendezés az utolsó módosítás szerint
    .accesskey = m
places-view-sortby-tags =
    .label = Rendezés címkék szerint
    .accesskey = c

places-cmd-find-key =
    .key = f

places-back-button =
    .tooltiptext = Ugrás vissza

places-forward-button =
    .tooltiptext = Ugrás előre

places-details-pane-select-an-item-description = Jelöljön ki egy elemet megtekintésre, és szerkessze tulajdonságait

places-details-pane-no-items =
    .value = 0 elem
# Variables:
#   $count (Number): number of items
places-details-pane-items-count =
    .value =
        { $count ->
            [one] Egy elem
           *[other] { $count } elem
        }

## Strings used as a placeholder in the Library search field. For example,
## "Search History" stands for "Search through the browser's history".

places-search-bookmarks =
    .placeholder = Keresés a könyvjelzők között
places-search-history =
    .placeholder = Keresés az előzmények között
places-search-downloads =
    .placeholder = Keresés a letöltések között

##

places-locked-prompt = A könyvjelzők és az előzmények rendszere nem fog működni, mert a { -brand-short-name } egyik fájlját egy másik alkalmazás használja. Egyes biztonsági szoftverek okozhatnak ilyen problémát.
