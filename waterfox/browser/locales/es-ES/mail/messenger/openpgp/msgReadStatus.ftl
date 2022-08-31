# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = S

#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] Mostrar seguridad del mensaje (⌃ ⌘ { message-header-show-security-info-key })
           *[other] Mostrar seguridad del mensaje (Ctrl+Alt+{ message-header-show-security-info-key })
        }

openpgp-view-signer-key =
    .label = Ver la clave del firmante
openpgp-view-your-encryption-key =
    .label = Ver su clave de descifrado
openpgp-openpgp = OpenPGP

openpgp-no-sig = Sin firma digital
openpgp-no-sig-info = Este mensaje no contiene la firma digital del remitente. La ausencia de una firma digital significa que el mensaje podría haber sido enviado por alguien que finge tener esta dirección de correo electrónico. También es posible que el mensaje haya sido alterado mientras circulaba por la red.
openpgp-uncertain-sig = Firma digital incierta
openpgp-invalid-sig = Firma digital no válida
openpgp-good-sig = Firma digital correcta

openpgp-sig-uncertain-no-key = Este mensaje contiene una firma digital, pero no está claro si es correcta. Para comprobar la firma, necesita obtener una copia de la clave pública del remitente.
openpgp-sig-uncertain-uid-mismatch = Este mensaje contiene una firma digital, pero se detectó una discrepancia. El mensaje fue enviado desde una dirección de correo electrónico que no coincide con la clave pública del firmante.
openpgp-sig-uncertain-not-accepted = Este mensaje contiene una firma digital, pero aún no ha decidido si acepta la clave del firmante.
openpgp-sig-invalid-rejected = Este mensaje contiene una firma digital, pero previamente decidió rechazar la clave del firmante.
openpgp-sig-invalid-technical-problem = Este mensaje contiene una firma digital, pero se detectó un error técnico. O el mensaje se ha dañado o alguien más lo ha modificado.
openpgp-sig-valid-unverified = Este mensaje incluye una firma digital válida de una clave que ya ha aceptado. Sin embargo, aún no ha comprobado que la clave sea propiedad del remitente.
openpgp-sig-valid-verified = Este mensaje incluye una firma digital válida de una clave verificada.
openpgp-sig-valid-own-key = Este mensaje incluye una firma digital válida de su clave personal.

openpgp-sig-key-id = ID de la clave del firmante: { $key }
openpgp-sig-key-id-with-subkey-id = ID de la clave del firmante: { $key } (ID de la subclave: { $subkey })

openpgp-enc-key-id = Su ID de la clave de descifrado: { $key }
openpgp-enc-key-with-subkey-id = Su ID de la clave de descifrado: { $key } (ID de la subclave: { $subkey })

openpgp-enc-none = El mensaje no está cifrado
openpgp-enc-none-label = Este mensaje no fue cifrado antes de ser enviado. La información que se manda a Internet sin cifrar puede ser vista por otras personas mientras llega a su destino.

openpgp-enc-invalid-label = No se puede descifrar el mensaje
openpgp-enc-invalid = Este mensaje fue cifrado antes de ser enviado, pero no se puede descifrar.

openpgp-enc-clueless = Hay problemas desconocidos con este mensaje cifrado.

openpgp-enc-valid-label = El mensaje está cifrado
openpgp-enc-valid = Este mensaje fue cifrado antes de ser enviado. El cifrado asegura que el mensaje solo pueda ser leído por los destinatarios previstos.

openpgp-unknown-key-id = Clave desconocida

openpgp-other-enc-additional-key-ids = Además, el mensaje se cifró para los propietarios de las siguientes claves:
openpgp-other-enc-all-key-ids = El mensaje fue cifrado para los propietarios de las siguientes claves:

openpgp-message-header-encrypted-ok-icon =
    .alt = Descifrado con éxito
openpgp-message-header-encrypted-notok-icon =
    .alt = Descifrado fallido

openpgp-message-header-signed-ok-icon =
    .alt = Firma correcta
# Mismatch icon is used for notok state as well
openpgp-message-header-signed-mismatch-icon =
    .alt = Firma errónea
openpgp-message-header-signed-unknown-icon =
    .alt = Estado de firma desconocido
openpgp-message-header-signed-verified-icon =
    .alt = Firma verificada
openpgp-message-header-signed-unverified-icon =
    .alt = Firma no verificada
