# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Couleurs
    .style =
        { PLATFORM() ->
            [macos] width: 54em !important
           *[other] width: 54em !important
        }

colors-dialog-legend = Texte et arrière-plan

text-color-label =
    .value = Texte :
    .accesskey = T

background-color-label =
    .value = Arrière-plan :
    .accesskey = A

use-system-colors =
    .label = Utiliser les couleurs système
    .accesskey = U

colors-link-legend = Couleur des liens

link-color-label =
    .value = Liens non visités :
    .accesskey = L

visited-link-color-label =
    .value = Liens visités :
    .accesskey = v

underline-link-checkbox =
    .label = Souligner les liens
    .accesskey = S

override-color-label =
    .value = Outrepasser les couleurs spécifiées par le contenu avec celles choisies ci-dessus :
    .accesskey = O

override-color-always =
    .label = Toujours

override-color-auto =
    .label = Uniquement pour les thèmes avec un contraste élevé

override-color-never =
    .label = Jamais
