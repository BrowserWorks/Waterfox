# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Ny flik
newtab-settings-button =
    .title = Anpassa sidan för Ny flik
newtab-personalize-button-label = Anpassa
    .title = Anpassa ny flik
    .aria-label = Anpassa ny flik
newtab-personalize-dialog-label =
    .aria-label = Anpassa

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Sök
    .aria-label = Sök
newtab-search-box-search-the-web-text = Sök på webben
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = Sök med { $engine } eller ange en adress
newtab-search-box-handoff-text-no-engine = Sök eller ange adress
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = Sök med { $engine } eller ange en adress
    .title = Sök med { $engine } eller ange en adress
    .aria-label = Sök med { $engine } eller ange en adress
newtab-search-box-handoff-input-no-engine =
    .placeholder = Sök eller ange adress
    .title = Sök eller ange adress
    .aria-label = Sök eller ange adress
newtab-search-box-search-the-web-input =
    .placeholder = Sök på webben
    .title = Sök på webben
    .aria-label = Sök på webben
newtab-search-box-text = Sök på webben
newtab-search-box-input =
    .placeholder = Sök på webben
    .aria-label = Sök på webben

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Lägg till sökmotor
newtab-topsites-add-topsites-header = Ny mest besökt
newtab-topsites-add-shortcut-header = Ny genväg
newtab-topsites-edit-topsites-header = Redigera mest besökta
newtab-topsites-edit-shortcut-header = Redigera genväg
newtab-topsites-title-label = Titel
newtab-topsites-title-input =
    .placeholder = Ange en titel
newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Skriv eller klistra in en URL
newtab-topsites-url-validation = Giltig URL krävs
newtab-topsites-image-url-label = Anpassa bild-URL
newtab-topsites-use-image-link = Använd en anpassad bild…
newtab-topsites-image-validation = Bilden misslyckades att ladda. Prova en annan URL.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Avbryt
newtab-topsites-delete-history-button = Ta bort från historik
newtab-topsites-save-button = Spara
newtab-topsites-preview-button = Förhandsvisa
newtab-topsites-add-button = Lägg till

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Är du säker på att du vill radera varje förekomst av den här sidan från din historik?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Den här åtgärden kan inte ångras.

## Top Sites - Sponsored label

newtab-topsite-sponsored = Sponsrad

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Öppna meny
    .aria-label = Öppna meny
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Ta bort
    .aria-label = Ta bort
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Öppna meny
    .aria-label = Öppna snabbmeny för { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Redigera denna webbplats
    .aria-label = Redigera denna webbplats

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Redigera
newtab-menu-open-new-window = Öppna i nytt fönster
newtab-menu-open-new-private-window = Öppna i nytt privat fönster
newtab-menu-dismiss = Ignorera
newtab-menu-pin = Fäst
newtab-menu-unpin = Lösgör
newtab-menu-delete-history = Ta bort från historik
newtab-menu-save-to-pocket = Spara till { -pocket-brand-name }
newtab-menu-delete-pocket = Ta bort från { -pocket-brand-name }
newtab-menu-archive-pocket = Arkivera i { -pocket-brand-name }
newtab-menu-show-privacy-info = Våra sponsorer & din integritet

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Klar
newtab-privacy-modal-button-manage = Hantera sponsrade innehållsinställningar
newtab-privacy-modal-header = Din integritet är viktig.
newtab-privacy-modal-paragraph-2 =
    Förutom att servera fängslande berättelser, visar vi dig också relevant,
    högt kontrollerat innehåll från utvalda sponsorer. Du kan vara säker på att <strong>din surfinformation
    inte lämnar din personliga kopia av { -brand-product-name }</strong> — vi ser inte den och våra
    sponsorer gör det inte heller.
newtab-privacy-modal-link = Lär dig hur sekretess fungerar på den nya fliken

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Ta bort bokmärke
# Bookmark is a verb here.
newtab-menu-bookmark = Bokmärke

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Kopiera nedladdningslänk
newtab-menu-go-to-download-page = Gå till hämtningssida
newtab-menu-remove-download = Ta bort från historik

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Visa i Finder
       *[other] Öppna objektets mapp
    }
newtab-menu-open-file = Öppna fil

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Besökta
newtab-label-bookmarked = Bokmärkta
newtab-label-removed-bookmark = Bokmärke har tagits bort
newtab-label-recommended = Trend
newtab-label-saved = Spara till { -pocket-brand-name }
newtab-label-download = Hämtat
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Sponsrad
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Sponsrad av { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Ta bort sektion
newtab-section-menu-collapse-section = Fäll ihop sektion
newtab-section-menu-expand-section = Expandera sektion
newtab-section-menu-manage-section = Hantera sektion
newtab-section-menu-manage-webext = Hantera tillägg
newtab-section-menu-add-topsite = Lägg till mest besökta
newtab-section-menu-add-search-engine = Lägg till sökmotor
newtab-section-menu-move-up = Flytta upp
newtab-section-menu-move-down = Flytta ner
newtab-section-menu-privacy-notice = Sekretesspolicy

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Fäll ihop sektion
newtab-section-expand-section-label =
    .aria-label = Expandera sektion

## Section Headers.

newtab-section-header-topsites = Mest besökta
newtab-section-header-highlights = Höjdpunkter
newtab-section-header-recent-activity = Senaste aktivitet
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Rekommenderas av { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Börja surfa, och vi visar några av de bästa artiklarna, videoklippen och andra sidor du nyligen har besökt eller bokmärkt här.
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Det finns inte fler. Kom tillbaka senare för fler huvudnyheter från { $provider }. Kan du inte vänta? Välj ett populärt ämne för att hitta fler bra nyheter från hela världen.

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Du är ikapp!
newtab-discovery-empty-section-topstories-content = Kom tillbaka senare för fler nyheter.
newtab-discovery-empty-section-topstories-try-again-button = Försök igen
newtab-discovery-empty-section-topstories-loading = Laddar…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Hoppsan! Vi laddade nästan detta avsnitt, men inte riktigt.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Populära ämnen:
newtab-pocket-more-recommendations = Fler rekommendationer
newtab-pocket-learn-more = Läs mer
newtab-pocket-cta-button = Hämta { -pocket-brand-name }
newtab-pocket-cta-text = Spara de nyheter som du tycker är intressant i { -pocket-brand-name } och stimulera dina tankar med fascinerande läsmaterial.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Oj, något gick fel när innehållet skulle laddas.
newtab-error-fallback-refresh-link = Uppdatera sidan för att försöka igen.

## Customization Menu

newtab-custom-shortcuts-title = Genvägar
newtab-custom-shortcuts-subtitle = Webbplatser du sparar eller besöker
newtab-custom-row-selector =
    { $num ->
        [one] { $num } rad
       *[other] { $num } rader
    }
newtab-custom-sponsored-sites = Sponsrade genvägar
newtab-custom-pocket-title = Rekommenderas av { -pocket-brand-name }
newtab-custom-pocket-subtitle = Särskilt innehåll valt av { -pocket-brand-name }, en del av familjen { -brand-product-name }
newtab-custom-pocket-sponsored = Sponsrade nyheter
newtab-custom-recent-title = Senaste aktivitet
newtab-custom-recent-subtitle = Ett urval av senaste webbplatser och innehåll
newtab-custom-close-button = Stäng
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
newtab-custom-snippets-title = Kort information
newtab-custom-snippets-subtitle = Tips och nyheter från { -vendor-short-name } och { -brand-product-name }
newtab-custom-settings = Hantera fler inställningar
