# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Tokisäx Ya'öl
    .accesskey = l

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (K'o wi)
    .tooltiptext = Takusaj k'o wi URL richin tisol ri DNS pa ruwi' HTTPS

connection-dns-over-https-url-custom =
    .label = Ichinan
    .accesskey = I
    .tooltiptext = Tatz'ib'aj ri URL nawajo' richin nisol DNS chi rij HTTPS

connection-dns-over-https-custom-label = Ichinan

connection-dialog-window =
    .title = Runuk'ulem okem pa k'amaya'l
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Tinuk'samajïx ri taq proxi richin yatok pa k'amaya'l

proxy-type-no =
    .label = Majun proxi
    .accesskey = i

proxy-type-wpad =
    .label = Pa ruyonil trïl runuk'ulem ri proxi richin re k'amab'ey re'
    .accesskey = b

proxy-type-system =
    .label = Tawokisaj ri runuk'ulem ruproxi q'inoj
    .accesskey = o

proxy-type-manual =
    .label = Tanuk'samajij retamawuj proxi:
    .accesskey = r

proxy-http-label =
    .value = HTTP Proxi:
    .accesskey = h

http-port-label =
    .value = B'ey:
    .accesskey = b

ssl-port-label =
    .value = B'ey:
    .accesskey = e

proxy-socks-label =
    .value = SOCKS K'uxasamaj:
    .accesskey = c

socks-port-label =
    .value = B'ey:
    .accesskey = y

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL richin runuk'ulem pa ruyonil ri proxi:
    .accesskey = y

proxy-reload-label =
    .label = Tisamajib'ëx chik
    .accesskey = j

no-proxy-label =
    .value = Manjun Proxi richin:
    .accesskey = n

no-proxy-example = Tz'eteb'äl: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Taq okem pa localhost, 127.0.0.1, chuqa' ::1 majub'ey nik'o pa proxi.

proxy-password-prompt =
    .label = Mani tik'utüx rujikib'axik we yakon ri ewan tzij
    .accesskey = j
    .tooltiptext = Re jun cha'oj re' nuya' awetal eqal chi kiwäch ri taq proxi toq e'ayakon kan taq awujil kichin rije'. Xakasik'ïx we ri ruya'ik awetal nisach.

proxy-remote-dns =
    .label = K'exel DNS toq nawokisaj SOCKS v5
    .accesskey = d

proxy-enable-doh =
    .label = Titzij DNS chuwäch HTTPS
    .accesskey = j
