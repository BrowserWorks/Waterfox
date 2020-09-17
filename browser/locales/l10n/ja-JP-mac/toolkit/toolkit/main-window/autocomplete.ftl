# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## Import Logins Autocomplete

# Variables:
#   $browser (String) - Browser name to import logins from.
#   $host (String) - Host name of the current site.
autocomplete-import-logins =
    <div data-l10n-name="line2">{ $host } および他のサイトのログイン情報を</div>
    <div data-l10n-name="line1">{ $browser } から読み込みます</div>

autocomplete-import-logins-info =
    .tooltiptext = 詳細情報

## Variables:
##   $host (String) - Host name of the current site.

autocomplete-import-logins-chrome =
    <div data-l10n-name="line1">{ $host } および他のサイトのログイン情報を</div>
    <div data-l10n-name="line2">Google Chrome から読み込みます</div>
autocomplete-import-logins-chromium =
    <div data-l10n-name="line1">{ $host } および他のサイトのログイン情報を</div>
    <div data-l10n-name="line2">Chromium から読み込みます</div>
autocomplete-import-logins-chromium-edge =
    <div data-l10n-name="line1">{ $host } および他のサイトのログイン情報を</div>
    <div data-l10n-name="line2">Microsoft Edge から読み込みます</div>

##

# (^m^) リンク先: https://support.mozilla.org/kb/import-data-another-browser
autocomplete-import-learn-more = 詳細情報
