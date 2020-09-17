# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Provider brûke
    .accesskey = r

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Standert)
    .tooltiptext = Standert URL brûke foar DNS oer HTTPS

connection-dns-over-https-url-custom =
    .label = Oanpast
    .accesskey = O
    .tooltiptext = Fier jo foarkars-URL yn foar DNS oer HTTPS

connection-dns-over-https-custom-label = Oanpast

connection-dialog-window =
    .title = Ferbiningsynstellingen
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Proxy’s foar tagong ta it ynternet konfigurearje

proxy-type-no =
    .label = Gjin proxy
    .accesskey = y

proxy-type-wpad =
    .label = Proxy-ynstellingen foar dit netwurk automatysk detektearje
    .accesskey = w

proxy-type-system =
    .label = Systeem proxy-ynstellingen brûke
    .accesskey = k

proxy-type-manual =
    .label = Hânmjittige proxykonfiguraasje:
    .accesskey = m

proxy-http-label =
    .value = HTTP-proxy:
    .accesskey = H

http-port-label =
    .value = Poarte:
    .accesskey = P

proxy-http-sharing =
    .label = Dizze proxy ek foar HTTPS brûke
    .accesskey = x

proxy-https-label =
    .value = HTTPS-proxy:
    .accesskey = S

ssl-port-label =
    .value = Poarte:
    .accesskey = o

proxy-socks-label =
    .value = SOCKS-host:
    .accesskey = C

socks-port-label =
    .value = Poarte:
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL foar automatyske proxykonfiguraasje:
    .accesskey = a

proxy-reload-label =
    .label = Opnij lade
    .accesskey = l

no-proxy-label =
    .value = Gjin proxy foar:
    .accesskey = n

no-proxy-example = Foarbyld: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Ferbiningen nei localhost, 127.0.0.1, en :: 1 rinne nea fia de proxy.

proxy-password-prompt =
    .label = Freegje net om autentikaasje as wachtwurd bewarre is
    .accesskey = i
    .tooltiptext = Dizze opsje autentisearret jo automatisysk by proxies as jo derfoar bewarre gegevens hawwe. Jo sille frege wurde as autentikaasje mislearret.

proxy-remote-dns =
    .label = DNS fia proxy by gebrûk fan SOCKS v5
    .accesskey = D

proxy-enable-doh =
    .label = DNS oer HTTPS ynskeakelje
    .accesskey = o
