# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Bekræft kontakts identitet
    .buttonlabelaccept = Bekræft

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Bekræft { $name }s identitet

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Fingeraftryk for dig, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Fingeraftryk for { $their_name }

auth-help = Når du bekræfter en kontakts identitet, hjælper du med at sikre, at samtalen virkelig er privat, hvilket gør det meget vanskeligt for en tredjepart at lytte med på eller manipulere samtalen.
auth-helpTitle = Hjælp til bekræftelse

auth-questionReceived = Her er det spørgsmål, som din kontakt stiller:

auth-yes =
    .label = Ja

auth-no =
    .label = Nej

auth-verified = Jeg har bekræftet, at dette er det rigtige fingeraftryk.

auth-manualVerification = Manuel bekræftelse af fingeraftryk
auth-questionAndAnswer = Spørgsmål og svar
auth-sharedSecret = Delt hemmelighed

auth-manualVerification-label =
    .label = { auth-manualVerification }

auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }

auth-sharedSecret-label =
    .label = { auth-sharedSecret }

auth-manualInstruction = Kontakt din påtænkte samtalepartner via en anden godkendt kanal, fx en OpenPGP-underskrevet mail eller over telefonen. Du skal fortælle hinanden jeres fingeraftryk (et fingeraftryk er en kontrolsum, der identificerer en krypteringsnøgle). Hvis fingeraftrykket stemmer overens, skal du markere herunder, at du har verificeret fingeraftrykket.

auth-how = Hvordan vil du bekræfte din kontakts identitet?

auth-qaInstruction = Tænk på et spørgsmål, som kun dig og din kontakt kender svaret på. Indtast spørgsmålet og svaret, og vent derefter på, at din kontakt indtaster svaret. Hvis svarene ikke stemmer overens, kan den kommunikationskanal, du bruger, være overvåget.

auth-secretInstruction = Tænk på en hemmelighed, kun du og din kontakt kender til. Brug ikke den samme internetforbindelse til at udveksle hemmeligheden. Indtast hemmeligheden, og vent derefter på din kontakt indtaster den. Hvis hemmelighederne ikke stemmer overens, kan den kommunikationskanal, du bruger, være overvåget.

auth-question = Indtast en spørgsmål:

auth-answer = Indtast svaret (forskel på store og små bogstaver):

auth-secret = Indtast hemmeligheden:
