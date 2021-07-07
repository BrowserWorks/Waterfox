# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Dostawca
    .accesskey = D
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (domyślny)
    .tooltiptext = Użyj domyślnego adresu serwera DNS udostępnionego poprzez HTTPS
connection-dns-over-https-url-custom =
    .label = Własny adres:
    .accesskey = W
    .tooltiptext = Podaj adres wybranego serwera DNS udostępnionego poprzez HTTPS
connection-dns-over-https-custom-label = Własny adres:
connection-dialog-window =
    .title = Ustawienia połączenia
    .style =
        { PLATFORM() ->
            [macos] width: 45em !important
           *[other] width: 49em !important
        }
connection-disable-extension =
    .label = Wyłącz rozszerzenie
connection-proxy-legend = Konfiguracja serwerów proxy do połączenia z Internetem
proxy-type-no =
    .label = Bez serwera proxy
    .accesskey = B
proxy-type-wpad =
    .label = Automatycznie wykrywaj ustawienia serwerów proxy dla tej sieci
    .accesskey = A
proxy-type-system =
    .label = Używaj systemowych ustawień serwerów proxy
    .accesskey = w
proxy-type-manual =
    .label = Ręczna konfiguracja serwerów proxy:
    .accesskey = k
proxy-http-label =
    .value = Serwer proxy HTTP:
    .accesskey = H
http-port-label =
    .value = Port:
    .accesskey = P
proxy-http-sharing =
    .label = Użyj tego serwera proxy także dla HTTPS
    .accesskey = U
proxy-https-label =
    .value = Serwer proxy HTTPS:
    .accesskey = S
ssl-port-label =
    .value = Port:
    .accesskey = o
proxy-socks-label =
    .value = Host SOCKS:
    .accesskey = c
socks-port-label =
    .value = Port:
    .accesskey = t
proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = 4
proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = 5
proxy-type-auto =
    .label = Adres URL automatycznej konfiguracji:
    .accesskey = e
proxy-reload-label =
    .label = Odśwież
    .accesskey = d
no-proxy-label =
    .value = Nie używaj proxy dla:
    .accesskey = N
no-proxy-example = Przykład: .mozilla.org, .com.pl, 192.168.1.0/24
# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Połączania z localhost, 127.0.0.1 i ::1 nigdy nie używają serwera proxy.
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Połączania z localhost, 127.0.0.1/8 i ::1 nigdy nie używają serwera proxy.
proxy-password-prompt =
    .label = Nie pytaj o uwierzytelnianie, jeśli istnieje zachowane hasło
    .accesskey = u
    .tooltiptext = Umożliwia automatyczne uwierzytelnianie na serwerach proxy, jeśli wcześniej zostały zachowane dane logowania. W przypadku nieudanego uwierzytelniania zostanie wyświetlone standardowe pytanie.
proxy-remote-dns =
    .label = Proxy DNS podczas używania SOCKS v5
    .accesskey = x
proxy-enable-doh =
    .label = DNS poprzez HTTPS
    .accesskey = D
