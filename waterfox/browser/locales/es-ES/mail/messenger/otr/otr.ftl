# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption-required-part1 = Ha intentado enviar un mensaje no cifrado a { $name }. Como norma, los mensajes no cifrados no están permitidos.

msgevent-encryption-required-part2 = Intentando iniciar una conversación privada. El mensaje será reenviado cuando la conversación privada se inicie.
msgevent-encryption-error = Ha ocurrido un error al cifrar el mensaje. El mensaje no ha sido enviado.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection-ended = { $name } ya cerró la conexión cifrada con usted. Para evitar que envíe accidentalmente un mensaje sin cifrado, su mensaje no se envió. Por favor finalice su conversación cifrada o reiníciela.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup-error = Ha ocurrido un error al configurar una conversación privada con { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg-reflected = Está recibiendo sus propios mensajes OTR. Está intentando hablar consigo mismo o alguien le está reenviado sus propios mensajes.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg-resent = El último mensaje a { $name } ha sido reenviado.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-not-private = El mensaje cifrado recibido de { $name } no se puede leer ya que en este momento no se está comunicando de forma privada.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unreadable = Ha recibido un mensaje cifrado ilegible de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-malformed = Ha recibido un mensaje de datos con formato incorrecto de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-rcvd = Mensaje Heartbeat recibido de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-sent = Mensaje Heartbeat enviado a { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg-general-err = Ha ocurrido un error inesperado al intentar proteger su conversación usando OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg-unencrypted = El siguiente mensaje recibido de { $name } no estaba cifrado: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unrecognized = Ha recibido un mensaje OTR no reconocido de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-for-other-instance = { $name } ha enviado un mensaje destinado a una sesión diferente. Si inició sesión varias veces, otra sesión puede haber recibido el mensaje.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-private = Se ha iniciado una conversación privada con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-unverified = Se inició una conversación cifrada pero no verificada con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still-secure = Se ha actualizado correctamente la conversación cifrada con { $name }.

error-enc = Ha sucedido un error al cifrar el mensaje.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not-priv = Ha enviado datos cifrados a { $name }, que no los esperaba.

error-unreadable = Ha transmitido un mensaje cifrado ilegible.
error-malformed = Ha transmitido un mensaje con datos mal formados.

resent = [reenviado]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } ha finalizado su conversación cifrada con usted; debería hacer lo mismo.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } ha solicitado una conversación cifrada Off-the-Record (OTR). Sin embargo, no tiene un plugin compatible con ella. Vea https://es.wikipedia.org/wiki/Off_the_record_messaging para más información.
