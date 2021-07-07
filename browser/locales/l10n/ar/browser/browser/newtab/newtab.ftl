# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = لسان جديد
newtab-settings-button =
    .title = خصص صفحة اللسان الجديد
newtab-personalize-button-label = خصّص
    .title = خصّص صفحة اللسان الجديد
    .aria-label = خصّص صفحة اللسان الجديد

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = ابحث
    .aria-label = ابحث
newtab-search-box-search-the-web-text = ابحث في الوِب
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = ‫ابحث مستعملًا { $engine } أو أدخِل عنوانا
newtab-search-box-handoff-text-no-engine = ابحث أو أدخِل عنوانا
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = ‫ابحث مستعملًا { $engine } أو أدخِل عنوانا
    .title = ‫ابحث مستعملًا { $engine } أو أدخِل عنوانا
    .aria-label = ‫ابحث مستعملًا { $engine } أو أدخِل عنوانا
newtab-search-box-handoff-input-no-engine =
    .placeholder = ابحث أو أدخِل عنوانا
    .title = ابحث أو أدخِل عنوانا
    .aria-label = ابحث أو أدخِل عنوانا
newtab-search-box-search-the-web-input =
    .placeholder = ابحث في الوِب
    .title = ابحث في الوِب
    .aria-label = ابحث في الوِب
newtab-search-box-text = ابحث في الوِب
newtab-search-box-input =
    .placeholder = ابحث في الوِب
    .aria-label = ابحث في الوِب

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = أضِف محرك بحث
newtab-topsites-add-topsites-header = موقع شائع جديد
newtab-topsites-add-shortcut-header = اختصار جديد
newtab-topsites-edit-topsites-header = حرّر الموقع الشائع
newtab-topsites-edit-shortcut-header = حرّر الاختصار
newtab-topsites-title-label = العنوان
newtab-topsites-title-input =
    .placeholder = أدخل عنوانًا
newtab-topsites-url-label = المسار
newtab-topsites-url-input =
    .placeholder = اكتب أو ألصق مسارًا
newtab-topsites-url-validation = مطلوب مسار صالح
newtab-topsites-image-url-label = مسار الصورة المخصصة
newtab-topsites-use-image-link = استخدم صورة مخصصة…
newtab-topsites-image-validation = فشل تحميل الصورة. جرّب مسارا آخر.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = ألغِ
newtab-topsites-delete-history-button = احذف من التأريخ
newtab-topsites-save-button = احفظ
newtab-topsites-preview-button = عايِن
newtab-topsites-add-button = أضِفْ

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = هل أنت متأكد أنك تريد حذف كل وجود لهذه الصفحة من تأريخك؟
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = لا يمكن التراجع عن هذا الإجراء.

## Top Sites - Sponsored label

newtab-topsite-sponsored = نتيجة مموّلة

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = افتح القائمة
    .aria-label = افتح القائمة
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = أزِل
    .aria-label = أزِل
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = افتح القائمة
    .aria-label = افتح قائمة { $title } السياقية
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = حرّر هذا الموقع
    .aria-label = حرّر هذا الموقع

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = حرِّر
newtab-menu-open-new-window = افتح في نافذة جديدة
newtab-menu-open-new-private-window = افتح في نافذة خاصة جديدة
newtab-menu-dismiss = ألغِ
newtab-menu-pin = ثبّت
newtab-menu-unpin = أزل
newtab-menu-delete-history = احذف من التأريخ
newtab-menu-save-to-pocket = احفظ في { -pocket-brand-name }
newtab-menu-delete-pocket = احذف من { -pocket-brand-name }
newtab-menu-archive-pocket = أرشِف في { -pocket-brand-name }
newtab-menu-show-privacy-info = رُعاتنا الرسميّون وخصوصيّتك

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = تمّ
newtab-privacy-modal-button-manage = أدِر إعدادات المحتوى المرعيّ
newtab-privacy-modal-header = خصوصيتك فوق كل شيء.
newtab-privacy-modal-paragraph-2 = نعرض عليكم محتوى مفحوصًا بحذر من رُعاة مُختارين بعناية، بالإضافة للقصص الآسرة التي نقدّمها. اطمئن <strong>فبياناتك وأنت تتصفّح لا تخرج مطلقًا خارج نسختك من { -brand-product-name }</strong> — إذ لا نحن نراها، ولا رُعاتنا يرونَها.
newtab-privacy-modal-link = تعرّف على طريقة عمل الخصوصية في الألسنة الجديدة

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = أزل العلامة
# Bookmark is a verb here.
newtab-menu-bookmark = علّم

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = انسخ رابط التنزيل
newtab-menu-go-to-download-page = انتقل إلى صفحة التنزيل
newtab-menu-remove-download = احذف من التأريخ

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] أظهِر في فايندر
       *[other] افتح المجلد المحتوي
    }
