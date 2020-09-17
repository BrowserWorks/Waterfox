# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Teenusepakkuja
    .accesskey = T

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (vaikimisi)
    .tooltiptext = Kasuta üle HTTPSi töötava DNSi puhul vaikeaadressi

connection-dns-over-https-url-custom =
    .label = kohandatud
    .accesskey = o
    .tooltiptext = Sisesta üle HTTPSi töötava DNSi jaoks oma eelistatud URL

connection-dns-over-https-custom-label = Kohandatud

connection-dialog-window =
    .title = Ühenduse sätted
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Puhverserverite häälestamine internetti pääsemiseks

proxy-type-no =
    .label = Puhverserver puudub
    .accesskey = P

proxy-type-wpad =
    .label = Puhverserveri sätted tuvastatakse automaatselt
    .accesskey = h

proxy-type-system =
    .label = Kasutatakse süsteemseid puhverserveri sätteid
    .accesskey = u

proxy-type-manual =
    .label = Puhverserveri häälestamine käsitsi:
    .accesskey = K

proxy-http-label =
    .value = HTTP:
    .accesskey = H

http-port-label =
    .value = Port:
    .accesskey = P

ssl-port-label =
    .value = Port:
    .accesskey = o

proxy-socks-label =
    .value = SOCKS masin:
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
    .label = Puhverserveri automaatse häälestuse URL:
    .accesskey = a

proxy-reload-label =
    .label = Laadi uuesti
    .accesskey = L

no-proxy-label =
    .value = Erandid:
    .accesskey = d

no-proxy-example = Näide: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = localhosti, 127.0.0.1 ja ::1 peale suunduvaid ühendusi ei suunata kunagi läbi puhverserveri.

proxy-password-prompt =
    .label = Salvestatud paroolide korral autentimist ei küsita
    .accesskey = r
    .tooltiptext = Selle valiku korral autenditakse sind automaatselt puhverserveritega, mille parool on salvestatud. Parooli küsitakse juhul, kui autentimine ebaõnnestub.

proxy-remote-dns =
    .label = Puhverserveri DNS, kui kasutusel on SOCKS v5
    .accesskey = D

proxy-enable-doh =
    .label = Lubatakse DNS üle HTTPSi
    .accesskey = D
