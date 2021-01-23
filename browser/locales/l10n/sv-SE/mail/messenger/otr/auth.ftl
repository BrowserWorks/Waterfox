# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Verifiera kontaktens identitet
    .buttonlabelaccept = Verifiera

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Verifiera identiteten för { $name }

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Ditt fingeravtryck, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Fingeravtryck för { $their_name }:

auth-help = Verifiering av en kontakts identitet hjälper till att säkerställa att konversationen verkligen är privat, vilket gör det mycket svårt för en tredje part att tjuvlyssna eller manipulera konversationen.
auth-helpTitle = Verifieringshjälp

auth-questionReceived = Detta är frågan som din kontakt ställer:

auth-yes =
    .label = Ja

auth-no =
    .label = Nej

auth-verified = Jag har verifierat att detta i själva verket är det rätta fingeravtrycket.

auth-manualVerification = Manuell verifiering av fingeravtryck
auth-questionAndAnswer = Fråga och svar
auth-sharedSecret = Delad hemlighet

auth-manualVerification-label =
    .label = { auth-manualVerification }

auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }

auth-sharedSecret-label =
    .label = { auth-sharedSecret }

auth-manualInstruction = Kontakta din avsedda samtalspartner via någon annan autentiserad kanal, till exempel OpenPGP-signerad e-post eller via telefon. Du ska berätta för varandra om dina fingeravtryck. (Ett fingeravtryck är ett kontrollsumma som identifierar en krypteringsnyckel.) Om fingeravtrycket matchar ska du ange i dialogrutan nedan att du har verifierat fingeravtrycket.

auth-how = Hur vill du verifiera din kontakts identitet?

auth-qaInstruction = Tänk på en fråga som svaret bara är känt för dig och din kontakt. Ange frågan och svaret, vänta sedan på att din kontakt anger svaret. Om svaren inte stämmer överens kan kommunikationskanalen du använder övervakas.

auth-secretInstruction = Tänk på en hemlighet som endast är känd för dig och din kontakt. Använd inte samma internetanslutning för att utbyta hemligheten. Ange hemligheten och vänta sedan på att din kontakt ska ange den. Om hemligheterna inte matchar kan kommunikationskanalen du använder övervakas.

auth-question = Ange en fråga:

auth-answer = Ange svaret (skiftlägeskänslig):

auth-secret = Ange hemligheten:
