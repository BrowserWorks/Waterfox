# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Hisobotni yuborishda xatolik yuz berdi. Keyinroq qayta urining.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Sayt tuzatildimi? Hisobot yuboring

## These strings are used to define the different levels of
## Enhanced Tracking Protection.


##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Kengaytirilgan kuzatuvdan himoya haqida batafsil

protections-panel-etp-on-header = Bu sayt uchun kengaytirilgan kuzatuvdan himoya yoniq
protections-panel-etp-off-header = Bu sayt uchun kengaytirilgan kuzatuvdan himoya oʻchiq

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Sayt ishlamayaptimi?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Sayt ishlamayaptimi?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Nima uchun?
protections-panel-not-blocking-why-etp-on-tooltip = Bloklasangiz, ayrim saytlaridagi elementlar ishlamasligi mumkin. Kuzatuvchilar ayrim tugma, shakl va login maydonchalarisiz sizni kuzata olmaydi.
protections-panel-not-blocking-why-etp-off-tooltip = Bu saytdagi barcha kuzatuvchilar yuklandi, chunki siz himoyani oʻchirib qoʻygansiz.

##

protections-panel-no-trackers-found = Bu sahifada { -brand-short-name }ga maʼlum boʻlgan hech qanday kuzatuvchi yuklanmadi.

protections-panel-content-blocking-tracking-protection = Kuzatuvchi kontent

protections-panel-content-blocking-socialblock = Ijtimoiy tarmoq kuzatuvchilari
protections-panel-content-blocking-cryptominers-label = Kriptomaynerlar
protections-panel-content-blocking-fingerprinters-label = Raqamli imzo yigʻuvchilar

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Bloklangan
protections-panel-not-blocking-label = Ruxsat berilgan
protections-panel-not-found-label = Hech narsa aniqlanmadi

##

protections-panel-settings-label = Himoya sozlamalari

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Bu bilan muammo boʻlsa, himoyani oʻchiring:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Login maydonchalari
protections-panel-site-not-working-view-issue-list-forms = Shakllar
protections-panel-site-not-working-view-issue-list-payments = Toʻlovlar
protections-panel-site-not-working-view-issue-list-comments = Sharhlar
protections-panel-site-not-working-view-issue-list-videos = Videolar

protections-panel-site-not-working-view-send-report = Hisobot yuborish

##

protections-panel-cross-site-tracking-cookies = Bundan kukilar internetda nima qilayotganingizni bilish uchun saytlarda sizni kuzatib boradi. Bunday kukilar analitik kompaniya va reklama beruvchilar tomonidan oʻrnatiladi.
protections-panel-cryptominers = Kriptomaynerlar raqamli pullarni qoʻlga kiritish uchun tizimingizning hisoblash quvvatidan foydalanadi. Bunday skriptlar batareya quvvatini tez tugatadi, kompyuter ishlashini sekinlashtiradi va elektr energiyasi toʻlovlarini koʻpaytirishi mumkin.
protections-panel-fingerprinters = Raqamli imzo yiʻguvchilar sizning nomingizdan profil yaratish uchun brauzer va kompyuteringiz sozlamalaridan foydalanadi. Bu raqamli imzodan foydalanib ular turli saytlardagi faoliyatingizni kuzatishi mumkin.
protections-panel-tracking-content = Saytlar tashqi reklama, video va boshqa turli kontentlarni kuzatish kodi bilan birga yuklashi mumkin. Kuzatuvchi kontentni bloklasangiz, saytlarni tez yuklanadi, lekin ayrim tugma, shakl va login maydonlari ishlamasligi mumkin.
protections-panel-social-media-trackers = Ijtimoiy tarmoqlar boshqa saytlarga kuzatuvchilarni joylaydi. Internetda nima qilayotganligingiz, nimani tomosha qilayotganligingizni bilishni istashadi. Bu ijtimoy mediya kompaniyalari egalariga siz haqingizda va ijtimoiy mediya profillaringizda nimani ulashayotganingizni koʻproq bilish imkonini beradi.

protections-panel-content-blocking-manage-settings =
    .label = Himoya sozlamalarini boshqarish
    .accesskey = M

protections-panel-content-blocking-breakage-report-view =
    .title = Buzilgan sayt haqida xabar berish
protections-panel-content-blocking-breakage-report-view-description = Ayrim kuzatuvchilarni bloklasangiz, baʼzi saytlarda muammo paydo boʻlishi mumkin. Bu muammo haqida xabar berish bilan siz { -brand-short-name }ni yaxshilashda yordam bergan hisoblanasiz. Bu hisobot bilan birga URL manzili va brauzeringiz sozlamalari haqidagi maʼlumotlar ham Mozillaga yuboriladi <label data-l10n-name="learn-more">Batafsil</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Ixtiyoriy: muammoni tasvirlab bering
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Ixtiyoriy: muammoni tasvirlab bering
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Bekor qilish
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Hisobot yuborish
