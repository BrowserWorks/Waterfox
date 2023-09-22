# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = A { -brand-full-name } névjegye

releaseNotes-link = Újdonságok

update-checkForUpdatesButton =
    .label = Frissítések keresése
    .accesskey = F

update-updateButton =
    .label = Újraindítás a { -brand-shorter-name } frissítéséhez
    .accesskey = R

update-checkingForUpdates = Frissítések keresése…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>Frissítés letöltése – <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Frissítés letöltése – <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Frissítés alkalmazása…

update-failed = A frissítés sikertelen.<label data-l10n-name="failed-link">Töltse le a legújabb verziót</label>
update-failed-main = A frissítés sikertelen.<a data-l10n-name="failed-link-main">Töltse le a legújabb verziót</a>

update-adminDisabled = A frissítéseket a rendszergazda letiltotta
update-noUpdatesFound = A { -brand-short-name } naprakész
aboutdialog-update-checking-failed = Nem sikerült a frissítések keresése.
update-otherInstanceHandlingUpdates = A { -brand-short-name } frissítése folyamatban egy másik példány által

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Frissítés elérhető: <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = Frissítés érhető el itt: <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = Nem végezhet további frissítéseket ezen a rendszeren.<label data-l10n-name="unsupported-link">További tudnivalók</label>

update-restarting = Újraindítás…

update-internal-error2 = Belső hiba miatt nem lehet frissítéseket keresni. A frissítések itt érhetők el: <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = Jelenleg a(z) <label data-l10n-name="current-channel">{ $channel }</label> frissítési csatornát használja.

warningDesc-version = A { -brand-short-name } kísérleti és esetleg instabil.

aboutdialog-help-user = { -brand-product-name } súgó
aboutdialog-submit-feedback = Visszajelzés küldése

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> egy <label data-l10n-name="community-exp-creditsLink">nemzetközi közösség</label>, amely a nyílt, nyilvános és mindenki számára elérhető világhálóért dolgozik.

community-2 = A { -brand-short-name } böngészőt a <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label> tervezte, egy <label data-l10n-name="community-creditsLink">nemzetközi közösség</label>, amely a nyílt, nyilvános és mindenki számára elérhető világhálóért dolgozik.

helpus = Szeretne segíteni? <label data-l10n-name="helpus-donateLink">Támogasson,</label> vagy <label data-l10n-name="helpus-getInvolvedLink">vegyen részt a munkánkban!</label>

bottomLinks-license = Licencinformációk
bottomLinks-rights = Végfelhasználói jogok
bottomLinks-privacy = Adatvédelmi irányelvek

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits } bites)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits } bites)
