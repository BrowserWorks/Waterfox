# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = U përpoqët të dërgoni një mesazh të pafshehtëzuar për { $name }. Si rregull, mesazhet e pafshehtëzuar nuk lejohen.

msgevent-encryption_required_part2 = Po provohet të niset një bisedë private. Mesazhi juaj do të ridërgohet kur të nisë biseda private.
msgevent-encryption_error = Ndodhi një gabim kur fshehtëzohej mesazhi juaj. Mesazhi s’u dërgua.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = { $name } e ka mbyllur tashmë lidhjen e fshehtëzuar me ju. Për të shmangur dërgimin aksidental nga ana juaj të një mesazhi pa fshehtëzim, mesazhi juaj s’u dërgua. Ju lutemi, përfundoni bisedën tuaj të fshehtëzuar, ose riniseni.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = Ndodhi një gabim teksa ujdisej një bisedë private me { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = Po merrni mesazhet tuaja OTR. Ose po rrekeni të bisedoni me veten, ose dikush është duke i pasqyruar mesazhet tuaja mbrapsht te ju.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = Mesazhi i fundit për { $name } u ridërgua.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = Mesazhi i fshehtëzuar i marrë prej { $name } është i palexueshëm, ngaqë hëpërhë s’po komunikoni në mënyrë private.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = Morët një mesazh të fshehtëzuar të palexueshëm nga { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = Morët nga { $name } një mesazh me të dhëna të keqformuara.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = Nga { $name } u mor Heartbeat.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = Për { $name }u dërgua Heartbeat.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = Ndodhi një gabim i papritur teksa provohej të mbrohej biseda juaj duke përdorur OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = Mesazhi vijues i marrë prej { $name } s’qe fshehtëzuar: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = Morët nga { $name } një mesazh OTR të panjohur.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = { $name } ka dërguar një mesazh të menduar për një sesion tjetër. Nëse keni bërë hyrjen një numër herësh, mesazhin mund ta ketë marrë një sesion tjetër.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = Nisi bisedë private me { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = Nisi bisedë private me { $name }, e fshehtëzuar, por e paverifikuar.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = U rifreskua me sukses biseda e fshehtëzuar me { $name }.

error-enc = Ndodhi një gabim teksa fshehtëzohej mesazhi.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = Dërguat të dhëna të fshehtëzuara te { $name }, që nuk priste të tilla.

error-unreadable = Transmetuat një mesazh të fshehtëzuar të palexueshëm.
error-malformed = Transmetuat një mesazh me të dhëna të keqformuara.

resent = [ridërguar]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name }e ka përfunduar bisedën e fshehtëzuar me ju; po këtë duhet të bëni edhe ju.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } ka kërkuar një bisedë të fshehtëzuar, Off-the-Record (OTR). Por ju s’keni një shtojcë që ta mbulojë këtë. Për më tepër të dhëna, shihni te https://en.wikipedia.org/wiki/Off-the-Record_Messaging.
