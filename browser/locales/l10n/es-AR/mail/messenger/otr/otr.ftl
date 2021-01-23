# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = Intentó enviar un mensaje sin cifrar a { $name }. Como política, los mensajes no cifrados no están permitidos.

msgevent-encryption_required_part2 = Intentando iniciar una conversación privada. Su mensaje va a ser reenviado cuando comience la conversación privada.
msgevent-encryption_error = Se produjo un error al cifrar su mensaje. El mensaje no fue enviado.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = { $name } ya cerró la conexión cifrada con usted. Para evitar que envíe accidentalmente un mensaje sin cifrado, su mensaje no se envió. Finalice su conversación cifrada o reiníciela.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = Se produjo un error al configurar una conversación privada con { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = Está recibiendo sus propios mensajes OTR. Está intentando hablar consigo mismo o alguien está reflejando sus mensajes.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = Se reenvió el último mensaje a { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = El mensaje cifrado recibido de { $name } no se puede leer ya que no se está comunicando en privado en este momento.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = Recibió un mensaje cifrado ilegible de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = Recibió un mensaje de datos con formato incorrecto de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = Pulsos recibidos de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = Pulso enviado a { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = Se produjo un error inesperado al intentar proteger su conversación usando OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = El siguiente mensaje recibido de { $name } no se cifró: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = Recibió un mensaje OTR no reconocido de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = { $name } envió un mensaje destinado a una sesión diferente. Si inició sesión varias veces, otra sesión puede haber recibido el mensaje.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = Se inició una conversación privada con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = Se inició una conversación cifrada pero no verificada con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = Actualizó con éxito la conversación cifrada con { $name }.

error-enc = Se produjo un error al cifrar el mensaje.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = Envió datos cifrados a { $name }, que no lo esperaba.

error-unreadable = Transmitió un mensaje cifrado ilegible.
error-malformed = Transmitió un mensaje de datos con formato incorrecto.

resent = [reenviado]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } terminó la conversación cifrada con usted; debería hacer lo mismo.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } solicitó una conversación cifrada fuera del registro (OTR). Sin embargo, no tiene un complemento para admitir eso. Consulte https://en.wikipedia.org/wiki/Off-the-Record_Messaging para obtener más información.
