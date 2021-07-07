# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = Ha intentado enviar un mensaje no cifrado a { $name }. Por directiva, no se permiten los mensajes no cifrados.

msgevent-encryption_required_part2 = Intentando iniciar una conversación privada. Su mensaje se reenviará cuand comience la conversación privada.
msgevent-encryption_error = Ha sucedido un error al cifrar su mensaje. El mensaje no se ha enviado.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = { $name } ya ha cerrado su conexión cifrada hacia usted. Para evitar que envíe un mensaje sin cifrar accidentalmente, no se ha enviado su mensaje. Termine su conversación cifrada o reiníciela.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = Ha sucedido un error al configurar una conversación privada con { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = Está recibiendo sus propios mensajes OTR. O está intentando hablar con usted mismo, o alguiene está reflejando sus mensajes de vuelta a usted.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = Se ha reenviado el último mensaje a { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = El mensaje cifrado recibido desde { $name } no es legible, ya que en este momento no se está comunicando de forma privada.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = Ha recibido un mensaje cifrado no legible de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = Ha recibido un mensaje con datos mal formados de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = Latido recibido de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = Latido enviado a { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = Ha ocurrido un error inesperado al intentar proteger su conversación usando OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = El siguiente mensaje recibido de { $name } no estaba cifrado: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = Ha recibido un mensaje OTR no reconocido de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = { $name } ha enviado un mensaje destinado a otra sesión diferente. Si ha iniciado sesión múltiples veces, otra sesión puede haber recibido el mensaje.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = Iniciada conversación privada con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = Iniciada conversación cifrada, pero no verificada, con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = Refrescada con éxito la conversación cifrada con { $name }.

error-enc = Ha sucedido un error al cifrar el mensaje.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = Ha enviado datos cifrados a { $name }, quien no lo esperaba.

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
