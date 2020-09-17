# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Nov tab
newtab-settings-button =
    .title = Persunalisar tia pagina per novs tabs

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Tschertgar
    .aria-label = Tschertgar

newtab-search-box-search-the-web-text = Tschertgar en il Web
newtab-search-box-search-the-web-input =
    .placeholder = Tschertgar en il Web
    .title = Tschertgar en il Web
    .aria-label = Tschertgar en il Web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Agiuntar maschina da tschertgar
newtab-topsites-add-topsites-header = Nova pagina principala
newtab-topsites-edit-topsites-header = Modifitgar la pagina principala
newtab-topsites-title-label = Titel
newtab-topsites-title-input =
    .placeholder = Endatar in titel

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Tippar u encollar ina URL
newtab-topsites-url-validation = In URL valid è necessari

newtab-topsites-image-url-label = URL dal maletg persunalisà
newtab-topsites-use-image-link = Utilisar in maletg persunalisà…
newtab-topsites-image-validation = Impussibel da chargiar il maletg. Emprova in auter URL.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Interrumper
newtab-topsites-delete-history-button = Stizzar da la cronologia
newtab-topsites-save-button = Memorisar
newtab-topsites-preview-button = Prevista
newtab-topsites-add-button = Agiuntar

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Vuls ti propi stizzar mintga instanza da questa pagina ord la cronologia?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Questa acziun na po betg vegnir revocada.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Avrir il menu
    .aria-label = Avrir il menu

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Allontanar
    .aria-label = Allontanar

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Avrir il menu
    .aria-label = Avrir il menu contextual per { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Modifitgar questa pagina
    .aria-label = Modifitgar questa pagina

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Modifitgar
newtab-menu-open-new-window = Avrir en ina nova fanestra
newtab-menu-open-new-private-window = Avrir en ina nova fanestra privata
newtab-menu-dismiss = Sbittar
newtab-menu-pin = Fixar
newtab-menu-unpin = Betg pli fixar
newtab-menu-delete-history = Stizzar da la cronologia
newtab-menu-save-to-pocket = Memorisar en { -pocket-brand-name }
newtab-menu-delete-pocket = Stizzar da { -pocket-brand-name }
newtab-menu-archive-pocket = Archivar en { -pocket-brand-name }
newtab-menu-show-privacy-info = Noss sponsurs & tia sfera privata

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Finì
newtab-privacy-modal-button-manage = Administrar ils parameters da cuntegn sponsurisà
newtab-privacy-modal-header = Tia sfera privata è impurtanta.
newtab-privacy-modal-paragraph-2 =
    Ultra dad istorgias captivantas, ta mussain nus era cuntegn relevant, 
    curà cun premura da sponsurs distinguids. Nus garantin che <strong>tias datas
    da navigaziun na bandunan mai tia copia persunala da { -brand-product-name }</strong>  —
    nus n'avain betg access a questas datas e noss sponsurs n'era betg.
newtab-privacy-modal-link = Ve a savair co la protecziun da datas funcziuna sin la pagina Nov tab

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Allontanar il segnapagina
# Bookmark is a verb here.
newtab-menu-bookmark = Marcar sco segnapagina

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Copiar la colliaziun a la telechargiada
newtab-menu-go-to-download-page = Ir a la pagina da telechargiada
newtab-menu-remove-download = Allontanar da la cronologia

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Mussar en il Finder
       *[other] Mussar l'ordinatur che cuntegna la datoteca
    }
newtab-menu-open-file = Avrir la datoteca

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Visità
newtab-label-bookmarked = Cun segnapagina
newtab-label-removed-bookmark = Allontanà il segnapagina
newtab-label-recommended = Popular
newtab-label-saved = Memorisà en { -pocket-brand-name }
newtab-label-download = Telechargià

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Sponsurà

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Sponsurisà da { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Allontanar la secziun
newtab-section-menu-collapse-section = Reducir la secziun
newtab-section-menu-expand-section = Expander la secziun
newtab-section-menu-manage-section = Administrar la secziun
newtab-section-menu-manage-webext = Administrar l'extensiun
newtab-section-menu-add-topsite = Agiuntar ina pagina principala
newtab-section-menu-add-search-engine = Agiuntar maschina da tschertgar
newtab-section-menu-move-up = Spustar ensi
newtab-section-menu-move-down = Spustar engiu
newtab-section-menu-privacy-notice = Infurmaziuns davart la protecziun da datas

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Reducir la secziun
newtab-section-expand-section-label =
    .aria-label = Expander la secziun

## Section Headers.

newtab-section-header-topsites = Paginas preferidas
newtab-section-header-highlights = Accents
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Recumandà da { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Cumenza a navigar e nus ta mussain qua artitgels, videos ed autras paginas che ti has visità dacurt u che ti has agiuntà dacurt sco segnapagina.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Ussa has ti legì tut las novitads. Turna pli tard per ulteriuras novitads da { $provider }. Na pos betg spetgar? Tscherna in tema popular per chattar ulteriuras istorgias ord il web.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = I na dat nagut auter.
newtab-discovery-empty-section-topstories-content = Returna pli tard per scuvrir auters artitgels.
newtab-discovery-empty-section-topstories-try-again-button = Reempruvar
newtab-discovery-empty-section-topstories-loading = Chargiar…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Oha! Nus avain quasi chargià il cuntegn, ma be quasi.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Temas populars:
newtab-pocket-more-recommendations = Dapli propostas
newtab-pocket-learn-more = Ulteriuras infurmaziuns
newtab-pocket-cta-button = Obtegnair { -pocket-brand-name }
newtab-pocket-cta-text = Memorisescha ils artitgels che ta plaschan en { -pocket-brand-name } e procura per inspiraziun cuntinuanta cun lectura fascinanta.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Oha, igl è succedì in sbagl cun chargiar il cuntegn.
newtab-error-fallback-refresh-link = Rechargia la pagina per reempruvar.
