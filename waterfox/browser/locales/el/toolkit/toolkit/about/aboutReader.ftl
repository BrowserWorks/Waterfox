# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-reader-loading = Φόρτωση…
about-reader-load-error = Απέτυχε η φόρτωση του άρθρου από τη σελίδα

about-reader-color-scheme-light = Ανοιχτόχρωμο
    .title = Ανοιχτόχρωμο σύνολο χρωμάτων
about-reader-color-scheme-dark = Σκοτεινό
    .title = Σκουρόχρωμο σύνολο χρωμάτων
about-reader-color-scheme-sepia = Σέπια
    .title = Σέπια σύνολο χρωμάτων
about-reader-color-scheme-auto = Αυτόματο
    .title = Αυτόματο σύνολο χρωμάτων

# An estimate for how long it takes to read an article,
# expressed as a range covering both slow and fast readers.
# Variables:
#   $rangePlural (String): The plural category of the range, using the same set as for numbers.
#   $range (String): The range of minutes as a localised string. Examples: "3-7", "~1".
about-reader-estimated-read-time =
    { $rangePlural ->
        [one] { $range } λεπτό
       *[other] { $range } λεπτά
    }

## These are used as tooltips in Type Control

about-reader-toolbar-minus =
    .title = Μείωση μεγέθους γραμματοσειράς
about-reader-toolbar-plus =
    .title = Αύξηση μεγέθους γραμματοσειράς
about-reader-toolbar-contentwidthminus =
    .title = Μείωση πλάτους περιεχομένου
about-reader-toolbar-contentwidthplus =
    .title = Αύξηση πλάτους περιεχομένου
about-reader-toolbar-lineheightminus =
    .title = Μείωση ύψους γραμμής
about-reader-toolbar-lineheightplus =
    .title = Αύξηση ύψους γραμμής

## These are the styles of typeface that are options in the reader view controls.

about-reader-font-type-serif = Serif
about-reader-font-type-sans-serif = Sans-serif

## Reader View toolbar buttons

about-reader-toolbar-close = Κλείσιμο προβολής ανάγνωσης
about-reader-toolbar-type-controls = Ρυθμίσεις τυπογραφίας
about-reader-toolbar-savetopocket = Αποθήκευση στο { -pocket-brand-name }
