# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = En savoir plus
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = { $addonName } souhaite remplacer votre moteur de recherche par défaut { $currentEngine } par { $newEngine }. Cela vous convient-il ?
webext-default-search-yes =
    .label = Oui
    .accesskey = O
webext-default-search-no =
    .label = Non
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = { $addonName } a été ajouté.

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = Exécuter { $addonName } sur des sites restreints ?
webext-quarantine-confirmation-line-1 = Afin de protéger vos données, cette extension n’est pas autorisée sur ce site.
webext-quarantine-confirmation-line-2 = Autorisez cette extension si vous lui faites confiance pour lire et modifier vos données sur les sites restreints par { -vendor-short-name }.
webext-quarantine-confirmation-allow =
    .label = Autoriser
    .accesskey = A
webext-quarantine-confirmation-deny =
    .label = Ne pas autoriser
    .accesskey = N
