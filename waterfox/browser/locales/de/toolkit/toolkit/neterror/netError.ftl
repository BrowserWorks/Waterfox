# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Seiten-Ladefehler
certerror-page-title = Warnung: Mögliches Sicherheitsrisiko erkannt
certerror-sts-page-title = Keine Verbindung aufgebaut: Mögliches Sicherheitsproblem
neterror-blocked-by-policy-page-title = Blockierte Seite
neterror-captive-portal-page-title = Anmeldung beim Netzwerk
neterror-dns-not-found-title = Server nicht gefunden
neterror-malformed-uri-page-title = Ungültige Adresse

## Error page actions

neterror-advanced-button = Erweitert…
neterror-copy-to-clipboard-button = In Zwischenablage kopieren
neterror-learn-more-link = Weitere Informationen…
neterror-open-portal-login-page-button = Anmeldeseite des Netzwerks öffnen
neterror-override-exception-button = Risiko akzeptieren und fortfahren
neterror-pref-reset-button = Standardeinstellungen wiederherstellen
neterror-return-to-previous-page-button = Zurück
neterror-return-to-previous-page-recommended-button = Zurück (empfohlen)
neterror-try-again-button = Nochmals versuchen
neterror-add-exception-button = Immer für diese Website fortfahren
neterror-settings-button = DNS-Einstellungen ändern
neterror-view-certificate-link = Zertifikat anzeigen
neterror-trr-continue-this-time = Dieses Mal fortfahren
neterror-disable-native-feedback-warning = Immer fortfahren

##

neterror-pref-reset = Dies könnte durch die Netzwerk-Sicherheitseinstellungen verursacht werden. Sollen die Standardeinstellungen wiederhergestellt werden?
neterror-error-reporting-automatic = Fehler an { -vendor-short-name } melden, um beim Identifizieren und Blockieren böswilliger Websites zu helfen

## Specific error messages

neterror-generic-error = { -brand-short-name } konnte die Seite aus unbekanntem Grund nicht laden.
neterror-load-error-try-again = Die Website könnte vorübergehend nicht erreichbar sein, versuchen Sie es bitte später nochmals.
neterror-load-error-connection = Wenn Sie auch keine andere Website aufrufen können, überprüfen Sie bitte die Netzwerk-/Internetverbindung.
neterror-load-error-firewall = Wenn Ihr Computer oder Netzwerk von einer Firewall oder einem Proxy geschützt wird, stellen Sie bitte sicher, dass { -brand-short-name } auf das Internet zugreifen darf.
neterror-captive-portal = Sie müssen sich bei dem Netzwerk anmelden, um auf das Internet zugreifen zu können.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Wollten Sie <a data-l10n-name="website">{ $hostAndPath }</a> aufrufen?
neterror-dns-not-found-hint-header = <strong>Wenn Sie die richtige Adresse eingegeben haben, können Sie Folgendes tun:</strong>
neterror-dns-not-found-hint-try-again = Versuchen Sie es später erneut.
neterror-dns-not-found-hint-check-network = Überprüfen Sie Ihre Netzwerkverbindung.
neterror-dns-not-found-hint-firewall = Überprüfen Sie, ob { -brand-short-name } die Berechtigung hat, auf das Internet zuzugreifen (Sie sind möglicherweise verbunden, aber hinter einer Firewall).

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } kann Ihre Anfrage für die Adresse dieser Website nicht durch unseren vertrauenswürdigen DNS-Resolver schützen. Der Grund ist:
neterror-dns-not-found-trr-third-party-warning2 = Sie können mit Ihrem Standard-DNS-Resolver fortfahren. Ein Drittanbieter kann jedoch möglicherweise sehen, welche Websites Sie besuchen.
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } konnte keine Verbindung zu { $trrDomain } herstellen.
neterror-dns-not-found-trr-only-timeout = Die Verbindung zu { $trrDomain } dauerte länger als erwartet.
neterror-dns-not-found-trr-offline = Sie sind nicht mit dem Internet verbunden.
neterror-dns-not-found-trr-unknown-host2 = Diese Website wurde nicht von { $trrDomain } gefunden.
neterror-dns-not-found-trr-server-problem = Es gab ein Problem mit { $trrDomain }.
neterror-dns-not-found-bad-trr-url = Ungültige Adresse.
neterror-dns-not-found-trr-unknown-problem = Unerwartetes Problem.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } kann Ihre Anfrage für die Adresse dieser Website nicht durch unseren vertrauenswürdigen DNS-Resolver schützen. Der Grund ist:
neterror-dns-not-found-native-fallback-heuristic = DNS über HTTPS wurde in Ihrem Netzwerk deaktiviert.
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } konnte keine Verbindung zu { $trrDomain } herstellen.

