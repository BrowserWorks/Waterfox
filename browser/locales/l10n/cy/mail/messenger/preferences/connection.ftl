# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Defnyddio Darparwr
    .accesskey = D

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Rhagosodiad)
    .tooltiptext = Defnyddiwch yr URL rhagosodedig ar gyfer datrys DNS dros HTTPS

connection-dns-over-https-url-custom =
    .label = Cyfaddas
    .accesskey = C
    .tooltiptext = Rhowch eich hoff URL er mwyn datrys DNS drod HTTPS

connection-dns-over-https-custom-label = Cyfaddas

connection-dialog-window =
    .title = Gosodiadau Cysylltu
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Ffurfweddu'r Dirprwyon i Gael Mynediad i'r Rhyngrwyd

proxy-type-no =
    .label = Dim dirprwy
    .accesskey = D

proxy-type-wpad =
    .label = Awtoganfod gosodiadau dirprwyol ar gyfer y rhwydwaith
    .accesskey = w

proxy-type-system =
    .label = Defnyddio gosodiadau dirprwyol y system
    .accesskey = e

proxy-type-manual =
    .label = Ffurfweddiad dirprwy gyda llaw:
    .accesskey = F

proxy-http-label =
    .value = Dirprwy yr HTTP:
    .accesskey = H

http-port-label =
    .value = Porth:
    .accesskey = P

proxy-http-sharing =
    .label = Defnyddiwch y dirprwy yma hefyd ar gyfer HTTPS
    .accesskey = x

proxy-https-label =
    .value = Dirprwy HTTPS:
    .accesskey = S

ssl-port-label =
    .value = Porth:
    .accesskey = o

proxy-socks-label =
    .value = Gwesteiwr SOCKS:
    .accesskey = C

socks-port-label =
    .value = Porth:
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL ffurfweddu dirprwy yn awtomatig:
    .accesskey = U

proxy-reload-label =
    .label = Ail-lwytho
    .accesskey = l

no-proxy-label =
    .value = Dim Dirprwy ar gyfer:
    .accesskey = m

no-proxy-example = Esiampl: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Nid yw cysylltiadau i localhost, 127.0.0.1, a ::1 byth yn cael eu dirprwyo.

proxy-password-prompt =
    .label = Peidio gofyn am ddilysiad os yw'r cyfrinair wedi ei gadw
    .accesskey = d
    .tooltiptext = Mae'r dewis hwn yn eich dilysu'n dawel i ddirprwyon rydych wedi eu cadw eu manylion ar eu cyfer. Byddwn yn gofyn os bydd y dilysiad yn methu.

proxy-remote-dns =
    .label = DNS dirprwyol pan y defnyddio SOCKS v5
    .accesskey = D

proxy-enable-doh =
    .label = Galluogi DNS dros HTTPS
    .accesskey = G
