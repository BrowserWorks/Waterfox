# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = Ai încercat să trimiți un mesaj necriptat către { $name }. Mesajele necriptate nu sunt permise prin politică.

msgevent-encryption_required_part2 = Se încearcă începerea unei conversații private. Mesajul tău va fi trimis din nou la începerea conversației private.
msgevent-encryption_error = A apărut o eroare la criptarea mesajului. Mesajul nu a fost trimis.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = { $name } a închis deja conexiunea criptată cutine. Pentru a evita să trimiți accidental un mesaj fără criptare, mesajul tău nu a fost trimis. Te rugăm să închei conversația criptată sau să o repornești.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = A apărut o eroare la configurarea unei conversații private cu { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = Primești propriile mesaje OTR. Fie încerci să vorbești cu tine, fie cineva îți trimite înapoi mesajele.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = Ultimul mesaj către { $name } a fost retrimis.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = Mesajul criptat primit de la { $name } nu poate fi citit, deoarece nu comunicați în privat acum.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = Ai primit un mesaj criptat ilizibil de la { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = Ai primit un mesaj cu date într-un format necorespunzător de la { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = Mesaj Heartbeat primit de la { $nume }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = Heartbeat trimis către { $nume }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = A apărut o eroare neașteptată la încercarea de protejare a conversației prin OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = Următorul mesaj primit de la { $nume } nu a fost criptat: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = Ai primit un mesaj OTR nerecunoscut de la { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = { $name } a trimis un mesaj destinat unei sesiuni diferite. Dacă ești autentificat de mai multe ori, este posibil să fi primit mesajul în altă sesiune.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = A început conversația privată cu { $nume }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = A început conversația criptată, dar neverificată, cu { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = Conversația criptată cu { $name } a fost reîmprospătată cu succes.

error-enc = A apărut o eroare la criptarea mesajului.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = Ai trimis date criptate către { $name }, care nu se aștepta să le primească.

error-unreadable = Ai transmis un mesaj criptat ilizibil.
error-malformed = Ai transmis un mesaj de date de format necorespunzător.

resent = [retransmis]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } a încheiat conversația criptată cu tine; ar trebui să faci la fel.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } a solicitat o conversație criptată neînregistrată (OTR). Însă nu ai un plugin pentru a putea avea una. Intră pe https://en.wikipedia.org/wiki/Off-the-Record_Messaging pentru mai multe informații.
