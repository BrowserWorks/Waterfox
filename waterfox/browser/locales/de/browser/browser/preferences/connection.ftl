# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Verbindungs-Einstellungen
    .style =
        { PLATFORM() ->
            [macos] width: 45em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Erweiterung deaktivieren

connection-proxy-configure = Proxy-Zugriff auf das Internet konfigurieren

connection-proxy-option-no =
    .label = Kein Proxy
    .accesskey = i
connection-proxy-option-system =
    .label = Proxy-Einstellungen des Systems verwenden
    .accesskey = g
connection-proxy-option-auto =
    .label = Die Proxy-Einstellungen für dieses Netzwerk automatisch erkennen
    .accesskey = w
connection-proxy-option-manual =
    .label = Manuelle Proxy-Konfiguration:
    .accesskey = M

connection-proxy-http = HTTP-Proxy:
    .accesskey = y
connection-proxy-http-port = Port:
    .accesskey = P

connection-proxy-https-sharing =
    .label = Diesen Proxy auch für HTTPS verwenden
    .accesskey = s

connection-proxy-https = HTTPS-Proxy
    .accesskey = H
connection-proxy-ssl-port = Port:
    .accesskey = o

connection-proxy-socks = SOCKS-Host:
    .accesskey = C
connection-proxy-socks-port = Port:
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Kein Proxy für:
    .accesskey = n

connection-proxy-noproxy-desc = Beispiel: .mozilla.org, .net.de, 192.168.1.0/24

# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Verbindungen mit localhost, 127.0.0.1/8 und ::1 werden nie über einen Proxy geleitet.

connection-proxy-autotype =
    .label = Automatische Proxy-Konfigurations-Adresse:
    .accesskey = u

connection-proxy-reload =
    .label = Neu laden
    .accesskey = a

connection-proxy-autologin =
    .label = Keine Authentifizierungsanfrage bei gespeichertem Passwort
    .accesskey = z
    .tooltip = Beim Aktivieren dieser Einstellung wird die Anmeldung an Proxies automatisch vorgenommen, falls deren Passwort gespeichert ist. Bei fehlgeschlagener Authentifizierung wird das Passwort vom Benutzer abgefragt.

connection-proxy-socks-remote-dns =
    .label = Bei Verwendung von SOCKS v5 den Proxy für DNS-Anfragen verwenden
    .accesskey = D

connection-dns-over-https =
    .label = DNS über HTTPS aktivieren
    .accesskey = b

connection-dns-over-https-url-resolver = Anbieter verwenden
    .accesskey = v

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Standard)
    .tooltiptext = Standardadresse für das Auflösen von DNS über HTTPS verwenden

connection-dns-over-https-url-custom =
    .label = Benutzerdefiniert
    .accesskey = B
    .tooltiptext = Bevorzugte Adresse für das Auflösen von DNS über HTTPS eingeben

connection-dns-over-https-custom-label = Benutzerdefiniert
