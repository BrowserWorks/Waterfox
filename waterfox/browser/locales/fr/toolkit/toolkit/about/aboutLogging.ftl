# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This is the title of the page
about-logging-title = À propos de la journalisation
about-logging-page-title = Gestionnaire de journalisation
about-logging-current-log-file = Fichier de journalisation actuel :
about-logging-new-log-file = Nouveau fichier journal :
about-logging-currently-enabled-log-modules = Modules de journalisation actuellement activés :
about-logging-log-tutorial = Consultez <a data-l10n-name="logging">HTTP Logging</a> pour obtenir des informations sur l’utilisation de cet outil.
# This message is used as a button label, "Open" indicates an action.
about-logging-open-log-file-dir = Ouvrir le répertoire
about-logging-set-log-file = Définir un fichier de journalisation
about-logging-set-log-modules = Définir des modules de journalisation
about-logging-start-logging = Lancer la journalisation
about-logging-stop-logging = Arrêter la journalisation
about-logging-buttons-disabled = La journalisation est configurée par les variables d’environnement, la configuration dynamique n’est pas disponible.
about-logging-some-elements-disabled = La journalisation est configurée par URL, certaines options de configuration ne sont pas disponibles
about-logging-info = Informations :
about-logging-log-modules-selection = Sélection des modules de journalisation
about-logging-new-log-modules = Nouveaux modules de journalisation :
about-logging-logging-output-selection = Sortie du journal
about-logging-logging-to-file = Sortie vers un fichier
about-logging-logging-to-profiler = Sortie vers le { -profiler-brand-name }
about-logging-no-log-modules = Aucun
about-logging-no-log-file = Aucun
about-logging-logging-preset-selector-text = Réglage de journalisation :
about-logging-with-profiler-stacks-checkbox = Activer les traces d’appels pour les messages du journal.

## Logging presets

about-logging-preset-networking-label = Réseau
about-logging-preset-networking-description = Modules de journalisation pour diagnostiquer les problèmes de réseau
about-logging-preset-networking-cookie-label = Cookies
about-logging-preset-networking-cookie-description = Modules de journalisation pour diagnostiquer les problèmes de cookies
about-logging-preset-networking-websocket-label = WebSocket
about-logging-preset-networking-websocket-description = Modules de journalisation pour diagnostiquer les problèmes de WebSocket
about-logging-preset-networking-http3-label = HTTP/3
about-logging-preset-networking-http3-description = Modules de journalisation pour diagnostiquer les problèmes d’HTTP/3 et QUIC
about-logging-preset-media-playback-label = Lecture multimédia
about-logging-preset-media-playback-description = Modules de journalisation pour diagnostiquer les problèmes de lecture multimédia (mais non ceux de visioconférence)
about-logging-preset-webrtc-label = WebRTC
about-logging-preset-webrtc-description = Modules de journalisation pour diagnostiquer les appels WebRTC
about-logging-preset-webgpu-label = WebGPU
about-logging-preset-webgpu-description = Modules de journalisation pour diagnostiquer les problèmes de WebGPU
about-logging-preset-gfx-label = Accélération graphique
about-logging-preset-gfx-description = Modules de journalisation pour diagnostiquer les problèmes d’accélération graphique
about-logging-preset-custom-label = Personnalisé
about-logging-preset-custom-description = Modules de journalisation sélectionnés manuellement
# Error handling
about-logging-error = Erreur :

## Variables:
##   $k (String) - Variable name
##   $v (String) - Variable value

about-logging-invalid-output = Valeur « { $v } » invalide pour la clé « { $k } »
about-logging-unknown-logging-preset = Réglage de journalisation « { $v } » inconnu
about-logging-unknown-profiler-preset = Réglage du profileur « { $v } » inconnu
about-logging-unknown-option = Option « { $k } » pour about:logging inconnue
about-logging-configuration-url-ignored = URL de configuration ignorée
about-logging-file-and-profiler-override = Impossible de forcer la sortie du fichier et de remplacer les options du profileur en même temps
about-logging-configured-via-url = Option configurée par URL
