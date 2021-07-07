# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Új lap
newtab-settings-button =
    .title = Az Új lap oldal személyre szabása
newtab-personalize-button-label = Testreszabás
    .title = Új lap testreszabása
    .aria-label = Új lap testreszabása
newtab-personalize-dialog-label =
    .aria-label = Testreszabás

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Keresés
    .aria-label = Keresés
newtab-search-box-search-the-web-text = Keresés a weben
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = Keressen a(z) { $engine } keresővel vagy adjon meg egy címet
newtab-search-box-handoff-text-no-engine = Keressen, vagy adjon meg címet
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = Keressen a(z) { $engine } keresővel vagy adjon meg egy címet
    .title = Keressen a(z) { $engine } keresővel vagy adjon meg egy címet
    .aria-label = Keressen a(z) { $engine } keresővel vagy adjon meg egy címet
newtab-search-box-handoff-input-no-engine =
    .placeholder = Keressen, vagy adjon meg címet
    .title = Keressen, vagy adjon meg címet
    .aria-label = Keressen, vagy adjon meg címet
newtab-search-box-search-the-web-input =
    .placeholder = Keresés a weben
    .title = Keresés a weben
    .aria-label = Keresés a weben
newtab-search-box-text = Keresés a weben
newtab-search-box-input =
    .placeholder = Keresés a weben
    .aria-label = Keresés a weben

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Keresőszolgáltatás hozzáadása
newtab-topsites-add-topsites-header = Új népszerű oldal
newtab-topsites-add-shortcut-header = Új gyorskereső
newtab-topsites-edit-topsites-header = Népszerű oldal szerkesztése
newtab-topsites-edit-shortcut-header = Gyorskereső szerkesztése
newtab-topsites-title-label = Cím
newtab-topsites-title-input =
    .placeholder = Cím megadása
newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Írjon vagy illesszen be egy URL-t
newtab-topsites-url-validation = Érvényes URL szükséges
newtab-topsites-image-url-label = Egyéni kép URL
newtab-topsites-use-image-link = Egyéni kép használata…
newtab-topsites-image-validation = A kép betöltése nem sikerült. Próbáljon meg egy másik URL-t.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Mégse
newtab-topsites-delete-history-button = Törlés az előzményekből
newtab-topsites-save-button = Mentés
newtab-topsites-preview-button = Előnézet
newtab-topsites-add-button = Hozzáadás

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Biztosan törli ezen oldal minden példányát az előzményekből?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Ez a művelet nem vonható vissza.

## Top Sites - Sponsored label

newtab-topsite-sponsored = Szponzorált

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Menü megnyitása
    .aria-label = Menü megnyitása
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Eltávolítás
    .aria-label = Eltávolítás
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Menü megnyitása
    .aria-label = Környezeti menü megnyitása ehhez: { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Webhely szerkesztése
    .aria-label = Webhely szerkesztése

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Szerkesztés
newtab-menu-open-new-window = Megnyitás új ablakban
newtab-menu-open-new-private-window = Megnyitás új privát ablakban
newtab-menu-dismiss = Elutasítás
newtab-menu-pin = Rögzítés
newtab-menu-unpin = Rögzítés feloldása
newtab-menu-delete-history = Törlés az előzményekből
newtab-menu-save-to-pocket = Mentés a { -pocket-brand-name }be
newtab-menu-delete-pocket = Törlés a { -pocket-brand-name }ből
newtab-menu-archive-pocket = Archiválás a { -pocket-brand-name }ben
newtab-menu-show-privacy-info = Támogatóink és az Ön adatvédelme

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Kész
newtab-privacy-modal-button-manage = Szponzorált tartalom beállításainak kezelése
newtab-privacy-modal-header = Számít az Ön adatvédelme.
newtab-privacy-modal-paragraph-2 =
    A magával ragadó történetek mellett, kiválasztott szponzoraink releváns,
    válogatott tartalmait is megjelenítjük. Biztos lehet benne, hogy <strong>a böngészési adatai
    sosem hagyják el az Ön { -brand-product-name } példányát</strong> – mi nem látjuk azokat,
    és a szponzoraink sem.
newtab-privacy-modal-link = Tudja meg, hogyan működik az adatvédelem az új lapon

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Könyvjelző eltávolítása
# Bookmark is a verb here.
newtab-menu-bookmark = Könyvjelzőzés

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Letöltési hivatkozás másolása
newtab-menu-go-to-download-page = Ugrás a letöltési oldalra
newtab-menu-remove-download = Törlés az előzményekből

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Megjelenítés a Finderben
       *[other] Tartalmazó mappa megnyitása
    }
