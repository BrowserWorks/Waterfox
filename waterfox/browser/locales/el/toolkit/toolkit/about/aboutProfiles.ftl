# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Σχετικά με τα προφίλ
profiles-subtitle = Η σελίδα αυτή σας βοηθά να διαχειρίζεστε τα προφίλ σας. Κάθε προφίλ αποτελεί ένα ξεχωριστό κόσμο που περιέχει ξεχωριστό ιστορικό, σελιδοδείκτες, ρυθμίσεις και πρόσθετα.
profiles-create = Δημιουργία νέου προφίλ
profiles-restart-title = Επανεκκίνηση
profiles-restart-in-safe-mode = Επανεκκίνηση με ανενεργά πρόσθετα…
profiles-restart-normal = Κανονική επανεκκίνηση…
profiles-conflict = Ένα άλλο αντίγραφο του { -brand-product-name } έχει κάνει αλλαγές στα προφίλ. Πρέπει να επανεκκινήσετε το { -brand-short-name } πριν κάνετε περισσότερες αλλαγές.
profiles-flush-fail-title = Μη αποθηκευμένες αλλαγές
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Ένα μη αναμενόμενο σφάλμα εμπόδισε την αποθήκευση των αλλαγών σας.
profiles-flush-restart-button = Επανεκκίνηση του { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Προφίλ: { $name }
profiles-is-default = Προεπιλεγμένο προφίλ
profiles-rootdir = Κατάλογος ρίζας

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Τοπικός κατάλογος
profiles-current-profile = Αυτό το προφίλ είναι σε λειτουργία και δεν μπορεί να διαγραφεί.
profiles-in-use-profile = Αυτό το προφίλ χρησιμοποιείται σε άλλη εφαρμογή και δεν μπορεί να διαγραφεί.

profiles-rename = Μετονομασία
profiles-remove = Αφαίρεση
profiles-set-as-default = Ορισμός ως προεπιλεγμένο προφίλ
profiles-launch-profile = Εκκίνηση προφίλ σε νέο πρόγραμμα περιήγησης

profiles-cannot-set-as-default-title = Αδυναμία ορισμού προεπιλογής
profiles-cannot-set-as-default-message = Το προεπιλεγμένο προφίλ δεν μπορεί να αλλάξει για το { -brand-short-name }.

profiles-yes = ναι
profiles-no = όχι

profiles-rename-profile-title = Μετονομασία προφίλ
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Μετονομασία προφίλ { $name }

profiles-invalid-profile-name-title = Μη έγκυρο όνομα προφίλ
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Το όνομα προφίλ “{ $name }” δεν επιτρέπεται.

profiles-delete-profile-title = Διαγραφή προφίλ
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Αν διαγράψετε ένα προφίλ, θα αφαιρεθεί οριστικά από τη λίστα των διαθέσιμων προφίλ.
    Μπορείτε επίσης να διαγράψετε τα αρχεία δεδομένων του προφίλ, όπως οι ρυθμίσεις, τα πιστοποιητικά και άλλα δεδομένα χρήστη. Αυτή η επιλογή θα διαγράψει τον φάκελο “{ $dir }” και δεν μπορεί να αναιρεθεί.
    Θέλετε να διαγράψετε τα αρχεία δεδομένων του προφίλ;
profiles-delete-files = Διαγραφή αρχείων
profiles-dont-delete-files = Διατήρηση αρχείων

profiles-delete-profile-failed-title = Σφάλμα
profiles-delete-profile-failed-message = Παρουσιάστηκε σφάλμα κατά την προσπάθεια διαγραφής αυτού του προφίλ.


profiles-opendir =
    { PLATFORM() ->
        [macos] Προβολή στο Finder
        [windows] Άνοιγμα φακέλου
       *[other] Άνοιγμα καταλόγου
    }
