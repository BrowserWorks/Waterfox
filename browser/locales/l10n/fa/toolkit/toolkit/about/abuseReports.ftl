# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = گزارش برای { $addon-name }

abuse-report-title-extension = گزارش این افزونه به { -vendor-short-name }
abuse-report-title-theme = گزارش این تم به { -vendor-short-name }
abuse-report-subtitle = موضوع چیست؟

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = توسط <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore = مطمئن نیستید چه مسئله ای را انتخاب کنید؟<a data-l10n-name="learnmore-link"> درباره گزارش افزونه‌ها و مضامین بیشتر بیاموزید</a>

abuse-report-submit-description = توضیح مسئله (اختیاری)
abuse-report-textarea =
    .placeholder = اگر مشخصات دقیق را داشته باشیم حل مشکل برای ما ساده‌تر می‌گردد. لطفا چیزی که تجربه می‌کنید را با ما در میان بگذارید. از کمک شما برای سالم نگه‌داشتن وب تشکر می‌کنیم.
abuse-report-submit-note =
    توجه: اطلاعات شخصی (مانند نام ، آدرس ایمیل ، شماره تلفن ، آدرس واقعی) را وارد نکنید.
    { -vendor-short-name } سابقه‌ای دائمی از این گزارش ها را  نگه می دارد.

## Panel buttons.

abuse-report-cancel-button = لغو
abuse-report-next-button = بعدی
abuse-report-goback-button = برگشتن
abuse-report-submit-button = ثبت

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = گزارش برای <span data-l10n-name="addon-name">{ $addon-name }</span> لغو شد.
abuse-report-messagebar-submitting = ارسال گزارش برای <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = با تشکر از شما برای ثبت گزارش. آیا می خواهید <span data-l10n-name="addon-name">{ $addon-name }</span> را حذف کنید؟
abuse-report-messagebar-submitted-noremove = با تشکر از شما برای ثبت گزارش.
abuse-report-messagebar-removed-extension = با تشکر از شما برای ثبت گزارش. شما افزونه <span data-l10n-name="addon-name">{ $addon-name }</span> را حذف کرده اید.
abuse-report-messagebar-removed-theme = با تشکر از شما برای ثبت گزارش. شما تم <span data-l10n-name="addon-name">{ $addon-name }</span> را حذف کرده اید.
abuse-report-messagebar-error = هنگام ارسال گزارش برای <span data-l10n-name="addon-name">{ $addon-name }</span> خطایی رخ داد.
abuse-report-messagebar-error-recent-submit = گزارش<span data-l10n-name="addon-name">{ $addon-name }</span> ارسال نشده است زیرا اخیراً گزارش دیگری ارسال شده است.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = بله، حذف کنید
abuse-report-messagebar-action-keep-extension = خیر، نگه دارید
abuse-report-messagebar-action-remove-theme = بله، حذف کنید
abuse-report-messagebar-action-keep-theme = خیر، نگه دارید
abuse-report-messagebar-action-retry = تلاش مجدد
abuse-report-messagebar-action-cancel = لغو

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = به رایانه من آسیب رساند یا اطلاعات من را در معرض خطر قرار داد
abuse-report-damage-example = مثال: بدافزار تزریق کرده است یا داده‌ها را سرقت می‌کند

abuse-report-spam-reason-v2 = حاوی هرزنامه است یا تبلیفات ناخواسته درج می‌کند
abuse-report-spam-example = مثال: تبلیغات به صفحات وب اضافه می‌کند

abuse-report-settings-reason-v2 = بدون اطلاع دادن یا سؤال از من، موتور جستجو، صفحه اصلی یا اطلاعات برگهٔ جدید را تغییر داد
abuse-report-settings-suggestions = قبل از گزارش افزونه، می‌توانید تنظیمات خود را تغییر دهید:
abuse-report-settings-suggestions-search = تنظیمات موتور جستجوی پیش فرض خود را تغییر دهید
abuse-report-settings-suggestions-homepage = صفحه خانگی و برگهٔ جدید خود را تغییر دهید

abuse-report-deceptive-reason-v2 = ادعا می‌کند چیز متفاوتی است
abuse-report-deceptive-example = مثال: توضیحات یا تصاویر گمراه کننده

abuse-report-broken-reason-extension-v2 = کار نمی کند، وب سایت‌ها را خراب می‌کند، یا سرعت { -brand-product-name } را کاهش می دهد
abuse-report-broken-reason-theme-v2 = کار نمی‌کند یا چهرهٔ مرورگر را خراب می‌کند
abuse-report-broken-example = مثال: امکانات کند، غیر قابل استفاده و یا کار نمی‌کنند. قسمت‌هایی از وب‌سایت‌ها بارگیری نمی‌شوند یا غیرعادی به نظر می‌رسند
abuse-report-broken-suggestions-extension =
    به نظر می رسد شما یک اشکال را شناسایی کرده‌اید. علاوه بر ثبت گزارش در اینجا، بهترین راه برای حل مسئله عملکرد، تماس با توسعه دهنده افزونه است.
    برای دریافت اطلاعات توسعه‌دهنده به<a data-l10n-name="support-link"> وب سایت افزونه</a> مراجعه کنید.
abuse-report-broken-suggestions-theme =
    به نظر می رسد شما یک اشکال را شناسایی کرده‌اید. علاوه بر ثبت گزارش در اینجا، بهترین راهبرای حل مسئله عملکرد، تماس با توسعه دهنده تم است.
    برای دریافت اطلاعات توسعه‌دهنده به <a data-l10n-name="support-link">وب سایت تم</a> مراجعه کنید.

abuse-report-policy-reason-v2 = حاوی محتوای نفرت انگیز، خشونت آمیز یا غیرقانونی
abuse-report-policy-suggestions =
    توجه: مسائل مربوط به کپی رایت و مارک تجاری باید در یک فرآیند جداگانه گزارش شود.
    برای گزارش مشکل از این<a data-l10n-name="report-infringement-link"> دستورالعمل‌ها </a>استفاده کنید

abuse-report-unwanted-reason-v2 = هرگز این افزونه را نمی‌خواستم و نمی‌دانم چگونه از شر آن خلاص بشوم
abuse-report-unwanted-example = مثال: برنامه‌ای بدون اجازه من آن را نصب کرده است

abuse-report-other-reason = موارد دیگر

