# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = שליחת חיווי ”נא לא לעקוב” לאתרים שאין ברצונך שיעקבו אחריך
do-not-track-learn-more = מידע נוסף
do-not-track-option-default-content-blocking-known =
    .label = רק כאשר { -brand-short-name } מוגדר לחסום רכיבי מעקב מוכרים
do-not-track-option-always =
    .label = תמיד
pref-page-title =
    { PLATFORM() ->
        [windows] אפשרויות
       *[other] העדפות
    }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] חיפוש באפשרויות
           *[other] חיפוש בהעדפות
        }
managed-notice = הדפדפן שלך מנוהל על־ידי הארגון שלך.
pane-general-title = כללי
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = בית
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = חיפוש
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = פרטיות ואבטחה
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-experimental-title = ניסויים של { -brand-short-name }
category-experimental =
    .tooltiptext = ניסויים של { -brand-short-name }
pane-experimental-subtitle = נא להמשיך בזהירות
pane-experimental-search-results-header = ניסויים של { -brand-short-name }: נא להמשיך בזהירות
pane-experimental-description = שינוי העדפות התצורה המתקדמות עשוי להשפיע על הביצועים או אבטחה של { -brand-short-name }.
help-button-label = תמיכה ב־{ -brand-short-name }
addons-button-label = הרחבות וערכות נושא
focus-search =
    .key = f
close-button =
    .aria-label = סגירה

## Browser Restart Dialog

feature-enable-requires-restart = יש להפעיל את { -brand-short-name } מחדש כדי להפעיל תכונה זו.
feature-disable-requires-restart = יש להפעיל את { -brand-short-name } מחדש כדי להשבית תכונה זו.
should-restart-title = הפעלת { -brand-short-name } מחדש
should-restart-ok = הפעלת { -brand-short-name } מחדש כעת
cancel-no-restart-button = ביטול
restart-later = הפעלה מחדש מאוחר יותר

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = ההרחבה <img data-l10n-name="icon"/> { $name } שולטת על דף הבית שלך.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = ההרחבה <img data-l10n-name="icon"/> { $name } שולטת על דף הלשונית החדשה שלך.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = ההרחבה <img data-l10n-name="icon"/> { $name } שולטת על הגדרה זו.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = ההרחבה <img data-l10n-name="icon"/> { $name } שולטת על הגדרה זו.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = ההרחבה <img data-l10n-name="icon"/> { $name } הגדירה את מנוע החיפוש ברירת המחדל שלך.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = ההרחבה <img data-l10n-name="icon"/> { $name } דורשת שימוש במגירת לשוניות.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = ההרחבה <img data-l10n-name="icon"/> { $name } שולטת על הגדרה זו.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = ההרחבה <img data-l10n-name="icon"/> { $name } שולטת באופן החיבור של { -brand-short-name } לאינטרנט.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = להפעלת ההרחבה יש לגשת לתוספות <img data-l10n-name="addons-icon"/> בתפריט <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = תוצאות חיפוש
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] אין תוצאות באפשרויות לביטוי „<span data-l10n-name="query"></span>“, עמך הסליחה.
       *[other] אין תוצאות בהעדפות לביטוי „<span data-l10n-name="query"></span>“, עמך הסליחה.
    }
search-results-help-link = לעזרה נוספת, נא לפנות אל <a data-l10n-name="url">אתר התמיכה של { -brand-short-name }</a>

## General Section

startup-header = הפעלה
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = לאפשר ל־{ -brand-short-name } ול־Firefox לרוץ במקביל
use-firefox-sync = טיפ: פעולה זו מתאפשרת תודות ליצירה של שני פרופילים נפרדים. ניתן להשתמש ב־{ -sync-brand-short-name } כדי לסנכרן נתונים בניהם.
get-started-not-logged-in = התחברות אל { -sync-brand-short-name }…
get-started-configured = פתיחת מסך ההעדפות של { -sync-brand-short-name }
always-check-default =
    .label = תמיד לבדוק אם { -brand-short-name } הוא דפדפן ברירת המחדל
    .accesskey = ת
is-default = { -brand-short-name } הוא כרגע דפדפן ברירת המחדל שלך
is-not-default = { -brand-short-name } אינו דפדפן ברירת המחדל שלך
set-as-my-default-browser =
    .label = הגדרה כדפדפן ברירת המחדל…
    .accesskey = ב
startup-restore-previous-session =
    .label = שחזור הפעלה קודמת
    .accesskey = ש
startup-restore-warn-on-quit =
    .label = הצגת אזהרה בעת סגירת הדפדפן
disable-extension =
    .label = השבתת הרחבה
tabs-group-header = לשוניות
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab מחליף את הלשוניות לפי סדר השימוש בהן
    .accesskey = ל
open-new-link-as-tabs =
    .label = פתיחת קישורים בלשוניות במקום בחלונות חדשים
    .accesskey = ח
warn-on-close-multiple-tabs =
    .label = הצגת אזהרה בעת סגירת מספר לשוניות
    .accesskey = ז
