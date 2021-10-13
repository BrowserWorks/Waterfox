# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-page-title = Kiegészítőkezelő
search-header =
    .placeholder = Keresés itt: addons.mozilla.org
    .searchbuttonlabel = Keresés
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = Kiegészítők és témák beszerzése itt: <a data-l10n-name="get-extensions">{ $domain }</a>
list-empty-installed =
    .value = Nincs ilyen típusú kiegészítője
list-empty-available-updates =
    .value = Nem találhatók frissítések
list-empty-recent-updates =
    .value = Mostanában nem frissített kiegészítőket
list-empty-find-updates =
    .label = Frissítések keresése
list-empty-button =
    .label = További tudnivalók a kiegészítőkről
help-button = Kiegészítő támogatás
sidebar-help-button-title =
    .title = Kiegészítő támogatás
addons-settings-button = { -brand-short-name } Beállítások
sidebar-settings-button-title =
    .title = { -brand-short-name } Beállítások
show-unsigned-extensions-button =
    .label = Néhány kiegészítő nem ellenőrizhető
show-all-extensions-button =
    .label = Minden kiegészítő megjelenítése
detail-version =
    .label = Verzió
detail-last-updated =
    .label = Utoljára frissítve
detail-contributions-description = A kiegészítő fejlesztője azt kéri, hogy egy csekély összeggel támogassa a további fejlesztést.
detail-contributions-button = Közreműködés
    .title = Közreműködés ezen kiegészítő fejlesztésében
    .accesskey = K
detail-update-type =
    .value = Automatikus frissítések
detail-update-default =
    .label = Alapértelmezett
    .tooltiptext = Frissítések automatikus telepítése csak akkor, ha ez az alapbeállítás
detail-update-automatic =
    .label = Be
    .tooltiptext = Frissítések automatikus telepítése
detail-update-manual =
    .label = Ki
    .tooltiptext = Ne legyenek automatikus frissítések
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Futtatás privát ablakokban
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Privát ablakokban nem engedélyezett
detail-private-disallowed-description2 = Ez a kiegészítő nem fut privát böngészéskor. <a data-l10n-name="learn-more">További tudnivalók</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Hozzáférés szükséges a privát ablakokhoz
detail-private-required-description2 = Ez a kiegészítő hozzáfér az online tevékenységéhez privát böngészéskor. <a data-l10n-name="learn-more">További tudnivalók</a>
detail-private-browsing-on =
    .label = Engedélyezés
    .tooltiptext = Engedélyezés privát böngészésben
detail-private-browsing-off =
    .label = Tiltás
    .tooltiptext = Tiltás privát böngészésben
detail-home =
    .label = Honlap
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Kiegészítő profilja
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Frissítések keresése
    .accesskey = F
    .tooltiptext = Frissítések keresése ehhez a kiegészítőhöz
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Beállítások
           *[other] Beállítások
        }
    .accesskey =
        { PLATFORM() ->
            [windows] B
           *[other] B
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] A kiegészítő beállításainak módosítása
           *[other] A kiegészítő beállításainak módosítása
        }
detail-rating =
    .value = Értékelés
addon-restart-now =
    .label = Újraindítás most
disabled-unsigned-heading =
    .value = Néhány kiegészítő letiltásra került
disabled-unsigned-description = A következő kiegészítők nem lettek ellenőrizve a { -brand-short-name } böngészőben való használatra. Lehetősége van <label data-l10n-name="find-addons">helyettesítőket keresni</label> vagy megkérni a fejlesztőt az ellenőriztetésre.
disabled-unsigned-learn-more = Tudjon meg többet erőfeszítéseinkről az online biztonsága fenntartásáért.
disabled-unsigned-devinfo = A kiegészítőik ellenőriztetése iránt érdeklődő fejlesztők folytathatják a <label data-l10n-name="learn-more">kézikönyv</label> elolvasásával.
plugin-deprecation-description = Hiányzik valami? Néhány bővítményt már nem támogat a { -brand-short-name }. <label data-l10n-name="learn-more">További tudnivalók.</label>
legacy-warning-show-legacy = Hagyományos kiegészítők megjelenítése
legacy-extensions =
    .value = Hagyományos kiegészítők
legacy-extensions-description = Ezek a kiegészítők nem felelnek meg a { -brand-short-name } aktuális elvárásainak, emiatt le lettek tiltva. <label data-l10n-name="legacy-learn-more">További tudnivalók a kiegészítők módosulásáról</label>
private-browsing-description2 =
    A { -brand-short-name } megváltoztatja a kiegészítők működését privát böngészésben. A { -brand-short-name }hoz
    hozzáadott új kiegészítők alapértelmezetten nem futnak privát böngészésben. Ha nem engedélyezi a beállításokban,
    akkor a kiegészítő nem fog működni privát böngészésben, és ott nem fog hozzáférni az online tevékenységéhez.
    Ezt a változtatást azért hoztuk, hogy a privát böngészése tényleg privát legyen.
    <label data-l10n-name="private-browsing-learn-more">Tudjon meg többet a kiegészítőbeállítások kezeléséről.</label>
