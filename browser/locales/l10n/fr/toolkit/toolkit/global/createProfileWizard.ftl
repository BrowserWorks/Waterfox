# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Assistant de création de profil
    .style = width: 45em; height: 34em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introduction
       *[other] { create-profile-window.title } - Bienvenue
    }

profile-creation-explanation-1 = { -brand-short-name } garde les informations concernant vos paramètres et préférences dans votre profil personnel.

profile-creation-explanation-2 = Si vous partagez cette copie de { -brand-short-name } avec d’autres utilisateurs, vous pouvez utiliser les profils pour garder les informations de chaque utilisateur séparées. Pour ce faire, chaque utilisateur devra créer son propre profil.

profile-creation-explanation-3 = Si vous êtes la seule personne à utiliser cette copie de { -brand-short-name }, vous devez avoir au moins un profil. Si vous le désirez, vous pouvez créer différents profils pour vous-même. Par exemple, vous pouvez vouloir disposer de profils séparés pour votre utilisation personnelle et professionnelle.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Pour commencer à créer votre profil, cliquez sur Continuer.
       *[other] Pour commencer à créer votre profil, cliquez sur Suivant.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Conclusion
       *[other] { create-profile-window.title } - Fin
    }

profile-creation-intro = Si vous créez plusieurs profils, vous pouvez les différencier par leur nom. Vous pouvez utiliser le nom proposé ou en choisir un vous-même.

profile-prompt = Saisissez le nom du nouveau profil :
    .accesskey = E

profile-default-name =
    .value = Utilisateur par défaut

profile-directory-explanation = Vos paramètres utilisateur, préférences et toutes vos données personnelles seront enregistrés dans :

create-profile-choose-folder =
    .label = Choisir un dossier…
    .accesskey = C

create-profile-use-default =
    .label = Utiliser le dossier par défaut
    .accesskey = U
