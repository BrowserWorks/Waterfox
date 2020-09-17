# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Görev Yöneticisi

## Column headers

column-name = Adı
column-type = Türü
column-energy-impact = Enerji etkisi
column-memory = Bellek

## Special values for the Name column

ghost-windows = Son kapatılan sekmeler
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Ön yüklenen: { $title }

## Values for the Type column

type-tab = Sekme
type-subframe = Alt çerçeve
type-tracker = Takipçi
type-addon = Eklenti
type-browser = Tarayıcı
type-worker = Worker
type-other = Diğer

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Yüksek ({ $value })
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
    .title = Sekmeyi kapat
show-addon =
    .title = Eklenti yöneticisinde göster

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Yüklemeden sonraki sevk: { $totalDispatches } ({ $totalDuration } ms)
        Son saniyelerdeki sevk: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
