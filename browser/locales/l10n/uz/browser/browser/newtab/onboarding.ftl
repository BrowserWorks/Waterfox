# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Batafsil
onboarding-button-label-get-started = Boshlash

## Welcome modal dialog strings

onboarding-welcome-header = { -brand-short-name }ga xush kelibsiz
onboarding-welcome-body = Endi brauzeringiz bor.<br/>{ -brand-product-name } bilan yaqindan tanishing.
onboarding-welcome-learn-more = Yutuqlari haqida batafsil maʼlumot oling.

onboarding-welcome-modal-get-body = Endi brauzeringiz bor.<br/>{ -brand-product-name }dan samarali foydalaning.
onboarding-welcome-modal-supercharge-body = Maxfiyligingiz himoyasini “qayta quvvatlang”.
onboarding-welcome-modal-privacy-body = Brauzeringiz bor. Endi unga maxfiylik himoyasini qoʻshamiz.
onboarding-welcome-modal-family-learn-more = { -brand-product-name } mahsulotlari oilasi bilan tanishing.
onboarding-welcome-form-header = Bu yerdan boshlang

onboarding-join-form-body = Boshlash uchun e-mail manzilingizni kiriting.
onboarding-join-form-email =
    .placeholder = E-pochta manzilingizni kiriting
onboarding-join-form-email-error = E-pochta manzilini xatosiz kiriting
onboarding-join-form-legal = Davom etish bilan siz <a data-l10n-name="terms">Xizmat koʻrsatish shartlari</a> va <a data-l10n-name="privacy">Maxfiylik eslamtlari</a>ga rozilik bildirgan hisoblanasiz.
onboarding-join-form-continue = Davom etish

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Hisobingiz bormi?
# Text for link to submit the sign in form
onboarding-join-form-signin = Hisobga kirish

onboarding-start-browsing-button-label = Koʻrishni boshlash

onboarding-cards-dismiss =
    .title = Yopish
    .aria-label = Yopish

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Qoʻlingizdan nima kelishini sinab koʻramiz.
onboarding-fullpage-form-email =
    .placeholder = E-pochta manzilingiz

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = { -brand-product-name }ni oʻzingiz bilan olib yuring
onboarding-sync-welcome-content = Xatchoʻp, tarix, parol va boshqa turli sozlamalarni barcha qurilmalaringizga sinxronlang.
onboarding-sync-welcome-learn-more-link = Firefox hisoblari haqida batafsil maʼlumot oling

onboarding-sync-form-input =
    .placeholder = E-pochta

onboarding-sync-form-continue-button = Davom etish
onboarding-sync-form-skip-login-button = Ushbu bosqichni oʻtkazib yuboring

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = E-pochtangizni kiriting
onboarding-sync-form-sub-header = { -sync-brand-name } bilan ishlashda davom etish uchun


## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Barcha qurilmalarda maxfiyligingizni taʼminlovchi vositalar oilasidan foydalaning.

# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Shaxsiy maʼlumotlar haqidagi vaʼdamizda turamiz: Kam maʼlumot olamiz. Xavfsiz saqlaymiz. Hech qanday sir boʻlmaydi.


onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Xatchoʻp, parol va tarix kabilardan istalgan yerda { -brand-product-name } orqali foydalaning.

onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Shaxsiy maʼlumotlaringizda maʼlumot sizib chiqishi maʼlum boʻlganda  bildirishnoma olasiz.

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Himoyalangan va koʻchma parollarni boshqarish


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Kuzatuvdan himoya
onboarding-tracking-protection-text2 = { -brand-short-name } syatlarning faoliyatingizni onlayn kuzatishlarini toʻxtatishda yordam beradi, internetda sizni kuzatuvchi reklamalar chiqishini qiyinlashtiradi.
onboarding-tracking-protection-button2 = U qanday ishlaydi

