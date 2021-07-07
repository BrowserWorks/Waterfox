# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = Tentou enviar uma mensagem não encriptada para { $name }. Como política, não são permitidas mensagens não encriptadas.

msgevent-encryption_required_part2 = Tentativa de iniciar uma conversa privada. A sua mensagem será reenviada quando a conversa privada for iniciada.
msgevent-encryption_error = Ocorreu um erro ao encriptar a sua mensagem. A mensagem não foi enviada.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = { $name } já fechou a ligação encriptada que tinha consigo. Para evitar o envio acidental de uma mensagem sem encriptação, a sua mensagem não foi enviada. Encerre a sua conversa encriptada ou reinicie a mesma.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = Ocorreu um erro ao configurar uma conversa privada com { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = Está a receber as suas próprias mensagens OTR. Está a tentar falar sozinho ou alguém está a repetir as suas mensagens para si.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = A última mensagem para { $name } foi reenviada.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = A mensagem encriptada recebida de { $name } é ilegível pois, neste momento, você não está a comunicar de modo privado.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = Recebeu uma mensagem encriptada ilegível de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = Recebeu uma mensagem de dados mal codificada de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = Pulsação recebida de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = Pulsação enviada para { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = Ocorreu um erro inesperado ao tentar proteger a sua conversa utilizando o OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = A seguinte mensagem, recebida de { $name }, não foi encriptada: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = Recebeu uma mensagem OTR irreconhecível de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = { $name } enviou uma mensagem destinada a uma sessão diferente. Se tiver iniciado sessão várias vezes, a mensagem pode ter sido recebida noutra sessão.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = A conversa privada com { $name } foi iniciada.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = A conversa privada, mas não confirmada, com { $name } foi iniciada.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = Renovou com sucesso a conversa encriptada com { $name }.

error-enc = Ocorreu um erro ao encriptar a mensagem.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = Enviou dados encriptados para { $name }, que não estava à esperava dos mesmos.

error-unreadable = Transmitiu uma mensagem encriptada ilegível.
error-malformed = Transmitiu uma mensagem de dados mal codificada.

resent = [reenviar]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } terminou a conversa encriptada consigo; você deve fazer o mesmo.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } solicitou uma conversa encriptada Off-the-Record (OTR). No entanto, você não tem um plugin que suporte isto. Consulte https://en.wikipedia.org/wiki/Off-the-Record_Messaging para obter mais informações.
