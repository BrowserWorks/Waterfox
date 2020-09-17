# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Mag-set ng mga policy na maaaring ma-access ng WebExtensions sa chrome.storage.managed.
policy-AppAutoUpdate = Mag-enable o mag-disable ng automatic application update.
policy-AppUpdateURL = Set custom app update URL.
policy-Authentication = I-configure ang integrated na pagpapatotoo para sa mga website na sumusuporta dito.I-configure ang integrated na pagpapatotoo para sa mga website na sumusuporta dito.
policy-BlockAboutAddons = Harangin ang access sa Add-ons Manager (about:addons).
policy-BlockAboutConfig = Bawal i-access ang about:config page.
policy-BlockAboutProfiles = Bawal i-access ang about:profiles page.
policy-BlockAboutSupport = Bawal i-access ang about:support page.
policy-Bookmarks = Gumawa ng mga bookmark sa Bookmark toolbar, Bookmark menu, o kaya sa isang partikular na folder sa loob ng mga ito.
policy-CaptivePortal = I-enable o i-disable ang captive portal support.
policy-CertificatesDescription = Magdagdag ng mga certificate o gumamit ng built-in na mga certificate.
policy-Cookies = Payagan o pagbawalan ang mga website na maglagay ng mga cookie.
policy-DisabledCiphers = I-disable ang mga cipher.
policy-DefaultDownloadDirectory = I-set ang default download directory.
policy-DisableAppUpdate = Pigilan ang browser mula sa pag-update.
policy-DisableBuiltinPDFViewer = I-disable ang PDF.js, ang built-in na PDF viewer sa { -brand-short-name }.
policy-DisableDefaultBrowserAgent = Pigilan ang default browser agent sa kahit anong pagkilos. Para lamang ito sa Windows; walang agent ang ibang mga platform.
policy-DisableDeveloperTools = I-block ang access sa paggamit ng developer tools.
policy-DisableFeedbackCommands = I-disable ang mga command para magpadala ng feedback mula sa Help menu (Mag-submit ng Feedback at I-report ang Deceptive Site).
policy-DisableFirefoxAccounts = I-disable ang mga service ng { -fxaccount-brand-name }, kagaya ng Sync.
# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = I-disable ang Firefox Screenshots feature.
policy-DisableFirefoxStudies = Pigilan ang { -brand-short-name } mula sa pagpapatakbo ng mga pag-aaral.
policy-DisableForgetButton = hadlangan ang pag access sa Forget button.
policy-DisableFormHistory = Huwag tandaan ang search at form history.
policy-DisableMasterPasswordCreation = Kung true, hindi maaaring lumikha ng master password.
policy-DisablePrimaryPasswordCreation = Kung true, hindi maaaring makagawa ng Primary Password.
policy-DisablePasswordReveal = Huwag payagang mailantad ang mga password sa mga naka-save na login.
policy-DisablePocket = Huwag paganahin ang tampok na makapag-save ng mga webpage sa Pocket.
policy-DisablePrivateBrowsing = Huwag paganahin ang Pribadong Pagba-browse.
policy-DisableProfileImport = I-disable ang menu command para makapag-Import ng data mula sa ibang browser.
policy-DisableProfileRefresh = I-disable ang Refresh { -brand-short-name } button sa about:support page.
policy-DisableSafeMode = I-disable ang feature na makapag-restart sa Safe Mode. Note: ang Shift key para makapasok sa Safe Mode ay maaari lamang i-disable sa Windows gamit ang Group Policy.
policy-DisableSecurityBypass = Pigilan ang user na mag-bypass ng ilang security warning.
policy-DisableSetAsDesktopBackground = I-disable ang menu command na I-set bilang Desktop Background para sa mga larawan.
policy-DisableSystemAddonUpdate = Pigilan ang browser mula sa pagkabit at pag-update ng mga system add-on.
policy-DisableTelemetry = Isara ang Telemetry.
policy-DisplayBookmarksToolbar = Ipakita ang Bookmark Toolbar bilang default.
policy-DisplayMenuBar = Ipakita ang Menu Bar bilang default.
policy-DNSOverHTTPS = I-configure ang DNS over HTTPS.
policy-DontCheckDefaultBrowser = Huwag mag-check ng default browser sa startup.
policy-DownloadDirectory = I-set at i-lock ang download directory.
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = I-enable o i-disable ang Content Blocking at opsyonal itong i-lock.
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Mag-install, mag-uninstall, o mag-lock ng mga extension. Ang option na Mag-install ay kumukuha ng mga URL o path bilang parameter. Ang option na Mag-uninstall at Mag-lock ay kumukuha ng mga extension ID.
policy-ExtensionSettings = I-manage ang lahat ng aspeto ng pag-install ng mga extension.
policy-ExtensionUpdate = I-enable o i-disable ang kusang pag-update ng mga extension.
policy-FirefoxHome = I-configure ang Firefox Home.
policy-FlashPlugin = Payagan o pagbawalan ang paggamit ng Flash plugin.
policy-HardwareAcceleration = Kung false, isara ang hardware acceleration.
# “lock” means that the user won’t be able to change this setting
policy-Homepage = I-set at i-lock (optional) ang homepage.
policy-InstallAddonsPermission = Payagan ang ilang mga website na magkabit ng mga add-on.
policy-LegacyProfiles = I-disable ang feature na nagpapatupad ng hiwalay na profile sa bawat installation

