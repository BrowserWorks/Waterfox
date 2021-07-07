# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Utilizar fornecedor
    .accesskey = r

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (predefinido)
    .tooltiptext = Utilize o URL predefinido para resolver DNS por HTTPS

connection-dns-over-https-url-custom =
    .label = Personalizar
    .accesskey = P
    .tooltiptext = Introduza o seu URL preferido para resolver DNS por HTTPS

connection-dns-over-https-custom-label = Personalizado

connection-dialog-window =
    .title = Definições de ligação
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Configurar proxies para aceder à Internet

proxy-type-no =
    .label = Sem proxy
    .accesskey = y

proxy-type-wpad =
    .label = Deteção automática de proxy para esta rede
    .accesskey = D

proxy-type-system =
    .label = Utilizar definições de proxy do sistema
    .accesskey = U

proxy-type-manual =
    .label = Configuração manual do proxy:
    .accesskey = m

proxy-http-label =
    .value = Proxy HTTP:
    .accesskey = T

http-port-label =
    .value = Porta:
    .accesskey = P

proxy-http-sharing =
    .label = Utilizar também este proxy para HTTPS
    .accesskey = x

proxy-https-label =
    .value = Proxy HTTPS:
    .accesskey = S

ssl-port-label =
    .value = Porta:
    .accesskey = o

proxy-socks-label =
    .value = SOCKS:
    .accesskey = K

socks-port-label =
    .value = Porta:
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL de configuração automática do proxy:
    .accesskey = R

proxy-reload-label =
    .label = Recarregar
    .accesskey = a

no-proxy-label =
    .value = Sem proxy para:
    .accesskey = m

no-proxy-example = Exemplo: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = O proxy nunca é utilizado em ligações para localhost, 127.0.0.1 e :: 1.

proxy-password-prompt =
    .label = Não solicitar autenticação se a palavra-passe estiver guardada
    .accesskey = i
    .tooltiptext = Esta opção autentica-lhe silenciosamente em proxies quando tem credenciais guardadas para os mesmos. Será solicitado(a) se a autenticação falhar.

proxy-remote-dns =
    .label = Proxy DNS ao utilizar SOCKS v5
    .accesskey = d

proxy-enable-doh =
    .label = Ativar DNS por HTTPS
    .accesskey = t