##

neterror-file-not-found-filename = Bitte überprüfen Sie die Adresse auf Rechtschreib-, Groß-/Kleinschreibungs- oder andere Fehler.
neterror-file-not-found-moved = Bitte überprüfen Sie, ob die Adresse umbenannt, gelöscht oder verschoben wurde.
neterror-access-denied = Sie wurde möglicherweise entfernt, verschoben, oder Dateiberechtigungen könnten den Zugriff verhindern.
neterror-unknown-protocol = Eventuell müssen Sie andere Software installieren, um diese Adresse aufrufen zu können.
neterror-redirect-loop = Dieses Problem kann manchmal auftreten, wenn Cookies deaktiviert oder abgelehnt werden.
neterror-unknown-socket-type-psm-installed = Bitte stellen Sie sicher, dass auf Ihrem System der Personal-Security-Manager installiert ist.
neterror-unknown-socket-type-server-config = Dies kann mit einer nicht-standardgemäßen Konfiguration des Servers zusammenhängen.
neterror-not-cached-intro = Das angeforderte Dokument ist nicht im Cache von { -brand-short-name } verfügbar.
neterror-not-cached-sensitive = Als Sicherheitsmaßnahme fordert { -brand-short-name } vertrauliche Dokumente nicht automatisch erneut an.
neterror-not-cached-try-again = Klicken Sie auf "Nochmals versuchen", um das Dokument erneut von der Website anzufordern.
neterror-net-offline = Wählen Sie “Nochmals versuchen", um in den Online-Modus zu wechseln und die Seite erneut zu laden.
neterror-proxy-resolve-failure-settings = Überprüfen Sie bitte, ob die Proxy-Einstellungen korrekt sind.
neterror-proxy-resolve-failure-connection = Überprüfen Sie bitte, ob eine Netzwerk-/Internet-Verbindung besteht.
neterror-proxy-resolve-failure-firewall = Wenn Ihr Computer oder Netzwerk von einer Firewall oder einem Proxy geschützt wird, stellen Sie bitte sicher, dass { -brand-short-name } auf das Internet zugreifen darf.
neterror-proxy-connect-failure-settings = Überprüfen Sie bitte, ob die Proxy-Einstellungen korrekt sind
neterror-proxy-connect-failure-contact-admin = Kontaktieren Sie bitte Ihren Netzwerk-Administrator, um sicherzustellen, dass der Proxy-Server funktioniert
neterror-content-encoding-error = Kontaktieren Sie bitte den Inhaber der Website, um ihn über dieses Problem zu informieren.
neterror-unsafe-content-type = Bitte kontaktieren Sie die Webseitenbetreiber, um sie über dieses Problem zu informieren.
neterror-nss-failure-not-verified = Die Website kann nicht angezeigt werden, da die Authentizität der erhaltenen Daten nicht verifiziert werden konnte.
neterror-nss-failure-contact-website = Kontaktieren Sie bitte den Inhaber der Website, um ihn über dieses Problem zu informieren.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } hat ein mögliches Sicherheitsrisiko erkannt und <b>{ $hostname }</b> nicht geladen. Falls Sie die Website besuchen, könnten Angreifer versuchen, Passwörter, E-Mails oder Kreditkartendaten zu stehlen.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } hat ein mögliches Sicherheitsrisiko erkannt und daher <b>{ $hostname }</b> nicht aufgerufen, denn die Website benötigt eine verschlüsselte Verbindung.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } hat ein Problem erkannt und <b>{ $hostname }</b> nicht aufgerufen. Entweder ist die Website falsch eingerichtet oder Datum und/oder Uhrzeit auf diesem Computer sind nicht korrekt.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> ist wahrscheinlich eine sichere Website, aber es konnte keine sichere Verbindung aufgebaut werden. Dies wird durch <b>{ $mitm }</b> verursacht, welches entweder auf dem Computer installierte Software oder Ihr Netzwerk ist.
neterror-corrupted-content-intro = Die Seite, die Sie anzusehen versuchen, kann nicht angezeigt werden, da ein Fehler in der Datenübertragung festgestellt wurde.
neterror-corrupted-content-contact-website = Bitte kontaktieren Sie die Website-Betreiber, um sie über dieses Problem zu verständigen.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Weitere Informationen: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> verwendet Sicherheitstechnologie, welche veraltet und verwundbar ist. Ein Angreifer könnte leicht Informationen entschlüsseln, welche Sie für sicher hielten. Der Website-Administrator muss dieses Problem auf dem Server beheben, bevor Sie die Seite aufrufen können.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Fehlercode: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = Datum und Uhrzeit Ihres Computers sind auf { DATETIME($now, dateStyle: "medium") } gesetzt, was { -brand-short-name } am Herstellen einer gesicherten Verbindung hindert. Setzen Sie Datum, Uhrzeit und Zeitzone in den Systemeinstellungen korrekt und laden Sie anschließend <b>{ $hostname }</b> neu.
neterror-network-protocol-error-intro = Die angeforderte Seite kann nicht angezeigt werden, da ein Fehler bei der Verwendung des Netzwerkprotokolls festgestellt wurde.
neterror-network-protocol-error-contact-website = Kontaktieren Sie bitte die Betreiber der Website, um sie über dieses Problem zu informieren.
certerror-expired-cert-second-para = Das Zertifikat der Website ist wahrscheinlich abgelaufen, weshalb { -brand-short-name } keine verschlüsselte Verbindung aufbauen kann. Falls Sie die Website besuchen, könnten Angreifer versuchen, Passwörter, E-Mails oder Kreditkartendaten zu stehlen.
certerror-expired-cert-sts-second-para = Das Zertifikat der Website ist wahrscheinlich abgelaufen, weshalb { -brand-short-name } keine verschlüsselte Verbindung aufbauen kann.
certerror-what-can-you-do-about-it-title = Was können Sie dagegen tun?
certerror-unknown-issuer-what-can-you-do-about-it-website = Am wahrscheinlichsten wird das Problem durch die Website verursacht und Sie können nichts dagegen tun.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Falls Sie sich in einem Firmennetzwerk befinden oder Antivirus-Software einsetzen, so können Sie jeweils deren IT-Support kontaktieren. Das Benachrichtigen des Website-Administrators über das Problem ist eine weitere Möglichkeit.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = Datum und Uhrzeit Ihres Computers sind eingestellt auf { DATETIME($now, dateStyle: "medium") }. Überprüfen Sie, ob Datum, Uhrzeit und Zeitzone in den Systemeinstellungen korrekt gesetzt sind und laden Sie <b>{ $hostname }</b> neu.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Falls Datum und Uhrzeit bereits korrekt sind, so ist die Website wahrscheinlich falsch eingerichtet und Sie können das Problem nicht selbst beheben. Sie können den Website-Administrator über das Problem benachrichtigen.
certerror-bad-cert-domain-what-can-you-do-about-it = Am wahrscheinlichsten wird das Problem durch die Website verursacht und Sie können nichts dagegen tun. Sie können den Website-Administrator über das Problem benachrichtigen.
certerror-mitm-what-can-you-do-about-it-antivirus = Falls die verwendete Antivirus-Software eine Funktion zum Untersuchen verschlüsselter Verbindungen enthält (oft als "Browser Safety" oder "Untersuchung von sicheren Verbindungen" bezeichnet), können Sie diese Funktion deaktivieren. Falls dies das Problem nicht behebt, können Sie die Antivirus-Software deinstallieren und neu installieren.
certerror-mitm-what-can-you-do-about-it-corporate = Falls Sie ein Firmennetzwerk verwenden, kontaktieren Sie bitte Ihre IT-Abteilung.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Falls Sie mit <b>{ $mitm }</b> nicht vertraut sind, könnte dies ein Angriff sein und Sie sollten nicht mit dem Laden dieser Website fortfahren.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Falls Sie mit <b>{ $mitm }</b> nicht vertraut sind, könnte dies ein Angriff sein und Sie können nichts unternehmen, um diese Seite zu laden.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> verwendet eine Sicherheitstechnologie namens "HTTP Strict Transport Security (HSTS)", durch welche { -brand-short-name } nur über gesicherte Verbindungen mit der Website verbinden darf. Daher kann keine Ausnahme für die Website hinzugefügt werden.
