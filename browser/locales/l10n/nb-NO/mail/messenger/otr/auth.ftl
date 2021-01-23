# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Bekreft kontaktens identitet
    .buttonlabelaccept = Bekreft

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Bekreft identiteten til { $name }

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Ditt fingeravtrykk, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Fingeravtrykk for { $their_name }:

auth-help = Bekrefting av en identiteten til en kontakt hjelper til med på å sikre at samtalen virkelig er privat, noe som gjør det veldig vanskelig for en tredjepart å avlytte eller manipulere samtalen.
auth-helpTitle = Bekreftelseshjelp

auth-questionReceived = Her er spørsmålene kontakten din stiller:

auth-yes =
    .label = Ja

auth-no =
    .label = Nei

auth-verified = Jeg har bekreftet at dette faktisk er det riktige fingeravtrykket.

auth-manualVerification = Manuell bekreftelse av fingeravtrykk
auth-questionAndAnswer = Spørsmål og svar
auth-sharedSecret = Delt hemmelighet

auth-manualVerification-label =
    .label = { auth-manualVerification }

auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }

auth-sharedSecret-label =
    .label = { auth-sharedSecret }

auth-manualInstruction = Kontakt din tiltenkte samtalepartner via en annen autentisert kanal, for eksempel OpenPGP-signert e-post eller over telefon. Du skal fortelle hverandre om fingeravtrykket deres. (Et fingeravtrykk er en kontrollsum som identifiserer en krypteringsnøkkel). Hvis fingeravtrykket stemmer overens, skal du nedenfor indikere at du har bekreftet fingeravtrykket.

auth-how = Hvordan vil du bekrefte identiteten til kontakten din?

auth-qaInstruction = Tenk på et spørsmål som kun du og kontaktpersonen din kjenner svaret på. Skriv inn spørsmålet og svaret, og vent deretter på at kontaktpersonen din skal angi svaret. Hvis svarene ikke stemmer, kan kommunikasjonskanalen du bruker være under overvåking.

auth-secretInstruction = Tenk på en hemmelighet som bare er kjent for deg og kontakten din. Ikke bruk den samme internettforbindelsen for å utveksle hemmeligheten. Skriv inn hemmeligheten, og vent deretter på at kontakten din skriver den inn. Hvis hemmelighetene ikke stemmer overens, kan kommunikasjonskanalen du bruker være under overvåking.

auth-question = Skriv inn et spørsmål:

auth-answer = Skriv inn svaret (skill mellom små og store bokstaver)

auth-secret = Skriv inn hemmeligheten:
