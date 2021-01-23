# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Rapport pour { $addon-name }

abuse-report-title-extension = Signaler cette extension à { -vendor-short-name }
abuse-report-title-theme = Signaler ce thème à { -vendor-short-name }
abuse-report-subtitle = Quel est le problème ?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = par <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Vous ne savez pas quel problème choisir ?
    <a data-l10n-name="learnmore-link">Apprenez-en plus sur le signalement d’extensions et de thèmes</a>

abuse-report-submit-description = Décrivez le problème (facultatif)
abuse-report-textarea =
    .placeholder = Il est plus facile pour nous de résoudre un problème si nous avons connaissance des détails. Veuillez décrire ce que vous avez constaté. Merci de nous aider à garder le Web en bonne santé.
abuse-report-submit-note =
    Remarque : N’incluez pas d’informations personnelles (telles que nom, adresse électronique, numéro de téléphone, adresse physique).
    { -vendor-short-name } conserve un enregistrement permanent de ces rapports.

## Panel buttons.

abuse-report-cancel-button = Annuler
abuse-report-next-button = Suivant
abuse-report-goback-button = Retour
abuse-report-submit-button = Envoyer

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Signalement de <span data-l10n-name="addon-name">{ $addon-name }</span> annulé.
abuse-report-messagebar-submitting = Envoi du signalement concernant <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Merci d’avoir soumis un rapport. Voulez-vous supprimer <span data-l10n-name="addon-name">{ $addon-name }</span> ?
abuse-report-messagebar-submitted-noremove = Merci d’avoir soumis un rapport.
abuse-report-messagebar-removed-extension = Merci d’avoir soumis un rapport. Vous avez supprimé l’extension <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Merci d’avoir soumis un rapport. Vous avez supprimé le thème <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Une erreur s’est produite lors de l’envoi du rapport pour <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Le rapport <span data-l10n-name="addon-name">{ $addon-name }</span> n’a pas été transmis car un autre rapport a été transmis récemment.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Oui, supprimez-la
abuse-report-messagebar-action-keep-extension = Non, je vais la conserver
abuse-report-messagebar-action-remove-theme = Oui, supprimez-le
abuse-report-messagebar-action-keep-theme = Non, je vais le conserver
abuse-report-messagebar-action-retry = Réessayer
abuse-report-messagebar-action-cancel = Annuler

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Mes données ou mon ordinateur ont été endommagés
abuse-report-damage-example = Exemple : a injecté un logiciel malveillant ou volé des données

abuse-report-spam-reason-v2 = Contient du spam ou insère de la publicité indésirable
abuse-report-spam-example = Exemple : insère des publicités sur des pages web

abuse-report-settings-reason-v2 = A modifié mon moteur de recherche, ma page d’accueil ou de nouvel onglet sans me prévenir ou me demander
abuse-report-settings-suggestions = Avant de signaler l’extension, vous pouvez essayer de modifier vos paramètres :
abuse-report-settings-suggestions-search = Modifie vos paramètres de recherche par défaut
abuse-report-settings-suggestions-homepage = Modifie votre page d’accueil et de nouvel onglet

abuse-report-deceptive-reason-v2 = Prétend être ce qu’il/elle n’est pas
abuse-report-deceptive-example = Exemple : description ou images trompeuses

abuse-report-broken-reason-extension-v2 = Ne fonctionne pas, casse les sites web ou ralentit { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Ne fonctionne pas ou interrompt l’affichage du navigateur
abuse-report-broken-example = Exemple : les fonctionnalités sont lentes, difficiles à utiliser ou ne fonctionnent pas ; des parties de sites web ne se chargent pas ou semblent inhabituelles
abuse-report-broken-suggestions-extension =
    Vous avez probablement identifié un problème. En plus de soumettre un rapport ici, la meilleure façon de résoudre un problème de fonctionnalité est de contacter le développeur de l’extension.
    <a data-l10n-name="support-link">Visitez le site web de l’extension</a> pour obtenir des informations sur le développeur.
abuse-report-broken-suggestions-theme =
    Vous avez probablement identifié un problème. En plus de soumettre un rapport ici, la meilleure façon de résoudre un problème de fonctionnalité est de contacter le développeur du thème.
    <a data-l10n-name="support-link">Visitez le site web du thème</a> pour trouver des informations sur le développeur.

abuse-report-policy-reason-v2 = Contient des contenus haineux, violents ou illégaux
abuse-report-policy-suggestions =
    Remarque : Les problèmes de droits d’auteur et de marques doivent être signalés dans un processus séparé.
    <a data-l10n-name="report-infringement-link">Suivez ces instructions</a> pour signaler le problème.

abuse-report-unwanted-reason-v2 = Je n’en ai jamais voulu et je ne sais pas comment m’en débarrasser
abuse-report-unwanted-example = Exemple : une application l’a installée sans mon autorisation

abuse-report-other-reason = Autre chose

