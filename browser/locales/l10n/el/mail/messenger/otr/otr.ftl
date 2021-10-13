# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption-required-part1 = Προσπαθήσατε να στείλετε ένα μη κρυπτογραφημένο μήνυμα στον/στην { $name }. Σύμφωνα με την πολιτική, τα μη κρυπτογραφημένα μηνύματα δεν επιτρέπονται.

msgevent-encryption-required-part2 = Γίνεται προσπάθεια έναρξης ιδιωτικής συζήτησης. Το μήνυμά σας θα αποσταλεί εκ νέου όταν ξεκινήσει η ιδιωτική συνομιλία.
msgevent-encryption-error = Συνέβη ένα σφάλμα κατά την κρυπτογράφηση του μηνύματός σας. Το μήνυμα δεν απεστάλη.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection-ended = Ο/Η { $name } έχει ήδη κλείσει την κρυπτογραφημένη σύνδεση με εσάς. Για να μην στείλετε κατά λάθος κάποιο μήνυμα χωρίς κρυπτογράφηση, το μήνυμά σας δεν απεστάλη. Παρακαλώ τερματίστε ή επανεκκινήστε την κρυπτογραφημένη συνομιλία σας.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup-error = Προέκυψε σφάλμα κατά τη δημιουργία ιδιωτικής συνομιλίας με τον/την { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg-reflected = Λαμβάνετε τα δικά σας μηνύματα OTR. Είτε προσπαθείτε να μιλήσετε με τον εαυτό σας, είτε κάποιος αντανακλά τα μηνύματά σας πίσω σε εσάς.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg-resent = Το τελευταίο μήνυμα προς τον/την { $name } απεστάλη ξανά.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-not-private = Το κρυπτογραφημένο μήνυμα που ελήφθη από τον/την { $name } δεν είναι αναγνώσιμο, καθώς δεν έχετε αυτή τη στιγμή ιδιωτική επικοινωνία.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unreadable = Λάβατε ένα μη αναγνώσιμο κρυπτογραφημένο μήνυμα από τον/την { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-malformed = Λάβατε ένα μήνυμα δεδομένων με λανθασμένη μορφή από τον/την { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-rcvd = Ελήφθη μήνυμα heartbeat από τον/την { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-sent = Απεστάλη μήνυμα heartbeat στον/στην { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg-general-err = Προέκυψε απροσδόκητο σφάλμα κατά την προσπάθεια προστασίας της συνομιλίας σας με OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg-unencrypted = Το ακόλουθο μήνυμα που ελήφθη από τον/την { $name } δεν ήταν κρυπτογραφημένο: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unrecognized = Λάβατε ένα μη αναγνωρισμένο μήνυμα OTR από τον/την { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-for-other-instance = Ο/Η { $name } έχει αποστείλει μήνυμα που προορίζεται για διαφορετική συνεδρία. Αν έχετε συνδεθεί πολλαπλές φορές, μια άλλη συνεδρία ενδέχεται να έχει λάβει το μήνυμα.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-private = Ξεκίνησε η ιδιωτική συνομιλία με τον/την { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-unverified = Ξεκίνησε κρυπτογραφημένη, αλλά μη επαληθευμένη συνομιλία με τον/την { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still-secure = Έγινε επιτυχής ανανέωση της κρυπτογραφημένης συνομιλίας με τον/την { $name }.

error-enc = Παρουσιάστηκε σφάλμα κατά την κρυπτογράφηση του μηνύματος.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not-priv = Στείλατε κρυπτογραφημένα δεδομένα στον/στην { $name }, που δεν τα περίμενε.

error-unreadable = Μεταδώσατε ένα μη αναγνώσιμο, κρυπτογραφημένο μήνυμα.
error-malformed = Μεταδώσατε ένα μήνυμα δεδομένων με λανθασμένη μορφή.

resent = [απεστάλη ξανά]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = Ο/Η { $name } έληξε την κρυπτογραφημένη συνομιλία μαζί σας· πρέπει να κάνετε το ίδιο.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = Ο/Η { $name } έχει ζητήσει μια κρυπτογραφημένη συζήτηση εκτός καταγραφής (OTR). Ωστόσο, δεν έχετε άρθρωμα για να το υποστηρίξει αυτό. Δείτε το https://en.wikipedia.org/wiki/Off-the-Record_Messaging για περισσότερες πληροφορίες.
