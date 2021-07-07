# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

permissions-window =
    .title = Exceptions
    .style = width: 50em
permissions-close-key =
    .key = w
permissions-address = Adresse du site web
    .accesskey = d
permissions-block =
    .label = Bloquer
    .accesskey = B
permissions-session =
    .label = Autoriser pour la session
    .accesskey = o
permissions-allow =
    .label = Autoriser
    .accesskey = A
permissions-button-off =
    .label = Désactiver
    .accesskey = D
permissions-button-off-temporarily =
    .label = Désactiver temporairement
    .accesskey = t
permissions-site-name =
    .label = Site web
permissions-status =
    .label = État
permissions-remove =
    .label = Supprimer le site
    .accesskey = S
permissions-remove-all =
    .label = Supprimer tous les sites
    .accesskey = u
permissions-button-cancel =
    .label = Annuler
    .accesskey = n
permissions-button-ok =
    .label = Enregistrer les modifications
    .accesskey = E
permission-dialog =
    .buttonlabelaccept = Enregistrer les modifications
    .buttonaccesskeyaccept = E
permissions-autoplay-menu = Par défaut pour tous les sites web :
permissions-searchbox =
    .placeholder = Rechercher un site web
permissions-capabilities-autoplay-allow =
    .label = Autoriser l’audio et la vidéo
permissions-capabilities-autoplay-block =
    .label = Bloquer l’audio
permissions-capabilities-autoplay-blockall =
    .label = Bloquer l’audio et la vidéo
permissions-capabilities-allow =
    .label = Autoriser
permissions-capabilities-block =
    .label = Bloquer
permissions-capabilities-prompt =
    .label = Toujours demander
permissions-capabilities-listitem-allow =
    .value = Autoriser
permissions-capabilities-listitem-block =
    .value = Bloquer
permissions-capabilities-listitem-allow-session =
    .value = Autoriser pour la session
permissions-capabilities-listitem-off =
    .value = Désactivé
permissions-capabilities-listitem-off-temporarily =
    .value = Désactivé temporairement

## Invalid Hostname Dialog

permissions-invalid-uri-title = Nom d’hôte invalide
permissions-invalid-uri-label = Veuillez saisir un nom d’hôte valide

## Exceptions - Tracking Protection

permissions-exceptions-etp-window =
    .title = Exceptions pour la protection renforcée contre le pistage
    .style = { permissions-window.style }
permissions-exceptions-etp-desc = Vous avez désactivé les protections sur ces sites web.

## Exceptions - Cookies

permissions-exceptions-cookie-window =
    .title = Exceptions - Cookies et données de sites
    .style = { permissions-window.style }
permissions-exceptions-cookie-desc = Vous pouvez indiquer les sites web qui sont toujours ou ne sont jamais autorisés à utiliser des cookies ou des données de sites. Saisissez l’adresse exacte du site et cliquez sur Bloquer, Autoriser pour la session, ou Autoriser.

## Exceptions - HTTPS-Only Mode

permissions-exceptions-https-only-window =
    .title = Exceptions - Mode HTTPS uniquement
    .style = { permissions-window.style }
permissions-exceptions-https-only-desc = Vous pouvez désactiver le mode HTTPS uniquement pour des sites web spécifiques. { -brand-short-name } n’essaiera pas de mettre à niveau vers une connexion HTTPS sécurisée pour ces sites. Les exceptions ne s’appliquent pas aux fenêtres privées.

## Exceptions - Pop-ups

permissions-exceptions-popup-window =
    .title = Sites autorisés - Popups
    .style = { permissions-window.style }
permissions-exceptions-popup-desc = Vous pouvez indiquer les sites web autorisés à ouvrir des fenêtres popup. Saisissez l’adresse exacte du site que vous souhaitez autoriser et cliquez sur Autoriser.

## Exceptions - Saved Logins

permissions-exceptions-saved-logins-window =
    .title = Exceptions - Enregistrement des identifiants
    .style = { permissions-window.style }
permissions-exceptions-saved-logins-desc = Les identifiants pour les sites suivants ne seront pas enregistrés

## Exceptions - Add-ons

permissions-exceptions-addons-window =
    .title = Sites autorisés - Modules complémentaires
    .style = { permissions-window.style }
