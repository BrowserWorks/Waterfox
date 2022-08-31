# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Configuración de conexión
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Deshabilitar extensión

connection-proxy-configure = Configurar accesos proxy para Internet

connection-proxy-option-no =
    .label = Sin proxy
    .accesskey = S
connection-proxy-option-system =
    .label = Usar la configuración de proxy del sistema
    .accesskey = l
connection-proxy-option-auto =
    .label = Autodetectar configuración del proxy para esta red
    .accesskey = r
connection-proxy-option-manual =
    .label = Configuración manual de proxy
    .accesskey = m

connection-proxy-http = Proxy HTTP
    .accesskey = x
connection-proxy-http-port = Puerto
    .accesskey = P

connection-proxy-https-sharing =
    .label = También usar este proxy para HTTPS
    .accesskey = s

connection-proxy-https = Proxy HTTPS
    .accesskey = H
connection-proxy-ssl-port = Puerto
    .accesskey = u

connection-proxy-socks = Servidor SOCKS
    .accesskey = C
connection-proxy-socks-port = Puerto
    .accesskey = o

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Sin proxy para
    .accesskey = n

connection-proxy-noproxy-desc = Ejemplo: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Las conexiones a localhost, 127.0.0.1 y ::1 nunca pasan por proxy.

connection-proxy-autotype =
    .label = URL de configuración automática de proxy
    .accesskey = A

connection-proxy-reload =
    .label = Recargar
    .accesskey = e

connection-proxy-autologin =
    .label = No pedir identificación si la contraseña está guardada
    .accesskey = i
    .tooltip = Esta opción te identifica silenciosamente con los proxys cuando has guardado credenciales para ellos. Serás requerido si la identificación falla.

connection-proxy-socks-remote-dns =
    .label = Proxy DNS cuando uses SOCKS v5
    .accesskey = D

connection-dns-over-https =
    .label = Habilitar DNS por HTTPS
    .accesskey = H

connection-dns-over-https-url-resolver = Usar Proveedor
    .accesskey = P

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Predeterminado)
    .tooltiptext = Usa la URL predeterminada para resolver DNS sobre HTTPS

connection-dns-over-https-url-custom =
    .label = Personalizar
    .accesskey = e
    .tooltiptext = Ingrese su URL preferida para resolver los DNS sobre HTTPS

connection-dns-over-https-custom-label = Personalizado
