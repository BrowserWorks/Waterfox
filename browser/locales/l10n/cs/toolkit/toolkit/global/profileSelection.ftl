# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

profile-selection-window =
    .title = { -brand-short-name } - Výběr profilu uživatele

profile-selection-button-accept =
    .label =
        Spustit { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "acc") }
            [feminine] { -brand-short-name(case: "acc") }
            [neuter] { -brand-short-name(case: "acc") }
           *[other] aplikaci { -brand-short-name }
        }

profile-selection-button-cancel =
    .label = Ukončit

profile-selection-new-button =
    .label = Vytvořit profil…
    .accesskey = V

profile-selection-rename-button =
    .label = Přejmenovat profil…
    .accesskey = P

profile-selection-delete-button =
    .label = Smazat profil…
    .accesskey = m

## Messages used in the profile manager

profile-manager-description = { -brand-short-name } ukládá informace o vašem nastavení, předvolbách a ostatních uživatelských položkách do vašeho uživatelského profilu.

profile-manager-work-offline =
    .label = Pracovat offline
    .accesskey = l

profile-manager-use-selected =
    .label = Použít zvolený profil bez ptaní při startu
    .accesskey = P
