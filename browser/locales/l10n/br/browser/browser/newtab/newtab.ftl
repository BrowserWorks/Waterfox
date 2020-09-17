# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Ivinell nevez
newtab-settings-button =
    .title = Personelait ho pajenn Ivinell Nevez

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Klask
    .aria-label = Klask

newtab-search-box-search-the-web-text = Klask er web
newtab-search-box-search-the-web-input =
    .placeholder = Klask er web
    .title = Klask er web
    .aria-label = Klask er web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Ouzhpennañ ul lusker klask
newtab-topsites-add-topsites-header = Lec'hiennoù gwellañ nevez
newtab-topsites-edit-topsites-header = Embann al Lec'hiennoù Gwellañ
newtab-topsites-title-label = Titl
newtab-topsites-title-input =
    .placeholder = Enankañ un titl

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Skrivit pe pegit un URL
newtab-topsites-url-validation = URL talvoudek azgoulennet

newtab-topsites-image-url-label = URL ar skeudenn personelaet
newtab-topsites-use-image-link = Ober gant ur skeudenn personelaet…
newtab-topsites-image-validation = N'haller ket kargan ar skeudenn. Klaskit gant un URL disheñvel.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Nullañ
newtab-topsites-delete-history-button = Dilemel eus ar roll istor
newtab-topsites-save-button = Enrollañ
newtab-topsites-preview-button = Alberz
newtab-topsites-add-button = Ouzhpennañ

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Sur oc'h e fell deoc'h dilemel kement eriol eus ar bajenn-mañ diouzh ho roll istor?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Ne c'haller ket dizober ar gwezh-mañ.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Digeriñ al lañser
    .aria-label = Digeriñ al lañser

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Dilemel
    .aria-label = Dilemel

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Digeriñ al lañser
    .aria-label = Digeriñ al lañser kemperzhel evit { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Embann al lec'hienn-mañ
    .aria-label = Embann al lec'hienn-mañ

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Embann
newtab-menu-open-new-window = Digeriñ e-barzh ur prenestr nevez
newtab-menu-open-new-private-window = Digeriñ e-barzh ur prenestr merdeiñ prevez nevez
newtab-menu-dismiss = Argas
newtab-menu-pin = Spilhennañ
newtab-menu-unpin = Dispilhennañ
newtab-menu-delete-history = Dilemel eus ar roll istor
newtab-menu-save-to-pocket = Enrollañ etrezek { -pocket-brand-name }
newtab-menu-delete-pocket = Dilemel eus { -pocket-brand-name }
newtab-menu-archive-pocket = Diellaouiñ e { -pocket-brand-name }
newtab-menu-show-privacy-info = Hor c'hevelerien hag ho puhez prevez

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Graet
newtab-privacy-modal-button-manage = Merañ an arventennoù endalc'had kevelet
newtab-privacy-modal-header = Pouezus eo ho puhez prevez
newtab-privacy-modal-paragraph-2 = Kinnig a reomp deoc'h istorioù dedennus, met ivez danvezioù dibabet gant aked eus hor c'hevelerien. Bezit dinec'het: <strong>morse ne vo kaset ho roadennoù merdeiñ e diavaez ho eilenn hiniennel { -brand-product-name }</strong> — ne welont ket anezho hag hor c'hevelerien kennebeut.
newtab-privacy-modal-link = Deskit penaos ec'h a en-dro ar prevezded war an ivinell nevez

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Dilemel ar sined
# Bookmark is a verb here.
newtab-menu-bookmark = Sined

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Eilañ ere ar pellgargadur
newtab-menu-go-to-download-page = Mont da bajenn ar pellgargadur
newtab-menu-remove-download = Dilemel diwar ar roll

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Diskouez e Finder
       *[other] Digeriñ an teuliad a endalc'h ar restr
    }
newtab-menu-open-file = Digeriñ ar restr

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Gweladennet
newtab-label-bookmarked = Lakaet er sinedoù
newtab-label-removed-bookmark = Sined dilamet
newtab-label-recommended = Brudet
newtab-label-saved = Enrollet e { -pocket-brand-name }
newtab-label-download = Pellgarget

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · kevellet

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Kevelet gant { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Dilemel ar gevrenn
newtab-section-menu-collapse-section = Bihanaat ar gevrenn
newtab-section-menu-expand-section = Astenn ar gevrenn
newtab-section-menu-manage-section = Merañ ar gevrenn
newtab-section-menu-manage-webext = Merañ an askouezh
newtab-section-menu-add-topsite = Ouzhpennañ ul lec'hienn gwellañ din
newtab-section-menu-add-search-engine = Ouzhpennañ ul lusker klask
newtab-section-menu-move-up = Dilec'hiañ etrezek ar c'hrec'h
newtab-section-menu-move-down = Dilec'hiañ etrezek an traoñ
newtab-section-menu-privacy-notice = Evezhiadennoù a-fet buhez prevez

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Bihanaat ar gevrenn
newtab-section-expand-section-label =
    .aria-label = Astenn ar gevrenn

## Section Headers.

newtab-section-header-topsites = Lec'hiennoù pennañ
newtab-section-header-highlights = Mareoù pouezus
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Erbedet gant { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Krogit da verdeiñ hag e tiskouezimp deoc’h pennadoù, videoioù ha pajennoù all gweladennet pe lakaet er sinedoù nevez ’zo.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Aet oc'h betek penn. Distroit diwezhatoc'h evit muioc’h a istorioù digant { $provider }. N’oc'h ket evit gortoz? Dibabit un danvez brudet evit klask muioc’h a bennadoù dedennus eus pep lec’h er web.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Echuet eo ganeoc'h!
newtab-discovery-empty-section-topstories-content = Distroit amañ diwezhatoc'h evit lenn pennadoù all.
newtab-discovery-empty-section-topstories-try-again-button = Klaskit en-dro
newtab-discovery-empty-section-topstories-loading = O kargañ...
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Chaous! N'eo ket bet karget ar gevrenn en he fezh.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Danvezioù brudet:
newtab-pocket-more-recommendations = Erbedadennoù ouzhpenn
newtab-pocket-learn-more = Gouzout hiroc'h
newtab-pocket-cta-button = Staliañ { -pocket-brand-name }
newtab-pocket-cta-text = Enrollit pennadoù a-zoare e { -pocket-brand-name } ha magit ho spered gant lennadennoù boemus.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Chaous, un dra bennak a zo a-dreuz en ur gargañ an endalc'had.
newtab-error-fallback-refresh-link = Adkargit ar bajenn evit klask en-dro.
