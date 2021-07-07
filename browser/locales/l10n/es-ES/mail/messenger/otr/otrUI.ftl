# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

start-label = Iniciar una conversación cifrada
refresh-label = Refrescar la conversación cifrada
auth-label = Verificar la identidad de su contacto
reauth-label = Verificar de nuevo la identidad de su contacto

auth-cancel = Cancelar

auth-error = Ha sucedido un error al verificar la identidad de su contacto.
auth-success = Se ha completado correctamente la verificación de la identidad de su contacto.
auth-fail = Ha fallado la verificación de la identidad de su contacto.
auth-waiting = Esperando que el contacto complete la verificación…

finger-verify = Verificar

# Do not translate 'OTR' (name of an encryption protocol)
buddycontextmenu-label = Añadir huella OTR

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-start = Intentando iniciar una conversación cifrada con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-refresh = Intentando refrescar la conversación cifrada con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-unseen = La identidad de { $name } no se ha verificado aún. No es posible una infiltración por casualidad, pero con cierto esfuerzo alguien podría estar escuchando. Evite la vigilancia verificando la identidad de su contacto.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-seen = { $name } está contactando con usted desde un equipo no reconocido. No es posible una infiltración por casualidad, pero con cierto esfuerzo alguien podría estar escuchando. Evite la vigilancia verificando la identidad de su contacto.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-unverified = La conversación actual está cifrada pero no es privada, dado que la identidad de { $name } aún no ha sido verificada.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-private = La identidad de { $name } ha sido verificada. La conversación actual está cifrada y es privada.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-finished = { $name } ha finalizado su conversación privada con usted; debería hacer lo mismo.

state-unverified-label = No verificada
state-private-label = Privada
state-finished-label = Finalizada

# Variables:
#   $name (String) - the screen name of a chat contact person
verify-request = { $name } ha solicitado la verificación de su identidad.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-private = Ha verificado la identidad de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-unverified = La identidad de { $name } no ha sido verificada.

verify-title = Verificar la identidad de su contacto
error-title = Error
success-title = Cifrado extremo a extremo
fail-title = No se puede verificar
waiting-title = Solicitud de verificación enviada

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $error (String) - contains an error message that describes the cause of the failure
otr-genkey-failed = Ha fallado la generación de la clave privada OTR: { $error }
