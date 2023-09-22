# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = Ulteriori informazioni

# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = { $addonName } vuole cambiare il motore di ricerca predefinito da { $currentEngine } a { $newEngine }. Consentire la modifica?
webext-default-search-yes =
    .label = Sì
    .accesskey = S
webext-default-search-no =
    .label = No
    .accesskey = N

# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = { $addonName } è stato installato.

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title =
    Eseguire { $addonName } in siti con restrizioni?

webext-quarantine-confirmation-line-1 =
    Per proteggere i tuoi dati, il funzionamento di questa estensione non è consentito in questo sito.
webext-quarantine-confirmation-line-2 =
    Consentire il funzionamento di questa estensione se si ritiene affidabile che possa leggere e
    modificare dati in siti con restrizioni identificati da { -vendor-short-name }.

webext-quarantine-confirmation-allow =
    .label = Consenti
    .accesskey = C

webext-quarantine-confirmation-deny =
    .label = Non consentire
    .accesskey = N

