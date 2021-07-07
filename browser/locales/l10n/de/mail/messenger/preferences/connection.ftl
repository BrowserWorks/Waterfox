# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Anbieter verwenden
    .accesskey = v

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Standard)
    .tooltiptext = Standardadresse für das Auflösen von DNS über HTTPS verwenden

connection-dns-over-https-url-custom =
    .label = Benutzerdefiniert
    .accesskey = e
    .tooltiptext = Adresse für das Auflösen von DNS über HTTPS eingeben

connection-dns-over-https-custom-label = Benutzerdefiniert

connection-dialog-window =
    .title = Verbindungs-Einstellungen
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-disable-extension =
    .label = Erweiterung deaktivieren

connection-proxy-legend = Proxies für den Zugriff auf das Internet konfigurieren

proxy-type-no =
    .label = Kein Proxy
    .accesskey = K

proxy-type-wpad =
    .label = Die Proxy-Einstellungen für dieses Netzwerk automatisch erkennen
    .accesskey = w

proxy-type-system =
    .label = Proxy-Einstellungen des Systems verwenden
    .accesskey = r

proxy-type-manual =
    .label = Manuelle Proxy-Konfiguration:
    .accesskey = m

proxy-http-label =
    .value = HTTP-Proxy:
    .accesskey = h

http-port-label =
    .value = Port:
    .accesskey = p

proxy-http-sharing =
    .label = Diesen Proxy auch für HTTPS verwenden
    .accesskey = x

proxy-https-label =
    .value = HTTPS-Proxy:
    .accesskey = S

ssl-port-label =
    .value = Port:
    .accesskey = o

proxy-socks-label =
    .value = SOCKS-Host
    .accesskey = c

socks-port-label =
    .value = Port:
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = Automatische Proxy-Konfigurations-URL:
    .accesskey = a

proxy-reload-label =
    .label = Neu laden
    .accesskey = l

no-proxy-label =
    .value = Kein Proxy für:
    .accesskey = n

no-proxy-example = Beispiel: .mozilla.org, .net.de, 192.168.1.0/24

# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Verbindungen mit localhost, 127.0.0.1/8 und ::1 werden nie über einen Proxy geleitet.

proxy-password-prompt =
    .label = Keine Authentifizierungsanfrage bei gespeichertem Passwort
    .accesskey = z
    .tooltiptext = Beim Aktivieren dieser Einstellung wird die Anmeldung an Proxies automatisch vorgenommen, falls deren Passwort gespeichert ist. Bei fehlgeschlagener Authentifizierung wird das Passwort vom Benutzer abgefragt.

proxy-remote-dns =
    .label = Bei Verwendung von SOCKS v5 den Proxy für DNS-Anfragen verwenden
    .accesskey = D

proxy-enable-doh =
    .label = DNS über HTTPS aktivieren
    .accesskey = b
