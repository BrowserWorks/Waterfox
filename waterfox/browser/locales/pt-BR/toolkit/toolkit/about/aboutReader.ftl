# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-reader-loading = Carregando…
about-reader-load-error = Falha ao carregar artigo da página

about-reader-color-scheme-light = Claro
    .title = Esquema de cores claro
about-reader-color-scheme-dark = Escuro
    .title = Esquema de cores escuro
about-reader-color-scheme-sepia = Sépia
    .title = Esquema de cores sépia
about-reader-color-scheme-auto = Automático
    .title = Esquema de cores automático

# An estimate for how long it takes to read an article,
# expressed as a range covering both slow and fast readers.
# Variables:
#   $rangePlural (String): The plural category of the range, using the same set as for numbers.
#   $range (String): The range of minutes as a localised string. Examples: "3-7", "~1".
about-reader-estimated-read-time =
    { $rangePlural ->
        [one] { $range } minuto
       *[other] { $range } minutos
    }

## These are used as tooltips in Type Control

about-reader-toolbar-minus =
    .title = Diminuir tamanho da fonte
about-reader-toolbar-plus =
    .title = Aumentar tamanho da fonte
about-reader-toolbar-contentwidthminus =
    .title = Diminuir largura do conteúdo
about-reader-toolbar-contentwidthplus =
    .title = Aumentar largura do conteúdo
about-reader-toolbar-lineheightminus =
    .title = Diminuir altura da linha
about-reader-toolbar-lineheightplus =
    .title = Aumentar altura da linha

## These are the styles of typeface that are options in the reader view controls.

about-reader-font-type-serif = Com serifa
about-reader-font-type-sans-serif = Sem serifa

## Reader View toolbar buttons

about-reader-toolbar-close = Fechar leitor
about-reader-toolbar-type-controls = Controle de fontes
about-reader-toolbar-savetopocket = Salvar no { -pocket-brand-name }
