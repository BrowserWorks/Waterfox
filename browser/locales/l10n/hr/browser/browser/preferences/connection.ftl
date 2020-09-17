# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Postavke spajanja
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }
connection-close-key =
    .key = w
connection-disable-extension =
    .label = Onemogući dodatak
connection-proxy-configure = Podesi proxy za pristup Internetu
connection-proxy-option-no =
    .label = Bez proxyja
    .accesskey = y
connection-proxy-option-system =
    .label = Koristi sistemske postavke za proxy
    .accesskey = s
connection-proxy-option-auto =
    .label = Automatski pronađi postavke za ovu mrežu
    .accesskey = t
connection-proxy-option-manual =
    .label = Ručno podešavanje proxyja
    .accesskey = x
connection-proxy-http = HTTP Proxy
    .accesskey = H
connection-proxy-http-port = Port
    .accesskey = U
connection-proxy-http-sharing =
    .label = Koristi ovaj proxy i za FTP i HTTPS
    .accesskey = v
connection-proxy-https = HTTPS proxy
    .accesskey = H
connection-proxy-ssl-port = Port
    .accesskey = l
connection-proxy-ftp = FTP Proxy
    .accesskey = F
connection-proxy-ftp-port = Port
    .accesskey = a
connection-proxy-socks = SOCKS domaćin
    .accesskey = C
connection-proxy-socks-port = Port
    .accesskey = z
connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Bez proxyja za
    .accesskey = z
connection-proxy-noproxy-desc = Primjer: .mozilla.org, .net.nz, 192.168.1.0/24
# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Veze s localhost, 127.0.0.1 i ::1 nikada nisu preko proxy.
connection-proxy-autotype =
    .label = URL za automatsko podešavanje proxyja
    .accesskey = a
connection-proxy-reload =
    .label = Učitaj ponovo
    .accesskey = a
connection-proxy-autologin =
    .label = Ne pitaj za prijavu ako je lozinka spremljena
    .accesskey = i
    .tooltip = Ova opcija vas neprimjetno prijavljuje na proxije kada imate spremljene njihove lozinke. Ako prijava ne uspije, bit ćete obaviješteni.
connection-proxy-socks-remote-dns =
    .label = Proxy DNS kada se koristi SOCKS v5
    .accesskey = d
connection-dns-over-https =
    .label = Aktiviraj DNS preko HTTPS
    .accesskey = O
connection-dns-over-https-url-resolver = Koristi pružatelja usluge
    .accesskey = p
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (standardno)
    .tooltiptext = Koristi standardni URL za rješavanje DNS-a preko HTTPS-a
connection-dns-over-https-url-custom =
    .label = Prilagođeno
    .accesskey = o
    .tooltiptext = Unesite vaš preferirani URL za rješavanje DNS preko HTTPS
connection-dns-over-https-custom-label = Prilagođeno
