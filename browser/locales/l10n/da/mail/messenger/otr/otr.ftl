# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = Du forsøgte at sende en ukrypteret meddelelse til { $name }. Ukrypterede meddelelser ikke tilladt.

msgevent-encryption_required_part2 = Forsøger at starte en privat samtale. Din meddelelse sendes igen, når den private samtale starter.
msgevent-encryption_error = Der opstod en fejl under kryptering af din meddelelse. Meddelelsen blev ikke sendt.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = { $name } har allerede lukket sin krypterede forbindelse til dig. For at undgå, at du ved en fejl sender en meddelelse ukrypteret, er din meddelelse ikke blevet sendt. Afslut din krypterede samtale, eller genstart den.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = Der opstod en fejl under forsøget på at starte en privat samtale med { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = Du modtager dine egne OTR-meddelelser. Enten prøver du at tale med dig selv, eller også er der nogen, der sender dine meddelelser tilbage til dig.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = Den seneste meddelelse til { $name } blev sendt igen.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = Den krypterede meddelelse der blev modtaget fra { $name } kan ikke læses, da I i øjeblikket ikke kommunikerer privat.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = Du modtog en ulæselig krypteret meddelelse fra { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = Du har modtaget en ugyldig datameddelelse fra { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = Impuls modtaget fra { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = Impuls sendt til { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = Der opstod en uventet fejl under forsøget på at beskytte din samtale ved hjælp af OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = Følgende meddelelse modtaget fra { $name } var ikke krypteret: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = Du modtog en ukendt OTR-meddelelse fra { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = { $name } har sendt en meddelelse beregnet til en anden session. Hvis du er logget ind flere gange, kan en anden session have modtaget meddelelsen.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = Privat samtale med { $name } startet.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = Krypteret, men ikke-bekræftet samtale med { $name } startet.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = Opdaterede den krypterede samtale med { $name }.

error-enc = Der opstod en fejl under kryptering af meddelelsen.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = Du sendte krypterede data til { $name }, som ikke forventede det.

error-unreadable = Du sendte en ulæselig krypteret meddelelse.
error-malformed = Du sendte en ugyldig datameddelelse.

resent = [gensendt]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } har afsluttet sin krypterede samtale med dig; du bør gøre det samme.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } har anmodet om en Off the Record (OTR)-krypteret samtale. Du har dog ikke et plugin, der understøtter det. Se https://en.wikipedia.org/wiki/Off-the-Record_Messaging for yderligere oplysninger.
