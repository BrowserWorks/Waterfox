# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Konto einrichten

## Header

account-setup-title = Bestehende E-Mail-Adresse einrichten

account-setup-description = Geben Sie zur Verwendung Ihrer derzeitigen E-Mail-Adresse deren Zugangsdaten ein.

account-setup-secondary-description = { -brand-product-name } wird automatisch nach funktionierenden und empfohlenen Server-Konfigurationen suchen.

account-setup-success-title = Konto erfolgreich hinzugefügt

account-setup-success-description = Das Konto kann jetzt mit { -brand-short-name } verwendet werden.

account-setup-success-secondary-description = Das Verhalten des Kontos kann durch Verbinden mit damit zusammenhängenden Diensten und durch das Verändern von erweiterten Konteneinstellungen angepasst werden.

## Form fields

account-setup-name-label = Ihr vollständiger Name
    .accesskey = N

# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = Bianca Beispiel

account-setup-name-info-icon =
    .title = Ihr Name, wie er anderen Personen gezeigt wird


account-setup-name-warning-icon =
    .title = Bitte geben Sie Ihren Namen ein.

account-setup-email-label = E-Mail-Adresse
    .accesskey = E

account-setup-email-input =
    .placeholder = bianca.beispiel@example.com

account-setup-email-info-icon =
    .title = Bestehende E-Mail-Adresse

account-setup-email-warning-icon =
    .title = Ungültige E-Mail-Adresse

account-setup-password-label = Passwort
    .accesskey = P
    .title = Freiwillig, wird zur Bestätigung des Benutzernamens verwendet

account-provisioner-button = Neue E-Mail-Adresse erhalten
    .accesskey = u

account-setup-password-toggle =
    .title = Passwortanzeige umschalten

account-setup-remember-password = Passwort speichern
    .accesskey = s

account-setup-exchange-label = Ihr Benutzername
    .accesskey = B

#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = IHREDOMÄNE\ihrbenutzername

#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Domänen-Anmeldung

## Action buttons

account-setup-button-cancel = Abbrechen
    .accesskey = c

account-setup-button-manual-config = Manuell einrichten
    .accesskey = M

account-setup-button-stop = Stopp
    .accesskey = p

account-setup-button-retest = Erneut testen
    .accesskey = t

account-setup-button-continue = Weiter
    .accesskey = W

account-setup-button-done = Fertig
    .accesskey = F

## Notifications

account-setup-looking-up-settings = Einstellungen werden gesucht…

account-setup-looking-up-settings-guess = Einstellungen suchen: Ausprobieren typischer Serverbezeichnungen…

account-setup-looking-up-settings-half-manual = Einstellungen suchen: Server untersuchen…

account-setup-looking-up-disk = Einstellungen suchen: In der { -brand-short-name }-Installation…

account-setup-looking-up-isp = Einstellungen suchen: Anbieter des E-Mail-Diensts…

# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Einstellungen suchen: Waterfox ISP-Datenbank…

account-setup-looking-up-mx = Einstellungen suchen: Posteingangs-Server…

account-setup-looking-up-exchange = Einstellungen suchen: Exchange-Server…

account-setup-checking-password = Passwort wird getestet…

account-setup-installing-addon = Add-on wird heruntergeladen und installiert…

account-setup-success-half-manual = Folgende Einstellungen wurden durch Untersuchen des genannten Servers gefunden:

account-setup-success-guess = Einstellungen wurden durch Ausprobieren typischer Serverbezeichnungen gefunden

account-setup-success-guess-offline = Sie sind offline. Sie müssen die hier vermuteten Einstellungen bitte noch gegebenenfalls korrigieren.

account-setup-success-password = Passwort akzeptiert

account-setup-success-addon = Add-on erfolgreich installiert

# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = Einstellungen wurden in der Waterfox ISP-Datenbank gefunden.

account-setup-success-settings-disk = Einstellungen wurden in der { -brand-short-name }-Installation gefunden.

account-setup-success-settings-isp = Einstellungen wurden bei Ihrem Anbieter des E-Mail-Diensts gefunden.

# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = Einstellungen für Microsoft Exchange-Server wurden gefunden.

## Illustrations

account-setup-step1-image =
    .title = Ausgangseinstellungen

account-setup-step2-image =
    .title = Laden…

account-setup-step3-image =
    .title = Einstellungen gefunden

account-setup-step4-image =
    .title = Verbindungsfehler

account-setup-step5-image =
    .title = Konto hinzugefügt

account-setup-privacy-footnote2 = Ihre Zugangsdaten werden nur lokal auf Ihrem Computer gespeichert.

account-setup-selection-help = Nicht sicher, was ausgewählt werden soll?