warn-on-open-many-tabs =
    .label = הצגת אזהרה כאשר פתיחת מספר לשוניות עשויה להאט את { -brand-short-name }
    .accesskey = פ
switch-links-to-new-tabs =
    .label = מעבר מיידי בפתיחה של קישור בלשונית חדשה
    .accesskey = מ
show-tabs-in-taskbar =
    .label = הצגת תצוגה מקדימה של לשוניות בסרגל המשימות של Windows
    .accesskey = ת
browser-containers-enabled =
    .label = הפעלת מגירות לשוניות
    .accesskey = מ
browser-containers-learn-more = מידע נוסף
browser-containers-settings =
    .label = הגדרות…
    .accesskey = ג
containers-disable-alert-title = האם לסגור את כל מגירות הלשוניות?
containers-disable-alert-desc =
    { $tabCount ->
        [one] אם האפשרות „לשוניות מגירות” תבוטל כעת, מגירת לשונית אחת תיסגר. האם ברצונך לבטל את מגירות הלשוניות?
       *[other] אם האפשרות „לשוניות מגירות” תבוטל כעת, { $tabCount } מגירות לשוניות תסגרנה. האם ברצונך לבטל את מגירות הלשוניות?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] סגירת מגירת לשונית אחת
       *[other] סגירת { $tabCount } מגירות לשוניות
    }
containers-disable-alert-cancel-button = להשאיר מופעל
containers-remove-alert-title = האם להסיר מגירה זו?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] אם מגירה זו תוסר, לשונית אחת תיסגר. האם ברצונך להסיר מגירה זו?
       *[other] אם מגירה זו תוסר, { $count } לשוניות תסגרנה. האם ברצונך להסיר מגירה זו?
    }
containers-remove-ok-button = להסיר מגירה זו
containers-remove-cancel-button = לא להסיר מגירה זו

## General Section - Language & Appearance

language-and-appearance-header = שפה ותצוגה
fonts-and-colors-header = גופנים וצבעים
default-font = גופן ברירת מחדל
    .accesskey = ב
default-font-size = גודל
    .accesskey = ג
advanced-fonts =
    .label = מתקדם…
    .accesskey = מ
colors-settings =
    .label = צבעים…
    .accesskey = צ
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = מרחק מתצוגה
preferences-default-zoom = מרחק מתצוגה ברירת מחדל
    .accesskey = ת
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = שינוי גודל טקסט בלבד
    .accesskey = ט
language-header = שפה
choose-language-description = בחירת השפה המועדפת עליך להצגת דפים
choose-button =
    .label = בחירה…
    .accesskey = ב
choose-browser-language-description = נא לבחור את השפות בהן ייעשה שימוש להצגת תפריטים, הודעות והתרעות מ־{ -brand-short-name }.
manage-browser-languages-button =
    .label = הגדרת חלופות…
    .accesskey = ח
confirm-browser-language-change-description = יש להפעיל את { -brand-short-name } מחדש כדי להחיל את השינויים האלה
confirm-browser-language-change-button = החלה והפעלה מחדש
translate-web-pages =
    .label = תרגום תוכן רשת
    .accesskey = ת
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = תרגום של <img data-l10n-name="logo"/>
translate-exceptions =
    .label = חריגות…
    .accesskey = ג
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = שימוש בהגדרות מערכת ההפעלה שלך עבור ״{ $localeName }״ כדי לעצב תאריכים, זמנים, מספרים ומידות.
check-user-spelling =
    .label = בדיקת איות תוך כדי הקלדה
    .accesskey = ב

## General Section - Files and Applications

files-and-applications-title = קבצים ויישומים
download-header = הורדות
download-save-to =
    .label = שמירת קבצים אל
    .accesskey = ק
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] בחירה…
           *[other] עיון…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ב
           *[other] י
        }
download-always-ask-where =
    .label = לשאול תמיד היכן לשמור קבצים
    .accesskey = ק
applications-header = יישומים
applications-description = בחירה כיצד { -brand-short-name } יטפל בקבצים שהורדו מהרשת או ביישומים שיהיו בשימוש במהלך הגלישה.
applications-filter =
    .placeholder = חיפוש סוגי קבצים או יישומים
applications-type-column =
    .label = סיווג תוכן
    .accesskey = ס
applications-action-column =
    .label = פעולה
    .accesskey = פ
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = קובץ { $extension }‏
applications-action-save =
    .label = שמירת קובץ
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = שימוש ב־{ $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = שימוש ב־{ $app-name } (ברירת מחדל)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] שימוש ביישום ברירת המחדל של macOS
            [windows] שימוש ביישום ברירת המחדל של Windows
           *[other] שימוש ביישום ברירת המחדל של המערכת
        }
applications-use-other =
    .label = שימוש ביישום אחר…
applications-select-helper = בחירת יישום מסייע
applications-manage-app =
    .label = פרטי יישום…
