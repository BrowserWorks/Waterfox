# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (גלישה פרטית)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (גלישה פרטית)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (גלישה פרטית)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (גלישה פרטית)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = הצגת נתוני אתר

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = פתיחת חלונית הודעת התקנה
urlbar-web-notification-anchor =
    .tooltiptext = החלפת מצב קבלת התרעות מהאתר
urlbar-midi-notification-anchor =
    .tooltiptext = פתיחת חלונית MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = ניהול השימוש בתכניות DRM
urlbar-web-authn-anchor =
    .tooltiptext = פתיחת חלונית Web Authentication
urlbar-canvas-notification-anchor =
    .tooltiptext = ניהול הרשאות חילוץ ממשטח ציור
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = ניהול שיתוף המיקרופון שלך עם האתר
urlbar-default-notification-anchor =
    .tooltiptext = פתיחת חלונית הודעות
urlbar-geolocation-notification-anchor =
    .tooltiptext = פתיחת חלונית בקשת מיקום
urlbar-xr-notification-anchor =
    .tooltiptext = פתיחת חלונית הרשאות למציאות מדומה
urlbar-storage-access-anchor =
    .tooltiptext = פתיחת חלונית הרשאות לפעילות בדפדפן
urlbar-translate-notification-anchor =
    .tooltiptext = תרגום עמוד זה
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = ניהול שיתוף החלונות או המסך שלך עם האתר
urlbar-indexed-db-notification-anchor =
    .tooltiptext = פתיחת חלונית הודעת אחסון לא מקוון
urlbar-password-notification-anchor =
    .tooltiptext = פתיחת חלונית הודעת שמירת ססמה
urlbar-translated-notification-anchor =
    .tooltiptext = ניהול תרגומי עמודים
urlbar-plugins-notification-anchor =
    .tooltiptext = ניהול שימוש בתוספים חיצוניים
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = ניהול שיתוף המצלמה ו/או המיקרופון שלך עם האתר
urlbar-autoplay-notification-anchor =
    .tooltiptext = פתיחת לוח ניגון אוטומטי
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = שמירת נתונים באחסון קבוע
urlbar-addons-notification-anchor =
    .tooltiptext = פתיחת חלונית ההודעות של התקנת תוספות
urlbar-tip-help-icon =
    .title = קבלת עזרה
urlbar-search-tips-confirm = בסדר, הבנתי
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = עצה:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = מהיום מקלידים פחות ומוצאים יותר: אפשר לחפש עם { $engineName } ישירות משורת הכתובת שלך.
urlbar-search-tips-redirect-2 = ניתן להתחיל לחפש בשורת הכתובת כדי לצפות בהצעות מ־{ $engineName } ובהיסטוריית הגלישה שלך.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = סימניות
urlbar-search-mode-tabs = לשוניות
urlbar-search-mode-history = היסטוריה

##

urlbar-geolocation-blocked =
    .tooltiptext = חסמת מפני האתר הזה לגשת לנתוני המיקום שלך.
urlbar-xr-blocked =
    .tooltiptext = חסמת גישה למכשיר מציאות מדומה עבור אתר זה.
urlbar-web-notifications-blocked =
    .tooltiptext = חסמת התרעות עבור אתר זה.
urlbar-camera-blocked =
    .tooltiptext = חסמת את המצלמה שלך עבור אתר זה.
urlbar-microphone-blocked =
    .tooltiptext = חסמת את המיקרופון שלך עבור אתר זה.
urlbar-screen-blocked =
    .tooltiptext = חסמת מפני האתר הזה את האפשרות לשתף את המסך שלך.
urlbar-persistent-storage-blocked =
    .tooltiptext = חסמת את האתר הזה משמירת נתונים קבועים.
urlbar-popup-blocked =
    .tooltiptext = חסמת חלונות קופצים עבור אתר זה.
urlbar-autoplay-media-blocked =
    .tooltiptext = חסמת ניגון אוטומטי של מדיה עם קול עבור אתר זה.
urlbar-canvas-blocked =
    .tooltiptext = חסמת חילוץ נתוני משטחי ציור עבור אתר זה.
urlbar-midi-blocked =
    .tooltiptext = חסמת גישת MIDI עבור אתר זה.
