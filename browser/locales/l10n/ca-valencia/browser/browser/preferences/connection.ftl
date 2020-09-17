# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Paràmetres de connexió
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Inhabilita l'extensió

connection-proxy-configure = Configureu el servidor intermediari per accedir a Internet

connection-proxy-option-no =
    .label = Sense servidor intermediari
    .accesskey = v
connection-proxy-option-system =
    .label = Utilitza els paràmetres de servidor intermediari del sistema
    .accesskey = z
connection-proxy-option-auto =
    .label = Detecta automàticament els paràmetres del servidor intermediari per a esta xarxa
    .accesskey = i
connection-proxy-option-manual =
    .label = Configuració manual del servidor intermediari
    .accesskey = m

connection-proxy-http = Servidor intermediari d'HTTP
    .accesskey = H
connection-proxy-http-port = Port
    .accesskey = P

connection-proxy-http-sharing =
    .label = Utilitza també este servidor intermediari per a FTP i HTTPS
    .accesskey = s

connection-proxy-https = Servidor intermediari d'HTTPS
    .accesskey = H
connection-proxy-ssl-port = Port
    .accesskey = o

connection-proxy-ftp = Servidor intermediari d'FTP
    .accesskey = F
connection-proxy-ftp-port = Port
    .accesskey = r

connection-proxy-socks = Ordinador central SOCKS
    .accesskey = K
connection-proxy-socks-port = Port
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Sense servidor intermediari per a
    .accesskey = n

connection-proxy-noproxy-desc = Exemple: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = No s'utilitza mail cap servidor intermediari per a les connexions a localhost, 127.0.0.1 i ::1.

connection-proxy-autotype =
    .label = URL de configuració automàtica del servidor intermediari
    .accesskey = a

connection-proxy-reload =
    .label = Actualitza
    .accesskey = z

connection-proxy-autologin =
    .label = No sol·licitis autenticació si la contrasenya està guardada
    .accesskey = i
    .tooltip = Esta opció vos autentica automàticament en els servidors intermediaris dels quals heu guardat les credencials. Si l'autenticació falla, se vos sol·licitaran les credencials.

connection-proxy-socks-remote-dns =
    .label = Servidor intermediari DNS en utilitzar SOCKS v5
    .accesskey = d

connection-dns-over-https =
    .label = Habilita DNS sobre HTTPS
    .accesskey = H

connection-dns-over-https-url-resolver = Utilitza el proveïdor
    .accesskey = p

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
