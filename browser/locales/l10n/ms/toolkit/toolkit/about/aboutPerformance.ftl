# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Pengurus Tugasan

## Column headers

column-name = Nama
column-type = Jenis
column-energy-impact = Impak Tenaga

## Special values for the Name column

ghost-windows = Tab terkini ditutup
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Pramuat: { $title }

## Values for the Type column

type-tab = Tab
type-subframe = Subbingkai
type-tracker = Penjejak
type-addon = Add-on
type-browser = Pelayar
type-worker = Worker
type-other = Lain-lain

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Tinggi ({ $value })
energy-impact-medium = Medium ({ $value })
energy-impact-low = Rendah ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

## Tooltips for the action buttons

close-tab =
    .title = Tutup tab
show-addon =
    .title = Papar dalam Pengurus Add-ons

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Penghantaran sejak beban: { $totalDispatches } ({ $totalDuration }ms)
        Penghantaran dalam saat terakhir: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
