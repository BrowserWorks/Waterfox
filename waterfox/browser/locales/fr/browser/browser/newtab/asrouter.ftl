# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extension recommandée
cfr-doorhanger-feature-heading = Fonctionnalité recommandée

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Pourquoi ceci s’affiche-t-il ?
cfr-doorhanger-extension-cancel-button = Pas maintenant
    .accesskey = P
cfr-doorhanger-extension-ok-button = Ajouter maintenant
    .accesskey = A
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

## Waterfox Accounts Message

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
cfr-whatsnew-release-notes-link-text = Lire les notes de version

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } a bloqué plus de <b>{ $blockedCount }</b> traqueurs depuis { DATETIME($date, month: "long", year: "numeric") } !
    }
cfr-doorhanger-milestone-ok-button = Tout afficher
    .accesskey = T
cfr-doorhanger-milestone-close-button = Fermer
    .accesskey = F

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

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Les vidéos de ce site peuvent ne pas être lues correctement sur cette version de { -brand-short-name }. Pour une prise en charge vidéo complète, vous devez mettre à jour { -brand-short-name }.
cfr-doorhanger-video-support-header = Mettez à jour { -brand-short-name } pour lire la vidéo
cfr-doorhanger-video-support-primary-button = Mettre à jour
    .accesskey = M

## Spotlight modal shared strings

spotlight-learn-more-collapsed = En savoir plus
    .title = Développer pour en savoir plus sur la fonctionnalité
spotlight-learn-more-expanded = En savoir plus
    .title = Fermer

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Vous semblez utiliser un Wi-Fi public
spotlight-public-wifi-vpn-body = Afin de masquer votre emplacement et votre activité de navigation, envisagez l’usage d’un réseau privé virtuel (VPN). Il vous aidera à vous protéger lorsque vous naviguerez dans des lieux publics comme les aéroports et les cafés.
spotlight-public-wifi-vpn-primary-button = Gardez votre vie privée avec { -mozilla-vpn-brand-name }
    .accesskey = G
spotlight-public-wifi-vpn-link = Plus tard
    .accesskey = t

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header = Testez en avant-première l’expérience de confidentialité la plus puissante que nous avons jamais conçue
spotlight-total-cookie-protection-body = La protection totale contre les cookies empêche les traqueurs d’utiliser des cookies pour vous pister sur le Web.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = { -brand-short-name } crée une barrière autour des cookies, les limitant au site sur lequel vous vous trouvez afin que les traqueurs ne puissent pas les utiliser pour vous pister. Avec un accès anticipé, vous contribuerez à optimiser cette fonctionnalité afin que nous puissions continuer à bâtir un meilleur Web pour tout le monde.
spotlight-total-cookie-protection-primary-button = Activer la protection totale contre les cookies
spotlight-total-cookie-protection-secondary-button = Plus tard
cfr-total-cookie-protection-header = Grâce à vous, { -brand-short-name } est plus privé et sûr que jamais
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch". Only those who received it and accepted are shown this message.
cfr-total-cookie-protection-body = La protection totale contre les cookies est le niveau de protection le plus élevé que nous offrons à votre vie privée à ce jour – de plus, il s’agit désormais du réglage par défaut partout pour toutes les personnes qui utilisent { -brand-short-name }. Nous n’aurions pu le faire sans l’aide de celles et ceux qui ont accepté comme vous d’y participer de façon anticipée. C’est pourquoi nous vous remercions de nous aider à créer un Internet meilleur et plus respectueux de la vie privée !

## Emotive Continuous Onboarding

spotlight-better-internet-header = Un Internet meilleur grâce à vous
spotlight-better-internet-body = Lorsque vous utilisez { -brand-short-name }, vous soutenez un Internet ouvert, accessible et meilleur pour tout le monde.
spotlight-peace-mind-header = Nous assurons votre protection
spotlight-peace-mind-body = Chaque mois, { -brand-short-name } bloque en moyenne au moins 3 000 traqueurs par utilisateur. Car rien, et en particulier des atteintes à la vie privée tels les traqueurs, ne devrait se tenir entre vous et ce qu’Internet offre de meilleur.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Garder dans le Dock
       *[other] Épingler à la barre des tâches
    }
spotlight-pin-secondary-button = Plus tard
