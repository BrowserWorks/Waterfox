# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = 設定 WebExtension 可透過 chrome.storage.managed 存取的政策。

policy-AppAutoUpdate = 開啟或關閉應用程式自動更新。

policy-AppUpdateURL = 自訂應用程式更新網址。

policy-Authentication = 為支援的網站設定整合身分驗證方式。

policy-BlockAboutAddons = 防止開啟附加元件管理員（about:addons）。

policy-BlockAboutConfig = 防止開啟 about:config 頁面。

policy-BlockAboutProfiles = 防止開啟 about:profiles 頁面。

policy-BlockAboutSupport = 防止開啟 about:support 頁面。

policy-CaptivePortal = 開啟或關閉支援 Captive portal。

policy-CertificatesDescription = 新增憑證，或使用內建憑證。

policy-Cookies = 允許或拒絕網站設定 Cookie。

policy-DisabledCiphers = 停用加密演算法。

policy-DefaultDownloadDirectory = 設定預設下載資料夾。

policy-DisableAppUpdate = 防止 { -brand-short-name } 更新。

policy-DisableDefaultClientAgent = 不讓預設客戶端代理工具作任何事。僅對 Windows 有效，其他平台沒有代理工具可用。

policy-DisableDeveloperTools = 防止使用開發者工具。

policy-DisableFeedbackCommands = 停用於「說明」選單中傳送意見回饋的相關指令（「送出意見回饋」與「回報詐騙網站」）。

policy-DisableForgetButton = 防止使用「忘記」功能。

policy-DisableFormHistory = 不要記住搜尋與表單填寫紀錄。

policy-DisableMasterPasswordCreation = 若為 true，將無法建立主控密碼。

policy-DisablePasswordReveal = 不允許於儲存的登入資訊畫面中顯示密碼。

policy-DisableProfileImport = 停用自其他應用程式匯入資料的選單功能。

policy-DisableSafeMode = 停用以安全模式重新啟動的功能。註: 啟動時按住 Shift 鍵進入安全模式的功能，僅能於 Windows 使用群組原則停用。

policy-DisableSecurityBypass = 防止使用者忽略某些安全性警告。

policy-DisableSystemAddonUpdate = 防止 { -brand-short-name } 安裝或更新系統附加元件。

policy-DisableTelemetry = 關閉 Telemetry。

policy-DisplayMenuBar = 預設顯示選單列。

policy-DNSOverHTTPS = 設定 DNS over HTTPS。

policy-DontCheckDefaultClient = 啟動時不檢查是否為預設郵件軟體。

policy-DownloadDirectory = 設定並鎖定下載資料夾。

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = 開啟或關閉內容封鎖功能，並可選擇鎖定該功能。

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = 開啟或關閉加密媒體擴充功能，並可選擇鎖定該功能。

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = 安裝、移除或鎖定擴充套件。安裝選項可加入網址或路徑作為參數。移除和鎖定選項則需要擴充套件 ID 作為參數。

policy-ExtensionSettings = 管理擴充套件的各種安裝設定。

policy-ExtensionUpdate = 開啟或關閉擴充套件自動更新。

policy-HardwareAcceleration = 若為 false，就會關閉硬體加速。

policy-InstallAddonsPermission = 允許某些網站安裝附加元件。

policy-LegacyProfiles = 停用「於每一套安裝使用不同設定檔」的功能。

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = 開啟預設傳統 SameSite cookie 行為設定。

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = 對指定的網站恢復傳統 SameSite cookie 行為。

##

policy-LocalFileLinks = 允許特定網站鏈結到本機檔案。

policy-NetworkPrediction = 開啟或關閉網路預測（DNS 預讀）功能。

policy-OfferToSaveLogins = 強制允許 { -brand-short-name } 提供記住登入資訊與密碼的設定。true 與 false 設定都接受。

policy-OfferToSaveLoginsDefault = 允許 { -brand-short-name } 提供記住儲存登入帳號與密碼的功能。true 與 false 值都接受。

policy-OverrideFirstRunPage = 覆蓋「首次執行」頁面。若您想停用首次執行頁面，請將原則設為空白。

policy-OverridePostUpdatePage = 覆蓋更新後會開啟的「有什麼新鮮事」頁面。若您想停用此頁面，請將原則設為空白。

policy-PasswordManagerEnabled = 允許使用密碼管理員來儲存密碼。

# PDF.js and PDF should not be translated
policy-PDFjs = 停用或設定 { -brand-short-name } 內建的 PDF 閱讀器 PDF.js。

policy-Permissions2 = 設定攝影機、麥克風、地理位置、通知、自動播放等權限。

policy-Preferences = 鎖定部分偏好設定的內容。

policy-PromptForDownloadLocation = 下載檔案時，詢問要將檔案儲存至何處。

policy-Proxy = 設定代理伺服器選項。

policy-RequestedLocales = 為應用程式設定使用的語系清單順序。

policy-SanitizeOnShutdown2 = 關閉程式時，清除上網資料。

policy-SearchEngines = 調整搜尋引擎設定。此原則僅對 Extended Support Release（ESR）版本有效。

policy-SearchSuggestEnabled = 啟用或停用搜尋建議。

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = 安裝 PKCS #11 模組。

policy-SSLVersionMax = 設定最大 SSL 版本。

policy-SSLVersionMin = 設定最小 SSL 版本。

policy-SupportMenu = 於說明選單內新增自訂的技術支援項目。

policy-UserMessaging = 不要對使用者顯示某些訊息。

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = 封鎖網站，不讓使用者開啟。請參考文件取得設定格式的詳細資料。
