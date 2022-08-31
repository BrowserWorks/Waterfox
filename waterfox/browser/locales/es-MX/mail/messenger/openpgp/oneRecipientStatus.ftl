# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-one-recipient-status-title =
    .title = Seguridad de mensajes OpenPGP
openpgp-one-recipient-status-status =
    .label = Estatus
openpgp-one-recipient-status-key-id =
    .label = ID de clave
openpgp-one-recipient-status-created-date =
    .label = Creado
openpgp-one-recipient-status-expires-date =
    .label = Expira
openpgp-one-recipient-status-open-details =
    .label = Abrir detalles y editar aprobación…
openpgp-one-recipient-status-discover =
    .label = Descubrir clave nueva o actualizada

openpgp-one-recipient-status-instruction1 = Para enviar un mensaje cifrado de extremo a un destinatario, necesitas obtener tu clave pública OpenPGP y marcarla como aceptada.
openpgp-one-recipient-status-instruction2 = Para obtener su claves pública, importarlos desde el correo electrónico que te han enviado y que las incluye. También, puedes intentar descubrir su clave pública en un directorio.

openpgp-key-own = Aceptado (clave personal)
openpgp-key-secret-not-personal = No utilizable
openpgp-key-verified = Aceptada (verificado)
openpgp-key-unverified = Aceptada (sin verificar)
openpgp-key-undecided = No aceptado (indeciso)
openpgp-key-rejected = No aceptado (rechazado)
openpgp-key-expired = Expirado

openpgp-intro = Claves públicas disponibles para { $key }

openpgp-pubkey-import-id = ID: { $kid }
openpgp-pubkey-import-fpr = Huella digital: { $fpr }

openpgp-pubkey-import-intro =
    { $num ->
        [one] El archivo contiene una llave pública que se muestra a continuación:
       *[other] El archivo contiene { $num } llaves públicas que se muestran a continuación:
    }

openpgp-pubkey-import-accept =
    { $num ->
        [one] ¿Aceptas esta llave para verificar firmas digitales y cifrar mensajes para todas las direcciones de correo electrónico mostradas?
       *[other] ¿Aceptas estas llaves para verificar firmas digitales y cifrar mensajes para todas las direcciones de correo electrónico mostradas?
    }

pubkey-import-button =
    .buttonlabelaccept = Importar
    .buttonaccesskeyaccept = I
