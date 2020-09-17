# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = מנהל התוספות
addons-page-title = מנהל התוספות

search-header =
    .placeholder = חיפוש ב־addons.mozilla.org
    .searchbuttonlabel = חיפוש

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = לא הותקנה אף תוספת מסוג זה

list-empty-available-updates =
    .value = לא נמצאו עדכונים

list-empty-recent-updates =
    .value = לא עדכנת תוספות כלשהן לאחרונה

list-empty-find-updates =
    .label = בדיקה אחר עדכונים

list-empty-button =
    .label = מידע נוסף על תוספות

help-button = תמיכה בתוספות
sidebar-help-button-title =
    .title = תמיכה בתוספות

preferences =
    { PLATFORM() ->
        [windows] אפשרויות של { -brand-short-name }
       *[other] העדפות של { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] אפשרויות של { -brand-short-name }
           *[other] העדפות של { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = אין אפשרות לאמת חלק מההרחבות

show-all-extensions-button =
    .label = הצגת כל ההרחבות

cmd-show-details =
    .label = הצגת מידע נוסף
    .accesskey = ה

cmd-find-updates =
    .label = בדיקת עדכונים
    .accesskey = מ

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] אפשרויות
           *[other] העדפות
        }
    .accesskey =
        { PLATFORM() ->
            [windows] א
           *[other] ה
        }

cmd-enable-theme =
    .label = לבש ערכת נושא
    .accesskey = ל

cmd-disable-theme =
    .label = הפסק ללבוש ערכת נושא
    .accesskey = ה

cmd-install-addon =
    .label = התקנה
    .accesskey = ה

cmd-contribute =
    .label = תרומה
    .accesskey = ת
    .tooltiptext = מתן תרומה לפיתוח תוספת זו

detail-version =
    .label = גרסה

detail-last-updated =
    .label = עודכן לאחרונה

detail-contributions-description = המפתחים של תוספת זו מבקשים את עזרתך בהמשך הפיתוח שלה על־ידי מתן תרומה צנועה.

detail-contributions-button = תרומה
    .title = מתן תרומה לפיתוח תוספת זו
    .accesskey = ת

detail-update-type =
    .value = עדכונים אוטומטיים

detail-update-default =
    .label = בררת מחדל
    .tooltiptext = התקנת עדכונים באופן אוטומטי רק אם זו בררת המחדל

detail-update-automatic =
    .label = פעיל
    .tooltiptext = התקן עדכונים אוטומטית

detail-update-manual =
    .label = כבוי
    .tooltiptext = אל תתקין עדכונים אוטומטית

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = הפעלה בחלונות פרטיים

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = לא מופעלת בחלונות פרטיים
detail-private-disallowed-description2 = הרחבה זו לא פועלת בזמן גלישה פרטית. <a data-l10n-name="learn-more">מידע נוסף</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = דורשת גישה לחלונות פרטיים
detail-private-required-description2 = להרחבה זו יש גישה לפעילויות המקוונות שלך בזמן גלישה פרטית. <a data-l10n-name="learn-more">מידע נוסף</a>

detail-private-browsing-on =
    .label = לאפשר
    .tooltiptext = הפעלה בגלישה פרטית

detail-private-browsing-off =
    .label = לא לאפשר
    .tooltiptext = נטרול בגלישה פרטית

detail-home =
    .label = דף הבית

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = פרופיל התוספת

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = בדיקה אחר עדכונים
    .accesskey = ב
    .tooltiptext = בדיקת עדכונים לתוספת זו

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] אפשרויות
           *[other] העדפות
        }
    .accesskey =
        { PLATFORM() ->
            [windows] א
           *[other] ה
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] שינוי האפשרויות של תוספת זו
           *[other] שינוי העדפות של תוספת זו
        }

detail-rating =
    .value = דירוג

addon-restart-now =
    .label = הפעלה מחדש כעת

disabled-unsigned-heading =
    .value = חלק מהתוספות נוטרלו

disabled-unsigned-description = התוספות הבאות לא אומתו לשימוש ב־{ -brand-short-name }. באפשרותך <label data-l10n-name="find-addons">לחפש חלופות</label> או לפנות למפתחים בדרישה לאמת אותן.

disabled-unsigned-learn-more = מידע נוסף על המאמצים שלנו לשמור על המשתמשים שלנו בטוחים ברשת.

disabled-unsigned-devinfo = מפתחים המעוניינים לאמת את התוספות שלהם מתבקשים לעיין <label data-l10n-name="learn-more">במדריך</label> שלנו.

plugin-deprecation-description = חסר כאן משהו? חלק מהתוספים החיצוניים אינם נתמכים עוד ב־{ -brand-short-name }. <label data-l10n-name="learn-more">למידע נוסף.</label>

