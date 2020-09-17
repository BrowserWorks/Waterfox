# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Nowy rajtark
newtab-settings-button =
    .title = Stronu wašeho noweho rajtarka přiměrić

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Pytać
    .aria-label = Pytać

newtab-search-box-search-the-web-text = Web přepytać
newtab-search-box-search-the-web-input =
    .placeholder = Web přepytać
    .title = Web přepytać
    .aria-label = Web přepytać

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Pytawu přidać
newtab-topsites-add-topsites-header = Nowe najhusćišo wopytane sydło
newtab-topsites-edit-topsites-header = Najhusćišo wopytane sydło wobdźěłać
newtab-topsites-title-label = Titul
newtab-topsites-title-input =
    .placeholder = Titul zapodać

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = URL zapodać abo zasadźić
newtab-topsites-url-validation = Płaćiwy URL trěbny

newtab-topsites-image-url-label = URL swójskeho wobraza
newtab-topsites-use-image-link = Swójski wobraz wužiwać…
newtab-topsites-image-validation = Wobraz njeda so začitać. Spytajće druhi URL.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Přetorhnyć
newtab-topsites-delete-history-button = Z historije zhašeć
newtab-topsites-save-button = Składować
newtab-topsites-preview-button = Přehlad
newtab-topsites-add-button = Přidać

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Chceće woprawdźe kóždu instancu tuteje strony ze swojeje historije zhašeć?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Tuta akcija njeda so cofnyć.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Meni wočinić
    .aria-label = Meni wočinić

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Wotstronić
    .aria-label = Wotstronić

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Meni wočinić
    .aria-label = Kontekstowy meni za { $title } wočinić
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Tute sydło wobdźěłać
    .aria-label = Tute sydło wobdźěłać

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Wobdźěłać
newtab-menu-open-new-window = W nowym woknje wočinić
newtab-menu-open-new-private-window = W nowym priwatnym woknje wočinić
newtab-menu-dismiss = Zaćisnyć
newtab-menu-pin = Připjeć
newtab-menu-unpin = Wotpjeć
newtab-menu-delete-history = Z historije zhašeć
newtab-menu-save-to-pocket = Pola { -pocket-brand-name } składować
newtab-menu-delete-pocket = Z { -pocket-brand-name } zhašeć
newtab-menu-archive-pocket = W { -pocket-brand-name } archiwować
newtab-menu-show-privacy-info = Naši sponsorojo a waša priwatnosć

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Dokónčene
newtab-privacy-modal-button-manage = Nastajenja sponsorowaneho wobsaha rjadować
newtab-privacy-modal-header = Waša priwatnosć je wažna
newtab-privacy-modal-paragraph-2 =
    Přidatnje k napowědanju putawych powědančkow, pokazujemy wam tež relewantny, 
    jara přepruwowany wobsah wot wubranych sponsorow. Budźće zawěsćeny, <strong>waše přehladowanske 
    daty wašu wosobinsku wersiju { -brand-product-name } ženje njewopušća</strong> ­­- njewidźimy je, a naši 
    sponsorojo tež nic.
newtab-privacy-modal-link = Zhońće, kak priwatnosć w nowym rajtarku funguje

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Zapołožku wotstronić
# Bookmark is a verb here.
newtab-menu-bookmark = Zapołožki składować

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Sćehnjenski wotkaz kopěrować
newtab-menu-go-to-download-page = K sćehnjenskej stronje přeńć
newtab-menu-remove-download = Z historije wotstronić

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] W Finder pokazać
       *[other] Wobsahowacy rjadowak wočinić
    }
newtab-menu-open-file = Dataju wočinić

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Wopytany
newtab-label-bookmarked = Jako zapołožka składowany
newtab-label-removed-bookmark = Zapołožka je so wotstroniła
newtab-label-recommended = Popularny
newtab-label-saved = Do { -pocket-brand-name } składowany
newtab-label-download = Sćehnjeny

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } - sponsorowane

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Sponsorowany wot { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Wotrězk wotstronić
newtab-section-menu-collapse-section = Wotrězk schować
newtab-section-menu-expand-section = Wotrězk pokazać
newtab-section-menu-manage-section = Wotrězk rjadować
newtab-section-menu-manage-webext = Rozšěrjenje rjadować
newtab-section-menu-add-topsite = Woblubowane sydło přidać
newtab-section-menu-add-search-engine = Pytawu přidać
newtab-section-menu-move-up = Horje
newtab-section-menu-move-down = Dele
newtab-section-menu-privacy-notice = Zdźělenka priwatnosće

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Wotrězk schować
newtab-section-expand-section-label =
    .aria-label = Wotrězk pokazać

## Section Headers.

newtab-section-header-topsites = Najhusćišo wopytane sydła
newtab-section-header-highlights = Wjerški
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Wot { $provider } doporučeny

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Započńće přehladować, a pokazamy někotre wulkotne nastawki, wideja a druhe strony, kotrež sće njedawno wopytał abo tu jako zapołožki składował.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = To je nachwilu wšitko. Wróćće so pozdźišo dalšich wulkotnych stawiznow dla wot { $provider }. Njemóžeće čakać? Wubjerće woblubowanu temu, zo byšće dalše wulkotne stawizny z weba namakał.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Sće dosćehnjeny!
newtab-discovery-empty-section-topstories-content = Hladajće pozdźišo za wjace stawiznami.
newtab-discovery-empty-section-topstories-try-again-button = Hišće raz spytać
newtab-discovery-empty-section-topstories-loading = Začita so…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Hopla! Smy tutón wotrězk bjezmała začitali, ale nic cyle.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Woblubowane temy:
newtab-pocket-more-recommendations = Dalše doporučenja
newtab-pocket-learn-more = Dalše informacije
newtab-pocket-cta-button = { -pocket-brand-name } wobstarać
newtab-pocket-cta-text = Składujće stawizny, kotrež so wam spodobuja, w { -pocket-brand-name } a žiwće swój duch z fascinowacymi čitančkami.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Hopla, při čitanju tutoho wobsaha je so něšto nimokuliło.
newtab-error-fallback-refresh-link = Aktualizujće stronu, zo byšće hišće raz spytał.
