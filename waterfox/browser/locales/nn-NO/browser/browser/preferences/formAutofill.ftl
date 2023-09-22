# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Lagra adresser
autofill-manage-addresses-list-header = Adressat

autofill-manage-credit-cards-title = Lagra kredittkort
autofill-manage-credit-cards-list-header = Kredittkort

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = Fjern
autofill-manage-add-button = Legg til…
autofill-manage-edit-button = Rediger…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Legg til ny adresse
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Rediger adresse

autofill-address-given-name = Fornamn
autofill-address-additional-name = Mellomnamn
autofill-address-family-name = Etternamn
autofill-address-organization = Organisasjon
autofill-address-street = Gateadresse

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Grannelag
# Used in MY
autofill-address-village-township = Tettstad eller Township
autofill-address-island = Øy
# Used in IE
autofill-address-townland = Townland

## address-level-2 names

autofill-address-city = Stad
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = Distrikt
# Used in GB, NO, SE
autofill-address-post-town = Poststad
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Forstad

## address-level-1 names

autofill-address-province = Provins
autofill-address-state = Stat
autofill-address-county = Land
# Used in BB, JM
autofill-address-parish = Sokn
# Used in JP
autofill-address-prefecture = Prefektur
# Used in HK
autofill-address-area = Område
# Used in KR
autofill-address-do-si = Do/Si
# Used in NI, CO
autofill-address-department = Område
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
autofill-save-button = Lagre
autofill-country-warning-message = Automatisk utfylling av skjema er for tida berre tilgjengeleg i enkelte land.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Legg til nytt kredittkort
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Rediger kredittkort

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] vis betalingskortinformasjon
        [windows] { -brand-short-name } prøver å vise kredittkortinformasjon. Stadfest tilgang til denne Windows-kontoen nedanfor.
       *[other] { -brand-short-name } prøver å vise kredittkortinformasjon.
    }

autofill-card-number = Kortnummer
autofill-card-invalid-number = Skriv inn eit gyldig kortnummer
autofill-card-name-on-card = Namn på kort
autofill-card-expires-month = Utløpsmånad
autofill-card-expires-year = Utløpsår
autofill-card-billing-address = Fakturaadresse
autofill-card-network = Korttype

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
