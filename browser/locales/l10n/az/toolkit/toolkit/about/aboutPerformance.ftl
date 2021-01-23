# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Tapşırıq idarə edicisi

## Column headers

column-name = Ad
column-type = Növ
column-energy-impact = Elektrik istifadəsi
column-memory = Yaddaş

## Special values for the Name column

ghost-windows = Yeni qapanmış vərəqlər
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Ön yüklənib: { $title }

## Values for the Type column

type-tab = Vərəq
type-subframe = Alt çərçivə
type-tracker = İzləyici
type-addon = Əlavə
type-browser = Səyyah
type-worker = Worker
type-other = Digər

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Yüksək ({ $value })
energy-impact-medium = Orta ({ $value })
energy-impact-low = Düşük ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Vərəqi qapat
show-addon =
    .title = Əlavələr İdarəçisində göstər

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Yüklənmədən sonrakı göndərmələr: { $totalDispatches } ({ $totalDuration }ms)
        Son saniyələrdəki göndərmələr: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
