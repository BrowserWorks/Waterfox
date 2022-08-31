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
about-addressbook-books-context-edit =
    .label = Szerkesztés
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
about-addressbook-sort-button2 =
    .title = Megjelenítési lehetőségek felsorolása
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
about-addressbook-horizontal-layout =
    .label = Váltás vízszintes elrendezésre
about-addressbook-vertical-layout =
    .label = Váltás függőleges elrendezésre

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Név
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = E-mail-címek
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = Telefonszámok
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = Címek
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = Cím
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = Részleg
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = Szervezet
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = Címjegyzék
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
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

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = Nem érhetők el névjegyek
about-addressbook-placeholder-new-contact = Új névjegy
about-addressbook-placeholder-search-only = Ez a címjegyzék csak keresés után jelenít meg névjegyeket
about-addressbook-placeholder-searching = Keresés…
about-addressbook-placeholder-no-search-results = Nem találhatók névjegyek

## Details

about-addressbook-prefer-display-name = Megjelenő név előnyben részesítése az üzenetfejlécben levő helyett
about-addressbook-write-action-button = Írás
about-addressbook-event-action-button = Esemény
about-addressbook-search-action-button = Keresés
about-addressbook-begin-edit-contact-button = Szerkesztés
about-addressbook-delete-edit-contact-button = Törlés
about-addressbook-cancel-edit-contact-button = Mégse
about-addressbook-save-edit-contact-button = Mentés
about-addressbook-add-contact-to = Hozzáadás:
about-addressbook-details-email-addresses-header = E-mail-címek
about-addressbook-details-phone-numbers-header = Telefonszámok
about-addressbook-details-addresses-header = Címek
about-addressbook-details-notes-header = Jegyzetek
about-addressbook-details-other-info-header = Egyéb információk
about-addressbook-entry-type-work = Munkahelyi
about-addressbook-entry-type-home = Otthoni
about-addressbook-entry-type-fax = Fax
about-addressbook-entry-type-cell = Mobil
about-addressbook-entry-type-pager = Személyhívó
about-addressbook-entry-name-birthday = Születésnap
about-addressbook-entry-name-anniversary = Évforduló
about-addressbook-entry-name-title = Cím
about-addressbook-entry-name-role = Szerep
about-addressbook-entry-name-organization = Szervezet
about-addressbook-entry-name-website = Webhely
about-addressbook-entry-name-time-zone = Időzóna
about-addressbook-unsaved-changes-prompt-title = Nem mentett módosítások
about-addressbook-unsaved-changes-prompt = Menti a módosításokat, mielőtt kilép a szerkesztési nézetből?

# Photo dialog

about-addressbook-photo-drop-target = Húzzon vagy illesszen be egy fényképet ide, vagy kattintson a fájl kiválasztásához.
about-addressbook-photo-drop-loading = Fénykép betöltése…
about-addressbook-photo-drop-error = A fénykép betöltése sikertelen.
about-addressbook-photo-filepicker-title = Válasszon egy képfájlt
about-addressbook-photo-discard = Meglévő fénykép elvetése
about-addressbook-photo-cancel = Mégse
about-addressbook-photo-save = Mentés
