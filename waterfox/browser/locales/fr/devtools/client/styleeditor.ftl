# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = Créer et ajouter une nouvelle feuille de style au document
    .accesskey = N
styleeditor-import-button =
    .tooltiptext = Importer et ajouter une feuille de style existante au document
    .accesskey = I
styleeditor-filter-input =
    .placeholder = Filtrer les feuilles de style
styleeditor-visibility-toggle =
    .tooltiptext = Activer/Désactiver la feuille de style
    .accesskey = S
styleeditor-visibility-toggle-system =
    .tooltiptext = Les feuilles de style système ne peuvent pas être désactivées
styleeditor-save-button = Enregistrer
    .tooltiptext = Enregistrer cette feuille de style dans un fichier
    .accesskey = S
styleeditor-options-button =
    .tooltiptext = Options de l’éditeur de style
styleeditor-at-rules = Règles @
styleeditor-editor-textbox =
    .data-placeholder = Saisissez du CSS ici.
styleeditor-no-stylesheet = Cette page n’a aucune feuille de style.
styleeditor-no-stylesheet-tip = Peut-être désirez-vous <a data-l10n-name="append-new-stylesheet">ajouter une nouvelle feuille de style</a> ?
styleeditor-open-link-new-tab =
    .label = Ouvrir le lien dans un nouvel onglet
styleeditor-copy-url =
    .label = Copier l’URL
styleeditor-find =
    .label = Rechercher
    .accesskey = h
styleeditor-find-again =
    .label = Rechercher le suivant
    .accesskey = v
styleeditor-go-to-line =
    .label = Aller à la ligne…
    .accesskey = r
# Label displayed when searching a term that is not found in any stylesheet path
styleeditor-stylesheet-all-filtered = Aucune feuille de style trouvée.

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [one] { $ruleCount } règle.
       *[other] { $ruleCount } règles.
    }
