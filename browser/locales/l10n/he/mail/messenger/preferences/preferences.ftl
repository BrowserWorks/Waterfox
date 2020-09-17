# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


close-button =
    .aria-label = סגירה

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] אפשרויות
           *[other] העדפות
        }

pane-compose-title = חיבור הודעה
category-compose =
    .tooltiptext = חיבור הודעה

pane-chat-title = צ׳אט
category-chat =
    .tooltiptext = צ׳אט

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = דף ההתחלה של { -brand-short-name }

start-page-label =
    .label = כאשר { -brand-short-name } מופעל, הצג את דף ההתחלה באזור ההודעה
    .accesskey = ג

location-label =
    .value = מיקום:
    .accesskey = מ
restore-default-label =
    .label = שחזור ברירת מחדל
    .accesskey = מ

default-search-engine = מנוע חיפוש כבררת מחדל

new-message-arrival = כאשר מופיעות הודעות חדשות:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] להשמיע את קובץ הצליל הבא:
           *[other] השמע צליל
        }
    .accesskey =
        { PLATFORM() ->
            [macos] צ
           *[other] צ
        }
mail-play-button =
    .label = נגן
    .accesskey = נ

change-dock-icon = שינוי ההעדפות לסמל היישום
app-icon-options =
    .label = אפשרויות סמל היישום…
    .accesskey = ס

animated-alert-label =
    .label = הראה התרעה
    .accesskey = א
customize-alert-label =
    .label = התאמה אישית…
    .accesskey = ה

tray-icon-label =
    .label = הצגת סמל במגש המערכת
    .accesskey = ג

mail-custom-sound-label =
    .label = השתמש בקובץ צליל הבא
    .accesskey = ש
mail-browse-sound-button =
    .label = עיון…
    .accesskey = ע

enable-gloda-search-label =
    .label = אפשר חיפוש גלובלי ואינדוקס
    .accesskey = ח

datetime-formatting-legend = תבנית תאריך ושעה

allow-hw-accel =
    .label = שימוש בהאצת חומרה כשניתן
    .accesskey = ח

store-type-label =
    .value = סוג אחסון הודעות לחשבונות חדשים:
    .accesskey = ס

mbox-store-label =
    .label = קובץ לכל תיקייה (mbox)
maildir-store-label =
    .label = קובץ לכל הודעה (maildir)

scrolling-legend = גלילה
autoscroll-label =
    .label = שימוש בגלילה אוטומטית
    .accesskey = א
smooth-scrolling-label =
    .label = שימוש בגלילה חלקה
    .accesskey = ח

system-integration-legend = השתלבות במערכת
always-check-default =
    .label = בדוק בכל הפעלה אם { -brand-short-name } היא תוכנת דואר ברירת המחדל
    .accesskey = ב
check-default-button =
    .label = לבדוק כעת…
    .accesskey = כ

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

search-integration-label =
    .label = אפשר ל־{ search-engine-name } לחפש הודעות
    .accesskey = ח

config-editor-button =
    .label = עורך הגדרות...
    .accesskey = ע

return-receipts-description = קבע כיצד { -brand-short-name } מטפל בקבלות חוזרות.
return-receipts-button =
    .label = קבלות חוזרות...
    .accesskey = ז

update-app-legend = עדכוני { -brand-short-name }

automatic-updates-label =
    .label = להתקין עדכונים אוטומטית (מומלץ: אבטחה משופרת)
    .accesskey = א
check-updates-label =
    .label = לבדוק עדכונים, אבל לאפשר לי לבחור האם להתקין אותם
    .accesskey = ב

update-history-button =
    .label = הצגת היסטוריית עדכונים
    .accesskey = ע

use-service =
    .label = שימוש בשירות רקע כדי להתקין עדכונים
    .accesskey = ר

networking-legend = חיבור
proxy-config-description = קבע כיצד { -brand-short-name } מתחבר לאינטרנט.

network-settings-button =
    .label = הגדרות…
    .accesskey = ה

