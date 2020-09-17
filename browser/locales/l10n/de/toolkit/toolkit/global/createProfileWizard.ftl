# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Profil-Assistent
    .style = width: 45em; height: 36em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Beginn
       *[other] { create-profile-window.title } - Willkommen
    }

profile-creation-explanation-1 = { -brand-short-name } speichert alle Einstellungen und Daten in Ihrem persönlichen Profil.

profile-creation-explanation-2 = Wenn Sie diese Kopie von { -brand-short-name } mit anderen Anwendern gemeinsam verwenden, können Sie verschiedene Profile nutzen, um die persönlichen Daten jedes Benutzers getrennt zu verwalten. Dazu sollte jeder Anwender sein eigenes Profil erstellen.

profile-creation-explanation-3 = Auch wenn Sie der einzige Anwender sind, der diese Kopie von { -brand-short-name } verwendet, müssen Sie zumindest ein Profil erstellen. Wenn Sie möchten, können Sie mehrere Profile für sich selbst erstellen, um Ihre Daten getrennt zu verwalten (z. B.: privat und beruflich).

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Um nun ein Profil zu erstellen, klicken Sie auf "Fortsetzen".
       *[other] Um nun ein Profil zu erstellen, klicken Sie auf "Weiter".
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Abschluss
       *[other] { create-profile-window.title } - Fertigstellen
    }

profile-creation-intro = Verschiedene Profile können durch ihre Namen unterschieden werden. Sie können den vorgegebenen oder einen eigenen Namen verwenden.

profile-prompt = Geben Sie den neuen Profilnamen ein:
    .accesskey = G

profile-default-name =
    .value = Standard-Benutzer

profile-directory-explanation = Ihre persönlichen Einstellungen und Daten werden gespeichert in:

create-profile-choose-folder =
    .label = Ordner wählen…
    .accesskey = w

create-profile-use-default =
    .label = Standardordner verwenden
    .accesskey = v
