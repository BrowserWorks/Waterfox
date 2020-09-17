# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Usar proveedor
    .accesskey = r

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Predeterminada)
    .tooltiptext = Usar URL predeterminada para resolver DNS sobre HTTPS

connection-dns-over-https-url-custom =
    .label = Personalizada
    .accesskey = z
    .tooltiptext = Ingresar URL preferida para resolver DNS sobre HTTPS

connection-dns-over-https-custom-label = Personalizada

connection-dialog-window =
    .title = Opciones de conexión
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Configurar proxies para acceder a Internet

proxy-type-no =
    .label = Sin proxy
    .accesskey = y

proxy-type-wpad =
    .label = Detectar automáticamente la configuración del proxy para esta red
    .accesskey = D

proxy-type-system =
    .label = Usar la configuración de proxy del sistema
    .accesskey = U

proxy-type-manual =
    .label = Configuración manual de proxy:
    .accesskey = m

proxy-http-label =
    .value = Proxy HTTP:
    .accesskey = h

http-port-label =
    .value = Puerto:
    .accesskey = p

proxy-http-sharing =
    .label = Use este proxy también para FTP y HTTPS
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
    .label = URL de configuración automática de proxy:
    .accesskey = a

proxy-reload-label =
    .label = Recargar
    .accesskey = R

no-proxy-label =
    .value = Sin proxy para:
    .accesskey = n

no-proxy-example = Ejemplo: .mozilla.org, .net.ar, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Las conexiones a localhost, 127.0.0.1 y ::1 nunca pasan pro proxy.

proxy-password-prompt =
    .label = No pedir autenticación si la contraseña está guardada
    .accesskey = i
    .tooltiptext = Esta opción autentica silenciosamente a los proxys cuand se han gardado credenciales para ellos. Se pedirá si falla la autenticación.

proxy-remote-dns =
    .label = Proxy DNS al usar SOCKS v5
    .accesskey = d

proxy-enable-doh =
    .label = Habilitar DNS por sobre HTTPS
    .accesskey = b
