# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

start-label = Verschlüsseltes Gespräch beginnen
refresh-label = Verschlüsseltes Gespräch wiederaufnehmen
auth-label = Identität Ihres Kontaktes bestätigen
reauth-label = Identität Ihres Kontaktes erneut bestätigen

auth-cancel = Abbrechen
auth-cancel-access-key = b

auth-error = Beim Bestätigen der Identität Ihres Kontaktes trat ein Fehler auf.
auth-success = Bestätigung der Identität Ihres Kontaktes erfolgreich abgeschlossen.
auth-success-them = Ihr Kontakt hat Ihre Identität erfolgreich bestätigt. Es ist empfehlenswert, dass Sie jetzt auch die Identität des Kontaktes bestätigen, indem Sie eine eigene Frage stellen.
auth-fail = Bestätigung der Identität Ihres Kontaktes fehlgeschlagen.
auth-waiting = Warten auf Abschluss der Bestätigung durch den Kontakt…

finger-verify = Bestätigen
finger-verify-access-key = B

finger-ignore = Ignorieren
finger-ignore-access-key = g

# Do not translate 'OTR' (name of an encryption protocol)
buddycontextmenu-label = OTR-Fingerabdruck hinzufügen

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-start = Es wird versucht, eine verschlüsselte Verbindung mit { $name } aufzubauen.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-refresh = Es wird versucht, das verschlüsselte Gespräch mit { $name } wiederaufzunehmen.

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-gone-insecure = Das verschlüsselte Gespräch mit { $name } wurde beendet.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-unseen = Die Identität von { $name } wurde noch nicht bestätigt. Einfaches Abhören ist nicht möglich, sondern benötigt etwas Aufwand. Verhindern Sie Überwachung, indem Sie die Identität des Kontaktes bestätigen.

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-seen={ $name } kontaktiert Sie von einem unbekannten Gerät. Einfaches Abhören ist nicht möglich, sondern benötigt etwas Aufwand. Verhindern Sie Überwachung, indem Sie die Identität des Kontaktes bestätigen.

state-not-private = Das derzeitige Gespräch ist nicht privat.
state-generic-not-private = Das derzeitige Gespräch ist nicht privat.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-unverified = Das derzeitige Gespräch ist verschlüsselt aber nicht privat, da die Identität von { $name } nicht bestätigt wurde.

state-generic-unverified = Das derzeitige Gespräch ist verschlüsselt aber nicht privat, da einige Identitäten noch nicht bestätigt wurden.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-private = Die Identität von { $name } wurde bestätigt. Das derzeitige Gespräch ist verschlüsselt und privat.

state-generic-private = Das derzeitige Gespräch ist verschlüsselt und privat.

# Variables:
#   $name (String) - the screen name of a chat contact person
state-finished = { $name } hat das verschlüsselte Gespräch mit Ihnen beendet; Sie sollten dies jetzt ebenfalls tun.

state-not-private-label = Nicht sicher
state-unverified-label = Nicht bestätigt
state-private-label = Privat
state-finished-label = Beendet

# Variables:
#   $name (String) - the screen name of a chat contact person
verify-request = { $name } forderte die Bestätigung Ihrer Identität an.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-private = Sie haben die Identität von { $name } bestätigt.

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-unverified = Die Identität von { $name } wurde noch nicht bestätigt.

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $error (String) - contains an error message that describes the cause of the failure
otr-genkey-failed = Erzeugung eines privaten OTR-Schlüssels schlug fehl: { $error }
