# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = ابزارهای پیش فرض توسعه دهنده

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = *در حال حاضر جعبه ابزار هدف پشتبانی نمی‌شود

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = ابزارهای توسعه نصب شده توسط افزودنی‌ها

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = دکمه‌های در دسترس جعبه ابزار

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = تم‌ها

## Inspector section

# The heading
options-context-inspector = بازرس‌

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = نمایش سبک‌های مرورگر
options-show-user-agent-styles-tooltip =
    .title = روشن کردن این باعث می‌شود سبک‌های پیش‌فرضی که مرورگر بارگیری کرده است نمایش داده شوند.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = کوتاه کردن ویژیگی‌های DOM
options-collapse-attrs-tooltip =
    .title = کوتاه کردن خصیصه‌های طولانی در بازرس

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = واحد رنگی پیش‌فرض
options-default-color-unit-authored = به عنوان نویسنده
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = نام رنگ‌ها

## Style Editor section

# The heading
options-styleeditor-label = ویرایشگر سبک

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = تکمیل خودکار CSS
options-stylesheet-autocompletion-tooltip =
    .title = کامل شدن خودکار خواص CSS، مقدارها و انتخابگران در ویرایشگر سبک در حالی که شما تایپ می‌کنید

## Screenshot section

# The heading
options-screenshot-label = رفتار تصویر‌گرفتن از صفحه

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = تصویر صفحه به clipboard
options-screenshot-clipboard-tooltip =
    .title = ذخیره‌سازی تصاویر صفحه مستقیما در clipboard

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = پخش صدای شاتر دوربین
options-screenshot-audio-tooltip =
    .title = فعالسازی صدای دوربین در حالی که تصویر از صفحه گرفته می ‌شود

## Editor section

# The heading
options-sourceeditor-label = ترجیحات ویرایشگر

options-sourceeditor-detectindentation-tooltip =
    .title = حدس زدن indentation بر اساس محتوا منبع
options-sourceeditor-detectindentation-label = تشخیص تورفتگی
options-sourceeditor-autoclosebrackets-tooltip =
    .title = افزودن خودکار براکت بسته
options-sourceeditor-autoclosebrackets-label = بستن خودکار براکت‌ها
options-sourceeditor-expandtab-tooltip =
    .title = استفاده از فاصله به جای نویسه تب
options-sourceeditor-expandtab-label = تورفتگی با استفاده از فاصله
options-sourceeditor-tabsize-label = اندازه زبانه
options-sourceeditor-keybinding-label = Keybindings
options-sourceeditor-keybinding-default-label = پیش‌فرض

## Advanced section

# The heading
options-context-advanced-settings = تنظیمات پیشرفته

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = غیرفعال کردن ذخیره نهان HTTP‌ (وقتی جعبه ابزار باز است)
options-disable-http-cache-tooltip =
    .title = فعال کردن این گزینه حافظه نهان HTTP را برای تمامی زبانه‌ها فعالی که جعبه‌ابزار آن ها باز است غیرفعال می‌کند. کارگرهای خدمات دهده تحت تاثیر این گزینه قرار نمی‌گیرند.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = غیرفعال کردن جاوا اسکریپت *
options-disable-javascript-tooltip =
    .title = فعال کردن ای گزینه JavaScript را از زبان فعلی غیرفعال می‌کند. اگر زبانه یا ابزار بسته شد سپس ممکن است این تنظیمات فراموش شود.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = فعال‌سازی کروم مرورگر و ابزارهای رفع‌اشکال افزودنی‌ها
options-enable-chrome-tooltip =
    .title = فعال کردن این گزینه این امکان را به شما می‌دهد تا از امکانات بسیار گسترده ابزار توسعه‌دهندگان در زمینه مرور (ابزار > توسعه وب > جعبه ابزار مرورگر) و اشکال زدایی افزونه ها از طریق مدیریت افزونه اقدام کنید.

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = فعال‌سازی رفع‌اشکال از راه دور

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = فعال کردن خدمات کارگران برای روی HTTP ( وقتی که جعبه ابزار باز است)
options-enable-service-workers-http-tooltip =
    .title = فعال کردن این گزینه بر روی خدمات کارگرهای را بر روی HTTP برای تمامی زبانه‌ها که جعبه‌ابزار‌ آن‌ها باز است فعال می‌کند.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = فعال‌سازی نقشه های منابع
options-source-maps-tooltip =
    .title = اگر شما این قابلیت را فعال کنید منابع قادر به ترسیم در ابزارخواهند بود.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = تنها نشست فعلی، صفحه را بازآوری می‌کند

##

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = نمایش اطلاعات بستر Gecko
options-show-platform-data-tooltip =
    .title = اگر شما این گزینه را فعال کنید نمایه JavaScript گزارش هایی شامل نماد های سکو Gecko گزارش خواهد کرد
