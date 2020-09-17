# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-show-current-data = נתונים נוכחיים
about-telemetry-choose-ping = בחירת פינג:
about-telemetry-archive-ping-header = פינג
about-telemetry-option-group-today = היום
about-telemetry-option-group-yesterday = אתמול
about-telemetry-option-group-older = ישן יותר
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = נתוני Telemetry
about-telemetry-more-information = בחיפוש אחר מידע נוסף?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">תיעוד הנתונים של Firefox</a> מכיל מדריכים על אופן העבודה עם כלי הנתונים שלנו.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">תיעוד הלקוח של Firefox Telemetry</a> כולל הגדרות לשיטות, תיעוד API והפניות למידע.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">לוחות הבקרה של Telemetry</a> מאפשרים לך לראות באופן חזותי את הנתונים ש־Mozilla מקבלת דרך Telemetry.
about-telemetry-show-in-Firefox-json-viewer = פתיחה במציג ה־JSON
about-telemetry-home-section = בית
about-telemetry-general-data-section = מידע כללי
about-telemetry-environment-data-section = נתונים סביבתיים
about-telemetry-session-info-section = פרטי הפעלה
about-telemetry-histograms-section = היסטוגרמות
about-telemetry-keyed-histogram-section = היסטוגרמות ממופתחות
about-telemetry-events-section = אירועים
about-telemetry-simple-measurements-section = מדדים פשוטים
about-telemetry-slow-sql-section = משפטי SQL איטיים
about-telemetry-addon-details-section = פרטי תוספות
about-telemetry-captured-stacks-section = מחסניות שנלכדו
about-telemetry-late-writes-section = כתיבה מאוחרת
about-telemetry-raw-payload-section = מטען גולמי
about-telemetry-raw = JSON גולמי
about-telemetry-full-sql-warning = הערה: ניפוי שגיאות עבור משפטי SQL איטיים פעילה. מחרוזות SQL מלאות אמנם יוצגו, אבל הן לא תישלחנה אל Telemetry.
about-telemetry-hide-stack-symbols = הצגת נתוני מחסנית גולמיים
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] נתוני הפצה
       *[prerelease] נתוני קדם הפצה
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] מופעלת
       *[disabled] מושבתת
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = עמוד זה מציג מידע על ביצועים, חומרה, שימוש והתאמות אישיות כפי שנאספו על־ידי Telemetry. מידע זה נשלח אל { $telemetryServerOwner } כדי לסייע בשיפור { -brand-full-name }.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = חיפוש תחת { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = חיפוש בכל הסעיפים
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = תוצאות עבור “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = מצטערים! אין תוצאות ב־{ $sectionName } עבור הביטוי “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = מצטערים! אין תוצאות בכל הסעיפים עבור הביטוי “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = מצטערים! כרגע אין נתונים זמינים ב־“{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = נתונים נוכחיים
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = הכל
# button label to copy the histogram
about-telemetry-histogram-copy = העתקה
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = פקודות SQL אטיות בתהליכון הראשי
about-telemetry-slow-sql-other = פקודות SQL אטיות בתהליכוני העזר
about-telemetry-slow-sql-hits = תוצאות
about-telemetry-slow-sql-average = זמן ממוצע (מ״ש)
about-telemetry-slow-sql-statement = פקודה
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = מזהה תוספת
about-telemetry-addon-table-details = פרטים
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = ספק { $addonProvider }
about-telemetry-keys-header = מאפיין
about-telemetry-names-header = שם
about-telemetry-values-header = ערך
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (ספירת לכידות: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = כתיבה מאוחרת #{ $lateWriteCount }
about-telemetry-stack-title = מחסנית:
about-telemetry-memory-map-title = מפת זיכרון:
about-telemetry-error-fetching-symbols = אירעה שגיאה במהלך אחזור הסמלים. נא לוודא שהחיבור לאינטרנט תקין ולנסות שוב.
about-telemetry-time-stamp-header = ‏‏חותמת זמן
about-telemetry-category-header = קטגוריה
about-telemetry-method-header = שיטה
about-telemetry-object-header = עצם
about-telemetry-extra-header = תוספת
