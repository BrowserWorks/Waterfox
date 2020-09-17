# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } geçen hafta { $count } takipçiyi engelledi
       *[other] { -brand-short-name } geçen hafta { $count } takipçiyi engelledi
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } tarihinden beri <b>{ $count }</b> takipçi engellendi
       *[other] { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } tarihinden beri <b>{ $count }</b> takipçi engellendi
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } gizli pencelerde takipçileri engellemeye devam eder ama neleri engellediğinin kaydını tutmaz.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Bu hafta { -brand-short-name } tarafından engellenen takipçiler

protection-report-webpage-title = Korumalar Panosu
protection-report-page-content-title = Korumalar Panosu
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = Siz web’de gezinirken { -brand-short-name } arka planda gizliliğinizi koruyabilir. Aşağıda bu korumaların özetini ve çevrimiçi güvenliğinizi artırmanızı sağlayacak araçları görüyorsunuz.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = Siz web’de gezinirken { -brand-short-name } arka planda gizliliğinizi korur. Aşağıda bu korumaların özetini ve çevrimiçi güvenliğinizi artırmanızı sağlayacak araçları görüyorsunuz.

protection-report-settings-link = Gizlilik ve güvenlik ayarlarınızı yönetin

etp-card-title-always = Gelişmiş izlenme koruması: Her zaman açık
etp-card-title-custom-not-blocking = Gelişmiş izlenme koruması: KAPALI
etp-card-content-description = { -brand-short-name }, şirketlerin sizi web’de gizlice takip etmesini otomatik olarak engeller.
protection-report-etp-card-content-custom-not-blocking = Şu anda tüm korumalar kapalı. { -brand-short-name } koruma ayarlarınızı yöneterek hangi takipçilerin engelleneceğini seçebilirsiniz.
protection-report-manage-protections = Ayarları yönet

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Bugün

# This string is used to describe the graph for screenreader users.
graph-legend-description = Bu hafta engellenen her takipçi türünün toplam sayısını gösteren bir grafik.

social-tab-title = Sosyal medya takipçileri
social-tab-contant = Sosyal ağlar, internette yaptıklarınızı, gördüklerinizi ve izlediklerinizi takip etmek için diğer web sitelerine takipçiler yerleştirirler. Bu sayede sosyal medya şirketleri, sosyal medya profillerinizde paylaştıklarınızdan çok daha fazla şey öğrenebilir. <a data-l10n-name="learn-more-link">Daha fazla bilgi alın</a>

cookie-tab-title = Siteler arası takip çerezleri
cookie-tab-content = Bu çerezler gezdiğiniz siteleri takip ederek internette yaptıklarınız hakkında veri toplar. Bu çerezleri reklamcılar ve analitik şirketleri gibi üçüncü taraflar kullanır. Siteler arası takip çerezlerinin engellenmesi, sizi takip eden reklamların sayısını azaltır. <a data-l10n-name="learn-more-link">Daha fazla bilgi alın</a>

tracker-tab-title = Takip amaçlı içerikler
tracker-tab-description = Web siteleri; takip kodu içeren harici reklamlar, videolar ve başka içerikler yükleyebilir. Takip amaçlı içerikleri engellemek sitelerin daha hızlı yüklenmesini sağlayabilir ama bazı düğmeler, formlar ve giriş alanları çalışmayabilir. <a data-l10n-name="learn-more-link">Daha fazla bilgi alın</a>

fingerprinter-tab-title = Parmak izi toplayıcılar
fingerprinter-tab-content = Parmak izi toplayıcılar profilinizi oluşturmak için tarayıcı ve bilgisayarınızdaki ayarları toplarlar. Bu dijital parmak izini kullanarak farklı web siteler arasında sizi takip edebilirler. <a data-l10n-name="learn-more-link">Daha fazla bilgi alın</a>

cryptominer-tab-title = Kripto madencileri
cryptominer-tab-content = Kripto madencileri sayısal para madenciliğinde bulunmak için sisteminizin hesaplama gücünü kullanır. Kripto madencilik betikleri pilinizi tüketir, bilgisayarınızı yavaşlatır ve elektrik faturanızı kabartabilir. <a data-l10n-name="learn-more-link">Daha fazla bilgi alın</a>

protections-close-button2 =
    .aria-label = Kapat
    .title = Kapat
  
mobile-app-title = Reklam takipçilerini tüm cihazlarda engelleyin
mobile-app-card-content = Reklam takipçilerine karşı dahili korumaya sahip mobil tarayıcıyı kullanın.
mobile-app-links = <a data-l10n-name="android-mobile-inline-link">Android</a> ve <a data-l10n-name="ios-mobile-inline-link">iOS</a> için { -brand-product-name } Browser

lockwise-title = Bir daha hiçbir parolayı unutmayın
lockwise-title-logged-in2 = Parola yönetimi
lockwise-header-content = { -lockwise-brand-name } parolalarınızı tarayınızda güvenle saklar.
lockwise-header-content-logged-in = Parolalarınızı güvenle saklayıp tüm cihazlarınızla senkronize edebilirsiniz.
protection-report-save-passwords-button = Parolaları kaydet
    .title = Parolaları { -lockwise-brand-short-name } ile kaydet
protection-report-manage-passwords-button = Parolaları yönet
    .title = Parolaları { -lockwise-brand-short-name } ile yönet