applications-always-ask =
    .label = לשאול תמיד
applications-type-pdf = Portable Document Format (PDF)
# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })
# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ‏({ $type })
# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = השתמש בתוסף { $plugin-name } (בתוך { -brand-short-name })
applications-open-inapp =
    .label = פתיחה ב־{ -brand-short-name }

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = תוכן ניהול זכויות דיגיטלי (DRM)
play-drm-content =
    .label = הפעלת תוכן מוגן DRM
    .accesskey = ה
play-drm-content-learn-more = מידע נוסף
update-application-title = עדכוני { -brand-short-name }
update-application-description = כדאי להשאיר את { -brand-short-name } עדכני לטובת ביצועים, יציבות ואבטחה ברמה הטובה ביותר.
update-application-version = גרסה { $version } <a data-l10n-name="learn-more">מה חדש</a>
update-history =
    .label = הצגת היסטוריית עדכונים…
    .accesskey = ה
update-application-allow-description = לאפשר ל־{ -brand-short-name }
update-application-auto =
    .label = להתקין עדכונים באופן אוטומטי (מומלץ)
    .accesskey = א
update-application-check-choose =
    .label = לבדוק אם קיימים עדכונים אבל לדרוש אישור כדי להתקין אותם
    .accesskey = ב
update-application-manual =
    .label = לעולם לא לבדוק לעדכונים (לא מומלץ)
    .accesskey = ל
update-application-warning-cross-user-setting = הגדרה זו תחול על כל חשבונות Windows ופרופילי { -brand-short-name } המשתמשים בהתקנה זו של { -brand-short-name }.
update-application-use-service =
    .label = שימוש בשירות רקע לשם התקנת עדכונים
    .accesskey = ר
update-setting-write-failure-title = שגיאה בשמירת העדפות עדכון
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    ‏{ -brand-short-name } נתקל בשגיאה ולא שמר את השינוי הזה. נא לשים לב כי שינוי ההגדרה של העדפת העדכון דורשת הרשאה לכתוב לקובץ שלהלן. ייתכן שתהיה לך או למנהל מערכת אפשרות לתקן את השגיאה על־ידי הענקת שליטה מלאה לקבוצה 'משתמשים' עבור קובץ זה.
    
    לא ניתן לכתוב לקובץ: { $path }
update-in-progress-title = העדכון בתהליך
update-in-progress-message = האם ברצונך ש־{ -brand-short-name } ימשיך בעדכון זה?
update-in-progress-ok-button = &ביטול
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &המשך

## General Section - Performance

performance-title = ביצועים
performance-use-recommended-settings-checkbox =
    .label = שימוש בהגדרות הביצועים המומלצות
    .accesskey = ש
performance-use-recommended-settings-desc = הגדרות אלו מותאמות לחומרת המחשב ולמערכת ההפעלה שלך.
performance-settings-learn-more = מידע נוסף
performance-allow-hw-accel =
    .label = שימוש בהאצת חומרה כשניתן
    .accesskey = ה
performance-limit-content-process-option = הגבלת תהליך תוכן
    .accesskey = ה
performance-limit-content-process-enabled-desc = תהליכי תוכן נוספים עשויים לשפר את הביצועים בעת שימוש במספר לשוניות, עם זאת ייעשה שימוש ביותר זיכרון.
performance-limit-content-process-blocked-desc = שינוי מספר תהליכי תוכן אפשרי רק עם { -brand-short-name } מרובה תהליכים. <a data-l10n-name="learn-more">כיצד לבדוק אם ריבוי תהליכים מופעל</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (ברירת מחדל)

## General Section - Browsing

browsing-title = דפדוף
browsing-use-autoscroll =
    .label = שימוש בגלילה אוטומטית
    .accesskey = ב
browsing-use-smooth-scrolling =
    .label = שימוש בגלילה חלקה
    .accesskey = ח
browsing-use-onscreen-keyboard =
    .label = הצגת מקלדת מגע בעת הצורך
    .accesskey = מ
browsing-use-cursor-navigation =
    .label = תמיד להשתמש במקשי הסמן לניווט בתוך דפים
    .accesskey = ס
browsing-search-on-start-typing =
    .label = חיפוש מלל עם תחילת הקלדה
    .accesskey = מ
browsing-picture-in-picture-toggle-enabled =
    .label = הפעלת בקרי וידאו של תמונה בתוך תמונה
    .accesskey = ת
browsing-picture-in-picture-learn-more = מידע נוסף
browsing-cfr-recommendations =
    .label = קבלת המלצות על הרחבות תוך כדי גלישה
    .accesskey = ק
browsing-cfr-features =
    .label = קבלת המלצות על תכונות תוך כדי גלישה
    .accesskey = ת
browsing-cfr-recommendations-learn-more = מידע נוסף

## General Section - Proxy

network-settings-title = הגדרות רשת
network-proxy-connection-description = הגדרת אופן החיבור של { -brand-short-name } לאינטרנט.
network-proxy-connection-learn-more = מידע נוסף
network-proxy-connection-settings =
    .label = הגדרות…
    .accesskey = ה