onboarding-data-sync-title = Har qanday joyda bir xil sozlamalardan foydalaning
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Xatchoʻp va parol kabilardan istalgan yerda { -brand-product-name } orqali foydalanish uchun sinxronizatsiyani boshlang.
onboarding-data-sync-button2 = { -sync-brand-short-name } hisobiga kirish

onboarding-firefox-monitor-title = Maʼlumotlar sizishi haqidagi bildirishnomaga yozilish
onboarding-firefox-monitor-text2 = { -monitor-brand-name } email manzilingizda maʼlumotlar sizishi mavjud yoki yoʻqligini nazorat qiladi, agar aniqlansa, sizga xabar beradi.
onboarding-firefox-monitor-button = Bildirishnomalar uchun yozilish

onboarding-browse-privately-title = Internetda maxfiy qoling
onboarding-browse-privately-text = Maxfiy koʻrish rejimida kompyuteringizda ishlaydigan boshqa insonlardan qidiruv va brauzer tarixini sir saqlash uchun ular tozalab tashlanadi.
onboarding-browse-privately-button = Maxfiy oynani ochish

onboarding-firefox-send-title = Ulashilgan fayllaringizni maxfiy saqlang
onboarding-firefox-send-text2 = { -send-brand-name } yordamida fayllaringizni yuklang. Ularni kuchli shifr va avtomatik muddati tugaydigan havola bilan ulashishingiz mumkin boʻladi.
onboarding-firefox-send-button = { -send-brand-name }ni ishlatib koʻrish

onboarding-mobile-phone-title = Telefoningizga { -brand-product-name }ni yuklab oling
onboarding-mobile-phone-text = { -brand-product-name }ni iOS yoki Android uchun yuklab oling va maʼlumotlaringizni barcha qurilmalarga sinxronlang.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Mobil brauzerni yuklab olish

onboarding-send-tabs-title = Varaqlarni osoniga oʻzingizga joʻnating
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Sahifalarni barcha qurilmalaringizga osongina yuboring. Nusxa olish va brauzerdan chiqish shart emas.
onboarding-send-tabs-button = Varaqlarni yuborishni boshlang

onboarding-pocket-anywhere-title = Istalgan joyda oʻqing va tinglang
onboarding-pocket-anywhere-text2 = Sevimli maqolalaringizni { -pocket-brand-name } yordamida saqlab qoʻying. Istalgan vaqtda internetga kirmasdan uni oʻqish, tinglash va koʻrishingiz mumkin.
onboarding-pocket-anywhere-button = { -pocket-brand-name }ni ishlatib koʻrish

onboarding-lockwise-strong-passwords-title = Ishonchli parollar yarating va saqlang
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } ishonchli parollar yaratadi va ularni bir joyda saqlaydi.
onboarding-lockwise-strong-passwords-button = Loginlaringizni boshqaring

onboarding-facebook-container-title = Facebook uchun chegara oʻrnating
onboarding-facebook-container-text2 = { -facebook-container-brand-name } profilingizni boshqalaridan alohida saqlaydi. Facebookning  reklama chiqarish uchun maʼlumotlaringizni kuzatishini qiyinlashtiradi.
onboarding-facebook-container-button = Kengaytmani qoʻshish


onboarding-import-browser-settings-title = Xatxhoʻp va parol kabilarni import qilish
onboarding-import-browser-settings-text = Chrome sozlamalari va u orqali kiritlgan saytlarni osongina import qiing.
onboarding-import-browser-settings-button = Chrome maʼlumotlarini import qilish

onboarding-personal-data-promise-button = Vaʼdamizni oʻqing

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Yashang, { -brand-short-name } oʻrnatildi

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Endi esa <icon></icon><b>{ $addon-name }ni oʻrnatamiz.</b>
return-to-amo-extension-button = Kengaytma qoʻshish
return-to-amo-get-started-button = { -brand-short-name } bilan ishlashni boshlang
