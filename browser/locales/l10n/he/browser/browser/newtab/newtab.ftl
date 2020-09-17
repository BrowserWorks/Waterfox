# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = לשונית חדשה
newtab-settings-button =
    .title = התאמה אישית של דף הלשונית החדשה שלך

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = חיפוש
    .aria-label = חיפוש

newtab-search-box-search-the-web-text = חיפוש ברשת
newtab-search-box-search-the-web-input =
    .placeholder = חיפוש ברשת
    .title = חיפוש ברשת
    .aria-label = חיפוש ברשת

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = הוספת מנוע חיפוש
newtab-topsites-add-topsites-header = אתר מוביל חדש
newtab-topsites-edit-topsites-header = עריכת אתר מוביל
newtab-topsites-title-label = כותרת
newtab-topsites-title-input =
    .placeholder = נא להזין כותרת

newtab-topsites-url-label = כתובת
newtab-topsites-url-input =
    .placeholder = נא להקליד או להזין כתובת
newtab-topsites-url-validation = נדרשת כתובת תקינה

newtab-topsites-image-url-label = כתובת תמונה מותאמת אישית
newtab-topsites-use-image-link = שימוש בתמונה מותאמת אישית…
newtab-topsites-image-validation = טעינת התמונה נכשלה. נא לנסות כתובת שונה.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = ביטול
newtab-topsites-delete-history-button = מחיקה מההיסטוריה
newtab-topsites-save-button = שמירה
newtab-topsites-preview-button = תצוגה מקדימה
newtab-topsites-add-button = הוספה

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = למחוק כל עותק של העמוד הזה מההיסטוריה שלך?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = לא ניתן לבטל פעולה זו.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = פתיחת תפריט
    .aria-label = פתיחת תפריט

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = הסרה
    .aria-label = הסרה

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = פתיחת תפריט
    .aria-label = פתיחת תפריט ההקשר עבור { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = עריכת אתר זה
    .aria-label = עריכת אתר זה

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = עריכה
newtab-menu-open-new-window = פתיחה בחלון חדש
newtab-menu-open-new-private-window = פתיחה בחלון פרטי חדש
newtab-menu-dismiss = הסרה
newtab-menu-pin = נעיצה
newtab-menu-unpin = ביטול נעיצה
newtab-menu-delete-history = מחיקה מההיסטוריה
newtab-menu-save-to-pocket = שמירה אל { -pocket-brand-name }
newtab-menu-delete-pocket = מחיקה מ־{ -pocket-brand-name }
newtab-menu-archive-pocket = העברה לארכיון ב־{ -pocket-brand-name }

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = סיום
newtab-privacy-modal-button-manage = ניהול הגדרות תוכן ממומן
newtab-privacy-modal-header = הפרטיות שלך חשובה.

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = הסרת סימנייה
# Bookmark is a verb here.
newtab-menu-bookmark = הוספת סימנייה

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = העתקת קישור ההורדה
newtab-menu-go-to-download-page = מעבר לעמוד ההורדה
newtab-menu-remove-download = הסרה מההיסטורייה

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] הצגה ב־Finder
       *[other] פתיחת תיקייה מכילה
    }
newtab-menu-open-file = פתיחת הקובץ

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = ביקורים קודמים
newtab-label-bookmarked = שמור כסימנייה
newtab-label-removed-bookmark = הסימנייה הוסרה
newtab-label-recommended = פופולרי
newtab-label-saved = נשמר ל־{ -pocket-brand-name }
newtab-label-download = התקבל

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · ממומן

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = בחסות { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = הסרת מדור
newtab-section-menu-collapse-section = צמצום מדור
newtab-section-menu-expand-section = הרחבת מדור
newtab-section-menu-manage-section = ניהול מדור
newtab-section-menu-manage-webext = ניהול הרחבה
newtab-section-menu-add-topsite = הוספת אתר מוביל
newtab-section-menu-add-search-engine = הוספת מנוע חיפוש
newtab-section-menu-move-up = העברה למעלה
newtab-section-menu-move-down = העברה למטה
newtab-section-menu-privacy-notice = הצהרת פרטיות

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = צמצום מדור
newtab-section-expand-section-label =
    .aria-label = הרחבת מדור

## Section Headers.

newtab-section-header-topsites = אתרים מובילים
newtab-section-header-highlights = מומלצים
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = מומלץ על־ידי { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = ניתן להתחיל בגלישה ואנו נציג בפניך מספר כתבות, סרטונים ועמודים שונים מעולים בהם ביקרת לאחרונה או שהוספת לסימניות.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = התעדכנת בכל הסיפורים. כדאי לנסות שוב מאוחר יותר כדי לקבל עוד סיפורים מובילים מאת { $provider }. לא רוצה לחכות? ניתן לבחור נושא נפוץ כדי למצוא עוד סיפורים נפלאים מרחבי הרשת.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-try-again-button = ניסיון חוזר
newtab-discovery-empty-section-topstories-loading = בטעינה…

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = נושאים פופולריים:
newtab-pocket-more-recommendations = המלצות נוספות
newtab-pocket-learn-more = מידע נוסף
newtab-pocket-cta-button = קבלת { -pocket-brand-name }
newtab-pocket-cta-text = שמירת הסיפורים שאהבת ב־{ -pocket-brand-name } על מנת למלא את מחשבתך בקריאה מרתקת.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = אופס, משהו השתבש בעת טעינת התוכן הזה.
newtab-error-fallback-refresh-link = נא לרענן את הדף כדי לנסות שוב.
