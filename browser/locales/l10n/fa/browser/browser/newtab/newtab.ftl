# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = زبانه جدید
newtab-settings-button =
    .title = صفحهٔ زبانه جدید را سفارشی کنید

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = جست‌وجو
    .aria-label = جست‌وجو

newtab-search-box-search-the-web-text = جست‌وجوی وب
newtab-search-box-search-the-web-input =
    .placeholder = جست‌وجوی وب
    .title = جست‌وجوی وب
    .aria-label = جست‌وجوی وب

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = افزودن موتور جست‌وجو
newtab-topsites-add-topsites-header = سایت برتر جدید
newtab-topsites-edit-topsites-header = ویرایش سایت برتر
newtab-topsites-title-label = عنوان
newtab-topsites-title-input =
    .placeholder = عنوان را وارد کنید

newtab-topsites-url-label = آدرس
newtab-topsites-url-input =
    .placeholder = یک URL تایپ کنید یا بچسبانید
newtab-topsites-url-validation = URL معتبر الزامی است

newtab-topsites-image-url-label = آدرسِ سفارشی عکس
newtab-topsites-use-image-link = استفاده از یک عکس سفارشی…
newtab-topsites-image-validation = بارگیری عکس شکست خورد. آدرس دیگری امتحان کنید.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = انصراف
newtab-topsites-delete-history-button = حذف از تاریخچه
newtab-topsites-save-button = ذخیره
newtab-topsites-preview-button = پیش‌نمایش
newtab-topsites-add-button = افزودن

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = آیا از پاک کردن همه نمونه‌های این صفحه از تاریخ‌چه خود اطمینان دارید؟
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = این عمل قابل برگشت نیست.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = باز کردن منو
    .aria-label = باز کردن منو

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = حذف
    .aria-label = حذف

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = باز کردن منو
    .aria-label = بازکردن فهرست زمینه برای { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = ویرایش این سایت
    .aria-label = ویرایش این سایت

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = ويرايش
newtab-menu-open-new-window = باز کردن در یک پنجره جدید
newtab-menu-open-new-private-window = بار کردن در یک پنجره ناشناس جدید
newtab-menu-dismiss = رد کردن
newtab-menu-pin = سنجاق کردن
newtab-menu-unpin = جدا کردن
newtab-menu-delete-history = حذف از تاریخچه
newtab-menu-save-to-pocket = ذخیره‌سازی در { -pocket-brand-name }
newtab-menu-delete-pocket = حذف از { -pocket-brand-name }
newtab-menu-archive-pocket = آرشیو در { -pocket-brand-name }
newtab-menu-show-privacy-info = حامیان ما و حریم خصوصی شما

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = انجام شد
newtab-privacy-modal-button-manage = مدیریتِ تنظیماتِ محتوای مورد حمایت
newtab-privacy-modal-header = حریم خصوصی شما اهمیت دارد.
newtab-privacy-modal-link = در مورد حریم خصوصی در برگهٔ جدید بیاموزید

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = حذف نشانک
# Bookmark is a verb here.
newtab-menu-bookmark = نشانک

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = رونوشت از پیوندِ بارگیری
newtab-menu-go-to-download-page = رفتن به صفحهٔ بارگیری
newtab-menu-remove-download = حذف از تاریخچه

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] نمایش در Finder
       *[other] باز کردن پوشهٔ محتوی
    }
newtab-menu-open-file = باز کردن پرونده

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = مشاهده شده
newtab-label-bookmarked = نشانک شده
newtab-label-removed-bookmark = نشانک حذف شد
newtab-label-recommended = موضوعات داغ
newtab-label-saved = در { -pocket-brand-name } ذخیره شد
newtab-label-download = دریافت شد

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · حمایت مالی شده

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = حمایت شده توسط { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = حذف قسمت
newtab-section-menu-collapse-section = جمع کردن قسمت
newtab-section-menu-expand-section = باز کردن قسمت
newtab-section-menu-manage-section = مدیریت قسمت
newtab-section-menu-manage-webext = مدیریت افزودنی
newtab-section-menu-add-topsite = اضافه کردن سایت برتر
newtab-section-menu-add-search-engine = افزودن موتور جست‌وجو
newtab-section-menu-move-up = جابه‌جایی به بالا
newtab-section-menu-move-down = جابه‌جایی به پایین
newtab-section-menu-privacy-notice = نکات حریم‌خصوصی

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = جمع‌کردن بخش
newtab-section-expand-section-label =
    .aria-label = باز کردن بخش

## Section Headers.

newtab-section-header-topsites = سایت‌های برتر
newtab-section-header-highlights = برجسته‌ها
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = پیشنهاد شده توسط { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = مرور کردن را شروع کنید و شاهد تعداد زیادی مقاله، فیلم و صفحات خوبی باشید که اخیر مشاهده کرده اید یا نشانگ گذاری کرده اید.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = فعلاً تمام شد. بعداً دوباره سر بزن تا مطالب جدیدی از { $provider } ببینی. نمی‌توانی صبر کنی؟ یک موضوع محبوب را انتخاب کن تا مطالب جالب مرتبط از سراسر دنیا را پیدا کنی.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = تمام شد!
newtab-discovery-empty-section-topstories-content = بعداً سر بزن تا مطالب بیشتری ببینی.
newtab-discovery-empty-section-topstories-try-again-button = تلاش دوباره
newtab-discovery-empty-section-topstories-loading = در حال بارگذاری...
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = آخ! ما تقریباً این بخش را بارگذاری کرده بودیم، اما کامل نیست.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = موضوع‌های محبوب:
newtab-pocket-more-recommendations = توصیه‌های بیشتر
newtab-pocket-learn-more = اطلاعات بیشتر
newtab-pocket-cta-button = دریافت { -pocket-brand-name }
newtab-pocket-cta-text = مطالبی که دوست دارید را در { -pocket-brand-name } ذخیره کنید، و به ذهن خود با مطالب فوق‌العاده انرژی بدهید.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = اوه، هنگام بارگیری این محتوا مشکلی پیش آمد.
newtab-error-fallback-refresh-link = برای تلاش مجدد صفحه را بازآوری کنید.
