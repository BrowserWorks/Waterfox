# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = על אודות פרופילים
profiles-subtitle = עמוד זה מאפשר לך לנהל את הפרופילים שלך. כל פרופיל הוא עולם נפרד המכיל היסטוריה, סימניות הגדרות ותוספות.
profiles-create = יצירת פרופיל חדש
profiles-restart-title = הפעלה מחדש
profiles-restart-in-safe-mode = הפעלה מחדש עם תוספות מנוטרלות…
profiles-restart-normal = הפעלה רגילה מחדש…
profiles-conflict = עותק נוסף של { -brand-product-name } ביצע שינויים לפרופילים. יש להפעיל את { -brand-short-name } מחדש לפני ביצוע שינויים נוספים.
profiles-flush-fail-title = השינויים לא נשמרו
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = שגיאה בלתי צפויה מנעה את שמירת השינויים שלך.
profiles-flush-restart-button = הפעלת { -brand-short-name } מחדש

# Variables:
#   $name (String) - Name of the profile
profiles-name = פרופיל: { $name }
profiles-is-default = פרופיל בררת המחדל
profiles-rootdir = ספריית השורש

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = ספרייה מקומית
profiles-current-profile = זה הפרופיל שבשימוש ולא ניתן למחוק אותו.
profiles-in-use-profile = פרופיל זה בשימוש ביישום אחר ולכן לא ניתן למחוק אותו.

profiles-rename = שינוי שם
profiles-remove = הסרה
profiles-set-as-default = הגדרה כפרופיל בררת המחדל
profiles-launch-profile = הפעלת פרופיל בדפדפן חדש

profiles-cannot-set-as-default-title = לא ניתן להגדיר כברירת מחדל
profiles-cannot-set-as-default-message = לא ניתן לשנות את פרופיל ברירת המחדל עבור { -brand-short-name }.

profiles-yes = כן
profiles-no = לא

profiles-rename-profile-title = שינוי שם פרופיל
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = שינוי שם הפרופיל { $name }

profiles-invalid-profile-name-title = שם פרופיל לא חוקי
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = לא ניתן להשתמש בשם ״{ $name }״ כשם לפרופיל.

profiles-delete-profile-title = מחיקת פרופיל
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    מחיקת פרופיל תסיר את הפרופיל מרשימת הפרופילים הזמינים ולא ניתן יהיה להשיבו.
    כמו־כן ניתן לבחור למחוק את קובצי הנתונים של הפרופיל, כולל ההגדרות, האישורים, ושאר נתוני המשתמש. אפשרות זו תמחק את התיקייה “{ $dir }” ולא ניתן יהיה להשיבה.
    למחוק את קובצי הנתונים של הפרופיל?
profiles-delete-files = למחוק קבצים
profiles-dont-delete-files = לא למחוק קבצים

profiles-delete-profile-failed-title = שגיאה
profiles-delete-profile-failed-message = אירעה שגיאה בעת ניסיון למחוק פרופיל זה.


profiles-opendir =
    { PLATFORM() ->
        [macos] הצגה ב־Finder
        [windows] פתיחת תיקייה
       *[other] פתיחת ספרייה
    }
