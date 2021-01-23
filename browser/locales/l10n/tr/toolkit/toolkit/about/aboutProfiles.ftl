# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Profiller hakkında
profiles-subtitle = Bu sayfa profillerinizi yönetmenize yardımcı olur. Her profil; ayrı bir geçmiş, yer imleri, ayarlar ve eklentiler içeren ayrı birer dünyadır.
profiles-create = Yeni profil oluştur
profiles-restart-title = Yeniden başlat
profiles-restart-in-safe-mode = Eklentileri devre dışı bırakıp yeniden başlat…
profiles-restart-normal = Normal şekilde yeniden başlat…
profiles-conflict = Başka bir { -brand-product-name } kopyası profillerde değişiklik yaptı. Daha fazla değişiklik yapmadan önce { -brand-short-name } tarayıcınızı yeniden başlatmalısınız.
profiles-flush-fail-title = Değişiklikler kaydedilmedi
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Beklenmeyen bir hata nedeniyle değişiklikleriniz kaydedilemedi.
profiles-flush-restart-button = { -brand-short-name } tarayıcısını yeniden başlat

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Varsayılan profil mi?
profiles-rootdir = Kök klasör

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Yerel klasör
profiles-current-profile = Bu profil şu anda kullanıldığı için silinemez.
profiles-in-use-profile = Bu profil başka bir uygulama tarafından kullanılmakta olduğu için silinemez.

profiles-rename = Adını değiștir
profiles-remove = Sil
profiles-set-as-default = Varsayılan profil yap
profiles-launch-profile = Profili yeni tarayıcıda aç

profiles-cannot-set-as-default-title = Varsayılan olarak ayarlanamadı
profiles-cannot-set-as-default-message = Varsayılan { -brand-short-name } profili değiştirilemedi.

profiles-yes = evet
profiles-no = hayır

profiles-rename-profile-title = Profilin adını değiştir
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = { $name } profilinin adını değiştir

profiles-invalid-profile-name-title = Geçersiz profil adı
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = “{ $name }” şeklindeki profil adına izin verilmiyor.

profiles-delete-profile-title = Profili sil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Bir profili silerseniz o profil, kullanılabilir profiller listesinden kaldırılır ve bu eylem geri alınamaz.
    Dilerseniz ayarlarınızın, sertifikalarınızın ve diğer kullanıcıyla ilişkileri verilerin yer aldığı profil veri dosyalarını da silebilirsiniz. Bu seçenek “{ $dir }” klasörünü siler ve geri alınamaz.
    Profil veri dosyalarını silmek istiyor musunuz?
profiles-delete-files = Dosyaları sil
profiles-dont-delete-files = Dosyaları silme

profiles-delete-profile-failed-title = Hata
profiles-delete-profile-failed-message = Bu profili silmeye çalışırken bir hata oluştu.


profiles-opendir =
    { PLATFORM() ->
        [macos] Finder'da göster
        [windows] Klasörü aç
       *[other] Dizini aç
    }
