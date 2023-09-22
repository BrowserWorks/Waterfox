# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Gemte adresser
autofill-manage-addresses-list-header = Adresser

autofill-manage-credit-cards-title = Gemte betalingskort
autofill-manage-credit-cards-list-header = Betalingskort

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = Fjern
autofill-manage-add-button = Tilføj…
autofill-manage-edit-button = Rediger…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Tilføj ny adresse
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Rediger adresse

autofill-address-given-name = Fornavn
autofill-address-additional-name = Mellemnavn
autofill-address-family-name = Efternavn
autofill-address-organization = Organisation
autofill-address-street = Postadresse

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Neighborhood
# Used in MY
autofill-address-village-township = Village eller Township
autofill-address-island = Ø
# Used in IE
autofill-address-townland = Townland

## address-level-2 names

autofill-address-city = By
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = District
# Used in GB, NO, SE
autofill-address-post-town = Post town
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Suburb

## address-level-1 names

autofill-address-province = Område
autofill-address-state = Stat
autofill-address-county = County
# Used in BB, JM
autofill-address-parish = Parish
# Used in JP
autofill-address-prefecture = Prefecture
# Used in HK
autofill-address-area = Area
# Used in KR
autofill-address-do-si = Do/Si
# Used in NI, CO
autofill-address-department = Department
# Used in AE
autofill-address-emirate = Emirat
# Used in RU and UA
autofill-address-oblast = Oblast

## Postal code name types

# Used in IN
autofill-address-pin = Pin
autofill-address-postal-code = Postnummer
autofill-address-zip = Zip code
# Used in IE
autofill-address-eircode = Eircode

##

autofill-address-country = Land eller region
autofill-address-tel = Telefonnummer
autofill-address-email = Mailadresse

autofill-cancel-button = Fortryd
autofill-save-button = Gem
autofill-country-warning-message = Autoudfyldning af adresser er lige nu kun tilgængelig i udvalgte lande.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Tilføj nyt betalingskort
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Rediger betalingskort

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] vise informationer om betalingskort
        [windows] { -brand-short-name } forsøger at vise information om et betalingskort. Bekræft adgang til Windows-kontoen nedenfor.
       *[other] { -brand-short-name } forsøger at vise information om et betalingskort.
    }

autofill-card-number = Kortnummer
autofill-card-invalid-number = Angiv et gyldigt kortnummer
autofill-card-name-on-card = Navn på kort
autofill-card-expires-month = Udløbsmåned
autofill-card-expires-year = Udløbsår
autofill-card-billing-address = Faktureringsadresse
autofill-card-network = Type af kort

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
