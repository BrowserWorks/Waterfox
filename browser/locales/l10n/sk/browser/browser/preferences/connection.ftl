# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Nastavenie pripojenia
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Zakázať rozšírenie

connection-proxy-configure = Nastavenie servera proxy pre prístup k internetu

connection-proxy-option-no =
    .label = Nepoužívať server proxy
    .accesskey = e
connection-proxy-option-system =
    .label = Použiť systémové nastavenia serverov proxy
    .accesskey = m
connection-proxy-option-auto =
    .label = Automatická detekcia nastavení tejto siete
    .accesskey = d
connection-proxy-option-manual =
    .label = Ručné nastavenie serverov proxy
    .accesskey = n

connection-proxy-http = Server proxy HTTP
    .accesskey = x
connection-proxy-http-port = Port
    .accesskey = t

connection-proxy-http-sharing =
    .label = Použiť tento server proxy pre FTP aj pre HTTPS
    .accesskey = s

connection-proxy-https = Server proxy HTTPS
    .accesskey = H
connection-proxy-ssl-port = Port
    .accesskey = o

connection-proxy-ftp = Server proxy pre FTP
    .accesskey = F
connection-proxy-ftp-port = Port
    .accesskey = r

connection-proxy-socks = Server SOCKS
    .accesskey = C
connection-proxy-socks-port = Port
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Nepoužívať proxy pre
    .accesskey = N

connection-proxy-noproxy-desc = Príklad: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Pripojenie na localhost, 127.0.0.1, and ::1 nikdy proxy servery nepoužívajú.

connection-proxy-autotype =
    .label = Adresa URL pre automatické nastavenie serverov proxy
    .accesskey = A

connection-proxy-reload =
    .label = Obnoviť
    .accesskey = b

connection-proxy-autologin =
    .label = Nevyžadovať autorizáciu, ak je heslo uložené
    .accesskey = z
    .tooltip = Vďaka tejto možnosti sa prehliadač automaticky autorizuje na serveri proxy, ak má preň uložené prihlasovanie údaje. Ak autorizácia zlyhá, prehliadač o údaje požiada.

connection-proxy-socks-remote-dns =
    .label = Použiť server proxy pre DNS pri použití SOCKS v5
    .accesskey = u

connection-dns-over-https =
    .label = Zapnúť DNS cez HTTPS
    .accesskey = Z

connection-dns-over-https-url-resolver = Poskytovateľ
    .accesskey = P

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (predvolené)
    .tooltiptext = Použiť predvolenú URL pre DNS cez HTTPS

connection-dns-over-https-url-custom =
    .label = Vlastná
    .accesskey = V
    .tooltiptext = Zadajte svoju preferovanú URL adresu pre DNS cez HTTPS

connection-dns-over-https-custom-label = Vlastná
