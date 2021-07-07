# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Fermer
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Options
           *[other] Préférences
        }
preferences-tab-title =
    .title = Préférences
preferences-doc-title = Préférences
category-list =
    .aria-label = Catégories
pane-general-title = Général
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = Rédaction
category-compose =
    .tooltiptext = Rédaction
pane-privacy-title = Vie privée et sécurité
category-privacy =
    .tooltiptext = Vie privée et sécurité
pane-chat-title = Messagerie instantanée
category-chat =
    .tooltiptext = Messagerie instantanée
pane-calendar-title = Agenda
category-calendar =
    .tooltiptext = Agenda
general-language-and-appearance-header = Langue et apparence
general-incoming-mail-header = Courrier entrant
general-files-and-attachment-header = Fichiers et pièces jointes
general-tags-header = Étiquettes
general-reading-and-display-header = Lecture et affichage
general-updates-header = Mises à jour
general-network-and-diskspace-header = Réseau et espace disque
general-indexing-label = Indexation
composition-category-header = Rédaction
composition-attachments-header = Pièces jointes
composition-spelling-title = Orthographe
compose-html-style-title = Style HTML
composition-addressing-header = Adressage
privacy-main-header = Vie privée
privacy-passwords-header = Mots de passe
privacy-junk-header = Courrier indésirable
collection-header = Collecte de données par { -brand-short-name } et utilisation
collection-description = Nous nous efforçons de vous laisser le choix et de recueillir uniquement les informations dont nous avons besoin pour proposer { -brand-short-name } et l’améliorer pour tout le monde. Nous demandons toujours votre permission avant de recevoir des données personnelles.
collection-privacy-notice = Politique de confidentialité
collection-health-report-telemetry-disabled = Vous n’autorisez plus { -vendor-short-name } à capturer des données techniques et d’interaction. Toutes les données passées seront supprimées dans les 30 jours.
collection-health-report-telemetry-disabled-link = En savoir plus
collection-health-report =
    .label = Autoriser { -brand-short-name } à envoyer des données techniques et des données d’interaction à { -vendor-short-name }
    .accesskey = A
collection-health-report-link = En savoir plus
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = L’envoi de données est désactivé pour cette configuration de compilation
collection-backlogged-crash-reports =
    .label = Autoriser { -brand-short-name } à envoyer pour vous les rapports de plantage en attente
    .accesskey = u
collection-backlogged-crash-reports-link = En savoir plus
privacy-security-header = Sécurité
privacy-scam-detection-title = Détection de contenu frauduleux
privacy-anti-virus-title = Antivirus
privacy-certificates-title = Certificats
chat-pane-header = Messagerie instantanée
chat-status-title = Statut
chat-notifications-title = Notifications
chat-pane-styling-header = Styles
choose-messenger-language-description = Choisissez les langues utilisées pour afficher les menus, messages et notifications de { -brand-short-name }.
manage-messenger-languages-button =
    .label = Choisir des alternatives…
    .accesskey = l
confirm-messenger-language-change-description = Redémarrez { -brand-short-name } pour appliquer ces modifications
confirm-messenger-language-change-button = Appliquer et redémarrer
update-setting-write-failure-title = Erreur lors de l’enregistrement des préférences de mise à jour
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } a rencontré une erreur et n’a pas enregistré cette modification. Notez que modifier cette préférence de mise à jour nécessite la permission d’écriture pour le fichier ci-dessous. Vous, ou un administrateur système, pouvez peut-être corriger l’erreur en accordant au groupe Users l’accès complet à ce fichier.
    
    Écriture impossible dans le fichier : { $path }
update-in-progress-title = Mise à jour en cours
update-in-progress-message = Voulez-vous que { -brand-short-name } continue cette mise à jour ?
update-in-progress-ok-button = &Abandonner
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Continuer
addons-button = Extensions et thèmes
account-button = Paramètres des comptes
open-addons-sidebar-button = Modules complémentaires et thèmes

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Pour créer un mot de passe principal, saisissez vos informations de connexion Windows. Cela contribue à protéger la sécurité de vos comptes.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = créer un mot de passe principal
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Pour créer un mot de passe principal, saisissez vos informations de connexion Windows. Cela contribue à protéger la sécurité de vos comptes.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = créer un mot de passe principal
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend = Page de démarrage de { -brand-short-name }
start-page-label =
    .label = Afficher la page de démarrage au lancement de { -brand-short-name }
    .accesskey = A
