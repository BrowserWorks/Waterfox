# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Définir les stratégies auxquelles les WebExtensions peuvent accéder par chrome.storage.managed.

policy-AppAutoUpdate = Activer ou désactiver les mises à jour automatiques des applications.

policy-AppUpdateURL = Définir une URL personnalisée pour la mise à jour de l’application.

policy-Authentication = Configurer l’authentification intégrée pour les sites web qui la prennent en charge.

policy-BackgroundAppUpdate2 = Activer ou désactiver la mise à jour en arrière-plan.

policy-BlockAboutAddons = Bloquer l’accès au gestionnaire de modules complémentaires (about:addons).

policy-BlockAboutConfig = Bloquer l’accès à la page about:config.

policy-BlockAboutProfiles = Bloquer l’accès à la page about:profiles.

policy-BlockAboutSupport = Bloquer l’accès à la page about:support.

policy-CaptivePortal = Activer ou désactiver la prise en charge du portail captif.

policy-CertificatesDescription = Ajouter des certificats ou utiliser les certificats intégrés.

policy-Cookies = Autoriser ou refuser les cookies des sites web.

policy-DisableBuiltinPDFViewer = Désactiver PDF.js, la visionneuse PDF intégrée dans { -brand-short-name }.

policy-DisabledCiphers = Désactiver les chiffrements.

policy-DefaultDownloadDirectory = Définir le répertoire de téléchargement par défaut.

policy-DisableAppUpdate = Empêcher la mise à jour de { -brand-short-name }.

policy-DisableDefaultClientAgent = Empêcher l’agent du client par défaut de prendre des mesures. Uniquement applicable à Windows ; les autres plateformes n’ont pas cet agent.

policy-DisableDeveloperTools = Bloquer l’accès aux outils de développement.

policy-DisableFeedbackCommands = Désactiver les commandes permettant d’envoyer des commentaires dans le menu Aide (« Donner votre avis… » et « Signaler un site trompeur… »).

policy-DisableForgetButton = Empêcher l’accès au bouton d’effacement des données.

policy-DisableFormHistory = Désactiver la conservation de l’historique des recherches et des formulaires.

policy-DisableMasterPasswordCreation = Si la valeur est sur true, la création d’un mot de passe principal est impossible.

policy-DisablePasswordReveal = Ne pas permettre de révéler les mots de passe dans les identifiants enregistrés.

policy-DisableProfileImport = Désactiver la commande de menu pour importer des données depuis une autre application.

policy-DisableSafeMode = Désactiver le redémarrage en mode sans échec. Note : sous Windows, le passage en mode sans échec via la touche Majuscule ne peut être désactivé qu’à l’aide d’une stratégie de groupe.

policy-DisableSecurityBypass = Empêcher l’utilisateur de contourner certains avertissements de sécurité.

policy-DisableSystemAddonUpdate = Empêcher { -brand-short-name } d’installer et de mettre à jour des modules système.

policy-DisableTelemetry = Désactiver la télémétrie.

policy-DisplayMenuBar = Afficher la barre de menus par défaut.

policy-DNSOverHTTPS = Activer le DNS via HTTPS.

policy-DontCheckDefaultClient = Désactiver la vérification du client par défaut au démarrage.

policy-DownloadDirectory = Définir et verrouiller le répertoire de téléchargement.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Activer ou désactiver le blocage de contenu et éventuellement le verrouiller.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Activer ou désactiver les extensions de médias chiffrés (EME) et permettre de verrouiller ce choix.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Installer, désinstaller ou verrouiller les extensions. L’option Installer accepte des URL ou des chemins comme paramètres. Les options Désinstaller et Verrouiller utilisent les identifiants des extensions.

policy-ExtensionSettings = Gérer tous les aspects de l’installation d’extensions.

policy-ExtensionUpdate = Activer ou désactiver les mises à jour automatiques des extensions.

policy-Handlers = Configurer les gestionnaires d’applications par défaut.

policy-HardwareAcceleration = Si la valeur est sur false, l’accélération matérielle est désactivée.

policy-InstallAddonsPermission = Autoriser certains sites web à installer des modules complémentaires.

policy-LegacyProfiles = Désactiver la fonctionnalité qui impose l’utilisation d’un profil distinct pour chaque installation.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Activer par défaut le paramètre de comportement traditionnel SameSite pour les cookies.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Revenir au comportement traditionnel SameSite pour les cookies sur certains sites spécifiques.

##

policy-LocalFileLinks = Autoriser des sites web spécifiques à créer des liens vers des fichiers locaux.

policy-ManualAppUpdateOnly = Autoriser uniquement les mises à jour manuelles et ne pas informer l’utilisateur ou l’utilisatrice de la disponibilité de mises à jour.

policy-NetworkPrediction = Activer ou désactiver la prédiction réseau (prélecture DNS).

policy-OfferToSaveLogins = Appliquer les paramètres qui permettent à { -brand-short-name } de se souvenir des identifiants et des mots de passe enregistrés. Les valeurs true et false sont toutes deux acceptées.

policy-OfferToSaveLoginsDefault = Définir si, par défaut, { -brand-short-name } doit proposer de mémoriser des identifiants et des mots de passe. Les valeurs true et false sont toutes deux acceptées.

policy-OverrideFirstRunPage = Remplacer la page de premier démarrage. Laissez cette règle vide pour désactiver la page de premier démarrage.

policy-OverridePostUpdatePage = Remplacer la page « Nouveautés » après une mise à jour. Laissez cette règle vide pour désactiver la page qui s’ouvre après la mise à jour.

policy-PasswordManagerEnabled = Activer l’enregistrement des mots de passe dans le gestionnaire de mots de passe.

# PDF.js and PDF should not be translated
policy-PDFjs = Désactiver ou configurer PDF.js, la visionneuse PDF intégrée dans { -brand-short-name }.

policy-Permissions2 = Configurer les permissions pour la caméra, le microphone, la localisation, les notifications et la lecture automatique.

policy-Preferences = Définir et verrouiller la valeur pour un sous-ensemble de préférences.

policy-PrimaryPassword = Exiger ou empêcher l’utilisation d’un mot de passe principal.

policy-PromptForDownloadLocation = Demander où sauvegarder les fichiers lors du téléchargement.

policy-Proxy = Configurer les paramètres de proxy.

policy-RequestedLocales = Définir la liste des locales demandées par l’application, dans l’ordre de préférence.

policy-SanitizeOnShutdown2 = Effacer les données de navigation à la fermeture.

policy-SearchEngines = Configurer les paramètres du moteur de recherche. Cette propriété n’est disponible que sur la version Extended Support Release (ESR).

policy-SearchSuggestEnabled = Activer ou désactiver les suggestions de recherche.

# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Installer des modules PKCS #11.

policy-SSLVersionMax = Définir la version SSL maximale.

policy-SSLVersionMin = Définir la version SSL minimale.

policy-SupportMenu = Ajoute une entrée personnalisée au menu d’aide pour l’assistance.

policy-UserMessaging = Masquer certains messages à destination de l’utilisateur.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Bloquer l’accès à des sites web. Voir la documentation pour plus de détails sur le format.
