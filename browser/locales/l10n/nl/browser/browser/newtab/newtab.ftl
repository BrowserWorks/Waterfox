# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Waterfox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Nieuw tabblad
newtab-settings-button =
    .title = Uw Nieuw-tabbladpagina aanpassen
newtab-personalize-icon-label =
    .title = Nieuw tabblad personaliseren
    .aria-label = Nieuw tabblad personaliseren
newtab-personalize-dialog-label =
    .aria-label = Personaliseren

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Zoeken
    .aria-label = Zoeken
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = Met { $engine } zoeken of voer adres in
newtab-search-box-handoff-text-no-engine = Voer zoekterm of adres in
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = Met { $engine } zoeken of voer adres in
    .title = Met { $engine } zoeken of voer adres in
    .aria-label = Met { $engine } zoeken of voer adres in
newtab-search-box-handoff-input-no-engine =
    .placeholder = Voer zoekterm of adres in
    .title = Voer zoekterm of adres in
    .aria-label = Voer zoekterm of adres in
newtab-search-box-search-the-web-input =
    .placeholder = Zoeken op het web
    .title = Zoeken op het web
    .aria-label = Zoeken op het web
newtab-search-box-text = Zoeken op het web
newtab-search-box-input =
    .placeholder = Zoeken op het web
    .aria-label = Zoeken op het web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Zoekmachine toevoegen
newtab-topsites-add-topsites-header = Nieuwe topwebsite
newtab-topsites-add-shortcut-header = Nieuwe snelkoppeling
newtab-topsites-edit-topsites-header = Topwebsite bewerken
newtab-topsites-edit-shortcut-header = Snelkoppeling bewerken
newtab-topsites-title-label = Titel
newtab-topsites-title-input =
    .placeholder = Voer een titel in
newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Typ of plak een URL
newtab-topsites-url-validation = Geldige URL vereist
newtab-topsites-image-url-label = URL van aangepaste afbeelding
newtab-topsites-use-image-link = Een aangepaste afbeelding gebruiken…
newtab-topsites-image-validation = Afbeelding kon niet worden geladen. Probeer een andere URL.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Annuleren
newtab-topsites-delete-history-button = Verwijderen uit geschiedenis
newtab-topsites-save-button = Opslaan
newtab-topsites-preview-button = Voorbeeld
newtab-topsites-add-button = Toevoegen

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Weet u zeker dat u alle exemplaren van deze pagina uit uw geschiedenis wilt verwijderen?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Deze actie kan niet ongedaan worden gemaakt.

## Top Sites - Sponsored label

newtab-topsite-sponsored = Gesponsord

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Menu openen
    .aria-label = Menu openen
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Verwijderen
    .aria-label = Verwijderen
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Menu openen
    .aria-label = Contextmenu openen voor { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Deze website bewerken
    .aria-label = Deze website bewerken

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Bewerken
newtab-menu-open-new-window = Openen in een nieuw venster
newtab-menu-open-new-private-window = Openen in een nieuw privévenster
newtab-menu-dismiss = Sluiten
newtab-menu-pin = Vastmaken
newtab-menu-unpin = Losmaken
newtab-menu-delete-history = Verwijderen uit geschiedenis
newtab-menu-save-to-pocket = Opslaan naar { -pocket-brand-name }
newtab-menu-delete-pocket = Verwijderen uit { -pocket-brand-name }
newtab-menu-archive-pocket = Archiveren in { -pocket-brand-name }
newtab-menu-show-privacy-info = Onze sponsors en uw privacy

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Gereed
newtab-privacy-modal-button-manage = Instellingen voor gesponsorde inhoud beheren
newtab-privacy-modal-header = Uw privacy is belangrijk.
newtab-privacy-modal-paragraph-2 =
    Naast het vertellen van boeiende verhalen, tonen we u ook relevante,
    goed doorgelichte inhoud van geselecteerde sponsors. Wees gerust, <strong>uw navigatiegegevens
    verlaten nooit uw persoonlijke exemplaar van { -brand-product-name }</strong> – wij krijgen ze niet te zien,
    en onze sponsors ook niet.
newtab-privacy-modal-link = Ontdek hoe privacy werkt op het nieuwe tabblad

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Bladwijzer verwijderen
# Bookmark is a verb here.
newtab-menu-bookmark = Bladwijzer maken

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Downloadkoppeling kopiëren
newtab-menu-go-to-download-page = Naar downloadpagina gaan
newtab-menu-remove-download = Verwijderen uit geschiedenis

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Tonen in Finder
       *[other] Bijbehorende map openen
    }
