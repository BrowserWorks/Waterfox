# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Import Logins Autocomplete

# Variables:
#   $browser (String) - Browser name to import logins from.
#   $host (String) - Host name of the current site.
autocomplete-import-logins =
    <div data-l10n-name="line1">Tuo kirjautumistietosi ohjelmasta { $browser }</div>¶
    <div data-l10n-name="line2"> sivustoa { $host } ja muita sivustoja varten</div>
autocomplete-import-logins-info =
    .tooltiptext = Lue lisää

## Variables:
##   $host (String) - Host name of the current site.

autocomplete-import-logins-chrome =
    <div data-l10n-name="line1">Tuo kirjautumistietosi Google Chromesta</div>
    <div data-l10n-name="line2">sivustoa { $host } ja muita sivustoja varten</div>
autocomplete-import-logins-chromium =
    <div data-l10n-name="line1">Tuo kirjautumistietosi Chromiumista</div>
    <div data-l10n-name="line2">sivustoa { $host } ja muita sivustoja varten</div>
autocomplete-import-logins-chromium-edge =
    <div data-l10n-name="line1">Tuo kirjautumistietosi Microsoft Edgestä</div>
    <div data-l10n-name="line2">sivustoa { $host } ja muita sivustoja varten</div>

##

autocomplete-import-learn-more = Lue lisää