## Home Section

home-new-windows-tabs-header = חלונות ולשוניות חדשים
home-new-windows-tabs-description2 = ניתן לבחור מה יופיע בעת פתיחת דף הבית שלך, חלונות חדשים ולשוניות חדשות.

## Home Section - Home Page Customization

home-homepage-mode-label = דף הבית וחלונות חדשים
home-newtabs-mode-label = לשוניות חדשות
home-restore-defaults =
    .label = שחזור ברירות מחדל
    .accesskey = ש
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = מסך הבית של Firefox (ברירת מחדל)
home-mode-choice-custom =
    .label = כתובות מותאמות אישית…
home-mode-choice-blank =
    .label = דף ריק
home-homepage-custom-url =
    .placeholder = נא להדביק כתובת…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] שימוש בדף הנוכחי
           *[other] שימוש בדפים הנוכחיים
        }
    .accesskey = נ
choose-bookmark =
    .label = שימוש בסימנייה…
    .accesskey = ס

## Home Section - Firefox Home Content Customization

home-prefs-content-header = תוכן מסך הבית של Firefox
home-prefs-content-description = בחירת תוכן שיוצג במסך הבית של Firefox.
home-prefs-search-header =
    .label = חיפוש ברשת
home-prefs-topsites-header =
    .label = אתרים מובילים
home-prefs-topsites-description = האתרים בהם ביקרת הכי הרבה

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = מומלץ על־ידי { $provider }

##

home-prefs-recommended-by-learn-more = איך זה עובד
home-prefs-recommended-by-option-sponsored-stories =
    .label = סיפורים ממומנים
home-prefs-highlights-header =
    .label = מומלצים
home-prefs-highlights-description = מבחר של אתרים ששמרת או ביקרת בהם
home-prefs-highlights-option-visited-pages =
    .label = עמודים בהם ביקרת
home-prefs-highlights-options-bookmarks =
    .label = סימניות
home-prefs-highlights-option-most-recent-download =
    .label = ההורדות האחרונות
home-prefs-highlights-option-saved-to-pocket =
    .label = עמודים שנשמרו ל־{ -pocket-brand-name }
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = פתקיות
home-prefs-snippets-description = עדכונים מ־{ -vendor-short-name } ו־{ -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] שורה אחת
           *[other] { $num } שורות
        }

## Search Section

search-bar-header = שורת החיפוש
search-bar-hidden =
    .label = שימוש בשורת הכתובת לחיפוש וניווט
search-bar-shown =
    .label = הוספת שורת החיפוש לסרגל הכלים
search-engine-default-header = מנוע חיפוש ברירת מחדל
search-engine-default-desc-2 = זהו מנוע החיפוש המוגדר כברירת מחדל בשורת הכתובת ובשורת החיפוש. ניתן להחליף אותו בכל עת.
search-engine-default-private-desc-2 = בחירת מנוע חיפוש אחר עבור חלונות פרטיים בלבד
search-separate-default-engine =
    .label = שימוש במנוע חיפוש זה בחלונות פרטיים
    .accesskey = ש
search-suggestions-header = הצעות חיפוש
search-suggestions-desc = בחירת האופן שבו מוצגות הצעות ממנועי חיפוש.
search-suggestions-option =
    .label = הצגת המלצות חיפוש
    .accesskey = מ
search-show-suggestions-url-bar-option =
    .label = הצגת הצעות חיפוש בתוצאות שורת הכתובת
    .accesskey = ח
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = הצגת הצעות חיפוש לפני היסטוריית הגלישה בתוצאות שורת הכתובת
search-show-suggestions-private-windows =
    .label = הצגת הצעות חיפוש בחלונות פרטיים
suggestions-addressbar-settings-generic = שינוי העדפות עבור הצעות אחרות של שורת הכתובת
search-suggestions-cant-show = הצעות חיפוש לא יופיעו בתוצאות סרגל המיקום מכיוון שהגדרת ש־{ -brand-short-name } לעולם לא לזכור היסטוריה.
search-one-click-header = מנועי חיפוש בלחיצה אחת
search-one-click-desc = בחירת מנועי חיפוש חלופיים שיופיעו מתחת לשורת הכתובת ושורת החיפוש עם תחילת ההקלדה של מילות מפתח.
search-choose-engine-column =
    .label = מנוע חיפוש
search-choose-keyword-column =
    .label = מילת מפתח
search-restore-default =
    .label = שחזור למנועי חיפוש ברירת מחדל
    .accesskey = ש
search-remove-engine =
    .label = הסרה
    .accesskey = ה
search-add-engine =
    .label = הוספה
    .accesskey = ה
