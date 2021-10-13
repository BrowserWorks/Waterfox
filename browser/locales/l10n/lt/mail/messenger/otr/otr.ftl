# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption-required-part1 = Bandėte nusiųsti nešifruotą pranešimą „{ $name }“. Pagal nustatytą politiką, nešifruoti pranešimai neleidžiami.

msgevent-encryption-required-part2 = Bandoma pradėti privatų pokalbį. Jūsų pranešimas bus pakartotas, kai pokalbis prasidės.
msgevent-encryption-error = Šifruojant jūsų pranešimą įvyko klaida. Jis nebuvo išsiųstas.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection-ended = „{ $name }“ jau uždarė užšifruotą ryšį su jumis. Kad atsitiktinai neišsiųstumėte nešifruoto pranešimo, jūsų pranešimas neišsiųstas. Užbaikite užšifruotą pokalbį arba pradėkite jį iš naujo.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup-error = Pradedant privatų pokalbį su „{ $name }“ įvyko klaida.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg-reflected = Gaunate savo OTR pranešimus. Jūs arba bandote pasikalbėti su savimi, arba kažkas gražina jūsų pranešimus.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg-resent = Pakartotas paskutinis „{ $name }“ skirtas pranešimas.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-not-private = Iš „{ $name }“ gautas užšifruotas pranešimas yra neįskaitomas, nes šiuo metu jūs nenaudojate pranešimų šifravimo.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unreadable = Iš „{ $name }“ gavote neįskaitomą šifruotą pranešimą.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-malformed = Iš „{ $name }“ gavote netinkamai suformuotą pranešimą.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-rcvd = Gautas ryšio palaikymo paketas iš „{ $name }“.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-sent = „{ $name }“ išsiųstas ryšio palaikymo paketas.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg-general-err = Bandant apsaugoti jūsų užšifruotą neįrašomą pokalbį (OTR), įvyko netikėta klaida.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg-unencrypted = Pranešimas, gautas iš „{ $name }“, nebuvo užšifruotas: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unrecognized = Gavote neatpažintą OTR pranešimą iš „{ $name }“.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-for-other-instance = „{ $name }“ atsiuntė pranešimą, skirtą kitai sesijai. Jei esate prisijungę kelis kartus, pranešimą galėjo gauti kita ryšio sesija.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-private = Pradėtas privatus pokalbis su „{ $name }“.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-unverified = Pradėtas šifruotas, bet nepatvirtintas pokalbis su „{ $name }“.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still-secure = Užšifruotas pokalbi su „{ $name }“ atnaujintas .

error-enc = Šifruojant pranešimą įvyko klaida.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not-priv = Išsiuntėte šifruotus duomenis „{ $name }“, kuris to nesitikėjo.

error-unreadable = Jūs perdavėte neįskaitomą užšifruotą pranešimą.
error-malformed = Jūs perdavėte netinkamai suformuotą pranešimą.

resent = [pakartoti]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = „{ $name }“ baigė užšifruotą pokalbį su jumis; turėtumėt užbaigti ir jūs.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = „{ $name }“ paprašė užšifruoto neįrašomo pokalbio (OTR). Tačiau jūs neturite papildinio, kuris tai palaikytų. Norėdami gauti daugiau informacijos, apsilankykite https://en.wikipedia.org/wiki/Off-the-Record_Messaging.
