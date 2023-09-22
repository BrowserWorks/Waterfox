# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-reader-loading = Laden…
about-reader-load-error = Artikel van pagina laden is mislukt

about-reader-color-scheme-light = Licht
    .title = Kleurenschema Licht
about-reader-color-scheme-dark = Donker
    .title = Kleurenschema Donker
about-reader-color-scheme-sepia = Sepia
    .title = Kleurenschema Sepia
about-reader-color-scheme-auto = Auto
    .title = Kleurenschema Automatisch

# An estimate for how long it takes to read an article,
# expressed as a range covering both slow and fast readers.
# Variables:
#   $rangePlural (String): The plural category of the range, using the same set as for numbers.
#   $range (String): The range of minutes as a localised string. Examples: "3-7", "~1".
about-reader-estimated-read-time =
    { $rangePlural ->
        [one] { $range } minuut
       *[other] { $range } minuten
    }

## These are used as tooltips in Type Control

about-reader-toolbar-minus =
    .title = Tekengrootte verkleinen
about-reader-toolbar-plus =
    .title = Tekengrootte vergroten
about-reader-toolbar-contentwidthminus =
    .title = Inhoudsbreedte verkleinen
about-reader-toolbar-contentwidthplus =
    .title = Inhoudsbreedte vergroten
about-reader-toolbar-lineheightminus =
    .title = Regelhoogte verkleinen
about-reader-toolbar-lineheightplus =
    .title = Regelhoogte vergroten

## These are the styles of typeface that are options in the reader view controls.

about-reader-font-type-serif = Serif
about-reader-font-type-sans-serif = Sans-serif

## Reader View toolbar buttons

about-reader-toolbar-close = Lezerweergave sluiten
about-reader-toolbar-type-controls = Lettertype-instellingen
about-reader-toolbar-savetopocket = Opslaan in { -pocket-brand-name }
