# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Laadi kaart uuesti
    .accesskey = i
select-all-tabs =
    .label = Vali kõik kaardid
    .accesskey = k
duplicate-tab =
    .label = Klooni kaart
    .accesskey = K
duplicate-tabs =
    .label = Klooni kaardid
    .accesskey = o
close-tabs-to-the-end =
    .label = Sulge paremale jäävad kaardid
    .accesskey = u
close-other-tabs =
    .label = Sulge teised kaardid
    .accesskey = t
reload-tabs =
    .label = Laadi kaardid uuesti
    .accesskey = L
pin-tab =
    .label = Tee püsikaardiks
    .accesskey = e
unpin-tab =
    .label = Tee tavakaardiks
    .accesskey = d
pin-selected-tabs =
    .label = Tee püsikaartideks
    .accesskey = p
unpin-selected-tabs =
    .label = Tee tavakaartideks
    .accesskey = T
bookmark-selected-tabs =
    .label = Lisa kaardid järjehoidjatesse…
    .accesskey = k
bookmark-tab =
    .label = Lisa kaart järjehoidjatesse
    .accesskey = j
reopen-in-container =
    .label = Taasava konteineris
    .accesskey = o
move-to-start =
    .label = Liiguta algusesse
    .accesskey = a
move-to-end =
    .label = Liiguta lõppu
    .accesskey = p
move-to-new-window =
    .label = Liiguta uude aknasse
    .accesskey = k
tab-context-close-multiple-tabs =
    .label = Sulge mitu kaarti
    .accesskey = m

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [one] Võta kaardi sulgemine tagasi
           *[other] Võta kaartide sulgemine tagasi
        }
    .accesskey = V
close-tab =
    .label = Sulge kaart
    .accesskey = S
close-tabs =
    .label = Sulge kaardid
    .accesskey = S
move-tabs =
    .label = Liiguta kaarte
    .accesskey = i
move-tab =
    .label = Liiguta kaarti
    .accesskey = i
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [one] Sulge kaart
           *[other] Sulge kaardid
        }
    .accesskey = S
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [one] Liiguta kaarti
           *[other] Liiguta kaarte
        }
    .accesskey = L
