# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Imprimir
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Guardar como

# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } folha de papel
       *[other] { $sheetCount } folhas de papel
    }

printui-page-range-all = Tudo
printui-page-range-custom = Personalizado
printui-page-range-label = Páginas
printui-page-range-picker =
    .aria-label = Escolha um intervalo de páginas
printui-page-custom-range-input =
    .aria-label = Especifique o intervalo personalizado de páginas
    .placeholder = por exemplo, 2-6, 9, 12-16

# Section title for the number of copies to print
printui-copies-label = Cópias

printui-orientation = Orientação
printui-landscape = Horizontal
printui-portrait = Vertical

# Section title for the printer or destination device to target
printui-destination-label = Destino
printui-destination-pdf-label = Guardar como PDF

printui-more-settings = Mais definições
printui-less-settings = Menos definições

printui-paper-size-label = Tamanho do papel

# Section title (noun) for the print scaling options
printui-scale = Escala
printui-scale-fit-to-page-width = Ajustar à largura da página
# Label for input control where user can set the scale percentage
printui-scale-pcent = Escala

# Section title (noun) for the two-sided print options
printui-two-sided-printing = Impressão dos dois lados
printui-two-sided-printing-off = Desligado
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = Inverter no limite maior
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = Inverter no limite menor

# Section title for miscellaneous print options
printui-options = Opções
printui-headers-footers-checkbox = Imprimir cabeçalhos e rodapés
printui-backgrounds-checkbox = Imprimir fundos

## The "Format" section, select a version of the website to print. Radio
## options to select between the original page, selected text only, or a version
## where the page is processed with "Reader View".

# The section title.
printui-source-label = Formato
# Option for printing the original page.
printui-source-radio = Original
# Option for printing just the content a user selected prior to printing.
printui-selection-radio = Seleção
# Option for "simplifying" the page by printing the Reader View version.
printui-simplify-page-radio = Simplificada

##

printui-color-mode-label = Modo de cor
printui-color-mode-color = Cor
printui-color-mode-bw = Preto e branco

printui-margins = Margens
printui-margins-default = Predefinida
printui-margins-min = Mínima
printui-margins-none = Nenhuma
printui-margins-custom-inches = Personalizado (polegadas)
printui-margins-custom-mm = Personalizado (mm)
printui-margins-custom-top = Superior
printui-margins-custom-top-inches = Topo (polegadas)
printui-margins-custom-top-mm = Superior (mm)
printui-margins-custom-bottom = Inferior
printui-margins-custom-bottom-inches = Inferior (polegadas)
printui-margins-custom-bottom-mm = Inferior (mm)
printui-margins-custom-left = Esquerda
printui-margins-custom-left-inches = Esquerda (polegadas)
printui-margins-custom-left-mm = Esquerda (mm)
printui-margins-custom-right = Direita
printui-margins-custom-right-inches = Direita (polegadas)
printui-margins-custom-right-mm = Direita (mm)

printui-system-dialog-link = Imprimir utilizando a janela do sistema…

printui-primary-button = Imprimir
printui-primary-button-save = Guardar
printui-cancel-button = Cancelar
printui-close-button = Fechar

printui-loading = A preparar a pré-visualização

# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Pré-visualização da impressão

printui-pages-per-sheet = Páginas por folha

# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = A imprimir…
printui-print-progress-indicator-saving = A guardar…

## Paper sizes that may be supported by the Save to PDF destination:

printui-paper-a5 = A5
printui-paper-a4 = A4
printui-paper-a3 = A3
printui-paper-a2 = A2
printui-paper-a1 = A1
printui-paper-a0 = A0
printui-paper-b5 = B5
printui-paper-b4 = B4
printui-paper-jis-b5 = JIS-B5
printui-paper-jis-b4 = JIS-B4
printui-paper-letter = Carta EUA
printui-paper-legal = Legal EUA
printui-paper-tabloid = Tabloide

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = A escala deve ser um número entre 10 e 200.
printui-error-invalid-margin = Insira uma margem válida para o tamanho de papel selecionado.
printui-error-invalid-copies = As cópias devem ser um número entre 1 e 10000.

# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = O intervalo deve ser um número entre 1 e { $numPages }.
printui-error-invalid-start-overflow = O número da página “de” deve ser menor que o número da página “até”.
