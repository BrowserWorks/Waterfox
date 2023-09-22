# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } a empêché ce site d’installer un logiciel sur votre ordinateur.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = Autoriser { $host } à installer un module complémentaire ?
xpinstall-prompt-message = Vous essayez d’installer un module complémentaire depuis { $host }. Assurez-vous qu’il s’agit d’un site digne de confiance avant de continuer.

##

xpinstall-prompt-header-unknown = Autoriser un site inconnu à installer un module complémentaire ?
xpinstall-prompt-message-unknown = Vous essayez d’installer un module complémentaire depuis un site inconnu. Assurez-vous qu’il s’agit d’un site digne de confiance avant de continuer.

xpinstall-prompt-dont-allow =
    .label = Ne pas autoriser
    .accesskey = N
xpinstall-prompt-never-allow =
    .label = Ne jamais autoriser
    .accesskey = N
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Signaler un site suspect
    .accesskey = S
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Continuer l’installation
    .accesskey = I

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Ce site demande l’accès à vos périphériques MIDI (Musical Instrument Digital Interface). L’accès aux périphériques peut être accordé par l’installation d’un module complémentaire.
site-permission-install-first-prompt-midi-message = La sécurité de cet accès n’est pas garantie. Ne continuez que si vous faites confiance à ce site.

##

xpinstall-disabled-locked = L’installation de logiciels a été désactivée par votre administrateur système.
xpinstall-disabled = L’installation de logiciels est actuellement désactivée. Cliquez sur « Activer » et essayez à nouveau.
xpinstall-disabled-button =
    .label = Activer
    .accesskey = v

# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) est bloqué par votre administrateur système.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = Votre administrateur système a empêché ce site d’installer un logiciel sur votre ordinateur.
addon-install-full-screen-blocked = L’installation de modules complémentaires n’est pas autorisée pendant ou avant le passage en mode plein écran.

# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } a été ajouté à { -brand-short-name }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } demande de nouvelles permissions

# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = Finaliser l’installation des extensions importées dans { -brand-short-name }

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = Supprimer { $name } ?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = Supprimer { $name } de { -brand-shorter-name } ?
addon-removal-button = Supprimer
addon-removal-abuse-report-checkbox = Signaler cette extension à { -vendor-short-name }

# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying =
    { $addonCount ->
        [one] Téléchargement et vérification du module…
       *[other] Téléchargement et vérification de { $addonCount } modules…
    }
addon-download-verifying = Vérification en cours

addon-install-cancel-button =
    .label = Annuler
    .accesskey = n
addon-install-accept-button =
    .label = Ajouter
    .accesskey = A

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one] Ce site souhaite installer un module sur { -brand-short-name } :
       *[other] Ce site souhaite installer { $addonCount } modules sur { -brand-short-name } :
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one] Attention, ce site souhaite installer un module non vérifié sur { -brand-short-name }. Poursuivez à vos risques et périls.
       *[other] Attention, ce site souhaite installer { $addonCount } modules non vérifiés sur { -brand-short-name }. Poursuivez à vos risques et périls.
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = Attention, ce site souhaite installer { $addonCount } modules sur { -brand-short-name }, dont certains ne sont pas vérifiés. Poursuivez à vos risques et périls.

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = Le module complémentaire n’a pas pu être téléchargé à cause d’un échec de connexion.
addon-install-error-incorrect-hash = Le module complémentaire n’a pas pu être installé car il ne correspond pas au module attendu par { -brand-short-name }.
addon-install-error-corrupt-file = Le module complémentaire téléchargé depuis ce site n’a pas pu être installé car il semble corrompu.
addon-install-error-file-access = { $addonName } n’a pas pu être installé car un fichier n’a pas pu être modifié par { -brand-short-name }.
addon-install-error-not-signed = { -brand-short-name } a empêché ce site d’installer un module complémentaire non vérifié.
addon-install-error-invalid-domain = Le module complémentaire { $addonName } ne peut pas être installé depuis cet emplacement.
addon-local-install-error-network-failure = Ce module complémentaire n’a pas pu être installé à cause d’une erreur du système de fichiers.
addon-local-install-error-incorrect-hash = Ce module complémentaire n’a pas pu être installé car il ne correspond pas au module attendu par { -brand-short-name }.
addon-local-install-error-corrupt-file = Ce module complémentaire n’a pas pu être installé car il semble être corrompu.
addon-local-install-error-file-access = { $addonName } n’a pas pu être installé car un fichier n’a pas pu être modifié par { -brand-short-name }.
addon-local-install-error-not-signed = Ce module complémentaire n’a pas pu être installé car il n’a pas été vérifié.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = { $addonName } n’a pas pu être installé car il n’est pas compatible avec { -brand-short-name } { $appVersion }.
addon-install-error-blocklisted = { $addonName } n’a pas pu être installé car il présente un risque élevé de causer des problèmes de stabilité ou de sécurité.
