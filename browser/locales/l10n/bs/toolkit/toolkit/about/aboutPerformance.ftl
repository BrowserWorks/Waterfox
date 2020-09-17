# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Task Manager

## Column headers

column-name = Naziv
column-type = Tip
column-energy-impact = Energetski uticaj
column-memory = Memorija

## Special values for the Name column

ghost-windows = Nedavno zatvoreni tabovi
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Unaprijed učitano: { $title }

## Values for the Type column

type-tab = Tab
type-subframe = Subframe
type-tracker = Tracker
type-addon = Add-on
type-browser = Browser
type-worker = Worker
type-other = Ostalo

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Visoko ({ $value })
energy-impact-medium = Srednje ({ $value })
energy-impact-low = Nisko ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Zatvori tab
show-addon =
    .title = Prikaži u Add-on Manageru

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occurred for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occurred in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Isporuke od učitavanja: { $totalDispatches } ({ $totalDuration }ms)
        Isporuke u posljednjim sekundama: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
