# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Headers used in the webextension permissions dialog,
## See https://bug1308309.bmoattachments.org/attachment.cgi?id=8814612
## for an example of the full dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension.

webext-perms-header = Προσθήκη του «{ $extension }»;
webext-perms-header-with-perms = Προσθήκη του «{ $extension }»; Αυτή η επέκταση θα έχει την άδεια για:
webext-perms-header-unsigned = Προσθήκη του «{ $extension }»; Αυτό το πρόσθετο δεν είναι επαληθευμένο. Τα κακόβουλα πρόσθετα μπορούν να υποκλέψουν τις προσωπικές σας πληροφορίες ή να θέσουν σε κίνδυνο τον υπολογιστή σας. Προσθέστε το μόνο εάν εμπιστεύεστε την προέλευσή του.
webext-perms-header-unsigned-with-perms = Προσθήκη του «{ $extension }»; Αυτό το πρόσθετο δεν είναι επαληθευμένο. Τα κακόβουλα πρόσθετα μπορούν να υποκλέψουν τις προσωπικές σας πληροφορίες ή να θέσουν σε κίνδυνο τον υπολογιστή σας. Προσθέστε το μόνο εάν εμπιστεύεστε την προέλευσή του. Η επέκταση θα έχει την άδεια για:
webext-perms-sideload-header = Το { $extension } προστέθηκε
webext-perms-optional-perms-header = Το { $extension } απαιτεί επιπρόσθετα δικαιώματα.

##

webext-perms-add =
    .label = Προσθήκη
    .accesskey = Π
webext-perms-cancel =
    .label = Ακύρωση
    .accesskey = Α

webext-perms-sideload-text = Κάποιο πρόγραμμα του υπολογιστή σας εγκατέστησε ένα πρόσθετο που ενδέχεται να επηρεάσει το πρόγραμμα περιήγησής σας. Παρακαλώ ελέγξτε τα αιτήματα δικαιωμάτων του προσθέτου και επιλέξτε «Ενεργοποίηση» ή «Ακύρωση» (για να παραμείνει ανενεργό).
webext-perms-sideload-text-no-perms = Κάποιο πρόγραμμα του υπολογιστή σας εγκατέστησε ένα πρόσθετο που ενδέχεται να επηρεάσει το πρόγραμμα περιήγησής σας. Παρακαλώ επιλέξτε «Ενεργοποίηση» ή «Ακύρωση» (για να παραμείνει ανενεργό).
webext-perms-sideload-enable =
    .label = Ενεργοποίηση
    .accesskey = Ε
webext-perms-sideload-cancel =
    .label = Ακύρωση
    .accesskey = Α

# Variables:
#   $extension (String): replaced with the localized name of the extension.
webext-perms-update-text = Το { $extension } έχει ενημερωθεί. Πρέπει να εγκρίνετε τα νέα δικαιώματα πριν εγκατασταθεί η ενημερωμένη έκδοση. Αν επιλέξετε «Ακύρωση», θα διατηρηθεί η τρέχουσα έκδοση της επέκτασης. Η επέκταση θα έχει την άδεια για:
webext-perms-update-accept =
    .label = Ενημέρωση
    .accesskey = Ε

webext-perms-optional-perms-list-intro = Επιθυμεί την άδεια για:
webext-perms-optional-perms-allow =
    .label = Αποδοχή
    .accesskey = Α
webext-perms-optional-perms-deny =
    .label = Άρνηση
    .accesskey = ρ

webext-perms-host-description-all-urls = Πρόσβαση στα δεδομένα σας για κάθε ιστότοπο

# Variables:
#   $domain (String): will be replaced by the DNS domain for which a webextension is requesting access (e.g., mozilla.org)
webext-perms-host-description-wildcard = Πρόσβαση στα δεδομένα σας για ιστοτόπους του τομέα { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-wildcards =
    { $domainCount ->
        [one] Πρόσβαση στα δεδομένα σας σε { $domainCount } ακόμα τομέα
       *[other] Πρόσβαση στα δεδομένα σας για { $domainCount } ακόμα τομείς
    }
# Variables:
#   $domain (String): will be replaced by the DNS host name for which a webextension is requesting access (e.g., www.mozilla.org)
webext-perms-host-description-one-site = Πρόσβαση στα δεδομένα σας για το { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-sites =
    { $domainCount ->
        [one] Πρόσβαση στα δεδομένα σας σε { $domainCount } ακόμα ιστότοπο
       *[other] Πρόσβαση στα δεδομένα σας σε { $domainCount } ακόμα ιστοτόπους
    }

## Headers used in the webextension permissions dialog for synthetic add-ons.
## The part of the string describing what privileges the extension gives should be consistent
## with the value of webext-site-perms-description-gated-perms-{sitePermission}.
## Note, this string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $hostname (String): the hostname of the site the add-on is being installed from.

webext-site-perms-header-with-gated-perms-midi = Αυτό το πρόσθετο παρέχει στο { $hostname } πρόσβαση στις συσκευές MIDI σας.
webext-site-perms-header-with-gated-perms-midi-sysex = Αυτό το πρόσθετο παρέχει στο { $hostname } πρόσβαση στις συσκευές MIDI σας (με υποστήριξη SysEx).

##

# This string is used as description in the webextension permissions dialog for synthetic add-ons.
# Note, the empty line is used to create a line break between the two sections.
# Note, this string will be used as raw markup. Avoid characters like <, >, &
webext-site-perms-description-gated-perms-midi =
    Αυτές είναι συνήθως εξωτερικές συσκευές, όπως συνθεσάιζερ ήχου, αλλά ενδέχεται επίσης να είναι ενσωματωμένες στον υπολογιστή σας.
    
    Γενικά, δεν επιτρέπεται στους ιστοτόπους η πρόσβαση σε συσκευές MIDI. Η ακατάλληλη χρήση μπορεί να προκαλέσει βλάβες ή να θέσει σε κίνδυνο την ασφάλειά σας.

## Headers used in the webextension permissions dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension being installed.
##   $hostname (String): will be replaced by the DNS host name for which a webextension enables permissions.

webext-site-perms-header-with-perms = Προσθήκη του «{ $extension }»; Αυτή η επέκταση παραχωρεί τις εξής δυνατότητες στο { $hostname }:
webext-site-perms-header-unsigned-with-perms = Προσθήκη του { $extension }; Αυτό το πρόσθετο δεν είναι επαληθευμένο. Τα κακόβουλα πρόσθετα μπορούν να υποκλέψουν προσωπικές πληροφορίες ή να θέσουν σε κίνδυνο τον υπολογιστή σας. Προσθέστε το μόνο αν εμπιστεύεστε την προέλευσή του. Αυτή η επέκταση δίνει τις ακόλουθες δυνατότητες στο { $hostname }:

## These should remain in sync with permissions.NAME.label in sitePermissions.properties

webext-site-perms-midi = Πρόσβαση σε συσκευές MIDI
webext-site-perms-midi-sysex = Πρόσβαση σε συσκευές MIDI με υποστήριξη SysEx
