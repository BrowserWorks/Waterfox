# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The address and credit card autofill management dialog in browser preferences

autofill-manage-addresses-title = العناوين المحفوظة
autofill-manage-addresses-list-header = العناوين

autofill-manage-credit-cards-title = بطاقات الائتمان المحفوظة
autofill-manage-credit-cards-list-header = بطاقات الائتمان

autofill-manage-dialog =
    .style = min-width: 560px
autofill-manage-remove-button = أزِل
autofill-manage-add-button = أضِف…
autofill-manage-edit-button = حرّر…

##

# The dialog title for creating addresses in browser preferences.
autofill-add-new-address-title = أضِف عنوانا جديدا
# The dialog title for editing addresses in browser preferences.
autofill-edit-address-title = حرّر العنوان

autofill-address-given-name = الاسم الأول
autofill-address-additional-name = الاسم الأوسط
autofill-address-family-name = الاسم الأخير
autofill-address-organization = المؤسسة
autofill-address-street = عنوان الشارع

## address-level-3 (Sublocality) names

# Used in IR, MX
autofill-address-neighborhood = الحي
# Used in MY
autofill-address-village-township = البلدة
autofill-address-island = الجزيرة
# Used in IE
autofill-address-townland = الأرض

## address-level-2 names

autofill-address-city = المدينة
# Used in HK, SD, SY, TR as Address Level-2 and used in KR as Sublocality.
autofill-address-district = المنطقة
# Used in GB, NO, SE
autofill-address-post-town = أنزل
# Used in AU as Address Level-2 and used in ZZ as Sublocality.
autofill-address-suburb = الضاحية

## address-level-1 names

autofill-address-province = المقاطعة
autofill-address-state = الولاية
autofill-address-county = البلد
# Used in BB, JM
autofill-address-parish = الأبرشيّة
# Used in JP
autofill-address-prefecture = المحافظة
# Used in HK
autofill-address-area = المنطقة
# Used in KR
autofill-address-do-si = Do/Si
# Used in NI, CO
autofill-address-department = القِسم
# Used in AE
autofill-address-emirate = الإمارة
# Used in RU and UA
autofill-address-oblast = المقاطعة

## Postal code name types

# Used in IN
autofill-address-pin = الرمز البريدي
autofill-address-postal-code = الرمز البريدي
autofill-address-zip = الرمز البريدي
# Used in IE
autofill-address-eircode = الرمز البريدي الأيرلندي

##

autofill-address-country = المنطقة أو الإقليم
autofill-address-tel = الهاتف
autofill-address-email = البريد الإلكتروني

autofill-cancel-button = ألغِ
autofill-save-button = احفظ
autofill-country-warning-message = الملء الآلي للاستمارات متاح حاليا في بعض الدول فحسب.

# The dialog title for creating credit cards in browser preferences.
autofill-add-new-card-title = أضِف بطاقة ائتمان جديدة
# The dialog title for editing credit cards in browser preferences.
autofill-edit-card-title = حرّر بطاقة الائتمان

# In macOS, this string is preceded by the operating system with "Waterfox is trying to ",
# and has a period added to its end. Make sure to test in your locale.
autofill-edit-card-password-prompt =
    { PLATFORM() ->
        [macos] عرض معلومات بطاقة الائتمان
        [windows] يحاول { -brand-short-name } عرض معلومات بطاقة الائتمان. أكّد الوصول إلى حساب وِندوز هذا من الأسفل.
       *[other] يحاول { -brand-short-name } عرض معلومات بطاقة الائتمان.
    }

autofill-card-number = رقم البطاقة
autofill-card-invalid-number = رجاءً أدخِل اسم بطاقة سليم
autofill-card-name-on-card = الاسم على البطاقة
autofill-card-expires-month = شهر انقضاء الصلاحية
autofill-card-expires-year = سنة انقضاء الصلاحية
autofill-card-billing-address = عنوان إرسال الفواتير
autofill-card-network = نوع البطاقة

## These are brand names and should only be translated when a locale-specific name for that brand is in common use

autofill-card-network-amex = أمريكان إكسبرِس
autofill-card-network-cartebancaire = Carte Bancaire
autofill-card-network-diners = Diners Club
autofill-card-network-discover = اكتشف
autofill-card-network-jcb = JCB
autofill-card-network-mastercard = ماستِركارد
autofill-card-network-mir = MIR
autofill-card-network-unionpay = Union Pay
autofill-card-network-visa = ڤيزا
