# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Impostazioni di connessione
    .style =
        { PLATFORM() ->
            [macos] width: 47em
           *[other] width: 52em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Disattiva estensione

connection-proxy-configure = Configurazione dei proxy per l’accesso a Internet

connection-proxy-option-no =
    .label = Nessun proxy
    .accesskey = N
connection-proxy-option-system =
    .label = Utilizza le impostazioni proxy del sistema
    .accesskey = u
connection-proxy-option-auto =
    .label = Individua automaticamente le impostazioni proxy per questa rete
    .accesskey = e
connection-proxy-option-manual =
    .label = Configurazione manuale dei proxy
    .accesskey = m

connection-proxy-http = Proxy HTTP
    .accesskey = H
connection-proxy-http-port = Porta
    .accesskey = P

connection-proxy-https-sharing =
    .label = Utilizza questo proxy anche per HTTPS
    .accesskey = c

connection-proxy-https = Proxy HTTPS
    .accesskey = S
connection-proxy-ssl-port = Porta
    .accesskey = o

connection-proxy-socks = Host SOCKS
    .accesskey = K
connection-proxy-socks-port = Porta
    .accesskey = a

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = 4
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = 5
connection-proxy-noproxy = Nessun proxy per
    .accesskey = x

connection-proxy-noproxy-desc = Esempio: .mozilla.org, .net.nz, 192.168.1.0/24

connection-proxy-noproxy-localhost-desc-2 = Le connessioni verso localhost, 127.0.0.1/8 e ::1 non usano mai proxy.

connection-proxy-autotype =
    .label = Configurazione automatica dei proxy (URL)
    .accesskey = z

connection-proxy-reload =
    .label = Ricarica
    .accesskey = i

connection-proxy-autologin =
    .label = Non richiedere l’autenticazione se la password è salvata
    .accesskey = c
    .tooltip = Questa opzione permette di autenticarsi direttamente con un proxy se risultano salvate delle credenziali. La richiesta verrà visualizzata in caso di errore.

connection-proxy-socks-remote-dns =
    .label = DNS proxy per SOCKS v5
    .accesskey = D

connection-dns-over-https =
    .label = Attiva DNS over HTTPS
    .accesskey = H

connection-dns-over-https-url-resolver = Utilizza provider
    .accesskey = U

connection-dns-over-https-url-item-default =
    .label = { $name } (predefinito)
    .tooltiptext = Utilizza l’indirizzo predefinito per risolvere richieste DNS over HTTPS

connection-dns-over-https-url-custom =
    .label = Personalizzato
    .accesskey = P
    .tooltiptext = Inserisci l’indirizzo da utilizzare per risolvere richieste DNS over HTTPS

connection-dns-over-https-custom-label = Personalizzato
