# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption-required-part1 = Intentaste enviar un mensaje sin cifrar a { $name }. Como política, los mensajes sin cifrar no están permitidos.

msgevent-encryption-required-part2 = Intentaste iniciar una conversación privada. Tu mensaje se enviará cuando se inicie la conversación privada.
msgevent-encryption-error = Ocurrió un error al cifrar tu mensaje. El mensaje no fue enviado.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection-ended = { $name } ya cerró la conexión cifrada contigo. Para evitar que envíes accidentalmente un mensaje sin cifrado, no se ha enviado tu mensaje. Por favor, finaliza tu conversación cifrada o reinicia.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup-error = Ocurrió un error al configurar una conversación privada con { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg-reflected = Estás recibiendo tus propios mensajes OTR. O estás intentando hablar contigo mismo, o alguien te está reflejando tus mensajes.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg-resent = Se reenvió el último mensaje a { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-not-private = El mensaje cifrado recibido de { $name } no puede ser leído, ya que actualmente no se está comunicando de forma privada.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unreadable = Recibiste un mensaje cifrado no legible de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-malformed = Recibiste un mensaje de datos con formato incorrecto de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-rcvd = Latido recibido de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-sent = Latido enviado a { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg-general-err = Ocurrió un error inesperado mientras se intentaba proteger tu conversación usando OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg-unencrypted = El siguiente mensaje recibido de { $name } no fue cifrado: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unrecognized = Recibiste un mensaje OTR no reconocido de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-for-other-instance = { $name } ha enviado un mensaje destinado a una sesión diferente. Si has iniciado sesión varias veces, es posible que otra sesión haya recibido el mensaje.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-private = Se inició una conversación privada con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-unverified = Se inició una conversación cifrada, pero no verificada con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still-secure = Se ha actualizado correctamente la conversación cifrada con { $name }.

error-enc = Ocurrió un error al cifrar el mensaje.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not-priv = Enviaste datos cifrado a { $name }, que no los esperaba.

error-unreadable = Has transmitido un mensaje  cifrado no legible.
error-malformed = Has transmitido un mensaje de datos con formato incorrecto.

resent = [reenviado]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } ha terminado su conversación cifrada contigo; deberías hacer lo mismo.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } ha solicitado una conversación cifrada fuera del registro (OTR). Sin embargo, no tienes un plugin que lo admita. Para más información, consulta https://en.wikipedia.org/wiki/Off-the-Record_Messaging
