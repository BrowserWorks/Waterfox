# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Nýr flipi
newtab-settings-button =
    .title = Sérsníða ræsisíðuna

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Leita
    .aria-label = Leita

newtab-search-box-search-the-web-text = Leita á vefnum
newtab-search-box-search-the-web-input =
    .placeholder = Leita á vefnum
    .title = Leita á vefnum
    .aria-label = Leita á vefnum

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Bæta við leitarvél
newtab-topsites-add-topsites-header = Ný toppsíða
newtab-topsites-edit-topsites-header = Breyta toppsíðu
newtab-topsites-title-label = Titill
newtab-topsites-title-input =
    .placeholder = Sláðu inn titil

newtab-topsites-url-label = Vefslóð
newtab-topsites-url-input =
    .placeholder = Slá inn eða líma vefslóð
newtab-topsites-url-validation = Gildrar vefslóðar krafist

newtab-topsites-image-url-label = Sérsniðin myndslóð
newtab-topsites-use-image-link = Nota sérsniðna mynd…
newtab-topsites-image-validation = Ekki tókst að hlaða mynd. Prófið aðra vefslóð.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Hætta við
newtab-topsites-delete-history-button = Eyða úr ferli
newtab-topsites-save-button = Vista
newtab-topsites-preview-button = Forskoðun
newtab-topsites-add-button = Bæta við

## Top Sites - Delete history confirmation dialog. 

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Ertu viss um að þú viljir eyða öllum tilvikum af þessari síðu úr vafraferli þínum?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Ekki er ekki hægt að bakfæra þessa aðgerð.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Opna valmynd
    .aria-label = Opna valmynd

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Opna valmynd
    .aria-label = Opna samhengisvalmynd fyrir { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Breyta þessari síðu
    .aria-label = Breyta þessari síðu

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Breyta
newtab-menu-open-new-window = Opna í nýjum glugga
newtab-menu-open-new-private-window = Opna í nýjum huliðsglugga
newtab-menu-dismiss = Hafna
newtab-menu-pin = Festa
newtab-menu-unpin = Leysa
newtab-menu-delete-history = Eyða úr ferli
newtab-menu-save-to-pocket = Vista í { -pocket-brand-name }
newtab-menu-delete-pocket = Eyða úr { -pocket-brand-name }
newtab-menu-archive-pocket = Safna í { -pocket-brand-name }

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Fjarlægja bókamerki
# Bookmark is a verb here.
newtab-menu-bookmark = Bókamerkja

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb, 
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Afrita niðurhalsslóð
newtab-menu-go-to-download-page = Opna niðurhalssíðu
newtab-menu-remove-download = Eyða úr vafraferli

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Sýna í Finder
       *[other] Opna möppu
    }
newtab-menu-open-file = Opna skrá

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Heimsótt
newtab-label-bookmarked = Búið að bókamerkja
newtab-label-recommended = Vinsælt
newtab-label-saved = Vistað í { -pocket-brand-name }
newtab-label-download = Niðurhalað

## Section Menu: These strings are displayed in the section context menu and are 
## meant as a call to action for the given section.

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Fjarlægja kafla
newtab-section-menu-collapse-section = Fella kafla
newtab-section-menu-expand-section = Stækka kafla
newtab-section-menu-manage-section = Stjórna kafla
newtab-section-menu-manage-webext = Stjórna viðbót
newtab-section-menu-add-topsite = Bæta við toppsíðu
newtab-section-menu-add-search-engine = Bæta við leitarvél
newtab-section-menu-move-up = Færa upp
newtab-section-menu-move-down = Færa niður
newtab-section-menu-privacy-notice = Tilkynning um friðhelgi

## Section aria-labels

## Section Headers.

newtab-section-header-topsites = Efstu vefsvæðin
newtab-section-header-highlights = Hápunktar
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Með þessu mælir { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Byrjaðu að vafra og við sýnum þér frábærar greinar, myndbönd og önnur vefsvæði sem þú hefur nýverið heimsótt eða bókarmerkt.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Þú hefur lesið allt. Athugaðu aftur síðar eftir fleiri fréttum frá { $provider }. Geturðu ekki beðið? Veldu vinsælt umfjöllunarefni til að finna fleiri áhugaverðar greinar hvaðanæva að af vefnum.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Helstu umræðuefni:
newtab-pocket-more-recommendations = Fleiri meðmæli
newtab-pocket-cta-button = Sækja { -pocket-brand-name }
newtab-pocket-cta-text = Vistaðu sögurnar sem þú elskar í { -pocket-brand-name } og fáðu innblástur í huga þinn með heillandi lesningu.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Úbbs, eitthvað fór úrskeiðis við að hlaða þessu efni inn.
newtab-error-fallback-refresh-link = Endurhlaðið síðu til að reyna aftur.
