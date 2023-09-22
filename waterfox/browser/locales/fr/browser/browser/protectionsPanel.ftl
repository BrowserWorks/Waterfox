# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Une erreur s’est produite lors de l’envoi du rapport. Veuillez réessayer plus tard.
# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Le site est réparé ? Envoyez le rapport.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Stricts
    .label = Stricts
protections-popup-footer-protection-label-custom = Personnalisés
    .label = Personnalisés
protections-popup-footer-protection-label-standard = Standards
    .label = Standards

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Plus d’informations sur la protection renforcée contre le pistage
protections-panel-etp-on-header = La protection renforcée contre le pistage est ACTIVÉE pour ce site.
protections-panel-etp-off-header = La protection renforcée contre le pistage est DÉSACTIVÉE pour ce site.

## Text for the toggles shown when ETP is enabled/disabled for a given site.
## .description is transferred into a separate paragraph by the moz-toggle
## custom element code.
##   $host (String): the hostname of the site that is being displayed.

protections-panel-etp-on-toggle =
    .label = Protection renforcée contre le pistage
    .description = Activée pour ce site
    .aria-label = Désactiver les protections pour { $host }
protections-panel-etp-off-toggle =
    .label = Protection renforcée contre le pistage
    .description = Désactivée pour ce site
    .aria-label = Activer les protections pour { $host }
# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Le site ne fonctionne pas ?
# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Le site ne fonctionne pas ?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Pourquoi ?
protections-panel-not-blocking-why-etp-on-tooltip = Bloquer ces éléments peut entraîner un dysfonctionnement partiel de certains sites web. Sans les traqueurs, certains boutons, formulaires ou champs de connexion peuvent ne pas fonctionner correctement.
protections-panel-not-blocking-why-etp-off-tooltip = Tous les traqueurs sur ce site ont été chargés car les protections sont désactivées.

##

protections-panel-no-trackers-found = Aucun traqueur connu par { -brand-short-name } n’a été détecté sur cette page.
protections-panel-content-blocking-tracking-protection = Contenu utilisé pour le pistage
protections-panel-content-blocking-socialblock = Traqueurs de réseaux sociaux
protections-panel-content-blocking-cryptominers-label = Mineurs de cryptomonnaies
protections-panel-content-blocking-fingerprinters-label = Détecteurs d’empreinte numérique

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Bloqués
protections-panel-not-blocking-label = Autorisés
protections-panel-not-found-label = Aucun détecté

##

protections-panel-settings-label = Paramètres de protection
protections-panel-protectionsdashboard-label = Tableau de bord des protections

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Désactivez les protections si vous rencontrez des problèmes avec :
# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Les champs de connexion
protections-panel-site-not-working-view-issue-list-forms = Les formulaires
protections-panel-site-not-working-view-issue-list-payments = Les paiements
protections-panel-site-not-working-view-issue-list-comments = Les commentaires
protections-panel-site-not-working-view-issue-list-videos = Les vidéos
protections-panel-site-not-working-view-issue-list-fonts = Polices de caractères
protections-panel-site-not-working-view-send-report = Envoyer un rapport

##

protections-panel-cross-site-tracking-cookies = Ces cookies vous suivent de site en site pour collecter des données sur vos faits et gestes en ligne. Ils sont déposés par des tiers, tels que des annonceurs ou des entreprises d’analyse de données.
protections-panel-cryptominers = Les mineurs de cryptomonnaies utilisent la puissance de calcul de votre système pour « extraire » de l’argent numérique. Les scripts de cryptominage déchargent votre batterie, ralentissent votre ordinateur et peuvent augmenter votre facture énergétique.
protections-panel-fingerprinters = Les détecteurs d’empreinte numérique recueillent les paramètres de votre navigateur et de votre ordinateur pour créer un profil de vous. En utilisant cette empreinte numérique, ils peuvent vous pister sur différents sites web.
protections-panel-tracking-content = Les sites web peuvent charger des publicités, des vidéos et d’autres contenus externes qui contiennent des éléments de pistage. Le blocage du contenu utilisé pour le pistage peut accélérer le chargement des sites, mais certains boutons, formulaires ou champs de connexion risquent de ne pas fonctionner.
protections-panel-social-media-trackers = Les réseaux sociaux placent des traqueurs sur d’autres sites web pour suivre ce que vous faites, lisez et regardez en ligne. Cela permet aux entreprises de réseaux sociaux d’en savoir plus sur vous au-delà de ce que vous partagez sur vos profils en ligne.
protections-panel-description-shim-allowed = Certains traqueurs marqués ci-dessous ont été partiellement débloqués sur cette page car vous avez interagi avec eux.
protections-panel-description-shim-allowed-learn-more = En savoir plus
protections-panel-shim-allowed-indicator =
    .tooltiptext = Traqueur partiellement débloqué
protections-panel-content-blocking-manage-settings =
    .label = Gérer les paramètres de protection
    .accesskey = G
protections-panel-content-blocking-breakage-report-view =
    .title = Signaler des problèmes avec ce site
protections-panel-content-blocking-breakage-report-view-description = Le blocage de certains traqueurs peut occasionner des problèmes sur des sites web. En signalant ces problèmes, vous contribuez à rendre { -brand-short-name } meilleur pour tout le monde. L’envoi du rapport communiquera une URL ainsi que des informations sur les préférences de votre navigateur à BrowserWorks. <label data-l10n-name="learn-more">En savoir plus</label>
protections-panel-content-blocking-breakage-report-view-description2 = Le blocage de certains traqueurs peut occasionner des problèmes sur des sites web. En signalant ces problèmes, vous contribuez à rendre { -brand-short-name } meilleur pour tout le monde. L’envoi du rapport communiquera une URL ainsi que des informations sur les préférences de votre navigateur à { -vendor-short-name }.
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Facultatif : décrivez le problème
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Facultatif : décrivez le problème
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Annuler
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Envoyer le rapport

# Cookie Banner Handling

protections-panel-cookie-banner-handling-header = Réduction des bannières de cookies
protections-panel-cookie-banner-handling-enabled = Activée pour ce site
protections-panel-cookie-banner-handling-disabled = Désactivée pour ce site
protections-panel-cookie-banner-handling-undetected = Site actuellement non pris en charge
protections-panel-cookie-banner-view-title =
    .title = Réduction des bannières de cookies
# Variables
#  $host (String): the hostname of the site that is being displayed.
protections-panel-cookie-banner-view-turn-off-for-site = Désactiver la réduction des bannières de cookies pour { $host } ?
protections-panel-cookie-banner-view-turn-on-for-site = Activer la réduction des bannières de cookies pour ce site ?
protections-panel-cookie-banner-view-cookie-clear-warning = { -brand-short-name } effacera les cookies de ce site et actualisera la page. La suppression de tous les cookies peut vous déconnecter ou vider les paniers d’achats.
protections-panel-cookie-banner-view-turn-on-description = { -brand-short-name } peut essayer de refuser automatiquement les demandes de dépôt de cookies sur les sites compatibles.
protections-panel-cookie-banner-view-cancel = Annuler
protections-panel-cookie-banner-view-turn-off = Désactiver
protections-panel-cookie-banner-view-turn-on = Activer
