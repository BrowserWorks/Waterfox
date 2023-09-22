# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Mentett címek
autofill-manage-addresses-list-header = Címek

autofill-manage-credit-cards-title = Mentett bankkártyák
autofill-manage-credit-cards-list-header = Bankkártyák

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = Eltávolítás
autofill-manage-add-button = Hozzáadás…
autofill-manage-edit-button = Szerkesztés…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Új cím hozzáadása
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Cím szerkesztése

autofill-address-given-name = Utónév
autofill-address-additional-name = Egyéb név
autofill-address-family-name = Vezetéknév
autofill-address-organization = Szervezet
autofill-address-street = Utca, hászszám

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Szomszédság
# Used in MY
autofill-address-village-township = Falu vagy község
autofill-address-island = Sziget
# Used in IE
autofill-address-townland = Townland

## address-level-2 names

autofill-address-city = Város
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = Kerület
# Used in GB, NO, SE
autofill-address-post-town = Postaállomás
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Külváros

## address-level-1 names

autofill-address-province = Tartomány
autofill-address-state = Állam
autofill-address-county = Megye
# Used in BB, JM
autofill-address-parish = Egyházközség
# Used in JP
autofill-address-prefecture = Közigazgatási terület
# Used in HK
autofill-address-area = Terület
# Used in KR
autofill-address-do-si = Do/Si
# Used in NI, CO
autofill-address-department = Részleg
# Used in AE
autofill-address-emirate = Emirátus
# Used in RU and UA
autofill-address-oblast = Oblaszt

## Postal code name types

# Used in IN
autofill-address-pin = Pin
autofill-address-postal-code = Irányítószám
autofill-address-zip = Irányítószám (Amerikai Egyesült Államok)
# Used in IE
autofill-address-eircode = Eircode

##

autofill-address-country = Ország vagy régió
autofill-address-tel = Telefonszám
autofill-address-email = E-mail

autofill-cancel-button = Mégse
autofill-save-button = Mentés
autofill-country-warning-message = Az űrlapkitöltés jelenleg csak egyes országbeli címekre érhető el.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Új bankkártya hozzáadása
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Bankkártya szerkesztése

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] bankkártya-információk megjelenítése
        [windows] A { -brand-short-name } bankkártyaadatokat akar megjeleníteni. Erősítse meg a hozzáférést az alábbi Windows-fiókhoz.
       *[other] A { -brand-short-name } bankkártyaadatokat akar megjeleníteni.
    }

autofill-card-number = Kártyaszám
autofill-card-invalid-number = Írjon be érvényes kártyaszámot
autofill-card-name-on-card = Kártyán szereplő név
autofill-card-expires-month = Lejárat hónapja
autofill-card-expires-year = Lejárat éve
autofill-card-billing-address = Számlázási cím
autofill-card-network = Kártyatípus

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
