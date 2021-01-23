# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Waterfox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Filă nouă
newtab-settings-button =
    .title = Personalizează pagina pentru filă nouă

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Caută
    .aria-label = Caută

newtab-search-box-search-the-web-text = Caută pe web
newtab-search-box-search-the-web-input =
    .placeholder = Caută pe web
    .title = Caută pe web
    .aria-label = Caută pe web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Adaugă motor de căutare
newtab-topsites-add-topsites-header = Site de top nou
newtab-topsites-edit-topsites-header = Editează site-ul de top
newtab-topsites-title-label = Titlu
newtab-topsites-title-input =
    .placeholder = Introdu un titlu

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Tastează sau lipește un URL
newtab-topsites-url-validation = URL valid necesar

newtab-topsites-image-url-label = URL pentru imagine personalizată
newtab-topsites-use-image-link = Folosește o imagine personalizată…
newtab-topsites-image-validation = Imaginea nu s-a încărcat. Încearcă o altă adresă.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Renunță
newtab-topsites-delete-history-button = Șterge din istoric
newtab-topsites-save-button = Salvează
newtab-topsites-preview-button = Previzualizare
newtab-topsites-add-button = Adaugă

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Sigur vrei să ștergi fiecare instanță a acestei pagini din istoric?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Această acțiune este ireversibilă.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Deschide meniul
    .aria-label = Deschide meniul

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Elimină
    .aria-label = Elimină

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Deschide meniul
    .aria-label = Deschide meniul contextual pentru { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Editează acest site
    .aria-label = Editează acest site

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Editează
newtab-menu-open-new-window = Deschide într-o fereastră nouă
newtab-menu-open-new-private-window = Deschide într-o fereastră privată nouă
newtab-menu-dismiss = Înlătură
newtab-menu-pin = Fixează
newtab-menu-unpin = Anulează fixarea
newtab-menu-delete-history = Șterge din istoric
newtab-menu-save-to-pocket = Salvează în { -pocket-brand-name }
newtab-menu-delete-pocket = Șterge din { -pocket-brand-name }
newtab-menu-archive-pocket = Arhivează în { -pocket-brand-name }
newtab-menu-show-privacy-info = Sponsorii noștri și confidențialitatea ta

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Terminat
newtab-privacy-modal-button-manage = Gestionează setările conținuturilor sponsorizate
newtab-privacy-modal-header = Confidențialitatea ta contează.
newtab-privacy-modal-paragraph-2 = În plus față de afișarea unor articole captivante, îți arătăm și conținuturi relevante foarte bine cotate de la sponsori selectați. Fii fără grijă, <strong>datele tale de navigare nu pleacă niciodată din exemplarul tău personal de { -brand-product-name }</strong> — nici noi nu le vedem, nici sponsorii noștri.
newtab-privacy-modal-link = Află cum funcționează confidențialitatea în fila nouă

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Elimină marcajul
# Bookmark is a verb here.
newtab-menu-bookmark = Marchează

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Copiază linkul de descărcare
newtab-menu-go-to-download-page = Mergi la pagina de descărcare
newtab-menu-remove-download = Elimină din istoric

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Afișează în Finder
       *[other] Deschide dosarul conținător
    }
newtab-menu-open-file = Deschide fișierul

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Vizitat
newtab-label-bookmarked = Însemnat
newtab-label-removed-bookmark = Marcaj eliminat
newtab-label-recommended = În tendințe
newtab-label-saved = Salvat în { -pocket-brand-name }
newtab-label-download = Descărcat

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Sponsorizat

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Sponsorizat de { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Elimină secțiunea
newtab-section-menu-collapse-section = Restrânge secțiunea
newtab-section-menu-expand-section = Extinde secțiunea
newtab-section-menu-manage-section = Gestionează secțiunea
newtab-section-menu-manage-webext = Gestionează extensia
newtab-section-menu-add-topsite = Adaugă site de top
newtab-section-menu-add-search-engine = Adaugă motor de căutare
newtab-section-menu-move-up = Mută în sus
newtab-section-menu-move-down = Mută în jos
newtab-section-menu-privacy-notice = Notificare privind confidențialitatea

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Restrânge secțiunea
newtab-section-expand-section-label =
    .aria-label = Extinde secțiunea

## Section Headers.

newtab-section-header-topsites = Site-uri de top
newtab-section-header-highlights = Evidențieri
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Recomandat de { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Începe să navighezi și noi îți vom arăta articole interesante, videouri sau alte pagini pe care le-ai vizitat sau marcat recent.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Ai ajuns la capăt. Revino mai târziu pentru alte articole de la { $provider }. Nu mai vrei să aștepți? Selectează un subiect popular și găsește alte articole interesante de pe web.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Ești prins!
newtab-discovery-empty-section-topstories-content = Revino mai târziu pentru mai multe articole.
newtab-discovery-empty-section-topstories-try-again-button = Încearcă din nou
newtab-discovery-empty-section-topstories-loading = Se încarcă…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Ups! Aproape că am încărcat această secțiune, dar nu complet.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Subiecte populare:
newtab-pocket-more-recommendations = Mai multe recomandări
newtab-pocket-learn-more = Află mai multe
newtab-pocket-cta-button = Obține { -pocket-brand-name }
newtab-pocket-cta-text = Salvează în { -pocket-brand-name } articolele care ți-au plăcut și hrănește-ți mintea cu lecturi fascinante.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Ups, ceva nu a funcționat la încărcarea acestui conținut.
newtab-error-fallback-refresh-link = Reîmprospătează pagina pentru a încerca din nou.
