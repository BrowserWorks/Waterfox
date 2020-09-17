# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Eklenti Önerisi
cfr-doorhanger-feature-heading = Özellik Önerisi
cfr-doorhanger-pintab-heading = Bunu deneyin: Sekme sabitleme

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Bunu neden görüyorum?

cfr-doorhanger-extension-cancel-button = Daha sonra
    .accesskey = D

cfr-doorhanger-extension-ok-button = Hemen ekle
    .accesskey = H
cfr-doorhanger-pintab-ok-button = Bu sekmeyi sabitle
    .accesskey = s

cfr-doorhanger-extension-manage-settings-button = Öneri ayarlarını yönet
    .accesskey = Ö

cfr-doorhanger-extension-never-show-recommendation = Bana bu öneriyi gösterme
    .accesskey = B

cfr-doorhanger-extension-learn-more-link = Daha fazla bilgi al

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = geliştiren: { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Öneri
cfr-doorhanger-extension-notification2 = Öneri
    .tooltiptext = Eklenti önerisi
    .a11y-announcement = Eklenti öneriniz var

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Öneri
    .tooltiptext = Özellik önerisi
    .a11y-announcement = Özellik öneriniz var

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } yıldız
           *[other] { $total } yıldız
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } kullanıcı
       *[other] { $total } kullanıcı
    }

cfr-doorhanger-pintab-description = En çok kullandığınız sitelere kolayca ulaşın. Siteleri sabit bir sekmede açık tutabilirsiniz (tarayıcınızı yeniden başlatsanız bile).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = Sabitlemek istediğiniz sekmeye <b>sağ tıklayın</b>.
cfr-doorhanger-pintab-step2 = Menüden <b>Sekmeyi sabitle</b>’yi seçin.
cfr-doorhanger-pintab-step3 = Sitede bir güncelleme olursa sabit sekmenizde mavi bir nokta göreceksiniz.

cfr-doorhanger-pintab-animation-pause = Duraklat
cfr-doorhanger-pintab-animation-resume = Devam et


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Yer imlerinize her yerden ulaşın.
cfr-doorhanger-bookmark-fxa-body = Bu yer imine mobil cihazlarınızdan da ulaşmak istemez miydiniz? Hemen { -fxaccount-brand-name } açın.
cfr-doorhanger-bookmark-fxa-link-text = Yer imlerini eşitle…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Kapat düğmesi
    .title = Kapat

## Protections panel

cfr-protections-panel-header = Takip edilmeden gezin
cfr-protections-panel-body = Verileriniz sizde kalsın. { -brand-short-name }, internette ne yaptığınızı öğrenmeye çalışan takipçilerin çoğundan sizi korur.
cfr-protections-panel-link-text = Daha fazla bilgi alın

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Yeni özellik:

cfr-whatsnew-button =
    .label = Yeni neler var?
    .tooltiptext = Yeni neler var?

cfr-whatsnew-panel-header = Yeni neler var?

cfr-whatsnew-release-notes-link-text = Sürüm notlarını okuyun

cfr-whatsnew-fx70-title = { -brand-short-name } artık gizliliğiniz için daha sıkı çalışıyor
cfr-whatsnew-fx70-body = Bu güncellemede İzlenme Koruması özelliğini geliştirdik ve sitelere kaydolurken güvenli parola üretmeyi daha da kolaylaştırdık.

cfr-whatsnew-tracking-protect-title = Kendinizi takipçilerden koruyun
cfr-whatsnew-tracking-protect-body = { -brand-short-name }, internette yaptıklarınızı izleyen çoğu sosyal medya takipçisini ve siteler arası takipçiyi engeller.
cfr-whatsnew-tracking-protect-link-text = Raporunuzu görün

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Engellenen takipçi
       *[other] Engellenen takipçiler
    }
cfr-whatsnew-tracking-blocked-subtitle = { DATETIME($earliestDate, month: "long", year: "numeric") } tarihinden beri
cfr-whatsnew-tracking-blocked-link-text = Raporu görüntüle

