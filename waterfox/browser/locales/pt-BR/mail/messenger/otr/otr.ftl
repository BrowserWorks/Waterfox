# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption-required-part1 = Você tentou enviar uma mensagem não criptografada para { $name }. Como diretiva, não são permitidas mensagens não criptografadas.

msgevent-encryption-required-part2 = Tentativa de iniciar uma conversa privativa. Sua mensagem será reenviada quando a conversa privativa for iniciada.
msgevent-encryption-error = Ocorreu um erro ao criptografar sua mensagem. A mensagem não foi enviada.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection-ended = { $name } já fechou a conexão criptografada com você. Para evitar que você envie acidentalmente uma mensagem sem criptografia, sua mensagem não foi enviada. Encerre a conversa criptografada ou a reinicie.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup-error = Ocorreu um erro ao preparar uma conversa privativa com { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg-reflected = Você está recebendo suas próprias mensagens OTR. Ou você está tentando conversar consigo mesmo, ou alguém está refletindo suas mensagens de volta para você.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg-resent = A última mensagem para { $name } foi reenviada.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-not-private = A mensagem criptografada recebida de { $name } é ilegível, pois você não está em uma comunicação privativa no momento.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unreadable = Você recebeu uma mensagem criptografada ilegível de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-malformed = Você recebeu uma mensagem de dados malformada de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-rcvd = Pulsação recebida de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-sent = Pulsação enviada para { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg-general-err = Ocorreu um erro inesperado ao tentar proteger sua conversa usando OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg-unencrypted = A seguinte mensagem recebida de { $name } não foi criptografada: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unrecognized = Você recebeu uma mensagem OTR não reconhecida de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-for-other-instance = { $name } enviou uma mensagem destinada a outra sessão. Se você tiver conectado várias vezes, outra sessão pode ter recebido a mensagem.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-private = Começou a conversa privativa com { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-unverified = Começou a conversa criptografada, mas não verificada, com { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still-secure = A conversa criptografada com { $name } foi restaurada com sucesso.

error-enc = Ocorreu um erro ao criptografar a mensagem.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not-priv = Você enviou dados criptografados para { $name }, que não estava esperando por isso.

error-unreadable = Você transmitiu uma mensagem criptografada ilegível.
error-malformed = Você transmitiu uma mensagem de dados malformada.

resent = [reenviar]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } encerrou a conversa criptografada. Você deve fazer o mesmo.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } solicitou uma conversa criptografada sem registro (OTR). No entanto, você não tem um plugin para suportar isso. Consulte mais informações em https://pt.wikipedia.org/wiki/Off-the-Record_Messaging.