urlbar-install-blocked =
    .tooltiptext = חסמת התקנת תוספות עבור אתר זה.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = עריכת סימנייה זו ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = יצירת סימנייה לדף זה ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = הוספה לשורת הכתובת
page-action-manage-extension =
    .label = ניהול הרחבה…
page-action-remove-from-urlbar =
    .label = הסרה משורת הכתובת
page-action-remove-extension =
    .label = הסרת הרחבה

## Auto-hide Context Menu

full-screen-autohide =
    .label = הסתרת סרגלים
    .accesskey = ה
full-screen-exit =
    .label = יציאה ממצב מסך מלא
    .accesskey = צ

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = הפעם, לחפש באמצעות:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = שינוי הגדרות החיפוש
search-one-offs-change-settings-compact-button =
    .tooltiptext = שינוי הגדרות החיפוש
search-one-offs-context-open-new-tab =
    .label = חיפוש בלשונית חדשה
    .accesskey = ל
search-one-offs-context-set-as-default =
    .label = הגדרה כמנוע חיפוש ברירת מחדל
    .accesskey = ב
search-one-offs-context-set-as-default-private =
    .label = הגדרה כמנוע חיפוש ברירת המחדל עבור חלונות פרטיים
    .accesskey = ג
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = סימניות ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = לשוניות ({ $restrict })
search-one-offs-history =
    .tooltiptext = היסטוריה ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = הצגת העורך בזמן שמירה
    .accesskey = ה
bookmark-panel-done-button =
    .label = סיום
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = החיבור אינו מאובטח
identity-connection-secure = החיבור מאובטח
identity-connection-internal = דף זה הנו דף מאובטח של { -brand-short-name }.
identity-connection-file = דף זה מאוחסן במחשב שלך.
identity-extension-page = עמוד זה נטען מתוך הרחבה.
identity-active-blocked = { -brand-short-name } חסם חלקים מהדף שאינם בטוחים.
identity-custom-root = חיבור מאומת על־ידי מנפיק אישורים שאינו מזוהה על־ידי Mozilla.
identity-passive-loaded = חלקים מדף זה אינם מאובטחים (כגון תמונות).
identity-active-loaded = ניטרלת את אמצעי האבטחה על דף זה.
identity-weak-encryption = דף זה משתמש בהצפנה חלשה.
identity-insecure-login-forms = פרטי ההתחברות המוזנים בעמוד זה עשויים להיות חשופים בפני גורמי צד שלישי.
identity-permissions =
    .value = הרשאות
identity-permissions-reload-hint = יתכן שיהיה עליך לרענן את העמוד כדי שהשינויים ייכנסו לתוקף.
identity-permissions-empty = לא סופקו לאתר זה הרשאות מיוחדות.
identity-clear-site-data =
    .label = ניקוי עוגיות ונתוני אתרים…
identity-connection-not-secure-security-view = החיבור שלך לאתר זה אינו מאובטח.
identity-connection-verified = החיבור שלך לאתר זה מאובטח.
identity-ev-owner-label = האישור הונפק עבור:
identity-description-custom-root = ‏Mozilla אינה מזהה את מנפיק האישורים הזה. ייתכן שהוא נוסף ממערכת ההפעלה שלך או על־ידי מנהל מערכת. <label data-l10n-name="link">מידע נוסף</label>
identity-remove-cert-exception =
    .label = הסרת חריגה
    .accesskey = ס
identity-description-insecure = החיבור שלך לאתר זה אינו פרטי. המידע שנשלח זמין לצפייה לאחרים (כגון ססמאות, הודעות, כרטיסי אשראי וכו׳).
identity-description-insecure-login-forms = פרטי ההתחברות שיוכנסו בדף זה אינם מאובטחים ועלולים להיות בסכנה.
identity-description-weak-cipher-intro = החיבור שלך לאתר זה משתמש בהצפנה חלשה ואינו פרטי.
identity-description-weak-cipher-risk = אנשים אחרים יכולים לצפות במידע שלך או לשנות את התנהגות האתר.
identity-description-active-blocked = { -brand-short-name } חסם חלקים שאינם בטוחים בדף זה. <label data-l10n-name="link">מידע נוסף</label>
identity-description-passive-loaded = החיבור שלך לאתר זה אינו פרטי, ומידע שישותף עם האתר עשוי להיות נגיש לאחרים.
identity-description-passive-loaded-insecure = אתר זה מכיל תוכן שאינו מאובטח (כגון תמונות). <label data-l10n-name="link">מידע נוסף</label>
identity-description-passive-loaded-mixed = למרות ש־{ -brand-short-name } חסם חלק מהתוכן, עדיין קיים בדף תוכן שאינו מאובטח (כגון תמונות). <label data-l10n-name="link">מידע נוסף</label>
identity-description-active-loaded = אתר זה מכיל תוכן שאינו מאובטח (כגון תסריטים) והחיבור שלך אליו אינו פרטי.
identity-description-active-loaded-insecure = מידע שישותף עם אתר זה, כגון ססמאות, הודעות, פרטי כרטיס האשראי וכדומה, עשוי להיות נגיש לאחרים.
identity-learn-more =
    .value = מידע נוסף
