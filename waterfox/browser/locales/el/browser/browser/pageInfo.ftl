# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 700px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Αντιγραφή
    .accesskey = γ

select-all =
    .key = A
menu-select-all =
    .label = Επιλογή όλων
    .accesskey = λ

close-dialog =
    .key = w

general-tab =
    .label = Γενικά
    .accesskey = Γ
general-title =
    .value = Τίτλος:
general-url =
    .value = Διεύθυνση:
general-type =
    .value = Τύπος:
general-mode =
    .value = Λειτουργία εμφάνισης:
general-size =
    .value = Μέγεθος:
general-referrer =
    .value = URL παραπομπής:
general-modified =
    .value = Τροποποίηση:
general-encoding =
    .value = Κωδικοποίηση κειμένου:
general-meta-name =
    .label = Όνομα
general-meta-content =
    .label = Περιεχόμενο

media-tab =
    .label = Πολυμέσα
    .accesskey = μ
media-location =
    .value = Τοποθεσία:
media-text =
    .value = Σχετικό κείμενο:
media-alt-header =
    .label = Εναλλακτικό κείμενο
media-address =
    .label = Διεύθυνση
media-type =
    .label = Τύπος
media-size =
    .label = Μέγεθος
media-count =
    .label = Αρίθμηση
media-dimension =
    .value = Διαστάσεις:
media-long-desc =
    .value = Μακρά περιγραφή:
media-save-as =
    .label = Αποθήκευση ως…
    .accesskey = ω
media-save-image-as =
    .label = Αποθήκευση ως…
    .accesskey = ω

perm-tab =
    .label = Δικαιώματα
    .accesskey = Δ
permissions-for =
    .value = Δικαιώματα για:

security-tab =
    .label = Ασφάλεια
    .accesskey = σ
security-view =
    .label = Προβολή πιστοποιητικού
    .accesskey = β
security-view-unknown = Άγνωστη
    .value = Άγνωστη
security-view-identity =
    .value = Ταυτότητα ιστοτόπου
security-view-identity-owner =
    .value = Ιδιοκτήτης:
security-view-identity-domain =
    .value = Ιστότοπος:
security-view-identity-verifier =
    .value = Επαληθεύτηκε από:
security-view-identity-validity =
    .value = Λήγει στις:
security-view-privacy =
    .value = Απόρρητο & ιστορικό

security-view-privacy-history-value = Έχω επισκεφθεί τον ιστότοπο στο παρελθόν;
security-view-privacy-sitedata-value = Αποθηκεύει ο ιστότοπος πληροφορίες στον υπολογιστή μου;

security-view-privacy-clearsitedata =
    .label = Απαλοιφή cookies και δεδομένων ιστοτόπου
    .accesskey = Α

security-view-privacy-passwords-value = Έχω αποθηκεύσει κωδικούς πρόσβασης για τον ιστότοπο;

security-view-privacy-viewpasswords =
    .label = Προβολή αποθηκευμένων κωδικών πρόσβασης
    .accesskey = λ
security-view-technical =
    .value = Τεχνικές λεπτομέρειες

help-button =
    .label = Βοήθεια

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Ναι, cookies και { $value } { $unit } δεδομένων ιστοτόπου
security-site-data-only = Ναι, { $value } { $unit } δεδομένων ιστοτόπου

security-site-data-cookies-only = Ναι, cookies
security-site-data-no = Όχι

##

image-size-unknown = Άγνωστο
page-info-not-specified =
    .value = Δεν έχει καθοριστεί
not-set-alternative-text = Δεν έχει καθοριστεί
not-set-date = Δεν έχει καθοριστεί
media-img = Εικόνα
media-bg-img = Φόντο
media-border-img = Περίγραμμα
media-list-img = Κουκκίδα
media-cursor = Κέρσορας
media-object = Αντικείμενο
media-embed = Ενσωμάτωση
media-link = Εικονίδιο
media-input = Είσοδος
media-video = Βίντεο
media-audio = Ήχος
saved-passwords-yes = Ναι
saved-passwords-no = Όχι

no-page-title =
    .value = Σελίδα χωρίς τίτλο:
general-quirks-mode =
    .value = Λειτουργία συμβατότητας
general-strict-mode =
    .value = Λειτουργία σύμφωνα με τα πρότυπα
page-info-security-no-owner =
    .value = Αυτός ο ιστότοπος δεν παρέχει πληροφορίες ιδιοκτησίας.
media-select-folder = Επιλέξτε έναν φάκελο για αποθήκευση εικόνων
media-unknown-not-cached =
    .value = Άγνωστο (όχι σε κρυφή μνήμη)
permissions-use-default =
    .label = Χρήση προεπιλογής
security-no-visits = Όχι

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] Μεταδεδομένα (1 ετικέτα)
           *[other] Μεταδεδομένα ({ $tags } ετικέτες)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Όχι
        [one] Ναι, μια φορά
       *[other] Ναι, { $visits } φορές
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } KB ({ $bytes } byte)
           *[other] { $kb } KB ({ $bytes } bytes)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] Εικόνα { $type } (κινούμενη, { $frames } καρέ)
           *[other] Εικόνα { $type } (κινούμενη, { $frames } καρέ)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = Εικόνα { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (κλιμακώθηκε σε { $scaledx }px × { $scaledy }px)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx }px × { $dimy }px

# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } KB

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = Φραγή εικόνων από { $website }
    .accesskey = α

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) — The url of the website pageInfo is getting info for
page-info-page =
    .title = Πληροφορίες σελίδας — { $website }
page-info-frame =
    .title = Πληροφορίες πλαισίου — { $website }
