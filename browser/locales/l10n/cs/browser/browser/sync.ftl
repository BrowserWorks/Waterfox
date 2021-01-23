# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

fxa-toolbar-sync-syncing =
    .label = Probíhá synchronizace…
fxa-toolbar-sync-syncing-tabs =
    .label = Probíhá synchronizace panelů…
sync-disconnect-dialog-title = Odpojit { -sync-brand-short-name(case: "acc") }?
sync-disconnect-dialog-body = { -brand-product-name } ukončí synchronizaci s vaším účtem, ale nesmaže z tohoto zařízení žádná vaše data.
fxa-disconnect-dialog-title =
    Odpojit { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "acc") }
        [feminine] { -brand-product-name(case: "acc") }
        [neuter] { -brand-product-name(case: "acc") }
       *[other] aplikaci { -brand-product-name }
    }?
fxa-disconnect-dialog-body = { -brand-product-name } se odpojí od vašeho účtu, ale nesmaže žádná vaše data na tomto zařízení.
sync-disconnect-dialog-button = Odpojit
fxa-signout-dialog-heading = Odhlásit se od { -fxaccount-brand-name(case: "gen", capitalization: "lower") }?
fxa-signout-dialog-body = Synchronizovaná data zůstanou uložená ve vašem účtu.
fxa-signout-checkbox =
    .label = Odstranit data z tohoto zařízení (přihlašovací údaje, hesla, historie, záložky atd.).
fxa-signout-dialog =
    .title = Odhlášení od { -fxaccount-brand-name(case: "gen", capitalization: "lower") }
    .style = min-width: 375px;
    .buttonlabelaccept = Odhlásit se