location-label =
    .value = Adresse :
    .accesskey = d
restore-default-label =
    .label = Réinitialiser
    .accesskey = i
default-search-engine = Moteur de recherche par défaut
add-search-engine =
    .label = Ajouter depuis un fichier
    .accesskey = A
remove-search-engine =
    .label = Supprimer
    .accesskey = S
minimize-to-tray-label =
    .label = Quand { -brand-short-name } est réduit, le déplacer dans la barre de notification
    .accesskey = r
new-message-arrival = Quand un nouveau message arrive :
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Jouer le fichier son suivant :
           *[other] Jouer un son
        }
    .accesskey =
        { PLATFORM() ->
            [macos] J
           *[other] J
        }
mail-play-button =
    .label = Jouer le son
    .accesskey = o
change-dock-icon = Modifier les préférences de l’icône de l’application
app-icon-options =
    .label = Options de l’icône de l’application…
    .accesskey = n
notification-settings = Les alertes et le son par défaut peuvent être désactivés depuis le panneau Notifications dans les préférences système.
animated-alert-label =
    .label = Afficher un avertissement
    .accesskey = f
customize-alert-label =
    .label = Personnaliser…
    .accesskey = P
tray-icon-label =
    .label = Afficher une icône dans la barre de notification
    .accesskey = e
biff-use-system-alert =
    .label = Utiliser la notification système
tray-icon-unread-label =
    .label = Afficher une icône dans la barre des tâches pour les messages non lus
    .accesskey = t
tray-icon-unread-description = Recommandé lorsque vous utilisez de petits boutons dans la barre des tâches
mail-system-sound-label =
    .label = Son système par défaut pour la réception d’un nouveau message
    .accesskey = d
mail-custom-sound-label =
    .label = Utiliser le fichier son suivant :
    .accesskey = U
mail-browse-sound-button =
    .label = Parcourir…
    .accesskey = r
enable-gloda-search-label =
    .label = Activer la recherche et l’indexation globales
    .accesskey = c
datetime-formatting-legend = Format de date et heure
language-selector-legend = Langues
allow-hw-accel =
    .label = Utiliser l’accélération graphique matérielle si disponible
    .accesskey = i
store-type-label =
    .value = Type de stockage des messages pour les nouveaux comptes :
    .accesskey = k
mbox-store-label =
    .label = Un fichier par dossier (mbox)
maildir-store-label =
    .label = Un fichier par message (maildir)
scrolling-legend = Défilement
autoscroll-label =
    .label = Automatique
    .accesskey = u
smooth-scrolling-label =
    .label = Doux
    .accesskey = o
system-integration-legend = Intégration système
always-check-default =
    .label = Toujours vérifier si { -brand-short-name } est le client de messagerie par défaut au démarrage
    .accesskey = T
check-default-button =
    .label = Vérifier maintenant…
    .accesskey = V
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Recherche Windows
       *[other] { "" }
    }
search-integration-label =
    .label = Autoriser { search-engine-name } à rechercher dans les messages
    .accesskey = A
config-editor-button =
    .label = Éditeur de configuration…
    .accesskey = d
return-receipts-description = Gestion des accusés de réception dans { -brand-short-name }
return-receipts-button =
    .label = Accusés de réception…
    .accesskey = A
update-app-legend = Mises à jour de { -brand-short-name }
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Version { $version }
allow-description = Autoriser { -brand-short-name } à
automatic-updates-label =
    .label = Installer automatiquement les mises à jour (recommandé pour votre sécurité)
    .accesskey = A
check-updates-label =
    .label = Vérifier l’existence de mises à jour mais me laisser décider de leur installation
    .accesskey = C
update-history-button =
    .label = Afficher l’historique des mises à jour
    .accesskey = h
use-service =
    .label = Utiliser un service en arrière-plan pour installer les mises à jour
    .accesskey = s
cross-user-udpate-warning = Ce paramètre s’appliquera à tous les comptes Windows et aux profils { -brand-short-name } utilisant cette installation de { -brand-short-name }.
networking-legend = Connexion
proxy-config-description = Configurer la façon dont { -brand-short-name } se connecte à Internet
network-settings-button =
    .label = Paramètres…
    .accesskey = P
