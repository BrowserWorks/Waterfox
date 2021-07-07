# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = Mode de dépannage de { -brand-short-name }
    .style = width: 37em;

troubleshoot-mode-description = Utilisez le mode de dépannage de { -brand-short-name } pour diagnostiquer les problèmes. Vos personnalisations et vos modules complémentaires seront temporairement désactivés.

troubleshoot-mode-description2 = Il est possible de rendre tout ou partie de ces changements permanents :

troubleshoot-mode-disable-addons =
    .label = Désactiver tous les modules complémentaires
    .accesskey = D

troubleshoot-mode-reset-toolbars =
    .label = Réinitialiser les barres d’outils et les contrôles
    .accesskey = R

troubleshoot-mode-change-and-restart =
    .label = Effectuer les changements et redémarrer
    .accesskey = m

troubleshoot-mode-continue =
    .label = Continuer en mode de dépannage
    .accesskey = C

troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] Quitter
           *[other] Quitter
        }
    .accesskey =
        { PLATFORM() ->
            [windows] Q
           *[other] Q
        }
