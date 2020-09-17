# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Ferbiningsynstellingen
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }
connection-close-key =
    .key = w
connection-disable-extension =
    .label = Utwreiding útskeakelje
connection-proxy-configure = Proxy foar tagong ta ynternet ynstelle
connection-proxy-option-no =
    .label = Gjin proxy
    .accesskey = G
connection-proxy-option-system =
    .label = Proxyynstellingen systeem brûke
    .accesskey = B
connection-proxy-option-auto =
    .label = Proxyynstellingen foar dit netwurk automatysk detektearje
    .accesskey = w
connection-proxy-option-manual =
    .label = Hânmjittige proxykonfiguraasje
    .accesskey = m
connection-proxy-http = HTTP-proxy
    .accesskey = x
connection-proxy-http-port = Poarte
    .accesskey = P
connection-proxy-http-sharing =
    .label = Dizze proxy ek foar FTP en HTTPS brûke
    .accesskey = k
connection-proxy-https = HTTPS-proxy
    .accesskey = H
connection-proxy-ssl-port = Poarte
    .accesskey = o
connection-proxy-ftp = FTP-proxy
    .accesskey = F
connection-proxy-ftp-port = Poarte
    .accesskey = r
connection-proxy-socks = SOCKS-host
    .accesskey = C
connection-proxy-socks-port = Poarte
    .accesskey = t
connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Gjin proxy foar
    .accesskey = n
connection-proxy-noproxy-desc = Foarbyld: .mozilla.org, .net.nl, 192.168.1.0/24
# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Ferbiningen mei localhost, 127.0.0.1 en ::1 gean nea fia in proxy.
connection-proxy-autotype =
    .label = URL foar automatyske proxykonfiguraasje
    .accesskey = U
connection-proxy-reload =
    .label = Fernije
    .accesskey = F
connection-proxy-autologin =
    .label = Freegje net om autentikaasje as wachtwurd bewarre is
    .accesskey = i
    .tooltip = Dizze opsje autentisearret jo automatisysk by proxies as jo derfaor bewarre gegevens hawwe. Jo sille frege wurde as autentikaasje mislearret.
connection-proxy-socks-remote-dns =
    .label = DNS fia proxy by gebrûk fan SOCKS v5
    .accesskey = d
connection-dns-over-https =
    .label = DNS oer HTTPS ynskeakelje
    .accesskey = D
connection-dns-over-https-url-resolver = Provider brûke
    .accesskey = P
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (standert)
    .tooltiptext = De standert-URL foar it omsetten fan DNS fia HTTPS brûke
connection-dns-over-https-url-custom =
    .label = Oanpast
    .accesskey = O
    .tooltiptext = In URL fan jo foarkar foar it omsetten fan DNS oer HTTPS ynfiere
connection-dns-over-https-custom-label = Oanpast
