# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Postavke konekcije
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Onemogući ekstenziju

connection-proxy-configure = Konfigurišite Proxy za pristup internetu

connection-proxy-option-no =
    .label = Nema proxyja
    .accesskey = y
connection-proxy-option-system =
    .label = Koristi sistemske proxy postavke
    .accesskey = K
connection-proxy-option-auto =
    .label = Auto-detektuj proxy postavke za ovu mrežu
    .accesskey = d
connection-proxy-option-manual =
    .label = Ručna konfiguracija proxy-a
    .accesskey = k

connection-proxy-http = HTTP Proxy
    .accesskey = x
connection-proxy-http-port = Port
    .accesskey = P

connection-proxy-ssl-port = Port
    .accesskey = o

connection-proxy-ftp = FTP Proxy
    .accesskey = F
connection-proxy-ftp-port = Port
    .accesskey = r

connection-proxy-socks = SOCKS Host
    .accesskey = C
connection-proxy-socks-port = Port
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Nema proxy-a za
    .accesskey = n

connection-proxy-noproxy-desc = Primjer: .mozilla.org, .net.nz, 192.168.1.0/24

connection-proxy-autotype =
    .label = Automatska konfiguracija proxy-a URL
    .accesskey = A

connection-proxy-reload =
    .label = Obnovi
    .accesskey = O

connection-proxy-autologin =
    .label = Ne pitaj za prijavu ako je lozinka spašena
    .accesskey = i
    .tooltip = Ova opcija vas neprimjetno prijavljuje na proxije kada imate spremljene njihove lozinke. Ako prijava ne uspije, bit ćete obaviješteni.

connection-proxy-socks-remote-dns =
    .label = Proxy DNS pri korištenju SOCKS v5
    .accesskey = d