search-find-more-link = מנועי חיפוש נוספים
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = מילת מפתח כפולה
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = בחרת להשתמש במילת מפתח שנמצאת כרגע בשימוש עבור "{ $name }". אנא בחר במילה אחרת.
search-keyword-warning-bookmark = בחרת להשתמש במילת מפתח שנמצאת כרגע בשימוש על־ידי סימנייה. נא לבחור במילה אחרת.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] חזרה לאפשרויות
           *[other] חזרה להעדפות
        }
containers-header = מגירת לשוניות
containers-add-button =
    .label = הוספת מגירה חדשה
    .accesskey = מ
containers-new-tab-check =
    .label = בחירת מגירה עבור כל לשונית חדשה
    .accesskey = ב
containers-preferences-button =
    .label = העדפות
containers-remove-button =
    .label = הסרה

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = קחו את הרשת עמכם
sync-signedout-description = סנכרון הסימניות, ההיסטוריה, הלשוניות, הססמאות, ההרחבות, וההעדפות בין כל מכשיריך.
sync-signedout-account-signin2 =
    .label = התחברות אל { -sync-brand-short-name }…
    .accesskey = ה
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = הורידו את Firefox עבור <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> או <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> כדי להסתנכרן עם המכשירים הניידים שלכם.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = שינוי תמונת פרופיל
sync-sign-out =
    .label = התנתקות…
    .accesskey = ה
sync-manage-account = ניהול חשבון
    .accesskey = נ
sync-signedin-unverified = הכתובת  { $email } אינה מאומתת.
sync-signedin-login-failure = נא להיכנס לחשבון כדי להתחבר מחדש { $email }
sync-resend-verification =
    .label = שליחת אימות מחדש
    .accesskey = א
sync-remove-account =
    .label = הסרת חשבון
    .accesskey = ס
sync-sign-in =
    .label = כניסה
    .accesskey = כ

## Sync section - enabling or disabling sync.

prefs-syncing-on = סנכרון: פעיל
prefs-syncing-off = סנכרון: כבוי
prefs-sync-setup =
    .label = הגדרת { -sync-brand-short-name }…
    .accesskey = ג
prefs-sync-offer-setup-label = סנכרון הסימניות, ההיסטוריה, הלשוניות, הססמאות, ההרחבות, וההעדפות בין כל המכשירים שלך.
prefs-sync-now =
    .labelnotsyncing = סנכרון כעת
    .accesskeynotsyncing = ס
    .labelsyncing = בתהליך סנכרון…

## The list of things currently syncing.

sync-currently-syncing-heading = כרגע בסנכרון הפריטים הבאים:
sync-currently-syncing-bookmarks = סימניות
sync-currently-syncing-history = היסטוריה
sync-currently-syncing-tabs = לשוניות פתוחות
sync-currently-syncing-logins-passwords = כניסות וססמאות
sync-currently-syncing-addresses = כתובות
sync-currently-syncing-creditcards = כרטיסי אשראי
sync-currently-syncing-addons = תוספות
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] אפשרויות
       *[other] העדפות
    }
sync-change-options =
    .label = שינוי…
    .accesskey = ש

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = בחירת הפריטים לסנכרון
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = שמירת השינויים
    .buttonaccesskeyaccept = ש
    .buttonlabelextra2 = התנתקות…
    .buttonaccesskeyextra2 = ה
sync-engine-bookmarks =
    .label = סימניות
    .accesskey = ס
sync-engine-history =
    .label = היסטוריה
    .accesskey = ה
sync-engine-tabs =
    .label = לשוניות פתוחות
    .tooltiptext = רשימה של מה שפתוח בכל ההתקנים המסונכרנים
    .accesskey = ל
sync-engine-logins-passwords =
    .label = כניסות וססמאות
    .tooltiptext = שמות משתמשים וססמאות ששמרת
    .accesskey = כ
sync-engine-addresses =
    .label = כתובות
    .tooltiptext = כתובות למשלוח דואר ששמרת (שולחן עבודה בלבד)
    .accesskey = כ
sync-engine-creditcards =
    .label = כרטיסי אשראי
    .tooltiptext = שמות, מספרים ותאריכי תפוגה (שולחן עבודה בלבד)
    .accesskey = א
sync-engine-addons =
    .label = תוספות
    .tooltiptext = הרחבות וערכות נושא עבור Firefox שולחני
    .accesskey = ת
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] אפשרויות
           *[other] העדפות
        }
    .tooltiptext = הגדרות כלליות, פרטיות ואבטחה ששינית
    .accesskey = ת

## The device name controls.

sync-device-name-header = שם המכשיר
sync-device-name-change =
    .label = שינוי שם מכשיר…
    .accesskey = ש
sync-device-name-cancel =
    .label = ביטול
    .accesskey = ב
sync-device-name-save =
    .label = שמירה
    .accesskey = ש
sync-connect-another-device = חיבור מכשיר נוסף

## Privacy Section

privacy-header = פרטיות דפדפן

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = כניסות וססמאות
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = הצגת בקשה לשמירת פרטי כניסה וססמאות לאתרים
    .accesskey = צ
forms-exceptions =
    .label = חריגות…
    .accesskey = ר
