# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Libreta de direcciones

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Nueva libreta de direcciones
about-addressbook-toolbar-add-carddav-address-book =
    .label = Añadir libreta de direcciones CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Añadir libreta de direcciones LDAP
about-addressbook-toolbar-new-contact =
    .label = Nuevo contacto
about-addressbook-toolbar-new-list =
    .label = Nueva lista
about-addressbook-toolbar-import =
    .label = Importar

## Books

all-address-books = Todas las libretas de direcciones
about-addressbook-books-context-properties =
    .label = Propiedades
about-addressbook-books-context-synchronize =
    .label = Sincronizar
about-addressbook-books-context-edit =
    .label = Editar
about-addressbook-books-context-print =
    .label = Imprimir...
about-addressbook-books-context-export =
    .label = Exportar...
about-addressbook-books-context-delete =
    .label = Eliminar
about-addressbook-books-context-remove =
    .label = Eliminar
about-addressbook-books-context-startup-default =
    .label = Directorio de inicio predeterminado
about-addressbook-confirm-delete-book-title = Eliminar libreta de direcciones
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = ¿Está seguro de que desea eliminar { $name } y todos sus contactos?
about-addressbook-confirm-remove-remote-book-title = Eliminar libreta de direcciones
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = ¿Está seguro de que desea eliminar { $name }?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Buscar en { $name }
about-addressbook-search-all =
    .placeholder = Buscar en todas las libretas de direcciones
about-addressbook-sort-button2 =
    .title = Opciones de visualización de la lista
about-addressbook-name-format-display =
    .label = Nombre para mostrar
about-addressbook-name-format-firstlast =
    .label = Nombre y apellidos
about-addressbook-name-format-lastfirst =
    .label = Apellidos, nombre
about-addressbook-sort-name-ascending =
    .label = Ordenar por nombre (A > Z)
about-addressbook-sort-name-descending =
    .label = Ordenar por nombre (Z > A)
about-addressbook-sort-email-ascending =
    .label = Ordenar por dirección de correo electrónico (A > Z)
about-addressbook-sort-email-descending =
    .label = Ordenar por dirección de correo electrónico (Z > A)
about-addressbook-horizontal-layout =
    .label = Cambiar a disposición horizontal
about-addressbook-vertical-layout =
    .label = Cambiar a disposición vertical

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Nombre
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = Direcciones de correo electrónico
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = Números de teléfono
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = Direcciones
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = Cargo
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = Departamento
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = Organización
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = Libreta de direcciones
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
about-addressbook-cards-context-write =
    .label = Escribir
about-addressbook-confirm-delete-mixed-title = Eliminar contactos y listas
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = ¿Está seguro de que desea eliminar estos { $count } contactos y listas?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Eliminar lista
       *[other] Eliminar listas
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] ¿Está seguro de que desea eliminar la lista { $name }?
       *[other] ¿Está seguro de que desea eliminar estas { $count } listas?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Eliminar contacto
       *[other] Eliminar contactos
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] ¿Está seguro de que desea eliminar a { $name } de { $list }?
       *[other] ¿Está seguro de que desea eliminar estos { $count } contactos de { $list }?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Eliminar contacto
       *[other] Eliminar contactos
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] ¿Está seguro de que desea eliminar el contacto { $name }?
       *[other] ¿Está seguro de que desea eliminar estos { $count } contactos?
    }

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = No hay contactos disponibles
about-addressbook-placeholder-new-contact = Nuevo contacto
about-addressbook-placeholder-search-only = Esta libreta de direcciones sólo muestra los contactos después de una búsqueda
about-addressbook-placeholder-searching = Buscando…
about-addressbook-placeholder-no-search-results = No se encontraron contactos

## Details

about-addressbook-prefer-display-name = Preferir el nombre mostrado al de la cabecera del mensaje
about-addressbook-write-action-button = Escribir
about-addressbook-event-action-button = Evento
about-addressbook-search-action-button = Buscar
about-addressbook-begin-edit-contact-button = Editar
about-addressbook-delete-edit-contact-button = Eliminar
about-addressbook-cancel-edit-contact-button = Cancelar
about-addressbook-save-edit-contact-button = Guardar
about-addressbook-add-contact-to = Añadir a:
about-addressbook-details-email-addresses-header = Direcciones de correo electrónico
about-addressbook-details-phone-numbers-header = Números de teléfono
about-addressbook-details-addresses-header = Direcciones
about-addressbook-details-notes-header = Notas
about-addressbook-details-other-info-header = Otra información
about-addressbook-entry-type-work = Trabajo
about-addressbook-entry-type-home = Casa
about-addressbook-entry-type-fax = Fax
about-addressbook-entry-type-cell = Teléfono móvil
about-addressbook-entry-type-pager = Buscapersonas
about-addressbook-entry-name-birthday = Cumpleaños
about-addressbook-entry-name-anniversary = Aniversario
about-addressbook-entry-name-title = Título
about-addressbook-entry-name-role = Rol
about-addressbook-entry-name-organization = Organización
about-addressbook-entry-name-website = Página web
about-addressbook-entry-name-time-zone = Zona horaria
about-addressbook-unsaved-changes-prompt-title = Cambios sin guardar
about-addressbook-unsaved-changes-prompt = ¿Desea guardar los cambios antes de salir de la vista de edición?

# Photo dialog

about-addressbook-photo-drop-target = Suelte o pegue una foto aquí, o haga clic para seleccionar un archivo.
about-addressbook-photo-drop-loading = Cargando foto…
about-addressbook-photo-drop-error = No se ha podido cargar la foto.
about-addressbook-photo-filepicker-title = Seleccionar un archivo de imagen
about-addressbook-photo-discard = Descartar la foto existente
about-addressbook-photo-cancel = Cancelar
about-addressbook-photo-save = Guardar
