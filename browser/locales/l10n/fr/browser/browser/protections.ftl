# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } a bloqué { $count } traqueur au cours de la semaine passée
       *[other] { -brand-short-name } a bloqué { $count } traqueurs au cours de la semaine passée
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> traqueur bloqué depuis le { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> traqueurs bloqués depuis le { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } continue de bloquer les traqueurs dans les fenêtres de navigation privée, mais ne conserve aucune trace de ce qui a été bloqué.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Traqueurs bloqués par { -brand-short-name } cette semaine

protection-report-webpage-title = Tableau de bord des protections
protection-report-page-content-title = Tableau de bord des protections
# This message shows when all privacy protections are turned off, which is why we use the word "can", Waterfox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } peut protéger votre vie privée en arrière-plan pendant que vous naviguez. Voici un résumé personnalisé de ces protections, avec des outils pour prendre le contrôle de votre sécurité en ligne.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Waterfox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } protège votre vie privée en arrière-plan pendant que vous naviguez. Voici un résumé personnalisé de ces protections, avec des outils pour prendre le contrôle de votre sécurité en ligne.

protection-report-settings-link = Gérer vos paramètres de confidentialité et de sécurité

etp-card-title-always = Protection renforcée contre le pistage : toujours activée
etp-card-title-custom-not-blocking = Protection renforcée contre le pistage : DÉSACTIVÉE
etp-card-content-description = { -brand-short-name } empêche automatiquement les entreprises de vous suivre secrètement sur le Web.
protection-report-etp-card-content-custom-not-blocking = Toutes les protections sont actuellement désactivées. Choisissez les traqueurs à bloquer en gérant les paramètres de protection de { -brand-short-name }.
protection-report-manage-protections = Gérer les paramètres

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = aujourd’hui

# This string is used to describe the graph for screenreader users.
graph-legend-description = Un graphique contenant le nombre total de chaque type de traqueur bloqué cette semaine.

social-tab-title = Traqueurs de réseaux sociaux
social-tab-contant = Les réseaux sociaux placent des traqueurs sur d’autres sites web pour suivre ce que vous faites, lisez et regardez en ligne. Cela permet aux entreprises de réseaux sociaux d’en savoir plus sur vous au-delà de ce que vous partagez sur vos profils en ligne. <a data-l10n-name="learn-more-link">En savoir plus</a>

cookie-tab-title = Cookies de pistage intersites
cookie-tab-content = Ces cookies vous suivent d’un site à l’autre pour collecter des données sur vos faits et gestes en ligne. Ils sont déposés par des tiers, tels que des annonceurs ou des entreprises d’analyse de données. Bloquer les cookies de pistage intersites permet de réduire le nombre de publicités qui vous suivent d’un site à l’autre. <a data-l10n-name="learn-more-link">En savoir plus</a>

tracker-tab-title = Contenu utilisé pour le pistage
tracker-tab-description = Les sites web peuvent charger des publicités, des vidéos et d’autres contenus externes qui contiennent des éléments de pistage. Le blocage du contenu utilisé pour le pistage peut accélérer le chargement des sites, mais certains boutons, formulaires ou champs de connexion risquent de ne pas fonctionner. <a data-l10n-name="learn-more-link">En savoir plus</a>

fingerprinter-tab-title = Détecteurs d’empreinte numérique
fingerprinter-tab-content = Les détecteurs d’empreinte numérique recueillent les paramètres de votre navigateur et de votre ordinateur pour créer un profil de vous. En utilisant cette empreinte numérique, ils peuvent vous pister sur différents sites web. <a data-l10n-name="learn-more-link">En savoir plus</a>

cryptominer-tab-title = Mineurs de cryptomonnaies
cryptominer-tab-content = Les mineurs de cryptomonnaies utilisent la puissance de calcul de votre système pour « extraire » de l’argent numérique. Les scripts de cryptominage déchargent votre batterie, ralentissent votre ordinateur et peuvent augmenter votre facture énergétique. <a data-l10n-name="learn-more-link">En savoir plus</a>

protections-close-button2 =
    .aria-label = Fermer
    .title = Fermer
  
mobile-app-title = Bloquez les traqueurs publicitaires sur plusieurs appareils
mobile-app-card-content = Utilisez le navigateur mobile avec une protection intégrée contre le pistage publicitaire.
mobile-app-links = Navigateur { -brand-product-name } pour <a data-l10n-name="android-mobile-inline-link">Android</a> et <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = N’oubliez plus jamais vos mots de passe
lockwise-title-logged-in2 = Gestion des mots de passe
lockwise-header-content = { -lockwise-brand-name } conserve de manière sécurisée vos mots de passe dans votre navigateur.
lockwise-header-content-logged-in = Enregistrez et synchronisez vos mots de passe sur tous vos appareils en toute sécurité.
protection-report-save-passwords-button = Enregistrer les mots de passe
    .title = Enregistrer les mots de passe dans { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Gérer les mots de passe
    .title = Gérer les mots de passe dans { -lockwise-brand-short-name }
lockwise-mobile-app-title = Emportez vos mots de passe partout
lockwise-no-logins-card-content = Utilisez les mots de passe enregistrés dans { -brand-short-name } sur n’importe quel appareil.
lockwise-app-links = { -lockwise-brand-name } pour <a data-l10n-name="lockwise-android-inline-link">Android</a> et <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 mot de passe peut avoir été compromis dans une fuite de données.
       *[other] { $count } mots de passe peuvent avoir été compromis dans une fuite de données.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 mot de passe stocké en toute sécurité.
       *[other] Vos mots de passe sont stockés en toute sécurité.
    }
lockwise-how-it-works-link = Principes de fonctionnement

monitor-title = Gardez un œil sur les fuites de données
monitor-link = Principes de fonctionnement
monitor-header-content-no-account = Consultez { -monitor-brand-name } pour vérifier si une fuite de données vous concerne et pour recevoir des alertes en cas de nouvelles fuites.
monitor-header-content-signed-in = { -monitor-brand-name } vous alerte si vos informations apparaissent dans une fuite de données connue
monitor-sign-up-link = S’inscrire aux alertes de fuites de données
    .title = S’inscrire aux alertes de fuites de données sur { -monitor-brand-name }
auto-scan = Vérifiées aujourd’hui automatiquement

monitor-emails-tooltip =
    .title = Afficher les adresses électroniques surveillées sur { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Afficher les fuites de données connues sur { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Afficher les mots de passe compromis sur { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] adresse électronique surveillée
       *[other] adresses électroniques surveillées
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] fuite de données connue a compromis vos informations
       *[other] fuites de données connues ont compromis vos informations
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] fuite de données connue marquée comme réglée
       *[other] fuites de données connues marquées comme réglées
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] mot de passe compromis parmi toutes les fuites de données
       *[other] mots de passe compromis parmi toutes les fuites de données
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] mot de passe compromis parmi les fuites de données non réglées
       *[other] mots de passe compromis parmi les fuites de données non réglées
    }

