# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = Læs mere
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = { $addonName } vil ændre din standard-søgetjeneste fra { $currentEngine } til { $newEngine }. Er det i orden?
webext-default-search-yes =
    .label = Ja
    .accesskey = J
webext-default-search-no =
    .label = Nej
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = { $addonName } blev tilføjet.

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = Kør { $addonName } på websteder underlagt begrænsninger?
webext-quarantine-confirmation-line-1 = For at beskytte dine data er denne udvidelse ikke tilladt på dette websted.
webext-quarantine-confirmation-line-2 = Tillad kun denne udvidelse, hvis du stoler på den og vil give den adgang til at læse og ændre dine data på websteder, som er underlagt begrænsninger af { -vendor-short-name }.
webext-quarantine-confirmation-allow =
    .label = Tillad
    .accesskey = T
webext-quarantine-confirmation-deny =
    .label = Tillad ikke
    .accesskey = k
