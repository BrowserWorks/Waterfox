# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Päivitä välilehti
    .accesskey = P
select-all-tabs =
    .label = Valitse kaikki välilehdet
    .accesskey = a
duplicate-tab =
    .label = Monista välilehti
    .accesskey = n
duplicate-tabs =
    .label = Monista välilehdet
    .accesskey = n
close-tabs-to-the-end =
    .label = Sulje välilehdet oikealla
    .accesskey = o
close-other-tabs =
    .label = Sulje muut välilehdet
    .accesskey = m
reload-tabs =
    .label = Päivitä välilehdet
    .accesskey = P
pin-tab =
    .label = Kiinnitä välilehti
    .accesskey = K
unpin-tab =
    .label = Irrota välilehti
    .accesskey = I
pin-selected-tabs =
    .label = Kiinnitä välilehdet
    .accesskey = K
unpin-selected-tabs =
    .label = Irrota välilehdet
    .accesskey = I
bookmark-selected-tabs =
    .label = Lisää välilehdet kirjanmerkkeihin…
    .accesskey = i
bookmark-tab =
    .label = Lisää välilehti kirjanmerkkeihin
    .accesskey = i
reopen-in-container =
    .label = Avaa uudelleen eristystilassa
    .accesskey = e
move-to-start =
    .label = Siirrä alkuun
    .accesskey = a
move-to-end =
    .label = Siirrä loppuun
    .accesskey = l
move-to-new-window =
    .label = Siirrä uuteen ikkunaan
    .accesskey = S
tab-context-close-multiple-tabs =
    .label = Sulje useita välilehtiä
    .accesskey = t

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Kumoa välilehden sulkeminen
           *[other] Kumoa välilehtien sulkeminen
        }
    .accesskey = u
close-tab =
    .label = Sulje välilehti
    .accesskey = S
close-tabs =
    .label = Sulje välilehdet
    .accesskey = S
move-tabs =
    .label = Siirrä välilehdet
    .accesskey = r
move-tab =
    .label = Siirrä välilehti
    .accesskey = r
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Sulje välilehti
           *[other] Sulje välilehdet
        }
    .accesskey = S
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Siirrä välilehti
           *[other] Siirrä välilehdet
        }
    .accesskey = r
