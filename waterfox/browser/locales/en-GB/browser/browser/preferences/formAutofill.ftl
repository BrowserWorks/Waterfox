# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Saved Addresses
autofill-manage-addresses-list-header = Addresses

autofill-manage-credit-cards-title = Saved Credit Cards
autofill-manage-credit-cards-list-header = Credit Cards

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = Remove
autofill-manage-add-button = Add…
autofill-manage-edit-button = Edit…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Add New Address
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Edit Address

autofill-address-given-name = First Name
autofill-address-additional-name = Middle Name
autofill-address-family-name = Last Name
autofill-address-organization = Organisation
autofill-address-street = Street Address

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Neighbourhood
# Used in MY
autofill-address-village-township = Village or Township
autofill-address-island = Island
# Used in IE
autofill-address-townland = Townland

## address-level-2 names

autofill-address-city = City
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = District
# Used in GB, NO, SE
autofill-address-post-town = Post town
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Suburb

## address-level-1 names

autofill-address-province = Province
autofill-address-state = State
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
autofill-address-emirate = Emirate
# Used in RU and UA
autofill-address-oblast = Oblast

## Postal code name types

# Used in IN
autofill-address-pin = Pin
autofill-address-postal-code = Post Code
autofill-address-zip = Zip Code
# Used in IE
autofill-address-eircode = Eircode

##

autofill-address-country = Country or Region
autofill-address-tel = Phone
autofill-address-email = Email

autofill-cancel-button = Cancel
autofill-save-button = Save
autofill-country-warning-message = Form Autofill is currently available only for certain countries.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Add New Credit Card
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Edit Credit Card

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] show credit card information
        [windows] { -brand-short-name } is trying to show credit card information. Confirm access to this Windows account below.
       *[other] { -brand-short-name } is trying to show credit card information.
    }

autofill-card-number = Card Number
autofill-card-invalid-number = Please enter a valid card number
autofill-card-name-on-card = Name on Card
autofill-card-expires-month = Exp. Month
autofill-card-expires-year = Exp. Year
autofill-card-billing-address = Billing Address
autofill-card-network = Card Type

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