addon-category-discover = Javaslatok
addon-category-discover-title =
    .title = Javaslatok
addon-category-extension = Kiegészítők
addon-category-extension-title =
    .title = Kiegészítők
addon-category-theme = Témák
addon-category-theme-title =
    .title = Témák
addon-category-plugin = Bővítmények
addon-category-plugin-title =
    .title = Bővítmények
addon-category-dictionary = Szótárak
addon-category-dictionary-title =
    .title = Szótárak
addon-category-locale = Nyelvek
addon-category-locale-title =
    .title = Nyelvek
addon-category-available-updates = Elérhető frissítések
addon-category-available-updates-title =
    .title = Elérhető frissítések
addon-category-recent-updates = Legutóbbi frissítések
addon-category-recent-updates-title =
    .title = Legutóbbi frissítések

## These are global warnings

extensions-warning-safe-mode = Minden kiegészítő tiltva van a csökkentett mód miatt.
extensions-warning-check-compatibility = A kiegészítők kompatibilitásának vizsgálata tiltva van. Előfordulhat, hogy nem kompatibilis kiegészítői vannak.
extensions-warning-check-compatibility-button = Engedélyezés
    .title = Kiegészítők kompatibilitási ellenőrzésének engedélyezése
extensions-warning-update-security = A kiegészítők biztonsági vizsgálata tiltva van. A frissítések biztonsági kockázatot hordoznak.
extensions-warning-update-security-button = Engedélyezés
    .title = Kiegészítők frissítésekor a biztonsági ellenőrzés engedélyezése

## Strings connected to add-on updates

addon-updates-check-for-updates = Frissítések keresése
    .accesskey = F
addon-updates-view-updates = A legutóbbi frissítések megtekintése
    .accesskey = A

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Kiegészítők automatikus frissítése
    .accesskey = K

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Minden kiegészítő automatikus frissítése
    .accesskey = M
addon-updates-reset-updates-to-manual = Minden kiegészítő kézi frissítése
    .accesskey = k

## Status messages displayed when updating add-ons

addon-updates-updating = Kiegészítők frissítése
addon-updates-installed = A kiegészítői frissítve lettek.
addon-updates-none-found = Nem találhatók frissítések
addon-updates-manual-updates-found = Az elérhető frissítések megtekintése

## Add-on install/debug strings for page options menu

addon-install-from-file = Kiegészítő telepítése fájlból…
    .accesskey = f
addon-install-from-file-dialog-title = Válassza ki a telepíteni kívánt kiegészítőt
addon-install-from-file-filter-name = Kiegészítők
addon-open-about-debugging = Kiegészítők hibakeresése
    .accesskey = h

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Kiegészítő-gyorsbillentyűk kezelése
    .accesskey = o
shortcuts-no-addons = Egyetlen kiegészítő sincs engedélyezve.
shortcuts-no-commands = A következő kiegészítők nem rendelkeznek gyorsbillentyűvel:
shortcuts-input =
    .placeholder = Írjon be egy gyorsbillentyűt
shortcuts-browserAction2 = Eszköztárgomb aktiválása
shortcuts-pageAction = Lapművelet aktiválása
shortcuts-sidebarAction = Oldalsáv be/ki
shortcuts-modifier-mac = Ctrl, Alt vagy ⌘ gombot tartalmaz
shortcuts-modifier-other = Ctrl vagy Alt gombot tartalmaz
shortcuts-invalid = Érvénytelen kombináció
shortcuts-letter = Írjon be egy betűt
shortcuts-system = Nem írhat felül egy { -brand-short-name } gyorsbillentyűt
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Ismétlődő parancsikon
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = A { $shortcut } gyorsbillentyű több mint egy esetben van használva. Az ismétlődő gyorsbillentyűk váratlan viselkedést okozhatnak.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Már használja: { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Még { $numberToShow } megjelenítése
       *[other] Még { $numberToShow } megjelenítése
    }
shortcuts-card-collapse-button = Kevesebb megjelenítése
header-back-button =
    .title = Ugrás vissza

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    A kiegészítők és témák olyanok, mint az alkalmazások a böngészője számára,
    és segítségükkel megvédheti a jelszavait, videókat tölthet le, leárazásokat
    találhat, blokkolhatja a zavaró hirdetéseket, módosíthatja a böngésző
    kinézetét, és még sok mást is tehet. Ezek a kis programokat általában
    harmadik felek készítik. Itt vagy egy válogatás, amelyet a { -brand-product-name }
    a kivételes biztonságuk, teljesítményük és funkcionalitásuk miatt 
    <a data-l10n-name="learn-more-trigger">javasol</a>.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Ezen javaslatok egy része személyre szabott. Ennek alapja a telepített kiegészítői,
    a profilbeállításai és a használati statisztikái.
