# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = Tu ha tentate inviar un non message non cryptate a { $name }. Como regulamento, le messages non cryptate non es consentite.

msgevent-encryption_required_part2 = Tentativa pro initiar un conversation private. Tu message sera reinviate quando le conversation private initia.
msgevent-encryption_error = Un error occurreva cryptante tu message. Message non inviate.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = { $name } ha jam claudite su connexion cryptate pro te. Pro evitar que tu accidentalmente invia un message non cryptate, tu message non ha essite inviate. Claude tu conversation cryptate, o reinitia lo.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = Un error occurreva durante le preparation de un conversation private con { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = Tu recipe tu proprie messages OTR. Tu tenta parlar a te mesme o qualcuno reflecte tu messages retro a te.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = Le ultime message a { $name } ha essite reinviate.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = Le message cryptate recipite de { $name } es illegibile, pois que tu non communica actualmente reservatemente.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = Tu ha recipite un message cryptate illegibile de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = Tu ha recipite un message de datos malformate de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = Pulsation del corde recipite de { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = Pulsation del corde inviate a { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = Un error impreviste occurreva durante le tentativa pro proteger tu conversation per le OTR

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = Le sequente message recipite de { $name } non era cryptate: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = Tu ha recipite un message OTR incognite de { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = { $name } ha inviate un message desirate pro un differente session. Si tu es connexe plure vices, un altere session pote haber recipite le message.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = Initiate conversation private con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = Initiate conversation cryptate, ma non verificate, con { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = Conversation cryptate con { $name } reinitiate con successo.

error-enc = Un error occurreva durante que on cryptava le message.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = Tu inviava a { $name } datos cryptate que ille non attendeva.

error-unreadable = Tu transmitteva un message cryptate non legibile.
error-malformed = Tu transmitteva un message de datos malformate.

resent = [reinviate]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } ha terminate su conversation cryptate con te; tu debe facer le mesmo.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } ha requirite un conversation cryptate Off-the-Record (OTR). Totevia, tu non ha un plugin pro lo supportar. Vider https://en.wikipedia.org/wiki/Off-the-Record_Messaging pro altere informationes.
