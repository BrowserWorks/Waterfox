# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Póbitowarja wužywaś
    .accesskey = b

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (standard)
    .tooltiptext = Standardny URL za rozpušćenje DNS pśez HTTPS wužywaś

connection-dns-over-https-url-custom =
    .label = Swójski
    .accesskey = S
    .tooltiptext = Zapodajće swój preferowany URL za rozpušćenje DNS přez HTTPS

connection-dns-over-https-custom-label = Swójski

connection-dialog-window =
    .title = Zwiskowe nastajenja
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Proksy za pśistup k internetoju konfigěrurowaś

proxy-type-no =
    .label = Žeden proksy
    .accesskey = y

proxy-type-wpad =
    .label = Nastajenja proksy za toś tu seś awtomatiski namakaś
    .accesskey = N

proxy-type-system =
    .label = Systemowe nastajenja proksy wužywaś
    .accesskey = S

proxy-type-manual =
    .label = Manuelna konfiguracija proksy:
    .accesskey = M

proxy-http-label =
    .value = HTTP-Proksy:
    .accesskey = H

http-port-label =
    .value = Port:
    .accesskey = P

proxy-http-sharing =
    .label = Teke toś ten proksy za HTTPS wužywaś
    .accesskey = k

proxy-https-label =
    .value = HTTPS-proksy:
    .accesskey = S

ssl-port-label =
    .value = Port:
    .accesskey = o

proxy-socks-label =
    .value = SOCKS Host:
    .accesskey = C

socks-port-label =
    .value = Port:
    .accesskey = r

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL awtomatiskeje proksy-konfiguracije:
    .accesskey = U

proxy-reload-label =
    .label = Znowego
    .accesskey = Z

no-proxy-label =
    .value = Žeden proksy za:
    .accesskey = d

no-proxy-example = Pśikład: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Zwiski z localhost, 127.0.0.1 a ::1 nigda pśez proksy njejdu.

proxy-password-prompt =
    .label = Za awtentificěrowanim se njepšašaś, jolic gronidło jo składowane
    .accesskey = i
    .tooltiptext = Toś to nastajenje awtentificěrujo was w slězynje pla proksyjow, gaž sćo pśizjwjańske daty za nje składował. Dostanjośo informaciju, jolic se awtentificěrowanje njeraźijo.

proxy-remote-dns =
    .label = Proksy-DNS, gaž se SOCKS v5 wužywa
    .accesskey = D

proxy-enable-doh =
    .label = DNS pśez HTTPS zmóžniś
    .accesskey = m
