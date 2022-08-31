# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-one-recipient-status-title =
    .title = Seguridad de mensajes OpenGPG
openpgp-one-recipient-status-status =
    .label = Estado
openpgp-one-recipient-status-key-id =
    .label = ID de clave
openpgp-one-recipient-status-created-date =
    .label = Creado
openpgp-one-recipient-status-expires-date =
    .label = Caduca
openpgp-one-recipient-status-open-details =
    .label = Abrir detalles y editar aceptación…
openpgp-one-recipient-status-discover =
    .label = Descubrir clave nueva o actualizada
openpgp-one-recipient-status-instruction1 = Para enviar un mensaje cifrado de extremo a extremo a un destinatario, necesita obtener su clave pública OpenPGP y marcarla como aceptada.
openpgp-one-recipient-status-instruction2 = Para obtener su clave pública, impórtela desde el correo electrónico que le han enviado y que la incluye. También puede intentar descubrir su clave pública en un directorio.
openpgp-key-own = Aceptada (clave personal)
openpgp-key-secret-not-personal = Inutilizable
openpgp-key-verified = Aceptada (verificada)
openpgp-key-unverified = Aceptada (no verificada)
openpgp-key-undecided = No aceptada (indecisa)
openpgp-key-rejected = No aceptada (rechazada)
openpgp-key-expired = Caducada
openpgp-intro = Claves públicas disponibles para { $key }
openpgp-pubkey-import-id = ID: { $kid }
openpgp-pubkey-import-fpr = Huella digital: { $fpr }
openpgp-pubkey-import-intro =
    { $num ->
        [one] El archivo contiene una clave pública que se muestra a continuación:
       *[other] El archivo contiene { $num } claves públicas que se muestran a continuación:
    }
openpgp-pubkey-import-accept =
    { $num ->
        [one] ¿Acepta esta clave para verificar firmas digitales y cifrar mensajes para todas las direcciones de correo electrónico mostradas?
       *[other] ¿Acepta estas claves para verificar firmas digitales y cifrar mensajes para todas las direcciones de correo electrónico mostradas?
    }
pubkey-import-button =
    .buttonlabelaccept = Importar
    .buttonaccesskeyaccept = I
