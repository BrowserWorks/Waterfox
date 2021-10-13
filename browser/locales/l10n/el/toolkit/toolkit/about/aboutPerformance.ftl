# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Διαχείριση εργασιών

## Column headers

column-name = Όνομα
column-type = Τύπος
column-energy-impact = Αντίκτυπο ενέργειας
column-memory = Μνήμη

## Special values for the Name column

ghost-windows = Πρόσφατα κλεισμένες καρτέλες
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Προφορτωμένη: { $title }

## Values for the Type column

type-tab = Καρτέλα
type-subframe = Υποπλαίσιο
type-tracker = Ιχνηλάτης
type-addon = Πρόσθετο
type-browser = Πρόγραμμα περιήγησης
type-worker = Worker
type-other = Άλλο

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Υψηλό ({ $value })
energy-impact-medium = Μέτριο ({ $value })
energy-impact-low = Χαμηλό ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Κλείσιμο καρτέλας
show-addon =
    .title = Εμφάνιση στη Διαχείριση προσθέτων

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Αποστολές από τη φόρτωση: { $totalDispatches } ({ $totalDuration }ms)
        Αποστολές τα τελευταία δευτερόλεπτα: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
