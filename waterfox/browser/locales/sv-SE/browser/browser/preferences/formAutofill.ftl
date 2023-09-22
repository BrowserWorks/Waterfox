# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Sparade adresser
autofill-manage-addresses-list-header = Adresser

autofill-manage-credit-cards-title = Sparade kreditkort
autofill-manage-credit-cards-list-header = Kreditkort

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = Ta bort
autofill-manage-add-button = Lägg till…
autofill-manage-edit-button = Redigera…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Lägg till ny adress
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Redigera adress

autofill-address-given-name = Förnamn
autofill-address-additional-name = Mellannamn
autofill-address-family-name = Efternamn
autofill-address-organization = Organisation
autofill-address-street = Gatuadress

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Grannskap
# Used in MY
autofill-address-village-township = Samhälle eller stadsdel
autofill-address-island = Ö
# Used in IE
autofill-address-townland = Bygd

## address-level-2 names

autofill-address-city = Ort
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = Distrikt
# Used in GB, NO, SE
autofill-address-post-town = Postort
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Förort

## address-level-1 names

autofill-address-province = Län
autofill-address-state = Region
autofill-address-county = Grevskap
# Used in BB, JM
autofill-address-parish = Socken
# Used in JP
autofill-address-prefecture = Prefektur
# Used in HK
autofill-address-area = Yta
# Used in KR
autofill-address-do-si = Do/Si
# Used in NI, CO
autofill-address-department = Avdelning
# Used in AE
autofill-address-emirate = Emirat
# Used in RU and UA
autofill-address-oblast = Oblast

## Postal code name types

# Used in IN
autofill-address-pin = Pin
autofill-address-postal-code = Postnummer
autofill-address-zip = Postnummer
# Used in IE
autofill-address-eircode = Eircode

##

autofill-address-country = Land eller region
autofill-address-tel = Telefon
autofill-address-email = E-post

autofill-cancel-button = Avbryt
autofill-save-button = Spara
autofill-country-warning-message = Autofyll av formulär är för närvarande endast tillgänglig för vissa länder.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Lägg till nytt kreditkort
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Redigera kreditkort

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] visa kreditkortsinformation
        [windows] { -brand-short-name } försöker visa kreditkortsinformation. Bekräfta åtkomst till detta Windows-konto nedan.
       *[other] { -brand-short-name } försöker visa kreditkortsinformation.
    }

autofill-card-number = Kortnummer
autofill-card-invalid-number = Ange ett giltigt kortnummer
autofill-card-name-on-card = Namn på kort
autofill-card-expires-month = Utg. månad
autofill-card-expires-year = Utg. år
autofill-card-billing-address = Fakturaadress
autofill-card-network = Korttyp

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
