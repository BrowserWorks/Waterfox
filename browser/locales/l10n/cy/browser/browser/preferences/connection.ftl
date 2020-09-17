# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Gosodiadau Cysylltu
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Analluogi Estyniad

connection-proxy-configure = Ffurfweddu Mynediad Dirprwy i'r Rhyngrwyd

connection-proxy-option-no =
    .label = Dim dirprwy
    .accesskey = D
connection-proxy-option-system =
    .label = Defnyddio gosodiadau dirprwyol y system
    .accesskey = g
connection-proxy-option-auto =
    .label = Awto-ganfod gosodiadau dirprwyol ar gyfer y rhwydwaith
    .accesskey = r
connection-proxy-option-manual =
    .label = Ffurfweddiad dirprwyo â llaw
    .accesskey = l

connection-proxy-http = Dirprwy yr HTTP
    .accesskey = H
connection-proxy-http-port = Porth
    .accesskey = P

connection-proxy-http-sharing =
    .label = Defnyddiwch y dirprwy yma hefyd ar gyfer FTP a HTTPS
    .accesskey = d

connection-proxy-https = Dirprwy HTTPS:
    .accesskey = D
connection-proxy-ssl-port = Porth
    .accesskey = o

connection-proxy-ftp = Dirprwy FTP
    .accesskey = F
connection-proxy-ftp-port = Porth
    .accesskey = r

connection-proxy-socks = Gwesteiwr SOCKS v5
    .accesskey = G
connection-proxy-socks-port = Porth
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Dim Dirprwy ar gyfer
    .accesskey = m

connection-proxy-noproxy-desc = Esiampl: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Nid yw cysylltiadau i localhost, 127.0.0.1, a ::1 byth yn cael eu cirprwyo.

connection-proxy-autotype =
    .label = URL ffurfweddu dirprwy yn awtomatig
    .accesskey = U

connection-proxy-reload =
    .label = Ail-lwytho
    .accesskey = i

connection-proxy-autologin =
    .label = Peidio gofyn am ddilysiad os yw'r cyfrinair wedi ei gadw
    .accesskey = d
    .tooltip = Mae'r dewis hwn yn eich dilysu'n dawel i ddirprwyon rydych wedi eu cadw eu manylion ar eu cyfer. Byddwn yn gofyn os bydd y dilysiad yn methu.

connection-proxy-socks-remote-dns =
    .label = DNS dirprwyol wrth ddefnyddio SOCKS v5
    .accesskey = d

connection-dns-over-https =
    .label = Galluogi DNS dros HTTPS
    .accesskey = D

connection-dns-over-https-url-resolver = Defnyddio'r Darparwr
    .accesskey = D

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } Rhagosodedig
    .tooltiptext = Defnyddiwch yr URL rhagosodedig i ddatrys DNS dros HTTPS

connection-dns-over-https-url-custom =
    .label = Cyfaddasu
    .accesskey = C
    .tooltiptext = Rhowch eich hoff URL ar gyfer datrys DNS dros HTTPS

connection-dns-over-https-custom-label = Cyfaddas
