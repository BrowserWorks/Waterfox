# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Waterfox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Nouvel onglet
newtab-settings-button =
    .title = Personnaliser la page Nouvel onglet
newtab-personalize-icon-label =
    .title = Personnaliser la page de nouvel onglet
    .aria-label = Personnaliser la page de nouvel onglet
newtab-personalize-dialog-label =
    .aria-label = Personnaliser

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Rechercher
    .aria-label = Rechercher
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = Rechercher avec { $engine } ou saisir une adresse
newtab-search-box-handoff-text-no-engine = Rechercher ou saisir une adresse
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = Rechercher avec { $engine } ou saisir une adresse
    .title = Rechercher avec { $engine } ou saisir une adresse
    .aria-label = Rechercher avec { $engine } ou saisir une adresse
newtab-search-box-handoff-input-no-engine =
    .placeholder = Rechercher ou saisir une adresse
    .title = Rechercher ou saisir une adresse
    .aria-label = Rechercher ou saisir une adresse
newtab-search-box-search-the-web-input =
    .placeholder = Rechercher sur le Web
    .title = Rechercher sur le Web
    .aria-label = Rechercher sur le Web
newtab-search-box-text = Rechercher sur le Web
newtab-search-box-input =
    .placeholder = Rechercher sur le Web
    .aria-label = Rechercher sur le Web

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Ajouter un moteur de recherche
newtab-topsites-add-topsites-header = Nouveau site populaire
newtab-topsites-add-shortcut-header = Nouveau raccourci
newtab-topsites-edit-topsites-header = Modifier le site populaire
newtab-topsites-edit-shortcut-header = Modifier le raccourci
newtab-topsites-title-label = Titre
newtab-topsites-title-input =
    .placeholder = Saisir un titre
newtab-topsites-url-label = Adresse web
newtab-topsites-url-input =
    .placeholder = Saisir ou coller une adresse web
newtab-topsites-url-validation = Adresse web valide requise
newtab-topsites-image-url-label = URL de l’image personnalisée
newtab-topsites-use-image-link = Utiliser une image personnalisée…
newtab-topsites-image-validation = Échec du chargement de l’image. Essayez avec une autre URL.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Annuler
newtab-topsites-delete-history-button = Supprimer de l’historique
newtab-topsites-save-button = Enregistrer
newtab-topsites-preview-button = Aperçu
newtab-topsites-add-button = Ajouter

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Voulez-vous vraiment supprimer de l’historique toutes les occurrences de cette page ?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Cette action est irréversible.

## Top Sites - Sponsored label

newtab-topsite-sponsored = Sponsorisé

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Ouvrir le menu
    .aria-label = Ouvrir le menu
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Supprimer
    .aria-label = Supprimer
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Ouvrir le menu
    .aria-label = Ouvrir le menu contextuel pour { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Modifier ce site
    .aria-label = Modifier ce site

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Modifier
newtab-menu-open-new-window = Ouvrir dans une nouvelle fenêtre
newtab-menu-open-new-private-window = Ouvrir dans une nouvelle fenêtre privée
newtab-menu-dismiss = Retirer
newtab-menu-pin = Épingler
newtab-menu-unpin = Désépingler
newtab-menu-delete-history = Supprimer de l’historique
newtab-menu-save-to-pocket = Enregistrer dans { -pocket-brand-name }
newtab-menu-delete-pocket = Supprimer de { -pocket-brand-name }
newtab-menu-archive-pocket = Archiver dans { -pocket-brand-name }
newtab-menu-show-privacy-info = Nos sponsors et votre vie privée

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Terminé
newtab-privacy-modal-button-manage = Gérer les paramètres de contenu sponsorisé
newtab-privacy-modal-header = Votre vie privée compte pour nous.
newtab-privacy-modal-paragraph-2 = En plus de partager des histoires captivantes, nous vous montrons également des contenus pertinents et soigneusement sélectionnés de sponsors triés sur le volet. Rassurez-vous, <strong>vos données de navigation ne quittent jamais votre copie personnelle de { -brand-product-name }</strong> — nous ne les voyons pas, et nos sponsors non plus.
newtab-privacy-modal-link = En savoir plus sur le respect de la vie privée dans le nouvel onglet

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Supprimer le marque-page
# Bookmark is a verb here.
newtab-menu-bookmark = Marquer cette page

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Copier l’adresse d’origine du téléchargement
newtab-menu-go-to-download-page = Aller à la page de téléchargement
newtab-menu-remove-download = Retirer de l’historique

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Afficher dans le Finder
       *[other] Ouvrir le dossier contenant le fichier
    }