monitor-no-breaches-title = Bonne nouvelle !
monitor-no-breaches-description = Vous n’apparaissez dans aucune fuite de données connue. Si cela vient à changer, nous vous en aviserons.
monitor-view-report-link = Voir le rapport
    .title = Régler les fuites de données avec { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Réglez vos fuites de données
monitor-breaches-unresolved-description = Après avoir examiné les détails des fuites de données et pris des mesures pour protéger vos informations, vous pouvez marquer les fuites comme réglées.
monitor-manage-breaches-link = Gérer les fuites de données
    .title = Gérer les fuites de données avec { -monitor-brand-short-name }
monitor-breaches-resolved-title = Bien ! Vous avez réglé toutes les fuites de données connues.
monitor-breaches-resolved-description = Si votre adresse électronique figure dans de nouvelles fuites de donnés, nous vous préviendrons.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreachesResolved ->
        [one] { $numBreachesResolved } fuite sur { $numBreaches } marquée comme réglée
       *[other] { $numBreachesResolved } fuites sur { $numBreaches } marquées comme réglées
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = Terminé à { $percentageResolved } %

monitor-partial-breaches-motivation-title-start = Un bon début !
monitor-partial-breaches-motivation-title-middle = Gardez le rythme !
monitor-partial-breaches-motivation-title-end = C’est presque fini. Continuez !
monitor-partial-breaches-motivation-description = Réglez vos autres fuites de données avec { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Régler vos fuites de données
    .title = Régler vos fuites de données avec { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Traqueurs de réseaux sociaux
    .aria-label =
        { $count ->
            [one] { $count } traqueur de réseau social ({ $percentage } %)
           *[other] { $count } traqueurs de réseaux sociaux ({ $percentage } %)
        }
bar-tooltip-cookie =
    .title = Cookies de pistage intersites
    .aria-label =
        { $count ->
            [one] { $count } cookie de pistage intersites ({ $percentage } %)
           *[other] { $count } cookies de pistage intersites ({ $percentage } %)
        }
bar-tooltip-tracker =
    .title = Contenu utilisé pour le pistage
    .aria-label =
        { $count ->
            [one] { $count } contenu utilisé pour le pistage ({ $percentage } %)
           *[other] { $count } contenus utilisés pour le pistage ({ $percentage } %)
        }
bar-tooltip-fingerprinter =
    .title = Détecteurs d’empreinte numérique
    .aria-label =
        { $count ->
            [one] { $count } détecteur d’empreinte numérique ({ $percentage } %)
           *[other] { $count } détecteurs d’empreinte numérique ({ $percentage } %)
        }
bar-tooltip-cryptominer =
    .title = Mineurs de cryptomonnaies
    .aria-label =
        { $count ->
            [one] { $count } mineur de cryptomonnaies ({ $percentage } %)
           *[other] { $count } mineurs de cryptomonnaies ({ $percentage } %)
        }