offline-legend = Hors connexion
offline-settings = Configurer les paramètres hors connexion
offline-settings-button =
    .label = Hors connexion…
    .accesskey = H
diskspace-legend = Espace disque
offline-compact-folder =
    .label = Compacter les dossiers quand cela économise au moins
    .accesskey = C
compact-folder-size =
    .value = Mo au total

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Utiliser jusqu’à
    .accesskey = U
use-cache-after = Mo d’espace disque pour le cache

##

smart-cache-label =
    .label = Modifier la gestion automatique du cache
    .accesskey = M
clear-cache-button =
    .label = Vider le cache maintenant
    .accesskey = V
fonts-legend = Polices et couleurs
default-font-label =
    .value = Police par défaut :
    .accesskey = D
default-size-label =
    .value = Taille :
    .accesskey = T
font-options-button =
    .label = Avancé…
    .accesskey = A
color-options-button =
    .label = Couleurs…
    .accesskey = C
display-width-legend = Messages en texte simple
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Afficher les émoticônes sous forme graphique
    .accesskey = f
display-text-label = Lors de l’affichage de citations en texte simple :
style-label =
    .value = Style :
    .accesskey = S
regular-style-item =
    .label = Normal
bold-style-item =
    .label = Gras
italic-style-item =
    .label = Italique
bold-italic-style-item =
    .label = Gras italique
size-label =
    .value = Taille :
    .accesskey = T
regular-size-item =
    .label = Normale
bigger-size-item =
    .label = Plus grande
smaller-size-item =
    .label = Plus petite
quoted-text-color =
    .label = Couleur :
    .accesskey = o
search-input =
    .placeholder = Rechercher
search-handler-table =
    .placeholder = Filtrer les types de contenu et les actions
type-column-label =
    .label = Type de contenu
    .accesskey = T
action-column-label =
    .label = Action
    .accesskey = A
save-to-label =
    .label = Enregistrer les fichiers sous
    .accesskey = E
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Choisir…
           *[other] Parcourir…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] P
        }
always-ask-label =
    .label = Toujours demander où enregistrer les fichiers
    .accesskey = o
display-tags-text = Les étiquettes peuvent être utilisées pour classer en catégories et donner un ordre de priorité à vos messages
new-tag-button =
    .label = Nouvelle…
    .accesskey = N
edit-tag-button =
    .label = Modifier…
    .accesskey = M
delete-tag-button =
    .label = Supprimer
    .accesskey = S
auto-mark-as-read =
    .label = Marquer automatiquement les messages comme lus
    .accesskey = M
mark-read-no-delay =
    .label = Dès l’affichage
    .accesskey = D

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Après un délai de
    .accesskey = A
seconds-label = secondes

##

open-msg-label =
    .value = Ouvrir les messages dans :
open-msg-tab =
    .label = un nouvel onglet
    .accesskey = v
open-msg-window =
    .label = une nouvelle fenêtre
    .accesskey = U
open-msg-ex-window =
    .label = une fenêtre existante
    .accesskey = e
close-move-delete =
    .label = Fermer la fenêtre ou l’onglet de message lors du déplacement ou de la suppression
    .accesskey = F
display-name-label =
    .value = Nom à afficher :
condensed-addresses-label =
    .label = N’afficher que le nom pour les personnes se trouvant dans le carnet d’adresses
    .accesskey = N

## Compose Tab

forward-label =
    .value = Transférer les messages :
    .accesskey = T
inline-label =
    .label = intégrés
as-attachment-label =
    .label = en pièces jointes
extension-label =
    .label = ajouter une extension au nom de fichier
    .accesskey = a

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Sauvegarde automatique toutes les
    .accesskey = S
auto-save-end = minutes

##

warn-on-send-accel-key =
    .label = Demander confirmation lors de l’utilisation d’un raccourci clavier pour envoyer un message
    .accesskey = D
spellcheck-label =
    .label = Vérifier l’orthographe avant l’envoi
    .accesskey = V
spellcheck-inline-label =
    .label = Activer la vérification pendant la saisie
    .accesskey = A
language-popup-label =
    .value = Langue :
    .accesskey = L
download-dictionaries-link = Télécharger d’autres dictionnaires
font-label =
    .value = Police :
    .accesskey = P
font-size-label =
    .value = Taille :
    .accesskey = e
default-colors-label =
    .label = Utiliser les couleurs par défaut du lecteur
    .accesskey = d
