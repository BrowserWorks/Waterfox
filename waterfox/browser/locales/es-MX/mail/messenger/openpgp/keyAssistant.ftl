# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-key-assistant-title = Asistente de claves OpenPGP
openpgp-key-assistant-rogue-warning = Evita aceptar una llave falsificada. Para asegurarte de haber obtenido la llave correcta, debes verificarla. <a data-l10n-name="openpgp-link">Más información…</a>

## Encryption status

openpgp-key-assistant-recipients-issue-header = No se puede cifrar
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-issue-description =
    { $count ->
        [one] Para cifrar, debes obtener y aceptar una llave utilizable para un destinatario. <a data-l10n-name="openpgp-link">Saber más…</a>
       *[other] Para cifrar, debes obtener y aceptar llaves utilizables para { $count } remitentes. <a data-l10n-name="openpgp-link">Saber más…</a>
    }
openpgp-key-assistant-info-alias = { -brand-short-name } normalmente requiere que la llave pública del destinatario contenga una identificación de usuario con una dirección de correo electrónico coincidente. Esto se puede anular mediante el uso de reglas de alias de destinatarios de OpenPGP. <a data-l10n-name="openpgp-link">Más información…</a>
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-description =
    { $count ->
        [one] Tienes una llave utilizable y aceptada para un destinatario.
       *[other] Tienes varias llaves utilizables y aceptadas para { $count } destinatarios.
    }
openpgp-key-assistant-recipients-description-no-issues = Este mensaje puede estar cifrado. Tienes llaves utilizables y aceptadas para todos los destinatarios.

## Resolve section

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
# $numKeys (Number) - The number of keys.
openpgp-key-assistant-resolve-title =
    { $numKeys ->
        [one] { -brand-short-name } encontró la siguiente llave para { $recipient }.
       *[other] { -brand-short-name } encontró las siguientes llaves para { $recipient }.
    }
openpgp-key-assistant-valid-description = Selecciona la llave que quieres aceptar
# Variables:
# $numKeys (Number) - The number of available keys.
openpgp-key-assistant-invalid-title =
    { $numKeys ->
        [one] La siguiente llave no puede ser usada, a menos que obtengas una actualización.
       *[other] Las siguientes llaves no pueden ser usadas, a menos que obtengas una actualización.
    }
openpgp-key-assistant-no-key-available = No hay llave disponible.
openpgp-key-assistant-multiple-keys = Hay varias claves disponibles.
# Variables:
# $count (Number) - The number of unaccepted keys.
openpgp-key-assistant-key-unaccepted =
    { $count ->
        [one] Una llave está disponible, pero no ha sido aceptada aún.
       *[other] Múltiples llaves están disponibles, pero no han sido aceptadas aún.
    }
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = Una llave aceptadas ha expirado el { $date }.
openpgp-key-assistant-keys-accepted-expired = Múltiples llaves aceptadas han expirado.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = Esta llave fue previamente aceptada pero expiró el { $date }.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one = La clave expiró en { $date }.
openpgp-key-assistant-key-unaccepted-expired-many = Múltiples llaves han expirado.
openpgp-key-assistant-key-fingerprint = Huella dactilar
openpgp-key-assistant-key-source =
    { $count ->
        [one] Fuente
       *[other] Fuentes
    }
openpgp-key-assistant-key-collected-attachment = archivo adjunto de correo
openpgp-key-assistant-key-collected-autocrypt = Encabezado de cifrado automático
openpgp-key-assistant-key-collected-keyserver = Servidor de claves
openpgp-key-assistant-key-collected-wkd = Directorio de llaves web
openpgp-key-assistant-keys-has-collected =
    { $count ->
        [one] Una llave fue encontrada, pero no ha sido aceptada aún.
       *[other] Múltiples llaves fueron encontradas, pero no han sido aceptadas aún.
    }
openpgp-key-assistant-key-rejected = Esta llave ha sido previamente rechazada.
openpgp-key-assistant-key-accepted-other = Esta llave ha sido previamente aceptada, pero por un correo electrónico diferente.
# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info = Descubre llaves adicionales o actualizadas para { $recipient } en línea, o impórtalas desde un archivo.

## Discovery section

openpgp-key-assistant-discover-title = Descubrimiento en línea en progreso.
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = Descubriendo llaves para { $recipient }…
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-expired-key-update =
    Una actualización fue encontrada para una de las llaves aceptadas previamente para { $recipient }.
    Puede ser usada ahora ya que ha dejado de estar expirada.

## Dialog buttons

openpgp-key-assistant-discover-online-button = Descubrir llaves públicas en línea…
openpgp-key-assistant-import-keys-button = Importar llaves públicas desde archivo…
openpgp-key-assistant-issue-resolve-button = Resolver…
openpgp-key-assistant-view-key-button = Ver llave…
openpgp-key-assistant-recipients-show-button = Mostrar
openpgp-key-assistant-recipients-hide-button = Ocultar
openpgp-key-assistant-cancel-button = Cancelar
openpgp-key-assistant-back-button = Atrás
openpgp-key-assistant-accept-button = Aceptar
openpgp-key-assistant-close-button = Cerrar
openpgp-key-assistant-disable-button = Deshabilitar el cifrado
openpgp-key-assistant-confirm-button = Enviar cifrado
# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = creado el { $date }
