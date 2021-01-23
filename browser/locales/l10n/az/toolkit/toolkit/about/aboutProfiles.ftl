# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Profillər Haqqında
profiles-subtitle = Bu səhifə profillərinizi idarə etməyə kömək edir. Hər bir profil ayrıca tarixçə, əlfəcin, tənzimləmə və əlavələri tutan ayrı bir dünyadır.
profiles-create = Yeni Profil Yarat
profiles-restart-title = Yenidən başlat
profiles-restart-in-safe-mode = Əlavələr sönülü olaraq yenidən başlat…
profiles-restart-normal = Normal yenidən başlat…

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profil: { $name }
profiles-is-default = Əsas Profil
profiles-rootdir = Kök Direktivi

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Lokal Direktiv
profiles-current-profile = Bu hazırda işlədilən profildir və silinə bilməz.
profiles-in-use-profile = Bu profil başqa tətbiq tərəfindən istifadə edildiyi üçün silinə bilməz.

profiles-rename = Yenidən adlandır
profiles-remove = Sil
profiles-set-as-default = Əsas profil olaraq seç
profiles-launch-profile = Profili yeni səyyahda aç

profiles-cannot-set-as-default-title = Standart olaraq seçilə bilmir
profiles-cannot-set-as-default-message = Standart profil { -brand-short-name } üçün dəyişdilər bilmir.

profiles-yes = bəli
profiles-no = yox

profiles-rename-profile-title = Profil adını dəyişdir
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = { $name } profilinin adını dəyiş

profiles-invalid-profile-name-title = Xətalı profil adı
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Profil adı "{ $name }" üçün icazə verilmir.

profiles-delete-profile-title = Profili Sil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Silmək istədiyiniz profil, istifadəçi profilləri siyahısından silinəcək və bu əməliyyat geri qaytarıla bilməz.
    Həmçinin tənzimləmə, sertifikatlar və digər istifadəçi məlumatlarınız daxil profil məlumat fayllarını silə bilərsiniz. Bu özəllik "{ $dir }" qovluğunu siləcək və bu geri alına bilməz.
    Profil məlumat fayllarını silmək istərdiniz?
profiles-delete-files = Faylları Sil
profiles-dont-delete-files = Faylları Silmə

profiles-delete-profile-failed-title = Xəta
profiles-delete-profile-failed-message = Bu profili silərkən xəta baş verdi.


profiles-opendir =
    { PLATFORM() ->
        [macos] Finder-də göstər
        [windows] Qovluğu Aç
       *[other] Direktivi Aç
    }
