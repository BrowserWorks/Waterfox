# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-reader-loading = Wczytywanie…
about-reader-load-error = Nie udało się wczytać artykułu z tej strony

about-reader-color-scheme-light = Jasny
    .title = Jasny schemat kolorów
about-reader-color-scheme-dark = Ciemny
    .title = Ciemny schemat kolorów
about-reader-color-scheme-sepia = Sepia
    .title = Schemat kolorów sepii
about-reader-color-scheme-auto = Auto
    .title = Automatyczny schemat kolorów

# An estimate for how long it takes to read an article,
# expressed as a range covering both slow and fast readers.
# Variables:
#   $rangePlural (String): The plural category of the range, using the same set as for numbers.
#   $range (String): The range of minutes as a localised string. Examples: "3-7", "~1".
about-reader-estimated-read-time =
    { $rangePlural ->
        [one] { $range } minuta
        [few] { $range } minuty
       *[many] { $range } minut
    }

## These are used as tooltips in Type Control

about-reader-toolbar-minus =
    .title = Zmniejsz rozmiar czcionki
about-reader-toolbar-plus =
    .title = Zwiększ rozmiar czcionki
about-reader-toolbar-contentwidthminus =
    .title = Zmniejsz szerokość tekstu
about-reader-toolbar-contentwidthplus =
    .title = Zwiększ szerokość tekstu
about-reader-toolbar-lineheightminus =
    .title = Zmniejsz wysokość wierszy
about-reader-toolbar-lineheightplus =
    .title = Zwiększ wysokość wierszy

## These are the styles of typeface that are options in the reader view controls.

about-reader-font-type-serif = Szeryfowa
about-reader-font-type-sans-serif = Bezszeryfowa

## Reader View toolbar buttons

about-reader-toolbar-close = Wygląd oryginalny
about-reader-toolbar-type-controls = Czcionki
about-reader-toolbar-savetopocket = Wyślij do { -pocket-brand-name }
