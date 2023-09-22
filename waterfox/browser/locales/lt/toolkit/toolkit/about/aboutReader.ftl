# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-reader-loading = Įkeliama…
about-reader-load-error = Iš tinklalapio įkelti straipsnio nepavyko

about-reader-color-scheme-light = Šviesi
    .title = Šviesi spalvų schema
about-reader-color-scheme-dark = Tamsi
    .title = Tamsi spalvų schema
about-reader-color-scheme-sepia = Sepija
    .title = Sepijos spalvų schema
about-reader-color-scheme-auto = Automatinė
    .title = Automatinė spalvų schema

# An estimate for how long it takes to read an article,
# expressed as a range covering both slow and fast readers.
# Variables:
#   $rangePlural (String): The plural category of the range, using the same set as for numbers.
#   $range (String): The range of minutes as a localised string. Examples: "3-7", "~1".
about-reader-estimated-read-time =
    { $rangePlural ->
        [one] { $range } minutė
        [few] { $range } minutės
       *[other] { $range } minučių
    }

## These are used as tooltips in Type Control

about-reader-toolbar-minus =
    .title = Sumažinti šriftą
about-reader-toolbar-plus =
    .title = Padidinti šriftą
about-reader-toolbar-contentwidthminus =
    .title = Sumažinti turinio plotį
about-reader-toolbar-contentwidthplus =
    .title = Padidinti turinio plotį
about-reader-toolbar-lineheightminus =
    .title = Sumažinti eilutės aukštį
about-reader-toolbar-lineheightplus =
    .title = Padidinti eilutės aukštį

## These are the styles of typeface that are options in the reader view controls.

about-reader-font-type-serif = Su užraitais
about-reader-font-type-sans-serif = Be užraitų

## Reader View toolbar buttons

about-reader-toolbar-close = Išjungti skaitymo rodinį
about-reader-toolbar-type-controls = Tipų valdymas
about-reader-toolbar-savetopocket = Įrašyti į „{ -pocket-brand-name }“
