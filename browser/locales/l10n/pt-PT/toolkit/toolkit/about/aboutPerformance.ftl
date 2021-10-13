# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Gestor de tarefas

## Column headers

column-name = Nome
column-type = Tipo
column-energy-impact = Impacto energético
column-memory = Memória

## Special values for the Name column

ghost-windows = Separadores fechados recentemente
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Pré-carregado: { $title }

## Values for the Type column

type-tab = Separador
type-subframe = Subframe
type-tracker = Rastreador
type-addon = Extra
type-browser = Navegador
type-worker = Worker
type-other = Outro

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Alto ({ $value })
energy-impact-medium = Médio ({ $value })
energy-impact-low = Baixo ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Fechar separador
show-addon =
    .title = Mostrar no Gestor de extras

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occurred for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occurred in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Despachos desde o carregamento: { $totalDispatches } ({ $totalDuration } ms)
        Despachos nos últimos segundos: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