newtab-menu-open-file = افتح الملف

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = مُزارة
newtab-label-bookmarked = معلّمة
newtab-label-removed-bookmark = أُزيلت العلامة
newtab-label-recommended = مُتداول
newtab-label-saved = حُفِظت في { -pocket-brand-name }
newtab-label-download = نُزّل
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = برعاية · { $sponsorOrSource }
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = برعاية { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = أزِل القسم
newtab-section-menu-collapse-section = اطوِ القسم
newtab-section-menu-expand-section = وسّع القسم
newtab-section-menu-manage-section = أدِر القسم
newtab-section-menu-manage-webext = أدِر الامتداد
newtab-section-menu-add-topsite = أضف موقعًا شائعًا
newtab-section-menu-add-search-engine = أضِف محرك بحث
newtab-section-menu-move-up = انقل لأعلى
newtab-section-menu-move-down = انقل لأسفل
newtab-section-menu-privacy-notice = تنويه الخصوصية

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = اطوِ القسم
newtab-section-expand-section-label =
    .aria-label = وسّع القسم

## Section Headers.

newtab-section-header-topsites = المواقع الأكثر زيارة
newtab-section-header-highlights = أهم الأحداث
newtab-section-header-recent-activity = أحدث الأنشطة
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = ينصح به { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = ابدأ التصفح وسنعرض أمامك بعض المقالات والفيديوهات والمواقع الأخرى التي زرتها حديثا أو أضفتها إلى العلامات هنا.
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = لا جديد. تحقق لاحقًا للحصول على مزيد من أهم الأخبار من { $provider }. لا يمكنك الانتظار؟ اختر موضوعًا شائعًا للعثور على المزيد من القصص الرائعة من جميع أنحاء الوِب.

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = بِتّ تعلم كل شيء!
newtab-discovery-empty-section-topstories-content = عُد فيما بعد لترى قصص أخرى.
newtab-discovery-empty-section-topstories-try-again-button = أعِد المحاولة
newtab-discovery-empty-section-topstories-loading = يحمّل…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = آخ. أوشكنا على تحميل هذا القسم، لكن للأسف لم يكتمل.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = المواضيع الشائعة:
newtab-pocket-more-recommendations = مقترحات أخرى
newtab-pocket-learn-more = اطّلع على المزيد
newtab-pocket-cta-button = نزِّل { -pocket-brand-name }
newtab-pocket-cta-text = احفظ القصص التي تحبّها في { -pocket-brand-name }، وزوّد عقلك بمقالات رائعة.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = أخ! حدث خطب ما أثناء تحميل المحتوى.
newtab-error-fallback-refresh-link = أنعِش الصفحة لإعادة المحاولة.

## Customization Menu

newtab-custom-shortcuts-title = الاختصارات
newtab-custom-shortcuts-subtitle = المواقع التي حفظتها أو زرتها
newtab-custom-row-selector =
    { $num ->
        [zero] ما من صفوف
        [one] صف واحد
        [two] صفّان اثنان
        [few] { $num } صفوف
        [many] { $num } صفًا
       *[other] { $num } صف
    }
newtab-custom-sponsored-sites = الاختصارات الممولة
newtab-custom-pocket-title = مُقترح من { -pocket-brand-name }
newtab-custom-pocket-subtitle = محتوى مميّز جمعه لك { -pocket-brand-name }، وهو جزء من عائلة { -brand-product-name }
newtab-custom-pocket-sponsored = قصص مموّلة
newtab-custom-recent-title = أحدث الأنشطة
newtab-custom-recent-subtitle = مختارات من المواقع والمحتويات الحديثة
newtab-custom-close-button = أغلِق
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
newtab-custom-snippets-title = المقتطفات
newtab-custom-snippets-subtitle = فوائد وأخبار من { -vendor-short-name } و{ -brand-product-name }
newtab-custom-settings = أدِر المزيد من الإعدادات
