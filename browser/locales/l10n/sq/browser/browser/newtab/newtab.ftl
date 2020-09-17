# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Skedë e Re
newtab-settings-button =
    .title = Personalizoni faqen tuaj Skedë e Re

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Kërko
    .aria-label = Kërko

newtab-search-box-search-the-web-text = Kërkoni në Web
newtab-search-box-search-the-web-input =
    .placeholder = Kërkoni në Web
    .title = Kërkoni në Web
    .aria-label = Kërkoni në Web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Shtoni Motor Kërkimesh
newtab-topsites-add-topsites-header = Sajt i Ri Kryesues
newtab-topsites-edit-topsites-header = Përpunoni Sajtin Kryesues
newtab-topsites-title-label = Titull
newtab-topsites-title-input =
    .placeholder = Jepni një titull

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Shtypni ose hidhni një URL
newtab-topsites-url-validation = Lypset URL e vlefshme

newtab-topsites-image-url-label = URL Figure Vetjake
newtab-topsites-use-image-link = Përdorni një figurë vetjake…
newtab-topsites-image-validation = Dështoi ngarkimi i figurës. Provoni një URL tjetër.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Anuloje
newtab-topsites-delete-history-button = Fshije nga Historiku
newtab-topsites-save-button = Ruaje
newtab-topsites-preview-button = Paraparje
newtab-topsites-add-button = Shtoje

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Jeni të sigurt se doni të fshini nga historiku çdo instancë të kësaj faqeje?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Ky veprim s’mund të zhbëhet.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Hapni menunë
    .aria-label = Hapni menunë

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Hiqe
    .aria-label = Hiqe

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Hapni menunë
    .aria-label = Hapni menu konteksti për { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Përpunoni këtë sajt
    .aria-label = Përpunoni këtë sajt

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Përpunoni
newtab-menu-open-new-window = Hape në Dritare të Re
newtab-menu-open-new-private-window = Hape në Dritare të Re Private
newtab-menu-dismiss = Hidhe tej
newtab-menu-pin = Fiksoje
newtab-menu-unpin = Shfiksoje
newtab-menu-delete-history = Fshije nga Historiku
newtab-menu-save-to-pocket = Ruaje te { -pocket-brand-name }
newtab-menu-delete-pocket = Fshije nga { -pocket-brand-name }
newtab-menu-archive-pocket = Arkivoje në { -pocket-brand-name }
newtab-menu-show-privacy-info = Sponsorët tanë & privatësia jonë

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Kaq qe
newtab-privacy-modal-button-manage = Administroni rregullime lënde të sponsorizuar
newtab-privacy-modal-header = Privatësia juaj ka rëndësi.
newtab-privacy-modal-paragraph-2 = Jo vetëm ju shërbejmë histori tërheqëse, por ju shfaqim edhe lëndë me vlerë, të kontrolluar mirë, prej sponsorësh të përzgjedhur. Flijeni mendjen, <strong>të dhënat e shfletimit tuaj nuk ikin kurrë nga kopja juaj personale e { -brand-product-name }-it</strong> — as ne nuk i shohim dot, as sponsorët tanë.
newtab-privacy-modal-link = Mësoni se si funksionon privatësia në skedën e re

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Hiqe Faqerojtësin
# Bookmark is a verb here.
newtab-menu-bookmark = Faqerojtës

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Kopjo Lidhjen e Shkarkimit
newtab-menu-go-to-download-page = Shko Te Faqja e Shkarkimit
newtab-menu-remove-download = Hiqe nga Historiku

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Shfaqe Në Finder
       *[other] Hap Dosjen Përkatëse
    }
newtab-menu-open-file = Hape Kartelën

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Të vizituara
newtab-label-bookmarked = Të faqeruajtura
newtab-label-removed-bookmark = Faqerojtësi u hoq
newtab-label-recommended = Në modë
newtab-label-saved = Ruajtur te { -pocket-brand-name }
newtab-label-download = Të shkarkuara

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · E sponsorizuar

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Sponsorizuar nga { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Hiqe Ndarjen
newtab-section-menu-collapse-section = Tkurre Ndarjen
newtab-section-menu-expand-section = Zgjeroje Ndarjen
newtab-section-menu-manage-section = Administroni Ndarjen
newtab-section-menu-manage-webext = Administroni Zgjerimin
newtab-section-menu-add-topsite = Shtoni Sajt Kryesues
newtab-section-menu-add-search-engine = Shtoni Motor Kërkimesh
newtab-section-menu-move-up = Ngrije
newtab-section-menu-move-down = Ule
newtab-section-menu-privacy-notice = Shënim Mbi Privatësinë

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Tkurre Ndarjen
newtab-section-expand-section-label =
    .aria-label = Zgjeroje Ndarjen

## Section Headers.

newtab-section-header-topsites = Sajte Kryesues
newtab-section-header-highlights = Në Pah
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Rekomanduar nga { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Filloni shfletimin, dhe do t'ju shfaqim disa nga artikujt, videot dhe të tjera faqe interesante që keni vizituar apo faqerojtur këtu kohët e fundit.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Gjithë ç’kish, e dini. Rikontrolloni më vonë për më tepër histori nga { $provider }. S’pritni dot? Përzgjidhni një temë popullore që të gjenden në internet më tepër histori të goditura.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = S’ka tjetër!
newtab-discovery-empty-section-topstories-content = Kontrolloni më vonë për më tepër shembuj.
newtab-discovery-empty-section-topstories-try-again-button = Riprovoni
newtab-discovery-empty-section-topstories-loading = Po ngarkohet…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Hëm! Thuajse e ngarkuam këtë ndarje, por jo dhe aq.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Tema Popullore:
newtab-pocket-more-recommendations = Më Tepër Rekomandime
newtab-pocket-learn-more = Mësoni më tepër
newtab-pocket-cta-button = Merreni { -pocket-brand-name }-in
newtab-pocket-cta-text = Ruajini në { -pocket-brand-name } shkrimet që doni, dhe ushqejeni mendjen me lexime të mahnitshme.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Hëm, diç shkoi ters në ngarkimin e kësaj lënde.
newtab-error-fallback-refresh-link = Rifreskoni faqen që të riprovohet.
