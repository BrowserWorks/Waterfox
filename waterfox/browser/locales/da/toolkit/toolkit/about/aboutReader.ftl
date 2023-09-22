# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-reader-loading = Indlæser…
about-reader-load-error = Indlæsning af artikel fra side mislykkedes

about-reader-color-scheme-light = Lys
    .title = Lyst farveskema
about-reader-color-scheme-dark = Mørk
    .title = Mørkt farveskema
about-reader-color-scheme-sepia = Sepia
    .title = Sepia farveskema
about-reader-color-scheme-auto = Auto
    .title = Automatisk farveskema

# An estimate for how long it takes to read an article,
# expressed as a range covering both slow and fast readers.
# Variables:
#   $rangePlural (String): The plural category of the range, using the same set as for numbers.
#   $range (String): The range of minutes as a localised string. Examples: "3-7", "~1".
about-reader-estimated-read-time =
    { $rangePlural ->
        [one] { $range } minutter
       *[other] { $range } minutter
    }

## These are used as tooltips in Type Control

about-reader-toolbar-minus =
    .title = Formindsk skriftstørrelsen
about-reader-toolbar-plus =
    .title = Forøg skriftstørrelsen
about-reader-toolbar-contentwidthminus =
    .title = Formindsk indholdets bredde
about-reader-toolbar-contentwidthplus =
    .title = Forøg indholdets bredde
about-reader-toolbar-lineheightminus =
    .title = Formindsk linjeafstanden
about-reader-toolbar-lineheightplus =
    .title = Forøg linjeafstanden

## These are the styles of typeface that are options in the reader view controls.

about-reader-font-type-serif = Serif
about-reader-font-type-sans-serif = Sans-serif

## Reader View toolbar buttons

about-reader-toolbar-close = Luk læsevisning
about-reader-toolbar-type-controls = Indstillinger
about-reader-toolbar-savetopocket = Gem til { -pocket-brand-name }