account-setup-selection-error = Benötigen Sie Hilfe?

account-setup-success-help = Nicht sicher, was als Nächstes kommt?

account-setup-documentation-help = Dokumentation zur Einrichtung

account-setup-forum-help = Hilfeforum

account-setup-privacy-help = Datenschutzerklärung

account-setup-getting-started = Einführung

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
        [one] Verfügbare Konfiguration
        *[other] Verfügbare Konfigurationen
    }

# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP

account-setup-result-imap-description = Ordner und E-Mails mit dem Server synchronisieren

# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3

account-setup-result-pop-description = Ordner und E-Mails auf dem Computer speichern

# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange

# Note: Exchange, Office365 are the name of products.
account-setup-result-exchange2-description = Microsoft-Exchange-Server oder Office365-Cloud-Dienste verwenden

account-setup-incoming-title = Posteingangs-Server

account-setup-outgoing-title = Postausgangs-Server

account-setup-username-title = Benutzername

account-setup-exchange-title = Server

account-setup-result-smtp = SMTP

account-setup-result-no-encryption = Keine Verschlüsselung

account-setup-result-ssl = SSL/TLS

account-setup-result-starttls = STARTTLS

account-setup-result-outgoing-existing = Bereits vorhandenen SMTP-Server verwenden

# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = Posteingangs-Server: { $incoming }, Postausgangs-Server: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Anmeldung fehlgeschlagen. Entweder stimmen die eingegebenen Zugangsdaten nicht oder es werden andere, gesonderte Zugangsdaten benötigt. Der Benutzername ist im Allgemeinen der Kontoname Ihres Zugangs zur Windows-Domäne, mit oder ohne Domäne (z.B. mariamustermann oder AD\\mariamustermann).

account-setup-credentials-wrong = Anmeldung fehlgeschlagen. Bitte überprüfen Sie Benutername und Passwort.

account-setup-find-settings-failed = { -brand-short-name } konnte keine Einstellungen für Ihr E-Mail-Konto finden.

account-setup-exchange-config-unverifiable = Konfiguration konnte nicht überprüft werden. Falls der Benutzername und das Passwort korrekt sind, hat der Server-Administrator vermutlich die gewählte Konfiguration für Ihr Konto deaktiviert. Versuchen Sie, ein anderes Protokoll zu verwenden.

## Manual configuration area

account-setup-manual-config-title = Manuelle Einrichtigung

account-setup-incoming-server-legend = Posteingangs-Server

account-setup-protocol-label = Protokoll:

protocol-imap-option = { account-setup-result-imap }

protocol-pop-option = { account-setup-result-pop }

protocol-exchange-option = { account-setup-result-exchange }

account-setup-hostname-label = Hostname:

account-setup-port-label = Port:
    .title = Geben Sie 0 als Portnummer an, um die automatische Erkennung zu aktivieren.

account-setup-auto-description = { -brand-short-name } wird versuchen, die Werte für leer gelassene Felder automatisch zu erkennen.

account-setup-ssl-label = Verbindungssicherheit:

account-setup-outgoing-server-legend = Postausgangs-Server

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Automatisch erkennen

ssl-no-authentication-option = Keine Authentifizierung

ssl-cleartext-password-option = Passwort, normal

ssl-encrypted-password-option = Verschlüsseltes Passwort

## Incoming/Outgoing SSL options

ssl-noencryption-option = Keine Verbindungssicherheit

account-setup-auth-label = Authentifizierungsmethode:

account-setup-username-label = Benutzername:

account-setup-advanced-setup-button = Erweiterte Einstellungen
    .accesskey = w

## Warning insecure server dialog

account-setup-insecure-title = Warnung!

account-setup-insecure-incoming-title = Posteingangs-Einstellungen:

account-setup-insecure-outgoing-title = Postausgangs-Einstellungen:

# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = <b>{ $server }</b> verwendet keine Verschlüsselung.

account-setup-warning-cleartext-details = Ungesicherte E-Mail-Server verwenden keine Verschlüsselung, um Ihre privaten Daten und Passwörter zu schützen. Eine Verbindung zu diesen Servern könnte Ihr Passwort und private Daten gegenüber Dritten offenbaren.

account-setup-insecure-server-checkbox = Ich verstehe die Risiken.
    .accesskey = R

account-setup-insecure-description = { -brand-short-name } kann Ihre Nachrichten mit den gewählten Einstellungen abrufen. Sie sollten jedoch Ihren Administrator oder Anbieter des E-Mail-Diensts wegen dieser mangelhaften Verbindungsmöglichkeit kontaktieren. Lesen Sie in der <a data-l10n-name="thunderbird-faq-link">Thunderbird-FAQ</a> für weitere Informationen.

