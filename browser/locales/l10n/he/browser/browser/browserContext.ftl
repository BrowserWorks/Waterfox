# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] משיכה מטה כדי להציג היסטוריה
           *[other] לחיצה ימנית או משיכה מטה כדי להציג היסטוריה
        }

## Back

main-context-menu-back =
    .tooltiptext = חזרה דף אחד אחורה
    .aria-label = אחורה
    .accesskey = ז

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = התקדמות דף אחד קדימה
    .aria-label = קדימה
    .accesskey = ק

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = טעינה מחדש
    .accesskey = מ

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = עצירה
    .accesskey = ע

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = שמירת דף בשם…
    .accesskey = ב

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = יצירת סימנייה לדף זה
    .accesskey = ס
    .tooltiptext = יצירת סימנייה לדף זה

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = יצירת סימנייה לדף זה
    .accesskey = ס
    .tooltiptext = יצירת סימנייה לדף זה ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = עריכת סימנייה זו
    .accesskey = ס
    .tooltiptext = עריכת סימנייה זו

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = עריכת סימנייה זו
    .accesskey = ס
    .tooltiptext = עריכת סימנייה זו ({ $shortcut })

main-context-menu-open-link =
    .label = פתיחת קישור
    .accesskey = פ

main-context-menu-open-link-new-tab =
    .label = פתיחת קישור בלשונית חדשה
    .accesskey = ל

main-context-menu-open-link-container-tab =
    .label = פתיחת קישור במגירת לשוניות חדשה
    .accesskey = מ

main-context-menu-open-link-new-window =
    .label = פתיחת קישור בחלון חדש
    .accesskey = ח

main-context-menu-open-link-new-private-window =
    .label = פתיחת קישור בחלון פרטי חדש
    .accesskey = פ

main-context-menu-bookmark-this-link =
    .label = יצירת סימנייה לקישור זה
    .accesskey = ק

main-context-menu-save-link =
    .label = שמירת קישור בשם…
    .accesskey = מ

main-context-menu-save-link-to-pocket =
    .label = שמירת קישור אל { -pocket-brand-name }
    .accesskey = מ

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = העתקת כתובת דוא״ל
    .accesskey = כ

main-context-menu-copy-link =
    .label = העתקת מיקום קישור
    .accesskey = ה

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = ניגון
    .accesskey = נ

main-context-menu-media-pause =
    .label = השהיה
    .accesskey = ה

##

main-context-menu-media-mute =
    .label = השתקה
    .accesskey = ש

main-context-menu-media-unmute =
    .label = ביטול השתקה
    .accesskey = ש

main-context-menu-media-play-speed =
    .label = מהירות נגינה
    .accesskey = נ

main-context-menu-media-play-speed-slow =
    .label = אטית (0.5×)
    .accesskey = א

main-context-menu-media-play-speed-normal =
    .label = רגילה
    .accesskey = ר

main-context-menu-media-play-speed-fast =
    .label = מהירה (1.25×)
    .accesskey = מ

main-context-menu-media-play-speed-faster =
    .label = מהירה יותר (1.5×)
    .accesskey = י

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = מטורפת (2×)
    .accesskey = ט

main-context-menu-media-loop =
    .label = לולאה
    .accesskey = ל

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = הצגת פקדים
    .accesskey = פ

main-context-menu-media-hide-controls =
    .label = הסתרת פקדים
    .accesskey = פ

##

main-context-menu-media-video-fullscreen =
    .label = מסך מלא
    .accesskey = מ

main-context-menu-media-video-leave-fullscreen =
    .label = יציאה ממסך מלא
    .accesskey = י

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = תמונה בתוך תמונה
    .accesskey = ב

main-context-menu-image-reload =
    .label = טעינת תמונה מחדש
    .accesskey = ת

main-context-menu-image-view =
    .label = הצגת תמונה
    .accesskey = צ

main-context-menu-video-view =
    .label = צפיה בוידאו
    .accesskey = צ

main-context-menu-image-copy =
    .label = העתקת תמונה
    .accesskey = ת

