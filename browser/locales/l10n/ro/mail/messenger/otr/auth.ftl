# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Verifică identitatea contactului
    .buttonlabelaccept = Verifică
# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Verifică identitatea lui { $name }
# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Amprentă digitală pentru tine, { $own_name }:
# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Amprentă digitală pentru { $their_name }
auth-help = Verificarea identității unui contact ajută la asigurarea confidențialității reale a conversațiilor, ceea ce face foarte dificilă interceptarea sau manipularea conversațiilor de către un terț.
auth-helpTitle = Ajutor de verificare
auth-questionReceived = Aceasta este întrebarea pusă de contact:
auth-yes =
    .label = Da
auth-no =
    .label = Nu
auth-verified = Am verificat că aceasta este de fapt amprenta corectă.
auth-manualVerification = Verificare manuală a amprentelor
auth-questionAndAnswer = Întrebare și răspuns
auth-sharedSecret = Secret partajat
auth-manualVerification-label =
    .label = { auth-manualVerification }
auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }
auth-sharedSecret-label =
    .label = { auth-sharedSecret }
auth-manualInstruction = Contactează partenerul de conversație intenționat prin intermediul unui alt canal autentificat, cum ar fi un e-mail semnat OpenPGP sau prin telefon. Ar trebui să vă spuneți reciproc amprentele. (Amprenta este o sumă de control care identifică o cheie de criptare.) Dacă amprenta este potrivită, ar trebui să indici în dialogul de mai jos că ai verificat amprenta.
auth-how = Cum ai vrea să verifici identitatea contactului tău?
auth-qaInstruction = Gândește-te la o întrebare la care numai tu și contactului tău știți răspunsul. Introdu întrebarea și răspunde, apoi așteaptă să introducă și contactul tău răspunsul. Dacă răspunsurile nu corespund, canalul de comunicare pe care îl utilizezi poate fi supravegheat.
auth-secretInstruction = Gândește-te la un secret cunoscut numai de tine și contactul tău. Nu folosiți aceeași conexiune la Internet pentru a schimba secretul între voi. Introdu secretul, apoi așteaptă să îl introducă și contactul tău. Dacă secretele nu se potrivesc, canalul de comunicare pe care îl utilizați poate fi supravegheat.
auth-question = Introdu o întrebare:
auth-answer = Introdu răspunsul (sensibil la litere mari și mici):
auth-secret = Introdu secretul:
