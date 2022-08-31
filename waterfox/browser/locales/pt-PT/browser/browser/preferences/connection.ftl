# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Definições de ligação
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Desativar extensão

connection-proxy-configure = Configurar acesso proxy à Internet

connection-proxy-option-no =
    .label = Sem proxy
    .accesskey = p
connection-proxy-option-system =
    .label = Utilizar definições de proxy do sistema
    .accesskey = x
connection-proxy-option-auto =
    .label = Detetar automaticamente as definições de proxy para esta rede
    .accesskey = d
connection-proxy-option-manual =
    .label = Configuração manual de proxy
    .accesskey = m

connection-proxy-http = Proxy HTTP
    .accesskey = x
connection-proxy-http-port = Porta
    .accesskey = P

connection-proxy-https-sharing =
    .label = Utilizar também este proxy para HTTPS
    .accesskey = S

connection-proxy-https = Proxy HTTPS
    .accesskey = H
connection-proxy-ssl-port = Porta
    .accesskey = o

connection-proxy-socks = Servidor SOCKS
    .accesskey = C
connection-proxy-socks-port = Porta
    .accesskey = a

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = 4
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = 5
connection-proxy-noproxy = Nenhum proxy para
    .accesskey = n

connection-proxy-noproxy-desc = Exemplo: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = A ligações a localhost, 127.0.0.1/8, e ::1 não passam pelo proxy.

connection-proxy-autotype =
    .label = URL de configuração automática de proxy
    .accesskey = a

connection-proxy-reload =
    .label = Recarregar
    .accesskey = c

connection-proxy-autologin =
    .label = Não solicitar autenticação se a palavra-passe estiver guardada
    .accesskey = i
    .tooltip = Esta opção autentica-lhe silenciosamente nos proxies quando tem credenciais para os mesmos. Será solicitado(a) se a autenticação falhar.

connection-proxy-socks-remote-dns =
    .label = Encaminhar DNS via proxy ao utilizar SOCKS v5
    .accesskey = D

connection-dns-over-https =
    .label = Ativar DNS sob HTTPS
    .accesskey = H

connection-dns-over-https-url-resolver = Utilizar fornecedor
    .accesskey = f

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (predefinição)
    .tooltiptext = Utilize o endereço predefinido para resolver DNS sob HTTPS

connection-dns-over-https-url-custom =
    .label = Personalizar
    .accesskey = P
    .tooltiptext = Introduza o endereço que pretende utilizar para resolver DNS sob HTTPS

connection-dns-over-https-custom-label = Personalizar
