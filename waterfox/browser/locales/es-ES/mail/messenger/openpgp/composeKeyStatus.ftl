# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-compose-key-status-intro-need-keys = Para enviar un mensaje cifrado de extremo a extremo, debe obtener y aceptar una clave pública para cada destinatario.
openpgp-compose-key-status-keys-heading = Disponibilidad de claves OpenPGP:
openpgp-compose-key-status-title =
    .title = Seguridad de mensajes OpenPGP
openpgp-compose-key-status-recipient =
    .label = Destinatario
openpgp-compose-key-status-status =
    .label = Estado
openpgp-compose-key-status-open-details = Administrar las claves del destinatario seleccionado...
openpgp-recip-good = aceptar
openpgp-recip-missing = no hay ninguna clave disponible
openpgp-recip-none-accepted = no hay ninguna clave aceptada
openpgp-compose-general-info-alias = { -brand-short-name } normalmente requiere que la clave pública del destinatario contenga un ID de usuario que coincida con la dirección de correo electrónico. Esto se puede anular utilizando las reglas de alias de destinatarios de OpenPGP.
openpgp-compose-general-info-alias-learn-more = Saber más
openpgp-compose-alias-status-direct =
    { $count ->
        [one] asignado a una clave de alias
       *[other] asignado a { $count } claves de alias
    }
openpgp-compose-alias-status-error = clave de alias inutilizable/no disponible
