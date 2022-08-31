# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Catálogo de endereços

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Novo catálogo de endereços
about-addressbook-toolbar-add-carddav-address-book =
    .label = Adicionar catálogo de endereços CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Adicionar catálogo de endereços LDAP
about-addressbook-toolbar-new-contact =
    .label = Novo contato
about-addressbook-toolbar-new-list =
    .label = Nova lista
about-addressbook-toolbar-import =
    .label = Importar

## Books

all-address-books = Todos os catálogos de endereços
about-addressbook-books-context-properties =
    .label = Propriedades
about-addressbook-books-context-synchronize =
    .label = Sincronizar
about-addressbook-books-context-edit =
    .label = Editar
about-addressbook-books-context-print =
    .label = Imprimir…
about-addressbook-books-context-export =
    .label = Exportar…
about-addressbook-books-context-delete =
    .label = Excluir
about-addressbook-books-context-remove =
    .label = Remover
about-addressbook-books-context-startup-default =
    .label = Diretório de início padrão
about-addressbook-confirm-delete-book-title = Excluir catálogo de endereços
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Tem certeza que quer excluir { $name } e todo seu conteúdo?
about-addressbook-confirm-remove-remote-book-title = Remover catálogo de endereços
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Tem certeza que quer remover { $name }?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Pesquisar { $name }
about-addressbook-search-all =
    .placeholder = Pesquisar em todos os catálogos de endereços
about-addressbook-sort-button2 =
    .title = Opções da lista de exibição
about-addressbook-name-format-display =
    .label = Nome de exibição
about-addressbook-name-format-firstlast =
    .label = Primeiro Último
about-addressbook-name-format-lastfirst =
    .label = Último, Primeiro
about-addressbook-sort-name-ascending =
    .label = Ordenar por nome (A > Z)
about-addressbook-sort-name-descending =
    .label = Ordenar por nome (Z > A)
about-addressbook-sort-email-ascending =
    .label = Ordenar por endereço de email (A > Z)
about-addressbook-sort-email-descending =
    .label = Ordenar por endereço de email (Z > A)
about-addressbook-horizontal-layout =
    .label = Mudar para disposição horizontal
about-addressbook-vertical-layout =
    .label = Mudar para disposição vertical

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Nome
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = Endereços de email
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = Números de telefone
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = Endereços
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = Cargo
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = Departamento
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = Organização
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = Catálogo de endereços
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
about-addressbook-cards-context-write =
    .label = Escrever
about-addressbook-confirm-delete-mixed-title = Excluir contatos e listas
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = Tem certeza que quer excluir esses { $count } contatos e listas?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Excluir lista
       *[other] Excluir listas
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Tem certeza que quer excluir a lista { $name }?
       *[other] Tem certeza que quer excluir essas { $count } listas?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Remover contato
       *[other] Remover contatos
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] Tem certeza que quer remover { $name } de { $list }?
       *[other] Tem certeza que quer remover esses { $count } contatos de { $list }?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Excluir contato
       *[other] Excluir contatos
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] Tem certeza que quer excluir o contato { $name }?
       *[other] Tem certeza que quer excluir esses { $count } contatos?
    }

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = Nenhum contato disponível
about-addressbook-placeholder-new-contact = Novo contato
about-addressbook-placeholder-search-only = Este catálogo de endereços só mostra contatos após uma pesquisa
about-addressbook-placeholder-searching = Procurando…
about-addressbook-placeholder-no-search-results = Nenhum contato encontrado

## Details

about-addressbook-prefer-display-name = Preferir nome de exibição ao cabeçalho da mensagem
about-addressbook-write-action-button = Escrever
about-addressbook-event-action-button = Evento
about-addressbook-search-action-button = Pesquisar
about-addressbook-begin-edit-contact-button = Editar
about-addressbook-delete-edit-contact-button = Excluir
about-addressbook-cancel-edit-contact-button = Cancelar
about-addressbook-save-edit-contact-button = Salvar
about-addressbook-add-contact-to = Adicionar a:
about-addressbook-details-email-addresses-header = Endereços de email
about-addressbook-details-phone-numbers-header = Números de telefone
about-addressbook-details-addresses-header = Endereços
about-addressbook-details-notes-header = Notas
about-addressbook-details-other-info-header = Outras informações
about-addressbook-entry-type-work = Trabalho
about-addressbook-entry-type-home = Casa
about-addressbook-entry-type-fax = Fax
about-addressbook-entry-type-cell = Celular
about-addressbook-entry-type-pager = Pager
about-addressbook-entry-name-birthday = Data de nascimento
about-addressbook-entry-name-anniversary = Aniversário
about-addressbook-entry-name-title = Título
about-addressbook-entry-name-role = Função
about-addressbook-entry-name-organization = Organização
about-addressbook-entry-name-website = Site
about-addressbook-entry-name-time-zone = Fuso horário
about-addressbook-unsaved-changes-prompt-title = Alterações não salvas
about-addressbook-unsaved-changes-prompt = Quer salvar suas alterações antes de sair do modo de edição?

# Photo dialog

about-addressbook-photo-drop-target = Arraste ou cole uma foto aqui, ou clique para selecionar um arquivo.
about-addressbook-photo-drop-loading = Carregando foto…
about-addressbook-photo-drop-error = Falha ao carregar foto.
about-addressbook-photo-filepicker-title = Selecionar arquivo de imagem
about-addressbook-photo-discard = Descartar foto existente
about-addressbook-photo-cancel = Cancelar
about-addressbook-photo-save = Salvar
