# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = Les meir
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = { $addonName } ønskjer å endre standard søkjemotor frå { $currentEngine } til { $newEngine }. Er det OK?
webext-default-search-yes =
    .label = Ja
    .accesskey = J
webext-default-search-no =
    .label = Nei
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = { $addonName } vart lagt til.

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = Køyre { $addonName } på avgrensa nettstadar?
webext-quarantine-confirmation-line-1 = For å beskytte dataa dine er denne utvidinga ikkje tillaten på denne nettstaden.
webext-quarantine-confirmation-line-2 = Tillat denne utvidinga, dersom du stolar på henne, å lese og endre dine data på nettstadar avgrensa av { -vendor-short-name }.
webext-quarantine-confirmation-allow =
    .label = Tillat
    .accesskey = T
webext-quarantine-confirmation-deny =
    .label = Ikkje tillat
    .accesskey = I
