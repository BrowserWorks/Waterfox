# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Usar proveedor
    .accesskey = r

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (predeterminado)
    .tooltiptext = Usar la URL predeterminada para resolver DNS sobre HTTPS

connection-dns-over-https-url-custom =
    .label = Personalizado
    .accesskey = P
    .tooltiptext = Introducir su URL preferida para resolver DNS sobre HTTPS

connection-dns-over-https-custom-label = Personalizado

connection-dialog-window =
    .title = Configuración de conexión
    .style =
        { PLATFORM() ->
            [macos] width: 52em !important
           *[other] width: 59em !important
        }

connection-proxy-legend = Configurar proxies para el acceso a Internet

proxy-type-no =
    .label = Sin proxy
    .accesskey = i

proxy-type-wpad =
    .label = Autodetectar configuración del proxy para esta red
    .accesskey = t

proxy-type-system =
    .label = Usar configuración de proxy del sistema
    .accesskey = U

proxy-type-manual =
    .label = Configuración manual del proxy:
    .accesskey = m

proxy-http-label =
    .value = Proxy HTTP:
    .accesskey = h

http-port-label =
    .value = Puerto:
    .accesskey = p

proxy-http-sharing =
    .label = Usar también este proxy para HTTPS
    .accesskey = x

proxy-https-label =
    .value = Proxy HTTPS:
    .accesskey = S

ssl-port-label =
    .value = Puerto:
    .accesskey = o

proxy-socks-label =
    .value = Servidor SOCKS:
    .accesskey = c

socks-port-label =
    .value = Puerto:
    .accesskey = e

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL para la configuración automática del proxy:
    .accesskey = A

proxy-reload-label =
    .label = Recargar
    .accesskey = R

no-proxy-label =
    .value = No usar proxy para:
    .accesskey = n

no-proxy-example = Ejemplo: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Las conexiones a localhost, 127.0.0.1 y ::1 nunca se tratan por el proxy.

proxy-password-prompt =
    .label = No solicitar identificación si la contraseña está guardada
    .accesskey = d
    .tooltiptext = Esta opción le identifica sin ningún mensaje ante los proxis cuando ha guardado credenciales para ellos. Se le preguntará en caso de que falle el inicio de sesión.

proxy-remote-dns =
    .label = DNS proxy al usar SOCKS v5
    .accesskey = 5

proxy-enable-doh =
    .label = Activar DNS sobre HTTPS
    .accesskey = v
