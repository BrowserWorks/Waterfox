# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Iisetingi zonxibelelwano
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-proxy-option-no =
    .label = Akukho proksi
    .accesskey = A
connection-proxy-option-system =
    .label = Sebenzisa iisethingi zeproksi yekhompyutha
    .accesskey = S
connection-proxy-option-auto =
    .label = Ukuzifumanela iisethingi zeproksi yale nethiwekhi
    .accesskey = w

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v

connection-proxy-noproxy-desc = Umzekelo: .mozilla.org, .net.nz, 192.168.1.0/24

connection-proxy-reload =
    .label = Khuphela kwakhona
    .accesskey = u

connection-proxy-autologin =
    .label = Musa ukuyalela imfezeko ukuba ipasiwedi igciniwe
    .accesskey = z
    .tooltip = Ekunokukhethwa kuko kukufezekisa ngenzolo kwiiproksi xa ugcine iikhridenshali zazo. Uya kuyalelwa ukuba imfezeko ayiphumelelanga.

connection-proxy-socks-remote-dns =
    .label = I-DNS yeproksi xa usebenzisa iSOCKS v5
    .accesskey = d

