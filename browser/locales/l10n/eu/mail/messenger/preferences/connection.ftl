# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Erabili hornitzailea
    .accesskey = h

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name }(lehenetsia)
    .tooltiptext = Erabili URL lehenetsia HTTPSn DNSak ebazteko

connection-dns-over-https-url-custom =
    .label = Pertsonalizatua
    .accesskey = P
    .tooltiptext = Sartu zure gogoko URL HTTPSn DNSak ebazteko

connection-dns-over-https-custom-label = Pertsonalizatua

connection-dialog-window =
    .title = Konexio-ezarpenak
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Konfiguratu Internet atzitzeko proxy-ak

proxy-type-no =
    .label = Proxy-rik ez
    .accesskey = y

proxy-type-wpad =
    .label = Automatikoki detektatu sare honetako proxy-ezarpenak
    .accesskey = s

proxy-type-system =
    .label = Erabili sistemaren proxy-ezarpenak
    .accesskey = E

proxy-type-manual =
    .label = Eskuzko proxy-konfigurazioa:
    .accesskey = s

proxy-http-label =
    .value = HTTP proxy-a:
    .accesskey = H

http-port-label =
    .value = Ataka:
    .accesskey = k

proxy-http-sharing =
    .label = Erabili proxy hau HTTPS protokoloarentzat ere bai
    .accesskey = x

proxy-https-label =
    .value = HTTP proxy-a:
    .accesskey = S

ssl-port-label =
    .value = Ataka:
    .accesskey = A

proxy-socks-label =
    .value = SOCKS ostalaria:
    .accesskey = C

socks-port-label =
    .value = Ataka:
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = Proxy-aren konfigurazio automatikoko URLa:
    .accesskey = a

proxy-reload-label =
    .label = Berritu
    .accesskey = B

no-proxy-label =
    .value = Proxy-rik ez hauentzat:
    .accesskey = n

no-proxy-example = Adibidez: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = localhost, 127.0.0.1 eta ::1 helbideetarako konexioak inoiz ez dira proxy bidez egiten.

proxy-password-prompt =
    .label = Ez eskatu autentifikaziorik pasahitza gordeta badago
    .accesskey = i
    .tooltiptext = Aukera honek proxietarako autentifikazioa isilean burutzen du hauentzat kredentzialak gorde dituzunean. Autentifikazioak huts egiten badu, eskatu egingo zaizu.

proxy-remote-dns =
    .label = Bideratu DNSa proxy bidez SOCKS v5 erabiltzean
    .accesskey = d

proxy-enable-doh =
    .label = Gaitu HTTPS gaineko DNSa
    .accesskey = b