legacy-warning-show-legacy = הצגת הרחבות דור קודם

legacy-extensions =
    .value = הרחבות מדור קודם

legacy-extensions-description = הרחבות אלו לא עומדות בתקנים הנוכחיים של { -brand-short-name } ולכן כובו. <label data-l10n-name="legacy-learn-more">מידע נוסף על השינויים בתוספות</label>

private-browsing-description2 =
    ‏{ -brand-short-name } משנה את האופן שבו הרחבות פועלות בגלישה פרטית. כל הרחבה חדשה שתתווסף אל { -brand-short-name } לא תרוץ כברירת מחדל בחלונות פרטיים. כל עוד אפשרות זו לא תופעל בהגדרות, ההרחבה לא תפעל בזמן גלישה פרטית, ולא תהיה לה גישה לפעילויות המקוונות שלך שם. עשינו את השינוי הזה כדי לשמור על הגלישה הפרטית שלך פרטית.
    <label data-l10n-name="private-browsing-learn-more">מידע נוסף על ניהול הגדרות הרחבות.</label>

addon-category-discover = המלצות
addon-category-discover-title =
    .title = המלצות
addon-category-extension = הרחבות
addon-category-extension-title =
    .title = הרחבות
addon-category-theme = ערכות נושא
addon-category-theme-title =
    .title = ערכות נושא
addon-category-plugin = תוספים חיצוניים
addon-category-plugin-title =
    .title = תוספים חיצוניים
addon-category-dictionary = מילונים
addon-category-dictionary-title =
    .title = מילונים
addon-category-locale = שפות
addon-category-locale-title =
    .title = שפות
addon-category-available-updates = עדכונים זמינים
addon-category-available-updates-title =
    .title = עדכונים זמינים
addon-category-recent-updates = עדכונים אחרונים
addon-category-recent-updates-title =
    .title = עדכונים אחרונים

## These are global warnings

extensions-warning-safe-mode = כל התוספות נוטרלו במצב בטוח.
extensions-warning-check-compatibility = בדיקת תאימות תוספות מנוטלת. ייתכן שברשותך תוספות לא תואמות.
extensions-warning-check-compatibility-button = הפעלה
    .title = הפעלת בדיקת תאימות תוספות
extensions-warning-update-security = בדיקת האבטחה של התוספות כרגע מנוטרלת. עדכונים לתוספות עלולים לסכן אותך.
extensions-warning-update-security-button = הפעלה
    .title = הפעלת בדיקות אבטחה לעדכוני תוספות


## Strings connected to add-on updates

addon-updates-check-for-updates = בדיקה אחר עדכונים
    .accesskey = ב
addon-updates-view-updates = הצגת עדכונים אחרונים
    .accesskey = ה

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = עדכון תוספות אוטומטי
    .accesskey = ע

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = איפוס כל התוספות לעדכון אוטומטי
    .accesskey = א
addon-updates-reset-updates-to-manual = איפוס כל התוספות לעדכון ידני
    .accesskey = א

## Status messages displayed when updating add-ons

addon-updates-updating = מעדכן תוספות
addon-updates-installed = התוספות שלך עודכנו.
addon-updates-none-found = לא נמצאו עדכונים
addon-updates-manual-updates-found = הצגת עדכונים זמינים

## Add-on install/debug strings for page options menu

addon-install-from-file = התקנת תוספת מקובץ…
    .accesskey = ה
addon-install-from-file-dialog-title = בחירת תוספת להתקנה
addon-install-from-file-filter-name = תוספות
addon-open-about-debugging = ניפוי שגיאות של תוספות
    .accesskey = נ

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = ניהול קיצורי דרך להרחבות
    .accesskey = ק

shortcuts-no-addons = אין לך הרחבות מופעלות.
shortcuts-no-commands = להרחבות הבאות אין קיצורי דרך:
shortcuts-input =
    .placeholder = נא להקליד קיצור דרך

shortcuts-browserAction2 = הפעלת הכפתור בסרגל הכלים
shortcuts-pageAction = הפעלת פעולת דף
shortcuts-sidebarAction = הצגה/הסתרה של סרגל הצד

shortcuts-modifier-mac = יש לכלול Ctrl, ‏Alt או ⌘
shortcuts-modifier-other = יש לכלול Ctrl או Alt
shortcuts-invalid = שילוב לא חוקי
shortcuts-letter = נא להקליד אות
shortcuts-system = לא ניתן לדרוס קיצור דרך של { -brand-short-name }

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = קיצור דרך כפול

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } משמש כקיצור דרך ביותר ממקרה אחד. קיצורי דרך כפולים עשויים לגרום להתנהגות בלתי צפויה.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = כבר בשימוש על־ידי { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] הצגת אחד נוסף
       *[other] הצגת { $numberToShow } נוספים
    }

