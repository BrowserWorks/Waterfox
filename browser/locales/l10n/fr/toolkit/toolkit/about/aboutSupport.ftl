# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Informations de dépannage
page-subtitle =
    Cette page contient des informations techniques qui pourraient être utiles quand vous essayez
    de résoudre un problème. Si vous cherchez des réponses à des questions courantes
    sur { -brand-short-name }, veuillez consulter notre <a data-l10n-name="support-link">site web d’assistance</a>.

crashes-title = Rapports de plantage
crashes-id = Identifiant du rapport
crashes-send-date = Date d’envoi
crashes-all-reports = Tous les rapports de plantage
crashes-no-config = Cette application n’a pas été configurée pour afficher les rapports de plantage.
support-addons-title = Modules complémentaires
support-addons-name = Nom
support-addons-type = Type
support-addons-enabled = Activé
support-addons-version = Version
support-addons-id = ID
security-software-title = Logiciel de sécurité
security-software-type = Type
security-software-name = Nom
security-software-antivirus = Antivirus
security-software-antispyware = Logiciel anti-espion
security-software-firewall = Pare-feu
features-title = Fonctionnalités de { -brand-short-name }
features-name = Nom
features-version = Version
features-id = ID
processes-title = Processus distants
processes-type = Type
processes-count = Nombre
app-basics-title = Paramètres de base de l’application
app-basics-name = Nom
app-basics-version = Version
app-basics-build-id = Identifiant de compilation
app-basics-distribution-id = ID de distribution
app-basics-update-channel = Canal de mise à jour
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Répertoire pour les mises à jour
       *[other] Dossier pour les mises à jour
    }
app-basics-update-history = Historique des mises à jour
app-basics-show-update-history = Afficher l’historique des mises à jour
# Represents the path to the binary used to start the application.
app-basics-binary = Binaire de l’application
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Répertoire de profil
       *[other] Dossier de profil
    }
app-basics-enabled-plugins = Plugins activés
app-basics-build-config = Configuration de compilation
app-basics-user-agent = Agent utilisateur
app-basics-os = Système d’exploitation
app-basics-os-theme = Thème du système d’exploitation
# Rosetta is Apple's translation process to run apps containing x86_64
# instructions on Apple Silicon. This should remain in English.
app-basics-rosetta = Traduit par Rosetta
app-basics-memory-use = Utilisation mémoire
app-basics-performance = Performances
app-basics-service-workers = Service workers inscrits
app-basics-third-party = Modules tiers
app-basics-profiles = Profils
app-basics-launcher-process-status = Processus de lancement
app-basics-multi-process-support = Fenêtres multiprocessus
app-basics-fission-support = Fenêtres Fission
app-basics-remote-processes-count = Processus distants
app-basics-enterprise-policies = Stratégies d’entreprise
app-basics-location-service-key-google = Clé du service de localisation de Google
app-basics-safebrowsing-key-google = Clé de Google Safebrowsing
app-basics-key-mozilla = Clé du service de localisation de Waterfox
app-basics-safe-mode = Mode sans échec
show-dir-label =
    { PLATFORM() ->
        [macos] Afficher dans le Finder
        [windows] Ouvrir le dossier correspondant
       *[other] Ouvrir le dossier correspondant
    }
environment-variables-title = Variables d’environnement
environment-variables-name = Nom
environment-variables-value = Valeur
experimental-features-title = Fonctionnalités expérimentales
experimental-features-name = Nom
experimental-features-value = Valeur
modified-key-prefs-title = Préférences modifiées importantes
modified-prefs-name = Nom
modified-prefs-value = Valeur
user-js-title = Préférences de user.js
user-js-description = Votre dossier de profil possède un <a data-l10n-name="user-js-link">fichier user.js</a> contenant les préférences qui n’ont pas été créées par { -brand-short-name }.
locked-key-prefs-title = Préférences verrouillées importantes
locked-prefs-name = Nom
locked-prefs-value = Valeur
graphics-title = Accélération graphique
graphics-features-title = Fonctionnalités
graphics-diagnostics-title = Diagnostics
graphics-failure-log-title = Journal des échecs
graphics-gpu1-title = GPU 1
graphics-gpu2-title = GPU 2
graphics-decision-log-title = Journal des décisions
graphics-crash-guards-title = Fonctionnalités désactivées par la protection contre les plantages
graphics-workarounds-title = Solutions de contournement
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Protocole de fenêtrage
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Environnement de bureau
place-database-title = Base de données « Places »
place-database-integrity = Intégrité
place-database-verify-integrity = Vérifier l’intégrité
a11y-title = Accessibilité
a11y-activated = Activée
a11y-force-disabled = Empêcher l’accessibilité
a11y-handler-used = Utilisation d’un gestionnaire accessible
a11y-instantiator = Générateur d’accessibilité
library-version-title = Versions des bibliothèques
copy-text-to-clipboard-label = Copier le texte dans le presse-papiers
copy-raw-data-to-clipboard-label = Copier les informations brutes dans le presse-papiers
sandbox-title = Bac à sable
sandbox-sys-call-log-title = Appels système rejetés
sandbox-sys-call-index = #
sandbox-sys-call-age = Il y a quelques secondes
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Type de processus
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Arguments
troubleshoot-mode-title = Diagnostiquer des problèmes
restart-in-troubleshoot-mode-label = Mode de dépannage…
clear-startup-cache-title = Essayez de vider le cache de démarrage
clear-startup-cache-label = Vider le cache de démarrage…
startup-cache-dialog-title2 = Redémarrer { -brand-short-name } pour effacer le cache de démarrage ?
startup-cache-dialog-body2 = Cela ne modifiera pas vos paramètres ni ne supprimera les extensions.
restart-button-label = Redémarrer

