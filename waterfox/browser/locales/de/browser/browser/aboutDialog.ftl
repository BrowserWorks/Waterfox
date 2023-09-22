# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = Über { -brand-full-name }

releaseNotes-link = Neue Funktionen und Änderungen

update-checkForUpdatesButton =
    .label = Nach Updates suchen
    .accesskey = N

update-updateButton =
    .label = Zum Abschließen des Updates { -brand-shorter-name } neu starten
    .accesskey = Z

update-checkingForUpdates = Nach Updates suchen…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>Update wird heruntergeladen — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Update wird heruntergeladen – <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Update wird durchgeführt…

update-failed = Update fehlgeschlagen. <label data-l10n-name="failed-link">Laden Sie die neueste Version herunter</label>
update-failed-main = Update fehlgeschlagen. <a data-l10n-name="failed-link-main">Laden Sie die neueste Version herunter</a>

update-adminDisabled = Updates von Ihrem System-Administrator deaktiviert
update-noUpdatesFound = { -brand-short-name } ist aktuell
aboutdialog-update-checking-failed = Suche nach Updates fehlgeschlagen.
update-otherInstanceHandlingUpdates = { -brand-short-name } wird durch eine andere Instanz aktualisiert.

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Updates verfügbar unter <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = Updates verfügbar unter <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = Auf diesem System können keine weiteren Updates installiert werden. <label data-l10n-name="unsupported-link">Weitere Informationen</label>

update-restarting = Wird neu gestartet…

update-internal-error2 = Aufgrund eines internen Fehlers konnte nicht nach Updates gesucht werden. Updates verfügbar unter <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = Sie sind derzeit auf dem Update-Kanal <label data-l10n-name="current-channel">{ $channel }</label>.

warningDesc-version = { -brand-short-name } ist experimentell und könnte instabil sein.

aboutdialog-help-user = { -brand-product-name }-Hilfe
aboutdialog-submit-feedback = Feedback senden

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> ist eine <label data-l10n-name="community-exp-creditsLink">globale Community</label>, die daran arbeitet, dass das Internet frei, öffentlich und für jeden zugänglich bleibt.

community-2 = { -brand-short-name } wird entwickelt und gestaltet von <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>, einer <label data-l10n-name="community-creditsLink">globalen Community</label>, die daran arbeitet, dass das Internet frei, öffentlich und für jeden zugänglich bleibt.

helpus = Wollen Sie uns unterstützen? <label data-l10n-name="helpus-donateLink">Spenden Sie</label> oder <label data-l10n-name="helpus-getInvolvedLink">machen Sie mit!</label>

bottomLinks-license = Informationen zur Lizenzierung
bottomLinks-rights = Endanwenderrechte
bottomLinks-privacy = Datenschutzbestimmungen

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits }-Bit)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits }-Bit)