font-color-label =
    .value = Couleur du texte :
    .accesskey = C
bg-color-label =
    .value = Couleur de l’arrière-plan :
    .accesskey = u
restore-html-label =
    .label = Restaurer les paramètres initiaux
    .accesskey = R
default-format-label =
    .label = Utiliser le format paragraphe à la place du format texte principal par défaut
    .accesskey = P
format-description = Configuration du comportement pour l’envoi en format texte
send-options-label =
    .label = Options d’expédition…
    .accesskey = O
autocomplete-description = Lors de la recherche d’adresses, chercher les correspondances dans :
ab-label =
    .label = les carnets d’adresses locaux
    .accesskey = C
directories-label =
    .label = un serveur d’annuaire :
    .accesskey = s
directories-none-label =
    .none = Aucun
edit-directories-label =
    .label = Modifier les annuaires…
    .accesskey = M
email-picker-label =
    .label = Ajouter les adresses des messages sortants dans :
    .accesskey = A
default-directory-label =
    .value = Annuaire par défaut à l’ouverture de la fenêtre du carnet d’adresses :
    .accesskey = f
default-last-label =
    .none = Dernier annuaire utilisé
attachment-label =
    .label = Vérification de pièces jointes manquantes
    .accesskey = V
attachment-options-label =
    .label = Mots-clés
    .accesskey = M
enable-cloud-share =
    .label = Proposer le partage pour les fichiers de plus de
cloud-share-size =
    .value = Mo
add-cloud-account =
    .label = Ajouter…
    .accesskey = A
    .defaultlabel = Ajouter…
remove-cloud-account =
    .label = Supprimer
    .accesskey = S
find-cloud-providers =
    .value = Trouver plus de fournisseurs…
cloud-account-description = Ajouter un nouveau service de stockage en ligne

## Privacy Tab

mail-content = Contenu des messages
remote-content-label =
    .label = Autoriser le contenu distant dans les messages
    .accesskey = u
exceptions-button =
    .label = Exceptions…
    .accesskey = p
remote-content-info =
    .value = En savoir plus sur les problématiques de vie privée liées au contenu distant
web-content = Contenu web
history-label =
    .label = Se souvenir des sites web et liens visités
    .accesskey = S
cookies-label =
    .label = Accepter les cookies
    .accesskey = A
third-party-label =
    .value = Accepter les cookies tiers :
    .accesskey = c
third-party-always =
    .label = toujours
third-party-never =
    .label = jamais
third-party-visited =
    .label = depuis les sites visités
keep-label =
    .value = Les conserver jusqu’à :
    .accesskey = L
keep-expire =
    .label = leur expiration
keep-close =
    .label = la fermeture de { -brand-short-name }
keep-ask =
    .label = me demander à chaque fois
cookies-button =
    .label = Afficher les cookies…
    .accesskey = k
do-not-track-label =
    .label = Envoyer aux sites web un signal « Ne pas me pister » indiquant que vous ne souhaitez pas être pisté·e
    .accesskey = n
learn-button =
    .label = En savoir plus
passwords-description = { -brand-short-name } peut mémoriser les mots de passe pour tous vos comptes.
passwords-button =
    .label = Mots de passe enregistrés…
    .accesskey = M
master-password-description = Un mot de passe principal protège tous vos mots de passe, mais il faut le saisir une fois par session.
master-password-label =
    .label = Utiliser un mot de passe principal
    .accesskey = U
master-password-button =
    .label = Gérer le mot de passe principal…
    .accesskey = G
primary-password-description = Un mot de passe principal protège tous vos mots de passe, mais il faut le saisir une fois par session.
primary-password-label =
    .label = Utiliser un mot de passe principal
    .accesskey = U
primary-password-button =
    .label = Changer le mot de passe principal ...
    .accesskey = C
forms-primary-pw-fips-title = Vous êtes actuellement en mode FIPS. Ce mode nécessite un mot de passe principal non vide.
forms-master-pw-fips-desc = Échec de la modification du mot de passe principal
junk-description = Définir les paramètres par défaut des indésirables. Les paramètres pour les indésirables propres à chaque compte peuvent être configurés dans le menu  « Paramètres des comptes… ».
junk-label =
    .label = Quand je marque des messages comme indésirables :
    .accesskey = Q
junk-move-label =
    .label = les déplacer dans le dossier « Indésirables »
    .accesskey = e
