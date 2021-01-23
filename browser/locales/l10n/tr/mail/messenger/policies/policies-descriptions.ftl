# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = WebExtension’ların chrome.storage.managed aracılığıyla ulaşabileceği ilkeleri ayarla.

policy-AppAutoUpdate = Otomatik uygulama güncellemesini aç veya kapat.

policy-AppUpdateURL = Özel uygulama güncelleme URL’sini ayarla.

policy-Authentication = Destekleyen web siteleri için bütünleşik kimlik doğrulamasını yapılandır.

policy-BlockAboutAddons = Eklenti Yöneticisi'ne (about:addons) erişimi engelle.

policy-BlockAboutConfig = about:config sayfasına erişimi engelle.

policy-BlockAboutProfiles = about:profiles sayfasına erişimi engelle.

policy-BlockAboutSupport = about:support sayfasına erişimi engelle.

policy-CaptivePortal = Kısıtlama portali desteğini aç veya kapat.

policy-CertificatesDescription = Sertifika ekle veya yerleşik sertifikaları kullan.

policy-Cookies = Web sitelerinin çerez yerleştirmesine izin ver veya engelle.

policy-DisabledCiphers = Şifrelemeleri devre dışı bırak.

policy-DefaultDownloadDirectory = Varsayılan indirme klasörünü ayarla.

policy-DisableAppUpdate = { -brand-short-name } uygulamasının güncellenmesini engelle.

policy-DisableDefaultClientAgent = Varsayılan istemci agent’ının herhangi bir işlem yapmasını önle. Yalnızca Windows için geçerlidir. Diğer platformlarda agent yoktur.

policy-DisableDeveloperTools = Geliştirici araçlarına erişimi engelle.

policy-DisableFeedbackCommands = Yardım menüsünden geri bildirim göndermeye olanak sağlayan komutları (“Geri bildirim gönder” ve “Aldatıcı siteyi ihbar et”) devre dışı bırak.

policy-DisableForgetButton = Unut düğmesine erişimi engelle.

policy-DisableFormHistory = Arama ve form geçmişini hatırlama.

policy-DisableMasterPasswordCreation = True olarak ayarlanırsa ana parola oluşturulamaz.

policy-DisablePasswordReveal = Kayıtlı hesaplardaki parolaların görüntülenmesine izin verme.

policy-DisableProfileImport = Başka uygulamalardan verileri içe aktarmayı sağlayan menü komutunu devre dışı bırak.

policy-DisableSafeMode = Güvenli kipte yeniden başlatma özelliğini devre dışı bırak. Not: Güvenli kipe girmek için kullanılan Shift tuşu, Windows'ta ancak Grup İlkesi ile devre dışı bırakılabilir.

policy-DisableSecurityBypass = Kullanıcının bazı güvenlik uyarılarını atlamasını engelle.

policy-DisableSystemAddonUpdate = { -brand-short-name } uygulamasının sistem eklentilerini yüklemesini ve güncellemesini önle.

policy-DisableTelemetry = Telemetri’yi kapat.

policy-DisplayMenuBar = Varsayılan olarak menü çubuğunu göster.

policy-DNSOverHTTPS = HTTP üzerinden DNS’i yapılandır.

policy-DontCheckDefaultClient = Başlangıçta varsayılan istemci kontrolünü devre dışı bırak.

policy-DownloadDirectory = İndirme klasörünü ayarla ve kilitle.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = İçerik engellemeyi etkinleştir veya devre dışı bırak ve isteğe bağlı olarak kilitle.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Encrypted Media Extensions’ı etkinleştir veya devre dışı bırak ve isteğe bağlı olarak kilitle.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Eklentileri yükle, kaldır veya kilitle. Yükleme seçeneğinde parametre olarak URL veya yol kullanılır. Kaldırma ve kilitleme seçeneklerinde ise eklenti kimliği kullanılır.

policy-ExtensionSettings = Eklenti kurulumunun tüm yönlerini yönet.

policy-ExtensionUpdate = Otomatik eklenti güncellemelerini aç veya kapat.

policy-HardwareAcceleration = false ise donanım ivmelenmesini kapat.

policy-InstallAddonsPermission = Belirli websitelerinin eklenti yüklemesine izin ver.

policy-LegacyProfiles = Her kurulum için ayrı bir profil oluşturmayı zorunlu tutan özelliği devre dışı bırak.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Varsayılan eski SameSite çerez davranışı ayarını etkinleştir.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Belirtilen sitelerdeki çerezler için eski SameSite davranışına geri dön.

##

policy-LocalFileLinks = Belirli web sitelerinin yerel dosyalara bağlantı vermesine izin ver.

policy-NetworkPrediction = Ağ tahminini (DNS prefetching) aç veya kapat.

policy-OfferToSaveLogins = { -brand-short-name } tarayıcısının kullanıcı adı ve parolaları kaydetmeyi önermesini ayarla. true veya false olarak ayarlanabilir.

policy-OfferToSaveLoginsDefault = { -brand-short-name } yazılımının kullanıcı adı ve parolaları kaydetmeyi önermesi için varsayılan değeri ayarla. true veya false olarak ayarlanabilir.

policy-OverrideFirstRunPage = İlk açılış sayfasını değiştir. İlk açılış sayfasını devre dışı bırakmak istiyorsanız bu ilkeyi boş olarak ayarlayın.

policy-OverridePostUpdatePage = Güncelleme sonrası “Yenilikler” sayfasını değiştir. Güncelleme sonrası sayfasını devre dışı bırakmak istiyorsanız bu ilkeyi boş olarak ayarlayabilirsiniz.

policy-PasswordManagerEnabled = Parolaları parola yöneticisine kaydetmeyi aç.

# PDF.js and PDF should not be translated
policy-PDFjs = Dahili { -brand-short-name } PDF göstericisi olan PDF.js’i devre dışı bırak veya yapılandır.

policy-Permissions2 = Kamera, mikrofon, konum, bildirim ve otomatik oynatma izinlerini yapılandır.

policy-Preferences = Bir tercihler alt kümesinin değerini ayarlayıp kilitle.

policy-PromptForDownloadLocation = Dosya indirirken nereye kaydedileceklerini sor.

policy-Proxy = Vekil sunucu ayarlarını yapılandır.

policy-RequestedLocales = Uygulamada kullanılması istenen dilleri tercih sırasına göre ayarla.

policy-SanitizeOnShutdown2 = Kapatırken gezinti verilerini temizle.

policy-SearchEngines = Arama motoru ayarlarını yapılandır. Bu ilke yalnızca Extended Support Release (ESR) sürümünde geçerlidir.

policy-SearchSuggestEnabled = Arama önerilerini etkinleştir veya devre dışı bırak.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = PKCS #11 modüllerini yükle.

policy-SSLVersionMax = Maksimum SSL sürümünü ayarla.

policy-SSLVersionMin = Minimum SSL sürümünü ayarla.

policy-SupportMenu = Yardım menüsüne özel bir destek öğesi ekle.

policy-UserMessaging = Kullanıcıya belirli mesajları gösterme.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Web sitelerinin ziyaret edilmesini engelle. Biçimle ilgili daha fazla bilgi için belgelendirmeye bakın.
