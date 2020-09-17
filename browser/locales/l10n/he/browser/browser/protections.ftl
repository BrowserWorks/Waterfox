# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } חסם רכיב מעקב אחד במהלך השבוע האחרון
       *[other] { -brand-short-name } חסם { $count } רכיבי מעקב במהלך השבוע האחרון
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] רכיב מעקב <b>אחד</b> נחסם מאז { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> רכיבי מעקב נחסמו מאז { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } ממשיך לחסום רכיבי מעקב בחלונות פרטיים, אך אינו שומר תיעוד על מה שנחסם.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = רכיבי מעקב ש־{ -brand-short-name } חסם השבוע

protection-report-webpage-title = לוח הגנות
protection-report-page-content-title = לוח הגנות
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = ‏{ -brand-short-name } יכול להגן על הפרטיות שלך מאחורי הקלעים בזמן הגלישה. להלן תקציר מותאם אישית של הגנות אלה, לרבות כלים המאפשרים להיות בשליטה על האבטחה המקוונת שלך.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = ‏{ -brand-short-name } מגן על הפרטיות שלך מאחורי הקלעים בזמן הגלישה. להלן תקציר מותאם אישית של הגנות אלה, לרבות כלים המאפשרים להיות בשליטה על האבטחה המקוונת שלך.

protection-report-settings-link = ניהול הגדרות הפרטיות והאבטחה שלך

etp-card-title-always = הגנת מעקב מתקדמת: תמיד פעילה
etp-card-title-custom-not-blocking = הגנת מעקב מתקדמת: כבויה
etp-card-content-description = { -brand-short-name } מונע באופן אוטומטי מחברות לעקוב אחריך בסתר ברחבי הרשת.
protection-report-etp-card-content-custom-not-blocking = כל ההגנות כבויות כרגע. ניתן לבחור באילו רכיבי מעקב יש לחסום על־ידי ניהול הגדרות ההגנות של { -brand-short-name }.
protection-report-manage-protections = ניהול הגדרות

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = היום

# This string is used to describe the graph for screenreader users.
graph-legend-description = גרף המכיל את המספר הכולל של כל סוג של רכיב מעקב שנחסם השבוע.

social-tab-title = רכיבי מעקב של מדיה חברתית
social-tab-contant = רשתות חברתיות מציבות רכיבי מעקב באתרים אחרים כדי לעקוב אחר מה שהינך עושה ורואה ברשת. זה מאפשר לחברות המדיה החברתית ללמוד עליך מעבר למה שבחרת לשתף בפרופילי המדיה החברתית שלך. <a data-l10n-name="learn-more-link">מידע נוסף</a>

cookie-tab-title = עוגיות מעקב חוצות אתרים
cookie-tab-content = עוגיות אלו עוקבות אחריך מאתר לאתר כדי לאסוף נתונים על הפעילויות המקוונות שלך. הן נוצרות על־ידי גורמי צד־שלישי כמו מפרסמים וחברות אנליטיות. חסימת עוגיות מעקב חוצות אתרים מפחיתה את מספר הפרסומות שעוקבות אחריך. <a data-l10n-name="learn-more-link">מידע נוסף</a>

tracker-tab-title = תוכן מעקב
tracker-tab-description = אתרים עשויים לטעון פרסומות חיצוניות, סרטונים ותכנים אחרים עם קוד מעקב. חסימת תוכן מעקב יכולה לסייע לאתרים להיטען מהר יותר, אך יתכן שמספר כפתורים, טפסים ושדות התחברות לא יעבדו. <a data-l10n-name="learn-more-link">מידע נוסף</a>

fingerprinter-tab-title = רכיבי זהות דיגיטלית

cryptominer-tab-title = כורי מטבעות דיגיטליים
cryptominer-tab-content = כורי מטבעות דיגיטליים משתמשים בכוח העיבוד של המערכת שלך כדי לכרות כסף דיגיטלי. תסריטי כריית מטבעות מרוקנים את הסוללה שלך, מאטים את המחשב שלך ומגדילים את חשבון החשמל שלך. <a data-l10n-name="learn-more-link">מידע נוסף</a>

protections-close-button2 =
    .aria-label = סגירה
    .title = סגירה
  
mobile-app-title = חסימת רכיבי מעקב של פרסומות ביותר מכשירים
mobile-app-card-content = ניתן להשתמש בדפדפן הנייד עם הגנה מובנית מפני מעקב של פרסומות.
mobile-app-links = דפדפן { -brand-product-name } עבור <a data-l10n-name="android-mobile-inline-link">Android</a> ו־<a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = אף ססמה לא תלך עוד לאיבוד
lockwise-title-logged-in2 = ניהול ססמאות
lockwise-header-content = { -lockwise-brand-name } מאחסן באופן מאובטח את הססמאות שלך בדפדפן.
lockwise-header-content-logged-in = אחסון וסנכרון הססמאות שלך באופן מאובטח לכל המכשירים שלך.
protection-report-save-passwords-button = שמירת ססמאות
    .title = שמירת ססמאות ב־{ -lockwise-brand-short-name }
protection-report-manage-passwords-button = ניהול ססמאות
    .title = ניהול ססמאות ב־{ -lockwise-brand-short-name }
lockwise-mobile-app-title = לקחת את הססמאות שלך לכל מקום
lockwise-no-logins-card-content = ניתן להשתמש בססמאות השמורות ב־{ -brand-short-name } בכל מכשיר.
lockwise-app-links = { -lockwise-brand-name } עבור <a data-l10n-name="lockwise-android-inline-link">Android</a> ו־<a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] יתכן שססמה אחת נחשפה בדליפת נתונים.
       *[other] יתכן ש־{ $count } ססמאות נחשפו בדליפת נתונים.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] ססמה אחת מאוחסנת בצורה מאובטחת.
       *[other] הססמאות שלך מאוחסנות בצורה מאובטחת.
    }
