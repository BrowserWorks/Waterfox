# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Novi tab
newtab-settings-button =
    .title = Prilagodite svoju početnu stranicu novog taba

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Traži
    .aria-label = Traži

newtab-search-box-search-the-web-text = Pretraži web
newtab-search-box-search-the-web-input =
    .placeholder = Pretraži web
    .title = Pretraži web
    .aria-label = Pretraži web

## Top Sites - General form dialog.

newtab-topsites-add-topsites-header = Nova najbolja stranica
newtab-topsites-edit-topsites-header = Uredi najbolju stranicu
newtab-topsites-title-label = Naslov
newtab-topsites-title-input =
    .placeholder = Unesi naslov

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Upišite ili zalijepite URL
newtab-topsites-url-validation = Potrebno je unijeti ispravan URL

newtab-topsites-image-url-label = Prilagođena URL slika
newtab-topsites-use-image-link = Koristite prilagođenu sliku…
newtab-topsites-image-validation = Neuspjelo učitavanje slike. Probajte drugi URL.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Otkaži
newtab-topsites-delete-history-button = Izbriši iz historije
newtab-topsites-save-button = Sačuvaj
newtab-topsites-preview-button = Pregled
newtab-topsites-add-button = Dodaj

## Top Sites - Delete history confirmation dialog. 

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Jeste li sigurni da želite izbrisati sve primjere ove stranice iz vaše historije?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Ova radnja se ne može opozvati.

## Context Menu - Action Tooltips.

# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Uredi ovu stranicu
    .aria-label = Uredi ovu stranicu

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Uredi
newtab-menu-open-new-window = Otvori u novom prozoru
newtab-menu-open-new-private-window = Otvori u novom privatnom prozoru
newtab-menu-dismiss = Odbaci
newtab-menu-pin = Zakači
newtab-menu-unpin = Otkači
newtab-menu-delete-history = Izbriši iz historije
newtab-menu-save-to-pocket = Sačuvaj na { -pocket-brand-name }
newtab-menu-delete-pocket = Izbriši iz { -pocket-brand-name }a
newtab-menu-archive-pocket = Arhiviraj u { -pocket-brand-name }

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Ukloni zabilješku
# Bookmark is a verb here.
newtab-menu-bookmark = Zabilježi

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb, 
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Kopiraj link za preuzimanje
newtab-menu-go-to-download-page = Idi na stranicu za preuzimanje
newtab-menu-remove-download = Ukloni iz historije

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Prikaži u Finderu
       *[other] Otvori direktorij u kojem se nalazi
    }
newtab-menu-open-file = Otvori datoteku

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Posjećeno
newtab-label-bookmarked = Zabilježeno
newtab-label-recommended = Popularno
newtab-label-saved = Sačuvano u { -pocket-brand-name }
newtab-label-download = Preuzeto

## Section Menu: These strings are displayed in the section context menu and are 
## meant as a call to action for the given section.

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Ukloni sekciju
newtab-section-menu-collapse-section = Skupi sekciju
newtab-section-menu-expand-section = Proširi sekciju
newtab-section-menu-manage-section = Upravljaj sekcijom
newtab-section-menu-add-topsite = Dodajte omiljenu stranicu
newtab-section-menu-move-up = Pomjeri gore
newtab-section-menu-move-down = Pomjeri dole
newtab-section-menu-privacy-notice = Polica privatnosti

## Section aria-labels

## Section Headers.

newtab-section-header-topsites = Najposjećenije stranice
newtab-section-header-highlights = Istaknuto
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Preporučeno od { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Započnite pretraživati i pokazat ćemo vam neke od izvrsnih članaka, videa i drugih web stranica prema vašim nedavno posjećenim stranicama ili zabilješkama.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Provjerite kasnije za više najpopularnijih priča od { $provider }. Ne možete čekati? Odaberite popularne teme kako biste pronašli više kvalitetnih priča s cijelog weba.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Popularne teme:

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Ups, došlo je do greške pri učitavanju ovog sadržaja.
newtab-error-fallback-refresh-link = Osvježite stranicu da biste pokušali ponovo.
