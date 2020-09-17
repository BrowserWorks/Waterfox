# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = ایڈ اون مینیجر

addons-page-title = ایڈ اون مینیجر

search-header =
    .placeholder = addons.mozilla.org تلاش کریں
    .searchbuttonlabel = تلاش

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = آپ کے پاس اس قسم کے کوئی ایڈ اون تنصیب شدہ نہیں

list-empty-available-updates =
    .value = کوئی تازہ کاریاں نہیں ملیں

list-empty-recent-updates =
    .value = آپ نے حالیہ طور پر کوئی ایڈ اون تازہ نہیں کیے

list-empty-find-updates =
    .label = تازہ کاریوں کے لیے چیک کریں

list-empty-button =
    .label = ایڈ اون کے بارے میں اور سیکھیں

help-button = ایڈ اون ہمایت کردہ

sidebar-help-button-title =
    .title = ایڈ اون ہمایت کردہ

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } اختیارات
       *[other] { -brand-short-name } ترجیحات
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } اختیارات
           *[other] { -brand-short-name } ترجیحات
        }

show-unsigned-extensions-button =
    .label = کچھ ایکسٹِنشنز کی تصدیق نہیں ہو سکی

show-all-extensions-button =
    .label = تمام ایکسٹینشنز دکھائیں

cmd-show-details =
    .label = مزید معلومات دکھائیں
    .accesskey = د

cmd-find-updates =
    .label = تازہ کاریاں ڈھونڈیں
    .accesskey = ڈ

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] اختیارات
           *[other] ترجیحات
        }
    .accesskey =
        { PLATFORM() ->
            [windows] ا
           *[other] ت
        }

cmd-enable-theme =
    .label = خیالیہ پہنیں
    .accesskey = خ

cmd-disable-theme =
    .label = خیالیہ پہننا بند کر دیں
    .accesskey = پ

cmd-install-addon =
    .label = تنصیب کریں
    .accesskey = ت

cmd-contribute =
    .label = حصہ لیں
    .accesskey = ح
    .tooltiptext = اس ایڈ اون کی تکمیل کاری میں حصہ لیں

detail-version =
    .label = ورژن

detail-last-updated =
    .label = آخری تازہ کاری

detail-contributions-description = اس ایڈ اون کا ڈیولپر آپ سے درخواست کرتا ہے کہ آپ اس کی جاری تکمیل کاری کو کچھ مدد دے کر اس کی معاونت کریں۔

detail-contributions-button = تعاون کریں
    .title = اس ایڈ اون کے ڈیولپمینٹ میں تعاون کریں
    .accesskey = C

detail-update-type =
    .value = خودکار تازہ کاریاں

detail-update-default =
    .label = طے شدہ
    .tooltiptext = تازہ کاریاں خود بخود صرف تب تنصیب کریں جب یہ طےشدہ ہو

detail-update-automatic =
    .label = آن
    .tooltiptext = تازہ کاریاں خود بخود تنصیب کریں

detail-update-manual =
    .label = آف کریں
    .tooltiptext = تازہ کاریاں خود بخود تنصیب مت کریں

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = نجی ونڈوز میں چلائیں

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = نجی ونڈوز میں اجازت نہیں ہے

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = نجی ونڈوز تک رسائی کی ضرورت ہے

detail-private-browsing-on =
    .label = اجازت دیں
    .tooltiptext = نجی براؤزنگ میں فاعال بنایں

detail-private-browsing-off =
    .label = اجازت مت دیں
    .tooltiptext = نجی براؤزنگ میں غیر فعال کریں

detail-home =
    .label = ابتدائی صفحہ

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = ایڈ اون پروفائل

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = تازہ کاریوں کے لیے پڑتال کریں
    .accesskey = ت
    .tooltiptext = اس ایڈ اون کے لیے تازہ کاریوں کی پڑتال کریں

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] اختیارات
           *[other] ترجیحات
        }
    .accesskey =
        { PLATFORM() ->
            [windows] ا
           *[other] ت
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] اس ایڈ اون کے اختیارات تبدیل کریں
           *[other] اس ایڈ اون کی ترجیحات تبدیل کریں
        }

detail-rating =
    .value = شرح کاری