newtab-menu-open-file = Bestand openen

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Bezocht
newtab-label-bookmarked = Bladwijzer gemaakt
newtab-label-removed-bookmark = Bladwijzer verwijderd
newtab-label-recommended = Trending
newtab-label-saved = Opgeslagen naar { -pocket-brand-name }
newtab-label-download = Gedownload
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Gesponsord
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Gesponsord door { $sponsor }
# This string is used under the image of story cards to indicate source and time to read
# Variables:
#  $source (String): This is the name of a company or their domain
#  $timeToRead (Number): This is the estimated number of minutes to read this story
newtab-label-source-read-time = { $source } · { $timeToRead } min.

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Sectie verwijderen
newtab-section-menu-collapse-section = Sectie samenvouwen
newtab-section-menu-expand-section = Sectie uitvouwen
newtab-section-menu-manage-section = Sectie beheren
newtab-section-menu-manage-webext = Extensie beheren
newtab-section-menu-add-topsite = Topwebsite toevoegen
newtab-section-menu-add-search-engine = Zoekmachine toevoegen
newtab-section-menu-move-up = Omhoog verplaatsen
newtab-section-menu-move-down = Omlaag verplaatsen
newtab-section-menu-privacy-notice = Privacyverklaring

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Sectie samenvouwen
newtab-section-expand-section-label =
    .aria-label = Sectie uitvouwen

## Section Headers.

newtab-section-header-topsites = Topwebsites
newtab-section-header-highlights = Highlights
newtab-section-header-recent-activity = Recente activiteit
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Aanbevolen door { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Begin met surfen, en we tonen hier een aantal geweldige artikelen, video’s en andere pagina’s die u onlangs hebt bezocht of waarvoor u een bladwijzer hebt gemaakt.
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = U bent weer bij. Kijk later nog eens voor meer topverhalen van { $provider }. Kunt u niet wachten? Selecteer een populair onderwerp voor meer geweldige verhalen van het hele web.

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = U bent helemaal bij!
newtab-discovery-empty-section-topstories-content = Kom later terug voor meer verhalen.
newtab-discovery-empty-section-topstories-try-again-button = Opnieuw proberen
newtab-discovery-empty-section-topstories-loading = Laden…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Oeps! We hadden deze sectie bijna geladen, maar toch niet helemaal.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Populaire onderwerpen:
newtab-pocket-new-topics-title = Wilt u nog meer verhalen? Bekijk deze populaire onderwerpen van { -pocket-brand-name }
newtab-pocket-more-recommendations = Meer aanbevelingen
newtab-pocket-learn-more = Meer info
newtab-pocket-cta-button = { -pocket-brand-name } gebruiken
newtab-pocket-cta-text = Bewaar de verhalen die u interessant vindt in { -pocket-brand-name }, en stimuleer uw gedachten met boeiende leesstof.
newtab-pocket-pocket-firefox-family = { -pocket-brand-name } maakt deel uit van de { -brand-product-name }-familie
# A save to Pocket button that shows over the card thumbnail on hover.
newtab-pocket-save-to-pocket = Opslaan naar { -pocket-brand-name }
newtab-pocket-saved-to-pocket = Opgeslagen naar { -pocket-brand-name }
# This is a button shown at the bottom of the Pocket section that loads more stories when clicked.
newtab-pocket-load-more-stories-button = Meer verhalen laden

## Pocket Final Card Section.
## This is for the final card in the Pocket grid.

newtab-pocket-last-card-title = U bent helemaal bij!
newtab-pocket-last-card-desc = Kom later terug voor meer.
newtab-pocket-last-card-image =
    .alt = U bent helemaal bij

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Oeps, er is iets misgegaan bij het laden van deze inhoud.
newtab-error-fallback-refresh-link = Vernieuw de pagina om het opnieuw te proberen.

## Customization Menu

newtab-custom-shortcuts-title = Snelkoppelingen
newtab-custom-shortcuts-subtitle = Opgeslagen of bezochte websites
newtab-custom-row-selector =
    { $num ->
        [one] { $num } rij
       *[other] { $num } rijen
    }
newtab-custom-sponsored-sites = Gesponsorde snelkoppelingen
newtab-custom-pocket-title = Aanbevolen door { -pocket-brand-name }
newtab-custom-pocket-subtitle = Uitzonderlijke inhoud, samengesteld door { -pocket-brand-name }, onderdeel van de { -brand-product-name }-familie
newtab-custom-pocket-sponsored = Gesponsorde verhalen
newtab-custom-recent-title = Recente activiteit
newtab-custom-recent-subtitle = Een selectie van recente websites en inhoud
newtab-custom-close-button = Sluiten
newtab-custom-settings = Meer instellingen beheren
