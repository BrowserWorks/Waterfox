# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = Données internes de WebRTC

# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = enregistrer about:webrtc sous

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = Journalisation AEC 
about-webrtc-aec-logging-off-state-label = Démarrer la journalisation AEC
about-webrtc-aec-logging-on-state-label = Arrêter la journalisation AEC
about-webrtc-aec-logging-on-state-msg = Journalisation AEC active (discutez quelques minutes avec votre correspondant puis arrêtez l’enregistrement)

##

# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = Identifiant PeerConnection:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = SDP local
about-webrtc-local-sdp-heading-offer = SDP local (Proposition)
about-webrtc-local-sdp-heading-answer = SDP local (Réponse)
about-webrtc-remote-sdp-heading = SDP distant
about-webrtc-remote-sdp-heading-offer = SDP distant (Proposition)
about-webrtc-remote-sdp-heading-answer = SDP distant (Réponse)
about-webrtc-sdp-history-heading = Historique SDP
about-webrtc-sdp-parsing-errors-heading = Erreurs d’analyse SDP

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = Statistiques RTP

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = État ICE
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = Statistiques ICE
about-webrtc-ice-restart-count-label = Redémarrages ICE:
about-webrtc-ice-rollback-count-label = Restaurations ICE:
about-webrtc-ice-pair-bytes-sent = Octets envoyés:
about-webrtc-ice-pair-bytes-received = Octets reçus:
about-webrtc-ice-component-id = ID du composant

## "Avg." is an abbreviation for Average. These are used as data labels.

about-webrtc-avg-bitrate-label = Débit binaire moyen :
about-webrtc-avg-framerate-label = Taux moyen d’images par seconde :

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Local
about-webrtc-type-remote = Distant

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Nommé

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Sélectionné

about-webrtc-save-page-label = Enregistrer la page
about-webrtc-debug-mode-msg-label = Mode débogage 
about-webrtc-debug-mode-off-state-label = Démarrer le mode débogage
about-webrtc-debug-mode-on-state-label = Arrêter le mode débogage
about-webrtc-stats-heading = Statistiques de session
about-webrtc-stats-clear = Effacer l’historique
about-webrtc-log-heading = Historique de connexion
about-webrtc-log-clear = Effacer l’historique
about-webrtc-log-show-msg = afficher l’historique
    .title = cliquer pour développer cette section
about-webrtc-log-hide-msg = masquer l’historique
    .title = cliquer pour réduire cette section

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (fermée) { $now }

##

about-webrtc-local-candidate = Candidat local
about-webrtc-remote-candidate = Candidat distant
about-webrtc-raw-candidates-heading = Tous les candidats bruts
about-webrtc-raw-local-candidate = Candidat brut local
about-webrtc-raw-remote-candidate = Candidat brut distant
about-webrtc-raw-cand-show-msg = afficher les candidats bruts
    .title = cliquer pour développer cette section
about-webrtc-raw-cand-hide-msg = masquer les candidats bruts
    .title = cliquer pour réduire cette section
about-webrtc-priority = Priorité
about-webrtc-fold-show-msg = afficher les détails
    .title = cliquer pour développer cette section
about-webrtc-fold-hide-msg = masquer les détails
    .title = cliquer pour réduire cette section
about-webrtc-dropped-frames-label = Images perdues :
about-webrtc-discarded-packets-label = Paquets ignorés :
about-webrtc-decoder-label = Décodeur
about-webrtc-encoder-label = Encodeur
about-webrtc-show-tab-label = Afficher l’onglet
about-webrtc-width-px = Largeur (px)
about-webrtc-height-px = Hauteur (px)
about-webrtc-consecutive-frames = Images consécutives
about-webrtc-time-elapsed = Temps écoulé (s)
about-webrtc-estimated-framerate = Images par seconde estimées
about-webrtc-rotation-degrees = Rotation (degrés)
about-webrtc-first-frame-timestamp = Horodatage de réception de la première image
about-webrtc-last-frame-timestamp = Horodatage de réception de la dernière image

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = SSRC de réception locale
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = SSRC d’envoi à distance

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Fourni

# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Non fourni

# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Préférences WebRTC définies par l’utilisateur ou l’utilisatrice

# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Bande passante estimée

# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Numéro de piste

# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Débit montant (octets/s)

# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Débit descendant (octets/s)

# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Bourrage maximal (octets/s)

# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Délai d’espacement (ms)

# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT ms

# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Statistiques d’images vidéo - ID MediaStreamTrack : { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = page enregistrée à l’emplacement suivant : { $path }
about-webrtc-debug-mode-off-state-msg = le fichier de la trace est disponible à l’emplacement suivant : { $path }
about-webrtc-debug-mode-on-state-msg = mode débogage actif, le fichier de la trace est disponible à l’emplacement suivant : { $path }
about-webrtc-aec-logging-off-state-msg = les fichiers de journalisation capturés sont disponibles à l’emplacement suivant : { $path }

##

# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
        [one] Un paquet reçu
       *[other] { $packets } paquets reçus
    }

# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
        [one] Un paquet perdu
       *[other] { $packets } paquets perdus
    }

# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
        [one] Un paquet envoyé
       *[other] { $packets } paquets envoyés
    }

# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Gigue { $jitter }

# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Les candidats lents (arrivant après la réponse) sont affichés avec un fond bleu

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Définir SDP local à l’horodatage { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Définir SDP distant à l’horodatage { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Horodatage { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

##

