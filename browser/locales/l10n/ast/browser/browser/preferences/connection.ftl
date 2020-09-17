# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Axustes de conexón
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Deshabilitar estensión

connection-proxy-configure = Configurar accesu proxy a Internet

connection-proxy-option-no =
    .label = Ensin proxy
    .accesskey = y
connection-proxy-option-system =
    .label = Usar los datos de proxy del sistema
    .accesskey = U
connection-proxy-option-auto =
    .label = Autodetectar configuración del proxy pa esta rede
    .accesskey = e
connection-proxy-option-manual =
    .label = Configuración manual del proxy
    .accesskey = m

connection-proxy-http = Proxy HTTP
    .accesskey = x
connection-proxy-http-port = Puertu
    .accesskey = P

connection-proxy-ssl-port = Puertu
    .accesskey = u

connection-proxy-ftp = Proxy FTP
    .accesskey = F
connection-proxy-ftp-port = Puertu
    .accesskey = r

connection-proxy-socks = Sirvidor SOCKS
    .accesskey = C
connection-proxy-socks-port = Puertu
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Nun usar proxy pa
    .accesskey = n

connection-proxy-noproxy-desc = Exemplu: .mozilla.org, .net.nz, 192.168.1.0/24

connection-proxy-autotype =
    .label = URL pa la configuración automática del proxy
    .accesskey = A

connection-proxy-reload =
    .label = Recargar
    .accesskey = R

connection-proxy-autologin =
    .label = Nun entrugar identificación si la contraseña ta guardada
    .accesskey = u
    .tooltip = Esta opción identifícate de mou silenciosu énte los proxys cuando guardasti les credenciales pa ellos. Va entrugásete si falla la identificación.

connection-proxy-socks-remote-dns =
    .label = Proxy DNS al usar SOCKS v5
    .accesskey = D

connection-dns-over-https =
    .label = Habilita DNS sobre HTTPS
    .accesskey = H

connection-dns-over-https-url-custom =
    .label = Personalizada
    .accesskey = P
    .tooltiptext = Escribi la to URL preferida pa resolver DNS sobre HTTPS

