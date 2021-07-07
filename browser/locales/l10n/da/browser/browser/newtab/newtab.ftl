# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Nyt faneblad
newtab-settings-button =
    .title = Tilpas siden Nyt faneblad
newtab-personalize-button-label = Tilpas
    .title = Tilpas nyt faneblad
    .aria-label = Tilpas nyt faneblad
newtab-personalize-dialog-label =
    .aria-label = Tilpas

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Søg
    .aria-label = Søg
newtab-search-box-search-the-web-text = Søg på internettet
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = Søg med { $engine } eller indtast adresse
newtab-search-box-handoff-text-no-engine = Søg eller indtast adresse
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = Søg med { $engine } eller indtast adresse
    .title = Søg med { $engine } eller indtast adresse
    .aria-label = Søg med { $engine } eller indtast adresse
newtab-search-box-handoff-input-no-engine =
    .placeholder = Søg eller indtast adresse
    .title = Søg eller indtast adresse
    .aria-label = Søg eller indtast adresse
newtab-search-box-search-the-web-input =
    .placeholder = Søg på internettet
    .title = Søg på internettet
    .aria-label = Søg på internettet
newtab-search-box-text = Søg på nettet
newtab-search-box-input =
    .placeholder = Søg på nettet
    .aria-label = Søg på nettet

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Tilføj søgetjeneste
newtab-topsites-add-topsites-header = Ny webside
newtab-topsites-add-shortcut-header = Ny genvej
newtab-topsites-edit-topsites-header = Rediger mest besøgte webside
newtab-topsites-edit-shortcut-header = Rediger genvej
newtab-topsites-title-label = Titel
newtab-topsites-title-input =
    .placeholder = Indtast en titel
newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Indtast eller indsæt en URL
newtab-topsites-url-validation = Gyldig URL påkrævet
newtab-topsites-image-url-label = URL til selvvalgt billede
newtab-topsites-use-image-link = Brug selvvalgt billede…
newtab-topsites-image-validation = Kunne ikke indlæse billede. Prøv en anden URL.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Annuller
newtab-topsites-delete-history-button = Slet fra historik
newtab-topsites-save-button = Gem
newtab-topsites-preview-button = Vis prøve
newtab-topsites-add-button = Tilføj

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Er du sikker på, at du vil slette alle forekomster af denne side fra din historik?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Denne handling kan ikke fortrydes.

## Top Sites - Sponsored label

newtab-topsite-sponsored = Sponsoreret

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Åbn menu
    .aria-label = Åbn menu
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Fjern
    .aria-label = Fjern
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Åbn menu
    .aria-label = Åbn genvejsmenuen for { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Rediger denne webside
    .aria-label = Rediger denne webside

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Rediger
newtab-menu-open-new-window = Åbn i et nyt vindue
newtab-menu-open-new-private-window = Åbn i et nyt privat vindue
newtab-menu-dismiss = Afvis
newtab-menu-pin = Fastgør
newtab-menu-unpin = Frigør
newtab-menu-delete-history = Slet fra historik
newtab-menu-save-to-pocket = Gem til { -pocket-brand-name }
newtab-menu-delete-pocket = Slet fra { -pocket-brand-name }
newtab-menu-archive-pocket = Arkiver i { -pocket-brand-name }
newtab-menu-show-privacy-info = Vores sponsorer og dit privatliv

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Færdig
newtab-privacy-modal-button-manage = Håndter indstillinger for sponsoreret indhold
newtab-privacy-modal-header = Du har ret til et privatliv
newtab-privacy-modal-paragraph-2 =
    Udover at servere fængslende historier viser vi dig også relevant
    og grundigt undersøgt indhold fra udvalgte sponsorer. Du kan være 
    sikker på, at <strong>dine data aldrig kommer videre end den version af 
    { -brand-product-name }, du har på din computer </strong> — Vi ser ikke dine data, 
    og det gør vores sponsorer heller ikke.
newtab-privacy-modal-link = Læs mere om, hvordan sikring af dit privatliv fungerer i nyt faneblad

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Fjern bogmærke
# Bookmark is a verb here.
newtab-menu-bookmark = Bogmærk

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Kopier linkadresse
newtab-menu-go-to-download-page = Gå til siden, filen blev hentet fra
newtab-menu-remove-download = Fjern fra historik

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Vis i Finder
       *[other] Åbn hentningsmappe
    }
