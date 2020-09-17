# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = מנהל משימות

## Column headers

column-name = שם
column-type = סוג
column-energy-impact = השפעה על צריכת חשמל
column-memory = זיכרון

## Special values for the Name column

ghost-windows = לשוניות שנסגרו לאחרונה
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = בטעינה מראש: { $title }

## Values for the Type column

type-tab = לשונית
type-subframe = תת־מסגרת
type-tracker = רכיב מעקב
type-addon = תוספת
type-browser = דפדפן
type-worker = Worker
type-other = אחר

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = גבוהה ({ $value })
energy-impact-medium = בינונית ({ $value })
energy-impact-low = נמוכה ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } ק״ב
size-MB = { $value } מ״ב
size-GB = { $value } ג״ב

## Tooltips for the action buttons

close-tab =
    .title = סגירת לשונית
show-addon =
    .title = הצגה במנהל התוספות

