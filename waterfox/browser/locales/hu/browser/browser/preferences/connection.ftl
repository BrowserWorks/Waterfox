# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Kapcsolat beállításai
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Kiegészítő letiltása

connection-proxy-configure = Proxy beállítása az internet eléréséhez

connection-proxy-option-no =
    .label = Nincs proxy
    .accesskey = N
connection-proxy-option-system =
    .label = Rendszerbeállítások használata
    .accesskey = R
connection-proxy-option-auto =
    .label = Proxybeállítások automatikus felismerése a hálózatban
    .accesskey = b
connection-proxy-option-manual =
    .label = Kézi proxybeállítás
    .accesskey = z

connection-proxy-http = HTTP-proxy
    .accesskey = x
connection-proxy-http-port = Port
    .accesskey = P

connection-proxy-https-sharing =
    .label = Használja ezt a proxyt HTTPS esetén is
    .accesskey = S

connection-proxy-https = HTTPS-proxy
    .accesskey = H
connection-proxy-ssl-port = Port
    .accesskey = o

connection-proxy-socks = SOCKS gép
    .accesskey = C
connection-proxy-socks-port = Port
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = 5
connection-proxy-noproxy = Nincs proxy a következőhöz
    .accesskey = v

connection-proxy-noproxy-desc = Példa: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = A localhost, a 127.0.0.1/8, és a ::1 felé nyitott kapcsolatok sosem kerülnek proxyzásra.

connection-proxy-autotype =
    .label = Automatikus proxybeállítás URL
    .accesskey = A

connection-proxy-reload =
    .label = Frissítés
    .accesskey = i

connection-proxy-autologin =
    .label = Ne kérjen hitelesítést, ha a jelszó el van mentve
    .accesskey = h
    .tooltip = Ez a beállítás csendben hitelesíti proxyk felé, ha mentette hozzájuk a hitelesítési adatokat. Ha a hitelesítés sikertelen, akkor felszólítást kap.

connection-proxy-socks-remote-dns =
    .label = DNS proxyzása SOCKS v5 használatakor
    .accesskey = d

connection-dns-over-https =
    .label = HTTPS-en keresztüli DNS engedélyezése
    .accesskey = H

connection-dns-over-https-url-resolver = Szolgáltató használata
    .accesskey = o

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (alapértelmezett)
    .tooltiptext = Az alapértelmezett URL használata a HTTPS feletti DNS feloldáshoz

connection-dns-over-https-url-custom =
    .label = Egyéni
    .accesskey = E
    .tooltiptext = Adja meg az előnyben részesített URL-t a HTTPS feletti DNS feloldáshoz

connection-dns-over-https-custom-label = Egyéni
