# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = Abrir
    .accesskey = A
places-open-in-tab =
    .label = Abrir num novo separador
    .accesskey = v
places-open-all-bookmarks =
    .label = Abrir todos os marcadores
    .accesskey = b
places-open-all-in-tabs =
    .label = Abrir tudo em separadores
    .accesskey = o
places-open-in-window =
    .label = Abrir numa nova janela
    .accesskey = j
places-open-in-private-window =
    .label = Abrir numa nova janela privada
    .accesskey = p
places-add-bookmark =
    .label = Adicionar marcador…
    .accesskey = m
places-add-folder-contextmenu =
    .label = Adicionar pasta…
    .accesskey = s
places-add-folder =
    .label = Adicionar pasta…
    .accesskey = s
places-add-separator =
    .label = Adicionar separador
    .accesskey = s
places-view =
    .label = Ver
    .accesskey = V
places-by-date =
    .label = Por data
    .accesskey = d
places-by-site =
    .label = Por site
    .accesskey = s
places-by-most-visited =
    .label = Por mais visitados
    .accesskey = v
places-by-last-visited =
    .label = Por última visita
    .accesskey = l
places-by-day-and-site =
    .label = Por data e site
    .accesskey = t
places-history-search =
    .placeholder = Pesquisar histórico
places-history =
    .aria-label = Histórico
places-bookmarks-search =
    .placeholder = Pesquisar marcadores
places-delete-domain-data =
    .label = Esquecer este site
    .accesskey = s
places-sortby-name =
    .label = Ordenar por nome
    .accesskey = r
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = Editar marcador…
    .accesskey = i
places-edit-generic =
    .label = Editar…
    .accesskey = i
places-edit-folder =
    .label = Renomear pasta…
    .accesskey = e
places-remove-folder =
    .label =
        { $count ->
            [1] Remover pasta
           *[other] Remover pastas
        }
    .accesskey = m
places-edit-folder2 =
    .label = Editar pasta…
    .accesskey = i
places-delete-folder =
    .label =
        { $count ->
            [1] Eliminar pasta
           *[other] Eliminar pastas
        }
    .accesskey = l
# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = Marcadores administrativos
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = Subpasta
# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = Outros marcadores
# Variables:
# $count (number) - The number of elements being selected for removal.
places-remove-bookmark =
    .label =
        { $count ->
            [1] Remover marcador
            [one] Remover marcador
           *[other] Remover marcadores
        }
    .accesskey = e
places-show-in-folder =
    .label = Mostrar na pasta
    .accesskey = M
# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] Eliminar marcador
           *[other] Eliminar marcadores
        }
    .accesskey = l
places-manage-bookmarks =
    .label = Gerir marcadores
    .accesskey = m
places-forget-about-this-site-confirmation-title = Esquecer este site
# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-message = Esta ação irá remover todos os dados relativos a { $hostOrBaseDomain } incluindo histórico, palavras-passe, cookies, cache e preferências de conteúdo. Tem a certeza que pretende continuar?
places-forget-about-this-site-forget = Esquecer
places-library =
    .title = Biblioteca
    .style = width:700px; height:500px;
places-organize-button =
    .label = Organizar
    .tooltiptext = Organize os seus marcadores
    .accesskey = O
places-organize-button-mac =
    .label = Organizar
    .tooltiptext = Organize os seus marcadores
places-file-close =
    .label = Fechar
    .accesskey = e
places-cmd-close =
    .key = w
places-view-button =
    .label = Vistas
    .tooltiptext = Altere a sua vista
    .accesskey = V
places-view-button-mac =
    .label = Vistas
    .tooltiptext = Altere a sua vista
places-view-menu-columns =
    .label = Mostrar colunas
    .accesskey = c
places-view-menu-sort =
    .label = Ordenar
    .accesskey = O
places-view-sort-unsorted =
    .label = Não ordenados
    .accesskey = N
places-view-sort-ascending =
    .label = Ordem A - Z
    .accesskey = A
places-view-sort-descending =
    .label = Ordem Z - A
    .accesskey = Z
places-maintenance-button =
    .label = Importar e criar cópia de segurança
    .tooltiptext = Importar e criar cópia de segurança dos seus marcadores
    .accesskey = I
places-maintenance-button-mac =
    .label = Importar e criar cópia de segurança
    .tooltiptext = Importar e criar cópia de segurança dos seus marcadores
places-cmd-backup =
    .label = Cópia de segurança…
    .accesskey = C
places-cmd-restore =
    .label = Restaurar
    .accesskey = R
places-cmd-restore-from-file =
    .label = Escolher ficheiro…
    .accesskey = c
places-import-bookmarks-from-html =
    .label = Importar marcadores a partir de HTML…
    .accesskey = I
places-export-bookmarks-to-html =
    .label = Exportar marcadores para HTML…
    .accesskey = E
places-import-other-browser =
    .label = Importar dados de outro navegador…
    .accesskey = a
places-view-sort-col-name =
    .label = Nome
places-view-sort-col-tags =
    .label = Etiquetas
places-view-sort-col-url =
    .label = Localização
places-view-sort-col-most-recent-visit =
    .label = Visita mais recente
places-view-sort-col-visit-count =
    .label = Número de visitas
places-view-sort-col-date-added =
    .label = Adicionado
places-view-sort-col-last-modified =
    .label = Última modificação
places-cmd-find-key =
    .key = f
places-back-button =
    .tooltiptext = Retroceder
places-forward-button =
    .tooltiptext = Avançar
places-details-pane-select-an-item-description = Selecione um item para ver e editar as suas propriedades
