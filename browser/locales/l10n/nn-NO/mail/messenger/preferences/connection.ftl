# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Bruk leverandør
    .accesskey = r

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (standard)
    .tooltiptext = Bruk standardadressa for DNS-oppslag over HTTPS

connection-dns-over-https-url-custom =
    .label = Tilpassa
    .accesskey = T
    .tooltiptext = Spesifiser føretrekt nettadresse for DNS-oppslag over HTTPS

connection-dns-over-https-custom-label = Tilpassa

connection-dialog-window =
    .title = Tilkoplingsinnstillingar
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Konfigurer mellomtenarar for tilgang til Internett

proxy-type-no =
    .label = Ingen mellomtenar
    .accesskey = I

proxy-type-wpad =
    .label = Automatisk oppdag mellomtenarinnstillingar
    .accesskey = A

proxy-type-system =
    .label = Bruk systeminnstillingar
    .accesskey = B

proxy-type-manual =
    .label = Manuelle mellomtenarinnstillingar:
    .accesskey = M

proxy-http-label =
    .value = HTTP:
    .accesskey = H

http-port-label =
    .value = Port:
    .accesskey = P

proxy-http-sharing =
    .label = Bruk også denne proxyserveren for HTTPS
    .accesskey = x

proxy-https-label =
    .value = HTTPS-proxy:
    .accesskey = S

ssl-port-label =
    .value = Port:
    .accesskey = o

proxy-socks-label =
    .value = SOCKS-vert:
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
    .label = Automatisk konfigurasjonsadresse:
    .accesskey = A

proxy-reload-label =
    .label = Oppdater
    .accesskey = O

no-proxy-label =
    .value = Ingen MT for:
    .accesskey = n

no-proxy-example = Døme: .mozilla.org, .net.nz, 192.168.1.0/24

proxy-password-prompt =
    .label = Ikkje be om autentisering viss passordet er lagra
    .accesskey = i
    .tooltiptext = Dette alternativet stadfestar deg, i det stille, til proxiar når du har lagra innloggingsdetaljar for dei. Du vil få spørsmål om godkjenninga er mislykka.

proxy-remote-dns =
    .label = Proxy-DNS når du brukar SOCKS v5
    .accesskey = D

proxy-enable-doh =
    .label = Aktiver DNS-over-HTTPS
    .accesskey = o
