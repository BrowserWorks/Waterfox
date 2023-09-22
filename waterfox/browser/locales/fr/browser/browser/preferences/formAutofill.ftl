# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Adresses enregistrées
autofill-manage-addresses-list-header = Adresses

autofill-manage-credit-cards-title = Cartes bancaires enregistrées
autofill-manage-credit-cards-list-header = Cartes bancaires

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = Supprimer
autofill-manage-add-button = Ajouter…
autofill-manage-edit-button = Modifier…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Ajouter une nouvelle adresse
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Modifier l’adresse

autofill-address-given-name = Prénom
autofill-address-additional-name = Deuxième prénom
autofill-address-family-name = Nom
autofill-address-organization = Société
autofill-address-street = Adresse postale

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Quartier
# Used in MY
autofill-address-village-township = Village ou canton
autofill-address-island = Île
# Used in IE
autofill-address-townland = Commune

## address-level-2 names

autofill-address-city = Ville
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = Arrondissement
# Used in GB, NO, SE
autofill-address-post-town = Ville postale
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Banlieue

## address-level-1 names

autofill-address-province = Province
autofill-address-state = État
autofill-address-county = Comté
# Used in BB, JM
autofill-address-parish = Paroisse
# Used in JP
autofill-address-prefecture = Préfecture
# Used in HK
autofill-address-area = Zone
# Used in KR
autofill-address-do-si = Do/Si
# Used in NI, CO
autofill-address-department = Département
# Used in AE
autofill-address-emirate = Émirat
# Used in RU and UA
autofill-address-oblast = Oblast

## Postal code name types

# Used in IN
autofill-address-pin = Pin
autofill-address-postal-code = Code postal
autofill-address-zip = Code postal (États-Unis)
# Used in IE
autofill-address-eircode = Eircode

##

autofill-address-country = Pays ou région
autofill-address-tel = Téléphone
autofill-address-email = Adresse e-mail

autofill-cancel-button = Annuler
autofill-save-button = Enregistrer
autofill-country-warning-message = Pour le moment, le remplissage automatique des formulaires est uniquement disponible dans certains pays.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Ajouter une nouvelle carte bancaire
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Modifier la carte bancaire

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] afficher les informations de la carte bancaire
        [windows] { -brand-short-name } tente d’afficher les informations liées à une carte bancaire. Veuillez confirmer l’accès au compte utilisateur Windows ci-dessous.
       *[other] { -brand-short-name } tente d’afficher les informations liées à une carte bancaire.
    }

autofill-card-number = Numéro de carte
autofill-card-invalid-number = Veuillez saisir un numéro de carte valide
autofill-card-name-on-card = Titulaire
autofill-card-expires-month = Mois d’expiration
autofill-card-expires-year = Année d’expiration
autofill-card-billing-address = Adresse de facturation
autofill-card-network = Type de carte

## These are brand names and should only be translated when a locale-specific name for that brand is in common use

autofill-card-network-amex = American Express
autofill-card-network-cartebancaire = Carte bancaire
autofill-card-network-diners = Diners Club
autofill-card-network-discover = Discover
autofill-card-network-jcb = JCB
autofill-card-network-mastercard = MasterCard
autofill-card-network-mir = MIR
autofill-card-network-unionpay = Union Pay
autofill-card-network-visa = Visa
