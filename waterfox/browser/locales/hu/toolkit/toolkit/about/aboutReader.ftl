# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-reader-loading = Betöltés…
about-reader-load-error = A cikk betöltése sikertelen az oldalról

about-reader-color-scheme-light = Világos
    .title = Világos színséma
about-reader-color-scheme-dark = Sötét
    .title = Sötét színséma
about-reader-color-scheme-sepia = Szépia
    .title = Szépia színséma
about-reader-color-scheme-auto = Automatikus
    .title = Automatikus színséma

# An estimate for how long it takes to read an article,
# expressed as a range covering both slow and fast readers.
# Variables:
#   $rangePlural (String): The plural category of the range, using the same set as for numbers.
#   $range (String): The range of minutes as a localised string. Examples: "3-7", "~1".
about-reader-estimated-read-time =
    { $rangePlural ->
        [one] { $range } perc
       *[other] { $range } perc
    }

## These are used as tooltips in Type Control

about-reader-toolbar-minus =
    .title = Betűméret csökkentése
about-reader-toolbar-plus =
    .title = Betűméret növelése
about-reader-toolbar-contentwidthminus =
    .title = Tartalomszélesség csökkentése
about-reader-toolbar-contentwidthplus =
    .title = Tartalomszélesség növelése
about-reader-toolbar-lineheightminus =
    .title = Sormagasság csökkentése
about-reader-toolbar-lineheightplus =
    .title = Sormagasság növelése

## These are the styles of typeface that are options in the reader view controls.

about-reader-font-type-serif = Talpas
about-reader-font-type-sans-serif = Talpatlan

## Reader View toolbar buttons

about-reader-toolbar-close = Olvasó nézet bezárása
about-reader-toolbar-type-controls = Szövegbeállítások
about-reader-toolbar-savetopocket = Mentés a { -pocket-brand-name }be