forms-generate-passwords =
    .label = הצעה ויצירת ססמאות חזקות
    .accesskey = ס
forms-breach-alerts =
    .label = הצגת התרעות על ססמאות עבור אתרים שנפרצו
    .accesskey = ס
forms-breach-alerts-learn-more-link = מידע נוסף
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = מילוי אוטומטי של כניסות וססמאות
    .accesskey = מ
forms-saved-logins =
    .label = כניסות שמורות…
    .accesskey = כ
forms-master-pw-use =
    .label = שימוש בססמה ראשית
    .accesskey = ש
forms-primary-pw-use =
    .label = שימוש בססמה ראשית
    .accesskey = ש
forms-primary-pw-learn-more-link = מידע נוסף
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = שינוי ססמה ראשית…
    .accesskey = נ
forms-master-pw-fips-title = הינך כרגע במצב FIPS. ‏FIPS דורש ססמה ראשית לא־ריקה.
forms-primary-pw-change =
    .label = שינוי ססמה ראשית…
    .accesskey = נ
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = מצבך כרגע הוא FIPS. ‏FIPS דורש ססמה ראשית לא־ריקה.
forms-master-pw-fips-desc = שינוי הססמה נכשל

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = כדי ליצור ססמה ראשית, יש להזין את פרטי הכניסה שלך ל־Windows. פעולה זאת מסייעת בהגנה על אבטחת החשבונות שלך.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = ליצור ססמה ראשית
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = כדי ליצור ססמה ראשית, יש להזין את פרטי הכניסה שלך ל־Windows. פעולה זאת מסייעת בהגנה על אבטחת החשבונות שלך.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = ליצור ססמה ראשית
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = היסטוריה
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name }
    .accesskey = F
history-remember-option-all =
    .label = ישמור היסטוריה
history-remember-option-never =
    .label = לעולם לא ישמור היסטוריה
history-remember-option-custom =
    .label = ישתמש בהגדרות מותאמות אישית להיסטוריה
history-remember-description = ‏{ -brand-short-name } יזכור את היסטוריית הגלישה, ההורדות, הטפסים והחיפוש שלך.
history-dontremember-description = { -brand-short-name } ישתמש באותן ההגדרות לגלישה פרטית, ולא יזכור היסטוריה כלשהי במהלך הגלישה שלך ברשת.
history-private-browsing-permanent =
    .label = שימוש תמידי במצב גלישה פרטית
    .accesskey = ה
history-remember-browser-option =
    .label = שמירת היסטוריית גלישה והורדות
    .accesskey = ש
history-remember-search-option =
    .label = שמירת חיפושים והיסטוריית טפסים
    .accesskey = ט
history-clear-on-close-option =
    .label = מחיקת היסטוריה כאשר { -brand-short-name } נסגר
    .accesskey = נ
history-clear-on-close-settings =
    .label = הגדרות…
    .accesskey = ה
history-clear-button =
    .label = ניקוי היסטוריה…
    .accesskey = ה

## Privacy Section - Site Data

sitedata-header = עוגיות ונתוני אתרים
sitedata-total-size-calculating = חישוב גודל נתוני אתרים ומטמון…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = העוגיות, נתוני האתרים והמטמון השמורים שלך משתמשים כרגע ב־{ $value } { $unit } משטח הדיסק.
sitedata-learn-more = מידע נוסף
sitedata-delete-on-close =
    .label = מחיקת עוגיות ונתוני אתרים עם סגירת { -brand-short-name }
    .accesskey = ח
sitedata-delete-on-close-private-browsing = במצב גלישה פרטית קבועה, עוגיות ונתוני אתרים ינוקו תמיד כש־{ -brand-short-name } נסגר.
sitedata-allow-cookies-option =
    .label = קבלת עוגיות ונתוני אתרים
    .accesskey = ק
sitedata-disallow-cookies-option =
    .label = חסימת עוגיות ונתוני אתרים
    .accesskey = ח
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = סוג שנחסם
    .accesskey = ס
sitedata-option-block-cross-site-trackers =
    .label = רכיבי מעקב חוצי אתרים
sitedata-option-block-unvisited =
    .label = עוגיות מאתרים שלא ביקרתי בהם
sitedata-option-block-all-third-party =
    .label = כל העוגיות צד־שלישי (עשוי לשבש פעילות של חלק מהאתרים)
sitedata-option-block-all =
    .label = כל העוגיות (ישבש פעילות של אתרים)
sitedata-clear =
    .label = ניקוי נתונים…
    .accesskey = נ
sitedata-settings =
    .label = ניהול נתונים…
    .accesskey = נ
sitedata-cookies-permissions =
    .label = ניהול הרשאות…
    .accesskey = ה
sitedata-cookies-exceptions =
    .label = ניהול חריגות…
    .accesskey = ח

## Privacy Section - Address Bar

addressbar-header = שורת כתובת
addressbar-suggest = כאשר משתמשים בסרגל החיפוש, יוצגו המלצות עבור
addressbar-locbar-history-option =
    .label = היסטוריית גלישה
    .accesskey = ג
