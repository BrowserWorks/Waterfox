# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = Informazioni su { -brand-full-name }

releaseNotes-link = Novità

update-checkForUpdatesButton =
    .label = Controlla aggiornamenti
    .accesskey = C

update-updateButton =
    .label = Riavvia per aggiornare { -brand-shorter-name }
    .accesskey = R

update-checkingForUpdates = Ricerca aggiornamenti…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>Download aggiornamento — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Download aggiornamento — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Installazione aggiornamento…

update-failed = Aggiornamento non riuscito. <label data-l10n-name="failed-link">Scarica l’ultima versione</label>
update-failed-main = Aggiornamento non riuscito. <a data-l10n-name="failed-link-main">Scarica l’ultima versione</a>

update-adminDisabled = Aggiornamenti disattivati dall’amministratore di sistema
update-noUpdatesFound = { -brand-short-name } è aggiornato
aboutdialog-update-checking-failed = Impossibile controllare la disponibilità di aggiornamenti.
update-otherInstanceHandlingUpdates = Aggiornamento di { -brand-short-name } in corso in un’altra istanza

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Aggiornamenti disponibili su <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = Aggiornamenti disponibili su <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = Non è possibile installare ulteriori aggiornamenti su questo sistema. <label data-l10n-name="unsupported-link">Ulteriori informazioni</label>

update-restarting = Riavvio…

update-internal-error2 = Impossibile verificare la disponibilità di aggiornamenti a causa di un errore interno. Aggiornamenti disponibili a <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = Canale di aggiornamento attuale: <label data-l10n-name="current-channel">{ $channel }</label>.

warningDesc-version = { -brand-short-name } è una versione sperimentale e potrebbe risultare instabile.

aboutdialog-help-user = Supporto per { -brand-product-name }
aboutdialog-submit-feedback = Invia feedback

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> è una <label data-l10n-name="community-exp-creditsLink">comunità mondiale</label> che lavora per mantenere il Web aperto, pubblico e accessibile a tutti.

community-2 = { -brand-short-name } è progettato da <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>, una <label data-l10n-name="community-creditsLink">comunità mondiale</label> che lavora per mantenere il Web aperto, pubblico e accessibile a tutti.

helpus = Vuoi aiutarci? <label data-l10n-name="helpus-donateLink">Fai una donazione</label> o <label data-l10n-name="helpus-getInvolvedLink">collabora con noi</label>

bottomLinks-license = Informazioni sulla licenza
bottomLinks-rights = Diritti dell’utente finale
bottomLinks-privacy = Informativa sulla privacy

aboutDialog-version = { $version } ({ $bits } bit)

aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits } bit)