shortcuts-card-collapse-button = הצגת פחות

header-back-button =
    .title = חזרה אחורה

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = הרחבות הן כמו יישומים לדפדפן שלך, ומאפשרות לך להגן על ססמאות, להוריד סרטונים, למצוא מבצעים, לחסום פרסומות מציקות, לשנות את תצוגת הדפדפן שלך ועוד. היישומים הקטנים האלו לרוב מפותחים על־ידי גורמי צד־שלישי. להלן מבחר הרחבות ש־{ -brand-product-name } <a data-l10n-name="learn-more-trigger">ממליצה</a> עליהן בגלל האבטחה, הביצועים והפונקציונליות יוצאת הדופן שלהן.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = חלק מהמלצות אלה מותאמות אישית. הן מבוססות על הרחבות אחרות שהתקנת, העדפות פרופיל וסטטיסטיקת שימוש.
discopane-notice-learn-more = מידע נוסף

privacy-policy = מדיניות פרטיות

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = מאת <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = משתמשים: { $dailyUsers }
install-extension-button = הוספה אל { -brand-product-name }
install-theme-button = התקנת ערכת נושא
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = ניהול
find-more-addons = חיפוש תוספות נוספות

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = אפשרויות נוספות

## Add-on actions

report-addon-button = דיווח
remove-addon-button = הסרה
# The link will always be shown after the other text.
remove-addon-disabled-button = לא ניתן להסרה <a data-l10n-name="link">למה?</a>
disable-addon-button = השבתה
enable-addon-button = הפעלה
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = הפעלה
preferences-addon-button =
    { PLATFORM() ->
        [windows] אפשרויות
       *[other] העדפות
    }
details-addon-button = פרטים
release-notes-addon-button = הערות שחרור
permissions-addon-button = הרשאות

ask-to-activate-button = בקשת אישור להפעלה
always-activate-button = הפעלה תמיד
never-activate-button = לא להפעיל לעולם

addon-detail-author-label = מפתח
addon-detail-version-label = גרסה
addon-detail-last-updated-label = עדכון אחרון
addon-detail-homepage-label = דף הבית
addon-detail-rating-label = דירוג

# Message for add-ons with a staged pending update.
install-postponed-message = הרחבה זו תתעדכן כש־{ -brand-short-name } יופעל מחדש.
install-postponed-button = עדכון כעת

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = דירוג { NUMBER($rating, maximumFractionDigits: 1) } מתוך 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = ‏{ $name } (מושבת)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] סקירה אחת
       *[other] { $numberOfReviews } סקירות
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = התוספת <span data-l10n-name="addon-name">{ $addon }</span> הוסרה.
pending-uninstall-undo-button = ביטול

addon-detail-updates-label = עדכונים אוטומטיים
addon-detail-updates-radio-default = ברירת מחדל
addon-detail-updates-radio-on = פעיל
addon-detail-updates-radio-off = כבוי
addon-detail-update-check-label = בדיקה אחר עדכונים
install-update-button = עדכון

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = מופעלת בחלונות פרטיים
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = אם אפשרות זו מופעלת, להרחבה תהיה גישה לפעילויות המקוונות שלך בזמן גלישה פרטית. <a data-l10n-name="learn-more">מידע נוסף</a>
addon-detail-private-browsing-allow = לאפשר
addon-detail-private-browsing-disallow = לא לאפשר

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = ‏{ -brand-product-name } ממליץ רק על הרחבות שעומדות בתקנים שלנו לאבטחה וביצועים
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = עדכונים זמינים
recent-updates-heading = עדכונים אחרונים

release-notes-loading = בטעינה…
release-notes-error = מצטערים, אירעה שגיאה במהלך טעינת הערות השחרור.

addon-permissions-empty = לתוספת זו לא נדרשות הרשאות

recommended-extensions-heading = הרחבות מומלצות
recommended-themes-heading = ערכות נושא מומלצות

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = גל של יצירתיות שוטף אותך? <a data-l10n-name="link">ניתן ליצור ערכת נושא משלך בעזרת Firefox Color.</a>

## Page headings

extension-heading = ניהול ההרחבות שלך
theme-heading = ניהול ערכות הנושא שלך
plugin-heading = ניהול התוספים החיצוניים שלך
dictionary-heading = ניהול המילונים שלך
locale-heading = ניהול השפות שלך
updates-heading = ניהול העדכונים שלך
discover-heading = התאמה אישית של ה־{ -brand-short-name } שלך
shortcuts-heading = ניהול קיצורי דרך להרחבות

default-heading-search-label = חיפוש תוספות נוספות
addons-heading-search-input =
    .placeholder = חיפוש ב־addons.mozilla.org

addon-page-options-button =
    .title = כלים עבור כל התוספות
