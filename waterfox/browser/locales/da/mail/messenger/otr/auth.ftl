# This Source Code Form is subject to the terms of the Waterfox Public
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

auth-help-title = Hjælp til bekræftelse

auth-question-received = Her er det spørgsmål, som din kontakt stiller:

auth-yes =
    .label = Ja

auth-no =
    .label = Nej

auth-verified = Jeg har bekræftet, at dette er det rigtige fingeraftryk.

auth-manual-verification = Manuel bekræftelse af fingeraftryk
auth-question-and-answer = Spørgsmål og svar
auth-shared-secret = Delt hemmelighed

auth-manual-verification-label =
    .label = { auth-manual-verification }

auth-question-and-answer-label =
    .label = { auth-question-and-answer }

auth-shared-secret-label =
    .label = { auth-shared-secret }

auth-manual-instruction = Kontakt din påtænkte samtalepartner via en anden godkendt kanal, fx en OpenPGP-underskrevet mail eller over telefonen. Du skal fortælle hinanden jeres fingeraftryk (et fingeraftryk er en kontrolsum, der identificerer en krypteringsnøgle). Hvis fingeraftrykket stemmer overens, skal du markere herunder, at du har verificeret fingeraftrykket.

auth-how = Hvordan vil du bekræfte din kontakts identitet?

auth-qa-instruction = Tænk på et spørgsmål, som kun dig og din kontakt kender svaret på. Indtast spørgsmålet og svaret, og vent derefter på, at din kontakt indtaster svaret. Hvis svarene ikke stemmer overens, kan den kommunikationskanal, du bruger, være overvåget.

auth-secret-instruction = Tænk på en hemmelighed, kun du og din kontakt kender til. Brug ikke den samme internetforbindelse til at udveksle hemmeligheden. Indtast hemmeligheden, og vent derefter på din kontakt indtaster den. Hvis hemmelighederne ikke stemmer overens, kan den kommunikationskanal, du bruger, være overvåget.

auth-question = Indtast en spørgsmål:

auth-answer = Indtast svaret (forskel på store og små bogstaver):

auth-secret = Indtast hemmeligheden:
