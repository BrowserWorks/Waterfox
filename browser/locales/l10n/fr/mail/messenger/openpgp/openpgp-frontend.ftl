# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-manage-keys-openpgp-cmd =
    .label = Gestionnaire de clés OpenPGP
    .accesskey = G

openpgp-ctx-decrypt-open =
    .label = Déchiffrer et ouvrir
    .accesskey = D
openpgp-ctx-decrypt-save =
    .label = Déchiffrer et enregistrer sous…
    .accesskey = c
openpgp-ctx-import-key =
    .label = Importer une clé OpenPGP
    .accesskey = I
openpgp-ctx-verify-att =
    .label = Vérifier la signature
    .accesskey = V

openpgp-has-sender-key = Ce message prétend contenir la clé publique OpenPGP de l’expéditeur.
openpgp-be-careful-new-key = Avertissement : la nouvelle clé publique OpenPGP contenue dans ce message diffère des clés publiques que vous aviez précédemment acceptées pour { $email }.

openpgp-import-sender-key =
    .label = Importer…

openpgp-search-keys-openpgp =
    .label = Rechercher la clé OpenPGP

openpgp-missing-signature-key = Ce message a été signé avec une clé que vous ne possédez pas encore.

openpgp-search-signature-key =
    .label = Rechercher…

# Don't translate the terms "OpenPGP" and "MS-Exchange"
openpgp-broken-exchange-opened = Il s’agit d’un message OpenPGP qui a été apparemment corrompu par MS-Exchange et qui ne peut pas être réparé, car il a été ouvert à partir d’un fichier local. Copiez le message dans un dossier de courrier pour tenter une réparation automatique.
openpgp-broken-exchange-info = Ce message OpenPGP a été apparemment corrompu par MS-Exchange. Si le contenu du message ne s’affiche pas comme prévu, vous pouvez tenter une réparation automatique.
openpgp-broken-exchange-repair =
    .label = Réparer le message
openpgp-broken-exchange-wait = Veuillez patienter…

openpgp-cannot-decrypt-because-mdc = Ce message chiffré a recours à un mécanisme ancien et vulnérable. Il a pu être modifié pendant sa transmission, avec l’intention de dérober son contenu. Pour éviter ce risque, le contenu n’est pas affiché.

openpgp-cannot-decrypt-because-missing-key = La clé secrète nécessaire pour déchiffrer ce message n’est pas disponible.

openpgp-partially-signed =
    Seule une partie de ce message a été signée numériquement à l’aide d’OpenPGP.
    Si vous cliquez sur le bouton Vérifier, les parties non protégées seront masquées et l’état de la signature numérique sera affiché.

openpgp-partially-encrypted =
    Seule une partie de ce message a été chiffrée à l’aide d’OpenPGP.
    Les parties lisibles du message qui sont déjà affichées n’ont pas été chiffrées.
    Si vous cliquez sur le bouton Déchiffrer, le contenu des parties chiffrées sera affiché.

openpgp-reminder-partial-display = Rappel : le message ci-dessous n’est qu’une partie du message d’origine.

openpgp-partial-verify-button = Vérifier
openpgp-partial-decrypt-button = Déchiffrer

