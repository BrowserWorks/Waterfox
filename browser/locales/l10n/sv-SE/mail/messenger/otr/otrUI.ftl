# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

start-label = Starta en krypterad konversation
refresh-label = Uppdatera den krypterade konversationen
auth-label = Verifiera din kontakts identitet
reauth-label = Bekräfta din kontakts identitet igen

auth-cancel = Avbryt
auth-cancel-access-key = A

auth-error = Ett fel inträffade när du verifierade identiteten på din kontakt.
auth-success = Verifiering av din kontakts identitet har slutförts.
auth-success-them = Din kontakt har verifierat din identitet. Du kanske också vill verifiera deras identitet genom att ställa din egna fråga.
auth-fail = Det gick inte att verifiera identiteten på din kontakt.
auth-waiting = Väntar på att kontakten ska slutföra verifieringen…

finger-verify = Verifiera
finger-verify-access-key = V

# Do not translate 'OTR' (name of an encryption protocol)
buddycontextmenu-label = Lägg till OTR-fingeravtryck

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-start = Försöker starta en krypterad konversation med { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-refresh = Försöker uppdatera den krypterade konversationen med { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-gone-insecure = Den krypterade konversationen med { $name } avslutades.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-unseen = Identiteten för { $name } har inte verifierats än. Tillfällig avlyssning är inte möjlig, men med viss ansträngning kan någon avlyssna. Förhindra övervakning genom att verifiera kontaktens identitet.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-seen = { $name } kontaktar dig från en okänd dator. Tillfällig avlyssning är inte möjlig, men med viss ansträngning kan någon avlyssna. Förhindra övervakning genom att verifiera kontaktens identitet.

state-not-private = Den aktuella konversationen är inte privat.

state-generic-not-private = Den aktuella konversationen är inte privat.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-unverified = Den aktuella konversationen är krypterad men inte privat eftersom identiteten { $name } ännu inte har verifierats.

state-generic-unverified = Den aktuella konversationen är krypterad men inte privat, eftersom vissa identiteter ännu inte har verifierats.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-private = Identiteten för { $name } har verifierats. Den aktuella konversationen är krypterad och privat.

state-generic-private = Den aktuella konversationen är krypterad och privat.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-finished = { $name } har avslutat sin krypterade konversation med dig; du borde göra samma sak.

state-not-private-label = Osäker
state-unverified-label = Overifierad
state-private-label = Privat
state-finished-label = Slutförd

# Variables:
#   $name (String) - the screen name of a chat contact person
verify-request = { $name } begärde verifiering av din identitet.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-private = Du har verifierat identiteten på { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-unverified = Identiteten för { $name } har inte verifierats.

verify-title = Verifiera din kontakts identitet
error-title = Fel
success-title = End-to-end kryptering
success-them-title = Verifiera din kontakts identitet
fail-title = Det går inte att verifiera
waiting-title = Verifieringsbegäran har skickats

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $error (String) - contains an error message that describes the cause of the failure
otr-genkey-failed = Generering av OTR-privatnyckel misslyckades: { $error }
