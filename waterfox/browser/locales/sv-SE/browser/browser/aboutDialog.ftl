# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = Om { -brand-full-name }

releaseNotes-link = Vad är nytt

update-checkForUpdatesButton =
    .label = Sök efter uppdateringar
    .accesskey = ö

update-updateButton =
    .label = Starta om för att uppdatera { -brand-shorter-name }
    .accesskey = S

update-checkingForUpdates = Söker efter uppdateringar…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>Hämtar uppdatering — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Hämtar uppdatering — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Utför uppdatering…

update-failed = Uppdatering misslyckades. <label data-l10n-name="failed-link">Hämta den senaste versionen</label>
update-failed-main = Uppdatering misslyckades. <a data-l10n-name="failed-link-main">Hämta den senaste versionen</a>

update-adminDisabled = Uppdateringar är inaktiverade av systemadministratören
update-noUpdatesFound = { -brand-short-name } är redan uppdaterad
aboutdialog-update-checking-failed = Det gick inte att söka efter uppdateringar.
update-otherInstanceHandlingUpdates = { -brand-short-name } uppdateras av en annan instans

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Uppdateringar finns på <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = Uppdateringar finns tillgängliga på <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = Du kan inte utföra fler uppdateringar på detta system. <label data-l10n-name="unsupported-link">Läs mer</label>

update-restarting = Startar om…

update-internal-error2 = Det gick inte att söka efter uppdateringar på grund av internt fel. Uppdateringar finns tillgängliga på <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = Du finns för närvarande på uppdateringskanalen <label data-l10n-name="current-channel">{ $channel }</label>uppdaterings kanal.

warningDesc-version = { -brand-short-name } är experimentell och kan vara instabil.

aboutdialog-help-user = { -brand-product-name } Hjälp
aboutdialog-submit-feedback = Skicka in återkoppling

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> är en <label data-l10n-name="community-exp-creditsLink">global gemenskap</label> som arbetar tillsammans för att hålla webben öppen och tillgänglig för alla.

community-2 = { -brand-short-name }, utvecklad av <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>, en <label data-l10n-name="community-creditsLink">global gemenskap</label> som arbetar tillsammans för att hålla webben öppen och tillgänglig för alla.

helpus = Vill du hjälpa till? <label data-l10n-name="helpus-donateLink">Ge ett bidrag</label> eller <label data-l10n-name="helpus-getInvolvedLink">engagera dig!</label>

bottomLinks-license = Licensinformation
bottomLinks-rights = Användarrättigheter
bottomLinks-privacy = Sekretesspolicy

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits }-bitars)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits }-bitars)