cfr-whatsnew-lockwise-backup-title = Parolalarınızı yedekleyin
cfr-whatsnew-lockwise-backup-body = Giriş yaptığınız her yerden ulaşabileceğiniz, güvenli parolalar oluşturun.
cfr-whatsnew-lockwise-backup-link-text = Yedeklemeyi aç

cfr-whatsnew-lockwise-take-title = Parolalarınızı yanınızda taşıyın
cfr-whatsnew-lockwise-take-body = { -lockwise-brand-short-name } mobil uygulaması, yedeklediğiniz parolalara her yerden güvenle ulaşmanızı sağlar.
cfr-whatsnew-lockwise-take-link-text = Uygulamayı indir

## Search Bar

cfr-whatsnew-searchbar-title = Adres çubuğuna daha az yazın, daha çok bulun
cfr-whatsnew-searchbar-body-topsites = Şimdi adres çubuğunu seçin. Sık kullandığınız bağlantıları gösteren bir kutu açılacak.
cfr-whatsnew-searchbar-icon-alt-text = Büyüteç simgesi

## Picture-in-Picture

cfr-whatsnew-pip-header = İnternette gezinirken video izleyin
cfr-whatsnew-pip-body = Görüntü içinde görüntü özelliği, başka sekmelerle çalışırken video izleyebilmeniz için videoyu ayrı bir pencereye koyar.
cfr-whatsnew-pip-cta = Daha fazla bilgi al

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Daha az açılır pencere
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } artık sitelerin size bildirim soruları sormasını engelliyor.
cfr-whatsnew-permission-prompt-cta = Daha fazla bilgi al

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Engellenen parmak izi toplayıcı
       *[other] Engellenen parmak izi toplayıcı
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name }, reklamcılara özel profilinizi çıkarmak için cihazınız ve eylemleriniz hakkında gizlice bilgi toplayan birçok parmak izi toplayıcıyı engelliyor.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Parmak izi toplayıcılar
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name }, reklamcılara özel profilinizi çıkarmak için cihazınız ve eylemleriniz hakkında gizlice bilgi toplayan parmak izi toplayıcıları engelleyebilir.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Bu yer imini telefonunuza gönderin
cfr-doorhanger-sync-bookmarks-body = Yer imlerinize, parolalarınıza, geçmişinize ve diğer bilgilerinize { -brand-product-name } tarayıcınıza giriş yaptığınız her yerden ulaşın.
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name }’i aç
    .accesskey = a

## Login Sync

cfr-doorhanger-sync-logins-header = Bir daha hiçbir parolanızı unutmayın
cfr-doorhanger-sync-logins-body = Parolalanızı güvenle depolayın, onlara tüm cihazlarınızdan ulaşın.
cfr-doorhanger-sync-logins-ok-button = { -sync-brand-short-name }’i aç
    .accesskey = a

## Send Tab

cfr-doorhanger-send-tab-header = Bu yazıyı yolda okuyun
cfr-doorhanger-send-tab-recipe-header = Bu yazıyı yanınızda taşıyın
cfr-doorhanger-send-tab-body = Sekme Gönder özelliğiyle bu bağlantıyı kolayca telefonunuza veya { -brand-product-name }’a giriş yaptığınız her yere gönderebilirsiniz.
cfr-doorhanger-send-tab-ok-button = Sekme göndermeyi dene
    .accesskey = S

## Firefox Send

cfr-doorhanger-firefox-send-header = Bu PDF’i güvenle paylaşın
cfr-doorhanger-firefox-send-body = Uçtan uca şifreleme ve işiniz bittiğinde kaybolan bir bağlantıyla hassas belgelerinizi meraklı gözlerden koruyun.
cfr-doorhanger-firefox-send-ok-button = { -send-brand-name }’i deneyin
    .accesskey = e

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Korumalara bak
    .accesskey = K
cfr-doorhanger-socialtracking-close-button = Kapat
    .accesskey = a
cfr-doorhanger-socialtracking-dont-show-again = Bunun gibi mesajlar bir daha gösterme
    .accesskey = B
