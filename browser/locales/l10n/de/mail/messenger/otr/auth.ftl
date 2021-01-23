# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Kontaktidentität bestätigen
    .buttonlabelaccept = Bestätigen

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Identität von { $name } bestätigen

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Ihr { $own_name }-Fingerabdruck:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Fingerabdruck für { $their_name }:

auth-help = Das Bestätigen der Identität eines Kontaktes hilft beim Sicherstellen, dass ein Gespräch wirklich privat ist, und erschwert das Abhören oder Manipulieren des Gesprächs durch Andere sehr.
auth-helpTitle = Hilfe zur Bestätigung

auth-questionReceived = Von Ihrem Kontakt gestellte Frage:

auth-yes =
    .label = Ja

auth-no =
    .label = Nein

auth-verified = Ich habe überprüft, dass dies tatsächlich der korrekte Fingerabdruck ist.

auth-manualVerification = Manuelle Bestätigung des Fingerabdrucks
auth-questionAndAnswer = Frage und Antwort
auth-sharedSecret = Geteiltes Geheimnis

auth-manualVerification-label =
    .label = { auth-manualVerification }

auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }

auth-sharedSecret-label =
    .label = { auth-sharedSecret }

auth-manualInstruction = Kontakten Sie Ihren beabsichtigten Gesprächspartner über einen anderen bestätigten Kommunikationskanal wie mit OpenPGP signierte E-Mails oder per Telefon. Teilen Sie sich gegenseitig Ihre Fingerabdrücke mit. (Ein Fingerabdruck ist die Prüfsumme, welche einen Verschlüsselungschlüssel identifiziert.) Falls die Fingerabdrücke stimmen, sollten Sie unten in diesem Dialog angeben, dass Sie den Fingerabdruck bestätigt haben.

auth-how = Wie soll die Identität Ihres Kontaktes bestätigt werden

auth-qaInstruction = Denken Sie sich eine Frage aus, auf die nur Sie und Ihr Kontakt die Antwort wissen. Geben Sie die Frage und Antwort ein und warten Sie dann darauf, dass Ihr Kontakt die Antwort eingibt. Falls die Antworten nicht überstimmen, wird der von Ihnen verwendete Kommunikationskanal eventuell überwacht.

auth-secretInstruction = Denken Sie an ein Geheimnis, welches nur Sie und Ihr Kontakt wissen. Verwenden Sie nicht dieselbe Internetverbindung, um das Geheimnis mitzuteilen. Geben Sie das Geheimnis ein und warten Sie dann darauf, dass Ihr Kontakt das Geheimnis eingibt. Falls die Geheimnisse nicht überstimmen, wird der von Ihnen verwendete Kommunikationskanal eventuell überwacht.

auth-question = Frage eingeben:

auth-answer = Antwort eingeben (Unterscheidung zwischen Groß- und Kleinschreibung):

auth-secret = Geheimnis eingeben:
