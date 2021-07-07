# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption-required-part1 = Podjęto próbę wysłania niezaszyfrowanej wiadomości do użytkownika { $name }. Zgodnie z zasadami niezaszyfrowane wiadomości nie są dozwolone.

msgevent-encryption-required-part2 = Próba rozpoczęcia prywatnej rozmowy. Twoja wiadomość zostanie ponownie wysłana po rozpoczęciu prywatnej rozmowy.
msgevent-encryption-error = Wystąpił błąd podczas szyfrowania wiadomości. Wiadomość nie została wysłana.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection-ended = Użytkownik { $name } zamknął już zaszyfrowane połączenie z Tobą. Aby uniknąć przypadkowego wysłania wiadomości bez szyfrowania, Twoja wiadomość nie została wysłana. Zakończ zaszyfrowaną rozmowę lub rozpocznij ją ponownie.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup-error = Wystąpił błąd podczas konfigurowania prywatnej rozmowy z użytkownikiem { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg-reflected = Odbierasz własne wiadomości OTR. Albo próbujesz mówić do siebie, albo ktoś odbija Twoje wiadomości z powrotem do Ciebie.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg-resent = Ostatnia wiadomość do użytkownika { $name } została wysłana ponownie.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-not-private = Zaszyfrowana wiadomość odebrana od użytkownika { $name } jest nieczytelna, ponieważ obecna komunikacja nie jest prywatna.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unreadable = Odebrano nieczytelną zaszyfrowaną wiadomość od użytkownika { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-malformed = Odebrano wiadomość ze zniekształconymi danymi od użytkownika { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-rcvd = Odebrano sygnał od użytkownika { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-sent = Wysłano sygnał do użytkownika { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg-general-err = Wystąpił nieoczekiwany błąd podczas próby ochrony rozmowy za pomocą OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg-unencrypted = Ta wiadomość odebrana od użytkownika { $name } nie była zaszyfrowana: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unrecognized = Odebrano nierozpoznaną wiadomość OTR od użytkownika { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-for-other-instance = Użytkownik { $name } wysłał wiadomość przeznaczoną dla innej sesji. Jeśli zalogowano się wielokrotnie, to inna sesja mogła odebrać tę wiadomość.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-private = Rozpoczęto prywatną rozmowę z użytkownikiem { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-unverified = Rozpoczęto zaszyfrowaną, ale niezweryfikowaną rozmowę z użytkownikiem { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still-secure = Pomyślnie odświeżono zaszyfrowaną rozmowę z użytkowaniem { $name }.

error-enc = Wystąpił błąd podczas szyfrowania wiadomości.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not-priv = Wysłano zaszyfrowane dane do użytkownika { $name }, który się tego nie spodziewał.

error-unreadable = Przesłano nieczytelną zaszyfrowaną wiadomość.
error-malformed = Przesłano wiadomość ze zniekształconymi danymi.

resent = [wyślij ponownie]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = Użytkownik { $name } zakończył zaszyfrowaną rozmowę z Tobą, należy zrobić to samo.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } prosi o rozmowę zaszyfrowaną za pomocą OTR (Off-the-Record Messaging). Nie zainstalowano potrzebnej do tego wtyczki. https://pl.wikipedia.org/wiki/Off-the-record_messaging zawiera więcej informacji.
