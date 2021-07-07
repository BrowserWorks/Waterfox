# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Imprimir
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Guardar como
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } hoja de papel
       *[other] { $sheetCount } hojas de papel
    }
printui-page-range-all = Todo
printui-page-range-custom = Personalizado
printui-page-range-label = Páginas
printui-page-range-picker =
    .aria-label = Seleccionar rango de páginas
printui-page-custom-range-input =
    .aria-label = Introduzca un rango de páginas personalizado
    .placeholder = p.ej. 2-6, 9, 12-16
# Section title for the number of copies to print
printui-copies-label = Copias
printui-orientation = Orientación
printui-landscape = Horizontal
printui-portrait = Vertical
# Section title for the printer or destination device to target
printui-destination-label = Destino
printui-destination-pdf-label = Guardar como PDF
printui-more-settings = Más ajustes
printui-less-settings = Menos ajustes
printui-paper-size-label = Tamaño de papel
# Section title (noun) for the print scaling options
printui-scale = Escala
printui-scale-fit-to-page-width = Ajustar al ancho de la página
# Label for input control where user can set the scale percentage
printui-scale-pcent = Escala
# Section title (noun) for the two-sided print options
printui-two-sided-printing = Impresión a doble cara
printui-two-sided-printing-off = Desactivado
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = Pasar página por el borde largo
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = Pasar página por el borde corto
# Section title for miscellaneous print options
printui-options = Opciones
printui-headers-footers-checkbox = Imprimir encabezados y pies de página
printui-backgrounds-checkbox = Imprimir fondo de pantalla
printui-selection-checkbox = Imprimir solo la selección
printui-color-mode-label = Modo de color
printui-color-mode-color = Color
printui-color-mode-bw = Blanco y negro
printui-margins = Márgenes
printui-margins-default = Predeterminado
printui-margins-min = Mínimo
printui-margins-none = Ninguno
printui-margins-custom-inches = Personalizado (pulgadas)
printui-margins-custom-mm = Personalizado (mm)
printui-margins-custom-top = Superior
printui-margins-custom-top-inches = Superior (pulgadas)
printui-margins-custom-top-mm = Superior (mm)
printui-margins-custom-bottom = Inferior
printui-margins-custom-bottom-inches = Inferior (pulgadas)
printui-margins-custom-bottom-mm = Inferior (mm)
printui-margins-custom-left = Izquierdo
printui-margins-custom-left-inches = Izquierda (pulgadas)
printui-margins-custom-left-mm = Izquierdo (mm)
printui-margins-custom-right = Derecho
printui-margins-custom-right-inches = Derecha (pulgadas)
printui-margins-custom-right-mm = Derecho (mm)
printui-system-dialog-link = Imprimir usando el diálogo del sistema…
printui-primary-button = Imprimir
printui-primary-button-save = Guardar
printui-cancel-button = Cancelar
printui-close-button = Cerrar
printui-loading = Preparando vista previa
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Vista previa de impresión
printui-pages-per-sheet = Páginas por hoja
# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = Imprimiendo…
printui-print-progress-indicator-saving = Guardando…

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
printui-paper-letter = Carta EE.UU.
printui-paper-legal = Legal EE.UU.
printui-paper-tabloid = Tabloide

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = La escala debe ser un número entre 10 y 200.
printui-error-invalid-margin = Introduzca un margen válido para el tamaño de papel seleccionado.
printui-error-invalid-copies = El número de copias debe ser un número entre 1 y 10000.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = El rango debe ser un número entre 1 y { $numPages }.
printui-error-invalid-start-overflow = El número de página “desde” debe ser menor que el número “hasta“.
