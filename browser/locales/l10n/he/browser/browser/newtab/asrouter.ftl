# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = הרחבה מומלצת
cfr-doorhanger-feature-heading = תכונה מומלצת
cfr-doorhanger-pintab-heading = התנסות בתכונה: נעיצת לשונית

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = למה אני רואה את זה

cfr-doorhanger-extension-cancel-button = לא עכשיו
    .accesskey = ע

cfr-doorhanger-extension-ok-button = הוספה כעת
    .accesskey = ס
cfr-doorhanger-pintab-ok-button = נעיצת לשונית זו
    .accesskey = נ

cfr-doorhanger-extension-manage-settings-button = ניהול הגדרות המלצות
    .accesskey = ג

cfr-doorhanger-extension-never-show-recommendation = לא להציג לי המלצה זו
    .accesskey = ל

cfr-doorhanger-extension-learn-more-link = מידע נוסף

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = מאת { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = המלצה
cfr-doorhanger-extension-notification2 = המלצה
    .tooltiptext = המלצה על הרחבה
    .a11y-announcement = זמינה המלצה על הרחבה

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = המלצה
    .tooltiptext = המלצה על תכונה
    .a11y-announcement = זמינה המלצה על תכונה

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] כוכב אחד
           *[other] { $total } כוכבים
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] משתמש אחד
       *[other] { $total } משתמשים
    }

cfr-doorhanger-pintab-description = קבלת גישה פשוטה לאתרים שהכי משמשים אותך. להשאיר אתרים פתוחים בלשונית (אפילו לאחר הפעלה מחדש).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = יש ללחוץ עם <b>הכפתור הימני</b> על הלשונית שברצונך לנעוץ.
cfr-doorhanger-pintab-step2 = יש לבחור ב<b>נעיצת לשונית</b> מהתפריט.
cfr-doorhanger-pintab-step3 = אם לאתר זה יהיה עדכון, תופיע נקודה כחולה על הלשונית הנעוצה שלך.

cfr-doorhanger-pintab-animation-pause = השהיה
cfr-doorhanger-pintab-animation-resume = המשך


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = סנכרון הסימניות שלך לכל מקום.
cfr-doorhanger-bookmark-fxa-link-text = סנכרון הסימניות כעת…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = כפתור סגירה
    .title = סגירה

## Protections panel

cfr-protections-panel-header = לגלוש מבלי שעוקבים אחריך
cfr-protections-panel-body = הנתונים שלך נשארים אצלך. { -brand-short-name } מגן עליך מפני רוב רכיבי הריגול שעוקבים אחר הפעילות המקוונת שלך.
cfr-protections-panel-link-text = מידע נוסף

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = תכונה חדשה:

cfr-whatsnew-button =
    .label = מה חדש
    .tooltiptext = מה חדש

cfr-whatsnew-panel-header = מה חדש

cfr-whatsnew-release-notes-link-text = קריאת הערור השחרור

cfr-whatsnew-fx70-title = { -brand-short-name } כעת נלחם יותר למען הפרטיות שלך
cfr-whatsnew-fx70-body = העדכון האחרון משפר את תכונת הגנת המעקב והופך את האפשרות ליצור ססמאות מאובטחות לכל אתר קלה מאי פעם.

cfr-whatsnew-tracking-protect-title = הגנה מפני רכיבי מעקב
cfr-whatsnew-tracking-protect-body = { -brand-short-name } חוסם  הרבה רכיבי מעקב מוכרים של רשתות חברתיות ורכיבי מעקב חוצי אתרים שעוקבים אחרי הפעילויות המקוונות שלך.
cfr-whatsnew-tracking-protect-link-text = הצגת הדוח שלך

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] רכיבי מעקב נחסמו
       *[other] רכיבי מעקב נחסמו
    }
cfr-whatsnew-tracking-blocked-subtitle = מאז { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = הצגת דוח

cfr-whatsnew-lockwise-backup-title = גיבוי הססמאות שלך
cfr-whatsnew-lockwise-backup-link-text = הפעלת גיבויים

cfr-whatsnew-lockwise-take-title = לקחת את הססמאות שלך לכל מקום
cfr-whatsnew-lockwise-take-body = היישומון לנייד { -lockwise-brand-short-name } מאפשר לך לגשת באופן מאובטח לססמאות המגובות שלך מכל מקום.
cfr-whatsnew-lockwise-take-link-text = הורדת היישומון

## Search Bar

cfr-whatsnew-searchbar-title = להקליד פחות ולמצוא יותר עם שורת הכתובת
cfr-whatsnew-searchbar-body-topsites = מעכשיו, אפשר ללחוץ על שורת הכתובת והיא תתרחב עם קישורים לאתרים המובילים שלך.
cfr-whatsnew-searchbar-icon-alt-text = סמל זכוכית מגדלת

## Picture-in-Picture

cfr-whatsnew-pip-header = צפייה בסרטונים תוך כדי גלישה
cfr-whatsnew-pip-body = במצב תמונה בתוך תמונה, הסרטון קופץ אל חלון מרחף כך שניתן לצפות בו תוך כדי עבודה בלשוניות אחרות.
cfr-whatsnew-pip-cta = מידע נוסף

## Permission Prompt

cfr-whatsnew-permission-prompt-header = פחות חלונות קופצים מעצבנים
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } מונע מעתה באופן אוטומטי מאתרים לבקש לשלוח לך הודעות קופצות.
cfr-whatsnew-permission-prompt-cta = מידע נוסף

