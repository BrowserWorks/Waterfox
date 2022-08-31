# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Livro de endereços

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Novo livro de endereços
about-addressbook-toolbar-add-carddav-address-book =
    .label = Adicionar livro de endereços CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Adicionar livro de endereços LDAP
about-addressbook-toolbar-new-contact =
    .label = Novo contacto
about-addressbook-toolbar-new-list =
    .label = Nova lista
about-addressbook-toolbar-import =
    .label = Importar

## Books

all-address-books = Todos os livros de endereços
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
    .label = Apagar
about-addressbook-books-context-remove =
    .label = Remover
about-addressbook-books-context-startup-default =
    .label = Diretório de arranque predefinido
about-addressbook-confirm-delete-book-title = Apagar livro de endereços
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Tem a certeza que pretende eliminar { $name } e todos os respetivos contactos?
about-addressbook-confirm-remove-remote-book-title = Remover livro de endereços
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Tem a certeza que pretende remover { $name }?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Pesquisar { $name }
about-addressbook-search-all =
    .placeholder = Pesquisar todos os livros de endereços
about-addressbook-sort-button2 =
    .title = Listar opções de apresentação
about-addressbook-name-format-display =
    .label = Nome de apresentação
about-addressbook-name-format-firstlast =
    .label = Primeiro Último
about-addressbook-name-format-lastfirst =
    .label = Último, Primeiro
about-addressbook-sort-name-ascending =
    .label = Ordenar por nome (A > Z)
about-addressbook-sort-name-descending =
    .label = Ordenar por nome (Z > A)
about-addressbook-sort-email-ascending =
    .label = Ordenar por endereço de e-mail (A > Z)
about-addressbook-sort-email-descending =
    .label = Ordenar por endereço de e-mail (Z > A)
about-addressbook-horizontal-layout =
    .label = Mudar para vista horizontal
about-addressbook-vertical-layout =
    .label = Mudar para vista vertical

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Nome
about-addressbook-column-header-emailaddresses = Endereços de e-mail
about-addressbook-column-header-phonenumbers = Números de Telefone
about-addressbook-column-header-addresses = Endereços
about-addressbook-column-header-title = Título
about-addressbook-column-header-department = Departamento
about-addressbook-column-header-organization = Organização
about-addressbook-column-header-addrbook = Livro de endereços
about-addressbook-cards-context-write =
    .label = Escrever
about-addressbook-confirm-delete-mixed-title = Apagar contactos e listas
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = Tem a certeza de que pretende apagar estes { $count } contactos e listas?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Apagar lista
       *[other] Apagar listas
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Tem certeza que pretende apagar a lista { $name }?
       *[other] Tem certeza que pretende apagar estas { $count } listas?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Remover contacto
       *[other] Remover contactos
    }

## Card list placeholder
## Shown when there are no cards in the list


## Details


# Photo dialog

