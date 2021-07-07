# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Usar proveedor
    .accesskey = r

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Predeterminado)
    .tooltiptext = Usar la URL predeterminada para resolver DNS sobre HTTPS

connection-dns-over-https-url-custom =
    .label = Personalizado
    .accesskey = C
    .tooltiptext = Escribe la URL preferida para resolver DNS sobre HTTPS

connection-dns-over-https-custom-label = Personalizado

connection-dialog-window =
    .title = Configuraciones de conexión
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-disable-extension =
    .label = Deshabilitar extensión

connection-proxy-legend = Configurar proxies para acceder a Internet

proxy-type-no =
    .label = Sin proxy
    .accesskey = y

proxy-type-wpad =
    .label = Detección automática de configuraciones de proxy para esta red
    .accesskey = w

proxy-type-system =
    .label = Usar la configuración del proxy del sistema
    .accesskey = u

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
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL de configuración automática del proxy:
    .accesskey = A

proxy-reload-label =
    .label = Recargar
    .accesskey = l

no-proxy-label =
    .value = Sin proxy para:
    .accesskey = n

no-proxy-example = Ejemplo: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Las conexiones a localhost, 127.0.0.1/8, y ::1 nunca pasan por proxy.

proxy-password-prompt =
    .label = No pedir autenticación si la contraseña está guardada
    .accesskey = i
    .tooltiptext = Esta opción silenciosamente te autentica en proxies cuando has guardado credenciales para ellos. Se te preguntará si falla la autenticación.

proxy-remote-dns =
    .label = DNS proxy al usar SOCKS v5
    .accesskey = d

proxy-enable-doh =
    .label = Habilitar DNS sobre HTTPS
    .accesskey = b
