# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Εύρεση της επόμενης εμφάνισης της φράσης
findbar-previous =
    .tooltiptext = Εύρεση της προηγούμενης εμφάνισης της φράσης

findbar-find-button-close =
    .tooltiptext = Κλείσιμο γραμμής εύρεσης

findbar-highlight-all2 =
    .label = Επισήμανση όλων
    .accesskey =
        { PLATFORM() ->
            [macos] λ
           *[other] ω
        }
    .tooltiptext = Επισήμανση όλων των εμφανίσεων της φράσης

findbar-case-sensitive =
    .label = Συμφωνία πεζών-κεφαλαίων
    .accesskey = φ
    .tooltiptext = Εύρεση με συμφωνία πεζών-κεφαλαίων

findbar-match-diacritics =
    .label = Αντιστοίχιση διακριτικών
    .accesskey = ι
    .tooltiptext = Διαχωρισμός ανάμεσα σε τονισμένα και μη γράμματα (για παράδειγμα, όταν κάνετε αναζήτηση για τον όρο “resume”, το “résumé” δεν θα εμφανιστεί)

findbar-entire-word =
    .label = Ολόκληρες λέξεις
    .accesskey = ξ
    .tooltiptext = Αναζήτηση μόνο ολόκληρων λέξεων

findbar-not-found = Η φράση δεν βρέθηκε

findbar-wrapped-to-top = Τέλος της σελίδας, συνέχεια από την αρχή
findbar-wrapped-to-bottom = Αρχή της σελίδας, συνέχεια από το τέλος

findbar-normal-find =
    .placeholder = Εύρεση στη σελίδα
findbar-fast-find =
    .placeholder = Γρήγορη εύρεση
findbar-fast-find-links =
    .placeholder = Γρήγορη εύρεση (μόνο δεσμοί)

findbar-case-sensitive-status =
    .value = (Συμφωνία πεζών/κεφαλαίων)
findbar-match-diacritics-status =
    .value = (Αντιστοίχιση διακριτικών)
findbar-entire-word-status =
    .value = (Μόνο ολόκληρες λέξεις)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] { $current } από { $total } αποτέλεσμα
           *[other] { $current } από { $total } αποτελέσματα
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Περισσότερα από { $limit } αποτέλεσμα
           *[other] Περισσότερα από { $limit } αποτελέσματα
        }
