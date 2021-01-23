# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

start-label = Comenzar conversación cifrada
refresh-label = Actualizar la conversación cifrada
auth-label = Verificar la identidad del contacto
reauth-label = Vuelva a verificar la identidad de su contacto

auth-cancel = Cancelar
auth-cancelAccessKey = C

auth-error = Se produjo un error al verificar la identidad de su contacto.
auth-success = Verificación de la identidad de su contacto completada con éxito.
auth-successThem = Su contacto verificó con éxito su identidad. Es posible que usted también quiera verificar su identidad haciendo su propia pregunta.
auth-fail = No se pudo verificar la identidad de su contacto.
auth-waiting = Esperando a que el contacto complete la verificación…

finger-verify = Verificar
finger-verify-accessKey = V

# Do not translate 'OTR' (name of an encryption protocol)
buddycontextmenu-label = Agregar huella digital OTR

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-start = Intentando iniciar una conversación cifrada con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-refresh = Intentando actualizar la conversación cifrada con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-gone_insecure = La conversación encriptada con { $name } se terminó.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-unseen = La identidad de { $name } todavía no se verificó. Las escuchas casuales no son posibles, pero con algún esfuerzo alguien podría estar escuchando. Evite la vigilancia verificando la identidad de este contacto.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-seen = { $name } se está contactando desde una computadora no reconocida. Las escuchas casuales no son posibles, pero con algún esfuerzo alguien podría estar escuchando. Evite la vigilancia verificando la identidad de este contacto.

state-not_private = La conversación actual no es privada.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-unverified = La conversación actual está cifrada pero no es privada, ya que la identidad de { $name } todavía no se verificó.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-private = Se verificó la identidad de { $name }. La conversación actual es cifrada y privada.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-finished = { $name } terminó la conversación cifrada con usted; Debería hacer lo mismo.

state-not_private-label = Inseguro
state-unverified-label = Sin verificar
state-private-label = Privado
state-finished-label = Terminado

# Variables:
#   $name (String) - the screen name of a chat contact person
verify-request = { $name } le solicitó verificar su identidad.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-private = Verificó la identidad de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-unverified = No se verificó la identidad de { $name }

verify-title = Verifiquela identidad de su contacto
error-title = Error
success-title = Cifrado de punta a punta
successThem-title = Verifique la identidad de su contacto
fail-title = No se puede verificar
waiting-title = Se envió la solicitud de verificación.

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $error (String) - contains an error message that describes the cause of the failure
otr-genkey-failed = Error al generar la clave privada OTR: { $error }