addon-restart-now =
    .label = ابھی دوباره شروع کریں

disabled-unsigned-heading =
    .value = کچھ ایڈ اون نااہل کر دیئے گئے ہیں

disabled-unsigned-description = مندرجہ ذیل ایڈ اون { -brand-short-name } میں استعمال کے لیے تصدیق نہیں کیئے گئے۔ آپ <label data-l10n-name="find-addons">تبدیلیاں ڈھونڈیں</label> یا پھر ان کی تصدیق کروانے کے لیے تخلیق کار سے کہیں۔

disabled-unsigned-learn-more = آپ کو آن لائن محفوظ رکھنے کے لیئے ہماری کوششوں کے بارے میں مزید سیکھیں۔

disabled-unsigned-devinfo = وہ ڈیولپر جو اپنے ایڈ اون تصدیق کروانا چاہتے ہیں آگے بڑھنے کے لیے یہ پڑھ سکتے ہیں <label data-l10n-name="learn-more">دستورالعمل</label>.

plugin-deprecation-description = کسی شہ کی کمی ہے؟ { -brand-short-name }. کی جانب سے کچھ بلگ ان میں تعاون اب نہیں رہا  <label data-l10n-name="learn-more">مزید سیکھیں۔</label>

legacy-warning-show-legacy = میراث توسیعات دکھائیں

legacy-extensions =
    .value = میراث ایکسٹینشن

addon-category-discover = سفارشات
addon-category-discover-title =
    .title = سفارشات
addon-category-extension = ایکسٹینشن
addon-category-extension-title =
    .title = ایکسٹینشن
addon-category-theme = خیالیے
addon-category-theme-title =
    .title = خیالیے
addon-category-plugin = پلگ ان
addon-category-plugin-title =
    .title = پلگ ان
addon-category-dictionary = لغات
addon-category-dictionary-title =
    .title = لغات
addon-category-locale = زبانیں
addon-category-locale-title =
    .title = زبانیں
addon-category-available-updates = دستیاب تازہ کاریاں
addon-category-available-updates-title =
    .title = دستیاب تازہ کاریاں
addon-category-recent-updates = حالیہ تازہ کاریاں
addon-category-recent-updates-title =
    .title = حالیہ تازہ کاریاں

## These are global warnings

extensions-warning-safe-mode = محفوظ موڈ کے تحت تمام ایڈ اون نا اہل ہیں۔
extensions-warning-check-compatibility = ایڈ اون موازنت کی پڑتال نا اہل ہے۔ آپ کے پاس غیر موازن ایڈ اون ہو سکتے ہیں۔
extensions-warning-check-compatibility-button = اہل بنائیں
    .title = ایڈ اون موازنت پڑتال اہل بنائیں
extensions-warning-update-security = ایڈ اون سلامتی پڑتال نا اہل ہے۔ آپ کو تازہ کاریوں سے مسلہ ہو سکتا ہے۔
extensions-warning-update-security-button = اہل بنائیں
    .title = ایڈ اون تازہ کاری سلامتی پڑتال کو اہل بنائیں


## Strings connected to add-on updates

addon-updates-check-for-updates = تازہ کاریوں کے لیے پڑتال کریں
    .accesskey = پ
addon-updates-view-updates = حالیہ تازہ کاریاں نظارہ کریں
    .accesskey = ن

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = ایڈ اون خود بخود تازہ کریں
    .accesskey = ا

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = تما ایڈ اون کو خود بخود تازہ ہونے کے لیے پھر سیٹ کریں
    .accesskey = پ
addon-updates-reset-updates-to-manual = تما ایڈ اون کو دستی بہ تازہ ہونے کے لیے پھر سیٹ کریں
    .accesskey = پ

## Status messages displayed when updating add-ons

addon-updates-updating = ایڈ اون تازہ کر رہا ہے
addon-updates-installed = آپ کے ایڈ اون تازہ ہو گئے ہیں۔
addon-updates-none-found = کوئی تازہ کاریاں نہیں ملیں
addon-updates-manual-updates-found = دستیاب تازہ کاریاں نظارہ کریں

## Add-on install/debug strings for page options menu

