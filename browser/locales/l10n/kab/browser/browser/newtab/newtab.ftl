# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Iccer amaynut
newtab-settings-button =
    .title = Sagen asebter n yiccer-ik amaynut

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Nadi
    .aria-label = Nadi

newtab-search-box-search-the-web-text = Nadi di Web
newtab-search-box-search-the-web-input =
    .placeholder = Nadi di Web
    .title = Nadi di Web
    .aria-label = Nadi di Web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Rnu amsedday n unadi
newtab-topsites-add-topsites-header = Asmel ifazen amaynut
newtab-topsites-edit-topsites-header = Ẓreg asmel ifazen
newtab-topsites-title-label = Azwel
newtab-topsites-title-input =
    .placeholder = Sekcem azwel

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Aru neɣ sekcem tansa URL
newtab-topsites-url-validation = Tansa URL tameɣtut tettwasra

newtab-topsites-image-url-label = Tugna tudmawant URL
newtab-topsites-use-image-link = Seqdec tugna tudmawant…
newtab-topsites-image-validation = Tugna ur d-uli ara. Ɛreḍ tansa-nniḍen URL.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Sefsex
newtab-topsites-delete-history-button = Kkes seg umazray
newtab-topsites-save-button = Sekles
newtab-topsites-preview-button = Taskant
newtab-topsites-add-button = Rnu

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Tebɣiḍ ad tekksed yal tummant n usebter-agi seg umazray-ik?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Tigawt-agi ur tettuɣal ara ar deffir.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Ldi umuɣ
    .aria-label = Ldi umuɣ

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Kkes
    .aria-label = Kkes

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Ldi umuɣ
    .aria-label = Ldi umuɣ asatal i { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Ẓreg asmel-agi
    .aria-label = Ẓreg asmel-agi

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Ẓreg
newtab-menu-open-new-window = Ldi deg usfaylu amaynut
newtab-menu-open-new-private-window = Ldi deg usfaylu uslig amaynut
newtab-menu-dismiss = Kkes
newtab-menu-pin = Senteḍ
newtab-menu-unpin = Serreḥ
newtab-menu-delete-history = Kkes seg umazray
newtab-menu-save-to-pocket = Sekles ɣer { -pocket-brand-name }
newtab-menu-delete-pocket = Kkes si { -pocket-brand-name }
newtab-menu-archive-pocket = Ḥrez di { -pocket-brand-name }
newtab-menu-show-privacy-info = Wid yettbeddan fell-aɣ akked tudert-ik tabaḍnit

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Immed
newtab-privacy-modal-button-manage = Sefrek iɣewwaren n ugbur yettwarefden
newtab-privacy-modal-header = Aqadeṛ n tudert-ik tabaḍnit yeɛna-aɣ.
newtab-privacy-modal-paragraph-2 = Ɣer tama n beṭṭu n teqsiḍin ijebbden, ad ak-d-nesken daɣen igburen usdiden akked wid yettbeddan fell-ak i d-nefren s telqay. Kkes aɣilif imi isefka-ik n tunigin ur teffɣen ara segunqal i tḥerzeḍ n { -brand-product-name }— ur ten-nettwali ara, ula d wid i yettbeddan fell-aɣ.
newtab-privacy-modal-link = Lmed amek tettedu tbaḍnit deg yiccer amaynut

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Kkes tacreṭ-agi
# Bookmark is a verb here.
newtab-menu-bookmark = Creḍ asebter-agi

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Nɣel tansa n useɣwen n usali
newtab-menu-go-to-download-page = Ddu ɣer usebter n usider
newtab-menu-remove-download = Kkes seg umazray

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Sken deg Finder
       *[other] Ldi akaram deg yella ufaylu
    }
newtab-menu-open-file = Ldi afaylu

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Yettwarza
newtab-label-bookmarked = Yettwacreḍ
newtab-label-removed-bookmark = Tacreṭ n usebter tettwakkes
newtab-label-recommended = Tiddin
newtab-label-saved = Yettwakles ɣer { -pocket-brand-name }
newtab-label-download = Yuli-d

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Yettwarfed

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Ddaw leɛnaya n { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Kkes tigezmi
newtab-section-menu-collapse-section = Fneẓ tigezmi
newtab-section-menu-expand-section = Snefli tigezmi
newtab-section-menu-manage-section = Sefrek tigezmi
newtab-section-menu-manage-webext = Sefrek asiɣzef
newtab-section-menu-add-topsite = Rnu asmel ifazen
newtab-section-menu-add-search-engine = Rnu amsedday n unadi
newtab-section-menu-move-up = Ali
newtab-section-menu-move-down = Ader
newtab-section-menu-privacy-notice = Tasertit n tbaḍnit

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Fneẓ tigezmi
newtab-section-expand-section-label =
    .aria-label = Snefli tigezmi

## Section Headers.

newtab-section-header-topsites = Ismal ifazen
newtab-section-header-highlights = Asebrureq
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Iwelleh-it-id { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Bdu tuniginn sakin nekkni ad k-n-sken imagraden, tividyutin, akked isebtar nniḍen i γef terziḍ yakan neγ i tceṛḍeḍ dagi.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Ulac wiyaḍ. Uɣal-d ticki s wugar n imagraden seg { $provider }. Ur tebɣiḍ ara ad terǧuḍ? Fren asentel seg wid yettwasnen akken ad twaliḍ imagraden yelhan di Web.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Ulac d acu yellan.
newtab-discovery-empty-section-topstories-content = Uɣal-d ticki akken ad tafeḍ ugar n teqsiḍin.
newtab-discovery-empty-section-topstories-try-again-button = Ɛreḍ tikkelt-nniḍen
newtab-discovery-empty-section-topstories-loading = Asali…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Ihuh! Waqil tigezmi ur d-tuli ara akken iwata.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Isental ittwasnen aṭas:
newtab-pocket-more-recommendations = Ugar n iwellihen
newtab-pocket-learn-more = Issin ugar
newtab-pocket-cta-button = Awi-d { -pocket-brand-name }
newtab-pocket-cta-text = Sekles tiqṣiḍin i tḥemmleḍ deg { -pocket-brand-name }, sedhu allaɣ-ik s tɣuri ifazen.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Ihuh, yella wayen yeḍran deg usali n ugbur-a.
newtab-error-fallback-refresh-link = Sali-d aseter akken ad talseḍ aɛraḍ.
