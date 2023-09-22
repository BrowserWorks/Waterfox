# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = Weitere Informationen
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = { $addonName } will die Standardsuchmaschine von { $currentEngine } zu { $newEngine } ändern. Soll diese Änderung vorgenommen werden?
webext-default-search-yes =
    .label = Ja
    .accesskey = J
webext-default-search-no =
    .label = Nein
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = { $addonName } wurde hinzugefügt.

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = { $addonName } auf eingeschränkten Websites ausführen?
webext-quarantine-confirmation-line-1 = Um Ihre Daten zu schützen, ist diese Erweiterung auf dieser Website nicht erlaubt.
webext-quarantine-confirmation-line-2 = Erlauben Sie dieser Erweiterung nur dann den Zugriff, wenn Sie ihr vertrauen, Ihre Daten auf Websites zu lesen und zu ändern, die durch { -vendor-short-name } eingeschränkt werden.
webext-quarantine-confirmation-allow =
    .label = Erlauben
    .accesskey = E
webext-quarantine-confirmation-deny =
    .label = Nicht erlauben
    .accesskey = N
