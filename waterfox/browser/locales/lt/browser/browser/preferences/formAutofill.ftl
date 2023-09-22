# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Įrašyti adresai
autofill-manage-addresses-list-header = Adresai

autofill-manage-credit-cards-title = Įrašytos banko kortelės
autofill-manage-credit-cards-list-header = Banko kortelės

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = Pašalinti
autofill-manage-add-button = Įtraukti…
autofill-manage-edit-button = Keisti…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Pridėti naują adresą
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Keisti adresą

autofill-address-given-name = Vardas
autofill-address-additional-name = Antras vardas
autofill-address-family-name = Pavardė
autofill-address-organization = Organizacija
autofill-address-street = Gatvės adresas

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Rajonas
# Used in MY
autofill-address-village-township = Kaimas ar miestelis
autofill-address-island = Sala
# Used in IE
autofill-address-townland = Miestelis

## address-level-2 names

autofill-address-city = Miestas
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = Rajonas
# Used in GB, NO, SE
autofill-address-post-town = Pašto miestas
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Priemiestis

## address-level-1 names

autofill-address-province = Provincija
autofill-address-state = Valstija (regionas)
autofill-address-county = Apygarda
# Used in BB, JM
autofill-address-parish = Parapija
# Used in JP
autofill-address-prefecture = Prefektūra
# Used in HK
autofill-address-area = Sritis
# Used in KR
autofill-address-do-si = Do/Si
# Used in NI, CO
autofill-address-department = Departamentas
# Used in AE
autofill-address-emirate = Emyratas
# Used in RU and UA
autofill-address-oblast = Sritis

## Postal code name types

# Used in IN
autofill-address-pin = Pin kodas
autofill-address-postal-code = Pašto kodas
autofill-address-zip = Pašto kodas
# Used in IE
autofill-address-eircode = Eir kodas

##

autofill-address-country = Šalis arba regionas
autofill-address-tel = Telefonas
autofill-address-email = El. paštas

autofill-cancel-button = Atsisakyti
autofill-save-button = Įrašyti
autofill-country-warning-message = Automatinis formų užpildymas kol kas galimas tik tam tikrose šalyse.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Įtraukti naują banko kortelę
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Keisti banko kortelę

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] parodyti banko kortelės duomenis
        [windows] „{ -brand-short-name }“ bando parodyti banko kortelės informaciją. Žemiau patvirtinkite prieigą prie šios „Windows“ paskyros.
       *[other] „{ -brand-short-name }“ bando parodyti banko kortelės informaciją.
    }

autofill-card-number = Kortelės numeris
autofill-card-invalid-number = Įveskite teisingą kortelės numerį
autofill-card-name-on-card = Vardas ant kortelės
autofill-card-expires-month = Pab. mėnuo
autofill-card-expires-year = Pab. metai
autofill-card-billing-address = Adresas sąskaitoms
autofill-card-network = Kortelės rūšis

## These are brand names and should only be translated when a locale-specific name for that brand is in common use

autofill-card-network-amex = „American Express“
autofill-card-network-cartebancaire = „Carte Bancaire“
autofill-card-network-diners = „Diners Club“
autofill-card-network-discover = „Discover“
autofill-card-network-jcb = „JCB“
autofill-card-network-mastercard = „MasterCard“
autofill-card-network-mir = „MIR“
autofill-card-network-unionpay = „Union Pay“
autofill-card-network-visa = „Visa“
