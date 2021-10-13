# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Απαλοιφή δεδομένων
    .style = width: 35em

clear-site-data-description = Η απαλοιφή όλων των cookies και των δεδομένων ιστοτόπων που αποθηκεύει το { -brand-short-name } ίσως σας αποσυνδέσει από ιστοτόπους και ενδέχεται να αφαιρέσει το περιεχόμενο web εκτός σύνδεσης. Η διαγραφή της κρυφής μνήμης δεν θα επηρεάσει τις συνδέσεις σας.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies και δεδομένα ιστοτόπων ({ $amount } { $unit })
    .accesskey = ι

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies και δεδομένα ιστοτόπων
    .accesskey = ι

clear-site-data-cookies-info = Ενδέχεται να αποσυνδεθείτε από τους ιστοτόπους εάν γίνει εκκαθάριση

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Προσωρινό περιεχόμενο διαδικτύου ({ $amount } { $unit })
    .accesskey = Π

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Προσωρινό περιεχόμενο διαδικτύου
    .accesskey = Π

clear-site-data-cache-info = Θα χρειαστεί εκ νέου φόρτωση εικόνων και δεδομένων σε ιστοτόπους

clear-site-data-dialog =
    .buttonlabelaccept = Απαλοιφή
    .buttonaccesskeyaccept = λ
