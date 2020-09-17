# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = نیا ٹیب
newtab-settings-button =
    .title = اپنے نئے ٹیب کہ صفحہ کی تخصیص کریں

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = تلاش
    .aria-label = تلاش

newtab-search-box-search-the-web-text = ويب پر تلاش کريں
newtab-search-box-search-the-web-input =
    .placeholder = ويب پر تلاش کريں
    .title = ويب پر تلاش کريں
    .aria-label = ويب پر تلاش کريں

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = تلاش انجن کا اضافہ کریں
newtab-topsites-add-topsites-header = نئی بہترین سائٹ
newtab-topsites-edit-topsites-header = بہترین سائٹٹ کیی تدوین کریں
newtab-topsites-title-label = عنوان
newtab-topsites-title-input =
    .placeholder = ایک عنوان داخل کریں

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = ٹائپ کریں یا ایک URL چسباں کریں
newtab-topsites-url-validation = جائز URL درکار ہے

newtab-topsites-image-url-label = مخصوص نقش کا URL
newtab-topsites-use-image-link = ایک مخصوص تصویر استعمال کریں…
newtab-topsites-image-validation = نقش لوڈ ہونے میں ناکام رہا۔ براہ مہربانی ایک مختلف URL کو آزمائیں۔

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = منسوخ کریں
newtab-topsites-delete-history-button = سابقات سے حذف کریں
newtab-topsites-save-button = محفوظ کریں
newtab-topsites-preview-button = پیش منظر
newtab-topsites-add-button = اظافہ کریں

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = کیا آپ کو یقین ہے کہ آپ اس صفحہ کا ہر نمونہ اپنے سابقات سے حذف کرنا چاہتے ہیں؟
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = یہ عمل کلعدم نہیں ہو سکتا۔

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = مینیو کھولیں
    .aria-label = مینیو کھولیں

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = ہٹائیں
    .aria-label = ہٹائیں

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = مینیو کھولیں
    .aria-label = { $title } کے لئے کونٹیکسٹ مینو کھولیں
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = اس سائٹ کی تدوین کریں
    .aria-label = اس سائٹ کی تدوین کریں

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = تدوین
newtab-menu-open-new-window = نئے دریچے میں کھولیں
newtab-menu-open-new-private-window = نئی نجی دریچے میں کھولیں
newtab-menu-dismiss = برخاست کریں
newtab-menu-pin = پن
newtab-menu-unpin = ان پن
newtab-menu-delete-history = سابقات سے حذف کریں
newtab-menu-save-to-pocket = { -pocket-brand-name } میں محفوظ کریں
newtab-menu-delete-pocket = { -pocket-brand-name } سے جزف کریں
newtab-menu-archive-pocket = { -pocket-brand-name } مے محفوظ
newtab-menu-show-privacy-info = ہمارے کفیل اور آپ کی رازداری

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = مکمل
newtab-privacy-modal-header = آپ کی رازداری کی اہمیت ہے۔
newtab-privacy-modal-link = سیکھیں کہ نئے ٹیب پر رازداری کیسے کام کرتی ہے

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = نشانى ہٹائيں
# Bookmark is a verb here.
newtab-menu-bookmark = بک مارک

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = ڈاؤن لوڈ ربط نقل کریں
newtab-menu-go-to-download-page = ڈاؤن لوڈ صفحہ پر جائیں
newtab-menu-remove-download = سابقات سے ہٹائیں

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] تلاش کار میں دکھائیں
       *[other] حامل پوشہ کھولیں
    }
newtab-menu-open-file = فائلکھولیں

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = دورہ شدہ
newtab-label-bookmarked = نشان شدہ
newtab-label-removed-bookmark = نشانی ہٹا دی گئی
newtab-label-recommended = رجحان سازی
newtab-label-saved = { -pocket-brand-name } میں محفوظ شدہ
newtab-label-download = ڈاؤن لوڈ شدہ

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } - تعاون شدہ

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = صیغہ ہٹائیں
newtab-section-menu-collapse-section = صیغہ تفصیل سے دیکھیں
newtab-section-menu-expand-section = صیغہ کو توسیع کریں
newtab-section-menu-manage-section = صیغہ منظم کریں
newtab-section-menu-manage-webext = توسیع منظم کریں
newtab-section-menu-add-topsite = بہترین سائٹ شامل کریں
newtab-section-menu-add-search-engine = تلاش انجن کا اضافہ کریں
newtab-section-menu-move-up = اوپر کریں
newtab-section-menu-move-down = نیچے کریں
newtab-section-menu-privacy-notice = رازداری کا نوٹس

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = صیغہ کی تخفیف کر یں
newtab-section-expand-section-label =
    .aria-label = صیغہ کی توسیع کریں

## Section Headers.

newtab-section-header-topsites = بہترین سائٹیں
newtab-section-header-highlights = شہ سرخياں
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = { $provider } کی جانب سے تجویز کردہ

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = برائوزنگگ شروع کریں،اور ہم آپ کو کچھ بہترین عبارات، وڈیوز اور حالیہ دورہ شددہ دیگر صفحات یا نشانیاں دکھائیں گے۔


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = آپ پکڑے گئے!
newtab-discovery-empty-section-topstories-content = مزید کہانیوں کے لئے بعد میں دوبارہ پڑتال کریں۔
newtab-discovery-empty-section-topstories-try-again-button = دوبارہ کوشش کریں
newtab-discovery-empty-section-topstories-loading = لوڈ ہو رہا ہے…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = افوہ! ہم نے اس حصے کو تقریبا بھرا ہوا ہے ، لیکن کافی نہیں۔

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = مشہور مضامین:
newtab-pocket-more-recommendations = اور زیادہ سفارشات
newtab-pocket-learn-more = مزید سیکھیں
newtab-pocket-cta-button = { -pocket-brand-name } حاصل کریں

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = افوہ ، اس مواد کو لوڈ کرنے میں کچھ غلط ہو گیا۔
newtab-error-fallback-refresh-link = دوبارہ کوشش کرنے کے لئے پیج کو ریفریش کریں۔