cfr-doorhanger-socialtracking-heading = { -brand-short-name } bir sosyal ağın sizi izlemesini engelledi
cfr-doorhanger-socialtracking-description = Gizliliğiniz bizim için önemli. { -brand-short-name } artık yaygın sosyal medya takipçilerini engelliyor, böylece internette yaptıklarınız hakkında daha az veri toplayabilmelerini sağlıyor.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } bu sayfadaki bir parmak izi toplayıcıyı engelledi
cfr-doorhanger-fingerprinters-description = Gizliliğiniz bizim için önemli. { -brand-short-name }, sizi izlemek için cihazınızı tanımlayabilecek bilgileri toplayan parmak izi toplayıcıları kendiliğinden engelliyor.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } bu sayfadaki bir kripto madencisini engelledi
cfr-doorhanger-cryptominers-description = Gizliliğiniz bizim için önemli. { -brand-short-name }, bilgisayarınızın işlemcisini dijital para üretmek için kullanan kripto madencilerini kendiliğinden engelliyor.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } { $date } tarihinden beri <b>{ $blockedCount }</b> takipçiyi engelledi!
       *[other] { -brand-short-name } { $date } tarihinden beri <b>{ $blockedCount }</b> takipçiyi engelledi!
    }
cfr-doorhanger-milestone-ok-button = Tümünü göster
    .accesskey = T

cfr-doorhanger-milestone-close-button = Kapat
    .accesskey = K

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Kolayca güvenli parolalar oluşturun
cfr-whatsnew-lockwise-body = Her hesap için benzersiz ve güvenli parolalar düşünmek zordur. Parola alanını seçerek { -brand-shorter-name } ile güvenli parolalar oluşturabilirsiniz.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } simgesi

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Güvensiz parolalar hakkında uyarılar alın
cfr-whatsnew-passwords-body = Hacker’lar insanların aynı parolaları farklı yerlerde kullandığını biliyor. Aynı parolayı birden çok sitede kullandıysanız ve bu sitelerden birinin verileri ele geçirildiyse { -lockwise-brand-short-name } ilgili sitelerdeki parolalarınızı değiştirmeniz için sizi uyaracak.
cfr-whatsnew-passwords-icon-alt = Güvensiz parola anahtar simgesi

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Görüntü içinde görüntüyü tam ekrana taşıyın
cfr-whatsnew-pip-fullscreen-body = Görüntü içinde görüntü modunda açtığınız videolara çift tıklayarak onları tam ekran yapabilirsiniz.
cfr-whatsnew-pip-fullscreen-icon-alt = Görüntü içinde görüntü simgesi

## Protections Dashboard message

cfr-whatsnew-protections-header = Korumalara hızlı bir bakış
cfr-whatsnew-protections-body = Korumalar panosu, veri ihlalleri ve parola yönetimi hakkında özet raporlar içerir. İhlallerin kaçını çözdüğünüzü izleyebilir, kayıtlı parolalarınızın veri ihlalleri kapsamında ele geçirilip geçirilmediğini görebilirsiniz.
cfr-whatsnew-protections-cta-link = Korumalar panosunu aç
cfr-whatsnew-protections-icon-alt = Kalkan simgesi

## Better PDF message

cfr-whatsnew-better-pdf-header = Daha iyi PDF deneyimi
cfr-whatsnew-better-pdf-body = PDF belgeleri artık doğrudan { -brand-short-name } içinde açılıyor, böylece işleriniz kolaylaşıyor.

## DOH Message

cfr-doorhanger-doh-body = Gizliliğiniz bizim için önemli. Web’de gezinirken gizliliğinizi korumak için { -brand-short-name } artık DNS isteklerinizi mümkün olduğunca iş ortaklarımıza yönlendiriyor.
cfr-doorhanger-doh-header = Daha güvenli, şifrelenmiş DNS sorguları
cfr-doorhanger-doh-primary-button = Tamam
    .accesskey = m
cfr-doorhanger-doh-secondary-button = Devre dışı bırak
    .accesskey = D

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Sinsi izleme taktiklerinden otomatik koruma
cfr-whatsnew-clear-cookies-body = Bazı takipçiler sizi bilgisayarınıza gizlice çerez yerleştiren web sitelerine yönlendirir. { -brand-short-name } artık bu çerezleri otomatik olarak temizliyor, böylece takip edilemiyorsunuz.
cfr-whatsnew-clear-cookies-image-alt = Çerez engellendi çizimi
