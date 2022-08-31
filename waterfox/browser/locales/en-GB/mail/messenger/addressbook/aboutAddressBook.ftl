# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Address Book

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = New Address Book
about-addressbook-toolbar-add-carddav-address-book =
    .label = Add CardDAV Address Book
about-addressbook-toolbar-add-ldap-address-book =
    .label = Add LDAP Address Book
about-addressbook-toolbar-new-contact =
    .label = New Contact
about-addressbook-toolbar-new-list =
    .label = New List
about-addressbook-toolbar-import =
    .label = Import

## Books

all-address-books = All Address Books
about-addressbook-books-context-properties =
    .label = Properties
about-addressbook-books-context-synchronize =
    .label = Synchronise
about-addressbook-books-context-edit =
    .label = Edit
about-addressbook-books-context-print =
    .label = Print…
about-addressbook-books-context-export =
    .label = Export…
about-addressbook-books-context-delete =
    .label = Delete
about-addressbook-books-context-remove =
    .label = Remove
about-addressbook-books-context-startup-default =
    .label = Default startup directory
about-addressbook-confirm-delete-book-title = Delete Address Book
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Are you sure you want to delete { $name } and all of its contacts?
about-addressbook-confirm-remove-remote-book-title = Remove Address Book
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Are you sure you want to remove { $name }?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Search { $name }
about-addressbook-search-all =
    .placeholder = Search all address books
about-addressbook-sort-button2 =
    .title = List display options
about-addressbook-name-format-display =
    .label = Display Name
about-addressbook-name-format-firstlast =
    .label = First Last
about-addressbook-name-format-lastfirst =
    .label = Last, First
about-addressbook-sort-name-ascending =
    .label = Sort by name (A > Z)
about-addressbook-sort-name-descending =
    .label = Sort by name (Z > A)
about-addressbook-sort-email-ascending =
    .label = Sort by e-mail address (A > Z)
about-addressbook-sort-email-descending =
    .label = Sort by e-mail address (Z > A)
about-addressbook-horizontal-layout =
    .label = Switch to horizontal layout
about-addressbook-vertical-layout =
    .label = Switch to vertical layout

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Name
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = Email Addresses
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = Phone Numbers
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = Addresses
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = Title
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = Department
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = Organisation
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = Address Book
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
about-addressbook-cards-context-write =
    .label = Write
about-addressbook-confirm-delete-mixed-title = Delete Contacts and Lists
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = Are you sure you want to delete these { $count } contacts and lists?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Delete List
       *[other] Delete Lists
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Are you sure you want to delete the list { $name }?
       *[other] Are you sure you want to delete these { $count } lists?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Remove Contact
       *[other] Remove Contacts
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] Are you sure you want to remove { $name } from { $list }?
       *[other] Are you sure you want to remove these { $count } contacts from { $list }?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Delete Contact
       *[other] Delete Contacts
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] Are you sure you want to delete the contact { $name }?
       *[other] Are you sure you want to delete these { $count } contacts?
    }

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = No contacts available
about-addressbook-placeholder-new-contact = New Contact
about-addressbook-placeholder-search-only = This address book shows contacts only after a search
about-addressbook-placeholder-searching = Searching…
about-addressbook-placeholder-no-search-results = No contacts found

## Details

about-addressbook-prefer-display-name = Prefer display name over message header
about-addressbook-write-action-button = Write
about-addressbook-event-action-button = Event
about-addressbook-search-action-button = Search
about-addressbook-begin-edit-contact-button = Edit
about-addressbook-delete-edit-contact-button = Delete
about-addressbook-cancel-edit-contact-button = Cancel
about-addressbook-save-edit-contact-button = Save
about-addressbook-add-contact-to = Add to:
about-addressbook-details-email-addresses-header = Email Addresses
about-addressbook-details-phone-numbers-header = Phone Numbers
about-addressbook-details-addresses-header = Addresses
about-addressbook-details-notes-header = Notes
about-addressbook-details-other-info-header = Other Information
about-addressbook-entry-type-work = Work
about-addressbook-entry-type-home = Home
about-addressbook-entry-type-fax = Fax
about-addressbook-entry-type-cell = Mobile
about-addressbook-entry-type-pager = Pager
about-addressbook-entry-name-birthday = Birthday
about-addressbook-entry-name-anniversary = Anniversary
about-addressbook-entry-name-title = Title
about-addressbook-entry-name-role = Role
about-addressbook-entry-name-organization = Organisation
about-addressbook-entry-name-website = Web site
about-addressbook-entry-name-time-zone = Time Zone
about-addressbook-unsaved-changes-prompt-title = Unsaved Changes
about-addressbook-unsaved-changes-prompt = Do you want to save your changes before leaving the edit view?

# Photo dialog

about-addressbook-photo-drop-target = Drop or paste a photo here, or click to select a file.
about-addressbook-photo-drop-loading = Loading photo…
about-addressbook-photo-drop-error = Failed to load photo.
about-addressbook-photo-filepicker-title = Select an image file
about-addressbook-photo-discard = Discard existing photo
about-addressbook-photo-cancel = Cancel
about-addressbook-photo-save = Save