offline-legend = לא־מקוון
offline-settings = נהל הגדרות לא־מקוון

offline-settings-button =
    .label = לא־מקוון...
    .accesskey = מ

diskspace-legend = שטח דיסק
offline-compact-folder =
    .label = לדחוס את כל התיקיות כשהפעולה תחסוך למעלה מ־
    .accesskey = ס

compact-folder-size =
    .value = מ״ב בסך הכול

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = השתמש במטמון עד לשטח של
    .accesskey = ה

use-cache-after = מ״ב

##

smart-cache-label =
    .label = דריסת ניהול מטמון אוטומטי
    .accesskey = ד

clear-cache-button =
    .label = נקה כעת
    .accesskey = נ

fonts-legend = גופנים וצבעים

default-font-label =
    .value = גופן ברירת מחדל:
    .accesskey = ב

default-size-label =
    .value = גודל:
    .accesskey = ג

font-options-button =
    .label = מתקדם…
    .accesskey = מ

color-options-button =
    .label = צבעים…
    .accesskey = צ

display-width-legend = הודעות טקסט פשוט

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = הצג פרצופונים בצורה גרפית
    .accesskey = ה

display-text-label = בעת הצגת הודעות טקסט פשוט מצוטט:

style-label =
    .value = סגנון:
    .accesskey = ס

regular-style-item =
    .label = רגיל
bold-style-item =
    .label = מודגש
italic-style-item =
    .label = נטוי
bold-italic-style-item =
    .label = נטוי מודגש

size-label =
    .value = גודל:
    .accesskey = ד

regular-size-item =
    .label = רגיל
bigger-size-item =
    .label = גדול יותר
smaller-size-item =
    .label = קטן יותר

quoted-text-color =
    .label = צבע:
    .accesskey = ב

search-input =
    .placeholder = חיפוש

type-column-label =
    .label = סיווג תוכן
    .accesskey = ס

action-column-label =
    .label = פעולה
    .accesskey = פ

save-to-label =
    .label = שמור קבצים אל
    .accesskey = ש

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] בחירה…
           *[other] עיון…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ב
           *[other] ע
        }

always-ask-label =
    .label = שאל תמיד היכן לשמור קבצים
    .accesskey = ת


display-tags-text = תוויות משמשות לחלוקה לקטגוריות ותיעדוף ההודעות שלך.

new-tag-button =
    .label = חדש…
    .accesskey = ח

edit-tag-button =
    .label = עריכה…
    .accesskey = ע

delete-tag-button =
    .label = מחק
    .accesskey = מ

auto-mark-as-read =
    .label = סימון הודעות כנקראו אוטומטית
    .accesskey = ק

mark-read-no-delay =
    .label = מיד עם ההצגה
    .accesskey = מ

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = לאחר הצגה למשך
    .accesskey = א

seconds-label = שניות

##

open-msg-label =
    .value = פתיחת הודעות בתוך:

open-msg-tab =
    .label = לשונית חדשה
    .accesskey = ל

open-msg-window =
    .label = חלון הודעה חדש
    .accesskey = ח

open-msg-ex-window =
    .label = חלון הודעה קיים
    .accesskey = ק

close-move-delete =
    .label = לסגור את חלון/לשונית ההודעה בעת העברה או מחיקה
    .accesskey = ס

condensed-addresses-label =
    .label = הצגת שמות תצוגה בלבד עבור אנשים בפנקס הכתובת שלי
    .accesskey = צ

## Compose Tab

forward-label =
    .value = הודעות מועברות:
    .accesskey = ה

inline-label =
    .label = בתוך השורה

as-attachment-label =
    .label = כנספח

extension-label =
    .label = הוסף סיומת לשם הקובץ
    .accesskey = ק

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = שמור אוטומטית כל
    .accesskey = ט

auto-save-end = דקות

##

warn-on-send-accel-key =
    .label = אשר בעת שימוש בקיצורי מקלדת לשליחת הודעה
    .accesskey = ב