junk-delete-label =
    .label = les supprimer
    .accesskey = s
junk-read-label =
    .label = Marquer les messages détectés indésirables comme lus
    .accesskey = M
junk-log-label =
    .label = Activer la journalisation du filtre adaptatif des indésirables
    .accesskey = c
junk-log-button =
    .label = Afficher le journal
    .accesskey = A
reset-junk-button =
    .label = Réinitialiser les données d’apprentissage
    .accesskey = R
phishing-description = { -brand-short-name } peut analyser les messages pour trouver les courriers susceptibles d’être frauduleux en cherchant les techniques habituelles utilisées pour tromper les utilisateurs.
phishing-label =
    .label = Signaler si le message en cours de lecture est susceptible d’être frauduleux
    .accesskey = S
antivirus-description = { -brand-short-name } peut permettre aux logiciels antivirus d’analyser les courriers entrants avant qu’ils ne soient stockés localement.
antivirus-label =
    .label = Permettre aux logiciels antivirus de mettre individuellement en quarantaine les messages entrants
    .accesskey = P
certificate-description = Lorsqu’un serveur demande mon certificat personnel :
certificate-auto =
    .label = en sélectionner un automatiquement
    .accesskey = m
certificate-ask =
    .label = me demander à chaque fois
    .accesskey = d
ocsp-label =
    .label = Interroger le répondeur OCSP pour confirmer la validité de vos certificats
    .accesskey = I
certificate-button =
    .label = Gérer les certificats…
    .accesskey = G
security-devices-button =
    .label = Périphériques de sécurité…
    .accesskey = P

## Chat Tab

startup-label =
    .value = Au démarrage de { -brand-short-name } :
    .accesskey = A
offline-label =
    .label = Laisser mes comptes de messagerie instantanée déconnectés
auto-connect-label =
    .label = Connecter mes comptes automatiquement

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Permettre à mes contacts de savoir que mon compte est inactif après
    .accesskey = P
idle-time-label = minutes d’inactivité

##

away-message-label =
    .label = et indiquer mon absence avec le message suivant :
    .accesskey = e
send-typing-label =
    .label = Envoyer les notifications de saisie dans mes conversations
    .accesskey = v
notification-label = À la réception d’un message qui vous est destiné :
show-notification-label =
    .label = Afficher une notification :
    .accesskey = c
notification-all =
    .label = avec le nom de l’expéditeur et un aperçu du message
notification-name =
    .label = avec le nom de l’expéditeur uniquement
notification-empty =
    .label = sans aucune information
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animer l’icône du dock
           *[other] Faire clignoter l’élément dans la barre des tâches
        }
    .accesskey =
        { PLATFORM() ->
            [macos] A
           *[other] F
        }
chat-play-sound-label =
    .label = Jouer un son
    .accesskey = n
chat-play-button =
    .label = Jouer
    .accesskey = J
chat-system-sound-label =
    .label = Son système par défaut pour la réception d’un nouveau message
    .accesskey = S
chat-custom-sound-label =
    .label = Utiliser le fichier son suivant
    .accesskey = U
chat-browse-sound-button =
    .label = Parcourir…
    .accesskey = r
theme-label =
    .value = Thème :
    .accesskey = T
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Bulles
style-dark =
    .label = Sombre
style-paper =
    .label = Feuilles de papier
style-simple =
    .label = Simple
preview-label = Aperçu :
no-preview-label = Pas d’aperçu disponible
no-preview-description = Ce thème n’est plus valide ou est indisponible (module désactivé, mode sans échec, …).
chat-variant-label =
    .value = Variante :
    .accesskey = V
chat-header-label =
    .label = Afficher l’en-tête
    .accesskey = E
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 19em
    .placeholder =
        { PLATFORM() ->
            [windows] Rechercher dans les options
           *[other] Rechercher dans les préférences
        }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-preferences-input =
    .style = width: 15.4em
    .placeholder = Rechercher

## Preferences UI Search Results

search-results-header = Résultats de la recherche
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Désolé, il n’y a aucun résultat dans les options pour « <span data-l10n-name="query"></span> ».
       *[other] Désolé, il n’y a aucun résultat dans les préférences pour « <span data-l10n-name="query"></span> ».
    }
search-results-help-link = Besoin d’aide ? Consultez <a data-l10n-name="url">l’assistance de { -brand-short-name }</a>
