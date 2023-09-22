# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

permissions-window2 =
    .title = Exceptions
    .style = min-width: 50em
permissions-close-key =
    .key = w
permissions-address = Adresse du site web
    .accesskey = d
permissions-block =
    .label = Bloquer
    .accesskey = B
permissions-disable-etp =
    .label = Ajouter une exception
    .accesskey = A
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

permissions-exceptions-etp-window2 =
    .title = Exceptions pour la protection renforcée contre le pistage
    .style = { permissions-window2.style }
permissions-exceptions-manage-etp-desc = Vous pouvez indiquer les sites web pour lesquels la Protection renforcée contre le pistage sera désactivée. Saisissez l’adresse exacte du site que vous souhaitez gérer et cliquez sur Ajouter une exception.

## Exceptions - Cookies

permissions-exceptions-cookie-window2 =
    .title = Exceptions - Cookies et données de sites
    .style = { permissions-window2.style }
permissions-exceptions-cookie-desc = Vous pouvez indiquer les sites web qui sont toujours ou ne sont jamais autorisés à utiliser des cookies ou des données de sites. Saisissez l’adresse exacte du site et cliquez sur Bloquer, Autoriser pour la session, ou Autoriser.

## Exceptions - HTTPS-Only Mode

permissions-exceptions-https-only-window2 =
    .title = Exceptions - Mode HTTPS uniquement
    .style = { permissions-window2.style }
permissions-exceptions-https-only-desc = Vous pouvez désactiver le mode HTTPS uniquement pour des sites web spécifiques. { -brand-short-name } n’essaiera pas de mettre à niveau vers une connexion HTTPS sécurisée pour ces sites. Les exceptions ne s’appliquent pas aux fenêtres privées.
permissions-exceptions-https-only-desc2 = Vous pouvez désactiver le mode HTTPS uniquement pour des sites web spécifiques. { -brand-short-name } n’essaiera pas de mettre à niveau vers une connexion HTTPS sécurisée pour ces sites.

## Exceptions - Pop-ups

permissions-exceptions-popup-window2 =
    .title = Sites autorisés - Popups
    .style = { permissions-window2.style }
permissions-exceptions-popup-desc = Vous pouvez indiquer les sites web autorisés à ouvrir des fenêtres popup. Saisissez l’adresse exacte du site que vous souhaitez autoriser et cliquez sur Autoriser.

## Exceptions - Saved Logins

permissions-exceptions-saved-logins-window2 =
    .title = Exceptions - Enregistrement des identifiants
    .style = { permissions-window2.style }
permissions-exceptions-saved-logins-desc = Les identifiants pour les sites suivants ne seront pas enregistrés

## Exceptions - Add-ons

permissions-exceptions-addons-window2 =
    .title = Sites autorisés - Modules complémentaires
    .style = { permissions-window2.style }
permissions-exceptions-addons-desc = Vous pouvez indiquer les sites web autorisés à installer des modules complémentaires. Saisissez l’adresse exacte du site que vous souhaitez autoriser et cliquez sur Autoriser.

## Site Permissions - Autoplay

permissions-site-autoplay-window2 =
    .title = Paramètres - Lecture automatique
    .style = { permissions-window2.style }
permissions-site-autoplay-desc = Vous pouvez gérer ici les sites qui ne suivent pas vos paramètres de lecture automatique par défaut.

## Site Permissions - Notifications

permissions-site-notification-window2 =
    .title = Paramètres - Permissions pour les notifications
    .style = { permissions-window2.style }
permissions-site-notification-desc = Les sites web suivants ont demandé à vous envoyer des notifications. Vous pouvez spécifier quels sites web sont autorisés à vous envoyer des notifications. Vous pouvez également bloquer les nouvelles demandes d’activation des notifications.
permissions-site-notification-disable-label =
    .label = Bloquer les nouvelles demandes d’activation des notifications
permissions-site-notification-disable-desc = Cela empêchera tous les sites web non listés ci-dessus de demander l’autorisation d’envoyer des notifications. Le blocage des notifications peut invalider les fonctionnalités de certains sites web.

## Site Permissions - Location

permissions-site-location-window2 =
    .title = Paramètres - Permissions pour la localisation
    .style = { permissions-window2.style }
