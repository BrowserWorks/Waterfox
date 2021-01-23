# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Poskićowarja wužiwać
    .accesskey = o

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (standard)
    .tooltiptext = Standardny URL za rozpušćenje DNS přez HTTPS wužiwać

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

connection-proxy-legend = Proksy za přistup k internetej konfigurować

proxy-type-no =
    .label = Žadyn proksy
    .accesskey = a

proxy-type-wpad =
    .label = Nastajenja proksy za tutu syć awtomatisce wotkryć
    .accesskey = w

proxy-type-system =
    .label = Systemowe proksynastajenja wužiwać
    .accesskey = S

proxy-type-manual =
    .label = Manuelna proksykonfiguracija:
    .accesskey = M

proxy-http-label =
    .value = HTTP-Proksy:
    .accesskey = H

http-port-label =
    .value = Port:
    .accesskey = P

proxy-http-sharing =
    .label = Tež tutón proksy za HTTPS wužiwać
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
    .label = URL awtomatiskeje proksykonfiguracije:
    .accesskey = L

proxy-reload-label =
    .label = Znowa začitać
    .accesskey = Z

no-proxy-label =
    .value = Žadyn proksy za:
    .accesskey = d

no-proxy-example = Přikład: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Zwiski z localhost, 127.0.0.1 a ::1 ženje přez proksy njeńdu.

proxy-password-prompt =
    .label = Za awtentifikaciju so njeprašeć, jeli hesło je składowane
    .accesskey = i
    .tooltiptext = Tute nastajenje awtentizuje was w pozadku pola proksyjow, hdyž sće přizjwjenske daty za nje składował. Dóstanjeće informaciju, hdyž so awtentifikacija njeporadźi.

proxy-remote-dns =
    .label = Proksy-DNS, hdyž so SOCKS v5 wužiwa
    .accesskey = D

proxy-enable-doh =
    .label = DNS přez HTTPS zmóžnić
    .accesskey = m
