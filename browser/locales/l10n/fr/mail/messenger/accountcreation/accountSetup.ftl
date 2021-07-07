# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Configuration du compte

## Header

account-setup-title = Configurez votre adresse électronique existante
account-setup-description =
    Pour utiliser votre adresse électronique actuelle, remplissez vos identifiants.<br/>
    { -brand-product-name } recherchera automatiquement une configuration de serveur fonctionnelle et recommandée.

## Form fields

account-setup-name-label = Votre nom complet
    .accesskey = n
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = Jean·ne Dupont
account-setup-name-info-icon =
    .title = Votre nom, tel qu’il apparaitra aux autres
account-setup-name-warning-icon =
    .title = { account-setup-name-warning }
account-setup-email-label = Adresse électronique
    .accesskey = e
account-setup-email-input =
    .placeholder = jean.ne.dupont@example.com
account-setup-email-info-icon =
    .title = Votre adresse électronique existante
account-setup-email-warning-icon =
    .title = { account-setup-email-warning }
account-setup-password-label = Mot de passe
    .accesskey = p
    .title = Facultatif, sera uniquement utilisé pour valider le nom d’utilisateur
account-provisioner-button = Obtenir une nouvelle adresse électronique
    .accesskey = b
account-setup-password-toggle =
    .title = Afficher/masquer le mot de passe
account-setup-remember-password = Retenir le mot de passe
    .accesskey = m
account-setup-exchange-label = Votre identifiant
    .accesskey = i
#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = VOTREDOMAINE\votrenomd’utilisateur
#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Identifiant du domaine

## Action buttons

account-setup-button-cancel = Annuler
    .accesskey = A
account-setup-button-manual-config = Configuration manuelle
    .accesskey = m
account-setup-button-stop = Arrêter
    .accesskey = A
account-setup-button-retest = Retester
    .accesskey = t
account-setup-button-continue = Continuer
    .accesskey = C
account-setup-button-done = Terminé
    .accesskey = n

## Notifications

account-setup-looking-up-settings = Recherche de la configuration…
account-setup-looking-up-settings-guess = Recherche de la configuration : essai des noms de serveurs courants…
account-setup-looking-up-settings-half-manual = Recherche de la configuration : sondage du serveur…
account-setup-looking-up-disk = Recherche de la configuration : installation de { -brand-short-name }…
account-setup-looking-up-isp = Recherche de la configuration : fournisseur de messagerie…
# Note: Do not translate or replace Mozilla. It stands for the public project mozilla.org, not Mozilla Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Recherche de la configuration : base de données des FAI de Mozilla…
account-setup-looking-up-mx = Recherche de la configuration : domaine de messagerie entrant…
account-setup-looking-up-exchange = Recherche de la configuration : serveur Exchange…
account-setup-checking-password = Vérification du mot de passe…
account-setup-installing-addon = Téléchargement et installation du module…
account-setup-success-half-manual = Les paramètres suivants ont été trouvés en sondant le serveur donné :
account-setup-success-guess = Configuration trouvée en essayant les noms de serveur courants.
account-setup-success-guess-offline = Vous êtes en mode hors connexion. Certains paramètres ont été supposés mais vous devrez saisir les bons paramètres.
account-setup-success-password = Mot de passe OK
account-setup-success-addon = Installation du module complémentaire terminée
# Note: Do not translate or replace Mozilla. It stands for the public project mozilla.org, not Mozilla Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = Configuration trouvée dans la base de données des FAI de Mozilla.
account-setup-success-settings-disk = Configuration trouvée sur l’installation de { -brand-short-name }.
account-setup-success-settings-isp = Configuration trouvée chez le fournisseur de messagerie.
# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = Configuration trouvée pour un serveur Microsoft Exchange.

## Illustrations

account-setup-step1-image =
    .title = Configuration initiale
account-setup-step2-image =
    .title = Chargement…
account-setup-step3-image =
    .title = Configuration trouvée
account-setup-step4-image =
    .title = Erreur de connexion
account-setup-privacy-footnote = Vos identifiants seront utilisés conformément à notre <a data-l10n-name="privacy-policy-link">politique de confidentialité</a> et ne seront stockés que localement sur votre ordinateur.
account-setup-selection-help = Vous ne savez pas quoi sélectionner ?
account-setup-selection-error = Besoin d’aide ?
account-setup-documentation-help = Documentation d’installation
account-setup-forum-help = Forum d’assistance

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
        [one] Configuration disponible
       *[other] Configurations disponibles
    }
# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP
account-setup-result-imap-description = Gardez vos dossiers et messages synchronisés sur votre serveur
# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3
account-setup-result-pop-description = Conservez vos dossiers et messages sur votre ordinateur
# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange
account-setup-result-exchange-description = Serveur Microsoft Exchange
account-setup-incoming-title = Entrant
account-setup-outgoing-title = Sortant
account-setup-username-title = Nom d’utilisateur
account-setup-exchange-title = Serveur
account-setup-result-smtp = SMTP
account-setup-result-no-encryption = Aucun chiffrement
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS
account-setup-result-outgoing-existing = Utiliser le serveur SMTP sortant existant
# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = Entrant : { $incoming }, sortant : { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Échec de l’authentification. Soit les identifiants saisis sont incorrects, soit un nom d’utilisateur séparé est nécessaire pour se connecter. Ce nom d’utilisateur est généralement votre identifiant de domaine Windows, avec ou sans le domaine (par exemple, jeannedupont ou AD\\jeannedupont)
account-setup-credentials-wrong = Échec de l’authentification. Veuillez vérifier le nom d’utilisateur et le mot de passe
account-setup-find-settings-failed = { -brand-short-name } n’a pas trouvé les paramètres de votre compte de messagerie
account-setup-exchange-config-unverifiable = La configuration n’a pas pu être vérifiée. Si votre nom d’utilisateur et votre mot de passe sont corrects, il est probable que l’administrateur du serveur a désactivé la configuration sélectionnée pour votre compte. Essayez de sélectionner un autre protocole.

## Manual configuration area

account-setup-manual-config-title = Paramètres du serveur
account-setup-incoming-server-legend = Serveur entrant
account-setup-protocol-label = Protocole :
protocol-imap-option = { account-setup-result-imap }
protocol-pop-option = { account-setup-result-pop }
protocol-exchange-option = { account-setup-result-exchange }
account-setup-hostname-label = Nom d’hôte :
account-setup-port-label = Port :
    .title = Indiquez 0 pour utiliser la détection automatique
account-setup-auto-description = { -brand-short-name } essayera de détecter automatiquement les champs qui sont laissés vides.
account-setup-ssl-label = Sécurité de la connexion :
account-setup-outgoing-server-legend = Serveur sortant

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Autodétection
ssl-no-authentication-option = Pas d’authentification
ssl-cleartext-password-option = Mot de passe normal
ssl-encrypted-password-option = Mot de passe chiffré

## Incoming/Outgoing SSL options

ssl-noencryption-option = Aucun
account-setup-auth-label = Méthode d’authentification :
account-setup-username-label = Nom d’utilisateur :
account-setup-advanced-setup-button = Configuration avancée
    .accesskey = a

## Warning insecure server dialog

account-setup-insecure-title = Avertissement !
account-setup-insecure-incoming-title = Paramètres du courrier entrant :
account-setup-insecure-outgoing-title = Paramètres du courrier sortant :
# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = <b>{ $server }</b> n’utilise pas de chiffrement.
account-setup-warning-cleartext-details = Les serveurs de courrier non sécurisés n’utilisent pas de connexions chiffrées pour protéger vos mots de passe et vos informations privées. En vous connectant à ce serveur, vous pourriez exposer votre mot de passe et vos informations privées.
account-setup-insecure-server-checkbox = Je comprends les risques
    .accesskey = u
account-setup-insecure-description = { -brand-short-name } peut vous permettre d’accéder à vos courriels en utilisant les configurations fournies. Cependant, vous devriez contacter votre administrateur ou votre fournisseur de messagerie au sujet de ces connexions incorrectes. Consultez la <a data-l10n-name="thunderbird-faq-link">FAQ de Thunderbird</a> pour plus d’informations.
insecure-dialog-cancel-button = Modifier les paramètres
    .accesskey = s
insecure-dialog-confirm-button = Confirmer
    .accesskey = C

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = { -brand-short-name } a trouvé les informations de configuration de votre compte sur { $domain }. Voulez-vous continuer et soumettre vos informations d’identification ?
exchange-dialog-confirm-button = Connexion
exchange-dialog-cancel-button = Annuler

## Alert dialogs

account-setup-creation-error-title = Erreur lors de la création du compte
account-setup-error-server-exists = Le serveur de courrier entrant existe déjà.
account-setup-confirm-advanced-title = Confirmer la configuration avancée
account-setup-confirm-advanced-description = Cette boîte de dialogue sera fermée et un compte avec les paramètres actuels sera créé, même si la configuration est incorrecte. Voulez-vous poursuivre ?

## Addon installation section

account-setup-addon-install-title = Installation
account-setup-addon-install-intro = Un module complémentaire tiers peut vous permettre d’accéder à votre compte de messagerie sur ce serveur :
account-setup-addon-no-protocol = Malheureusement, ce serveur de messagerie ne prend pas en charge les protocoles ouverts. { account-setup-addon-install-intro }

## Success view


## Calendar synchronization dialog

