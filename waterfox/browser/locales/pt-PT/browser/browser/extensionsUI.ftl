# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = Saber mais
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = { $addonName } gostaria de alterar o seu motor de pesquisa predefinido de { $currentEngine } para { $newEngine }. Está bem?
webext-default-search-yes =
    .label = Sim
    .accesskey = S
webext-default-search-no =
    .label = Não
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = { $addonName } foi adicionado.

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = Executar { $addonName } em sites restritos?
webext-quarantine-confirmation-line-1 = Para proteger os seus dados, esta extensão não é permitida neste site.
webext-quarantine-confirmation-line-2 = Permita esta extensão se confia na mesma para ler e alterar os seus dados em sites restritos por { -vendor-short-name }.
webext-quarantine-confirmation-allow =
    .label = Permitir
    .accesskey = P
webext-quarantine-confirmation-deny =
    .label = Não permitir
    .accesskey = N
