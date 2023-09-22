# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-reader-loading = Chargement…
about-reader-load-error = Impossible de charger l’article à partir de la page

about-reader-color-scheme-light = Clair
    .title = Jeu de couleurs claires
about-reader-color-scheme-dark = Sombre
    .title = Jeu de couleurs sombres
about-reader-color-scheme-sepia = Sépia
    .title = Jeu de couleurs sépia
about-reader-color-scheme-auto = Auto
    .title = Jeu de couleurs automatique

# An estimate for how long it takes to read an article,
# expressed as a range covering both slow and fast readers.
# Variables:
#   $rangePlural (String): The plural category of the range, using the same set as for numbers.
#   $range (String): The range of minutes as a localised string. Examples: "3-7", "~1".
about-reader-estimated-read-time =
    { $rangePlural ->
        [one] { $range } minute
       *[other] { $range } minutes
    }

## These are used as tooltips in Type Control

about-reader-toolbar-minus =
    .title = Diminuer la taille de la police
about-reader-toolbar-plus =
    .title = Augmenter la taille de la police
about-reader-toolbar-contentwidthminus =
    .title = Réduire la largeur du contenu
about-reader-toolbar-contentwidthplus =
    .title = Augmenter la largeur du contenu
about-reader-toolbar-lineheightminus =
    .title = Réduire la hauteur de ligne
about-reader-toolbar-lineheightplus =
    .title = Augmenter la hauteur de ligne

## These are the styles of typeface that are options in the reader view controls.

about-reader-font-type-serif = Sérif
about-reader-font-type-sans-serif = Sans sérif

## Reader View toolbar buttons

about-reader-toolbar-close = Quitter le mode lecture
about-reader-toolbar-type-controls = Modifier la police
about-reader-toolbar-savetopocket = Enregistrer dans { -pocket-brand-name }