newtab-menu-open-file = Fájl megnyitása

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Látogatott
newtab-label-bookmarked = Könyvjelzőzött
newtab-label-removed-bookmark = Könyvjelző törölve
newtab-label-recommended = Népszerű
newtab-label-saved = Mentve a { -pocket-brand-name }be
newtab-label-download = Letöltve
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Szponzorált
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Szponzorálta: { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Szakasz eltávolítása
newtab-section-menu-collapse-section = Szakasz összecsukása
newtab-section-menu-expand-section = Szakasz lenyitása
newtab-section-menu-manage-section = Szakasz kezelése
newtab-section-menu-manage-webext = Kiegészítő kezelése
newtab-section-menu-add-topsite = Hozzáadás a népszerű oldalakhoz
newtab-section-menu-add-search-engine = Keresőszolgáltatás hozzáadása
newtab-section-menu-move-up = Mozgatás felfelé
newtab-section-menu-move-down = Mozgatás lefelé
newtab-section-menu-privacy-notice = Adatvédelmi nyilatkozat

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Szakasz összecsukása
newtab-section-expand-section-label =
    .aria-label = Szakasz lenyitása

## Section Headers.

newtab-section-header-topsites = Népszerű oldalak
newtab-section-header-highlights = Kiemelések
newtab-section-header-recent-activity = Legutóbbi tevékenység
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = A(z) { $provider } ajánlásával

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Kezdjen el böngészni, és itt fognak megjelenni azok a nagyszerű cikkek, videók és más lapok, amelyeket nemrég meglátogatott vagy könyvjelzőzött.
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Már felzárkózott. Nézzen vissza később a legújabb { $provider } hírekért. Nem tud várni? Válasszon egy népszerű témát, hogy még több sztorit találjon a weben.

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Felzárkózott.
newtab-discovery-empty-section-topstories-content = Nézzen vissza később további történetekért.
newtab-discovery-empty-section-topstories-try-again-button = Próbálja újra
newtab-discovery-empty-section-topstories-loading = Betöltés…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Hoppá! Majdnem betöltöttük ezt a részt, de nem egészen.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Népszerű témák:
newtab-pocket-more-recommendations = További javaslatok
newtab-pocket-learn-more = További tudnivalók
newtab-pocket-cta-button = { -pocket-brand-name } beszerzése
newtab-pocket-cta-text = Mentse az Ön által kedvelt történeteket a { -pocket-brand-name }be, és töltse fel elméjét lebilincselő olvasnivalókkal.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Hoppá, valami hiba történt a tartalom betöltésekor.
newtab-error-fallback-refresh-link = Az újrapróbálkozáshoz frissítse az oldalt.

## Customization Menu

newtab-custom-shortcuts-title = Gyorskeresők
newtab-custom-shortcuts-subtitle = Mentett vagy felkeresett webhelyek
newtab-custom-row-selector =
    { $num ->
        [one] { $num } sor
       *[other] { $num } sor
    }
newtab-custom-sponsored-sites = Szponzorált gyorskeresők
newtab-custom-pocket-title = A { -pocket-brand-name } által ajánlott
newtab-custom-pocket-subtitle = Kivételes tartalmak a { -pocket-brand-name } válogatásában, amely a { -brand-product-name } család része
newtab-custom-pocket-sponsored = Szponzorált történetek
newtab-custom-recent-title = Legutóbbi tevékenység
newtab-custom-recent-subtitle = Válogatás a legutóbbi webhelyekből és tartalmakból
newtab-custom-close-button = Bezárás
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
newtab-custom-snippets-title = Töredékek
newtab-custom-snippets-subtitle = Tippek és hírek a { -vendor-short-name } és a { -brand-product-name } felől
newtab-custom-settings = További beállítások kezelése
