# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } verwendet ein ungültiges Sicherheitszertifikat.
cert-error-mitm-intro = Websites bestätigen ihre Identität mittels Zertifikaten, welche von Zertifizierungsstellen ausgegeben werden.
cert-error-mitm-mozilla = { -brand-short-name } wird von der gemeinnützigen Mozilla-Organisation unterstützt, welche eine vollständig offene Datenbank für Zertifizierungsstellen (CA Store) betreibt. Diese Datenbank hilft bei der Sicherstellung, dass Zertifizierungsstellen sich an Sicherheitsrichtlinien für die Anwendersicherheit halten.
cert-error-mitm-connection = { -brand-short-name } verwendet Mozillas Datenbank für Zertifizierungsstellen (CA Store) anstatt durch das Betriebssystem bereitgestellte Zertifikate, um zu überprüfen, ob eine Verbindung sicher ist. Wenn ein Antivirusprogramm oder das Netzwerk sich in eine Verbindung einklinkt und dafür ein Sicherheitszertifikat einer Zertifizierungsstelle verwendet, welche sich nicht in Mozillas Datenbank für Zertifizierungsstellen befindet, so wird die Verbindung daher als nicht sicher betrachtet.
cert-error-trust-unknown-issuer-intro = Eventuell täuscht jemand die Website vor und es sollte nicht fortgefahren werden.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Websites bestätigen ihre Identität mittels Zertifikaten. { -brand-short-name } vertraut { $hostname } nicht, weil der Aussteller des Zertifikats unbekannt ist, das Zertifikat vom Aussteller selbst signiert wurde oder der Server nicht die korrekten Zwischen-Zertifikate sendet.
cert-error-trust-cert-invalid = Dem Zertifikat wird nicht vertraut, weil es von einem ungültigen Zertifizierungsstellen-Zertifikat ausgestellt wurde.
cert-error-trust-untrusted-issuer = Dem Zertifikat wird nicht vertraut, weil dem Aussteller-Zertifikat nicht vertraut wird.
cert-error-trust-signature-algorithm-disabled = Dem Zertifikat wird nicht vertraut, weil es mit einem Signatur-Algorithmus signiert wurde, der deaktiviert wurde, weil er nicht sicher ist.
cert-error-trust-expired-issuer = Dem Zertifikat wird nicht vertraut, weil das Aussteller-Zertifikat abgelaufen ist.
cert-error-trust-self-signed = Dem Zertifikat wird nicht vertraut, weil es vom Aussteller selbst signiert wurde.
cert-error-trust-symantec = Von GeoTrust, RapidSSL, Symantec, Thawte oder VeriSign ausgestellte Zertifikate werden nicht mehr als vertrauenswürdig eingestuft, da sich die ausstellende Organisationen in der Vergangenheit nicht an Sicherheitsregeln gehalten haben.
cert-error-untrusted-default = Das Zertifikat kommt nicht von einer vertrauenswürdigen Quelle.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Websites bestätigen ihre Identität mittels Zertifikaten. { -brand-short-name } vertraut dieser Website nicht, weil das von der Website verwendete Zertifikat nicht für { $hostname } gilt.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Websites bestätigen ihre Identität mittels Zertifikaten. { -brand-short-name } vertraut dieser Website nicht, weil das von der Website verwendete Zertifikat nicht für { $hostname } gilt. Das Zertifikat ist nur gültig für <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Websites bestätigen ihre Identität mittels Zertifikaten. { -brand-short-name } vertraut dieser Website nicht, weil das von der Website verwendete Zertifikat nicht für { $hostname } gilt. Das Zertifikat ist nur gültig für { $alt-name }.
# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Websites bestätigen ihre Identität mittels Zertifikaten. { -brand-short-name } vertraut dieser Website nicht, weil das von der Website verwendete Zertifikat nicht für { $hostname } gilt. Das Zertifikat gilt nur für folgende Namen: { $subject-alt-names }
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Websites bestätigen ihre Identität mittels Zertifikaten, welche für einen bestimmten Zeitraum gültig sind. Das Zertifikat für { $hostname } ist am { $not-after-local-time } abgelaufen.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Websites bestätigen ihre Identität mittels Zertifikaten, welche für einen bestimmten Zeitraum gültig sind. Das Zertifikat für { $hostname } wird erst am { $not-before-local-time } gültig.
# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Fehlercode: <a data-l10n-name="error-code-link">{ $error }</a>
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Websites bestätigen ihre Identität mittels Zertifikaten, welche von Zertifizierungsstellen ausgegeben werden. Die meisten Browser vertrauen Zertifikaten nicht mehr, welche von GeoTrust, RapidSSL, Symantec, Thawte oder VeriSign ausgestellt wurden. { $hostname } verwendet ein Zertifikat von einer dieser Zertifizierungsstellen, weshalb die Identität der Website nicht bestätigt werden kann.
cert-error-symantec-distrust-admin = Sie können den Website-Administrator über das Problem benachrichtigen.
# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }
# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }
cert-error-details-cert-chain-label = Zertifikatskette:
open-in-new-window-for-csp-or-xfo-error = Seite in neuem Tab öffnen
# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Zu Ihrem Schutz erlaubt { $hostname } es { -brand-short-name } nicht, diese Seite anzuzeigen, wenn sie in eine andere Seite eingebettet ist. Zur Anzeige der Seite muss diese in einem neuen Tab geöffnet werden.

## Messages used for certificate error titles

connectionFailure-title = Fehler: Verbindung fehlgeschlagen
deniedPortAccess-title = Fehler: Port aus Sicherheitsgründen blockiert
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Seite wurde nicht gefunden
fileNotFound-title = Fehler: Datei nicht gefunden
fileAccessDenied-title = Zugriff auf die Datei wurde verweigert
generic-title = Fehler: Anfrage konnte nicht ausgeführt werden
captivePortal-title = Anmeldung beim Netzwerk
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Diese Adresse scheint nicht korrekt zu sein.
netInterrupt-title = Fehler: Datenübertragung unterbrochen
notCached-title = Dokument erloschen
netOffline-title = Fehler: Offline-Modus
contentEncodingError-title = Content-Encoding-Fehler
unsafeContentType-title = Unsicherer Dateityp
netReset-title = Fehler: Verbindung unterbrochen
netTimeout-title = Fehler: Netzwerk-Zeitüberschreitung
unknownProtocolFound-title = Adresse nicht erkannt
proxyConnectFailure-title = Fehler: Proxy-Server verweigert die Verbindung
proxyResolveFailure-title = Fehler: Proxy-Server nicht gefunden
redirectLoop-title = Fehler: Umleitungsfehler
unknownSocketType-title = Fehler: Unerwartete Antwort
nssFailure2-title = Fehler: Gesicherte Verbindung fehlgeschlagen
csp-xfo-error-title = { -brand-short-name } darf diese eingebettete Seite nicht öffnen
corruptedContentError-title = Fehler: Beschädigte Inhalte
remoteXUL-title = Remote-XUL
sslv3Used-title = Keine sichere Verbindung möglich
inadequateSecurityError-title = Diese Verbindung ist nicht sicher
blockedByPolicy-title = Blockierte Seite
clockSkewError-title = Datum und/oder Uhrzeit Ihres Computers sind nicht korrekt
networkProtocolError-title = Netzwerkprotokoll-Fehler
nssBadCert-title = Warnung: Mögliches Sicherheitsrisiko erkannt
nssBadCert-sts-title = Kein Verbindungsversuch unternommen: Mögliches Sicherheitsproblem
certerror-mitm-title = Software hindert { -brand-short-name } am Aufbauen einer sicheren Verbindung mit dieser Website