addon-install-from-file = ایڈ اون مسل سے تنصیب کریں...
    .accesskey = ت
addon-install-from-file-dialog-title = تنصیب کرنے کے لیے ایڈ اون منتخب کریں
addon-install-from-file-filter-name = ایڈ اون
addon-open-about-debugging = ایڈز آن ازالہ کرے
    .accesskey = b

## Extension shortcut management

shortcuts-no-addons = آپ کے پاس کوئی ایکسٹینشن فعال نہیں ہے۔
shortcuts-no-commands = مندرجہ ذیل ایکسٹینشنز میں شارٹ کٹس نہیں ہیں۔

shortcuts-browserAction2 = ٹول بار کے بٹن کو فعال بنائیں

shortcuts-modifier-other = Ctrl یا Alt شامل کریں
shortcuts-invalid = ناجائز مجموعہ
shortcuts-letter = ایک خط ٹائپ کریں

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = پہلے ہی { $addon } کے استعمال میں ہے

shortcuts-card-collapse-button = کم دکھائیں

header-back-button =
    .title = واپس جائیں

## Recommended add-ons page

discopane-notice-learn-more = مزید سیکھیں

privacy-policy = رازداری پالیسی

# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = صارفین: { $dailyUsers }
install-theme-button = تھیم انسٹال کریں
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = بندوبست کریں
find-more-addons = مزید ایڈ-اونز تلاش کریں

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = مزید اختیارات

## Add-on actions

report-addon-button = ‎رپورٹ کریں
remove-addon-button = ہٹائیں
disable-addon-button = غیر فعال
enable-addon-button = فعال
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = فعال کریں
preferences-addon-button =
    { PLATFORM() ->
        [windows] اختیارات
       *[other] ترجیحات
    }
details-addon-button = تفصیلات
release-notes-addon-button = اجرائی نوٹ
permissions-addon-button = اجازتیں

extension-enabled-heading = اہل بنایا گیا
extension-disabled-heading = نااہل

theme-enabled-heading = اہل
theme-disabled-heading = نااہل

plugin-enabled-heading = اہل
plugin-disabled-heading = نااہل

dictionary-enabled-heading = اہل
dictionary-disabled-heading = نااہل

locale-enabled-heading = اہل
locale-disabled-heading = نااہل

ask-to-activate-button = عمل میں لانے کے لیے پوچھیں
always-activate-button = ہمیشہ متحرک کریں
never-activate-button = کبھی متحرک نہ کریں

addon-detail-author-label = مصنف
addon-detail-version-label = ورژن
addon-detail-last-updated-label = آخری تازہ کاری
addon-detail-homepage-label = ابتدائی صفحہ
addon-detail-rating-label = شرح کاری

## Pending uninstall message bar

pending-uninstall-undo-button = کالعدم کریں

addon-detail-updates-label = خودکار تازہ کاریوں کی اجازت دیں
addon-detail-updates-radio-default = طے شدہ
addon-detail-updates-radio-on = آن کریں
addon-detail-updates-radio-off = بند کریں
addon-detail-update-check-label = تازہ کاریوں کے لیے پڑتال کریں
install-update-button = تازہ کاری کریں

addon-detail-private-browsing-allow = اجازت دیں
addon-detail-private-browsing-disallow = اجازت مت دیں

available-updates-heading = دستیاب تازہ کاریاں
recent-updates-heading = حالیہ تازہ کاریاں

release-notes-loading = لوڈ ہو رہا ہے…

recommended-extensions-heading = تجویز شدہ ایکسٹنشن
recommended-themes-heading = تجویز شدہ تھیمز

## Page headings

extension-heading = اپنی ایکسٹینشنز منظم کریں
theme-heading = اپنی تھیمز منظم کریں
plugin-heading = اپنی پلگانز منظم کریں
dictionary-heading = اپنی لغت کو منظم کریں
locale-heading = اپنی زبان کو منظم کریں
updates-heading = اپنی تازہ کاریوں کو منظم کریں

default-heading-search-label = مزید ایڈ-اون کے تلاش کریں
addons-heading-search-input =
    .placeholder = addons.mozilla.org تلاش کریں

addon-page-options-button =
    .title = تمام ایڈ اون کے لیے ٹول