identity-disable-mixed-content-blocking =
    .label = השבתת ההגנה לבינתיים
    .accesskey = ש
identity-enable-mixed-content-blocking =
    .label = הפעלת הגנה
    .accesskey = פ
identity-more-info-link-text =
    .label = מידע נוסף

## Window controls

browser-window-minimize-button =
    .tooltiptext = מזעור
browser-window-maximize-button =
    .tooltiptext = הגדלה
browser-window-restore-down-button =
    .tooltiptext = שחזור כלפי מטה
browser-window-close-button =
    .tooltiptext = סגירה

## WebRTC Pop-up notifications

popup-select-camera =
    .value = מצלמה לשיתוף:
    .accesskey = צ
popup-select-microphone =
    .value = מיקרופון לשיתוף:
    .accesskey = מ
popup-all-windows-shared = ישותפו כל החלונות הגלויים על המסך.
popup-screen-sharing-not-now =
    .label = לא כעת
    .accesskey = ל
popup-screen-sharing-never =
    .label = לעולם לא לאפשר
    .accesskey = ע
popup-silence-notifications-checkbox = השבתת התרעות מ־{ -brand-short-name } בזמן שיתוף
popup-silence-notifications-checkbox-warning = ‏{ -brand-short-name } לא יציג התרעות בזמן השיתוף.

## WebRTC window or screen share tab switch warning

sharing-warning-window = { -brand-short-name } משותף כעת. אנשים אחרים יכולים לראות כשיבוצע מעבר ללשונית חדשה.
sharing-warning-screen = כל המסך שלך משותף כעת. אנשים אחרים יכולים לראות כשיבוצע מעבר ללשונית חדשה.
sharing-warning-proceed-to-tab =
    .label = המשך ללשונית
sharing-warning-disable-for-session =
    .label = השבתת הגנת השיתוף עבור הפעלה זו

## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = חיפוש או הקלדת כתובת
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = חיפוש או הקלדת כתובת
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = חיפוש ברשת
    .aria-label = חיפוש באמצעות { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = נא להקליד מונח לחיפוש
    .aria-label = חיפוש ב־{ $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = נא להקליד מונח לחיפוש
    .aria-label = חיפוש בסימניות
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = נא להקליד מונח לחיפוש
    .aria-label = חיפוש בהיסטוריה
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = נא להקליד מונח לחיפוש
    .aria-label = חיפוש בלשוניות
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = ‏ניתן לחפש עם { $name } או להקליד כתובת
urlbar-remote-control-notification-anchor =
    .tooltiptext = הדפדפן נשלט מרחוק
urlbar-permissions-granted =
    .tooltiptext = הענקת לאתר זה הרשאות נוספות.
urlbar-switch-to-tab =
    .value = מעבר ללשונית:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = הרחבה:
urlbar-go-button =
    .tooltiptext = מעבר לכתובת שבסרגל המיקום
urlbar-page-action-button =
    .tooltiptext = פעולות דף
urlbar-pocket-button =
    .tooltiptext = שמירה אל { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> כעת במסך מלא
fullscreen-warning-no-domain = מסמך זה כעת במסך מלא
fullscreen-exit-button = יציאה ממסך מלא (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = יציאה ממסך מלא (Esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = לאתר בכתובת <span data-l10n-name="domain">{ $domain }</span> יש שליטה על הסמן שלך. לחיצה על ESC תחזיר את השליטה אליך.
pointerlock-warning-no-domain = למסמך זה יש שליטה על הסמן שלך. לחיצה על ESC תחזיר את השליטה אליך.
