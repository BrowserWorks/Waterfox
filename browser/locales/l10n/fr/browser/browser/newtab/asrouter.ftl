# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extension recommandée
cfr-doorhanger-feature-heading = Fonctionnalité recommandée
cfr-doorhanger-pintab-heading = Essayez ceci : épingler un onglet

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Pourquoi ceci s’affiche-t-il ?
cfr-doorhanger-extension-cancel-button = Pas maintenant
    .accesskey = P
cfr-doorhanger-extension-ok-button = Ajouter maintenant
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Épingler cet onglet
    .accesskey = i
cfr-doorhanger-extension-manage-settings-button = Gérer les paramètres de recommandation
    .accesskey = G
cfr-doorhanger-extension-never-show-recommendation = Ne pas montrer cette recommandation
    .accesskey = N
cfr-doorhanger-extension-learn-more-link = En savoir plus
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = par { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Recommandation
cfr-doorhanger-extension-notification2 = Recommandation
    .tooltiptext = Recommandation d’extension
    .a11y-announcement = Recommandation d’extension disponible
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Recommandation
    .tooltiptext = Recommandation de fonctionnalité
    .a11y-announcement = Recommandation de fonctionnalité disponible

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } étoile
           *[other] { $total } étoiles
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } utilisateur
       *[other] { $total } utilisateurs
    }
cfr-doorhanger-pintab-description = Obtenez un accès facile à vos sites les plus utilisés. Gardez les sites ouverts dans un onglet (même lorsque vous redémarrez).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Effectuez un clic droit</b> sur l’onglet que vous souhaitez épingler.
cfr-doorhanger-pintab-step2 = Sélectionnez <b>Épingler cet onglet</b> dans le menu.
cfr-doorhanger-pintab-step3 = Si le site est mis à jour vous verrez un point bleu apparaître sur votre onglet épinglé.
cfr-doorhanger-pintab-animation-pause = Pause
cfr-doorhanger-pintab-animation-resume = Reprendre

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synchronisez vos marque-pages partout.
cfr-doorhanger-bookmark-fxa-body = Vous avez déniché la perle rare ! Maintenant, retrouvez ce marque-page sur vos appareils mobiles. C’est le moment d’utiliser un { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Synchroniser les marque-pages maintenant…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Bouton de fermeture
    .title = Fermer

## Protections panel

cfr-protections-panel-header = Naviguez sans être suivi·e
cfr-protections-panel-body = Gardez vos données pour vous. { -brand-short-name } vous protège de la plupart des traqueurs les plus courants qui suivent ce que vous faites en ligne.
cfr-protections-panel-link-text = En savoir plus

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nouvelle fonctionnalité :
cfr-whatsnew-button =
    .label = Nouveautés
    .tooltiptext = Nouveautés
cfr-whatsnew-panel-header = Nouveautés
cfr-whatsnew-release-notes-link-text = Lire les notes de version
cfr-whatsnew-fx70-title = { -brand-short-name } lutte maintenant plus dur pour votre vie privée
cfr-whatsnew-fx70-body =
    La dernière mise à jour améliore la fonctionnalité de protection contre le pistage et rend
    plus facile que jamais de créer des mots de passe sécurisés pour chaque site.
cfr-whatsnew-tracking-protect-title = Protégez-vous des traqueurs
cfr-whatsnew-tracking-protect-body = { -brand-short-name } bloque de nombreux traqueurs sociaux et intersites courants qui suivent vos faits et gestes en ligne.
cfr-whatsnew-tracking-protect-link-text = Consulter votre rapport
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Traqueur bloqué
       *[other] Traqueurs bloqués
    }
