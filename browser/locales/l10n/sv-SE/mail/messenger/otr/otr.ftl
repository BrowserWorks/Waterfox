# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = Du försökte skicka ett okrypterat meddelande till { $name }. Som en policy är okrypterade meddelanden inte tillåtna.

msgevent-encryption_required_part2 = Försök att starta en privat konversation. Ditt meddelande kommer att skickas igen när den privata konversationen startar.
msgevent-encryption_error = Ett fel inträffade vid kryptering av ditt meddelande. Meddelandet skickades inte.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = { $name } har redan stängt sin krypterade anslutning till dig. För att undvika att du av misstag skickar ett meddelande utan kryptering, skickades inte ditt meddelande. Avsluta din krypterade konversation eller starta om den.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = Ett fel inträffade vid inställningen av en privat konversation med { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = Du får dina egna OTR-meddelanden. Du försöker antingen prata med dig själv, eller så reflekterar någon dina meddelanden tillbaka på dig.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = Det sista meddelandet till { $name } skickades på nytt.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = Det krypterade meddelandet som mottas från { $name } är oläsbart eftersom du för närvarande inte kommunicerar privat.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = Du fick ett oläsbart krypterat meddelande från { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = Du fick ett felformat datameddelande från { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = Heartbeat mottagen från { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = Heartbeat skickad till { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = Ett oväntat fel inträffade när du försökte skydda din konversation med OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = Följande meddelande från { $name } krypterades inte: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = Du fick ett okänt OTR-meddelande från { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = { $name } har skickat ett meddelande som är avsett för en annan session. Om du är inloggad flera gånger kan en annan session ha fått meddelandet.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = Privat konversation med { $name } startad.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = Krypterad, men overifierad konversation med { $name } startad.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = Uppdaterade den krypterade konversationen med { $name }.

error-enc = Ett fel inträffade vid kryptering av meddelandet.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = Du skickade krypterad data till { $name }, som inte förväntade sig den.

error-unreadable = Du skickade ett oläsbart krypterat meddelande.
error-malformed = Du skickade ett felformat datameddelande.

resent = [skicka igen]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } har avslutat sin krypterade konversation med dig; du borde göra samma sak.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } har begärt en Off-the-Record-krypterad konversation (OTR). Du har dock inte en insticksmodul som stöder det. Se https://en.wikipedia.org/wiki/Off-the-Record_Messaging för mer information.
