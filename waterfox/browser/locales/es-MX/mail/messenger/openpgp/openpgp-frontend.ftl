# This Source Code Form is subject to the terms of the Waterfox Public
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
    .accesskey = C
openpgp-ctx-import-key =
    .label = Importar clave OpenPGP
    .accesskey = I
openpgp-ctx-verify-att =
    .label = Verificar firma
    .accesskey = V
openpgp-has-sender-key = Este mensaje afirma contener la clave pública OpenPGP del remitente.
openpgp-be-careful-new-key = Advertencia: La nueva clave pública de OpenPGP en este mensaje difiere de las claves públicas que aceptaste anteriormente para { $email }.
openpgp-import-sender-key =
    .label = Importar…
openpgp-search-keys-openpgp =
    .label = Descubrir la clave OpenPGP
openpgp-missing-signature-key = Este mensaje se firmó con una clave que aún no tienes.
openpgp-search-signature-key =
    .label = Descubrir…
# Don't translate the terms "OpenPGP" and "MS-Exchange"
openpgp-broken-exchange-opened = Este es un mensaje de OpenPGP que aparentemente fue dañado por MS-Exchange y no se puede reparar porque se abrió desde un archivo local. Copie el mensaje en una carpeta de correo para intentar una reparación automática.
openpgp-broken-exchange-info = Este es un mensaje de OpenPGP que aparentemente fue dañado por MS-Exchange. Si el contenido del mensaje no se muestra como se esperaba, puedes intentar una reparación automática.
openpgp-broken-exchange-repair =
    .label = Reparar mensaje
openpgp-broken-exchange-wait = Por favor, espera…
openpgp-cannot-decrypt-because-mdc =
    Este es un mensaje cifrado que utiliza un mecanismo antiguo y vulnerable.
    Podría haber sido modificado mientras estaba en tránsito, con la intención de robar su contenido.
    Para evitar este riesgo, no se muestran los contenidos.
openpgp-cannot-decrypt-because-missing-key = La clave secreta necesaria para descifrar este mensaje no está disponible.
openpgp-partially-signed =
    Solo un subconjunto de este mensaje se firmó digitalmente mediante OpenPGP.
    Si haces clic en el botón de verificación, se ocultarán las partes no protegidas y se mostrará el estado de la firma digital.
openpgp-partially-encrypted =
    Solo un subconjunto de este mensaje se cifró con OpenPGP.
    Las partes legibles del mensaje que ya se muestran no se cifraron.
    Si haces clic en el botón de descifrar, se mostrará el contenido de las partes cifradas.
openpgp-reminder-partial-display = Recordatorio: El mensaje que se muestra a continuación es solo un subconjunto del mensaje original.
openpgp-partial-verify-button = Verificar
openpgp-partial-decrypt-button = Descifrar
openpgp-unexpected-key-for-you = Advertencia: Este mensaje contiene una llave OpenPGP desconocida que hace referencia a una de tus direcciones de correo. Si esta no es una de tus llaves, podría ser un intento de engañar a otros contactos.
