# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Nový panel
newtab-settings-button =
    .title = Přizpůsobení stránky nového panelu
newtab-personalize-button-label = Přizpůsobit
    .title = Přizpůsobení nového panelu
    .aria-label = Přizpůsobení nového panelu
newtab-personalize-dialog-label =
    .aria-label = Přizpůsobit

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Vyhledat
    .aria-label = Vyhledat
newtab-search-box-search-the-web-text = Vyhledat na webu
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = Zadejte webovou adresu nebo dotaz pro vyhledávač { $engine }
newtab-search-box-handoff-text-no-engine = Zadejte webovou adresu nebo dotaz pro vyhledávač
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = Zadejte webovou adresu nebo dotaz pro vyhledávač { $engine }
    .title = Zadejte webovou adresu nebo dotaz pro vyhledávač { $engine }
    .aria-label = Zadejte webovou adresu nebo dotaz pro vyhledávač { $engine }
newtab-search-box-handoff-input-no-engine =
    .placeholder = Zadejte webovou adresu nebo dotaz pro vyhledávač
    .title = Zadejte webovou adresu nebo dotaz pro vyhledávač
    .aria-label = Zadejte webovou adresu nebo dotaz pro vyhledávač
newtab-search-box-search-the-web-input =
    .placeholder = Vyhledat na webu
    .title = Vyhledat na webu
    .aria-label = Vyhledat na webu
newtab-search-box-text = Vyhledat na webu
newtab-search-box-input =
    .placeholder = Vyhledat na webu
    .aria-label = Vyhledat na webu

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Přidat vyhledávač
newtab-topsites-add-topsites-header = Nová top stránka
newtab-topsites-add-shortcut-header = Nová zkratka
newtab-topsites-edit-topsites-header = Upravit top stránku
newtab-topsites-edit-shortcut-header = Upravit zkratku
newtab-topsites-title-label = Název stránky
newtab-topsites-title-input =
    .placeholder = Zadejte název
newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Zadejte nebo vložte URL adresu
newtab-topsites-url-validation = Je vyžadována platná URL
newtab-topsites-image-url-label = URL adresa vlastního obrázku
newtab-topsites-use-image-link = Použít vlastní obrázek…
newtab-topsites-image-validation = Obrázek se nepodařilo načíst. Zkuste jinou URL adresu.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Zrušit
newtab-topsites-delete-history-button = Smazat z historie
newtab-topsites-save-button = Uložit
newtab-topsites-preview-button = Náhled
newtab-topsites-add-button = Přidat

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Opravdu chcete smazat všechny výskyty této stránky z historie vašeho prohlížení?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Tuto akci nelze vzít zpět.

## Top Sites - Sponsored label

newtab-topsite-sponsored = Sponzorováno

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Otevře nabídku
    .aria-label = Otevře nabídku
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Odstranit
    .aria-label = Odstranit
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Otevře nabídku
    .aria-label = Otevřít kontextovou nabídku pro { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Upravit tuto stránku
    .aria-label = Upravit tuto stránku

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Upravit
newtab-menu-open-new-window = Otevřít v novém okně
newtab-menu-open-new-private-window = Otevřít v novém anonymním okně
newtab-menu-dismiss = Skrýt
newtab-menu-pin = Připnout
newtab-menu-unpin = Odepnout
newtab-menu-delete-history = Smazat z historie
newtab-menu-save-to-pocket = Uložit do { -pocket-brand-name(case: "gen") }
newtab-menu-delete-pocket = Smazat z { -pocket-brand-name(case: "gen") }
newtab-menu-archive-pocket = Archivovat do { -pocket-brand-name(case: "gen") }
newtab-menu-show-privacy-info = Naši sponzoři a vaše soukromí

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Hotovo
newtab-privacy-modal-button-manage = Nastavení sponzorovaného obsahu
newtab-privacy-modal-header = Na vašem soukromí záleží.
newtab-privacy-modal-paragraph-2 =
    Kromě zajímavých článků zobrazujeme také relevantní a prověřený obsah od vybraných partnerů. Nemusíte se ale bát, <strong>vaše údaje nikdy neopustí { -brand-product-name.gender ->
        [masculine] váš { -brand-product-name(case: "acc") }
        [feminine] vaši { -brand-product-name(case: "acc") }
        [neuter] vaše { -brand-product-name(case: "acc") }
       *[other] vaši aplikaci { -brand-product-name }
    }</strong> - neodesílají se nám ani našim partnerům.
newtab-privacy-modal-link = Zjistěte, jak chráníme vaše soukromí na stránce nového panelu.

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Odebrat záložku
# Bookmark is a verb here.
newtab-menu-bookmark = Přidat do záložek

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Kopírovat stahovaný odkaz
newtab-menu-go-to-download-page = Přejít na stránku stahování
newtab-menu-remove-download = Odstranit z historie

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Zobrazit ve Finderu
       *[other] Otevřít složku
    }
