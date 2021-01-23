# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Koristi pružatelja usluga
    .accesskey = r

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (zadano)
    .tooltiptext = Koristi zadani URL za DNS preko HTTPS

connection-dns-over-https-url-custom =
    .label = Zadano
    .accesskey = Z
    .tooltiptext = Unesite željeni URL za DNS preko HTTPS

connection-dns-over-https-custom-label = Zadano

connection-dialog-window =
    .title = Postavke spajanja
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Podesite proxy za pristupanje Internetu

proxy-type-no =
    .label = Bez proxyja
    .accesskey = y

proxy-type-wpad =
    .label = Automatski pronađi proxy postavke za ovu mrežu
    .accesskey = t

proxy-type-system =
    .label = Koristi sistemske postavke za proxy
    .accesskey = s

proxy-type-manual =
    .label = Ručno podešavanje proxyja:
    .accesskey = x

proxy-http-label =
    .value = HTTP Proxy:
    .accesskey = H

http-port-label =
    .value = Port:
    .accesskey = P

proxy-http-sharing =
    .label = Koristi ovaj proxy i za HTTPS
    .accesskey = k

proxy-https-label =
    .value = HTTPS proxy:
    .accesskey = S

ssl-port-label =
    .value = Port:
    .accesskey = o

proxy-socks-label =
    .value = SOCKS poslužitelj:
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
    .label = URL za automatsko podešavanje proxyja:
    .accesskey = a

proxy-reload-label =
    .label = Ponovno učitaj
    .accesskey = j

no-proxy-label =
    .value = Bez proxyja za:
    .accesskey = z

no-proxy-example = Primjer: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Veze s localhost, 127.0.0.1 i ::1 nikada nisu preko proxy.

proxy-password-prompt =
    .label = Ne pitaj za prijavu ukoliko je lozinka spremljena
    .accesskey = i
    .tooltiptext = Ova mogućnost vas tiho prijavi na proxy ukoliko imate spremljene lozinke za njih. Biti ćete obaviješteni ukoliko prijava nije uspješna.

proxy-remote-dns =
    .label = Proxy DNS ukoliko se koristi SOCKS v5
    .accesskey = d

proxy-enable-doh =
    .label = Omogući DNS preko HTTPS
    .accesskey = D
