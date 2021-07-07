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
about-addressbook-sort-button =
    .title = Change the list order
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

## Details

about-addressbook-begin-edit-contact-button = Edit
about-addressbook-cancel-edit-contact-button = Cancel
about-addressbook-save-edit-contact-button = Save
about-addressbook-details-email-addresses-header = Email Addresses
about-addressbook-details-phone-numbers-header = Phone Numbers
about-addressbook-details-home-address-header = Home Address
about-addressbook-details-work-address-header = Work Address
about-addressbook-details-other-info-header = Other Information
about-addressbook-prompt-to-save-title = Save Changes?
about-addressbook-prompt-to-save = Do you want to save your changes?
