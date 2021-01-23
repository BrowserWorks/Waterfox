# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Rapor gönderilirken bir hata oluştu. Lütfen daha sonra tekrar deneyin.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Site düzeldi mi? Bize bildirin

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Sıkı
    .label = Sıkı
protections-popup-footer-protection-label-custom = Özel
    .label = Özel
protections-popup-footer-protection-label-standard = Standart
    .label = Standart

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Gelişmiş izlenme koruması hakkında daha fazla bilgi

protections-panel-etp-on-header = Bu sitede gelişmiş izlenme koruması AÇIK
protections-panel-etp-off-header = Bu sitede gelişmiş izlenme koruması KAPALI

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Site çalışmıyor mu?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Site çalışmıyor mu?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Neden?
protections-panel-not-blocking-why-etp-on-tooltip = Bunları engellemek bazı web sitelerini kısmen bozabilir. Takipçiler engellendiğinde bazı düğmeler, formlar ve giriş alanları çalışmayabilir.
protections-panel-not-blocking-why-etp-off-tooltip = Korumalar kapalı olduğu için bu sitedeki tüm takipçiler yüklendi.

##

protections-panel-no-trackers-found = Bu sayfada { -brand-short-name } tarayıcısının tanıdığı bir takipçi tespit edilmedi.

protections-panel-content-blocking-tracking-protection = Takip amaçlı içerikler

protections-panel-content-blocking-socialblock = Sosyal medya takipçileri
protections-panel-content-blocking-cryptominers-label = Kripto madencileri
protections-panel-content-blocking-fingerprinters-label = Parmak izi toplayıcılar

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Engellendi
protections-panel-not-blocking-label = İzin verildi
protections-panel-not-found-label = Bulunmadı

##

protections-panel-settings-label = Koruma ayarları
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Korumalar panosu

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Aşağıdakilerle ilgili sorun yaşıyorsanız korumaları kapatın:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Giriş alanları
protections-panel-site-not-working-view-issue-list-forms = Formlar
protections-panel-site-not-working-view-issue-list-payments = Ödemeler
protections-panel-site-not-working-view-issue-list-comments = Yorumlar
protections-panel-site-not-working-view-issue-list-videos = Videolar

protections-panel-site-not-working-view-send-report = Rapor gönderin

##

protections-panel-cross-site-tracking-cookies = Bu çerezler, internette yaptığınız şeyler hakkında veri toplamak için sizi siteden siteye takip eder. Reklam verenler ve analiz şirketleri gibi üçüncü taraflar tarafından yerleştirilirler.
protections-panel-cryptominers = Kripto madencileri sayısal para madenciliğinde bulunmak için sisteminizin hesaplama gücünü kullanır. Kripto madencilik betikleri pilinizi tüketir, bilgisayarınızı yavaşlatır ve elektrik faturanızı kabartabilir.
protections-panel-fingerprinters = Parmak izi toplayıcılar profilinizi oluşturmak için tarayıcı ve bilgisayarınızdaki ayarları toplar. Bu dijital parmak izini kullanarak farklı web siteler arasında sizi takip edebilirler.
protections-panel-tracking-content = Web siteleri; takip kodu içeren harici reklamlar, videolar ve başka içerikler yükleyebilir. Takip amaçlı içerikleri engellemek sitelerin daha hızlı yüklenmesini sağlayabilir ama bazı düğmeler, formlar ve giriş alanları çalışmayabilir.
protections-panel-social-media-trackers = Sosyal ağlar, internette yaptıklarınızı, gördüklerinizi ve izlediklerinizi takip etmek için diğer web sitelerine takipçiler yerleştirirler. Bu sayede sosyal medya şirketleri, sosyal medya profillerinizde paylaştıklarınızdan çok daha fazla şey öğrenebilir.

protections-panel-content-blocking-manage-settings =
    .label = Koruma ayarlarını yönet
    .accesskey = K

protections-panel-content-blocking-breakage-report-view =
    .title = Bozuk Bir Siteyi Bildirin
protections-panel-content-blocking-breakage-report-view-description = Bazı takipçileri engellemek bazı web sitelerinde sorunlara yol açabilir. Bu sorunları bize bildirirseniz { -brand-short-name } tarayıcısını iyileştirme şansımız olur. Bu rapor, sayfanın adresini ve tarayıcı ayarlarınızla ilgili bilgileri Mozilla’ya gönderir. <label data-l10n-name="learn-more">Daha fazla bilgi alın</label>
protections-panel-content-blocking-breakage-report-view-collection-url = Adres
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = Adres
protections-panel-content-blocking-breakage-report-view-collection-comments = İsteğe bağlı: Sorunu açıklayın
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = İsteğe bağlı: Sorunu açıklayın
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Vazgeç
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Raporu gönder