## Fingerprinter Counter


## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = קבלת הסימנייה הזו בטלפון שלך
cfr-doorhanger-sync-bookmarks-ok-button = הפעלת { -sync-brand-short-name }
    .accesskey = ה

## Login Sync

cfr-doorhanger-sync-logins-header = אף ססמה לא תלך עוד לאיבוד
cfr-doorhanger-sync-logins-body = אחסון וסנכרון הססמאות שלך באופן מאובטח לכל המכשירים שלך.
cfr-doorhanger-sync-logins-ok-button = הפעלת { -sync-brand-short-name }
    .accesskey = ה

## Send Tab

cfr-doorhanger-send-tab-header = לקריאה בדרכים
cfr-doorhanger-send-tab-ok-button = לנסות את Send Tab
    .accesskey = ל

## Firefox Send

cfr-doorhanger-firefox-send-header = שיתוף ה־PDF הזה באופן מאובטח
cfr-doorhanger-firefox-send-ok-button = לנסות את { -send-brand-name }
    .accesskey = ל

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = הצגת הגנות
    .accesskey = ג
cfr-doorhanger-socialtracking-close-button = סגירה
    .accesskey = ס
cfr-doorhanger-socialtracking-dont-show-again = לא להציג לי הודעות כאלו שוב
    .accesskey = ל
cfr-doorhanger-socialtracking-heading = { -brand-short-name } מנע מעקב של רשת חברתית כאן
cfr-doorhanger-socialtracking-description = הפרטיות שלך חשובה. { -brand-short-name } חוסם כעת רכיבי מעקב נפוצים של מדיה חברתית, ומגביל את כמות הנתונים שהם יכולים לאסוף על הפעילויות שלך ברשת.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } חסם כורה מטבעות דיגיטליים בדף זה
cfr-doorhanger-cryptominers-description = הפרטיות שלך חשובה. { -brand-short-name } חוסם כעת כורי מטבעות דיגיטליים, המשתמשים בכוח העיבוד של המערכת שלך כדי לכרות כסף דיגיטלי.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] ‏{ -brand-short-name } חסם יותר מרכיב מעקב אחד מאז { $date }!
       *[other] ‏{ -brand-short-name } חסם למעלה מ־<b>{ $blockedCount }</b> רכיבי מעקב מאז { $date }!
    }
cfr-doorhanger-milestone-ok-button = צפייה בהכל
    .accesskey = צ

cfr-doorhanger-milestone-close-button = סגירה
    .accesskey = ס

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = יצירת ססמאות מאובטחות בקלות
cfr-whatsnew-lockwise-icon-alt = סמל { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = קבלת התרעות על ססמאות פגיעות
cfr-whatsnew-passwords-body = פצחנים יודעים שאנשים משתמשים באותן הססמאות. אם השתמשת באותה הססמה במספר אתרים, ואחד מאותם האתרים נחשף בדליפת נתונים, תתקבל התרעה ב־{ -lockwise-brand-short-name } כדי לשנות את הססמה שלך באתרים אלה.
cfr-whatsnew-passwords-icon-alt = סמל מפתח ססמה פגיעה

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = העברת מצב תמונה בתוך תמונה למסך מלא
cfr-whatsnew-pip-fullscreen-icon-alt = סמל תמונה בתוך תמונה

## Protections Dashboard message

cfr-whatsnew-protections-header = הגנות במבט חטוף
cfr-whatsnew-protections-cta-link = הצגת לוח ההגנות
cfr-whatsnew-protections-icon-alt = סמל מגן

## Better PDF message

cfr-whatsnew-better-pdf-header = חוויית PDF טובה יותר

## DOH Message

cfr-doorhanger-doh-body = הפרטיות שלך חשובה. { -brand-short-name } מעביר כעת את בקשות ה־DNS שלך, כאשר ניתן, לשירות שותף כדי להגן עליך בזמן הגלישה.
cfr-doorhanger-doh-header = חיפושי DNS מוצפנים ומאובטחים יותר
cfr-doorhanger-doh-primary-button = בסדר, הבנתי
    .accesskey = ב
cfr-doorhanger-doh-secondary-button = השבתה
    .accesskey = ה

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = הגנה אוטומטית מפני תכסיסי מעקב
cfr-whatsnew-clear-cookies-body = ישנם רכיבי מעקב המפנים אותך לאתרים אחרים המגדירים עוגיות בחשאי. { -brand-short-name } כעת מנקה באופן אוטומטי את העוגיות האלו כך שלא יהיה ניתן לעקוב אחריך.
