# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = Apie „{ -brand-full-name }“

releaseNotes-link = Kas naujo

update-checkForUpdatesButton =
    .label = Patikrinti ar yra naujinimų
    .accesskey = P

update-updateButton =
    .label = Perleiskite, norėdami atnaujinti „{ -brand-shorter-name }“
    .accesskey = P

update-checkingForUpdates = Tikrinama, ar yra naujinimų…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>Atsiunčiamas naujinimas — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Atsisiunčiamas naujinimas – <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Diegiamas naujinimas…

update-failed = Programos atnaujinti nepavyko. <label data-l10n-name="failed-link">Atsisiųskite paskiausią laidą</label>
update-failed-main = Programos atnaujinti nepavyko. <a data-l10n-name="failed-link-main">Atsisiųskite paskiausią laidą</a>

update-adminDisabled = Naujinimus uždraudė sistemos administratorius
update-noUpdatesFound = Naudojama paskiausia „{ -brand-short-name }“ laida
aboutdialog-update-checking-failed = Nepavyko patikrinti, ar yra naujinimų.
update-otherInstanceHandlingUpdates = Programa „{ -brand-short-name }“ šiuo metu naujinama

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Atsisiųskite naujinimą iš <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = Atsisiųskite naujinimą iš <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = Tolesni naujinimai, naudojantis šia sistema, yra negalimi. <label data-l10n-name="unsupported-link">Sužinoti daugiau</label>

update-restarting = Paleidžiama iš naujo…

update-internal-error2 = Dėl vidinės klaidos nepavyko patikrinti, ar yra naujinimų. Naujinimai pasiekiami per <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = Šiuo metu naudojamas <label data-l10n-name="current-channel">{ $channel }</label> naujinimų kanalas.

warningDesc-version = „{ -brand-short-name }“ yra eksperimentinė programa ir gali būti nestabili.

aboutdialog-help-user = „{ -brand-product-name }“ žinynas
aboutdialog-submit-feedback = Siųsti atsiliepimą

community-exp = <label data-l10n-name="community-exp-mozillaLink">„{ -vendor-short-name }“</label> – tai <label data-l10n-name="community-exp-creditsLink">pasaulinė bendruomenė</label>, siekianti, kad saitynas būtų atviras, viešas ir prieinamas kiekvienam.

community-2 = „{ -brand-short-name }“ kuria ir tobulina <label data-l10n-name="community-mozillaLink">„{ -vendor-short-name }“</label> – <label data-l10n-name="community-creditsLink">pasaulinė bendruomenė</label>, siekianti, kad saitynas būtų atviras, viešas ir prieinamas kiekvienam.

helpus = Norite padėti? <label data-l10n-name="helpus-donateLink">Paaukokite</label> arba <label data-l10n-name="helpus-getInvolvedLink">įsitraukite į veiklą!</label>

bottomLinks-license = Informacija apie licencijavimą
bottomLinks-rights = Galutinio naudotojo teisės
bottomLinks-privacy = Privatumo nuostatai

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits } bitų)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits } bitų)
