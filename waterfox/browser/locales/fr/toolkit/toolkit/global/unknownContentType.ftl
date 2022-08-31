# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

unknowncontenttype-handleinternally =
    .label = Ouvrir avec { -brand-short-name }
    .accesskey = e

unknowncontenttype-settingschange =
    .value =
        { PLATFORM() ->
            [windows] Les paramètres peuvent être modifiés dans le menu Options de { -brand-short-name }.
           *[other] Les paramètres peuvent être modifiés dans le Menu Préférences de { -brand-short-name }.
        }

unknowncontenttype-intro = Vous avez choisi d’ouvrir :
unknowncontenttype-which-is = qui est un fichier de type :
unknowncontenttype-from = à partir de :
unknowncontenttype-prompt = Voulez-vous enregistrer ce fichier ?
unknowncontenttype-action-question = Que doit faire { -brand-short-name } avec ce fichier ?
unknowncontenttype-open-with =
    .label = Ouvrir avec
    .accesskey = O
unknowncontenttype-other =
    .label = Autre…
unknowncontenttype-choose-handler =
    .label =
        { PLATFORM() ->
            [macos] Choisir…
           *[other] Parcourir…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] P
        }
unknowncontenttype-save-file =
    .label = Enregistrer le fichier
    .accesskey = E
unknowncontenttype-remember-choice =
    .label = Toujours effectuer cette action pour ce type de fichier.
    .accesskey = T
