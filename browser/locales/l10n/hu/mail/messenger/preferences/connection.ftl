# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Szolgáltató használata
    .accesskey = o
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Alapértelmezett)
    .tooltiptext = Az alapértelmezett URL használati a HTTPS feletti DNS feloldáshoz
connection-dns-over-https-url-custom =
    .label = Egyéni
    .accesskey = E
    .tooltiptext = Adja meg az előnyben részesített URL-t a HTTPS feletti DNS feloldáshoz
connection-dns-over-https-custom-label = Egyéni
connection-dialog-window =
    .title = Kapcsolat beállításai
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }
connection-disable-extension =
    .label = Kiegészítő letiltása
disable-extension-button = Kiegészítő letiltása
# Variables:
#   $name (String) - The extension that is controlling the proxy settings.
#
# The extension-icon is the extension's icon, or a fallback image. It should be
# purely decoration for the actual extension name, with alt="".
proxy-settings-controlled-by-extension = A(z) <img data-l10n-name="extension-icon" alt="" /> { $name } kiegészítő vezérli, hogy a { -brand-short-name } hogy kapcsolódik az internethez.
connection-proxy-legend = Proxy beállítása az internet eléréséhez
proxy-type-no =
    .label = Nincs proxy
    .accesskey = N
proxy-type-wpad =
    .label = Proxybeállítások automatikus felismerése a hálózatban
    .accesskey = b
proxy-type-system =
    .label = Rendszerbeállítások használata
    .accesskey = R
proxy-type-manual =
    .label = Kézi proxybeállítás:
    .accesskey = z
proxy-http-label =
    .value = HTTP-proxy:
    .accesskey = H
http-port-label =
    .value = Port:
    .accesskey = P
proxy-http-sharing =
    .label = Használja ezt a proxyt HTTPS esetén is
    .accesskey = x
proxy-https-label =
    .value = HTTPS-proxy:
    .accesskey = S
ssl-port-label =
    .value = Port:
    .accesskey = o
proxy-socks-label =
    .value = SOCKS gép:
    .accesskey = C
socks-port-label =
    .value = Port:
    .accesskey = t
proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K
proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = 5
proxy-type-auto =
    .label = Automatikus proxybeállítás URL:
    .accesskey = A
proxy-reload-label =
    .label = Frissítés
    .accesskey = r
no-proxy-label =
    .value = Nincs proxy a következőhöz:
    .accesskey = N
no-proxy-example = Példa: .mozilla.org, .net.nz, 192.168.1.0/24
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = A localhost, a 127.0.0.1/8, és a ::1 felé nyitott kapcsolatok sosem kerülnek proxyzásra.
proxy-password-prompt =
    .label = Ne kérjen hitelesítést, ha a jelszó el van mentve
    .accesskey = h
    .tooltiptext = Ez a beállítás csendben hitelesíti proxyk felé, ha mentette hozzájuk a hitelesítési adatokat. Ha a hitelesítés sikertelen, akkor felszólítást kap.
proxy-remote-dns =
    .label = DNS proxyzása SOCKS v5 használatakor
    .accesskey = d
proxy-enable-doh =
    .label = HTTPS feletti DNS bekapcsolása
    .accesskey = b