permissions-exceptions-addons-desc = Vous pouvez indiquer les sites web autorisés à installer des modules complémentaires. Saisissez l’adresse exacte du site que vous souhaitez autoriser et cliquez sur Autoriser.

## Site Permissions - Autoplay

permissions-site-autoplay-window =
    .title = Paramètres - Lecture automatique
    .style = { permissions-window.style }
permissions-site-autoplay-desc = Vous pouvez gérer ici les sites qui ne suivent pas vos paramètres de lecture automatique par défaut.

## Site Permissions - Notifications

permissions-site-notification-window =
    .title = Paramètres - Permissions pour les notifications
    .style = { permissions-window.style }
permissions-site-notification-desc = Les sites web suivants ont demandé à vous envoyer des notifications. Vous pouvez spécifier quels sites web sont autorisés à vous envoyer des notifications. Vous pouvez également bloquer les nouvelles demandes d’activation des notifications.
permissions-site-notification-disable-label =
    .label = Bloquer les nouvelles demandes d’activation des notifications
permissions-site-notification-disable-desc = Cela empêchera tous les sites web non listés ci-dessus de demander l’autorisation d’envoyer des notifications. Le blocage des notifications peut invalider les fonctionnalités de certains sites web.

## Site Permissions - Location

permissions-site-location-window =
    .title = Paramètres - Permissions pour la localisation
    .style = { permissions-window.style }
permissions-site-location-desc = Les sites web suivants ont demandé l’accès à votre localisation. Vous pouvez spécifier quels sites web sont autorisés à accéder à votre localisation. Vous pouvez également bloquer les nouvelles demandes d’accès à votre localisation.
permissions-site-location-disable-label =
    .label = Bloquer les nouvelles demandes d’accès à votre localisation
permissions-site-location-disable-desc = Cela empêchera tous les sites web non listés ci-dessus de demander l’autorisation d’accéder à votre localisation. Bloquer l’accès à votre localisation peut invalider les fonctionnalités de certains sites web.

## Site Permissions - Virtual Reality

permissions-site-xr-window =
    .title = Paramètres - Autorisations de réalité virtuelle
    .style = { permissions-window.style }
permissions-site-xr-desc = Les sites web suivants ont demandé l’accès à vos appareils de réalité virtuelle. Vous pouvez spécifier quels sites web sont autorisés à accéder à vos appareils de réalité virtuelle. Vous pouvez également bloquer les nouvelles demandes d’accès à vos appareils de réalité virtuelle.
permissions-site-xr-disable-label =
    .label = Bloquer les nouvelles demandes d’accès à vos appareils de réalité virtuelle
permissions-site-xr-disable-desc = Cela empêchera tous les sites web non listés ci-dessus de demander l’autorisation d’accéder à vos appareils de réalité virtuelle. Bloquer l’accès à vos appareils de réalité virtuelle peut restreindre les fonctionnalités de certains sites web.

## Site Permissions - Camera

permissions-site-camera-window =
    .title = Paramètres - Permissions pour la caméra
    .style = { permissions-window.style }
permissions-site-camera-desc = Les sites web suivants ont demandé l’accès à votre caméra. Vous pouvez spécifier quels sites web sont autorisés à accéder à votre caméra. Vous pouvez également bloquer les nouvelles demandes d’accès à votre caméra.
permissions-site-camera-disable-label =
    .label = Bloquer les nouvelles demandes d’accès à votre caméra
permissions-site-camera-disable-desc = Cela empêchera tous les sites web non listés ci-dessus de demander l’autorisation d’accéder à votre caméra. Bloquer l’accès à votre caméra peut invalider les fonctionnalités de certains sites web.

## Site Permissions - Microphone

permissions-site-microphone-window =
    .title = Paramètres - Permissions pour le microphone
    .style = { permissions-window.style }
permissions-site-microphone-desc = Les sites web suivants ont demandé l’accès à votre microphone. Vous pouvez spécifier quels sites web sont autorisés à accéder à votre microphone. Vous pouvez également bloquer les nouvelles demandes d’accès à votre microphone.
permissions-site-microphone-disable-label =
    .label = Bloquer les nouvelles demandes d’accès à votre microphone
permissions-site-microphone-disable-desc = Cela empêchera tous les sites web non listés ci-dessus de demander l’autorisation d’accéder à votre microphone. Bloquer l’accès à votre microphone peut invalider les fonctionnalités de certains sites web.
