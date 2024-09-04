# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Gespeicherte Adressen
autofill-manage-addresses-list-header = Adressen

autofill-manage-credit-cards-title = Gespeicherte Kreditkarten
autofill-manage-credit-cards-list-header = Kreditkarten

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = Entfernen
autofill-manage-add-button = Hinzufügen…
autofill-manage-edit-button = Bearbeiten…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Adresse hinzufügen
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Adresse bearbeiten

autofill-address-given-name = Erster Vorname
autofill-address-additional-name = Zweiter Vorname
autofill-address-family-name = Nachname
autofill-address-organization = Organisation
autofill-address-street = Straße und Hausnummer

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Neighborhood
# Used in MY
autofill-address-village-township = Dorf oder Gemeinde
autofill-address-island = Insel
# Used in IE
autofill-address-townland = Townland

## address-level-2 names

autofill-address-city = Ort
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = Distrikt
# Used in GB, NO, SE
autofill-address-post-town = Post Town
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Suburb

## address-level-1 names

autofill-address-province = Provinz
autofill-address-state = Bundesland
autofill-address-county = County
# Used in BB, JM
autofill-address-parish = Parish
# Used in JP
autofill-address-prefecture = Präfektur
# Used in HK
autofill-address-area = Area
# Used in KR
autofill-address-do-si = Do/Si
# Used in NI, CO
autofill-address-department = Departamento
# Used in AE
autofill-address-emirate = Emirat
# Used in RU and UA
autofill-address-oblast = Oblast

## Postal code name types

# Used in IN
autofill-address-pin = PIN
autofill-address-postal-code = Postleitzahl
autofill-address-zip = ZIP-Code
# Used in IE
autofill-address-eircode = Eircode

##

autofill-address-country = Land oder Region
autofill-address-tel = Telefon
autofill-address-email = E-Mail-Adresse

autofill-cancel-button = Abbrechen
autofill-save-button = Speichern
autofill-country-warning-message = Das automatische Ausfüllen von Adressen ist derzeit nur für Adressen in einigen Ländern verfügbar.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Neue Kreditkarte hinzufügen
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Kreditkarte bearbeiten

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] Kreditkartendaten anzeigen
        [windows] { -brand-short-name } versucht, Kreditkartendaten anzuzeigen. Bestätigen Sie unten den Zugriff auf dieses Windows-Konto.
       *[other] { -brand-short-name } versucht, Kreditkartendaten anzuzeigen.
    }

autofill-card-number = Kartennummer
autofill-card-invalid-number = Bitte geben Sie eine gültige Kreditkartennummer ein.
autofill-card-name-on-card = Name auf Karte
autofill-card-expires-month = Monat des Ablaufs
autofill-card-expires-year = Jahr des Ablaufs
autofill-card-billing-address = Rechnungsadresse
autofill-card-network = Kreditkarten-Typ

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
