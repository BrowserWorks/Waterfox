# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = Więcej informacji
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = Czy pozwolić rozszerzeniu „{ $addonName }” zmienić domyślną wyszukiwarkę z „{ $currentEngine }” na „{ $newEngine }”?
webext-default-search-yes =
    .label = Tak
    .accesskey = T
webext-default-search-no =
    .label = Nie
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = Dodano rozszerzenie „{ $addonName }”.

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = Czy zezwolić rozszerzeniu „{ $addonName }” działać na witrynach z ograniczeniami?
webext-quarantine-confirmation-line-1 = Aby chronić dane użytkownika, to rozszerzenie nie jest dozwolone na tej witrynie.
webext-quarantine-confirmation-line-2 = Zezwolenie temu rozszerzeniu pozwoli mu odczytywać i zmieniać dane użytkownika na witrynach z ograniczeniami nałożonymi przez { -vendor-short-name(case: "acc") }.
webext-quarantine-confirmation-allow =
    .label = Zezwól
    .accesskey = Z
webext-quarantine-confirmation-deny =
    .label = Nie zezwalaj
    .accesskey = N
