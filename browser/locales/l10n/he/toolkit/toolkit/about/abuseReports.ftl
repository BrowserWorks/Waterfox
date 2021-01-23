# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title.
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = דיווח עבור { $addon-name }

abuse-report-title-extension = דיווח על הרחבה זו ל־{ -vendor-short-name }
abuse-report-title-theme = דיווח על ערכת נושא זו ל־{ -vendor-short-name }
abuse-report-subtitle = מה הבעיה?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = מאת <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore = בהתלבטות באיזו בעיה לבחור? <a data-l10n-name="learnmore-link">מידע נוסף על דיווח הרחבות וערכות נושא</a>

abuse-report-submit-description = תיאור הבעיה (לא חובה)
abuse-report-textarea =
    .placeholder = קל לנו יותר לטפל בבעיה אם יש לנו פרטים. נא לתאר את מה שחווית. תודה על העזרה בשמירה על בריאות הרשת.
abuse-report-submit-note = לתשומך לבך: אין לכלול פרטים אישיים (כמו שם, כתובת דוא״ל, מספר טלפון, כתובת פיזית). { -vendor-short-name } שומרת תיעוד קבוע של דיווחים אלו.

## Panel buttons.

abuse-report-cancel-button = ביטול
abuse-report-next-button = הבא
abuse-report-goback-button = חזרה אחורה
abuse-report-submit-button = שליחה

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = הדיווח עבור <span data-l10n-name="addon-name">{ $addon-name }</span> בוטל.
abuse-report-messagebar-submitting = בשליחת דיווח עבור <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = תודה ששלחת את הדיווח. האם ברצונך להסיר את <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = תודה ששלחת את הדיווח.
abuse-report-messagebar-removed-extension = תודה ששלחת את הדיווח. הסרת את ההרחבה <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = תודה ששלחת את הדיווח. הסרת את ערכת הנושא <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = אירעה שגיאה בשליחת הדיווח עבור <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = הדיווח עבור <span data-l10n-name="addon-name">{ $addon-name }</span> לא נשלח מכיוון שדיווח נוסף נשלח לאחרונה.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = כן, להסיר אותה
abuse-report-messagebar-action-keep-extension = לא, אשמור אותה
abuse-report-messagebar-action-remove-theme = כן, להסיר אותה
abuse-report-messagebar-action-keep-theme = לא, אשמור אותה
abuse-report-messagebar-action-retry = ניסיון חוזר
abuse-report-messagebar-action-cancel = ביטול

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = היא הזיקה למחשב שלי או שפגעה בנתונים שלי
abuse-report-damage-example = לדוגמה: נוזקה מושתלת או מידע גנוב

abuse-report-spam-reason-v2 = היא מכילה ספאם או מוסיפה פרסומות לא רצויות
abuse-report-spam-example = לדוגמה: מוסיפה פרסומות בדפי אינטרנט

abuse-report-settings-reason-v2 = היא שינתה את מנוע החיפוש, דף הבית או הלשונית החדשה שלי מבלי ליידע או לשאול אותי
abuse-report-settings-suggestions = לפני דיווח על ההרחבה, באפשרותך לנסות לשנות את ההגדרות שלך:
abuse-report-settings-suggestions-search = שינוי הגדרות חיפוש ברירת מחדל
abuse-report-settings-suggestions-homepage = שינוי דף הבית והלשונית החדשה שלך

abuse-report-broken-reason-extension-v2 = היא לא עובדת, משבשת פעילות של אתרי אינטרנט או שמאטה את { -brand-product-name }
abuse-report-broken-reason-theme-v2 = היא לא עובדת או שמשבשת את ניראות הדפדפן
abuse-report-broken-example = לדוגמה: תכונות איטיות, קשה לשימוש או שאינה פועלת; חלקים מאתרי אינטרנט לא נטענים או לא נראים כשורה

abuse-report-policy-reason-v2 = היא מכילה תוכן של שנאה, אלימות או תוכן בלתי חוקי
abuse-report-policy-suggestions =
    לתשומת לבך: יש לדווח על בעיות בנושא זכויות יוצרים וסימנים מסחריים בתהליך נפרד.
    <a data-l10n-name="report-infringement-link">ניתן להשתמש בהוראות האלו</a> כדי
    לדווח על הבעיה.

abuse-report-unwanted-reason-v2 = אף פעם לא רציתי את ההרחבה הזו ולא ניתן להסיר אותה
abuse-report-unwanted-example = לדוגמה: יישום התקין אותה ללא רשותי

abuse-report-other-reason = משהו אחר

