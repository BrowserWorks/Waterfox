# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Zweryfikuj tożsamość kontaktu
    .buttonlabelaccept = Zweryfikuj

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Zweryfikuj tożsamość użytkownika { $name }

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Własny odcisk klucza ({ $own_name }):

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Odcisk klucza użytkownika { $their_name }:

auth-help = Weryfikacja tożsamości kontaktu pomaga zapewnić, że rozmowa jest rzeczywiście prywatna, znacznie utrudniając osobie trzeciej podsłuchiwanie lub manipulowanie rozmową.

auth-help-title = Pomoc przy weryfikacji

auth-question-received = Pytanie zadane przez kontakt:

auth-yes =
    .label = Tak

auth-no =
    .label = Nie

auth-verified = Potwierdzam, że to jest właściwy odcisk klucza.

auth-manual-verification = Ręczna weryfikacja odcisku klucza
auth-question-and-answer = Pytanie i odpowiedź
auth-shared-secret = Wspólny sekret

auth-manual-verification-label =
    .label = { auth-manual-verification }

auth-question-and-answer-label =
    .label = { auth-question-and-answer }

auth-shared-secret-label =
    .label = { auth-shared-secret }

auth-manual-instruction = Skontaktuj się z wybranym rozmówcą za pośrednictwem innego uwierzytelnionego środka komunikacji, takiego jak wiadomość e-mail podpisana za pomocą OpenPGP lub przez telefon. Musicie przekazać sobie swoje odciski kluczy (odcisk to suma kontrolna identyfikująca klucz szyfrowania). Jeśli się zgadzają, wskaż w oknie poniżej, że potwierdzono odcisk klucza.

auth-how = Jak chcesz zweryfikować tożsamość kontaktu?

auth-qa-instruction = Wymyśl pytanie, na które odpowiedź jest znana tylko Tobie i kontaktowi. Wpisz pytanie i odpowiedź, a następnie poczekaj, aż kontakt poda odpowiedź. Jeśli odpowiedzi się nie zgadzają, to używany środek komunikacji może być inwigilowany.

auth-secret-instruction = Wymyśl sekret znany tylko Tobie i kontaktowi. Nie używaj tego samego połączenia z Internetem do wymiany sekretu. Wpisz sekret, a następnie poczekaj, aż kontakt go poda. Jeśli sekrety się nie zgadzają, to używany środek komunikacji może być inwigilowany.

auth-question = Wpisz pytanie:

auth-answer = Wpisz odpowiedź (wielkość liter ma znaczenie):

auth-secret = Wpisz sekret:
