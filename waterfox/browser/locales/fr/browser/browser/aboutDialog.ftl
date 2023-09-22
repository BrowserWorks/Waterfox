# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = À propos de { -brand-full-name }

releaseNotes-link = Notes de version

update-checkForUpdatesButton =
    .label = Rechercher des mises à jour
    .accesskey = R

update-updateButton =
    .label = Redémarrer pour mettre à jour { -brand-shorter-name }
    .accesskey = R

update-checkingForUpdates = Recherche de mises à jour…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>Téléchargement de la mise à jour — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Téléchargement de la mise à jour — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Application de la mise à jour…

update-failed = La mise à jour a échoué. <label data-l10n-name="failed-link">Télécharger la dernière version</label>
update-failed-main = La mise à jour a échoué. <a data-l10n-name="failed-link-main">Télécharger la dernière version</a>

update-adminDisabled = Les mises à jour sont désactivées par votre administrateur système
update-noUpdatesFound = { -brand-short-name } est à jour
aboutdialog-update-checking-failed = Échec de la vérification des mises à jour.
update-otherInstanceHandlingUpdates = { -brand-short-name } est mis à jour par une autre instance

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Mises à jour disponibles à <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = Mises à jour disponibles sur <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = La dernière version n’est pas disponible pour votre système. <label data-l10n-name="unsupported-link">En savoir plus</label>

update-restarting = Redémarrage…

update-internal-error2 = Une erreur interne empêche la vérification des mises à jour. Elles sont disponibles sur <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = Vous utilisez actuellement le canal de mise à jour <label data-l10n-name="current-channel">{ $channel }</label>.

warningDesc-version = { -brand-short-name } est expérimental et peut être instable.

aboutdialog-help-user = Aide de { -brand-product-name }
aboutdialog-submit-feedback = Donner votre avis

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> est une <label data-l10n-name="community-exp-creditsLink">communauté mondiale</label> de contributeurs qui travaillent ensemble pour garder le Web ouvert, public et accessible à tous.

community-2 = { -brand-short-name } est conçu par <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>, une communauté mondiale de <label data-l10n-name="community-creditsLink">contributeurs</label> qui travaillent ensemble pour garder le Web ouvert, public et accessible à tous.

helpus = Vous souhaitez aider ? Vous pouvez <label data-l10n-name="helpus-donateLink">faire un don</label> ou bien <label data-l10n-name="helpus-getInvolvedLink">participer</label>

bottomLinks-license = Informations de licence
bottomLinks-rights = Droits de l’utilisateur
bottomLinks-privacy = Politique de confidentialité

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits } bits)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits } bits)
