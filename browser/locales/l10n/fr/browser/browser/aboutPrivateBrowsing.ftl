# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Ouvrir une fenêtre de navigation privée
    .accesskey = u
about-private-browsing-search-placeholder = Rechercher sur le Web
about-private-browsing-info-title = Cette fenêtre de navigation est privée
about-private-browsing-info-myths = Principales idées reçues sur la navigation privée
about-private-browsing =
    .title = Rechercher sur le Web
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Rechercher avec { $engine } ou saisir une adresse
about-private-browsing-handoff-no-engine =
    .title = Rechercher ou saisir une adresse
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Rechercher avec { $engine } ou saisir une adresse
about-private-browsing-handoff-text-no-engine = Rechercher ou saisir une adresse
about-private-browsing-not-private = Vous ne vous trouvez pas dans une fenêtre de navigation privée.
about-private-browsing-info-description = { -brand-short-name } efface vos historiques de recherche et de navigation lorsque vous quittez l’application ou fermez tous les onglets et fenêtres de navigation privée. Bien que cela ne vous rende pas anonyme auprès des sites web ou de votre fournisseur d’accès à Internet, cela vous aide à garder confidentielles vos activités en ligne auprès de toute autre personne utilisant cet ordinateur.
about-private-browsing-need-more-privacy = Besoin de plus d’intimité ?
about-private-browsing-turn-on-vpn = Essayez { -mozilla-vpn-brand-name }
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } est votre moteur de recherche par défaut dans les fenêtres de navigation privée
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Pour sélectionner un moteur de recherche différent, accédez aux <a data-l10n-name="link-options">options</a>
       *[other] Pour sélectionner un moteur de recherche différent, accédez aux <a data-l10n-name="link-options">préférences</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Fermer
