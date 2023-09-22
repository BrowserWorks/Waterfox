# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = Läs mer
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = { $addonName } vill du ändra din förvalda sökmotor från { $currentEngine } till { $newEngine }. Är det OK?
webext-default-search-yes =
    .label = Ja
    .accesskey = J
webext-default-search-no =
    .label = Nej
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = { $addonName } har lagts till.

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = Kör { $addonName } på begränsade webbplatser?
webext-quarantine-confirmation-line-1 = För att skydda dina uppgifter är detta tillägg inte tillåtet på den här webbplatsen.
webext-quarantine-confirmation-line-2 = Tillåt det här tillägget om du litar på att det läser och ändrar dina data på webbplatser som begränsas av { -vendor-short-name }.
webext-quarantine-confirmation-allow =
    .label = Tillåt
    .accesskey = T
webext-quarantine-confirmation-deny =
    .label = Tillåt inte
    .accesskey = n
