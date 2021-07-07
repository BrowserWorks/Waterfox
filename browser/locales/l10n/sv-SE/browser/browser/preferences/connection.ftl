# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Anslutningsinställningar
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }
connection-close-key =
    .key = w
connection-disable-extension =
    .label = Inaktivera tillägg
connection-proxy-configure = Konfigurera proxy för anslutning till Internet
connection-proxy-option-no =
    .label = Ingen proxy
    .accesskey = I
connection-proxy-option-system =
    .label = Använd systemets proxyinställningar
    .accesskey = v
connection-proxy-option-auto =
    .label = Automatisk identifiering av proxyinställningar
    .accesskey = e
connection-proxy-option-manual =
    .label = Manuell proxykonfiguration
    .accesskey = M
connection-proxy-http = HTTP-proxy
    .accesskey = x
connection-proxy-http-port = Port
    .accesskey = P
connection-proxy-http-sharing =
    .label = Använd också denna proxy för FTP och HTTPS
    .accesskey = A
connection-proxy-https-sharing =
    .label = Använd också denna proxy för HTTPS
    .accesskey = A
connection-proxy-https = HTTPS-proxy
    .accesskey = H
connection-proxy-ssl-port = Port
    .accesskey = o
connection-proxy-ftp = FTP-proxy
    .accesskey = F
connection-proxy-ftp-port = Port
    .accesskey = r
connection-proxy-socks = SOCKS-värd
    .accesskey = C
connection-proxy-socks-port = Port
    .accesskey = t
connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = 5
connection-proxy-noproxy = Ingen proxy för
    .accesskey = n
connection-proxy-noproxy-desc = Exempel: .mozilla.org, .sunet.se, 192.168.1.0/24
# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Anslutningar till localhost, 127.0.0.1 och ::1 är aldrig anslutna via en proxy.
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Anslutning till localhost 127.0.0.1/8 och ::1 går aldrig via proxy.
connection-proxy-autotype =
    .label = URL för automatisk proxykonfiguration
    .accesskey = U
connection-proxy-reload =
    .label = Uppdatera
    .accesskey = p
connection-proxy-autologin =
    .label = Fråga inte efter autentisering om lösenordet är sparat
    .accesskey = å
    .tooltip = Det här alternativet autentiserar dig automatiskt till proxyer när du har sparat inloggningar för dem. Du tillfrågas endast om autentiseringen misslyckas.
connection-proxy-socks-remote-dns =
    .label = Proxy DNS när du använder SOCKS v5
    .accesskey = d
connection-dns-over-https =
    .label = Aktivera DNS över HTTPS
    .accesskey = A
connection-dns-over-https-url-resolver = Använd leverantör
    .accesskey = A
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Standard)
    .tooltiptext = Använd standardadressen för att lösa DNS över HTTPS
connection-dns-over-https-url-custom =
    .label = Anpassad
    .accesskey = p
    .tooltiptext = Ange önskad URL för att lösa DNS över HTTPS
connection-dns-over-https-custom-label = Anpassad