cfr-whatsnew-tracking-blocked-subtitle = Depuis { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Voir le rapport
cfr-whatsnew-lockwise-backup-title = Sauvegardez vos mots de passe
cfr-whatsnew-lockwise-backup-body = Générez maintenant des mots de passe sécurisés auxquels vous pouvez accéder partout où vous vous connectez.
cfr-whatsnew-lockwise-backup-link-text = Activer les sauvegardes
cfr-whatsnew-lockwise-take-title = Emportez vos mots de passe avec vous
cfr-whatsnew-lockwise-take-body = L’application mobile { -lockwise-brand-short-name } vous permet d’accéder en toute sécurité à vos mots de passe sauvegardés depuis n’importe où.
cfr-whatsnew-lockwise-take-link-text = Obtenir l’application

## Search Bar

cfr-whatsnew-searchbar-title = Tapez moins, trouvez plus avec la barre d’adresse
cfr-whatsnew-searchbar-body-topsites = Désormais, sélectionnez simplement la barre d’adresse et un cadre s’agrandira pour vous présenter des liens vers vos sites les plus visités.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Icône de loupe

## Picture-in-Picture

cfr-whatsnew-pip-header = Regardez des vidéos pendant que vous naviguez
cfr-whatsnew-pip-body = Le mode incrustation insère une vidéo dans une fenêtre flottante afin que vous puissiez la regarder tout en travaillant dans d’autres onglets.
cfr-whatsnew-pip-cta = En savoir plus

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Moins de popups de sites pénibles
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } empêche désormais les sites de vous demander automatiquement de vous envoyer des messages dans des popups.
cfr-whatsnew-permission-prompt-cta = En savoir plus

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Détecteur d’empreinte numérique bloqué
       *[other] Détecteurs d’empreinte numérique bloqués
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } bloque de nombreux détecteurs d’empreinte numérique qui collectent en secret des informations sur votre appareil et vos actions afin de créer un profil publicitaire sur vous.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Détecteurs d’empreinte numérique
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } peut bloquer les détecteurs d’empreinte numérique qui collectent en secret des informations sur votre appareil et vos actions afin de créer un profil publicitaire sur vous.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Accédez à ce marque-page sur votre téléphone
cfr-doorhanger-sync-bookmarks-body = Emportez vos marque-pages, vos mots de passe, votre historique et bien d’autres choses sur tous les appareils connectés à votre compte { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Activer { -sync-brand-short-name }
    .accesskey = A

## Login Sync

cfr-doorhanger-sync-logins-header = Ne perdez plus jamais vos mots de passe
cfr-doorhanger-sync-logins-body = Enregistrez et synchronisez vos mots de passe sur tous vos appareils en toute sécurité.
cfr-doorhanger-sync-logins-ok-button = Activer { -sync-brand-short-name }
    .accesskey = A

## Send Tab

cfr-doorhanger-send-tab-header = Lisez ceci en déplacement
cfr-doorhanger-send-tab-recipe-header = Lisez cette recette dans la cuisine
cfr-doorhanger-send-tab-body = « Envoyer l’onglet » vous permet de transférer facilement ce lien à votre téléphone ou à tout autre appareil connecté à votre compte { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Essayer l’envoi d’onglet
    .accesskey = E

## Firefox Send

cfr-doorhanger-firefox-send-header = Partagez ce PDF en toute sécurité
cfr-doorhanger-firefox-send-body = Protégez vos documents sensibles des regards indiscrets avec un chiffrement de bout en bout et un lien qui disparaît lorsque vous avez terminé.
cfr-doorhanger-firefox-send-ok-button = Essayer { -send-brand-name }
    .accesskey = E

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Voir les protections
    .accesskey = V
cfr-doorhanger-socialtracking-close-button = Fermer
    .accesskey = F
cfr-doorhanger-socialtracking-dont-show-again = Ne plus me montrer de messages comme celui-ci
    .accesskey = N
cfr-doorhanger-socialtracking-heading = { -brand-short-name } a empêché un réseau social de vous pister ici
cfr-doorhanger-socialtracking-description = Le respect de votre vie privée est important. { -brand-short-name } bloque désormais les traqueurs de réseaux sociaux courants, limitant ainsi la quantité de données qu’ils peuvent recueillir sur votre activité en ligne.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } a bloqué un traqueur d’empreinte numérique sur cette page
cfr-doorhanger-fingerprinters-description = Le respect de votre vie privée est important. { -brand-short-name } bloque désormais les détecteurs d’empreintes numériques, qui collectent des informations uniques et identifiables sur votre appareil afin de vous pister.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } a bloqué un mineur de cryptomonnaie sur cette page
cfr-doorhanger-cryptominers-description = Le respect de votre vie privée est important. { -brand-short-name } bloque désormais les mineurs de cryptomonnaies, qui utilisent la puissance de calcul de votre système pour extraire de la monnaie numérique.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading = { -brand-short-name } a bloqué plus de <b>{ $blockedCount }</b> traqueurs depuis { $date }.
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } a bloqué plus de <b>{ $blockedCount }</b> traqueurs depuis { DATETIME($date, month: "long", year: "numeric") } !
    }
