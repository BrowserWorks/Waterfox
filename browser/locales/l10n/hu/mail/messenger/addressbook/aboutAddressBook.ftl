# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Címjegyzék

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Új címjegyzék
about-addressbook-toolbar-add-carddav-address-book =
    .label = CardDAV-címjegyzék hozzáadása
about-addressbook-toolbar-add-ldap-address-book =
    .label = LDAP-címjegyzék hozzáadása
about-addressbook-toolbar-new-contact =
    .label = Új névjegy
about-addressbook-toolbar-new-list =
    .label = Új lista
about-addressbook-toolbar-import =
    .label = Importálás

## Books

all-address-books = Minden címjegyzék
about-addressbook-books-context-properties =
    .label = Tulajdonságok
about-addressbook-books-context-synchronize =
    .label = Szinkronizálás
about-addressbook-books-context-print =
    .label = Nyomtatás…
about-addressbook-books-context-export =
    .label = Exportálás…
about-addressbook-books-context-delete =
    .label = Törlés
about-addressbook-books-context-remove =
    .label = Eltávolítás
about-addressbook-books-context-startup-default =
    .label = Alapértelmezett indulási könyvtár
about-addressbook-confirm-delete-book-title = Címjegyzék törlése
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Biztos, hogy törli a(z) { $name } címjegyzéket és a tartalmát?
about-addressbook-confirm-remove-remote-book-title = Címjegyzék eltávolítása
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Biztos, hogy törli a(z) { $name } címjegyzéket?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Keresés ebben: { $name }
about-addressbook-search-all =
    .placeholder = Keresés az összes címjegyzékben
about-addressbook-sort-button =
    .title = A lista sorrendjének módosítása
about-addressbook-name-format-display =
    .label = Megjelenő név
about-addressbook-name-format-firstlast =
    .label = Utónév, vezetéknév
about-addressbook-name-format-lastfirst =
    .label = Vezetéknév, utónév
about-addressbook-sort-name-ascending =
    .label = Rendezés név szerint (A > Z)
about-addressbook-sort-name-descending =
    .label = Rendezés név szerint (Z > A)
about-addressbook-sort-email-ascending =
    .label = Rendezés e-mail-cím szerint (A > Z)
about-addressbook-sort-email-descending =
    .label = Rendezés e-mail-cím szerint (Z > A)
about-addressbook-cards-context-write =
    .label = Írás
about-addressbook-confirm-delete-mixed-title = Névjegyek és listák törlése
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = Biztos, hogy törli ezt a(z) { $count } névjegyet és listát?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Lista törlése
       *[other] Listák törlése
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Biztos, hogy törli a(z) { $name } listát?
       *[other] Biztos, hogy törli ezt a(z) { $count } listát?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Névjegy eltávolítása
       *[other] Névjegyek eltávolítása
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] Biztos, hogy eltávolítja a(z) { $name } névjegyet a(z) { $list } listáról?
       *[other] Biztos, hogy eltávolítja ezt a(z) { $count } névjegyet a(z) { $list } listáról?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Névjegy törlése
       *[other] Névjegyek törlése
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] Biztos, hogy törli a(z) { $name } névjegyet?
       *[other] Biztos, hogy törli ezt a(z) { $count } listát?
    }

## Details

about-addressbook-begin-edit-contact-button = Szerkesztés
about-addressbook-cancel-edit-contact-button = Mégse
about-addressbook-save-edit-contact-button = Mentés
about-addressbook-details-email-addresses-header = E-mail-címek
about-addressbook-details-phone-numbers-header = Telefonszámok
about-addressbook-details-home-address-header = Otthoni cím
about-addressbook-details-work-address-header = Munkahelyi cím
about-addressbook-details-other-info-header = Egyéb információk
about-addressbook-prompt-to-save-title = Menti a változtatásokat?
about-addressbook-prompt-to-save = Szeretné menteni a módosításokat?
