# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Gestione attività

## Column headers
column-name = Nome
column-type = Tipo
column-energy-impact = Impatto energetico
column-memory = Memoria

## Special values for the Name column
ghost-windows = Schede chiuse di recente
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Precaricato: { $title }

## Values for the Type column
type-tab = Scheda
type-subframe = Subframe
type-tracker = Tracker
type-addon = Comp. aggiuntivo
type-browser = Browser
type-worker = Worker
type-other = Altro

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)
energy-impact-high = Alto ({ $value })
energy-impact-medium = Medio ({ $value })
energy-impact-low = Basso ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used
size-KB = { $value } kB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons
close-tab =
    .title = Chiudi scheda
show-addon =
    .title = Mostra nel gestore componenti aggiuntivi

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Dispatch dal caricamento: { $totalDispatches } ({ $totalDuration }ms)
        Dispatch negli ultimi secondi: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
