# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Ühenduse sätted
    .style =
        { PLATFORM() ->
            [macos] width: 48em
           *[other] width: 53em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Keela see laiendus

connection-proxy-configure = Interneti puhverserveri häälestamine

connection-proxy-option-no =
    .label = Internetti ühendutakse otse
    .accesskey = I
connection-proxy-option-system =
    .label = Kasutatakse süsteemi puhverserveri sätteid
    .accesskey = K
connection-proxy-option-auto =
    .label = Puhverserveri sätted tuvastatakse automaatselt
    .accesskey = s
connection-proxy-option-manual =
    .label = Puhverserveri sätted määratakse käsitsi
    .accesskey = P

connection-proxy-http = HTTP-puhverserver
    .accesskey = H
connection-proxy-http-port = Port
    .accesskey = r

connection-proxy-ssl-port = Port
    .accesskey = o

connection-proxy-ftp = FTP-puhverserver
    .accesskey = F
connection-proxy-ftp-port = Port
    .accesskey = t

connection-proxy-socks = SOCKS masin
    .accesskey = C
connection-proxy-socks-port = Port
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = V
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = 5
connection-proxy-noproxy = Erandid
    .accesskey = n

connection-proxy-noproxy-desc = Näide: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = localhosti, 127.0.0.1 ja ::1 peale suunduvaid ühendusi ei suunata kunagi läbi puhverserveri.

connection-proxy-autotype =
    .label = Puhverserveri automaatse häälestuse URL
    .accesskey = a

connection-proxy-reload =
    .label = Laadi uuesti
    .accesskey = d

connection-proxy-autologin =
    .label = Salvestatud paroolide korral autentimist ei küsita
    .accesskey = v
    .tooltip = Selle valiku korral autenditakse sind automaatselt puhverserveritega, mille parool on salvestatud. Parooli küsitakse juhul, kui autentimine ebaõnnestub.

connection-proxy-socks-remote-dns =
    .label = Puhverserveri DNS, kui kasutusel on SOCKS v5
    .accesskey = e

connection-dns-over-https =
    .label = Lubatakse DNS üle HTTPSi
    .accesskey = D

connection-dns-over-https-url-resolver = Teenusepakkuja
    .accesskey = j

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (vaikimisi)
    .tooltiptext = Kasuta nimede lahendamiseks üle HTTPSi vaikimisi URLi

connection-dns-over-https-url-custom =
    .label = kohandatud
    .accesskey = k
    .tooltiptext = Sisesta üle HTTPSi töötava DNSi jaoks oma eelistatud URL

connection-dns-over-https-custom-label = Kohandatud
