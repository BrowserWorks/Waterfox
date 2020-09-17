# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Caktoni rregulla të cilat WebExtensions mund t’i shohin përmes chrome.storage.managed.

policy-AppAutoUpdate = Aktivizoni ose çaktivizoni përditësime të vetvetishme aplikacionesh.

policy-AppUpdateURL = Caktoni URL vetjake përditësimi aplikacioni.

policy-Authentication = Formësoni mirëfilltësim të integruar për sajte që e mbulojnë atë.

policy-BlockAboutAddons = Bllokoni hyrje te Përgjegjësi i Shtesave (about:addons).

policy-BlockAboutConfig = Bllokoni hyrje te faqja about:config.

policy-BlockAboutProfiles = Bllokoni hyrje te faqja about:profiles.

policy-BlockAboutSupport = Bllokoni hyrje te faqja about:support.

policy-CaptivePortal = Aktivizoni ose çaktivizoni mbulim për <em>captive portal</em>.

policy-CertificatesDescription = Shtoni dëshmi ose përdorni dëshmi të brendshme të programit.

policy-Cookies = Lejoni ose jo që sajte të depozitojnë cookies.

policy-DisabledCiphers = Çaktivizo shifra.

policy-DefaultDownloadDirectory = Caktoni drejtori parazgjedhje shkarkimesh.

policy-DisableAppUpdate = Pengojani { -brand-short-name }-it xhirimin e studimeve.

policy-DisableDefaultClientAgent = Pengo agjent klienti parazgjedhje të ndërmarrë ndonjë veprim. E zbatueshme vetëm për Windows; platformat e tjera s’e kanë agjentin.

policy-DisableDeveloperTools = Bllokoni hyrje te mjetet për zhvillues.

policy-DisableFeedbackCommands = Çaktivizoni te menuja Ndihmë urdhra për dërgim përshtypjesh (Parashtroni Përshtypje dhe  Raportoni Sajt të Rrejshëm).

policy-DisableForgetButton = Pengoni përdorimin e butoni Harroje.

policy-DisableFormHistory = Mos mba mend historik kërkimesh dhe plotësimi formularësh.

policy-DisableMasterPasswordCreation = Nëse caktohet <em>true</em>, s’mund të krijohet një fjalëkalim i përgjithshëm.

policy-DisablePasswordReveal = Mos lejo të shfaqen fjalëkalime te kredenciale hyrjesh të ruajtura.

policy-DisableProfileImport = Çaktivizoni te menuja urdhrin për Importim të dhënash nga një tjetër shfletues.

policy-DisableSafeMode = Çaktivizoni veçorinë e rinisjes nën Mënyrën e Parrezik. Shënim: tasti Shift për hyrje nën Mënyrën e Parrezik mund të çaktivizohet vetëm në Windows, duke përdorur Rregulla Grupi.

policy-DisableSecurityBypass = Pengojini përdoruesit të anashkalojë disa sinjalizime sigurie.

policy-DisableSystemAddonUpdate = Pengojeni { -brand-short-name }-in të instalojë dhe përditësojë shtesa sistemi.

policy-DisableTelemetry = Çaktivizoni Telemetry-në.

policy-DisplayMenuBar = Shfaqni Shtyllë Menush, si parazgjedhje.

policy-DNSOverHTTPS = Formësoni DNS përmes HTTPS-je.

policy-DontCheckDefaultClient = Çaktivizoni kontrollin për klient parazgjedhje gjatë nisjes.

policy-DownloadDirectory = Caktoni dhe kyçni drejtorinë e shkarkimeve.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Aktivizoni ose çaktivizoni Bllokim Lënde, dhe kyçeni, në daçi.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Aktivizoni ose çaktivizoni Zgjerime Mediash të Fshehtëzuara, dhe kyçeni, në daçi.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instaloni, çinstaloni ose kyçni zgjerime. Mundësia Instaloni si parametra përdor URL ose shtigje. Mundësitë Çinstaloni dhe Kyçur përdorin ID zgjerimesh.