addressbar-locbar-bookmarks-option =
    .label = סימניות
    .accesskey = ס
addressbar-locbar-openpage-option =
    .label = לשוניות פתוחות
    .accesskey = ל
addressbar-locbar-topsites-option =
    .label = אתרים מובילים
    .accesskey = מ
addressbar-suggestions-settings = שינוי העדפות של הצעות מנועי חיפוש

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = הגנת מעקב מתקדמת
content-blocking-section-top-level-description = רכיבי מעקב עוקבים אחריך ברשת כדי לאסוף מידע על הרגלי הגלישה ותחומי העניין שלך. { -brand-short-name } חוסם הרבה מרכיבי המעקב האלו, לרבות תסריטים זדוניים אחרים.
content-blocking-learn-more = מידע נוסף

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = רגיל
    .accesskey = ר
enhanced-tracking-protection-setting-strict =
    .label = מחמיר
    .accesskey = מ
enhanced-tracking-protection-setting-custom =
    .label = התאמה אישית
    .accesskey = ה

##

content-blocking-etp-standard-desc = מאוזן בין הגנה לביצועים. דפים ייטענו כרגיל.
content-blocking-etp-strict-desc = הגנה חזקה יותר, אך עשויה לשבש פעילות של אתרים או תוכן.
content-blocking-etp-custom-desc = בחירה באילו רכיבי מעקב ותסריטים יש לחסום.
content-blocking-private-windows = תוכן מעקב בחלונות פרטיים
content-blocking-cross-site-tracking-cookies = עוגיות מעקב חוצות אתרים
content-blocking-social-media-trackers = רכיבי מעקב של מדיה חברתית
content-blocking-all-cookies = כל העוגיות
content-blocking-unvisited-cookies = עוגיות מאתרים שלא ביקרתי בהם
content-blocking-all-windows-tracking-content = תוכן מעקב בכל החלונות
content-blocking-all-third-party-cookies = כל העוגיות צד־שלישי
content-blocking-cryptominers = כורי מטבעות דיגיטליים
content-blocking-fingerprinters = רכיבי זהות דיגיטלית
content-blocking-warning-title = לתשומת לבך!
content-blocking-and-isolating-etp-warning-description = חסימת רכיבי מעקב ובידוד עוגיות עשויים להשפיע על הפונקציונליות של אתרים מסוימים. יש לטעון מחדש דף עם רכיבי מעקב כדי לטעון את כל התוכן.
content-blocking-warning-learn-how = מידע נוסף
content-blocking-reload-description = יהיה עליך לטעון מחדש את הלשוניות שלך כדי להחיל שינויים אלו.
content-blocking-reload-tabs-button =
    .label = טעינת כל הלשוניות מחדש
    .accesskey = ט
content-blocking-tracking-content-label =
    .label = תוכן מעקב
    .accesskey = ת
content-blocking-tracking-protection-option-all-windows =
    .label = בכל החלונות
    .accesskey = כ
content-blocking-option-private =
    .label = רק בחלונות פרטיים
    .accesskey = פ
content-blocking-tracking-protection-change-block-list = שינוי רשימת חסימות
content-blocking-cookies-label =
    .label = עוגיות
    .accesskey = ע
content-blocking-expand-section =
    .tooltiptext = מידע נוסף
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = כורי מטבעות דיגיטליים
    .accesskey = כ
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = רכיבי זהות דיגיטלית
    .accesskey = ז

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = ניהול חריגות…
    .accesskey = ח

## Privacy Section - Permissions

permissions-header = הרשאות
permissions-location = מיקום
permissions-location-settings =
    .label = הגדרות…
    .accesskey = ה
permissions-xr = מציאות מדומה
permissions-xr-settings =
    .label = הגדרות…
    .accesskey = ה
permissions-camera = מצלמה
permissions-camera-settings =
    .label = הגדרות…
    .accesskey = ה
permissions-microphone = מיקרופון
permissions-microphone-settings =
    .label = הגדרות…
    .accesskey = ה
permissions-notification = התרעות
permissions-notification-settings =
    .label = הגדרות…
    .accesskey = ה
permissions-notification-link = מידע נוסף
permissions-notification-pause =
    .label = השהיית התרעות עד להפעלה מחדש של { -brand-short-name }
    .accesskey = ה
permissions-autoplay = ניגון אוטומטי
permissions-autoplay-settings =
    .label = הגדרות…
    .accesskey = ה
permissions-block-popups =
    .label = חסימת חלונות קופצים
    .accesskey = ח
permissions-block-popups-exceptions =
    .label = חריגות…
    .accesskey = ר
permissions-addon-install-warning =
    .label = הצגת אזהרה כשאתרים מנסים להתקין תוספות
    .accesskey = ה
permissions-addon-exceptions =
    .label = חריגות…
    .accesskey = ח
