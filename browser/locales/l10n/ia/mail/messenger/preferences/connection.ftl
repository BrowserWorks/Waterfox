# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Usar fornitor
    .accesskey = r

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Predefinite)
    .tooltiptext = Usar le URL predefinite pro solver DNS sur HTTPS

connection-dns-over-https-url-custom =
    .label = Personalisate
    .accesskey = P
    .tooltiptext = Insere tu URL preferite pro resolver DNS super HTTPS

connection-dns-over-https-custom-label = Personalisate

connection-dialog-window =
    .title = Parametros de connexion
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Configurar proxies pro acceder a Internet

proxy-type-no =
    .label = Nulle proxy
    .accesskey = y

proxy-type-wpad =
    .label = Auto-deteger le parametros de proxy pro iste rete
    .accesskey = x

proxy-type-system =
    .label = Usar le parametros de proxy del systema
    .accesskey = u

proxy-type-manual =
    .label = Configuration manual del proxy:
    .accesskey = m

proxy-http-label =
    .value = Proxy HTTP:
    .accesskey = h

http-port-label =
    .value = Porta:
    .accesskey = p

proxy-http-sharing =
    .label = Usa alsi iste proxy pro HTTPS
    .accesskey = x

proxy-https-label =
    .value = Proxy HTTPS:
    .accesskey = S

ssl-port-label =
    .value = Porta:
    .accesskey = o

proxy-socks-label =
    .value = Hoste SOCKS:
    .accesskey = c

socks-port-label =
    .value = Porta:
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL de configuration automatic del proxy:
    .accesskey = A

proxy-reload-label =
    .label = Recargar
    .accesskey = l

no-proxy-label =
    .value = Nulle proxy pro:
    .accesskey = n

no-proxy-example = Exemplo: .mozilla.org, .asso.fr, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Le connexiones a localhost, 127.0.0.1 e ::1 nunquam passa per un proxy.

proxy-password-prompt =
    .label = Non demandar authenticar me si le contrasigno es salvate
    .accesskey = i
    .tooltiptext = Iste option te authentica silentiosemente al proxies quando tu ha salvate credentiales pro illos. Te essera demandate si le authentication falle.

proxy-remote-dns =
    .label = Proxy DNS quando in SOCKS v5
    .accesskey = d

proxy-enable-doh =
    .label = Activar le DNS sur HTTPS
    .accesskey = b
