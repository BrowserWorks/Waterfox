# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Arventennoù kennaskañ
    .style =
        { PLATFORM() ->
            [macos] width: 39em
           *[other] width: 39em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Diweredekaat an askouezh

connection-proxy-configure = Kefluniañ haeziñ ar proksi d'ar genrouedad

connection-proxy-option-no =
    .label = Proksi ebet
    .accesskey = b
connection-proxy-option-system =
    .label = Arverañ arventennoù proksi ar reizhiad
    .accesskey = r
connection-proxy-option-auto =
    .label = EmZinoiñ an arventennoù proksi evit ar ristenn-mañ
    .accesskey = Z
connection-proxy-option-manual =
    .label = Kefluniadur proksi dre zorn
    .accesskey = p

connection-proxy-http = Proksi HTTP
    .accesskey = H
connection-proxy-http-port = Porzh
    .accesskey = p

connection-proxy-http-sharing =
    .label = Arverañ ar proksi-mañ evit an FTP hag an HTTP ivez
    .accesskey = A

connection-proxy-https = Proksi HTTPS
    .accesskey = P
connection-proxy-ssl-port = Porzh
    .accesskey = o

connection-proxy-ftp = Proksi FTP
    .accesskey = F
connection-proxy-ftp-port = Porzh
    .accesskey = r

connection-proxy-socks = Ostiz SOCKS
    .accesskey = O
connection-proxy-socks-port = Porzh
    .accesskey = z

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Proksi ebet evit
    .accesskey = e

connection-proxy-noproxy-desc = Skouer : .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = N'eo morse lakaet ar c'hennaskoù da localhost, 127.0.0.1, ha ::1 a-dreñv ur proksi.

connection-proxy-autotype =
    .label = URL kefluniañ emgefreek ar proksi
    .accesskey = U

connection-proxy-reload =
    .label = Adkargañ
    .accesskey = k

connection-proxy-autologin =
    .label = Na c'houlenn diganin en em zilesa ma'z eus ur ger-tremen enrollet
    .accesskey = N
    .tooltip = An dibarzh-mañ a zilesa ac'hanoc'h ent emgefreek war ar proksioù ma'z eus naoudioù kennaskañ enrollet evito. Goulennet e vo anezho diganeoc'h ma vez c'hwitet an dilesa.

connection-proxy-socks-remote-dns =
    .label = DNS Proksi p'eo arveret SOCKS v5
    .accesskey = d

connection-dns-over-https =
    .label = Gweredekaat DNS dre HTTPS
    .accesskey = G

connection-dns-over-https-url-resolver = Ober gant ar pourchaser
    .accesskey = O

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (dre ziouer)
    .tooltiptext = Ober gant an URL dre ziouer evit diskoulmañ an DNS war HTTPS

connection-dns-over-https-url-custom =
    .label = Personelaet
    .accesskey = P
    .tooltiptext = Enankit an URL a fell deoc'h implijout evit diskoulmañ HTTPS war DNS

connection-dns-over-https-custom-label = Personelaet
