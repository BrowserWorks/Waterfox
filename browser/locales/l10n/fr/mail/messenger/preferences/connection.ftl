# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
    .tooltiptext = Saisissez l’URL de votre choix pour résoudre le DNS via HTTPS
connection-dns-over-https-custom-label = Personnalisé
connection-dialog-window =
    .title = Paramètres de connexion
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }
connection-disable-extension =
    .label = Désactiver l’extension
connection-proxy-legend = Configuration du serveur proxy pour accéder à Internet
proxy-type-no =
    .label = Pas de proxy
    .accesskey = d
proxy-type-wpad =
    .label = Détection automatique des paramètres de proxy pour ce réseau
    .accesskey = u
proxy-type-system =
    .label = Utiliser les paramètres proxy du système
    .accesskey = y
proxy-type-manual =
    .label = Configuration manuelle du proxy :
    .accesskey = m
proxy-http-label =
    .value = Proxy HTTP :
    .accesskey = h
http-port-label =
    .value = Port :
    .accesskey = p
proxy-http-sharing =
    .label = Utiliser également ce proxy pour HTTPS
    .accesskey = x
proxy-https-label =
    .value = Proxy HTTPS :
    .accesskey = S
ssl-port-label =
    .value = Port :
    .accesskey = o
proxy-socks-label =
    .value = Hôte SOCKS :
    .accesskey = c
socks-port-label =
    .value = Port :
    .accesskey = t
proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k
proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v
proxy-type-auto =
    .label = Adresse de configuration automatique du proxy :
    .accesskey = A
proxy-reload-label =
    .label = Actualiser
    .accesskey = e
no-proxy-label =
    .value = Pas de proxy pour :
    .accesskey = x
no-proxy-example = Exemples : .mozilla.org, .asso.org, 192.168.1.0/24
# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Les connexions à localhost, 127.0.0.1 ou ::1 ne passent jamais par un proxy.
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Les connexions à localhost, 127.0.0.1/8 ou ::1 ne passent jamais par un proxy.
proxy-password-prompt =
    .label = Ne pas me demander de m’authentifier si le mot de passe est enregistré
    .accesskey = N
    .tooltiptext = Cette option vous authentifie automatiquement sur les serveurs proxy dont le mot de passe est enregistré. Si l’authentification échoue, le mot de passe vous sera demandé.
proxy-remote-dns =
    .label = Utiliser un DNS distant lorsque SOCKS v5 est actif
    .accesskey = r
proxy-enable-doh =
    .label = Activer le DNS via HTTPS
    .accesskey = d