spellcheck-label =
    .label = בדוק איות לפני שליחה
    .accesskey = ב

spellcheck-inline-label =
    .label = אפשר בדיקת איות תוך כדי הקלדה
    .accesskey = א

language-popup-label =
    .value = שפה:
    .accesskey = ש

download-dictionaries-link = הורד מילונים נוספים

font-label =
    .value = גופן:
    .accesskey = פ

font-color-label =
    .value = צבע טקסט:
    .accesskey = ט

bg-color-label =
    .value = צבע רקע:
    .accesskey = ר

restore-html-label =
    .label = שחזור ברירות מחדל
    .accesskey = ב

default-format-label =
    .label = שימוש בתבנית פסקה במקום גוף ההודעה כבררת מחדל
    .accesskey = פ

format-description = הגדר התנהגות סגנון טקסט

send-options-label =
    .label = אפשרויות שליחה...
    .accesskey = ל

autocomplete-description = כאשר ממענים הודעות, חפש רשומות תואמות בתוך:

ab-label =
    .label = פנקסי כתובות מקומיים
    .accesskey = פ

directories-label =
    .label = שרת מדריך:
    .accesskey = ש

directories-none-label =
    .none = ללא

edit-directories-label =
    .label = ערוך ספריות...
    .accesskey = ע

email-picker-label =
    .label = הוסף אוטומטית כתובות מדואר אלקטרוני יוצא אל:
    .accesskey = כ

default-directory-label =
    .value = תיקיית בררת מחדל לפתיחת חלון פנקס הכתובות:
    .accesskey = ב

default-last-label =
    .none = תיקייה אחרונה שהייתה בשימוש

attachment-label =
    .label = בדוק לקבצים מצורפים חסרים
    .accesskey = ח

attachment-options-label =
    .label = מילות מפתח…
    .accesskey = מ

enable-cloud-share =
    .label = הצעה לשתף עבור קבצים בגודל מעל
cloud-share-size =
    .value = מ״ב

add-cloud-account =
    .label = הוספה…
    .accesskey = ס
    .defaultlabel = הוספה…


## Privacy Tab

mail-content = תוכן דוא״ל

remote-content-label =
    .label = לאפשר תוכן מרוחק בהודעות
    .accesskey = ת

exceptions-button =
    .label = חריגות…
    .accesskey = ח

remote-content-info =
    .value = מידע נוסף על נושאי אבטחה שעולים בהקשר של תוכן מרוחק

web-content = תוכן אינטרנט

history-label =
    .label = לזכור אתרים וקישורים בהם ביקרתי
    .accesskey = ז

cookies-label =
    .label = לקבל עוגיות מאתרים
    .accesskey = ע

third-party-label =
    .value = לקבל עוגיות צד־שלישי:
    .accesskey = ש

third-party-always =
    .label = תמיד
third-party-never =
    .label = לעולם לא
third-party-visited =
    .label = מכאלו שבהם ביקרת

keep-label =
    .value = לשמור עד:
    .accesskey = ע

keep-expire =
    .label = לתפוגתם
keep-close =
    .label = הסגירה של { -brand-short-name }
keep-ask =
    .label = לשאול בכל פעם

cookies-button =
    .label = הצגת עוגיות…
    .accesskey = צ

passwords-description = { -brand-short-name } יכול לזכור מידע ססמאות עבור כל החשבונות שלך כדי שלא תצטרך להכניס שוב את מידע ההתחברות.

passwords-button =
    .label = ססמאות שמורות…
    .accesskey = מ

master-password-description = כאשר נקבעה, הססמה הראשית מגינה על כל ססמאותיך - אולם תצטרך להקליד אותה פעם אחת בכל הפעלה.

master-password-label =
    .label = השתמש בססמה ראשית
    .accesskey = ר

master-password-button =
    .label = שינוי ססמה ראשית…
    .accesskey = ש


