# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Använd leverantör
    .accesskey = A
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Standard)
    .tooltiptext = Använd standardadressen för att lösa DNS över HTTPS
connection-dns-over-https-url-custom =
    .label = Anpassad
    .accesskey = A
    .tooltiptext = Ange önskad adress för att lösa DNS över HTTPS
connection-dns-over-https-custom-label = Anpassad
connection-dialog-window =
    .title = Anslutningsinställningar
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }
connection-disable-extension =
    .label = Inaktivera tillägg
disable-extension-button = Inaktivera tillägg
# Variables:
#   $name (String) - The extension that is controlling the proxy settings.
#
# The extension-icon is the extension's icon, or a fallback image. It should be
# purely decoration for the actual extension name, with alt="".
proxy-settings-controlled-by-extension = Ett tillägg, <img data-l10n-name="extension-icon" alt="" />{ $name }, styr hur { -brand-short-name } ansluter till internet.
connection-proxy-legend = Ange proxy för anslutning till Internet
proxy-type-no =
    .label = Ingen proxy
    .accesskey = I
proxy-type-wpad =
    .label = Automatisk identifiering av proxyinställningar
    .accesskey = e
proxy-type-system =
    .label = Använd systemets proxyinställningar
    .accesskey = d
proxy-type-manual =
    .label = Manuell proxykonfiguration:
    .accesskey = M
proxy-http-label =
    .value = HTTP-proxy:
    .accesskey = x
http-port-label =
    .value = Port:
    .accesskey = P
proxy-http-sharing =
    .label = Använd också denna proxy för HTTPS
    .accesskey = x
proxy-https-label =
    .value = HTTPS-proxy:
    .accesskey = S
ssl-port-label =
    .value = Port:
    .accesskey = o
proxy-socks-label =
    .value = SOCKS-värd:
    .accesskey = C
socks-port-label =
    .value = Port:
    .accesskey = t
proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K
proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v
proxy-type-auto =
    .label = URL för automatisk proxykonfiguration:
    .accesskey = a
proxy-reload-label =
    .label = Uppdatera
    .accesskey = U
no-proxy-label =
    .value = Ingen proxy för:
    .accesskey = n
no-proxy-example = Exempel: .mozilla.org, .sunet.se, 192.168.1.0/24
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Anslutning till localhost 127.0.0.1/8 och ::1 går aldrig via proxy.
proxy-password-prompt =
    .label = Fråga inte efter autentisering om lösenordet är sparat
    .accesskey = o
    .tooltiptext = Detta alternativ autentiserar dig automatiskt till proxier när du har sparat inloggningsuppgifter för dem. Du kommer att bli tillfrågad om autentiseringen misslyckas.
proxy-remote-dns =
    .label = Proxy DNS när du använder SOCKS v5
    .accesskey = d
proxy-enable-doh =
    .label = Aktivera DNS över HTTPS
    .accesskey = v
