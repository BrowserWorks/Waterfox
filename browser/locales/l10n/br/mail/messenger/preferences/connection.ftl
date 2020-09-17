# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dialog-window =
    .title = Arventennoù kennaskañ
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Kefluniañ proksioù evit mont war Internet

proxy-type-no =
    .label = Proksi ebet
    .accesskey = e

proxy-type-wpad =
    .label = EmZizoleiñ an arventennoù proksi evit ar rouedad-mañ
    .accesskey = Z

proxy-type-system =
    .label = Arverañ arventennoù proksi ar reizhiad
    .accesskey = A

proxy-type-manual =
    .label = Kefluniadur proksi dre zorn:
    .accesskey = z

proxy-http-label =
    .value = Proksi HTTP :
    .accesskey = H

http-port-label =
    .value = Porzh:
    .accesskey = P

ssl-port-label =
    .value = Porzh:
    .accesskey = o

proxy-socks-label =
    .value = Ostiz SOCKS :
    .accesskey = C

socks-port-label =
    .value = Porzh:
    .accesskey = h

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL kefluniañ emgefreek ar proksi:
    .accesskey = U

proxy-reload-label =
    .label = Adkargañ
    .accesskey = A

no-proxy-label =
    .value = Proksi ebet evit :
    .accesskey = b

no-proxy-example = Skouer : .mozilla.org, .net.nz, 192.168.1.0/24

proxy-password-prompt =
    .label = Na c'houlenn diganin en em zilesa ma'z eus ur ger-tremen enrollet
    .accesskey = i
    .tooltiptext = An dibarzh-mañ a zilesa ac'hanoc'h ent emgefreek war ar proksioù ma'z eus naoudioù kennaskañ enrollet evito. Goulennet e vo anezho diganeoc'h ma vez c'hwitet an dilesa.

proxy-remote-dns =
    .label = DNS Proksi p'eo arveret SOCKS v5
    .accesskey = D

proxy-enable-doh =
    .label = Enaouiñ an DNS e-plas HTTPS
    .accesskey = b
