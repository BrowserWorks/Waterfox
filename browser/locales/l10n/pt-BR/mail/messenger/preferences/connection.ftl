# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Usar provedor
    .accesskey = v
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (padrão)
    .tooltiptext = Usar a URL padrão para resolver DNS sobre HTTPS
connection-dns-over-https-url-custom =
    .label = Personalizado
    .accesskey = P
    .tooltiptext = Digite sua URL preferida para resolver DNS sobre HTTPS
connection-dns-over-https-custom-label = Personalizado
connection-dialog-window =
    .title = Configurar conexão
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }
connection-disable-extension =
    .label = Desativar extensão
connection-proxy-legend = Acesso à internet
proxy-type-no =
    .label = Sem proxy
    .accesskey = S
proxy-type-wpad =
    .label = Detectar automaticamente as configurações de proxy desta rede
    .accesskey = d
proxy-type-system =
    .label = Usar as configurações de proxy do sistema
    .accesskey = a
proxy-type-manual =
    .label = Configuração manual de proxy:
    .accesskey = n
proxy-http-label =
    .value = HTTP:
    .accesskey = H
http-port-label =
    .value = Porta:
    .accesskey = P
proxy-http-sharing =
    .label = Usar este proxy também para HTTPS
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
    .accesskey = 4
proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = 5
proxy-type-auto =
    .label = URL de configuração automática de proxy:
    .accesskey = E
proxy-reload-label =
    .label = Recarregar
    .accesskey = c
no-proxy-label =
    .value = Sem proxy para:
    .accesskey = S
no-proxy-example = Exemplo: .mozilla.org, .net.nz, 192.168.1.0/24
# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Conexões para localhost, 127.0.0.1 e ::1 não passam por proxy.
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Conexões para localhost, 127.0.0.1/8 e ::1 nunca passam por proxy.
proxy-password-prompt =
    .label = Não pedir confirmação de autenticação se senha estiver memorizada
    .accesskey = i
    .tooltiptext = Esta opção autentica-o silenciosamente em proxys quando tem credenciais memorizadas para os mesmos. Uma confirmação será solicitada se a autenticação falhar.
proxy-remote-dns =
    .label = Proxy DNS ao usar SOCKS v5
    .accesskey = d
proxy-enable-doh =
    .label = Habilitar DNS sobre HTTPS
    .accesskey = b
