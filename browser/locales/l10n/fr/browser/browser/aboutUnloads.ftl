# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Déchargement d’onglets
about-unloads-intro-1 = { -brand-short-name } est doté d’une fonctionnalité qui décharge automatiquement des onglets pour empêcher le plantage de l’application par manque de mémoire quand la quantité de mémoire disponible du système est faible. Le prochain onglet à décharger est choisi selon plusieurs attributs. Cette page montre comment { -brand-short-name } choisit la priorité des onglets et lequel sera déchargé lorsque le déchargement d’onglets sera déclenché.
about-unloads-intro-2 = Les onglets existants sont affichés dans le tableau ci-dessous dans l’ordre même que { -brand-short-name } utilise pour choisir le prochain onglet à décharger. L’identifiant de processus apparaît en <strong>gras</strong> quand ce processus héberge le cadre supérieur d’un onglet et en <em>italique</em> quand il est partagé entre différents onglets. Vous pouvez déclencher manuellement le déchargement d’onglets en cliquant sur le bouton <em>Décharger</em> ci-dessous.
about-unloads-intro = { -brand-short-name } est doté d’une fonctionnalité qui décharge automatiquement des onglets pour empêcher le plantage de l’application par manque de mémoire quand la quantité de mémoire disponible du système est faible. Le prochain onglet à décharger est choisi selon plusieurs attributs. Cette page montre comment { -brand-short-name } choisit la priorité des onglets et lequel sera déchargé lorsque le déchargement d’onglets sera déclenché. Vous pouvez déclencher manuellement le déchargement de cet onglet en cliquant sur le bouton <em>Décharger</em> ci-dessous.
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more = Consultez l’article <a data-l10n-name="doc-link">Tab Unloading</a> pour en savoir plus sur la fonctionnalité et sur cette page.
about-unloads-last-updated = Dernière actualisation : { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Décharger
    .title = Décharger l’onglet possédant la priorité la plus élevée
about-unloads-no-unloadable-tab = Aucun onglet ne peut être déchargé.
about-unloads-column-priority = Priorité
about-unloads-column-host = Hôte
about-unloads-column-last-accessed = Dernier accès
about-unloads-column-weight = Poids de base
    .title = Les onglets sont d’abord triés selon cette valeur qui découle de quelques attributs particuliers comme la lecture audio, WebRTC, etc.
about-unloads-column-sortweight = Poids secondaire
    .title = Si elle est disponible, les onglets sont triés selon cette valeur après le premier tri réalisé selon le poids de base. Cette valeur provient de l’utilisation de la mémoire par l’onglet et le décompte des processus.
about-unloads-column-memory = Mémoire
    .title = Utilisation de mémoire par l’onglet estimée
about-unloads-column-processes = ID de processus
    .title = Identifiants des processus hébergeant le contenu des onglets.
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } Mo
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } Mo