junk-description = קבע את הגדרות ברירת המחדל שלך לדואר זבל. הגדרות דואר זבל יחודיות לכל חשבון ניתנות להגדרה בהגדרות החשבון.

junk-label =
    .label = כאשר אני מסמן הודעות כזבל:
    .accesskey = ז

junk-move-label =
    .label = העבר לתיקיית "דואר זבל" של החשבון
    .accesskey = ע

junk-delete-label =
    .label = מחק אותן
    .accesskey = מ

junk-read-label =
    .label = סמן הודעות שזוהו כזבל כהודעות שנקראו
    .accesskey = נ

junk-log-label =
    .label = הפעלת רישום מסנן זבל מסתגל
    .accesskey = פ

junk-log-button =
    .label = הצג יומן
    .accesskey = ה

reset-junk-button =
    .label = אפס נתוני אימון
    .accesskey = א

phishing-description = { -brand-short-name } יכול לנתח הודעות ולבדוק אם הן מכילות הונאות דוא״ל חשודות על־ידי חיפוש שיטות נפוצות המשמשות להטעות אותך.

phishing-label =
    .label = אמור לי אם ההודעה שאני קורא חשודה כתרמית דוא״ל
    .accesskey = א

antivirus-description = { -brand-short-name } יכול לגרום לתוכנות אנטי-וירוס לנתח בקלות הודעות דואר נכנס עבור וירוסים לפני שהן מאוכסנות באופן מקומי.

antivirus-label =
    .label = אפשר ללקוחות אנטי וירוס לבודד הודעות יחידות מתוך ההודעות הנכנסות
    .accesskey = ב

certificate-description = כאשר שרת מבקש את אישור האבטחה האישי שלי:

certificate-auto =
    .label = בחר אחד באופן אוטומטי
    .accesskey = א

certificate-ask =
    .label = שאל אותי תמיד
    .accesskey = מ

## Chat Tab

startup-label =
    .value = כאשר { -brand-short-name } מופעל:
    .accesskey = פ

offline-label =
    .label = להשאיר את חשבון הצ׳אט שלי לא מקוון

auto-connect-label =
    .label = התחברות לחשבונות הצ׳אט שלי אוטומטית

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = לאפשר לאנשי הקשר שלי לדעת על חוסר פעילות מצדי לאחר
    .accesskey = פ

idle-time-label = דקות של חוסר פעילות

##

away-message-label =
    .label = ולהגדיר את המצב למרוחק עם הודעה מצב זו:
    .accesskey = ר

send-typing-label =
    .label = שליחת התרעת הקלדה בדיונים
    .accesskey = ק

notification-label = כשמגיעות הודעות שמיועדות אליך:

show-notification-label =
    .label = הצגת התרעה:
    .accesskey = ר

notification-all =
    .label = עם שם השולח ותצוגה מקדימה של הודעה
notification-name =
    .label = עם שם השולח בלבד
notification-empty =
    .label = ללא כל מידע

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] הנפשת הסמל במעגן
           *[other] הבהוב הפריט בשורת המשימות
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ע
           *[other] ב
        }

chat-play-sound-label =
    .label = השמעת צליל
    .accesskey = ס

chat-play-button =
    .label = השמעה
    .accesskey = ש

chat-system-sound-label =
    .label = צליל בררת המחדל של המערכת להודעות דוא״ל חדשות
    .accesskey = ב

chat-custom-sound-label =
    .label = שימוש בקובץ השמע הבא
    .accesskey = ש

chat-browse-sound-button =
    .label = עיון…
    .accesskey = ע

theme-label =
    .value = ערכת נושא:
    .accesskey = ע

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = בועות
style-dark =
    .label = כהה
style-paper =
    .label = גיליונות נייר
style-simple =
    .label = פשוט

preview-label = תצוגה מקדימה:
no-preview-label = אין תצוגה מקדימה זמינה

chat-variant-label =
    .value = הגוון:
    .accesskey = ג

chat-header-label =
    .label = הצגת כותרת
    .accesskey = כ

## Preferences UI Search Results