newtab-menu-open-file = Otevřít soubor

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Navštívené
newtab-label-bookmarked = V záložkách
newtab-label-removed-bookmark = Záložka odebrána
newtab-label-recommended = Populární
newtab-label-saved = Uloženo do { -pocket-brand-name(case: "gen") }
newtab-label-download = Staženo
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · sponzrováno
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Sponzorováno společností { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Odebrat sekci
newtab-section-menu-collapse-section = Sbalit sekci
newtab-section-menu-expand-section = Rozbalit sekci
newtab-section-menu-manage-section = Nastavení sekce
newtab-section-menu-manage-webext = Správa rozšíření
newtab-section-menu-add-topsite = Přidat mezi top stránky
newtab-section-menu-add-search-engine = Přidat vyhledávač
newtab-section-menu-move-up = Posunout nahoru
newtab-section-menu-move-down = Posunout dolů
newtab-section-menu-privacy-notice = Zásady ochrany osobních údajů

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Sbalit sekci
newtab-section-expand-section-label =
    .aria-label = Rozbalit sekci

## Section Headers.

newtab-section-header-topsites = Top stránky
newtab-section-header-highlights = Vybrané
newtab-section-header-recent-activity = Nedávná aktivita
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Doporučení ze služby { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Začněte prohlížet a my vám zde ukážeme některé skvělé články, videa a další stránky, které jste nedávno viděli nebo uložili do záložek.
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Už jste všechno přečetli. Další články ze služby { $provider } tu najdete zase později. Ale pokud se nemůžete dočkat, vyberte své oblíbené téma a podívejte se na další velké články z celého webu.

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Už jste všechno přečetli.
newtab-discovery-empty-section-topstories-content = Další články zde najdete později.
newtab-discovery-empty-section-topstories-try-again-button = Zkusit znovu
newtab-discovery-empty-section-topstories-loading = Načítání…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Jejda, při načítání obsahu se něco pokazilo.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Populární témata:
newtab-pocket-more-recommendations = Další doporučení
newtab-pocket-learn-more = Zjistit více
newtab-pocket-cta-button = Získejte { -pocket-brand-name(case: "acc") }
newtab-pocket-cta-text = Ukládejte si články do { -pocket-brand-name(case: "gen") } a užívejte si skvělé čtení.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Jejda, při načítání tohoto obsahu se něco pokazilo.
newtab-error-fallback-refresh-link = Opětovným načtením stránky to zkuste znovu.

## Customization Menu

newtab-custom-shortcuts-title = Zkratky
newtab-custom-shortcuts-subtitle = Uložené nebo navštěvované stránky
newtab-custom-row-selector =
    { $num ->
        [one] Jeden řádek
        [few] { $num } řádky
       *[other] { $num } řádků
    }
newtab-custom-sponsored-sites = Sponzorované zkratky
newtab-custom-pocket-title = Doporučeno službou { -pocket-brand-name }
newtab-custom-pocket-subtitle = Výjimečný obsah vybraný službou { -pocket-brand-name }, která je součástí { -brand-product-name(case: "gen") }
newtab-custom-pocket-sponsored = Sponzorované články
newtab-custom-recent-title = Nedávná aktivita
newtab-custom-recent-subtitle = Výběr z nedávných stránek a obsahu
newtab-custom-close-button = Zavřít
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
newtab-custom-snippets-title = Útržky
newtab-custom-snippets-subtitle = Tipy a novinky od { -vendor-short-name(case: "gen") } a aplikace { -brand-product-name }
newtab-custom-settings = Další nastavení