permissions-site-location-desc = Les sites web suivants ont demandé l’accès à votre localisation. Vous pouvez spécifier quels sites web sont autorisés à accéder à votre localisation. Vous pouvez également bloquer les nouvelles demandes d’accès à votre localisation.
permissions-site-location-disable-label =
    .label = Bloquer les nouvelles demandes d’accès à votre localisation
permissions-site-location-disable-desc = Cela empêchera tous les sites web non listés ci-dessus de demander l’autorisation d’accéder à votre localisation. Bloquer l’accès à votre localisation peut invalider les fonctionnalités de certains sites web.

## Site Permissions - Virtual Reality

permissions-site-xr-window2 =
    .title = Paramètres - Autorisations de réalité virtuelle
    .style = { permissions-window2.style }
permissions-site-xr-desc = Les sites web suivants ont demandé l’accès à vos appareils de réalité virtuelle. Vous pouvez spécifier quels sites web sont autorisés à accéder à vos appareils de réalité virtuelle. Vous pouvez également bloquer les nouvelles demandes d’accès à vos appareils de réalité virtuelle.
permissions-site-xr-disable-label =
    .label = Bloquer les nouvelles demandes d’accès à vos appareils de réalité virtuelle
permissions-site-xr-disable-desc = Cela empêchera tous les sites web non listés ci-dessus de demander l’autorisation d’accéder à vos appareils de réalité virtuelle. Bloquer l’accès à vos appareils de réalité virtuelle peut restreindre les fonctionnalités de certains sites web.

## Site Permissions - Camera

permissions-site-camera-window2 =
    .title = Paramètres - Permissions pour la caméra
    .style = { permissions-window2.style }
permissions-site-camera-desc = Les sites web suivants ont demandé l’accès à votre caméra. Vous pouvez spécifier quels sites web sont autorisés à accéder à votre caméra. Vous pouvez également bloquer les nouvelles demandes d’accès à votre caméra.
permissions-site-camera-disable-label =
    .label = Bloquer les nouvelles demandes d’accès à votre caméra
permissions-site-camera-disable-desc = Cela empêchera tous les sites web non listés ci-dessus de demander l’autorisation d’accéder à votre caméra. Bloquer l’accès à votre caméra peut invalider les fonctionnalités de certains sites web.

## Site Permissions - Microphone

permissions-site-microphone-window2 =
    .title = Paramètres - Permissions pour le microphone
    .style = { permissions-window2.style }
permissions-site-microphone-desc = Les sites web suivants ont demandé l’accès à votre microphone. Vous pouvez spécifier quels sites web sont autorisés à accéder à votre microphone. Vous pouvez également bloquer les nouvelles demandes d’accès à votre microphone.
permissions-site-microphone-disable-label =
    .label = Bloquer les nouvelles demandes d’accès à votre microphone
permissions-site-microphone-disable-desc = Cela empêchera tous les sites web non listés ci-dessus de demander l’autorisation d’accéder à votre microphone. Bloquer l’accès à votre microphone peut invalider les fonctionnalités de certains sites web.

## Site Permissions - Speaker
##
## "Speaker" refers to an audio output device.

permissions-site-speaker-window =
    .title = Paramètres - Permissions pour les haut-parleurs
    .style = { permissions-window2.style }
permissions-site-speaker-desc = Les sites web suivants ont demandé à sélectionner un périphérique de sortie audio. Vous pouvez décider quels sites web sont autorisés à sélectionner un périphérique de sortie audio.
permissions-exceptions-doh-window =
    .title = Exceptions au DNS via HTTPS
    .style = { permissions-window2.style }
permissions-exceptions-manage-doh-desc = { -brand-short-name } n’utilisera pas le DNS sécurisé sur ces sites et leurs sous-domaines.
permissions-doh-entry-field = Saisissez le nom de domaine du site web
    .accesskey = d
permissions-doh-add-exception =
    .label = Ajouter
    .accesskey = A
permissions-doh-col =
    .label = Domaine
permissions-doh-remove =
    .label = Supprimer
    .accesskey = S
permissions-doh-remove-all =
    .label = Tout supprimer
    .accesskey = T