cfr-doorhanger-milestone-ok-button = Tout afficher
    .accesskey = T

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Créez facilement des mots de passe sûrs
cfr-whatsnew-lockwise-body = Il n’est pas toujours facile de penser à des mots de passe uniques et sûrs pour chaque compte. Lors de la création d’un mot de passe, sélectionnez le champ de mot de passe pour utiliser un mot de passe sécurisé, généré à partir de { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Icône de { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Recevez des alertes sur les mots de passe vulnérables
cfr-whatsnew-passwords-body = Les pirates savent que les gens réutilisent les mêmes mots de passe. Si vous avez utilisé le même mot de passe sur plusieurs sites et que l’un de ces sites a été victime d’une fuite de données, vous verrez une alerte dans { -lockwise-brand-short-name } vous invitant à modifier votre mot de passe sur ces sites.
cfr-whatsnew-passwords-icon-alt = Icône de clé de mot de passe vulnérable

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Passez du petit au grand écran
cfr-whatsnew-pip-fullscreen-body = Lorsque vous avez placé une vidéo dans une fenêtre flottante, vous pouvez maintenant double-cliquer sur celle-ci pour passer en plein écran.
cfr-whatsnew-pip-fullscreen-icon-alt = Icône d’incrustation vidéo

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Fermer
    .accesskey = F

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Protections en un coup d’œil
cfr-whatsnew-protections-body = Le tableau de bord des protections comprend des rapports récapitulatifs sur les fuites de données et la gestion des mots de passe. Vous pouvez désormais suivre le nombre de fuites que vous avez résolues et voir si l’un de vos mots de passe enregistrés peut avoir été exposé dans une fuite de données.
cfr-whatsnew-protections-cta-link = Afficher le tableau de bord des protections
cfr-whatsnew-protections-icon-alt = Icône de bouclier

## Better PDF message

cfr-whatsnew-better-pdf-header = Meilleure expérience PDF
cfr-whatsnew-better-pdf-body = Les documents PDF s’ouvrent maintenant directement dans { -brand-short-name }, gardant vos outils de travail à portée de main.

## DOH Message

cfr-doorhanger-doh-body = Le respect de votre vie privée est important. Désormais, et lorsque cela est possible, { -brand-short-name } envoie vos requêtes DNS de manière sécurisée vers un service fourni par un partenaire pour vous protéger pendant votre navigation.
cfr-doorhanger-doh-header = Des requêtes DNS chiffrées et plus sûres
cfr-doorhanger-doh-primary-button-2 = OK
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Désactiver
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Votre vie privée est importante. Désormais, { -brand-short-name } isole les sites web les uns des autres, ou les ouvre dans des bacs à sable, compliquant ainsi la tâche des pirates pour dérober mots de passe, numéros de carte bancaire et autres données sensibles.
cfr-doorhanger-fission-header = Isolement des sites
cfr-doorhanger-fission-primary-button = J’ai compris
    .accesskey = c
cfr-doorhanger-fission-secondary-button = En savoir plus
    .accesskey = s

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Protection automatique contre les techniques de pistage discrètes
cfr-whatsnew-clear-cookies-body = Certains traqueurs vous redirigent vers d’autres sites qui créent des cookies cachés. { -brand-short-name } est désormais capable d’effacer ces cookies afin que vous ne puissiez pas être pisté·e.
cfr-whatsnew-clear-cookies-image-alt = Illustration d’un cookie bloqué

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Plus de contrôles multimédias
cfr-whatsnew-media-keys-body = Lisez et mettez en pause l’audio ou la vidéo directement depuis votre clavier ou votre casque, ce qui facilite le contrôle des médias à partir d’un autre onglet ou programme, ou même lorsque votre ordinateur est verrouillé. Vous pouvez également vous déplacer entre les pistes à l’aide des touches avant et arrière.
cfr-whatsnew-media-keys-button = Découvrez comment

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Raccourcis de recherche dans la barre d’adresse
cfr-whatsnew-search-shortcuts-body = Désormais, lorsque vous saisissez l’adresse d’un moteur de recherche ou d’un site spécifique dans la barre d’adresse, un raccourci bleu apparaît parmi les suggestions de recherche au-dessous. Sélectionnez ce raccourci pour terminer votre recherche directement depuis la barre d’adresse.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Protection contre les supercookies malveillants
cfr-whatsnew-supercookies-body = Des sites web peuvent attacher secrètement à votre navigateur un « supercookie » qui peut vous suivre sur le Web, même après l’effacement des cookies. { -brand-short-name } fournit désormais une protection robuste contre les supercookies pour qu’ils ne soient pas utilisés pour pister vos activités en ligne d’un site à un autre.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = De meilleurs marque-pages
cfr-whatsnew-bookmarking-body = Il est plus facile de garder trace de vos sites préférés. { -brand-short-name } se souvient désormais de votre emplacement préféré pour les marque-pages enregistrés, affiche la barre personnelle sur les nouveaux onglets par défaut et vous offre un accès facile à vos autres marque-pages grâce à un dossier dans la barre personnelle.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Protection complète contre le pistage des cookies intersites
cfr-whatsnew-cross-site-tracking-body = Vous pouvez désormais opter pour une meilleure protection contre le pistage des cookies. { -brand-short-name } peut isoler vos activités et données du site sur lequel vous vous trouvez afin que les informations stockées dans le navigateur ne soient pas partagées entre les sites web.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Les vidéos de ce site peuvent ne pas être lues correctement sur cette version de { -brand-short-name }. Pour une prise en charge vidéo complète, vous devez mettre à jour { -brand-short-name }.
cfr-doorhanger-video-support-header = Mettez à jour { -brand-short-name } pour lire la vidéo
cfr-doorhanger-video-support-primary-button = Mettre à jour
    .accesskey = M
