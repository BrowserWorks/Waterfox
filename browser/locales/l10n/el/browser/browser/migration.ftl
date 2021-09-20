# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Βοηθός εισαγωγής
import-from =
    { PLATFORM() ->
        [windows] Εισαγωγή επιλογών, σελιδοδεικτών, ιστορικού, κωδικών πρόσβασης και άλλων δεδομένων από:
       *[other] Εισαγωγή προτιμήσεων, σελιδοδεικτών, ιστορικού, κωδικών πρόσβασης και άλλων δεδομένων από:
    }
import-from-bookmarks = Εισαγωγή σελιδοδεικτών από:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge Legacy
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = Να μην εισαχθεί τίποτα
    .accesskey = Ν
import-from-safari =
    .label = Safari
    .accesskey = S
import-from-canary =
    .label = Chrome Canary
    .accesskey = n
import-from-chrome =
    .label = Chrome
    .accesskey = C
import-from-chrome-beta =
    .label = Chrome Beta
    .accesskey = B
import-from-chrome-dev =
    .label = Chrome Dev
    .accesskey = D
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Waterfox
    .accesskey = X
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3
no-migration-sources = Δεν βρέθηκαν προγράμματα τα οποία περιέχουν σελιδοδείκτες, ιστορικό ή δεδομένα κωδικών.
import-source-page-title = Εισαγωγή ρυθμίσεων και δεδομένων
import-items-page-title = Στοιχεία προς εισαγωγή
import-items-description = Επιλέξτε στοιχεία προς εισαγωγή:
import-permissions-page-title = Παρακαλούμε παραχωρήστε στο { -brand-short-name } δικαιώματα
# Do not translate "Bookmarks.plist"; the file name is the same everywhere.
import-permissions-description = Το macOS απαιτεί τη ρητή έγκρισή σας ώστε το { -brand-short-name } να προσπελάσει τους σελιδοδείκτες του Safari. Κάντε κλικ στο “Συνέχεια” και επιλέξτε το αρχείο “Bookmarks.plist” στο παράθυρο “Άνοιγμα αρχείου”.
import-migrating-page-title = Εισαγωγή…
import-migrating-description = Γίνεται εισαγωγή των παρακάτω στοιχείων αυτή τη στιγμή…
import-select-profile-page-title = Επιλογή προφίλ
import-select-profile-description = Τα ακόλουθα προφίλ είναι διαθέσιμα για εισαγωγή από:
import-done-page-title = Η εισαγωγή ολοκληρώθηκε
import-done-description = Τα ακόλουθα στοιχεία εισήχθησαν επιτυχώς:
import-close-source-browser = Παρακαλώ βεβαιωθείτε ότι το επιλεγμένο πρόγραμμα περιήγησης είναι κλειστό πριν συνεχίσετε.
# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Από { $source }
source-name-ie = Ιnternet Explorer
source-name-edge = Microsoft Edge
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Waterfox
source-name-360se = 360 Secure Browser
imported-safari-reading-list = Λίστα ανάγνωσης (Από Safari)
imported-edge-reading-list = Λίστα ανάγνωσης (Από Edge)

## Browser data types
## All of these strings get a $browser variable passed in.
## You can use the browser variable to differentiate the name of items,
## which may have different labels in different browsers.
## The supported values for the $browser variable are:
## 360se
## chrome
## edge
## firefox
## ie
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

browser-data-cookies-checkbox =
    .label = Cookies
browser-data-cookies-label =
    .value = Cookies
browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Ιστορικό περιήγησης και σελιδοδείκτες
           *[other] Ιστορικό περιήγησης
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Ιστορικό περιήγησης και σελιδοδείκτες
           *[other] Ιστορικό περιήγησης
        }
browser-data-formdata-checkbox =
    .label = Ιστορικό αποθηκευμένων φορμών
browser-data-formdata-label =
    .value = Ιστορικό αποθηκευμένων φορμών
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Αποθηκευμένες συνδέσεις και κωδικοί πρόσβασης
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Αποθηκευμένες συνδέσεις και κωδικοί πρόσβασης
browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Αγαπημένα
            [edge] Αγαπημένα
           *[other] Σελιδοδείκτες
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Αγαπημένα
            [edge] Αγαπημένα
           *[other] Σελιδοδείκτες
        }
browser-data-otherdata-checkbox =
    .label = Άλλα δεδομένα
browser-data-otherdata-label =
    .label = Άλλα δεδομένα
browser-data-session-checkbox =
    .label = Παράθυρα και καρτέλες
browser-data-session-label =
    .value = Παράθυρα και καρτέλες