newtab-menu-open-file = Åbn fil

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Besøgt
newtab-label-bookmarked = Bogmærket
newtab-label-removed-bookmark = Bogmærke fjernet
newtab-label-recommended = Populært
newtab-label-saved = Gemt til { -pocket-brand-name }
newtab-label-download = Hentet
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Sponsoreret
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Sponsoreret af { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Fjern afsnit
newtab-section-menu-collapse-section = Sammenfold afsnit
newtab-section-menu-expand-section = Udvid afsnit
newtab-section-menu-manage-section = Håndter afsnit
newtab-section-menu-manage-webext = Håndter udvidelse
newtab-section-menu-add-topsite = Tilføj ny webside
newtab-section-menu-add-search-engine = Tilføj søgetjeneste
newtab-section-menu-move-up = Flyt op
newtab-section-menu-move-down = Flyt ned
newtab-section-menu-privacy-notice = Privatlivspolitik

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Sammenfold afsnit
newtab-section-expand-section-label =
    .aria-label = Udvid afsnit

## Section Headers.

newtab-section-header-topsites = Mest besøgte websider
newtab-section-header-highlights = Fremhævede
newtab-section-header-recent-activity = Seneste aktivitet
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Anbefalet af { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Gå i gang med at browse, så vil vi vise dig nogle af de artikler, videoer og andre sider, du har besøgt eller gemt et bogmærke til for nylig.
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Der er ikke flere nye historier. Kom tilbage senere for at se flere tophistorier fra { $provider }. Kan du ikke vente? Vælg et populært emne og find flere spændende historier fra hele verden.

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Du har læst det hele!
newtab-discovery-empty-section-topstories-content = Kom tilbage senere for at se flere historier.
newtab-discovery-empty-section-topstories-try-again-button = Prøv igen
newtab-discovery-empty-section-topstories-loading = Indlæser…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Hov. Det lykkedes ikke at indlæse afsnittet.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Populære emner:
newtab-pocket-more-recommendations = Flere anbefalinger
newtab-pocket-learn-more = Læs mere
newtab-pocket-cta-button = Hent { -pocket-brand-name }
newtab-pocket-cta-text = Gem dine yndlingshistorier i { -pocket-brand-name } og hav dem altid ved hånden.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Hovsa. Noget gik galt ved indlæsning af indholdet.
newtab-error-fallback-refresh-link = Prøv igen ved at genindlæse siden.

## Customization Menu

newtab-custom-shortcuts-title = Genveje
newtab-custom-shortcuts-subtitle = Gemte eller besøgte websteder
newtab-custom-row-selector =
    { $num ->
        [one] { $num } række
       *[other] { $num } rækker
    }
newtab-custom-sponsored-sites = Sponsorerede genveje
newtab-custom-pocket-title = Anbefalet af { -pocket-brand-name }
newtab-custom-pocket-subtitle = Interessant indhold udvalgt af { -pocket-brand-name }, en del af { -brand-product-name }-familien
newtab-custom-pocket-sponsored = Sponsorerede historier
newtab-custom-recent-title = Seneste aktivitet
newtab-custom-recent-subtitle = Et udvalg af seneste websteder og indhold
newtab-custom-close-button = Luk
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
newtab-custom-snippets-title = Notitser
newtab-custom-snippets-subtitle = Tips og nyheder fra { -vendor-short-name } og { -brand-product-name }
newtab-custom-settings = Håndter flere indstillinger