lockwise-mobile-app-title = Parolalarınızı yanınızda taşıyın
lockwise-no-logins-card-content = { -brand-short-name } tarayıcınızda kaydettiğiniz parolaları tüm cihazlarınızda kullanın.
lockwise-app-links = <a data-l10n-name="lockwise-android-inline-link">Android</a> ve <a data-l10n-name="lockwise-ios-inline-link">iOS</a> için { -lockwise-brand-name }

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 parolanız bir veri ihlali kapsamında ele geçirilmiş olabilir.
       *[other] { $count } parolanız bir veri ihlali kapsamında ele geçirilmiş olabilir.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 parolanız güvenle saklanıyor.
       *[other] Parolalarınız güvenle saklanıyor.
    }
lockwise-how-it-works-link = Nasıl çalışır?

turn-on-sync = { -sync-brand-short-name }’i etkinleştir…
    .title = Eşitleme tercihlerine git

monitor-title = Veri hırsızlıklarından haberiniz olsun
monitor-link = Nasıl çalışır?
monitor-header-content-no-account = Bilinen veri ihlallerinde bilgilerinizin çalınıp çalınmadığını öğrenmek ve yeni ihlallerden haberdar olmak için { -monitor-brand-name }’ü ziyaret edin.
monitor-header-content-signed-in = Bilgileriniz bilinen bir veri ihlalinde yer alırsa { -monitor-brand-name } sizi uyarır.
monitor-sign-up-link = İhlal uyarılarına kaydol
    .title = { -monitor-brand-name }’de ihlal uyarılarına kaydolun
auto-scan = Bugün otomatik olarak tarandı

monitor-emails-tooltip =
    .title = İzlenen e-posta adreslerini { -monitor-brand-short-name }’de görün
monitor-breaches-tooltip =
    .title = Bilinen veri ihlallerini { -monitor-brand-short-name }’de görün
monitor-passwords-tooltip =
    .title = Ele geçirilen parolaları { -monitor-brand-short-name }’de görün

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] e-posta adresi izleniyor
       *[other] e-posta adresi izleniyor
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] veri ihlalinde bilgileriniz ele geçirildi
       *[other] veri ihlalinde bilgileriniz ele geçirildi
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] veri ihlali çözüldü olarak işaretlendi
       *[other] veri ihlali çözüldü olarak işaretlendi
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] parolanız veri ihlallerinde ele geçirildi
       *[other] parolanız veri ihlallerinde ele geçirildi
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] parolanız çözülmemiş veri ihlallerinde ele geçirildi
       *[other] parolanız çözülmemiş veri ihlallerinde ele geçirildi
    }

monitor-no-breaches-title = Her şey yolunda!
monitor-no-breaches-description = Bilinen veri ihlallerinde yer almıyorsunuz. Bu durum değişirse size haber vereceğiz.
monitor-view-report-link = Raporu görüntüle
    .title = { -monitor-brand-short-name }'de ihlalleri çözün
monitor-breaches-unresolved-title = İhlallerinizi çözün
monitor-breaches-unresolved-description = İhlal ayrıntılarını inceleyip bilgilerinizi korumak için gereken adımları attıktan sonra ihlalleri "çözüldü" olarak işaretleyebilirsiniz.
monitor-manage-breaches-link = İhlalleri yönet
    .title = İhlalleri { -monitor-brand-short-name }’de yönetin
monitor-breaches-resolved-title = Güzel! Bilinen tüm ihlalleri çözdünüz.
monitor-breaches-resolved-description = E-postanız yeni bir ihlalde ortaya çıkarsa size haber vereceğiz.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreaches } ihlalden { $numBreachesResolved } tanesi çözüldü olarak işaretlendi
       *[other] { $numBreaches } ihlalden { $numBreachesResolved } tanesi çözüldü olarak işaretlendi
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = %{ $percentageResolved } tamamlandı

monitor-partial-breaches-motivation-title-start = İyi başladınız!
monitor-partial-breaches-motivation-title-middle = Aynen böyle devam!
monitor-partial-breaches-motivation-title-end = Bitmek üzere! Aynen böyle devam.
monitor-partial-breaches-motivation-description = Geri kalan ihallerinizi { -monitor-brand-short-name }’de çözün.
monitor-resolve-breaches-link = İhlalleri çöz
    .title = İhlalleri { -monitor-brand-short-name }’de çözün

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Sosyal medya takipçileri
    .aria-label =
        { $count ->
            [one] { $count } sosyal medya takipçisi (%{ $percentage })
           *[other] { $count } sosyal medya takipçisi (%{ $percentage })
        }
bar-tooltip-cookie =
    .title = Siteler arası takip çerezleri
    .aria-label =
        { $count ->
            [one] { $count } siteler arası takip çerezi (%{ $percentage })
           *[other] { $count } siteler arası takip çerezi (%{ $percentage })
        }
bar-tooltip-tracker =
    .title = Takip amaçlı içerikler
    .aria-label =
        { $count ->
            [one] { $count } takip amaçlı içerik (%{ $percentage })
           *[other] { $count } takip amaçlı içerik (%{ $percentage })
        }
bar-tooltip-fingerprinter =
    .title = Parmak izi toplayıcılar
    .aria-label =
        { $count ->
            [one] { $count } parmak izi toplayıcı (%{ $percentage })
           *[other] { $count } parmak izi toplayıcı (%{ $percentage })
        }
bar-tooltip-cryptominer =
    .title = Kripto madencileri
    .aria-label =
        { $count ->
            [one] { $count } kripto madencisi (%{ $percentage })
           *[other] { $count } kripto madencisi (%{ $percentage })
        }
