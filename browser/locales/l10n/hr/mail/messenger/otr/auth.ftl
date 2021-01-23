# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Potvrdi identitet kontakta
    .buttonlabelaccept = Potvrdi

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Potvrdi identitet od { $name }

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Digitalni otisak za tebe, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Digitalni otisak za { $their_name }:

auth-help = Provjera identiteta kontakta pomaže kako biste bili sigurni da je razgovor stvarno privatan, i uvelike otežava trećim stranama prisluškivanje ili manipulaciju razgovora.
auth-helpTitle = Pomoć prilikom provjere

auth-questionReceived = Ovo je pitanje koje je postavio tvoj kontakt:

auth-yes =
    .label = Da

auth-no =
    .label = Ne

auth-verified = Provjerio sam da je ovo ispravan otisak prsta.

auth-manualVerification = Ručna provjera digitalnog otiska
auth-questionAndAnswer = Pitanje i odgovor
auth-sharedSecret = Dijeljena tajna

auth-manualVerification-label =
    .label = { auth-manualVerification }

auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }

auth-sharedSecret-label =
    .label = { auth-sharedSecret }

auth-manualInstruction = Kontaktirajte osobu s kojom želite voditi razgovor putem drugog komunikacijskog kanala kao što su OpenPGP potpisane poruke e-pošte ili preko telefona. Obavijestite jedan drugoga o svojim otiscima prstiju. (Otisak prstiju je kontrolni zbroj koji identificira ključ za kriptiranje.) Ukoliko otisak prsta odgovara trebate označiti u razgovoru da ste provjerili otisak prsta.

auth-how = Kako želite provjeriti identitet vašeg kontakta?

auth-qaInstruction = Zamislite pitanje na koje odgovor zna samo vaš kontakt. Unesite pitanje i odgovor, te sačekajte sugovornika da unese odgovor. Ukoliko se odgovori ne podudaraju, komunikacijski kanal je možda pod nadzorom.

auth-secretInstruction = Zamislite tajnu poznatu samo vama i vašem kontaktu. Nemojte koristiti istu Internet vezu za razmjenu tajne. Unesite tajnu i čekajte svoj kontakt da je isto unese. Ukoliko se tajne ne podudaraju, komunikacijski kanal je možda pod nadzorom.

auth-question = Upiši pitanje:

auth-answer = Upiši odgovor (pazi na velika/mala slova):

auth-secret = Upiši tajnu:
