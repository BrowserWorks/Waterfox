# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Použiť poskytovateľa
    .accesskey = s

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (predvolený)
    .tooltiptext = Použiť predvolenú URL pre DNS cez HTTPS

connection-dns-over-https-url-custom =
    .label = Vlastný
    .accesskey = V
    .tooltiptext = Zadajte svoju preferovanú URL pre DNS cez HTTPS

connection-dns-over-https-custom-label = Vlastný

connection-dialog-window =
    .title = Nastavenie pripojenia
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Nastavenie serverov proxy pre prístup k sieti Internet

proxy-type-no =
    .label = Nepoužívať server proxy
    .accesskey = e

proxy-type-wpad =
    .label = Automatická detekcia nastavení tejto siete
    .accesskey = d

proxy-type-system =
    .label = Použiť systémové nastavenia serverov proxy
    .accesskey = m

proxy-type-manual =
    .label = Ručné nastavenie serverov proxy:
    .accesskey = u

proxy-http-label =
    .value = Server proxy HTTP:
    .accesskey = H

http-port-label =
    .value = Port:
    .accesskey = t

proxy-http-sharing =
    .label = Použiť tento server proxy aj pre HTTPS
    .accesskey = x

proxy-https-label =
    .value = Server proxy HTTPS:
    .accesskey = S

ssl-port-label =
    .value = Port:
    .accesskey = o

proxy-socks-label =
    .value = Server SOCKS:
    .accesskey = C

socks-port-label =
    .value = Port:
    .accesskey = P

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = Adresa URL pre automatické nastavenie serverov proxy:
    .accesskey = A

proxy-reload-label =
    .label = Obnoviť
    .accesskey = b

no-proxy-label =
    .value = Nepoužívať proxy pre:
    .accesskey = N

no-proxy-example = Príklad: .mozilla.org, .net.nz

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Pripojenie na localhost, 127.0.0.1 a ::1 nikdy proxy servery nepoužívajú.

proxy-password-prompt =
    .label = Nevyžadovať zadanie autorizačných údajov, ak ich má prehliadač uložené
    .accesskey = i
    .tooltiptext = Vďaka tejto možnosti sa prehliadač automaticky autorizuje na serveri proxy, ak má preň uložené prihlasovanie údaje. Ak autorizácia zlyhá, prehliadač o údaje požiada.

proxy-remote-dns =
    .label = Použiť server proxy pre DNS pri použití SOCKS v5
    .accesskey = r

proxy-enable-doh =
    .label = Zapnúť DNS cez HTTPS
    .accesskey = p
