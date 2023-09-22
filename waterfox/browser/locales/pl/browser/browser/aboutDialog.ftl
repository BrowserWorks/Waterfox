# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = O programie { -brand-full-name }

releaseNotes-link = Informacje o wydaniu

update-checkForUpdatesButton =
    .label = Sprawdź dostępność aktualizacji
    .accesskey = S

update-updateButton =
    .label = Uruchom ponownie, aby uaktualnić przeglądarkę { -brand-shorter-name }
    .accesskey = U

update-checkingForUpdates = Poszukiwanie aktualizacji…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/> Pobieranie aktualizacji — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Pobieranie aktualizacji — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Instalowanie aktualizacji…

update-failed = Aktualizacja się nie powiodła. <label data-l10n-name="failed-link">Pobierz najnowszą wersję</label>.
update-failed-main = Aktualizacja się nie powiodła. <a data-l10n-name="failed-link-main">Pobierz najnowszą wersję</a>.

update-adminDisabled = Aktualizacje zablokowane przez administratora komputera.
update-noUpdatesFound = { -brand-short-name } jest aktualny.
aboutdialog-update-checking-failed = Sprawdzenie dostępności aktualizacji się nie powiodło.
update-otherInstanceHandlingUpdates = Inna instancja właśnie aktualizuje program { -brand-short-name }.

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Aktualizacje są dostępne na <label data-l10n-name="manual-link">{ $displayUrl }</label>.
settings-update-manual-with-link = Aktualizacje są dostępne na <a data-l10n-name="manual-link">{ $displayUrl }</a>.

update-unsupported = Dalsze aktualizacje na tym systemie nie są możliwe. <label data-l10n-name="unsupported-link">Więcej informacji</label>.

update-restarting = Ponowne uruchamianie…

update-internal-error2 = Nie można sprawdzić dostępności aktualizacji z powodu błędu wewnętrznego. Aktualizacje są dostępne na <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = Obecnie korzystasz z kanału aktualizacji „<label data-l10n-name="current-channel">{ $channel }</label>”.

warningDesc-version = { -brand-short-name } jest wersją rozwojową programu i może być niestabilny.

aboutdialog-help-user = Pomoc programu { -brand-product-name }
aboutdialog-submit-feedback = Prześlij swoją opinię

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> jest <label data-l10n-name="community-exp-creditsLink">globalną społecznością</label>, starającą się zapewnić, by Internet pozostał otwarty, publiczny i dostępny dla wszystkich.

community-2 = { -brand-short-name } został opracowany przez <label data-l10n-name="community-mozillaLink">{ -vendor-short-name(case: "acc") }</label>, która jest <label data-l10n-name="community-creditsLink">globalną społecznością</label>, starającą się zapewnić, by Internet pozostał otwarty, publiczny i dostępny dla wszystkich.

helpus = Chcesz pomóc? <label data-l10n-name="helpus-donateLink">Przekaż datek</label> lub <label data-l10n-name="helpus-getInvolvedLink">dołącz do nas</label>.

bottomLinks-license = Informacje licencyjne
bottomLinks-rights = Prawa użytkownika
bottomLinks-privacy = Zasady ochrony prywatności

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits } bity)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits } bity)
