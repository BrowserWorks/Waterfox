# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Provider gebruiken
    .accesskey = r
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (standaard)
    .tooltiptext = De standaard-URL voor het omzetten van DNS over HTTPS gebruiken
connection-dns-over-https-url-custom =
    .label = Aangepast
    .accesskey = A
    .tooltiptext = Een URL van uw voorkeur voor het omzetten van DNS over HTTPS invoeren
connection-dns-over-https-custom-label = Aangepast
connection-dialog-window =
    .title = Verbindingsinstellingen
    .style =
        { PLATFORM() ->
            [macos] width: 46em !important
           *[other] width: 51em !important
        }
connection-disable-extension =
    .label = Extensie uitschakelen
connection-proxy-legend = Proxy’s voor toegang tot het internet configureren
proxy-type-no =
    .label = Geen proxy
    .accesskey = y
proxy-type-wpad =
    .label = Proxyinstellingen voor dit netwerk automatisch detecteren
    .accesskey = w
proxy-type-system =
    .label = Proxyinstellingen van systeem gebruiken
    .accesskey = b
proxy-type-manual =
    .label = Handmatige proxyconfiguratie:
    .accesskey = m
proxy-http-label =
    .value = HTTP-proxy:
    .accesskey = x
http-port-label =
    .value = Poort:
    .accesskey = P
proxy-http-sharing =
    .label = Deze proxy ook voor HTTPS gebruiken
    .accesskey = x
proxy-https-label =
    .value = HTTPS-proxy:
    .accesskey = S
ssl-port-label =
    .value = Poort:
    .accesskey = o
proxy-socks-label =
    .value = SOCKS-host:
    .accesskey = C
socks-port-label =
    .value = Poort:
    .accesskey = t
proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K
proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v
proxy-type-auto =
    .label = URL voor automatische proxyconfiguratie:
    .accesskey = a
proxy-reload-label =
    .label = Opnieuw laden
    .accesskey = e
no-proxy-label =
    .value = Geen proxy voor:
    .accesskey = G
no-proxy-example = Voorbeeld: .mozilla.org, .net.nz, 192.168.1.0/24
# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Verbindingen met localhost, 127.0.0.1 en ::1 gaan nooit via een proxy.
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Verbindingen met localhost, 127.0.0.1/8 en ::1 gaan nooit via een proxy.
proxy-password-prompt =
    .label = Niet om authenticatie vragen als wachtwoord is opgeslagen
    .accesskey = i
    .tooltiptext = Deze optie authenticeert u automatisch bij proxy’s als u hiervoor referenties hebt opgeslagen. Als authenticatie mislukt, wordt hierom gevraagd.
proxy-remote-dns =
    .label = DNS via proxy bij gebruik van SOCKS v5
    .accesskey = D
proxy-enable-doh =
    .label = DNS over HTTPS inschakelen
    .accesskey = N
