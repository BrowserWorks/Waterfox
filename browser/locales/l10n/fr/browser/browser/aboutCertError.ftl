# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } utilise un certificat de sécurité invalide.

cert-error-mitm-intro = Les sites web prouvent leur identité en utilisant des certificats, qui sont émis par des autorités de certification.

cert-error-mitm-mozilla = { -brand-short-name } est soutenu par Waterfox, une organisation à but non lucratif qui gère un magasin d’autorité de certification (CA) entièrement ouvert. Ce magasin de CA aide à garantir que les autorités de certification respectent de bonnes pratiques de sécurité pour protéger les utilisateurs.

cert-error-mitm-connection = { -brand-short-name } utilise le magasin d’autorités de certification Waterfox pour vérifier qu’une connexion est sécurisée, plutôt que des certificats fournis par le système d’exploitation de l’utilisateur. Ainsi, si un programme antivirus ou un réseau intercepte une connexion avec un certificat de sécurité émis par une autorité de certification ne figurant pas dans le magasin d’autorité de certification Waterfox, la connexion est considérée comme non sécurisée.

cert-error-trust-unknown-issuer-intro = Quelqu’un pourrait être en train d’essayer d’usurper l’identité du site. Vous ne devriez pas poursuivre.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Les sites web justifient leur identité par des certificats. { -brand-short-name } ne fait pas confiance à { $hostname }, car l’émetteur de son certificat est inconnu, le certificat est auto-signé ou le serveur n’envoie pas les certificats intermédiaires corrects.

cert-error-trust-cert-invalid = Le certificat n’est pas sûr car le certificat de l’autorité l’ayant délivré est invalide.

cert-error-trust-untrusted-issuer = Le certificat n’est pas sûr car le certificat de l’autorité l’ayant délivré n’est pas digne de confiance.

cert-error-trust-signature-algorithm-disabled = Le certificat n’est pas sûr car il a été signé à l’aide d’un algorithme de signature qui a été désactivé car cet algorithme n’est pas sécurisé.

cert-error-trust-expired-issuer = Le certificat n’est pas sûr car le certificat de l’autorité l’ayant délivré a expiré.

cert-error-trust-self-signed = Le certificat n’est pas sûr car il est auto-signé.

cert-error-trust-symantec = Les certificats émis par GeoTrust, RapidSSL, Symantec, Thawte et VeriSign ne sont plus considérés comme sécurisés car ces autorités de certification ont, dans le passé, omis de respecter des pratiques de sécurité.

cert-error-untrusted-default = Le certificat ne provient pas d’une source sûre.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Les sites web justifient leur identité par des certificats. { -brand-short-name } ne fait pas confiance à ce site, car il utilise un certificat qui n’est pas valide pour { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Les sites web justifient leur identité par des certificats. { -brand-short-name } ne fait pas confiance à ce site, car il utilise un certificat qui n’est pas valide pour { $hostname }. Le certificat n’est valide que pour <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Les sites web justifient leur identité par des certificats. { -brand-short-name } ne fait pas confiance à ce site, car il utilise un certificat qui n’est pas valide pour { $hostname }. Le certificat n’est valide que pour { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Les sites web justifient leur identité par des certificats. { -brand-short-name } ne fait pas confiance à ce site, car il utilise un certificat qui n’est pas valide pour { $hostname }. Le certificat est seulement valide pour les noms suivants : { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Les sites web justifient leur identité par des certificats qui ont une période de validité définie. Le certificat de { $hostname } a expiré le { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Les sites web justifient leur identité par des certificats qui ont une période de validité définie. Le certificat de { $hostname } ne sera pas valide jusqu’au { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Code d’erreur : <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Les sites web justifient leur identité avec des certificats émis par des autorités de certification. La plupart des navigateurs ne font plus confiance aux certificats émis par GeoTrust, RapidSSL, Symantec, Thawte, et VeriSign. { $hostname } utilise un certificat émis par l’une de ces autorités ; par conséquent, l’identité du site ne peut être validée.

cert-error-symantec-distrust-admin = Vous pouvez informer l’administrateur du site web de ce problème.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security : { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning : { $hasHPKP }

cert-error-details-cert-chain-label = Chaîne de certificat :

open-in-new-window-for-csp-or-xfo-error = Ouvrir le site dans une nouvelle fenêtre

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Pour protéger votre sécurité, { $hostname } ne permettra pas à { -brand-short-name } d’afficher la page si celle-ci est intégrée par un autre site. Pour voir cette page, vous devez l’ouvrir dans une nouvelle fenêtre.

## Messages used for certificate error titles

connectionFailure-title = La connexion a échoué
deniedPortAccess-title = Cette adresse est interdite
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hum, nous ne parvenons pas à trouver ce site.
fileNotFound-title = Fichier introuvable
fileAccessDenied-title = L’accès au fichier a été refusé
generic-title = La requête ne peut aboutir
captivePortal-title = Se connecter au réseau
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hum, cette adresse ne semble pas valide.
netInterrupt-title = La connexion a été interrompue
notCached-title = Le document a expiré
netOffline-title = Mode hors connexion
contentEncodingError-title = Erreur d’encodage de contenu
unsafeContentType-title = Type de fichier non sûr
netReset-title = La connexion a été réinitialisée
netTimeout-title = Le délai d’attente est dépassé
unknownProtocolFound-title = L’adresse n’a pas été reconnue
proxyConnectFailure-title = La connexion a été refusée par le serveur proxy
proxyResolveFailure-title = Le serveur proxy est introuvable
redirectLoop-title = La page n’est pas redirigée correctement
unknownSocketType-title = Réponse inattendue du serveur
nssFailure2-title = Échec de la connexion sécurisée
csp-xfo-error-title = { -brand-short-name } ne peut pas ouvrir cette page
corruptedContentError-title = Erreur due à un contenu corrompu
remoteXUL-title = XUL distant
sslv3Used-title = Impossible d’établir une connexion sécurisée
inadequateSecurityError-title = La connexion n’est pas sécurisée
blockedByPolicy-title = Page bloquée
clockSkewError-title = L’heure de votre ordinateur est incorrecte
networkProtocolError-title = Erreur de protocole réseau
nssBadCert-title = Attention : risque probable de sécurité
nssBadCert-sts-title = Connexion bloquée : problème de sécurité potentiel
certerror-mitm-title = Un logiciel empêche { -brand-short-name } de se connecter de façon sécurisée à ce site