lockwise-how-it-works-link = איך זה עובד

turn-on-sync = הפעלת { -sync-brand-short-name }…
    .title = מעבר להעדפות סנכרון

monitor-title = קבלת התרעות על דליפות נתונים
monitor-link = איך זה עובד
monitor-header-content-no-account = ניתן לבדוק את { -monitor-brand-name } כדי לראות אם היית חלק מדליפת נתונים מוכרת, ולקבל התרעות לגבי דליפות חדשות.
monitor-header-content-signed-in = { -monitor-brand-name } מזהיר אותך אם המידע שלך נחשף בדליפת נתונים מוכרת.
monitor-sign-up-link = הרשמה להתרעות על דליפות
    .title = הרשמה להתרעות על דליפות ב־{ -monitor-brand-name }
auto-scan = נסרק באופן אוטומטי היום

monitor-emails-tooltip =
    .title = הצגת כתובות דוא״ל מנוטרות ב־{ -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = הצגת דליפות נתונים מוכרות ב־{ -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = הצגת ססמאות שנחשפו ב־{ -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] כתובת דוא״ל מנוטרת
       *[other] כתובות דוא״ל מנוטרות
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] דליפת נתונים מוכרת חשפה מידע עליך
       *[other] דליפות נתונים מוכרות חשפו מידע עליך
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] דליפת נתונים מוכרת אחת סומנה שטופלה
       *[other] דליפות נתונים מוכרות סומנו שטופלו
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] ססמה אחת נחשפה בכל הדליפות
       *[other] ססמאות נחשפו בכל הדליפות
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] ססמה אחת נחשפה בדליפות שטרם טופלו
       *[other] ססמאות נחשפו בדליפות שטרם טופלו
    }

monitor-no-breaches-title = חדשות טובות!
monitor-no-breaches-description = אין לך דליפות מוכרות. אם זה ישתנה, נודיע לך על כך.
monitor-view-report-link = הצגת דוח
    .title = טיפול בדליפות ב־{ -monitor-brand-short-name }
monitor-breaches-unresolved-title = טיפול בדליפות שלך
monitor-manage-breaches-link = ניהול דליפות
    .title = ניהול דליפות ב־{ -monitor-brand-short-name }
monitor-breaches-resolved-title = יופי! טיפלת בכל הדליפות המוכרות.
monitor-breaches-resolved-description = אם הדוא״ל שלך יופיע בדליפות חדשות כלשהן, נודיע לך על כך.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] דליפה { $numBreachesResolved } מתוך { $numBreaches } סומנה שטופלה
       *[other] { $numBreachesResolved } מתוך { $numBreaches } דליפות סומנו שטופלו
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% הושלמו

monitor-partial-breaches-motivation-title-start = התחלה נהדרת!
monitor-partial-breaches-motivation-description = ניתן לטפל בשאר הדליפות שלך ב־{ -monitor-brand-short-name }.
monitor-resolve-breaches-link = טיפול בדליפות
    .title = טיפול בדליפות ב־{ -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = רכיבי מעקב של מדיה חברתית
    .aria-label =
        { $count ->
            [one] רכיב מעקב אחד של מדיה חברתית ({ $percentage }%)
           *[other] { $count } רכיבי מעקב של מדיה חברתית ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = עוגיות מעקב חוצות אתרים
    .aria-label =
        { $count ->
            [one] עוגיית מעקב חוצת אתרים אחת ({ $percentage }%)
           *[other] { $count } עוגיות מעקב חוצות אתרים ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = תוכן מעקב
    .aria-label =
        { $count ->
            [one] תוכן מעקב אחד ({ $percentage }%)
           *[other] { $count } תכני מעקב ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = כורי מטבעות דיגיטליים
    .aria-label =
        { $count ->
            [one] כורה מטבעות דיגיטליים אחד ({ $percentage }%)
           *[other] { $count } כורי מטבעות דיגיטליים ({ $percentage }%)
        }
