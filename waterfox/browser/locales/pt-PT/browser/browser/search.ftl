# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Erro de instalação
opensearch-error-duplicate-desc = O { -brand-short-name } não pôde instalar o plugin de pesquisa de “{ $location-url }” porque já existe um motor com o mesmo nome.

opensearch-error-format-title = Formato inválido
opensearch-error-format-desc = O { -brand-short-name } não pôde instalar o motor de pesquisa de: { $location-url }

opensearch-error-download-title = Erro ao transferir
opensearch-error-download-desc = O { -brand-short-name } não conseguiu transferir o plug-in de pesquisa de: { $location-url }

##

searchbar-submit =
    .tooltiptext = Submeter pesquisa

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = Pesquisar

searchbar-icon =
    .tooltiptext = Pesquisa

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>O seu motor de pesquisa padrão foi alterado.</strong> O { $oldEngine } não está mais disponível como motor de pesquisa padrão no { -brand-short-name }. O { $newEngine } é agora o seu motor de pesquisa padrão. Para mudar para outro motor de pesquisa padrão, vá às configurações. <label data-l10n-name="remove-search-engine-article">Saiba mais</label>
remove-search-engine-button = OK
