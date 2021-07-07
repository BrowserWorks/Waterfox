# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Administrador de tareas

## Column headers

column-name = Nombre
column-type = Tipo
column-energy-impact = Impacto energético
column-memory = Memoria

## Special values for the Name column

ghost-windows = Pestañas cerradas recientemente
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Precargado: { $title }

## Values for the Type column

type-tab = Pestaña
type-subframe = Subframe
type-tracker = Rastreador
type-addon = Complemento
type-browser = Navegador
type-worker = Worker
type-other = Otro

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Elevado ({ $value })
energy-impact-medium = Medio ({ $value })
energy-impact-low = Bajo ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Cerrar pestaña
show-addon =
    .title = Mostrar en el administrador de complementos

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title = Envíos desde la carga: { $totalDispatches } ({ $totalDuration }ms) Envíos en los últimos segundos: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
