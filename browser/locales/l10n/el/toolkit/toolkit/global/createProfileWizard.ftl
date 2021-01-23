# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Οδηγός δημιουργίας προφίλ
    .style = width: 52em; height: 35em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Εισαγωγή
       *[other] Καλώς ήλθατε στο { create-profile-window.title }
    }

profile-creation-explanation-1 = Το { -brand-short-name } αποθηκεύει πληροφορίες σχετικά με τις ρυθμίσεις και τις προτιμήσεις σας στο προσωπικό σας προφίλ.

profile-creation-explanation-2 = Αν μοιράζεστε αυτό το αντίγραφο του { -brand-short-name } με άλλους χρήστες, μπορείτε να χρησιμοποιήσετε τα προφίλ για να έχει ο κάθε χρήστης ξεχωριστές πληροφορίες. Για να το κάνετε αυτό, ο κάθε χρήστης θα πρέπει να δημιουργήσει το δικό του προφίλ.

profile-creation-explanation-3 = Αν είστε ο μόνος χρήστης αυτού του αντιγράφου του { -brand-short-name }, θα πρέπει να δημιουργήσετε τουλάχιστον ένα προφίλ. Αν θέλετε, μπορείτε να δημιουργήσετε πολλαπλά προφίλ για τον εαυτό σας, ώστε να αποθηκεύετε διαφορετικά σύνολα ρυθμίσεων και προτιμήσεων. Για παράδειγμα, ίσως να θέλετε να έχετε ξεχωριστά προφίλ για προσωπική και επαγγελματική χρήση.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Για να ξεκινήσετε τη δημιουργία του προφίλ σας, κάντε κλικ στο Συνέχεια.
       *[other] Για να ξεκινήσετε τη δημιουργία του προφίλ σας, κάντε κλικ στο Επόμενο.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Επίλογος
       *[other] Ολοκλήρωση του { create-profile-window.title }
    }

profile-creation-intro = Αν δημιουργήσετε πολλά προφίλ, μπορείτε να τα ξεχωρίζετε από το όνομά τους. Μπορείτε να επιλέξτε το προεπιλεγμένο όνομα ή να δημιουργήσετε το δικό σας.

profile-prompt = Εισάγετε το όνομα του νέου προφίλ:
    .accesskey = Ε

profile-default-name =
    .value = Προεπιλεγμένος χρήστης

profile-directory-explanation = Οι ρυθμίσεις, οι προτιμήσεις, οι σελιδοδείκτες και άλλα σχετικά δεδομένα χρήστη θα αποθηκευτούν εδώ:

create-profile-choose-folder =
    .label = Επιλογή φακέλου…
    .accesskey = λ

create-profile-use-default =
    .label = Χρήση προεπιλεγμένου φακέλου
    .accesskey = ρ
