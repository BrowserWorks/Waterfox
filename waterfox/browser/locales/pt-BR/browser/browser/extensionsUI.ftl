# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = Saiba mais
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = { $addonName } quer mudar seu mecanismo de pesquisa padrão de { $currentEngine } para { $newEngine }. Você autoriza?
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
webext-quarantine-confirmation-line-1 = Para proteger seus dados, esta extensão não é permitida neste site.
webext-quarantine-confirmation-line-2 = Permita esta extensão se você confiar nela para ler e alterar seus dados em sites restritos pela { -vendor-short-name }.
webext-quarantine-confirmation-allow =
    .label = Permitir
    .accesskey = P
webext-quarantine-confirmation-deny =
    .label = Não permitir
    .accesskey = N
