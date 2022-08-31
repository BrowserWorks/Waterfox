# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Ouvrir une fenêtre de navigation privée
    .accesskey = u
about-private-browsing-search-placeholder = Rechercher sur le Web
about-private-browsing-info-title = Cette fenêtre de navigation est privée
about-private-browsing-search-btn =
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
about-private-browsing-info-description-private-window = Fenêtre de navigation privée : { -brand-short-name } efface l’historique de vos recherches et de votre navigation à la fermeture des fenêtres privées. Cela ne vous rend pas anonyme.
about-private-browsing-info-description-simplified = { -brand-short-name } efface l’historique de vos recherches et de votre navigation à la fermeture des fenêtres privées, mais cela ne vous rend pas pour autant anonyme.
about-private-browsing-learn-more-link = En savoir plus
about-private-browsing-hide-activity = Cachez vos activités et votre emplacement, partout où vous mène votre navigation
about-private-browsing-get-privacy = Protégez votre vie privée partout où vous naviguez
about-private-browsing-hide-activity-1 = Masquez votre navigation et votre emplacement avec { -mozilla-vpn-brand-name }. D’un simple clic, créez une connexion sécurisée, même sur un réseau Wi-Fi public.
about-private-browsing-prominent-cta = Gardez votre vie privée avec { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = Télécharger { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name } : navigation privée mobile
about-private-browsing-focus-promo-text = Notre application mobile dédiée à la navigation privée efface votre historique et vos cookies après chaque utilisation.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Profitez de la navigation privée sur votre téléphone
about-private-browsing-focus-promo-text-b = Utilisez { -focus-brand-name } pour des recherches privées que vous voulez cacher à votre navigateur mobile habituel.
about-private-browsing-focus-promo-header-c = Confidentialité de haut niveau sur mobile
about-private-browsing-focus-promo-text-c = { -focus-brand-name } efface systématiquement votre historique et bloque aussi publicités et traqueurs.
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
about-private-browsing-promo-close-button =
    .title = Fermer

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = La liberté de la navigation privée en un clic
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Ajouter au Dock
       *[other] Épingler à la barre des tâches
    }
