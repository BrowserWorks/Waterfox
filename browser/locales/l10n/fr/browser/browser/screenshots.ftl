# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

screenshot-toolbarbutton =
    .label = Capture d’écran
    .tooltiptext = Prendre une capture d’écran

screenshots-instructions = Sélectionnez une zone de la page par cliquer-glisser ou en cliquant sur l’élément à sélectionner. Appuyez sur Échap pour annuler.
screenshots-cancel-button = Annuler
screenshots-save-visible-button = Capturer la zone visible
screenshots-save-page-button = Capturer la page complète
screenshots-download-button = Télécharger
screenshots-download-button-tooltip = Télécharger la capture d’écran
screenshots-copy-button = Copier
screenshots-copy-button-tooltip = Copier la capture d’écran dans le presse-papiers

screenshots-meta-key =
    { PLATFORM() ->
        [macos] ⌘
       *[other] Ctrl
    }
screenshots-notification-link-copied-title = Lien copié
screenshots-notification-link-copied-details = Le lien de votre capture a été copié dans le presse-papiers. Appuyez sur { screenshots-meta-key }-V pour le coller.

screenshots-notification-image-copied-title = Capture copiée
screenshots-notification-image-copied-details = Votre capture a été copiée dans le presse-papiers. Appuyez sur { screenshots-meta-key }-V pour la coller.

screenshots-request-error-title = Impossible d’effectuer cette action.
screenshots-request-error-details = Votre capture d’écran n’a pas pu être enregistrée. Veuillez réessayer plus tard.

screenshots-connection-error-title = Nous ne pouvons pas nous connecter à vos captures d’écran.
screenshots-connection-error-details = Veuillez vérifier votre connexion à Internet. Si celle-ci fonctionne normalement, il peut y avoir un problème temporaire avec le service de { -screenshots-brand-name }.

screenshots-login-error-details = Nous n’avons pas pu enregistrer votre capture d’écran, car le service de { -screenshots-brand-name } rencontre des difficultés. Veuillez réessayer plus tard.

screenshots-unshootable-page-error-title = Impossible d’effectuer une capture de cette page.
screenshots-unshootable-page-error-details = Impossible d’effectuer une capture d’écran, car cette page web n’est pas standard.

screenshots-empty-selection-error-title = La zone sélectionnée est trop petite

screenshots-private-window-error-title = { -screenshots-brand-name } est désactivé en mode de navigation privée
screenshots-private-window-error-details = Désolé pour la gêne occasionnée. Nous travaillons sur cette fonctionnalité pour de prochaines versions.

screenshots-generic-error-title = { -screenshots-brand-name } semble avoir un problème.
screenshots-generic-error-details = Un problème non identifié est survenu. Vous pouvez réessayer ou effectuer une capture d’écran d’une autre page.
