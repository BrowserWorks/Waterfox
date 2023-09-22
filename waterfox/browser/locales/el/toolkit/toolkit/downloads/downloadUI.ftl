# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Ακύρωση όλων των λήψεων;

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Αν αποχωρήσετε τώρα, θα ακυρωθεί 1 λήψη. Θέλετε σίγουρα να αποχωρήσετε;
       *[other] Αν αποχωρήσετε τώρα, θα ακυρωθούν { $downloadsCount } λήψεις. Θέλετε σίγουρα να αποχωρήσετε;
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Αν αποχωρήσετε τώρα, θα ακυρωθεί 1 λήψη. Θέλετε σίγουρα να αποχωρήσετε;
       *[other] Αν αποχωρήσετε τώρα, θα ακυρωθούν { $downloadsCount } λήψεις. Θέλετε σίγουρα να αποχωρήσετε;
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] Να μη γίνει έξοδος
       *[other] Να μη γίνει έξοδος
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Αν αποσυνδεθείτε τώρα, θα ακυρωθεί 1 λήψη. Θέλετε σίγουρα να αποσυνδεθείτε;
       *[other] Αν αποσυνδεθείτε τώρα, θα ακυρωθούν { $downloadsCount } λήψεις. Θέλετε σίγουρα να αποσυνδεθείτε;
    }
download-ui-dont-go-offline-button = Διατήρηση σύνδεσης

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Αν κλείσετε τώρα όλα τα παράθυρα ιδιωτικής περιήγησης, θα ακυρωθεί 1 λήψη. Θέλετε σίγουρα να αποχωρήσετε από την ιδιωτική περιήγηση;
       *[other] Αν κλείσετε τώρα όλα τα παράθυρα ιδιωτικής περιήγησης, θα ακυρωθούν { $downloadsCount } λήψεις. Θέλετε σίγουρα να αποχωρήσετε από την ιδιωτική περιήγηση;
    }
download-ui-dont-leave-private-browsing-button = Παραμονή σε ιδιωτική περιήγηση

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] Ακύρωση 1 λήψης
       *[other] Ακύρωση { $downloadsCount } λήψεων
    }

##

download-ui-file-executable-security-warning-title = Άνοιγμα εκτελέσιμου αρχείου;
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = Το “{ $executable }” είναι ένα εκτελέσιμο αρχείο. Τα εκτελέσιμα αρχεία ενδέχεται να περιέχουν ιούς ή άλλο κακόβουλο κώδικα που μπορεί να βλάψει τον υπολογιστή σας. Ανοίξτε με προσοχή αυτό το αρχείο. Θέλετε σίγουρα να εκκινήσετε το “{ $executable }”;
