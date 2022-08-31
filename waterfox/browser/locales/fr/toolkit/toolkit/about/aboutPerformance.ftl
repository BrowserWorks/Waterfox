# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Gestionnaire de tâches

## Column headers

column-name = Nom
column-type = Type
column-energy-impact = Impact énergétique
column-memory = Mémoire

## Special values for the Name column

ghost-windows = Onglets récemment fermés
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Préchargé : { $title }

## Values for the Type column

type-tab = Onglet
type-subframe = Subframe
type-tracker = Traqueur
type-addon = Module
type-browser = Navigateur
type-worker = Worker
type-other = Autre

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Élevé ({ $value })
energy-impact-medium = Moyen ({ $value })
energy-impact-low = Faible ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } Ko
size-MB = { $value } Mo
size-GB = { $value } Go

## Tooltips for the action buttons

close-tab =
    .title = Fermer l’onglet
show-addon =
    .title = Afficher dans le gestionnaire des modules complémentaires

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Exécutions depuis le chargement : { $totalDispatches } ({ $totalDuration } ms)
        Exécutions au cours des dernières secondes : { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
