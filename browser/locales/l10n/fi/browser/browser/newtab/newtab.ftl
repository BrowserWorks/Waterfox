# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Uusi välilehti
newtab-settings-button =
    .title = Muokkaa Uusi välilehti -sivua

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Haku
    .aria-label = Haku

newtab-search-box-search-the-web-text = Verkkohaku
newtab-search-box-search-the-web-input =
    .placeholder = Verkkohaku
    .title = Verkkohaku
    .aria-label = Verkkohaku

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Lisää hakukone
newtab-topsites-add-topsites-header = Uusi ykkössivusto
newtab-topsites-edit-topsites-header = Muokkaa ykkössivustoa
newtab-topsites-title-label = Otsikko
newtab-topsites-title-input =
    .placeholder = Kirjoita otsikko

newtab-topsites-url-label = Osoite
newtab-topsites-url-input =
    .placeholder = Kirjoita tai liitä osoite
newtab-topsites-url-validation = Kelvollinen osoite vaaditaan

newtab-topsites-image-url-label = Oman kuvan osoite
newtab-topsites-use-image-link = Käytä omaa kuvaa…
newtab-topsites-image-validation = Kuvan lataaminen epäonnistui. Kokeile toista osoitetta.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Peruuta
newtab-topsites-delete-history-button = Poista historiasta
newtab-topsites-save-button = Tallenna
newtab-topsites-preview-button = Esikatsele
newtab-topsites-add-button = Lisää

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Haluatko varmasti poistaa tämän sivun kaikkialta historiastasi?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Tämä toiminto on peruuttamaton.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Avaa valikko
    .aria-label = Avaa valikko

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Poista
    .aria-label = Poista

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Avaa valikko
    .aria-label = Avaa pikavalikko sivustolle { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Muokkaa tätä sivustoa
    .aria-label = Muokkaa tätä sivustoa

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Muokkaa
newtab-menu-open-new-window = Avaa uuteen ikkunaan
newtab-menu-open-new-private-window = Avaa uuteen yksityiseen ikkunaan
newtab-menu-dismiss = Hylkää
newtab-menu-pin = Kiinnitä
newtab-menu-unpin = Poista kiinnitys
newtab-menu-delete-history = Poista historiasta
newtab-menu-save-to-pocket = Tallenna { -pocket-brand-name }-palveluun
newtab-menu-delete-pocket = Poista { -pocket-brand-name }-palvelusta
newtab-menu-archive-pocket = Arkistoi { -pocket-brand-name }-palveluun
newtab-menu-show-privacy-info = Tukijamme ja yksityisyytesi

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Valmis
newtab-privacy-modal-button-manage = Hallitse sponsoroidun sisällön asetuksia
newtab-privacy-modal-header = Yksityisyydelläsi on merkitystä.
newtab-privacy-modal-paragraph-2 =
    Kiehtovien tarinoiden tarjoamisen lisäksi näytämme sinulle myös kiinnostavaa,
    tarkastettua sisältöä valituilta sponsoreilta. Voit olla varma, että <strong>selaustietosi
    pysyvät omassa { -brand-product-name }-kopiossasi</strong> – emme näe niitä eivätkä 
    myöskään sponsorimme.
newtab-privacy-modal-link = Opi miten yksityisyys on esillä uusi välilehti -sivulla

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Poista kirjanmerkki
# Bookmark is a verb here.
newtab-menu-bookmark = Lisää kirjanmerkki

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Kopioi latauslinkki
newtab-menu-go-to-download-page = Siirry lataussivulle
newtab-menu-remove-download = Poista historiasta

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Näytä Finderissa
       *[other] Avaa kohteen kansio
    }
newtab-menu-open-file = Avaa tiedosto

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Vierailtu
newtab-label-bookmarked = Kirjanmerkki
newtab-label-removed-bookmark = Kirjanmerkki poistettu
newtab-label-recommended = Pinnalla
newtab-label-saved = Tallennettu { -pocket-brand-name }-palveluun
newtab-label-download = Ladatut

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Sponsoroitu

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Sponsorina { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Poista osio
newtab-section-menu-collapse-section = Pienennä osio
newtab-section-menu-expand-section = Laajenna osio
newtab-section-menu-manage-section = Muokkaa osiota
newtab-section-menu-manage-webext = Hallitse laajennusta
newtab-section-menu-add-topsite = Lisää ykkössivusto
newtab-section-menu-add-search-engine = Lisää hakukone
newtab-section-menu-move-up = Siirrä ylös
newtab-section-menu-move-down = Siirrä alas
newtab-section-menu-privacy-notice = Tietosuojakäytäntö

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Pienennä osio
newtab-section-expand-section-label =
    .aria-label = Laajenna osio

## Section Headers.

newtab-section-header-topsites = Ykkössivustot
newtab-section-header-highlights = Nostot
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Suositukset lähteestä { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Ala selata, niin tässä alkaa näkyä hyviä juttuja, videoita ja muita sivuja, joilla olet käynyt hiljattain tai jotka olet lisännyt kirjanmerkkeihin.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Ei enempää suosituksia juuri nyt. Katso myöhemmin uudestaan lisää ykkösjuttuja lähteestä { $provider }. Etkö malta odottaa? Valitse suosittu aihe ja löydä lisää hyviä juttuja ympäri verkkoa.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Olet ajan tasalla!
newtab-discovery-empty-section-topstories-content = Katso myöhemmin lisää juttuja.
newtab-discovery-empty-section-topstories-try-again-button = Yritä uudelleen
newtab-discovery-empty-section-topstories-loading = Ladataan…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Hups! Tämä osio ladattiin melkein, mutta ei ihan.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Suositut aiheet:
newtab-pocket-more-recommendations = Lisää suosituksia
newtab-pocket-learn-more = Lue lisää
newtab-pocket-cta-button = Hanki { -pocket-brand-name }
newtab-pocket-cta-text = Tallenna tykkäämäsi tekstit { -pocket-brand-name }iin ja ravitse mieltäsi kiinnostavilla teksteillä.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Hups, jotain meni vikaan tätä sisältöä ladattaessa.
newtab-error-fallback-refresh-link = Yritä uudestaan päivittämällä sivu.