insecure-dialog-cancel-button = Einstellungen ändern
    .accesskey = n

insecure-dialog-confirm-button = Bestätigen
    .accesskey = B

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = { -brand-short-name } erkannte Informationen zur Konteneinrichtung auf { $domain }. Wollen Sie fortfahren und Ihre Zugangsdaten senden?

exchange-dialog-confirm-button = Senden

exchange-dialog-cancel-button = Abbrechen

## Dismiss account creation dialog

## Alert dialogs

account-setup-creation-error-title = Konteneinrichtung fehlgeschlagen

account-setup-error-server-exists = Der Posteingangs-Server wird bereits verwendet.

account-setup-confirm-advanced-title = Bestätigung - Öffnen der Erweiterten Konfiguration

account-setup-confirm-advanced-description = Dieser Dialog wird geschlossen und ein Konto wird basierend auf den derzeitigen Einstellungen erstellt, selbst wenn diese fehlerhaft sind. Wollen Sie fortfahren?

## Addon installation section

account-setup-addon-install-title = Installieren

account-setup-addon-install-intro = Ein Add-on eines Drittanbieters kann den Zugriff auf das E-Mail-Konto des Servers ermöglichen:

account-setup-addon-no-protocol = Dieser Posteingangs-Server unterstützt leider keine offenen Protokolle. { account-setup-addon-install-intro }

## Success view

account-setup-settings-button = Konteneinstellungen

account-setup-encryption-button = Ende-zu-Ende-Verschlüsselung

account-setup-signature-button = Signatur hinzufügen

account-setup-dictionaries-button = Wörterbücher hinzufügen

account-setup-address-book-carddav-button = Mit CardDAV-Adressbuch verbinden

account-setup-address-book-ldap-button = Mit LDAP-Adressbuch verbinden

account-setup-calendar-button = Mit externem Kalender verbinden

account-setup-linked-services-title = Mit verknüpften Diensten verbinden

account-setup-linked-services-description = { -brand-short-name } erkannte andere Dienste, die mit Ihrem E-Mail-Konto verknüpft sind.

account-setup-no-linked-description = Richten Sie andere Dienste ein, um Ihre Nutzung von { -brand-short-name } zu optimieren.

# Variables:
# $count (Number) - The number of address books found during autoconfig.
account-setup-found-address-books-description =
    { $count ->
        [one] { -brand-short-name } erkannte ein Adressbuch, das mit Ihrem E-Mail-Konto verknüpft ist.
        *[other] { -brand-short-name } erkannte { $count } Adressbücher, die mit Ihrem E-Mail-Konto verknüpft sind.
    }

# Variables:
# $count (Number) - The number of calendars found during autoconfig.
account-setup-found-calendars-description =
    { $count ->
        [one] { -brand-short-name } erkannte einen Kalender, der mit Ihrem E-Mail-Konto verknüpft ist.
        *[other] { -brand-short-name } erkannte { $count } Kalender, die mit Ihrem E-Mail-Konto verknüpft sind.
    }

account-setup-button-finish = Beenden
    .accesskey = B

account-setup-looking-up-address-books = Adressbücher werden aufgerufen…

account-setup-looking-up-calendars = Kalender werden aufgerufen…

account-setup-address-books-button = Adressbücher

account-setup-calendars-button = Kalender

account-setup-connect-link = Verbinden

account-setup-existing-address-book = Verbunden
    .title = Bereits mit Adressbuch verbunden

account-setup-existing-calendar = Verbunden
    .title = Bereits mit Kalender verbunden

account-setup-connect-all-calendars = Mit allen Kalendern verbinden

account-setup-connect-all-address-books = Mit allen Adressbüchern verbinden

## Calendar synchronization dialog

calendar-dialog-title = Kalender verbinden

calendar-dialog-cancel-button = Abbrechen
    .accesskey = b

calendar-dialog-confirm-button = Verbinden
    .accesskey = V

account-setup-calendar-name-label = Name

account-setup-calendar-name-input =
    .placeholder = Mein Kalender

account-setup-calendar-color-label = Farbe

account-setup-calendar-refresh-label = Aktualisieren

account-setup-calendar-refresh-manual = Manuell

account-setup-calendar-refresh-interval =
    { $count ->
        [one] Jede Minute
        *[other] Alle { $count } Minuten
    }

account-setup-calendar-read-only = Schreibgeschützt
    .accesskey = S

account-setup-calendar-show-reminders = Alarme anzeigen
    .accesskey = A

account-setup-calendar-offline-support = Offline-Unterstützung
    .accesskey = O
