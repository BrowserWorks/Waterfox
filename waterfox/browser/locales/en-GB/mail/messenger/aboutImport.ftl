# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = Import
export-page-title = Export

## Header

import-start = Import Tool
import-start-title = Import settings or data from an application or a file.
import-start-description = Select the source from which you want to import. You will later be asked to choose which data needs to be imported.
import-from-app = Import from Application
import-file = Import from a file
import-file-title = Select a file to import its content.
import-file-description = Choose to import a previously backed up profile, address books or calendars.
import-address-book-title = Import Address Book file
import-calendar-title = Import Calendar file
export-profile = Export

## Buttons

button-back = Back
button-continue = Continue
button-export = Export
button-finish = Finish

## Import from app steps

app-name-thunderbird = Thunderbird
app-name-seamonkey = SeaMonkey
app-name-outlook = Outlook
app-name-becky = Becky! Internet Mail
app-name-apple-mail = Apple Mail
source-thunderbird = Import from another { app-name-thunderbird } installation
source-thunderbird-description = Import settings, filters, messages, and other data from a { app-name-thunderbird } profile.
source-seamonkey = Import from a { app-name-seamonkey } installation
source-seamonkey-description = Import settings, filters, messages, and other data from a { app-name-seamonkey } profile.
source-outlook = Import from { app-name-outlook }
source-outlook-description = Import accounts, address books, and messages from { app-name-outlook }.
source-becky = Import from { app-name-becky }
source-becky-description = Import address books and messages from { app-name-becky }.
source-apple-mail = Import from { app-name-apple-mail }
source-apple-mail-description = Import messages from { app-name-apple-mail }.
source-file2 = Import from a file
source-file-description = Select a file to import address books, calendars, or a profile backup (ZIP file).

## Import from file selections

file-profile2 = Import Backed-up Profile
file-profile-description = Select a previously backed up Thunderbird profile (.zip)
file-calendar = Import Calendars
file-calendar-description = Select a file containing exported Calendars or Events (.ics)
file-addressbook = Import Address Books
file-addressbook-description = Select a file containing exported Address Books and Contacts

## Import from app profile steps

from-app-thunderbird = Import from a { app-name-thunderbird } profile
from-app-seamonkey = Import from a { app-name-seamonkey } profile
from-app-outlook = Import from { app-name-outlook }
from-app-becky = Import from { app-name-becky }
from-app-apple-mail = Import from { app-name-apple-mail }
profiles-pane-title-thunderbird = Import Settings and Data from a { app-name-thunderbird } profile.
profiles-pane-title-seamonkey = Import Settings and Data from a { app-name-seamonkey } profile.
profiles-pane-title-outlook = Import Data from { app-name-outlook }.
profiles-pane-title-becky = Import Data from { app-name-becky }.
profiles-pane-title-apple-mail = Import Messages from { app-name-apple-mail }.
profile-source = Import from profile
# $profileName (string) - name of the profile
profile-source-named = Import from profile <strong>"{ $profileName }"</strong>
profile-file-picker-directory = Choose a profile folder
profile-file-picker-archive = Choose a <strong>ZIP</strong> file
profile-file-picker-archive-description = The ZIP file must be smaller than 2GB.
profile-file-picker-archive-title = Choose a ZIP file (smaller than 2GB)
items-pane-title2 = Choose what to import:
items-pane-directory = Directory:
items-pane-profile-name = Profile name:
items-pane-checkbox-accounts = Accounts and Settings
items-pane-checkbox-address-books = Address Books
items-pane-checkbox-calendars = Calendars
items-pane-checkbox-mail-messages = Mail Messages
items-pane-override = Any existing or identical data will not be overwritten.

## Import from address book file steps

import-from-addr-book-file-description = Choose the file format containing your Address Book data.
addr-book-csv-file = Comma or tab separated file (.csv, .tsv)
addr-book-ldif-file = LDIF file (.ldif)
addr-book-vcard-file = vCard file (.vcf, .vcard)
addr-book-sqlite-file = SQLite database file (.sqlite)
addr-book-mab-file = Mork database file (.mab)
addr-book-file-picker = Select an address book file
addr-book-csv-field-map-title = Match field names
addr-book-csv-field-map-desc = Select address book fields corresponding to the source fields. Untick fields you do not want to import.
addr-book-directories-title = Select where to import the chosen data
addr-book-directories-pane-source = Source file:
# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = Create a new directory called <strong>"{ $addressBookName }"</strong>
# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = Import the chosen data into the "{ $addressBookName }" directory
# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = A new address book called "{ $addressBookName }" will be created.

## Import from calendar file steps

import-from-calendar-file-desc = Select the iCalendar (.ics) file you would like to import.
calendar-items-title = Select which items to import.
calendar-items-loading = Loading items…
calendar-items-filter-input =
    .placeholder = Filter items…
calendar-select-all-items = Select all
calendar-deselect-all-items = Deselect all
calendar-target-title = Select where to import the chosen items.
# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = Create a new calendar called <strong>"{ $targetCalendar }"</strong>
# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
    { $itemCount ->
        [one] Import one item into the "{ $targetCalendar }" calendar
       *[other] Import { $itemCount } items into the "{ $targetCalendar }" calendar
    }
# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = A new calendar called "{ $targetCalendar }" will be created.

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = Importing… { $progressPercent }
# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = Exporting… { $progressPercent }
progress-pane-finished-desc2 = Complete.
error-pane-title = Error
error-message-zip-file-too-big2 = The selected ZIP file is larger than 2GB. Please extract it first, then import from the extracted folder instead.
error-message-extract-zip-file-failed2 = Failed to extract the ZIP file. Please extract it manually, then import from the extracted folder instead.
error-message-failed = Import failed unexpectedly, more information may be available in the Error Console.
error-failed-to-parse-ics-file = No importable items found in the file.
error-export-failed = Export failed unexpectedly, more information may be available in the Error Console.
error-message-no-profile = No profile found.

## <csv-field-map> element

csv-first-row-contains-headers = First row contains field names
csv-source-field = Source field
csv-source-first-record = First record
csv-source-second-record = Second record
csv-target-field = Address book field

## Export tab

export-profile-title = Export accounts, messages, address books, and settings to a ZIP file.
export-profile-description = If your current profile is larger than 2GB, we suggest you back it up by yourself.
export-open-profile-folder = Open profile folder
export-file-picker2 = Export to a ZIP file
export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = Data to be imported
summary-pane-start = Start Import
summary-pane-warning = { -brand-product-name } will need to be restarted when importing is complete.
summary-pane-start-over = Restart Import Tool

## Footer area

footer-help = Need help?
footer-import-documentation = Import documentation
footer-export-documentation = Export documentation
footer-support-forum = Support forum

## Step navigation on top of the wizard pages

step-list =
    .aria-label = Import steps
step-confirm = Confirm
# Variables:
# $number (number) - step number
step-count = { $number }
