# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

calendar-ics-file-window-2 =
    .title = Import Calendar Events and Tasks
calendar-ics-file-dialog-import-event-button-label = Import Event
calendar-ics-file-dialog-import-task-button-label = Import Task
calendar-ics-file-dialog-2 =
    .buttonlabelaccept = Import All
calendar-ics-file-accept-button-ok-label = OK
calendar-ics-file-cancel-button-close-label = Close
calendar-ics-file-dialog-message-2 = Import from file:
calendar-ics-file-dialog-calendar-menu-label = Import into calendar:
calendar-ics-file-dialog-items-loading-message =
    .value = Loading items…
calendar-ics-file-dialog-search-input =
    .placeholder = Filter items…
calendar-ics-file-dialog-sort-start-ascending =
    .label = Sort by start date (first to last)
calendar-ics-file-dialog-sort-start-descending =
    .label = Sort by start date (last to first)
# "A > Z" is used as a concise way to say "alphabetical order".
# You may replace it with something appropriate to your language.
calendar-ics-file-dialog-sort-title-ascending =
    .label = Sort by title (A > Z)
# "Z > A" is used as a concise way to say "reverse alphabetical order".
# You may replace it with something appropriate to your language.
calendar-ics-file-dialog-sort-title-descending =
    .label = Sort by title (Z > A)
calendar-ics-file-dialog-progress-message = Importing…
calendar-ics-file-import-success = Successfully imported!
calendar-ics-file-import-error = An error occurred and the import failed.
calendar-ics-file-import-complete = Import complete.
calendar-ics-file-import-duplicates =
    { $duplicatesCount ->
        [one] One item was ignored since it already exists in the destination calendar.
       *[other] { $duplicatesCount } items were ignored since they already exist in the destination calendar.
    }
calendar-ics-file-import-errors =
    { $errorsCount ->
        [one] One item failed to import. Check the Error Console for details.
       *[other] { $errorsCount } items failed to import. Check the Error Console for details.
    }
calendar-ics-file-dialog-no-calendars = There are no calendars that can import events or tasks.
