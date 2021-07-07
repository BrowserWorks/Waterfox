# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Επιλεγμένο στοιχείο
compatibility-all-elements-header = Όλα τα ζητήματα

## Message used as labels for the type of issue

compatibility-issue-deprecated = (παρωχημένο)
compatibility-issue-experimental = (πειραματικό)
compatibility-issue-prefixneeded = (απαιτείται πρόθεμα)
compatibility-issue-deprecated-experimental = (παρωχημένο, πειραματικό)
compatibility-issue-deprecated-prefixneeded = (παρωχημένο, απαιτείται πρόθεμα)
compatibility-issue-experimental-prefixneeded = (πειραματικό, απαιτείται πρόθεμα)
compatibility-issue-deprecated-experimental-prefixneeded = (παρωχημένο, πειραματικό, απαιτείται πρόθεμα)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Ρυθμίσεις
compatibility-settings-button-title =
    .title = Ρυθμίσεις
compatibility-feedback-button-label = Σχόλια
compatibility-feedback-button-title =
    .title = Σχόλια

## Messages used as headers in settings pane

compatibility-settings-header = Ρυθμίσεις
compatibility-target-browsers-header = Προγράμματα περιήγησης-στόχοι

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } εμφάνιση
       *[other] { $number } εμφανίσεις
    }

compatibility-no-issues-found = Δεν βρέθηκαν ζητήματα συμβατότητας
compatibility-close-settings-button =
    .title = Κλείσιμο ρυθμίσεων