## Do not translate "SameSite", it's the name of a cookie attribute.


##

policy-LocalFileLinks = Payagan ang ilang mga website na mag-link sa mga local file.
policy-MasterPassword = Kailanganin o pigilang gumamit ng master password.
policy-PrimaryPassword = Kailanganin o pigilang gumamit ng Primary Password.
policy-NetworkPrediction = I-enable o i-disable ang network prediction (DNS prefetching).
policy-NewTabPage = I-enable o i-disable ang New Tab page.
policy-NoDefaultBookmarks = I-disable ang paggawa ng mga default bookmark na kasama sa { -brand-short-name }, at mga Smart Bookmark (Most Visited, Recent Tags). Note: ang policy na ito ay may pakinabang lang kapag ginamit bago ang unang pagtakbo ng profile.
policy-OfferToSaveLogins = Ipatupad ang setting para payagan ang { -brand-short-name } na mag-alok na tandaan ang mga naka-save na login at password. Parehong tinatanggap ang mga true at false na value.
policy-OfferToSaveLoginsDefault = Itakda ang default value sa pagpahintulot sa { -brand-short-name } para mag-alok na alalahanin ang mga saved login at password. Parehong tinatanggap ang true at false na value.
policy-OverrideFirstRunPage = I-override ang first run page. Itakda ang polisiyang ito sa blangko kung gusto mong i-disable ang first run page.
policy-OverridePostUpdatePage = Patungan ang nilalaman ng pahinang "Ano ang Bago" matapos mag-update. Itakda ang polisiyang ito sa blangko kung gusto mong huwag paganahin ang post-update page.
policy-PasswordManagerEnabled = I-enable ang pag-save ng mga password sa password manager.
# PDF.js and PDF should not be translated
policy-PDFjs = I-disable o i-configure ang PDF.js, ang built-in na PDF viewer sa { -brand-short-name }.
policy-Permissions2 = I-configure ang mga pahintulot para sa camera, mikropono, lokasyon, abiso, at autoplay.
policy-PictureInPicture = I-enable o i-disable ang Picture-in-Picture.
policy-PopupBlocking = Payagan ang mga piling website para magpakita ng popup by default.
policy-Preferences = I-set at i-lock ang value para sa mga kagustuhan na napili
policy-PromptForDownloadLocation = Magtanong kung saan maaaring mag save ng file kapag nag-download.
policy-Proxy = I-configure ang mga proxy setting.
policy-RequestedLocales = I-set ang listahan ng mga hinihinging locale para sa application ayon sa ninanais na pagkakasunod.
policy-SanitizeOnShutdown2 = Burahin ang navigation data kapag nag-shutdown.
policy-SearchBar = I-set ang default location ng search bar. Pinapayagan pa rin ang user na baguhin ito.
policy-SearchEngines = I-configure ang mga setting ng search engine. Ang policy na ito ay matatagpuan lamang sa Extended Support Release (ESR) version.
policy-SearchSuggestEnabled = I-enable o i-disable ang mga search suggestion.
# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Ikabit ang mga PKCS #11 module.
policy-SSLVersionMax = I-set ang maximum SSL version.
policy-SSLVersionMin = I-set ang minimum SSL version.
policy-SupportMenu = Magdagdag ng custom support menu item sa help menu.
policy-UserMessaging = Huwag ipakita ang ilang mga mensahe sa gumagamit.
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Pigilang mabisita ang mga website. Tingnan ang documentation para sa karagdagang impormasyon sa format.
