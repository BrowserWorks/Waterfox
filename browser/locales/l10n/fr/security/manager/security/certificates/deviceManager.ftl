# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Gestionnaire de périphériques
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Modules et périphériques de sécurité

devmgr-header-details =
    .label = Détails

devmgr-header-value =
    .label = Valeur

devmgr-button-login =
    .label = Connexion
    .accesskey = n

devmgr-button-logout =
    .label = Déconnexion
    .accesskey = D

devmgr-button-changepw =
    .label = Changer le mot de passe
    .accesskey = m

devmgr-button-load =
    .label = Charger
    .accesskey = g

devmgr-button-unload =
    .label = Décharger
    .accesskey = h

devmgr-button-enable-fips =
    .label = Activer FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Désactiver FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Charger le pilote du périphérique PKCS#11

load-device-info = Saisissez les informations sur le module que vous voulez ajouter.

load-device-modname =
    .value = Nom du module
    .accesskey = o

load-device-modname-default =
    .value = Nouveau module PKCS#11

load-device-filename =
    .value = Nom de fichier du module
    .accesskey = i

load-device-browse =
    .label = Parcourir…
    .accesskey = P

## Token Manager

devinfo-status =
    .label = Statut

devinfo-status-disabled =
    .label = Désactivé

devinfo-status-not-present =
    .label = Absent

devinfo-status-uninitialized =
    .label = Non initialisé

devinfo-status-not-logged-in =
    .label = Non connecté

devinfo-status-logged-in =
    .label = Connecté

devinfo-status-ready =
    .label = Prêt

devinfo-desc =
    .label = Description

devinfo-man-id =
    .label = Fabricant

devinfo-hwversion =
    .label = Version HW
devinfo-fwversion =
    .label = Version FW

devinfo-modname =
    .label = Module

devinfo-modpath =
    .label = Chemin

login-failed = Échec de connexion

devinfo-label =
    .label = Étiquette

devinfo-serialnum =
    .label = Numéro de série

fips-nonempty-password-required = Le mode FIPS exige que vous ayez défini un mot de passe principal pour chaque périphérique de sécurité. Veuillez définir le mot de passe principal avant d’activer le mode FIPS.

fips-nonempty-primary-password-required = Le mode FIPS exige que vous ayez défini un mot de passe principal pour chaque périphérique de sécurité. Veuillez définir le mot de passe principal avant d’activer le mode FIPS.
unable-to-toggle-fips = Impossible de modifier le mode FIPS pour le périphérique de sécurité. Nous vous recommandons de quitter et de redémarrer cette application.
load-pk11-module-file-picker-title = Sélectionner un pilote de périphérique PKCS#11 à charger

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Le nom du module ne peut pas être vide.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = « Root Certs » est réservé et ne peut pas être utilisé comme nom de module.

add-module-failure = Impossible d’ajouter le module
del-module-warning = Voulez-vous vraiment supprimer ce module de sécurité ?
del-module-error = Impossible de supprimer le module
