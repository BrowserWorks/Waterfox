# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-reader-loading = Laddar...
about-reader-load-error = Det gick inte att läsa in artikeln från sidan

about-reader-color-scheme-light = Ljus
    .title = Färgschema ljus
about-reader-color-scheme-dark = Mörk
    .title = Färgschema mörk
about-reader-color-scheme-sepia = Sepia
    .title = Färgschema sepia
about-reader-color-scheme-auto = Auto
    .title = Färgschema automatiskt

# An estimate for how long it takes to read an article,
# expressed as a range covering both slow and fast readers.
# Variables:
#   $rangePlural (String): The plural category of the range, using the same set as for numbers.
#   $range (String): The range of minutes as a localised string. Examples: "3-7", "~1".
about-reader-estimated-read-time =
    { $rangePlural ->
        [one] { $range } minut
       *[other] { $range } minuter
    }

## These are used as tooltips in Type Control

about-reader-toolbar-minus =
    .title = Minska textstorlek
about-reader-toolbar-plus =
    .title = Öka textstorlek
about-reader-toolbar-contentwidthminus =
    .title = Minska innehållsbredd
about-reader-toolbar-contentwidthplus =
    .title = Öka innehållsbredd
about-reader-toolbar-lineheightminus =
    .title = Minska linjens höjd
about-reader-toolbar-lineheightplus =
    .title = Öka linjens höjd

## These are the styles of typeface that are options in the reader view controls.

about-reader-font-type-serif = Serif
about-reader-font-type-sans-serif = Sans-serif

## Reader View toolbar buttons

about-reader-toolbar-close = Stäng läsarvy
about-reader-toolbar-type-controls = Typkontroller
about-reader-toolbar-savetopocket = Spara till { -pocket-brand-name }