main-context-menu-image-copy-location =
    .label = העתקת מיקום תמונה
    .accesskey = ע

main-context-menu-video-copy-location =
    .label = העתקת מיקום וידאו
    .accesskey = ה

main-context-menu-audio-copy-location =
    .label = העתקת מיקום אודיו
    .accesskey = ה

main-context-menu-image-save-as =
    .label = שמירת תמונה בשם…
    .accesskey = ב

main-context-menu-image-email =
    .label = שליחת תמונה בדוא״ל…
    .accesskey = ת

main-context-menu-image-set-as-background =
    .label = קביעה כתמונת רקע בשולחן העבודה…
    .accesskey = כ

main-context-menu-image-info =
    .label = הצגת פרטי תמונה
    .accesskey = מ

main-context-menu-image-desc =
    .label = הצגת תיאור
    .accesskey = ת

main-context-menu-video-save-as =
    .label = שמירת וידאו בשם…
    .accesskey = מ

main-context-menu-audio-save-as =
    .label = שמירת אודיו בשם…
    .accesskey = מ

main-context-menu-video-image-save-as =
    .label = שמירת צילום בשם…
    .accesskey = צ

main-context-menu-video-email =
    .label = שליחת וידאו בדוא״ל…
    .accesskey = ו

main-context-menu-audio-email =
    .label = שליחת אודיו בדוא״ל…
    .accesskey = א

main-context-menu-plugin-play =
    .label = הפעלת תוסף חיצוני זה
    .accesskey = ת

main-context-menu-plugin-hide =
    .label = הסתרת תוסף חיצוני זה
    .accesskey = ס

main-context-menu-save-to-pocket =
    .label = שמירת דף אל { -pocket-brand-name }
    .accesskey = ש

main-context-menu-send-to-device =
    .label = שליחת דף למכשיר
    .accesskey = מ

main-context-menu-view-background-image =
    .label = הצגת תמונת רקע
    .accesskey = ת

main-context-menu-keyword =
    .label = הוספת מילת מפתח לחיפוש זה…
    .accesskey = ס

main-context-menu-link-send-to-device =
    .label = שליחת קישור למכשיר
    .accesskey = מ

main-context-menu-frame =
    .label = מסגרת זו
    .accesskey = ג

main-context-menu-frame-show-this =
    .label = הצגת מסגרת זו בלבד
    .accesskey = ה

main-context-menu-frame-open-tab =
    .label = פתיחת מסגרת בלשונית חדשה
    .accesskey = ל

main-context-menu-frame-open-window =
    .label = פתיחת מסגרת בחלון חדש
    .accesskey = ח

main-context-menu-frame-reload =
    .label = טעינת מסגרת מחדש
    .accesskey = ט

main-context-menu-frame-bookmark =
    .label = יצירת סימנייה למסגרת זו
    .accesskey = מ

main-context-menu-frame-save-as =
    .label = שמירת מסגרת בשם…
    .accesskey = מ

main-context-menu-frame-print =
    .label = הדפסת מסגרת…
    .accesskey = ה

main-context-menu-frame-view-source =
    .label = הצגת מקור המסגרת
    .accesskey = מ

main-context-menu-frame-view-info =
    .label = הצגת מידע על המסגרת
    .accesskey = ד

main-context-menu-view-selection-source =
    .label = הצגת קוד מקור של קטע נבחר
    .accesskey = ה

main-context-menu-view-page-source =
    .label = הצגת מקור הדף
    .accesskey = מ

main-context-menu-view-page-info =
    .label = הצגת מידע על הדף
    .accesskey = ד

main-context-menu-bidi-switch-text =
    .label = הפוך כיוון כתיבה
    .accesskey = כ

main-context-menu-bidi-switch-page =
    .label = הפיכת כיוון דף
    .accesskey = פ

main-context-menu-inspect-element =
    .label = חקירת רכיב
    .accesskey = ח

main-context-menu-inspect-a11y-properties =
    .label = חקירת מאפייני נגישות

main-context-menu-eme-learn-more =
    .label = מידע נוסף על ניהול זכויות דיגיטלי…
    .accesskey = ז

