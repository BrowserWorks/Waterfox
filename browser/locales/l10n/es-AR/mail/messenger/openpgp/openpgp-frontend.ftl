# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-manage-keys-openpgp-cmd =
    .label = Administrador de claves OpenPGP
    .accesskey = O

openpgp-ctx-decrypt-open =
    .label = Descifrar y abrir
    .accesskey = D
openpgp-ctx-decrypt-save =
    .label = Descifrar y guardar como…
    .accesskey = c
openpgp-ctx-import-key =
    .label = Importar clave OpenPGP
    .accesskey = I
openpgp-ctx-verify-att =
    .label = Verificar firma
    .accesskey = V

openpgp-has-sender-key = Este mensaje dice contener la clave pública OpenPGP del remitente.
openpgp-be-careful-new-key = Advertencia: La nueva clave pública OpenPGP en este mensaje difiere de las claves públicas previamente aceptadas para { $email }.

openpgp-import-sender-key =
    .label = Importar…

openpgp-search-keys-openpgp =
    .label = Descubrir clave OpenPGP

openpgp-missing-signature-key = Este mensaje fue firmado con una clave que aún no tiene.

openpgp-search-signature-key =
    .label = Descubrir…

# Don't translate the terms "OpenPGP" and "MS-Exchange"
openpgp-broken-exchange-info = Este es un mensaje OpenPGP que aparentemente fue dañado por MS-Exchange. Si el contenido del mensaje no se muestra como es esperado, se puede intentar una reparación automática.
openpgp-broken-exchange-repair =
    .label = Reparar mensaje
openpgp-broken-exchange-wait = Espere…

openpgp-cannot-decrypt-because-mdc =
    Este es un mensaje cifrado que usa un mecanismo viejo y vulnerable.
    Se puede haber modificado en tránsito con la intención de robar su contenido.
    Para evitar este riesgo, el contenido no se muestra.

openpgp-cannot-decrypt-because-missing-key = La clave secreta que se requiere para descifrar este mensaje no está disponible.

openpgp-partially-signed =
    Se firmó digitalmente con OpenPGP solo un subconjunto de este mensaje .
    Si hace clic en el botón de verificación, las partes desprotegidas se ocultarán y se mostrará el estado de la firma digital.

openpgp-partially-encrypted =
    Se cifró con OpenPGP solo un subconjunto de este mensaje.
    Las partes legibles del mensaje que ya se muestran no se cifraron.
    Si hace clic en el botón descifrar, se mostrará el contenido de las partes cifradas.

openpgp-reminder-partial-display = Recordatorio: El mensaje que se muestra a continuación es solo un subconjunto del mensaje original.

openpgp-partial-verify-button = Verificar
openpgp-partial-decrypt-button = Descifrar

