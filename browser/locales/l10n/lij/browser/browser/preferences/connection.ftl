# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Preferense de conescion
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Dizabilita Estenscion

connection-proxy-configure = Inpòsta proxy pe intrâ in Internet

connection-proxy-option-no =
    .label = No proxy
    .accesskey = y
connection-proxy-option-system =
    .label = Adeuvia o proxy de scistema
    .accesskey = Û
connection-proxy-option-auto =
    .label = Treuva e inpostaçion do proxy in aotomatico pe sta ræ
    .accesskey = T
connection-proxy-option-manual =
    .label = Configoraçion a man do proxy
    .accesskey = m

connection-proxy-http = Proxy HTTP
    .accesskey = x
connection-proxy-http-port = Pòrta
    .accesskey = P

connection-proxy-ssl-port = Pòrta
    .accesskey = o

connection-proxy-ftp = Proxy FTP
    .accesskey = F
connection-proxy-ftp-port = Pòrta
    .accesskey = r

connection-proxy-socks = Host SOCKS
    .accesskey = C
connection-proxy-socks-port = Pòrta
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Nisciun proxy pe
    .accesskey = n

connection-proxy-noproxy-desc = Ezenpio: mozilla.org, .net.nz, 192.168.1.0/24

connection-proxy-autotype =
    .label = URL pe-a configoraçion do proxy outomatica
    .accesskey = A

connection-proxy-reload =
    .label = Recarega
    .accesskey = e

connection-proxy-autologin =
    .label = No domandâ l’aotenticaçion se a paròlla segreta a l'é sarvâ
    .accesskey = c
    .tooltip = Sta òpçion a permette de aotenticase diretamente con in proxy se ti gh'æ de credensiali sarvæ. A domanda ti a vediæ in caxo de'erô.

connection-proxy-socks-remote-dns =
    .label = Proxy DNS quande se deuvia SOCKS v5
    .accesskey = D

connection-dns-over-https =
    .label = Abilita DNS in sce HTTPS
    .accesskey = H

connection-dns-over-https-url-custom =
    .label = Personalizou
    .accesskey = P
    .tooltiptext = Scrivi a teu URL preferia pe risolve DNS sorvia HTTPS

connection-dns-over-https-custom-label = Personalizou