policy-ExtensionSettings = Administroni krejt anët e instalimit të zgjerimeve.

policy-ExtensionUpdate = Aktivizoni ose çaktivizoni përditësime të vetvetishme të zgjerimeve.

policy-HardwareAcceleration = Në u caktoftë "false", çaktivizohet përshpejtimi përmes hardware-it.

policy-InstallAddonsPermission = Lejojuni disa sajteve të caktuar të instalojnë shtesa.

policy-LegacyProfiles = Çaktivizo veçorinë e zbatimit me detyrim të një profili veçmas për çdo instalim.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Aktivizoni rregullimin parazgjedhje të dikurshëm për sjelljen e cookie-t SameSite.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Rikthe sjelljen e dikurshme për SameSite, për cookie-t në sajtet e specifikuar.

##

policy-LocalFileLinks = Lejo sajte specifikë të krijojnë lidhje te kartela vendore.

policy-NetworkPrediction = Aktivizoni ose çaktivizoni parashikim rrjeti (<em>DNS prefetching</em>).

policy-OfferToSaveLogins = Bëjeni të detyrueshëm rregullimin për lejimin e { -brand-short-name }-it të ofrojë të mbajë mend kredenciale hyrjesh dhe fjalëkalime. Pranohet që të dyja vlerat, <em>true</em> dhe <em>false</em>.

policy-OfferToSaveLoginsDefault = Caktoni vlerën parazgjedhje për lejim të { -brand-short-name }-it të ofrojë mbajtjen mend të kredencialeve të hyrjes dhe fjalëkalimeve të ruajtur. Pranohet si vlera <em>true</em>,  ashtu edhe ajo <em>false</em>.

policy-OverrideFirstRunPage = Anashkaloni faqen e xhirimit për herë të parë. Lëreni të zbrazët, nëse doni të çaktivizohet faqja e xhirimit për herë të parë.

policy-OverridePostUpdatePage = Anashkaloni faqen “Ç’ka të Re” që shfaqet pas përditësimesh. Lëreni të zbrazët, nëse doni të çaktivizohet faqja pas-përditësim.

policy-PasswordManagerEnabled = Aktivizoni ruajtjen e fjalëkalimeve te përgjegjësi i fjalëkalimeve.

# PDF.js and PDF should not be translated
policy-PDFjs = Çaktivizoni pse formësoni PDF.js, parësin e brendshëm të PDF-ve në { -brand-short-name }.

policy-Permissions2 = Formësoni lejet për kamerën, mikrofonin, vendndodhjen, njoftimet dhe vetëluajtjen.

policy-Preferences = Caktoni dhe kyçni vlerën për një nëngrup parapëlqimesh.

policy-PromptForDownloadLocation = Pyet ku të ruhen kartelat kur shkarkohen.

policy-Proxy = Formësoni rregullime ndërmjetësi

policy-RequestedLocales = Caktoni për aplikacionin listën e gjuhëve të kërkuara, renditur sipas parapëlqimit.

policy-SanitizeOnShutdown2 = Gjatë fikjes, spastro të dhëna lëvizjeje.

policy-SearchEngines = Formësoni rregullime motori kërkimesh. Ky rregull tani është i përdorshëm vetëm në versionin Extended Support Release (ESR).

policy-SearchSuggestEnabled = Aktivizoni ose çaktivizoni sugjerime kërkimi.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instaloni module PKCS #11.

policy-SSLVersionMax = Caktoni version maksimum SSL-je.

policy-SSLVersionMin = Caktoni version minimum SSL-je.

policy-SupportMenu = Shtoni te menuja e ndihmës një element vetjak menuje asistence.

policy-UserMessaging = Mos i shfaq përdoruesit disa mesazhe të caktuara.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Bllokoni vizita në sajte. Për më tepër hollësi mbi këtë format, shihni dokumentimin.
