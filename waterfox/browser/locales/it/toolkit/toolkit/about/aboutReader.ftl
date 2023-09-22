# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-reader-loading = Caricamento in corso…
about-reader-load-error = Non è stato possibile estrarre il testo dell’articolo dalla pagina

about-reader-color-scheme-light = Chiaro
    .title = Combinazione colori chiara
about-reader-color-scheme-dark = Scuro
    .title = Combinazione colori scura
about-reader-color-scheme-sepia = Seppia
    .title = Combinazione colori seppia
about-reader-color-scheme-auto = Automatico
    .title = Combinazione colori automatica

# An estimate for how long it takes to read an article,
# expressed as a range covering both slow and fast readers.
# Variables:
#   $rangePlural (String): The plural category of the range, using the same set as for numbers.
#   $range (String): The range of minutes as a localised string. Examples: "3-7", "~1".
about-reader-estimated-read-time =
    { $rangePlural ->
        [one] { $range } minuto
       *[other] { $range } minuti
    }

## These are used as tooltips in Type Control

about-reader-toolbar-minus =
    .title = Riduci dimensione carattere
about-reader-toolbar-plus =
    .title = Aumenta dimensione carattere
about-reader-toolbar-contentwidthminus =
    .title = Riduci larghezza del contenuto
about-reader-toolbar-contentwidthplus =
    .title = Aumenta larghezza del contenuto
about-reader-toolbar-lineheightminus =
    .title = Riduci altezza riga
about-reader-toolbar-lineheightplus =
    .title = Aumenta altezza riga

## These are the styles of typeface that are options in the reader view controls.

about-reader-font-type-serif = Con grazie
about-reader-font-type-sans-serif = Senza grazie

## Reader View toolbar buttons

about-reader-toolbar-close = Chiudi Modalità lettura
about-reader-toolbar-type-controls = Controlli carattere
about-reader-toolbar-savetopocket = Salva in { -pocket-brand-name }
