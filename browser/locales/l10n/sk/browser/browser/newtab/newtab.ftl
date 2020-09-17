# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Nová karta
newtab-settings-button =
    .title = Prispôsobte si svoju stránku Nová karta

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Hľadať
    .aria-label = Hľadať

newtab-search-box-search-the-web-text = Vyhľadávanie na webe
newtab-search-box-search-the-web-input =
    .placeholder = Vyhľadávanie na webe
    .title = Vyhľadávanie na webe
    .aria-label = Vyhľadávanie na webe

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Pridať vyhľadávací modul
newtab-topsites-add-topsites-header = Nová top stránka
newtab-topsites-edit-topsites-header = Upraviť top stránku
newtab-topsites-title-label = Názov
newtab-topsites-title-input =
    .placeholder = Zadajte názov

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Zadajte alebo prilepte URL
newtab-topsites-url-validation = Vyžaduje sa platná URL

newtab-topsites-image-url-label = URL adresa vlastného obrázku
newtab-topsites-use-image-link = Použiť vlastný obrázok…
newtab-topsites-image-validation = Obrázok sa nepodarilo načítať. Skúste inú URL adresu.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Zrušiť
newtab-topsites-delete-history-button = Odstrániť z histórie
newtab-topsites-save-button = Uložiť
newtab-topsites-preview-button = Ukážka
newtab-topsites-add-button = Pridať

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Ste si istí, že chcete odstrániť všetky výskyty tejto stránky zo svojej histórie prehliadania?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Túto akciu nie je možné vrátiť späť.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Otvorí ponuku
    .aria-label = Otvorí ponuku

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Odstrániť
    .aria-label = Odstrániť

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Otvorí ponuku
    .aria-label = Otvorí kontextovú ponuku pre { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Upraviť túto stránku
    .aria-label = Upraviť túto stránku

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Upraviť
newtab-menu-open-new-window = Otvoriť v novom okne
newtab-menu-open-new-private-window = Otvoriť v novom súkromnom okne
newtab-menu-dismiss = Skryť
newtab-menu-pin = Pripnúť
newtab-menu-unpin = Odopnúť
newtab-menu-delete-history = Odstrániť z histórie
newtab-menu-save-to-pocket = Uložiť do služby { -pocket-brand-name }
newtab-menu-delete-pocket = Odstrániť zo služby { -pocket-brand-name }
newtab-menu-archive-pocket = Archivovať v službe { -pocket-brand-name }
newtab-menu-show-privacy-info = Naši sponzori a vaše súkromie

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Hotovo
newtab-privacy-modal-button-manage = Nastavenie sponzorovaného obsahu
newtab-privacy-modal-header = Na vašom súkromí záleží.
newtab-privacy-modal-paragraph-2 = Okrem zaujímavých článkov vám taktiež zobrazujeme relevantný a preverený obsah od vybraných sponzorov. Nemusíte sa báť, <strong>vaše údaje nikdy neopustia { -brand-product-name }</strong> - neodosielajú sa nám ani našim sponzorom.
newtab-privacy-modal-link = Ďalšie informácie o tom, ako funguje súkromie na stránke novej karty

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Odstrániť záložku
# Bookmark is a verb here.
newtab-menu-bookmark = Pridať medzi záložky

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Kopírovať adresu súboru
newtab-menu-go-to-download-page = Prejsť na stránku so súborom
newtab-menu-remove-download = Odstrániť z histórie

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Zobraziť vo Finderi
       *[other] Otvoriť priečinok so súborom
    }
newtab-menu-open-file = Otvoriť súbor

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Navštívené
newtab-label-bookmarked = V záložkách
newtab-label-removed-bookmark = Záložka bola odstránená
newtab-label-recommended = Trendy
newtab-label-saved = Uložené do služby { -pocket-brand-name }
newtab-label-download = Prevzaté

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Sponzorované

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Sponzorované spoločnosťou { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Odstrániť sekciu
newtab-section-menu-collapse-section = Zbaliť sekciu
newtab-section-menu-expand-section = Rozbaliť sekciu
newtab-section-menu-manage-section = Spravovať sekciu
newtab-section-menu-manage-webext = Správa rozšírenia
newtab-section-menu-add-topsite = Pridať top stránku
newtab-section-menu-add-search-engine = Pridať vyhľadávací modul
newtab-section-menu-move-up = Posunúť vyššie
newtab-section-menu-move-down = Posunúť nižšie
newtab-section-menu-privacy-notice = Zásady ochrany súkromia

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Zbaliť sekciu
newtab-section-expand-section-label =
    .aria-label = Rozbaliť sekciu

## Section Headers.

newtab-section-header-topsites = Top stránky
newtab-section-header-highlights = Vybrané stránky
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Odporúča { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Začnite s prehliadaním a my vám na tomto mieste ukážeme skvelé články, videá a ostatné stránky, ktoré ste nedávno navštívili alebo pridali medzi záložky.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Už ste prečítali všetko. Ďalšie príbehy zo služby { $provider } tu nájdete opäť neskôr. Nemôžete sa dočkať? Vyberte si populárnu tému a pozrite sa na ďalšie skvelé príbehy z celého webu.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Už ste prečítali všetko!
newtab-discovery-empty-section-topstories-content = Ďalšie príbehy tu nájdete opäť neskôr.
newtab-discovery-empty-section-topstories-try-again-button = Skúsiť znova
newtab-discovery-empty-section-topstories-loading = Načítava sa…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Hups! Túto sekciu sa nepodarilo načítať.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Populárne témy:
newtab-pocket-more-recommendations = Ďalšie odporúčania
newtab-pocket-learn-more = Ďalšie informácie
newtab-pocket-cta-button = Získajte { -pocket-brand-name }
newtab-pocket-cta-text = Ukladajte si články do služby { -pocket-brand-name } a užívajte si skvelé čítanie.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Hups, pri načítavaní tohto obsahu sa niečo pokazilo.
newtab-error-fallback-refresh-link = Obnovením stránky to skúsite znova.
