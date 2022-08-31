# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

start-label = Iniciar una conversación cifrado
refresh-label = Actualizar la conversación cifrada.
auth-label = Verificar la identidad de tu contacto
reauth-label = Volver a verificar la identidad de tu contacto

auth-cancel = Cancelar
auth-cancel-access-key = C

auth-error = Ocurrió un error al verificar la identidad de tu contacto.
auth-success = Verificación de la identidad de tu contacto completada con éxito.
auth-success-them = Tu contacto ha verificado correctamente tu identidad. Tal vez quieras verificar su identidad también haciendo tu propia pregunta.
auth-fail = No se pudo verificar la identidad de tu contacto.
auth-waiting = Esperando que el contacto complete la verificación…

finger-verify = Verificar
finger-verify-access-key = V

finger-ignore = Ignorar
finger-ignore-access-key = I

# Do not translate 'OTR' (name of an encryption protocol)
buddycontextmenu-label = Agregar huella digital OTR

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-start = Intentado iniciar una conversación cifrada con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-refresh = Intentando actualizar la conversación cifrada con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-gone-insecure = La conversación cifrada con { $name } terminó.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-unseen = La identidad de { $name } aún no ha sido verificada. No es posible escuchar a escondidas, pero con un poco de esfuerzo alguien podría estar escuchando. Evita la vigilancia verificando la identidad de este contacto.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-seen = { $name } está contactándote desde una computadora no reconocida. No es posible escuchar a escondidas, pero con un poco de esfuerzo alguien podría estar escuchando. Evita la vigilancia verificando la identidad de este contacto.

state-not-private = La conversación actual no es privada.
state-generic-not-private = La conversación actual no es privada.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-unverified = La conversación actual está cifrada pero no es privada, ya que la identidad de { $name } aún no ha sido verificada.

state-generic-unverified = La conversación actual está cifrada pero no es privada, ya que algunas identidades aún no han sido verificadas.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-private = La identidad de { $name } ha sido verificada. La conversación actual está cifrada y es privada.

state-generic-private = La conversación actual esta cifrada y es privada.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-finished = { $name } ha terminado su conversación cifrada contigo; deberías hacer lo mismo.

state-not-private-label = Inseguro
state-unverified-label = No verifcado
state-private-label = Privado
state-finished-label = Terminado

# Variables:
#   $name (String) - the screen name of a chat contact person
verify-request = { $name } solicitó la verificación de tu identidad.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-private = Has verificado la identidad de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-unverified = La identidad de { $name } no ha sido verificada.

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $error (String) - contains an error message that describes the cause of the failure
otr-genkey-failed = Error al generar la clave privada OTR: { $error }