discopane-notice-learn-more = További tudnivalók
privacy-policy = Adatvédelmi irányelvek
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = szerző: <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Felhasználók: { $dailyUsers }
install-extension-button = Hozzáadás a { -brand-product-name }hoz
install-theme-button = Téma telepítése
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Kezelés
find-more-addons = Több kiegészítő keresése
find-more-themes = További témák keresése
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = További beállítások

## Add-on actions

report-addon-button = Jelentés
remove-addon-button = Eltávolítás
# The link will always be shown after the other text.
remove-addon-disabled-button = Nem távolítható el <a data-l10n-name="link">Miért?</a>
disable-addon-button = Letiltás
enable-addon-button = Engedélyezés
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Engedélyezés
preferences-addon-button =
    { PLATFORM() ->
        [windows] Beállítások
       *[other] Beállítások
    }
details-addon-button = Részletek
release-notes-addon-button = Kiadási megjegyzések
permissions-addon-button = Engedélyek
extension-enabled-heading = Engedélyezve
extension-disabled-heading = Tiltva
theme-enabled-heading = Engedélyezve
theme-disabled-heading = Tiltva
theme-monochromatic-heading = Színvilágok
theme-monochromatic-subheading = Élénk új színvilágok a { -brand-product-name }tól. Korlátozott ideig elérhető.
plugin-enabled-heading = Engedélyezve
plugin-disabled-heading = Tiltva
dictionary-enabled-heading = Engedélyezve
dictionary-disabled-heading = Tiltva
locale-enabled-heading = Engedélyezve
locale-disabled-heading = Tiltva
always-activate-button = Mindig aktiválja
never-activate-button = Soha ne aktiválja
addon-detail-author-label = Szerző
addon-detail-version-label = Verzió
addon-detail-last-updated-label = Utoljára frissítve
addon-detail-homepage-label = Honlap
addon-detail-rating-label = Értékelés
# Message for add-ons with a staged pending update.
install-postponed-message = Ez a kiegészítő a { -brand-short-name } újraindításakor lesz frissítve.
install-postponed-button = Frissítés most
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Értékelés: { NUMBER($rating, maximumFractionDigits: 1) } az 5-ből
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (letiltva)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } értékelés
       *[other] { $numberOfReviews } értékelés
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> has been removed.
pending-uninstall-undo-button = Visszavonás
addon-detail-updates-label = Automatikus frissítések engedélyezése
addon-detail-updates-radio-default = Alapértelmezett
addon-detail-updates-radio-on = Be
addon-detail-updates-radio-off = Ki
addon-detail-update-check-label = Frissítések keresése
install-update-button = Frissítés
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Engedélyezett privát ablakokban
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Ha engedélyezve van, a kiegészítő hozzá fog férni az online tevékenységekhez privát böngészés közben. <a data-l10n-name="learn-more">További tudnivalók</a>
addon-detail-private-browsing-allow = Engedélyezés
addon-detail-private-browsing-disallow = Tiltás

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = A { -brand-product-name } csak olyan kiegészítőket ajánl, amelyek megfelelnek a biztonsági és a teljesítménybeli követelményeinknek.
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Waterfox" in the string below because the extensions are built
# by Waterfox and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Hivatalos, a Waterfox által készített kiegészítő. Megfelel a biztonsági és teljesítményi előírásoknak.
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = Megvizsgáltuk ezt a kiegészítőt, és megfelelt a biztonsági és a teljesítménybeli követelményeinknek.
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Elérhető frissítések
recent-updates-heading = Legutóbbi frissítések
release-notes-loading = Betöltés…
release-notes-error = Sajnáljuk, de hiba történt a kiadási megjegyzések betöltésekor.
addon-permissions-empty = Ez a kiegészítő nem igényel semmilyen engedélyt
addon-permissions-required = Az alapvető funkciókhoz szükséges engedélyek:
addon-permissions-optional = A további funkciókhoz szükséges engedélyek:
addon-permissions-learnmore = További tudnivalók az engedélyekről
recommended-extensions-heading = Ajánlott kiegészítők
recommended-themes-heading = Ajánlott témák
# A recommendation for the Waterfox Color theme shown at the bottom of the theme
# list view. The "Waterfox Color" name itself should not be translated.
recommended-theme-1 = Kreatívnak érzi magát? <a data-l10n-name="link">Állítsa össze a saját témáját a Waterfox Color használatával.</a>

## Page headings

extension-heading = Kiegészítők kezelése
theme-heading = Témák kezelése
plugin-heading = Bővítmények kezelése
dictionary-heading = Szótárak kezelése
locale-heading = Nyelvek kezelése
updates-heading = Frissítések kezelése
discover-heading = A { -brand-short-name } testreszabása
shortcuts-heading = Kiegészítő-gyorsbillentyűk kezelése
default-heading-search-label = Több kiegészítő keresése
addons-heading-search-input =
    .placeholder = Keresés itt: addons.mozilla.org
addon-page-options-button =
    .title = Eszközök minden kiegészítőhöz