newtab-menu-open-file = Ouvrir le fichier

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Visité
newtab-label-bookmarked = Ajouté aux marque-pages
newtab-label-removed-bookmark = Marque-page supprimé
newtab-label-recommended = Tendance
newtab-label-saved = Enregistré dans { -pocket-brand-name }
newtab-label-download = Téléchargé
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Sponsorisé
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Sponsorisé par { $sponsor }
# This string is used under the image of story cards to indicate source and time to read
# Variables:
#  $source (String): This is the name of a company or their domain
#  $timeToRead (Number): This is the estimated number of minutes to read this story
newtab-label-source-read-time = { $source } · { $timeToRead } min

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Supprimer la section
newtab-section-menu-collapse-section = Réduire la section
newtab-section-menu-expand-section = Développer la section
newtab-section-menu-manage-section = Gérer la section
newtab-section-menu-manage-webext = Gérer l’extension
newtab-section-menu-add-topsite = Ajouter un site populaire
newtab-section-menu-add-search-engine = Ajouter un moteur de recherche
newtab-section-menu-move-up = Déplacer vers le haut
newtab-section-menu-move-down = Déplacer vers le bas
newtab-section-menu-privacy-notice = Politique de confidentialité

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Réduire la section
newtab-section-expand-section-label =
    .aria-label = Développer la section

## Section Headers.

newtab-section-header-topsites = Sites les plus visités
newtab-section-header-highlights = Éléments-clés
newtab-section-header-recent-activity = Activité récente
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Recommandations par { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Commencez à naviguer puis nous afficherons des articles, des vidéos ou d’autres pages que vous avez récemment visités ou ajoutés aux marque-pages.
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Il n’y en a pas d’autres. Revenez plus tard pour plus d’articles de { $provider }. Vous ne voulez pas attendre ? Choisissez un sujet parmi les plus populaires pour découvrir d’autres articles intéressants sur le Web.

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Il n’y a rien d’autre.
newtab-discovery-empty-section-topstories-content = Revenez plus tard pour découvrir d’autres articles.
newtab-discovery-empty-section-topstories-try-again-button = Réessayer
newtab-discovery-empty-section-topstories-loading = Chargement…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Oups, il semblerait que la section ne se soit pas chargée complètement.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Sujets populaires :
newtab-pocket-new-topics-title = Vous voulez encore plus d’articles ? Parcourez ces sujets populaires de { -pocket-brand-name }
newtab-pocket-more-recommendations = Plus de recommandations
newtab-pocket-learn-more = En savoir plus
newtab-pocket-cta-button = Installer { -pocket-brand-name }
newtab-pocket-cta-text = Enregistrez les articles que vous aimez dans { -pocket-brand-name }, et stimulez votre imagination avec des lectures fascinantes.
newtab-pocket-pocket-firefox-family = { -pocket-brand-name } fait partie de la famille { -brand-product-name }
# A save to Pocket button that shows over the card thumbnail on hover.
newtab-pocket-save-to-pocket = Enregistrer dans { -pocket-brand-name }
newtab-pocket-saved-to-pocket = Enregistré dans { -pocket-brand-name }
# This is a button shown at the bottom of the Pocket section that loads more stories when clicked.
newtab-pocket-load-more-stories-button = Afficher plus d’articles

## Pocket Final Card Section.
## This is for the final card in the Pocket grid.

newtab-pocket-last-card-title = Vous avez fait le tour !

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Oups, une erreur s’est produite lors du chargement du contenu.
newtab-error-fallback-refresh-link = Actualisez la page pour réessayer.

## Customization Menu

newtab-custom-shortcuts-title = Raccourcis
newtab-custom-shortcuts-subtitle = Sites que vous enregistrez ou visitez
newtab-custom-row-selector =
    { $num ->
        [one] { $num } ligne
       *[other] { $num } lignes
    }
newtab-custom-sponsored-sites = Raccourcis sponsorisés
newtab-custom-pocket-title = Recommandé par { -pocket-brand-name }
newtab-custom-pocket-subtitle = Contenu exceptionnel sélectionné par { -pocket-brand-name }, membre de la famille { -brand-product-name }
newtab-custom-pocket-sponsored = Articles sponsorisés
newtab-custom-recent-title = Activité récente
newtab-custom-recent-subtitle = Une sélection de sites et de contenus récents
newtab-custom-close-button = Fermer
newtab-custom-settings = Gérer plus de paramètres
