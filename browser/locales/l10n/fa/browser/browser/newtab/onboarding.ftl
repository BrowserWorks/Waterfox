# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = بیشتر بدانید
onboarding-button-label-get-started = شروع کنید

## Welcome modal dialog strings

onboarding-welcome-header = به { -brand-short-name } خوش آمدید
onboarding-welcome-body = شما مرورگر را به دست آوردید.<br/>سایر بخش‌های { -brand-product-name } را ببینید.
onboarding-welcome-learn-more = در مورد مزایای آن بیشتر یاد بگیرید.
onboarding-welcome-modal-get-body = شما مرورگر را دارید<br/>حالا میتوانیداز { -brand-product-name } بیشترین بهره را ببرید.
onboarding-welcome-modal-supercharge-body = محافظت از حریم شخصیتان را تقویت کنید.
onboarding-welcome-modal-privacy-body = شما مرورگر را دارید. بیایید محافظت از حریم خصوصی را بیشتر کنیم.
onboarding-welcome-modal-family-learn-more = درباره خانواده محصولات { -brand-product-name } بیاموزید.
onboarding-welcome-form-header = از اینجا شروع کنید

onboarding-join-form-body = برای شروع، آدرس ایمیل خود را وارد کنید.
onboarding-join-form-email =
    .placeholder = ایمیل را وارد کنید
onboarding-join-form-email-error = به ایمیل معتبر نیاز است
onboarding-join-form-legal = با ادامه دادن، شما با <a data-l10n-name="terms">قوانین خدمات</a> و <a data-l10n-name="privacy">قواعد حفظ حریم شخصی</a>، موافقت می‌کنید.
onboarding-join-form-continue = ادامه

# Text for link to submit the sign in form
onboarding-join-form-signin = ورود

onboarding-start-browsing-button-label = شروع وب‌گردی
onboarding-cards-dismiss =
    .title = رد کردن
    .aria-label = رد کردن

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string


## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = { -brand-product-name } را همراه خود داشته باشید
onboarding-sync-welcome-content = نشانک‌ها، تاریخچه، گذرواژه‌ها و تنظیمات دیگر خود را بر روی تمام دستگاه‌های خود همراه خود داشته باشید.
onboarding-sync-welcome-learn-more-link = در مورد حساب‌های فایرفاکس بیشتر بدانید

onboarding-sync-form-input =
    .placeholder = پست‌الکترونیکی

onboarding-sync-form-continue-button = ادامه
onboarding-sync-form-skip-login-button = پرش از این مرحله

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = پست‌الکترونیکی خود را وارد کنید
onboarding-sync-form-sub-header = برای ادامه به { -sync-brand-name }.


## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = به کمک گروهی از ابزارها که به حریم خصوصی شما بر روی دستگاه‌هایتان احترام می‌گذارند، کارها را انجام دهید.

# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = هرکاری که ما انجام می‌دهیم به تعهد ما در مورد اطلاعات شخصی وفادار است: چیزهای کمتری بگیر، امن نگهداری کن، مخفی کاری وجود ندارد.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = محافظت از ردگیری شدن
onboarding-tracking-protection-text2 = { -brand-short-name } کمک می‌کند تا ردگیری آنلاین شما توسط وبسایت‌ها متوقف شود و آگهی‌ها نیز به سختی شما را در وب دنبال خواهند کرد.
onboarding-tracking-protection-button2 = چطور کار می‌کند

onboarding-data-sync-title = تنظیماتتان را با خود ببرید
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = هرجا که از { -brand-product-name } استفاده می‌کنید، نشانک‌ها، گذرواژه‌ها و بسیاری چیزهای دیگر را همگام‌سازی کنید.
onboarding-data-sync-button2 = وارد { -sync-brand-short-name } شوید

onboarding-firefox-monitor-title = نسبت به نشت اطلاعات آگاه باشید
onboarding-firefox-monitor-button = برای دریافت اخطارها عضو شوید

onboarding-browse-privately-title = مرور ناشناس
onboarding-browse-privately-text = مرور ناشناس، سابقه جستجو و مرور شما را پاک می‌کند تا آن را از دید کسانی که از کامپیوتر شما استفاده می‌کنند مخفی نگه دارد.
onboarding-browse-privately-button = یک پنجره ناشناس باز کنید

onboarding-firefox-send-title = فایل‌های به اشتراک گذاشته شده خود را خصوصی نگه دارید
onboarding-firefox-send-text2 = برای به اشتراک گذاشتن فایل‌های خود با رمز گذاری نقطه به نقطه و لینک دارای تاریخ انقضا، آن‌ها را در { -send-brand-name } بارگذاری کنید.
onboarding-firefox-send-button = { -send-brand-name } را امتحان کنید

onboarding-mobile-phone-title = { -brand-product-name } را بر روی تلفن خود داشته باشید
onboarding-mobile-phone-text = { -brand-product-name } را برای iOS یا Android دریافت کنید و اطلاعات خود را بین دستگاه‌های مختلف همگام‌سازی کنید.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = مرورگر همراه را دریافت کنید

onboarding-send-tabs-title = بلافاصله زبانه‌ها را برای خود بفرستید
onboarding-send-tabs-button = استفاده از فرستادن زبانه‌ها را آغاز کنید

onboarding-pocket-anywhere-title = هرجایی بخوانید و بشنوید
onboarding-pocket-anywhere-text2 = محتوای مورد علاقه خود را با اپ { -pocket-brand-name } به صورت آفلاین ذخیره کنید و هر زمان که برایتان مناسب بود آن را بخوانید، بشنوید یا تماشا کنید.
onboarding-pocket-anywhere-button = { -pocket-brand-name } را امتحان کنید

onboarding-facebook-container-button = اضافه کردن افزونه

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = عالی است، شما { -brand-short-name } را دریافت کردید

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = حالا اجازه بدهید برایتان <icon></icon><b>{ $addon-name } را بگبریم.</b>
return-to-amo-extension-button = اضافه کردن افزونه
return-to-amo-get-started-button = شروع با { -brand-short-name }
