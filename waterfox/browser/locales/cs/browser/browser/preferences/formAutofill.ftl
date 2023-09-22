# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Uložené adresy
autofill-manage-addresses-list-header = Adresy

autofill-manage-credit-cards-title = Uložené platební karty
autofill-manage-credit-cards-list-header = Platební karty

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = Odstranit
autofill-manage-add-button = Přidat…
autofill-manage-edit-button = Upravit…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Přidat novou adresu
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Upravit adresu

autofill-address-given-name = Křestní jméno
autofill-address-additional-name = Prostřední jméno
autofill-address-family-name = Příjmení
autofill-address-organization = Společnost
autofill-address-street = Ulice

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Sousedství
# Used in MY
autofill-address-village-township = Obec nebo okres
autofill-address-island = Ostrov
# Used in IE
autofill-address-townland = Město

## address-level-2 names

autofill-address-city = Město
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = Okres
# Used in GB, NO, SE
autofill-address-post-town = Pošta - město
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Předměstí

## address-level-1 names

autofill-address-province = Kraj
autofill-address-state = Země
autofill-address-county = Okres
# Used in BB, JM
autofill-address-parish = Farnost
# Used in JP
autofill-address-prefecture = Prefektura
# Used in HK
autofill-address-area = Oblast
# Used in KR
autofill-address-do-si = Do/Si
# Used in NI, CO
autofill-address-department = Oblast
# Used in AE
autofill-address-emirate = Emirát
# Used in RU and UA
autofill-address-oblast = Oblast

## Postal code name types

# Used in IN
autofill-address-pin = Pin
autofill-address-postal-code = PSČ
autofill-address-zip = PSČ
# Used in IE
autofill-address-eircode = Eircode

##

autofill-address-country = Země nebo oblast
autofill-address-tel = Telefon
autofill-address-email = E-mailová adresa

autofill-cancel-button = Zrušit
autofill-save-button = Uložit
autofill-country-warning-message = Automatické vyplňování formulářů nyní funguje jenom pro některé země.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Přidat novou platební kartu
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Upravit informace o platební kartě

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] zobrazit informace o platební kartě
        [windows] { -brand-short-name } chce zobrazit informace o platební kartě. Potvrďte prosím přístup k níže uvedenému účtu Windows.
       *[other] { -brand-short-name } chce zobrazit informace o platební kartě.
    }

autofill-card-number = Číslo karty
autofill-card-invalid-number = Zadejte prosím platné číslo platební karty
autofill-card-name-on-card = Jméno na kartě
autofill-card-expires-month = Měsíc expirace
autofill-card-expires-year = Rok expirace
autofill-card-billing-address = Fakturační adresa
autofill-card-network = Typ karty

## These are brand names and should only be translated when a locale-specific name for that brand is in common use

autofill-card-network-amex = American Express
autofill-card-network-cartebancaire = Carte Bancaire
autofill-card-network-diners = Diners Club
autofill-card-network-discover = Discover
autofill-card-network-jcb = JCB
autofill-card-network-mastercard = MasterCard
autofill-card-network-mir = MIR
autofill-card-network-unionpay = Union Pay
autofill-card-network-visa = Visa
