# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Catálogo de endereços

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Novo catálogo de endereços
about-addressbook-toolbar-new-carddav-address-book =
    .label = Novo catálogo de endereços CardDAV
about-addressbook-toolbar-new-ldap-address-book =
    .label = Novo catálogo de endereços LDAP
about-addressbook-toolbar-add-carddav-address-book =
    .label = Adicionar catálogo de endereços CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Adicionar catálogo de endereços LDAP
about-addressbook-toolbar-new-contact =
    .label = Novo contato
about-addressbook-toolbar-new-list =
    .label = Nova lista

## Books

all-address-books = Todos os catálogos de endereços
about-addressbook-books-context-properties =
    .label = Propriedades
about-addressbook-books-context-synchronize =
    .label = Sincronizar
about-addressbook-books-context-print =
    .label = Imprimir…
about-addressbook-books-context-delete =
    .label = Excluir
about-addressbook-books-context-remove =
    .label = Remover
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
about-addressbook-sort-button =
    .title = Alterar a ordem da lista
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

## Details

about-addressbook-begin-edit-contact-button = Editar
about-addressbook-cancel-edit-contact-button = Cancelar
about-addressbook-save-edit-contact-button = Salvar
about-addressbook-details-email-addresses-header = Endereços de email
about-addressbook-details-phone-numbers-header = Números de telefone
about-addressbook-details-home-address-header = Endereço residencial
about-addressbook-details-work-address-header = Endereço comercial
about-addressbook-details-other-info-header = Outras informações
