# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = Abrir
    .accesskey = r
places-open-in-tab =
    .label = Abrir em nova aba
    .accesskey = v
places-open-in-container-tab =
    .label = Abrir em nova aba contêiner
    .accesskey = i
places-open-all-bookmarks =
    .label = Abrir todos os favoritos
    .accesskey = A
places-open-all-in-tabs =
    .label = Abrir tudo em abas
    .accesskey = A
places-open-in-window =
    .label = Abrir em nova janela
    .accesskey = n
places-open-in-private-window =
    .label = Abrir em nova janela privativa
    .accesskey = p

places-empty-bookmarks-folder =
    .label = (vazio)

places-add-bookmark =
    .label = Adicionar favorito…
    .accesskey = f
places-add-folder-contextmenu =
    .label = Adicionar pasta…
    .accesskey = p
places-add-folder =
    .label = Adicionar pasta…
    .accesskey = p
places-add-separator =
    .label = Adicionar separador
    .accesskey = s

places-view =
    .label = Exibir
    .accesskey = b
places-by-date =
    .label = Por data
    .accesskey = d
places-by-site =
    .label = Por site
    .accesskey = s
places-by-most-visited =
    .label = Por número de visitas
    .accesskey = n
places-by-last-visited =
    .label = Por último visitado
    .accesskey = v
places-by-day-and-site =
    .label = Por data e site
    .accesskey = e

places-history-search =
    .placeholder = Pesquisar no histórico
places-history =
    .aria-label = Histórico
places-bookmarks-search =
    .placeholder = Procurar favoritos

places-delete-domain-data =
    .label = Esquecer este site
    .accesskey = E
places-sortby-name =
    .label = Ordenar pelo nome
    .accesskey = d
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = Editar favorito…
    .accesskey = i
places-edit-generic =
    .label = Editar…
    .accesskey = i
places-edit-folder2 =
    .label = Editar pasta…
    .accesskey = i
places-delete-folder =
    .label =
        { $count ->
            [1] Excluir pasta
           *[other] Excluir pastas
        }
    .accesskey = x
# Variables:
#   $count (number) - The number of pages selected for removal.
places-delete-page =
    .label =
        { $count ->
            [1] Excluir página
           *[other] Excluir páginas
        }
    .accesskey = A

# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = Favoritos controlados
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = Subpasta

# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = Outros favoritos

places-show-in-folder =
    .label = Mostrar na pasta
    .accesskey = p

# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] Excluir favorito
           *[other] Excluir favoritos
        }
    .accesskey = x

# Variables:
#   $count (number) - The number of bookmarks being added.
places-create-bookmark =
    .label =
        { $count ->
            [1] Adicionar página aos favoritos…
           *[other] Adicionar páginas aos favoritos…
        }
    .accesskey = f

places-untag-bookmark =
    .label = Remover etiqueta
    .accesskey = R

places-manage-bookmarks =
    .label = Gerenciar favoritos
    .accesskey = G

places-forget-about-this-site-confirmation-title = Esquecer este site

# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-msg = Esta ação remove dados relacionados a { $hostOrBaseDomain }, incluindo histórico, cookies, cache e preferências de conteúdo. Favoritos e senhas relacionados não são removidos. Tem certeza que quer continuar?

places-forget-about-this-site-forget = Esquecer

places-library3 =
    .title = Biblioteca

places-organize-button =
    .label = Organizar
    .tooltiptext = Organizar favoritos
    .accesskey = O

places-organize-button-mac =
    .label = Organizar
    .tooltiptext = Organizar favoritos

places-file-close =
    .label = Fechar
    .accesskey = F

places-cmd-close =
    .key = w

places-view-button =
    .label = Exibição
    .tooltiptext = Alterar a exibição
    .accesskey = E

places-view-button-mac =
    .label = Exibição
    .tooltiptext = Alterar a exibição

places-view-menu-columns =
    .label = Exibir colunas
    .accesskey = c

places-view-menu-sort =
    .label = Ordenar
    .accesskey = O

places-view-sort-unsorted =
    .label = Não ordenado
    .accesskey = N

places-view-sort-ascending =
    .label = Ordem crescente
    .accesskey = c

places-view-sort-descending =
    .label = Ordem decrescente
    .accesskey = d

places-maintenance-button =
    .label = Importar e backup
    .tooltiptext = Importar e fazer backup dos favoritos
    .accesskey = I

places-maintenance-button-mac =
    .label = Importar e backup
    .tooltiptext = Importar e fazer backup dos favoritos

places-cmd-backup =
    .label = Backup…
    .accesskey = B

places-cmd-restore =
    .label = Restaurar
    .accesskey = R

places-cmd-restore-from-file =
    .label = Selecionar arquivo…
    .accesskey = S

places-import-bookmarks-from-html =
    .label = Importar favoritos de HTML…
    .accesskey = I

places-export-bookmarks-to-html =
    .label = Exportar favoritos para HTML…
    .accesskey = E

places-import-other-browser =
    .label = Importar dados de outro navegador…
    .accesskey = m

places-view-sort-col-name =
    .label = Nome

places-view-sort-col-tags =
    .label = Etiquetas

places-view-sort-col-url =
    .label = Local

places-view-sort-col-most-recent-visit =
    .label = Visita mais recente

places-view-sort-col-visit-count =
    .label = Número de visitas

places-view-sort-col-date-added =
    .label = Adicionado em

places-view-sort-col-last-modified =
    .label = Última modificação

places-view-sortby-name =
    .label = Ordenar por nome
    .accesskey = n
places-view-sortby-url =
    .label = Ordenar por localização
    .accesskey = l
places-view-sortby-date =
    .label = Ordenar por visitados mais recentemente
    .accesskey = c
places-view-sortby-visit-count =
    .label = Ordenar por número de visitas
    .accesskey = v
places-view-sortby-date-added =
    .label = Ordenar por data
    .accesskey = a
places-view-sortby-last-modified =
    .label = Ordenar por data de modificação
    .accesskey = m
places-view-sortby-tags =
    .label = Ordenar por etiquetas
    .accesskey = t

places-cmd-find-key =
    .key = F

places-back-button =
    .tooltiptext = Voltar

places-forward-button =
    .tooltiptext = Avançar

places-details-pane-select-an-item-description = Selecione um item para ver e editar suas propriedades

places-details-pane-no-items =
    .value = Nenhum item
# Variables:
#   $count (Number): number of items
places-details-pane-items-count =
    .value =
        { $count ->
            [one] Um item
           *[other] { $count } itens
        }

## Strings used as a placeholder in the Library search field. For example,
## "Search History" stands for "Search through the browser's history".

places-search-bookmarks =
    .placeholder = Procurar favoritos
places-search-history =
    .placeholder = Procurar no histórico
places-search-downloads =
    .placeholder = Procurar nos downloads

##

places-locked-prompt = O sistema de favoritos e histórico não funcionará agora porque um dos arquivos do { -brand-short-name } está sendo usado por outra aplicação. Alguns softwares de segurança podem causar este problema.
