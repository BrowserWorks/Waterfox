# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-reader-loading = Lastar …
about-reader-load-error = Klarte ikkje å laste inn artikkelen frå sida

about-reader-color-scheme-light = Lys
    .title = Fargeskjema, lys
about-reader-color-scheme-dark = Mørk
    .title = Fargeskjema, mørk
about-reader-color-scheme-sepia = Sepia
    .title = Fargeskjema, sepia
about-reader-color-scheme-auto = Auto
    .title = Automatisk fargeskjema

# An estimate for how long it takes to read an article,
# expressed as a range covering both slow and fast readers.
# Variables:
#   $rangePlural (String): The plural category of the range, using the same set as for numbers.
#   $range (String): The range of minutes as a localised string. Examples: "3-7", "~1".
about-reader-estimated-read-time =
    { $rangePlural ->
        [one] { $range } minutt
       *[other] { $range } minutt
    }

## These are used as tooltips in Type Control

about-reader-toolbar-minus =
    .title = MInske skriftstorleik
about-reader-toolbar-plus =
    .title = Auke skriftstorleik
about-reader-toolbar-contentwidthminus =
    .title = Minske innhaldsbreidde
about-reader-toolbar-contentwidthplus =
    .title = Auke innhaldsbreidde
about-reader-toolbar-lineheightminus =
    .title = MInke linjehøgde
about-reader-toolbar-lineheightplus =
    .title = Auke linjehøgde

## These are the styles of typeface that are options in the reader view controls.

about-reader-font-type-serif = Seriff
about-reader-font-type-sans-serif = Serifflaus

## Reader View toolbar buttons

about-reader-toolbar-close = Lat att lesevising
about-reader-toolbar-type-controls = Skriftinnstillingar
about-reader-toolbar-savetopocket = Lagre til { -pocket-brand-name }
