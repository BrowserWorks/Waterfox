# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = Yritit lähettää salaamattoman viestin yhteyshenkilölle { $name }. Salaamattomat viestit eivät ole sallittuja.

msgevent-encryption_required_part2 = Yritetään aloittaa yksityinen keskustelu. Viestisi lähetetään uudelleen, kun yksityinen keskustelu alkaa.
msgevent-encryption_error = Viestisi salaamisessa tapahtui virhe. Viestiä ei lähetetty.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = { $name } on jo sulkenut salatun yhteyden sinulle. Viestiäsi ei lähetetty, jotta et lähettäisi viestiä vahingossa ilman salausta. Lopeta salattu keskustelu tai käynnistä se uudelleen.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = Avatessasi yksityistä keskustelua käyttäjän { $name } kanssa tapahtui virhe.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = Olet vastaanottamassa omia OTR-viestejäsi. Yrität joko puhua itsellesi tai joku peilaa viestejäsi takaisin sinulle.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = Viimeisin viesti yhteyshenkilölle { $name } lähetettiin uudelleen.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = Lähettäjältä { $name } vastaanotettu salattu viesti ei ole luettavissa, koska et ole tällä hetkellä yhteydessä yksityisesti.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = Sait lukukelvottoman salatun viestin yhteyshenkilöltä { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = Sait väärän muotoisen dataviestin yhteyshenkilöltä { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = Syke vastaanotettiin yhteyshenkilöltä { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = Syke lähetetty yhteyshenkilölle { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = Yritettäessä suojata keskusteluasi OTR:llä tapahtui odottamaton virhe.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = Seuraavaa yhteyshenkilöltä { $name } vastaanotettua viestiä ei salattu: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = Sait tuntemattoman OTR-viestin yhteyshenkilöltä { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = { $name } on lähettänyt viestin, joka on tarkoitettu toiseen istuntoon. Jos olet kirjautunut sisään useita kertoja, toinen istunto on saattanut vastaanottaa viestin.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = Yksityinen keskustelu yhteyshenkilön { $name } kanssa alkoi.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = Salattu, mutta varmistamaton keskustelu yhteyshenkilön { $name } kanssa alkoi.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = Salattu keskustelu yhteyshenkilön { $name } kanssa päivitettiin.

error-enc = Viestin salaamisessa tapahtui virhe.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = Lähetit salatut tiedot yhteyshenkilölle { $name }, joka ei odottanut niitä.

error-unreadable = Lähetit lukukelvottoman salatun viestin.
error-malformed = Lähetit väärän muotoisen dataviestin.

resent = [uudelleen lähetetty]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } on lopettanut salatun keskustelun kanssasi; sinun pitäisi tehdä samoin.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } on pyytänyt OTR-salattua keskustelua. Sinulla ei kuitenkaan ole sitä tukevaa laajennusta. Katso lisätietoja osoitteesta https://fi.wikipedia.org/wiki/OTR.
