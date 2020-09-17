# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Aygıt yöneticisi
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Güvenlik Modülleri ve Aygıtları

devmgr-header-details =
    .label = Ayrıntılar

devmgr-header-value =
    .label = Değer

devmgr-button-login =
    .label = Giriş yap
    .accesskey = G

devmgr-button-logout =
    .label = Oturumu kapat
    .accesskey = O

devmgr-button-changepw =
    .label = Parola değiştir
    .accesskey = P

devmgr-button-load =
    .label = Yükle
    .accesskey = Y

devmgr-button-unload =
    .label = Boşalt
    .accesskey = B

devmgr-button-enable-fips =
    .label = FIPS’i etkinleştir
    .accesskey = F

devmgr-button-disable-fips =
    .label = FIPS’i etkisizleştir
    .accesskey = F

## Strings used for load device

load-device =
    .title = PKCS #11 aygıt sürücüsünü yükle

load-device-info = Eklemek istediğiniz modülle ilgili bilgileri girin.

load-device-modname =
    .value = Modül adı
    .accesskey = M

load-device-modname-default =
    .value = Yeni PKCS#11 Modülü

load-device-filename =
    .value = Modülün dosya adı
    .accesskey = o

load-device-browse =
    .label = Gözat…
    .accesskey = G

## Token Manager

devinfo-status =
    .label = Durum

devinfo-status-disabled =
    .label = Devre dışı

devinfo-status-not-present =
    .label = Mevcut değil

devinfo-status-uninitialized =
    .label = Ayarsız

devinfo-status-not-logged-in =
    .label = Giriş yapılmadı

devinfo-status-logged-in =
    .label = Giriş yapıldı

devinfo-status-ready =
    .label = Hazır

devinfo-desc =
    .label = Açıklama

devinfo-man-id =
    .label = Üretici

devinfo-hwversion =
    .label = HW Sürümü
devinfo-fwversion =
    .label = FW Sürümü

devinfo-modname =
    .label = Modül

devinfo-modpath =
    .label = Yol

login-failed = Giriş başarısız

devinfo-label =
    .label = Etiket

devinfo-serialnum =
    .label = Seri numarası

fips-nonempty-password-required = FIPS kipi, bütün güvenlik ayarlamaları için bir ana parola ihtiyaç duyar. Gerekli parolayı yerleştirin ve FIPS kipi etkinleştirmek için tekrar deneyin.

fips-nonempty-primary-password-required = FIPS kipi, her güvenlik cihazı bir ana parolaya ihtiyaç duyar. FIPS kipini etkinleştirmeden önce lütfen parolayı ayarlayın.
unable-to-toggle-fips = FIPS kipi güvenlik aygıtı için değiştirilemiyor. Bu uygulamadan çıkıp uygulamayı yeniden başlatmanız tavsiye edilir.
load-pk11-module-file-picker-title = Yüklemek için bir PKCS#11 aygıt sürücüsü seçin

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Modül adı boş olamaz.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ rezerve olduğu için modül adı olarak kullanılamaz.

add-module-failure = Modül eklenemedi
del-module-warning = Bu güvenlik modülünü silmek istediğinizden emin misiniz?
del-module-error = Modül silinemedi
