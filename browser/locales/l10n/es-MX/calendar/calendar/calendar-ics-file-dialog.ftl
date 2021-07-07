# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

calendar-ics-file-window-2 =
    .title = Importar eventos y tareas del calendario
calendar-ics-file-dialog-import-event-button-label = Importar evento
calendar-ics-file-dialog-import-task-button-label = Importar tarea
calendar-ics-file-dialog-2 =
    .buttonlabelaccept = Importar todo
calendar-ics-file-accept-button-ok-label = Aceptar
calendar-ics-file-cancel-button-close-label = Cerrar
calendar-ics-file-dialog-message-2 = Importar desde archivo:
calendar-ics-file-dialog-calendar-menu-label = Importar al calendario:
calendar-ics-file-dialog-items-loading-message =
    .value = Cargando elementos…
calendar-ics-file-dialog-search-input =
    .placeholder = Filtrar elementos…
calendar-ics-file-dialog-sort-start-ascending =
    .label = Ordenar por fecha de inicio (primero a último)
calendar-ics-file-dialog-sort-start-descending =
    .label = Ordenar por fecha de inicio (último a primero)
# "A > Z" is used as a concise way to say "alphabetical order".
# You may replace it with something appropriate to your language.
calendar-ics-file-dialog-sort-title-ascending =
    .label = Ordenar por título (A > Z)
# "Z > A" is used as a concise way to say "reverse alphabetical order".
# You may replace it with something appropriate to your language.
calendar-ics-file-dialog-sort-title-descending =
    .label = Ordenar por título (Z > A)
calendar-ics-file-dialog-progress-message = Importando…
calendar-ics-file-import-success = ¡Importado correctamente!
calendar-ics-file-import-error = Ha ocurrido un error y el archivo no se pudo importar.
calendar-ics-file-import-complete = Importación completa.
calendar-ics-file-import-duplicates =
    { $duplicatesCount ->
        [one] Se ha ignorado un elemento porque ya existe en el calendario de destino.
       *[other] { $duplicatesCount } se han ignorado porque ya existen en la agenda de destino.
    }
calendar-ics-file-import-errors =
    { $errorsCount ->
        [one] Ha fallado la importación de un elemento. Comprueba la Consola de Errores para ver los detalles.
       *[other] { $errorsCount } no se han importado los elementos. Comprueba la Consola de Errores para ver los detalles.
    }
calendar-ics-file-dialog-no-calendars = No hay calendarios que puedan importar eventos o tareas.