permissions-a11y-privacy-checkbox =
    .label = מניעת שירותי נגישות מקבלת גישה לדפדפן שלך
    .accesskey = נ
permissions-a11y-privacy-link = מידע נוסף

## Privacy Section - Data Collection

collection-header = איסוף המידע של { -brand-short-name }
collection-description = אנו חותרים לספק לך זכות בחירה ולאסוף רק מה שנדרש לנו כדי לספק ולשפר את { -brand-short-name } לטובת הכלל. אנו תמיד נבקש את רשותך לפני קבלת פרטים אישיים.
collection-privacy-notice = הצהרת פרטיות
collection-health-report-telemetry-disabled-link = מידע נוסף
collection-health-report =
    .label = לאפשר ל־{ -brand-short-name } לשלוח אל { -vendor-short-name } מידע טכני ופעולות שבוצעו בדפדפן
    .accesskey = ד
collection-health-report-link = מידע נוסף
collection-studies =
    .label = לאפשר ל־{ -brand-short-name } להתקין ולהריץ מחקרים
collection-studies-link = הצגת המחקרים של { -brand-short-name }
addon-recommendations =
    .label = לאפשר ל־{ -brand-short-name } להציע הרחבות מותאמות אישית
addon-recommendations-link = מידע נוסף
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = דיווח נתונים מנוטרל עבור תצורת בנייה זו
collection-backlogged-crash-reports =
    .label = לאפשר ל־{ -brand-short-name } לשלוח דיווחי קריסות שנשמרו בשמך
    .accesskey = ק
collection-backlogged-crash-reports-link = מידע נוסף

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = אבטחה
security-browsing-protection = תוכן מטעה והגנת תוכנה מסוכנת
security-enable-safe-browsing =
    .label = חסימת תוכן מסוכן ומטעה
    .accesskey = ת
security-enable-safe-browsing-link = מידע נוסף
security-block-downloads =
    .label = חסימת הורדות מסוכנות
    .accesskey = ה
security-block-uncommon-software =
    .label = הצגת אזהרה מפני תכניות לא רצויות ולא נפוצות
    .accesskey = ת

## Privacy Section - Certificates

certs-header = אישורים
certs-personal-label = כאשר שרת מבקש את אישור האבטחה האישי שלך
certs-select-auto-option =
    .label = לבחור אחד באופן אוטומטי
    .accesskey = ב
certs-select-ask-option =
    .label = לשאול אותך כל פעם
    .accesskey = ש
certs-enable-ocsp =
    .label = תשאול שרתי OCSP לאימות תקפות נוכחית של אישורי אבטחה
    .accesskey = ת
certs-view =
    .label = הצגת אישורים…
    .accesskey = א
certs-devices =
    .label = התקני אבטחה…
    .accesskey = א
space-alert-learn-more-button =
    .label = מידע נוסף
    .accesskey = מ
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] פתיחת אפשרויות
           *[other] פתיחת העדפות
        }
    .accesskey =
        { PLATFORM() ->
            [windows] א
           *[other] ה
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] ל־{ -brand-short-name } אוזל שטח הדיסק. יתכן שתכני אתרים לא יוצגו כשורה. ניתן למחוק נתונים שמורים באפשרויות > פרטיות ואבטחה > עוגיות ונתוני אתרים.
       *[other] ל־{ -brand-short-name } אוזל שטח הדיסק. יתכן שתכני אתרים לא יוצגו כשורה. ניתן למחוק נתונים שמורים בהעדפות > פרטיות ואבטחה > עוגיות ונתוני אתרים.
    }
space-alert-under-5gb-ok-button =
    .label = בסדר, הבנתי
    .accesskey = ב
space-alert-under-5gb-message = ל־{ -brand-short-name } אוזל שטח הדיסק. יתכן שנתוני אתרים לא יוצגו כשורה. ניתן לבקר בקישור של “מידע נוסף” כדי לייעל את אופן השימוש בדיסק לחוויית גלישה טובה יותר.

## Privacy Section - HTTPS-Only

httpsonly-header = מצב HTTPS בלבד
httpsonly-description = ‏HTTPS מספק חיבור מאובטח ומוצפן בין { -brand-short-name } לבין האתרים שמבקרים בהם. רוב האתרים תומכים ב־HTTPS, ואם מצב HTTPS בלבד מופעל, { -brand-short-name } ישדרג את כל החיבורים ל־HTTPS.
httpsonly-learn-more = מידע נוסף
httpsonly-radio-enabled =
    .label = הפעלת מצב HTTPS בלבד בכל החלונות
httpsonly-radio-enabled-pbm =
    .label = הפעלת מצב HTTPS בלבד אך ורק בחלונות פרטיים
httpsonly-radio-disabled =
    .label = לא להפעיל מצב HTTPS בלבד

## The following strings are used in the Download section of settings

desktop-folder-name = שולחן עבודה
downloads-folder-name = הורדות
choose-download-folder-title = בחירת תיקייה להורדה:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = שמירת קבצים ב־{ $service-name }
