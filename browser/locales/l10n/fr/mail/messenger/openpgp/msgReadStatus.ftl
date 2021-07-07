# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = S

#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] Afficher la sécurité du message (⌘ ⌥ { message-header-show-security-info-key })
           *[other] Afficher la sécurité du message (Ctrl+Alt+{ message-header-show-security-info-key })
        }

openpgp-view-signer-key =
    .label = Afficher la clé du signataire
openpgp-view-your-encryption-key =
    .label = Afficher votre clé de déchiffrement
openpgp-openpgp = OpenPGP

openpgp-no-sig = Pas de signature numérique
openpgp-uncertain-sig = Signature numérique incertaine
openpgp-invalid-sig = Signature numérique non valide
openpgp-good-sig = Signature numérique correcte

openpgp-sig-uncertain-no-key = Ce message contient une signature numérique, mais il n’est pas certain qu’elle soit correcte. Pour vérifier la signature, vous devez obtenir une copie de la clé publique de l’expéditeur.
openpgp-sig-uncertain-uid-mismatch = Ce message contient une signature numérique, mais une incompatibilité a été détectée. Le message a été envoyé à partir d’une adresse électronique qui ne correspond pas à la clé publique du signataire.
openpgp-sig-uncertain-not-accepted = Ce message contient une signature numérique, mais vous n’avez pas encore indiqué si la clé du signataire vous paraît correcte ou non.
openpgp-sig-invalid-rejected = Ce message contient une signature numérique, mais vous avez précédemment décidé de rejeter la clé du signataire.
openpgp-sig-invalid-technical-problem = Ce message contient une signature numérique, mais une erreur technique a été détectée. Soit le message a été corrompu, soit le message a été modifié par quelqu’un d’autre.
openpgp-sig-valid-unverified = Ce message comprend une signature numérique valide d’une clé que vous avez déjà acceptée. Cependant, vous n’avez pas encore vérifié que la clé appartient réellement à l’expéditeur.
openpgp-sig-valid-verified = Ce message comprend une signature numérique valide d’une clé vérifiée.
openpgp-sig-valid-own-key = Ce message comprend une signature numérique valide de votre clé personnelle.

openpgp-sig-key-id = Identifiant de clé du signataire : { $key }
openpgp-sig-key-id-with-subkey-id = Identifiant de clé du signataire : { $key } (Sous-identifiant de clé : { $subkey })

openpgp-enc-key-id = Votre identifiant de clé de déchiffrement : { $key }
openpgp-enc-key-with-subkey-id = Votre identifiant de clé de déchiffrement : { $key } (Sous-identifiant de clé de déchiffrement : { $subkey })

openpgp-unknown-key-id = Clé inconnue

openpgp-other-enc-additional-key-ids = De plus, le message a été chiffré à destination des propriétaires des clés suivantes :
openpgp-other-enc-all-key-ids = Le message a été chiffré à destination des propriétaires des clés suivantes :

openpgp-message-header-encrypted-ok-icon =
    .alt = Déchiffrement effectué
openpgp-message-header-encrypted-notok-icon =
    .alt = Échec du déchiffrement

openpgp-message-header-signed-ok-icon =
    .alt = Signature correcte
# Mismatch icon is used for notok state as well
openpgp-message-header-signed-mismatch-icon =
    .alt = Signature incorrecte
openpgp-message-header-signed-unknown-icon =
    .alt = État de signature inconnu
openpgp-message-header-signed-verified-icon =
    .alt = Signature vérifiée
openpgp-message-header-signed-unverified-icon =
    .alt = Signature non vérifiée
