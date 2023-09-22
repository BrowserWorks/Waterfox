# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Indirizzi salvati
autofill-manage-addresses-list-header = Indirizzi

autofill-manage-credit-cards-title = Carte di credito salvate
autofill-manage-credit-cards-list-header = Carte di credito

autofill-manage-dialog =
    .style = min-width: 600px
autofill-manage-remove-button = Elimina
autofill-manage-add-button = Aggiungi…
autofill-manage-edit-button = Modifica…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Nuovo indirizzo
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Modifica indirizzo

autofill-address-given-name = Nome
autofill-address-additional-name = Secondo nome
autofill-address-family-name = Cognome
autofill-address-organization = Organizzazione
autofill-address-street = Indirizzo

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Vicinato
# Used in MY
autofill-address-village-township = Villaggio o township
autofill-address-island = Isola
# Used in IE
autofill-address-townland = Townland

## address-level-2 names

autofill-address-city = Città
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = Distretto
# Used in GB, NO, SE
autofill-address-post-town = Post town
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Suburb

## address-level-1 names

autofill-address-province = Provincia
autofill-address-state = Stato
autofill-address-county = County
# Used in BB, JM
autofill-address-parish = Parish
# Used in JP
autofill-address-prefecture = Prefettura
# Used in HK
autofill-address-area = Area
# Used in KR
autofill-address-do-si = Do/Si
# Used in NI, CO
autofill-address-department = Dipartimento
# Used in AE
autofill-address-emirate = Emirato
# Used in RU and UA
autofill-address-oblast = Oblast

## Postal code name types

# Used in IN
autofill-address-pin = Pin
autofill-address-postal-code = Codice postale
autofill-address-zip = Codice ZIP
# Used in IE
autofill-address-eircode = Eircode

##

autofill-address-country = Stato o regione
autofill-address-tel = Telefono
autofill-address-email = Email

autofill-cancel-button = Annulla
autofill-save-button = Salva
autofill-country-warning-message = La compilazione automatica dei moduli è attualmente disponibile solo per alcuni Paesi.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Nuova carta di credito
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Modifica carta di credito

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] visualizzare informazioni relative alle carte di credito.
        [windows] { -brand-short-name } sta cercando di visualizzare informazioni relative alle carte di credito. Confermare l’accesso all’account Windows.
       *[other] { -brand-short-name } sta cercando di visualizzare informazioni relative alle carte di credito.
    }

autofill-card-number = Numero carta
autofill-card-invalid-number = Inserire un numero di carta valido
autofill-card-name-on-card = Nome sulla carta
autofill-card-expires-month = Scad. mese
autofill-card-expires-year = Scad. anno
autofill-card-billing-address = Indirizzo di fatturazione
autofill-card-network = Tipo di carta

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
