# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Zachowane adresy
autofill-manage-addresses-list-header = Adresy

autofill-manage-credit-cards-title = Zachowane dane kart
autofill-manage-credit-cards-list-header = Karty

autofill-manage-dialog =
    .style = min-width: 600px
autofill-manage-remove-button = Usuń
autofill-manage-add-button = Dodaj…
autofill-manage-edit-button = Edytuj…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Nowy adres
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Edycja adresu

autofill-address-given-name = Imię
autofill-address-additional-name = Drugie imię
autofill-address-family-name = Nazwisko
autofill-address-organization = Organizacja
autofill-address-street = Adres

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Neighborhood
# Used in MY
autofill-address-village-township = Wioska lub township
autofill-address-island = Wyspa
# Used in IE
autofill-address-townland = Townland

## address-level-2 names

autofill-address-city = Miasto
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = Dystrykt
# Used in GB, NO, SE
autofill-address-post-town = Post town
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Suburb

## address-level-1 names

autofill-address-province = Prowincja
autofill-address-state = Stan
autofill-address-county = Hrabstwo
# Used in BB, JM
autofill-address-parish = Parish
# Used in JP
autofill-address-prefecture = Prefektura
# Used in HK
autofill-address-area = Obszar
# Used in KR
autofill-address-do-si = Do/Si
# Used in NI, CO
autofill-address-department = Departament
# Used in AE
autofill-address-emirate = Emirat
# Used in RU and UA
autofill-address-oblast = Obwód

## Postal code name types

# Used in IN
autofill-address-pin = Pin
autofill-address-postal-code = Kod pocztowy
autofill-address-zip = Kod ZIP
# Used in IE
autofill-address-eircode = Eircode

##

autofill-address-country = Państwo lub region
autofill-address-tel = Telefon
autofill-address-email = E-mail

autofill-cancel-button = Anuluj
autofill-save-button = Zachowaj
autofill-country-warning-message = Wypełnianie formularzy jest obecnie dostępne tylko w wybranych krajach.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Dodawanie nowej karty płatniczej
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Edycja danych karty płatniczej

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] dostęp do informacji o kartach płatniczych
        [windows] { -brand-short-name } chce uzyskać dostęp do informacji o kartach płatniczych. Potwierdź poniżej używając konta Windows.
       *[other] { -brand-short-name } chce uzyskać dostęp do informacji o kartach płatniczych.
    }

autofill-card-number = Numer
autofill-card-invalid-number = Proszę wprowadzić prawidłowy numer karty
autofill-card-name-on-card = Imię i nazwisko
autofill-card-expires-month = miesiąc
autofill-card-expires-year = rok
autofill-card-billing-address = Adres na fakturze
autofill-card-network = Wystawca karty

## These are brand names and should only be translated when a locale-specific name for that brand is in common use

autofill-card-network-amex = American Express
autofill-card-network-cartebancaire = Carte Bancaire
autofill-card-network-diners = Diners Club
autofill-card-network-discover = Discover
autofill-card-network-jcb = JCB
autofill-card-network-mastercard = Mastercard
autofill-card-network-mir = MIR
autofill-card-network-unionpay = Union Pay
autofill-card-network-visa = Visa
