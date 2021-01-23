# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Gestor de tasques

## Column headers

column-name = Nom
column-type = Tipus
column-energy-impact = Impacte energètic
column-memory = Memòria

## Special values for the Name column

ghost-windows = Pestanyes tancades recentment

## Values for the Type column

type-tab = Pestanya
type-subframe = Submarc
type-tracker = Element de seguiment
type-addon = Complement
type-browser = Navegador
type-worker = Procés de treball
type-other = Altres

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Alt ({ $value })
energy-impact-medium = Mitjà ({ $value })
energy-impact-low = Baix ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } kB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Tanca la pestanya
show-addon =
    .title = Mostra en el gestor de complements

