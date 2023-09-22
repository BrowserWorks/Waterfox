# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = Αποθηκευμένες διευθύνσεις
autofill-manage-addresses-list-header = Διευθύνσεις

autofill-manage-credit-cards-title = Αποθηκευμένες πιστωτικές κάρτες
autofill-manage-credit-cards-list-header = Πιστωτικές κάρτες

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = Αφαίρεση
autofill-manage-add-button = Προσθήκη…
autofill-manage-edit-button = Επεξεργασία…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = Προσθήκη νέας διεύθυνσης
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = Επεξεργασία διεύθυνσης

autofill-address-given-name = Όνομα
autofill-address-additional-name = Μεσαίο όνομα
autofill-address-family-name = Επώνυμο
autofill-address-organization = Εταιρεία
autofill-address-street = Διεύθυνση οδού

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = Γειτονιά
# Used in MY
autofill-address-village-township = Χωριό ή κωμόπολη
autofill-address-island = Νησί
# Used in IE
autofill-address-townland = Κοινότητα

## address-level-2 names

autofill-address-city = Πόλη
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = Συνοικία
# Used in GB, NO, SE
autofill-address-post-town = Πόλη αποστολής
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = Προάστιο

## address-level-1 names

autofill-address-province = Επαρχία
autofill-address-state = Περιφέρεια
autofill-address-county = Κομητεία
# Used in BB, JM
autofill-address-parish = Ενορία
# Used in JP
autofill-address-prefecture = Νομαρχία
# Used in HK
autofill-address-area = Περιοχή
# Used in KR
autofill-address-do-si = Do/Si
# Used in NI, CO
autofill-address-department = Τμήμα
# Used in AE
autofill-address-emirate = Εμιράτο
# Used in RU and UA
autofill-address-oblast = Oblast

## Postal code name types

# Used in IN
autofill-address-pin = Ταχ. κώδικας
autofill-address-postal-code = Ταχυδρομικός κώδικας
autofill-address-zip = Ταχ. κώδικας
# Used in IE
autofill-address-eircode = Eircode

##

autofill-address-country = Χώρα ή περιοχή
autofill-address-tel = Τηλέφωνο
autofill-address-email = Email

autofill-cancel-button = Ακύρωση
autofill-save-button = Αποθήκευση
autofill-country-warning-message = Η αυτόματη συμπλήρωση φορμών διατίθεται μόνο σε ορισμένες χώρες προς το παρόν.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = Προσθήκη νέας πιστωτικής κάρτας
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = Επεξεργασία πιστωτικής κάρτας

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] εμφανίσει στοιχεία πιστωτικής κάρτας
        [windows] Το { -brand-short-name } προσπαθεί να εμφανίσει πληροφορίες πιστωτικών καρτών. Επιβεβαιώστε παρακάτω την πρόσβαση σε αυτό το λογαριασμό Windows.
       *[other] Το { -brand-short-name } προσπαθεί να εμφανίσει πληροφορίες πιστωτικών καρτών.
    }

autofill-card-number = Αριθμός κάρτας
autofill-card-invalid-number = Εισάγετε έναν έγκυρο αριθμό κάρτας
autofill-card-name-on-card = Όνομα στην κάρτα
autofill-card-expires-month = Μήνας λήξης
autofill-card-expires-year = Έτος λήξης
autofill-card-billing-address = Διεύθυνση χρέωσης
autofill-card-network = Τύπος κάρτας

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