## Media titles

audio-backend = Backend audio
max-audio-channels = Nombre maximum de canaux
sample-rate = Fréquence d’échantillonnage préférée
roundtrip-latency = Latence aller-retour (écart type)
media-title = Multimédia
media-output-devices-title = Périphériques de sortie
media-input-devices-title = Périphériques d’entrée
media-device-name = Nom
media-device-group = Groupe
media-device-vendor = Fabricant
media-device-state = État
media-device-preferred = Préféré
media-device-format = Format
media-device-channels = Canaux
media-device-rate = Fréquence
media-device-latency = Latence
media-capabilities-title = Capacités média
# List all the entries of the database.
media-capabilities-enumerate = Parcourir la base de données

##

intl-title = Langue et internationalisation
intl-app-title = Paramètres d’application
intl-locales-requested = Langues demandées
intl-locales-available = Langues disponibles
intl-locales-supported = Langues de l’application
intl-locales-default = Langue par défaut
intl-os-title = Système d’exploitation
intl-os-prefs-system-locales = Langues du système
intl-regional-prefs = Préférences régionales

## Remote Debugging
##
## The Waterfox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Débogage à distance (protocole Chromium)
remote-debugging-accepting-connections = Accepter les connexions
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Rapports de plantage de la veille
       *[other] Rapports de plantage des { $days } derniers jours
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] Il y a { $minutes } minute
       *[other] Il y a { $minutes } minutes
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] Il y a { $hours } heure
       *[other] Il y a { $hours } heures
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] Il y a { $days } jour
       *[other] Il y a { $days } jours
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Tous les rapports de plantage (y compris { $reports } rapport en attente d’un plantage ayant eu lieu dans l’intervalle)
       *[other] Tous les rapports de plantage (y compris { $reports } rapports en attente de plantages ayant eu lieu dans l’intervalle)
    }

raw-data-copied = Informations brutes copiées dans le presse-papiers
text-copied = Texte copié dans le presse-papiers

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Bloqué pour la version de votre pilote graphique.
blocked-gfx-card = Bloqué pour votre carte graphique à cause de problèmes non résolus du pilote.
blocked-os-version = Bloqué pour la version de votre système d’exploitation.
blocked-mismatched-version = Bloqué pour la version de votre pilote graphique car la version diffère entre le registre et les DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Bloqué pour la version de votre pilote graphique. Essayez de faire la mise à jour de votre pilote graphique vers la version { $driverVersion } ou supérieure.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Paramètres ClearType

compositing = Composition
hardware-h264 = Décodage matériel H264
main-thread-no-omtc = Fil d’exécution principal, pas d’OMTC
yes = Oui
no = Non
unknown = Inconnu
virtual-monitor-disp = Affichage virtuel

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Présente
missing = Manquante

gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Description
gpu-vendor-id = ID du vendeur
gpu-device-id = ID du périphérique
gpu-subsys-id = ID du sous-système
gpu-drivers = Pilotes
gpu-ram = RAM
gpu-driver-vendor = Éditeur du pilote
gpu-driver-version = Version du pilote
gpu-driver-date = Date du pilote
gpu-active = Actif
webgl1-wsiinfo = Pilote WebGL 1 - Informations WSI
webgl1-renderer = Pilote WebGL 1 - Rendu
webgl1-version = Pilote WebGL 1 - Version
webgl1-driver-extensions = Pilote WebGL 1 - Extensions
webgl1-extensions = WebGL 1 - Extensions
webgl2-wsiinfo = Pilote WebGL 2 - Informations WSI
webgl2-renderer = Pilote WebGL 2 - Rendu
webgl2-version = Pilote WebGL 2 - Version
webgl2-driver-extensions = Pilote WebGL 2 - Extensions
webgl2-extensions = WebGL 2 - Extensions

# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Mis en liste de blocage en raison de problèmes connus : <a data-l10n-name="bug-link">bug { $bugNumber }</a>

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Mis sur liste de blocage ; code d’erreur { $failureCode }

d3d11layers-crash-guard = Compositeur D3D11
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = Décodeur vidéo WMF VPX

reset-on-next-restart = Réinitialisé au prochain démarrage
gpu-process-kill-button = Arrêter le processus GPU
gpu-device-reset = Réinitialisation de l’appareil
gpu-device-reset-button = Déclencher la réinitialisation de l’appareil
uses-tiling = Utilise le pavage
content-uses-tiling = Utilise le pavage (contenu)
off-main-thread-paint-enabled = Painting en dehors du fil d’exécution principal activé
off-main-thread-paint-worker-count = Nombre de workers participant au painting en dehors du fil d’exécution principal
target-frame-rate = Fréquence d’images cible

min-lib-versions = Version minimale attendue
loaded-lib-versions = Version utilisée

has-seccomp-bpf = Seccomp-BPF (Filtrage des appels système)
has-seccomp-tsync = Synchronisation du fil d’exécution Seccomp
has-user-namespaces = Espace de noms utilisateur
has-privileged-user-namespaces = Espace de noms utilisateur pour les processus privilégiés
can-sandbox-content = Bac à sable pour les processus de contenu
can-sandbox-media = Bac à sable pour les plugins multimédia
content-sandbox-level = Niveau du bac à sable pour les processus de contenu
effective-content-sandbox-level = Niveau effectif du bac à sable pour les processus de contenu
content-win32k-lockdown-state = État de verrouillage Win32k pour le processus de contenu
sandbox-proc-type-content = contenu
sandbox-proc-type-file = contenu du fichier
sandbox-proc-type-media-plugin = plugin multimédia
sandbox-proc-type-data-decoder = décodeur de données

startup-cache-title = Cache de démarrage
startup-cache-disk-cache-path = Chemin du cache disque
startup-cache-ignore-disk-cache = Ignorer le cache disque
startup-cache-found-disk-cache-on-init = Cache disque trouvé à l’initialisation
startup-cache-wrote-to-disk-cache = Écriture dans le cache disque

launcher-process-status-0 = Activé
launcher-process-status-1 = Désactivé en raison d’une défaillance
launcher-process-status-2 = Désactivé de force
launcher-process-status-unknown = État inconnu

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/{ $totalWindows }
fission-status-experiment-control = Désactivées par une expérience
fission-status-experiment-treatment = Activées par une expérience
fission-status-disabled-by-e10s-env = Désactivées par l’environnement
fission-status-enabled-by-env = Activées par l’environnement
fission-status-disabled-by-safe-mode = Désactivées par le mode sans échec
fission-status-enabled-by-default = Activées par défaut
fission-status-disabled-by-default = Désactivées par défaut
fission-status-enabled-by-user-pref = Activées par l’utilisateur
fission-status-disabled-by-user-pref = Désactivées par l’utilisateur
fission-status-disabled-by-e10s-other = Désactivées par E10s
fission-status-enabled-by-rollout = Activé par déploiement progressif

async-pan-zoom = Zoom/Panoramique asynchrones
apz-none = aucun
wheel-enabled = entrée molette activée
touch-enabled = entrée tactile activée
drag-enabled = faire glisser les barres de défilement
keyboard-enabled = clavier activé
autoscroll-enabled = défilement automatique activé
zooming-enabled = zoom fluide par pincement activé

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = entrée molette asynchrone désactivée en raison d’une préférence non prise en charge : { $preferenceKey }
touch-warning = entrée tactile asynchrone désactivée en raison d’une préférence non prise en charge : { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Inactives
policies-active = Actives
policies-error = Erreur

## Printing section

support-printing-title = Impression
support-printing-troubleshoot = Résolution de problèmes
support-printing-clear-settings-button = Effacer les paramètres d’impression enregistrés
support-printing-modified-settings = Paramètres d’impression modifiés
support-printing-prefs-name = Nom
support-printing-prefs-value = Valeur

## Normandy sections

support-remote-experiments-title = Expériences à distance
support-remote-experiments-name = Nom
support-remote-experiments-branch = Branche expérimentale
support-remote-experiments-see-about-studies = Consultez <a data-l10n-name="support-about-studies-link">about:studies</a> pour plus d’informations, notamment sur la façon de désactiver des tests individuels ou d’empêcher { -brand-short-name } d’exécuter ce  type d’expérience dans le futur.

support-remote-features-title = Fonctionnalités distantes
support-remote-features-name = Nom
support-remote-features-status = État
