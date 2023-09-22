# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = Over { -brand-full-name }

releaseNotes-link = Wat is er nieuw

update-checkForUpdatesButton =
    .label = Controleren op updates
    .accesskey = C

update-updateButton =
    .label = Herstarten om { -brand-shorter-name } bij te werken
    .accesskey = H

update-checkingForUpdates = Controleren op updates…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>Update downloaden – <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Update downloaden – <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Update toepassen…

update-failed = Update mislukt. <label data-l10n-name="failed-link">Download de nieuwste versie</label>
update-failed-main = Update mislukt. <a data-l10n-name="failed-link-main">Download de nieuwste versie</a>

update-adminDisabled = Updates zijn uitgeschakeld door uw systeembeheerder
update-noUpdatesFound = { -brand-short-name } is up-to-date
aboutdialog-update-checking-failed = Kan niet controleren op updates.
update-otherInstanceHandlingUpdates = { -brand-short-name } wordt door een ander exemplaar bijgewerkt

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Updates beschikbaar op <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = Updates beschikbaar op <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = U kunt op dit systeem geen updates meer installeren. <label data-l10n-name="unsupported-link">Meer info</label>

update-restarting = Herstarten…

update-internal-error2 = Kan niet controleren op updates vanwege een interne fout. Updates beschikbaar op <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = U gebruikt momenteel het <label data-l10n-name="current-channel">{ $channel }</label>-updatekanaal.

warningDesc-version = { -brand-short-name } is experimenteel en kan onstabiel zijn.

aboutdialog-help-user = { -brand-product-name } Help
aboutdialog-submit-feedback = Feedback verzenden

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> is een <label data-l10n-name="community-exp-creditsLink">wereldwijde gemeenschap</label> die samenwerkt om het internet open, openbaar en voor iedereen toegankelijk te houden.

community-2 = { -brand-short-name } is ontworpen door <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>, een <label data-l10n-name="community-creditsLink">wereldwijde gemeenschap</label> die samenwerkt om het internet open, openbaar en voor iedereen toegankelijk te houden.

helpus = Wilt u helpen? <label data-l10n-name="helpus-donateLink">Geef een donatie</label> of <label data-l10n-name="helpus-getInvolvedLink">doe mee!</label>

bottomLinks-license = Licentie-informatie
bottomLinks-rights = Eindgebruikersrechten
bottomLinks-privacy = Privacybeleid

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits }-bits)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits }-bits)
