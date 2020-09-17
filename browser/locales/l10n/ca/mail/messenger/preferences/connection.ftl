# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Utilitza el proveïdor
    .accesskey = r

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (per defecte)
    .tooltiptext = Utilitza l'URL per defecte per resoldre DNS sobre HTTPS

connection-dns-over-https-url-custom =
    .label = Personalitzat
    .accesskey = P
    .tooltiptext = Introduïu el vostre URL preferit per resoldre DNS sobre HTTPS

connection-dns-over-https-custom-label = Personalitzat

connection-dialog-window =
    .title = Paràmetres de la connexió
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Configura els servidors intermediaris per accedir a Internet

proxy-type-no =
    .label = Sense cap servidor intermediari
    .accesskey = d

proxy-type-wpad =
    .label = Detecta automàticament els paràmetres del servidor intermediari per a aquesta xarxa
    .accesskey = i

proxy-type-system =
    .label = Utilitza els paràmetres de servidor intermediari del sistema
    .accesskey = U

proxy-type-manual =
    .label = Configuració manual del servidor intermediari:
    .accesskey = m

proxy-http-label =
    .value = Servidor intermediari d'HTTP:
    .accesskey = H

http-port-label =
    .value = Port:
    .accesskey = P

proxy-http-sharing =
    .label = Utilitza també aquest servidor intermediari per a HTTPS
    .accesskey = v

proxy-https-label =
    .value = Servidor intermediari d'HTTPS:
    .accesskey = S

ssl-port-label =
    .value = Port:
    .accesskey = o

proxy-socks-label =
    .value = Ordinador central SOCKS:
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
    .label = URL de configuració automàtica del servidor intermediari:
    .accesskey = a

proxy-reload-label =
    .label = Actualitza
    .accesskey = l

no-proxy-label =
    .value = Sense servidor intermediari per a:
    .accesskey = n

no-proxy-example = Exemple: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = No s'utilitza mail cap servidor intermediari per a les connexions a localhost, 127.0.0.1 i ::1.

proxy-password-prompt =
    .label = No sol·licitis autenticació si la contrasenya està desada
    .accesskey = i
    .tooltiptext = Aquesta opció us autentica automàticament en els servidors intermediaris dels quals heu desat les credencials. Si l'autenticació falla, se us sol·licitaran les credencials.

proxy-remote-dns =
    .label = Utilitza el servidor intermediari per a DNS en utilitzar SOCKS v5
    .accesskey = d

proxy-enable-doh =
    .label = Habilita DNS sobre HTTPS
    .accesskey = H
