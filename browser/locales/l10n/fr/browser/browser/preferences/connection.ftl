# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Paramètres de connexion
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Désactiver l’extension

connection-proxy-configure = Configuration du serveur proxy pour accéder à Internet

connection-proxy-option-no =
    .label = Pas de proxy
    .accesskey = d
connection-proxy-option-system =
    .label = Utiliser les paramètres proxy du système
    .accesskey = y
connection-proxy-option-auto =
    .label = Détection automatique des paramètres de proxy pour ce réseau
    .accesskey = u
connection-proxy-option-manual =
    .label = Configuration manuelle du proxy
    .accesskey = m

connection-proxy-http = Proxy HTTP
    .accesskey = H
connection-proxy-http-port = Port
    .accesskey = p

connection-proxy-https-sharing =
    .label = Utiliser également ce proxy pour HTTPS
    .accesskey = s

connection-proxy-https = Proxy HTTPS
    .accesskey = H
connection-proxy-ssl-port = Port
    .accesskey = o

connection-proxy-socks = Hôte SOCKS
    .accesskey = C
connection-proxy-socks-port = Port
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = k
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Pas de proxy pour
    .accesskey = x

connection-proxy-noproxy-desc = Exemples : .mozilla.org, .asso.fr, 192.168.1.0/24

# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Les connexions à localhost, 127.0.0.1/8 ou ::1 ne passent jamais par un proxy.

connection-proxy-autotype =
    .label = Adresse de configuration automatique du proxy
    .accesskey = A

connection-proxy-reload =
    .label = Actualiser
    .accesskey = e

connection-proxy-autologin =
    .label = Ne pas me demander de m’authentifier si le mot de passe est enregistré
    .accesskey = g
    .tooltip = Cette option vous authentifie automatiquement sur les serveurs proxy dont le mot de passe est enregistré. Si l’authentification échoue, le mot de passe vous sera demandé.

connection-proxy-socks-remote-dns =
    .label = Utiliser un DNS distant lorsque SOCKS v5 est actif
    .accesskey = n

connection-dns-over-https =
    .label = Activer le DNS via HTTPS
    .accesskey = t

connection-dns-over-https-url-resolver = Utiliser le fournisseur
    .accesskey = U

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (par défaut)
    .tooltiptext = Utiliser l’URL par défaut pour résoudre le DNS via HTTPS

connection-dns-over-https-url-custom =
    .label = Personnalisé
    .accesskey = P
    .tooltiptext = Saisissez votre adresse préférée pour résoudre le DNS via HTTPS

connection-dns-over-https-custom-label = Personnalisé
