# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
    .accesskey = w

proxy-type-system =
    .label = Koristi sistemske postavke za proxy
    .accesskey = u

proxy-type-manual =
    .label = Ručno podešavanje proxyja:
    .accesskey = m

proxy-http-label =
    .value = HTTP Proxy:
    .accesskey = h

http-port-label =
    .value = Port:
    .accesskey = p

ssl-port-label =
    .value = Port:
    .accesskey = o

proxy-socks-label =
    .value = SOCKS Host:
    .accesskey = c

socks-port-label =
    .value = Port:
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL za automatsko podešavanje proxyja:
    .accesskey = A

proxy-reload-label =
    .label = Ponovo učitaj
    .accesskey = l

no-proxy-label =
    .value = Bez proxyja za:
    .accesskey = n

no-proxy-example = Primjer: .mozilla.org, .net.nz, 192.168.1.0/24

proxy-password-prompt =
    .label = Ne pitaj za prijavu ukoliko je lozinka sačuvana
    .accesskey = i
    .tooltiptext = Ova mogućnost vas tiho prijavi na proxy ukoliko imate sačuvane lozinke za njih. Biti ćete obaviješteni ukoliko prijava nije uspješna.

proxy-remote-dns =
    .label = Proxy DNS ukoliko se koristi SOCKS v5
    .accesskey = d

