# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Nastavení připojení
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Zakázat rozšíření

connection-proxy-configure = Nastavení proxy serverů pro přístup k internetu

connection-proxy-option-no =
    .label = Bez proxy serveru
    .accesskey = y
connection-proxy-option-system =
    .label = Použít nastavení proxy serverů v systému
    .accesskey = u
connection-proxy-option-auto =
    .label = Automatické zjištění konfigurace proxy serverů
    .accesskey = A
connection-proxy-option-manual =
    .label = Ruční konfigurace proxy serverů
    .accesskey = k

connection-proxy-http = HTTP proxy
    .accesskey = H
connection-proxy-http-port = Port
    .accesskey = p

connection-proxy-https-sharing =
    .label = Použít tento proxy server také pro HTTPS
    .accesskey = s

connection-proxy-https = HTTPS proxy
    .accesskey = H
connection-proxy-ssl-port = Port
    .accesskey = o

connection-proxy-socks = SOCKS server
    .accesskey = C
connection-proxy-socks-port = Port
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = 4
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = 5
connection-proxy-noproxy = Nepoužívat pro
    .accesskey = N

connection-proxy-noproxy-desc = Příklad: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Spojení na localhost, 127.0.0.1/8 a ::1 nikdy proxy servery nepoužívají.

connection-proxy-autotype =
    .label = URL adresa pro automatickou konfiguraci proxy serverů
    .accesskey = m

connection-proxy-reload =
    .label = Znovu načíst
    .accesskey = o

connection-proxy-autologin =
    .label = Nedotazovat se na autentizaci, pokud je heslo uloženo
    .accesskey = e
    .tooltip = Tato volba zajistí provedení tiché autentizace k proxy, pokud pro ni máte uloženy přihlašovací údaje. Pokud autentizace selže, budete na ně dotázání.

connection-proxy-socks-remote-dns =
    .label = Použít proxy server pro DNS při použití SOCKS v5
    .accesskey = d

connection-dns-over-https =
    .label = Zapnout DNS over HTTPS
    .accesskey = H

connection-dns-over-https-url-resolver = Poskytovatel
    .accesskey = P

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (výchozí)
    .tooltiptext = Použít výchozí URL adresu pro službu DNS over HTTPS

connection-dns-over-https-url-custom =
    .label = Vlastní
    .accesskey = n
    .tooltiptext = Zadejte vlastní URL adresu pro službu DNS over HTTPS

connection-dns-over-https-custom-label = Vlastní URL
