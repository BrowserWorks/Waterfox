# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Configuração de conexão
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = W

connection-disable-extension =
    .label = Desativar extensão

connection-proxy-configure = Configuração do proxy de acesso à internet

connection-proxy-option-no =
    .label = Sem proxy
    .accesskey = S
connection-proxy-option-system =
    .label = Usar as configurações de proxy do sistema
    .accesskey = a
connection-proxy-option-auto =
    .label = Detectar automaticamente as configurações de proxy desta rede
    .accesskey = r
connection-proxy-option-manual =
    .label = Configuração manual de proxy
    .accesskey = m

connection-proxy-http = Proxy HTTP
    .accesskey = H
connection-proxy-http-port = Porta
    .accesskey = P

connection-proxy-https-sharing =
    .label = Usar este proxy também para HTTPS
    .accesskey = s

connection-proxy-https = Proxy HTTPS
    .accesskey = H
connection-proxy-ssl-port = Porta
    .accesskey = o

connection-proxy-socks = Domínio SOCKS
    .accesskey = S
connection-proxy-socks-port = Porta
    .accesskey = t

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
connection-proxy-noproxy-localhost-desc-2 = Conexões para localhost, 127.0.0.1/8, e ::1 nunca passam por proxy.

connection-proxy-autotype =
    .label = URL de configuração automática de proxy
    .accesskey = A

connection-proxy-reload =
    .label = Recarregar
    .accesskey = c

connection-proxy-autologin =
    .label = Não pedir confirmação de autenticação se a senha estiver memorizada
    .accesskey = v
    .tooltip = Autenticação silenciosa em proxies quando houver credenciais memorizadas. Uma confirmação será solicitada se a autenticação falhar.

connection-proxy-socks-remote-dns =
    .label = Proxy DNS ao usar SOCKS v5
    .accesskey = D

connection-dns-over-https =
    .label = Ativar DNS sobre HTTPS
    .accesskey = H

connection-dns-over-https-url-resolver = Usar provedor
    .accesskey = p

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (padrão)
    .tooltiptext = Usar a URL padrão para resolver DNS sobre HTTPS

connection-dns-over-https-url-custom =
    .label = Personalizado
    .accesskey = P
    .tooltiptext = Insira sua URL preferida para resolver DNS sobre HTTPS

connection-dns-over-https-custom-label = Personalizado
