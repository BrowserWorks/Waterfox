# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Utilizza provider
    .accesskey = U
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (predefinito)
    .tooltiptext = Utilizza l’indirizzo predefinito per risolvere richieste DNS over HTTPS
connection-dns-over-https-url-custom =
    .label = Personalizzato
    .accesskey = P
    .tooltiptext = Inserisci l’indirizzo da utilizzare per risolvere richieste DNS over HTTPS
connection-dns-over-https-custom-label = Personalizzato
connection-dialog-window =
    .title = Impostazioni di connessione
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }
connection-disable-extension =
    .label = Disattiva estensione
disable-extension-button = Disattiva estensione
# Variables:
#   $name (String) - The extension that is controlling the proxy settings.
#
# The extension-icon is the extension's icon, or a fallback image. It should be
# purely decoration for the actual extension name, with alt="".
proxy-settings-controlled-by-extension = Le impostazioni di { -brand-short-name } relative alla connessione a Internet sono attualmente gestite da un’estensione (<img data-l10n-name="extension-icon" alt="" /> { $name }).
connection-proxy-legend = Configura proxy per l’accesso a Internet
proxy-type-no =
    .label = Nessun proxy
    .accesskey = y
proxy-type-wpad =
    .label = Configurazione automatica delle impostazioni del proxy per questa rete
    .accesskey = x
proxy-type-system =
    .label = Utilizza le impostazioni del proxy di sistema
    .accesskey = u
proxy-type-manual =
    .label = Configurazione manuale del proxy:
    .accesskey = m
proxy-http-label =
    .value = Proxy HTTP:
    .accesskey = h
http-port-label =
    .value = Porta:
    .accesskey = p
proxy-http-sharing =
    .label = Utilizza anche questo proxy per HTTPS
    .accesskey = x
proxy-https-label =
    .value = Proxy HTTPS:
    .accesskey = S
ssl-port-label =
    .value = Porta:
    .accesskey = o
proxy-socks-label =
    .value = Server SOCKS:
    .accesskey = c
socks-port-label =
    .value = Porta:
    .accesskey = t
proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k
proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v
proxy-type-auto =
    .label = URL per la configurazione automatica del proxy:
    .accesskey = A
proxy-reload-label =
    .label = Ricarica
    .accesskey = R
no-proxy-label =
    .value = Nessun proxy per:
    .accesskey = n
no-proxy-example = Esempio: .mozilla.org, .net.nz, mozillaitalia.org, 192.168.1.0/24
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Le connessioni verso localhost, 127.0.0.1/8 e ::1 non usano mai proxy.
proxy-password-prompt =
    .label = Non richiedere l’autenticazione se la password è salvata
    .accesskey = i
    .tooltiptext = Questa opzione permette di autenticarsi direttamente con un proxy se ci sono delle credenziali salvate. Verranno chieste nuovamente se l’autenticazione dovesse fallire.
proxy-remote-dns =
    .label = DNS proxy per SOCKS v5
    .accesskey = d
proxy-enable-doh =
    .label = Attiva DNS su HTTPS
    .accesskey = N
