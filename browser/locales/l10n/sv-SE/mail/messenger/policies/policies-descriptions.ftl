# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Ange policyer som WebExtensions kan komma åt via chrome.storage.managed.

policy-AppAutoUpdate = Aktivera eller inaktivera automatisk applikationsuppdatering.

policy-AppUpdateURL = Ange webbadress för anpassad appuppdatering.

policy-Authentication = Konfigurera integrerad autentisering för webbplatser som stöder den.

policy-BackgroundAppUpdate2 = Aktivera eller inaktivera uppdateringar i bakgrunden.

policy-BlockAboutAddons = Blockera åtkomst till tilläggshanteraren (about:addons).

policy-BlockAboutConfig = Blockera åtkomst till sidan about:config.

policy-BlockAboutProfiles = Blockera åtkomst till sidan about:profiles.

policy-BlockAboutSupport = Blockera åtkomst till sidan about:support.

policy-CaptivePortal = Aktivera eller inaktivera stöd för infångstportal.

policy-CertificatesDescription = Lägg till certifikat eller använd inbyggda certifikat.

policy-Cookies = Tillåt eller neka webbplatser att ställa in kakor.

policy-DisableBuiltinPDFViewer = Inaktivera PDF.js, den inbyggda PDF-visaren i { -brand-short-name }.

policy-DisabledCiphers = Inaktivera chiffer.

policy-DefaultDownloadDirectory = Ange standardkatalog för nedladdning.

policy-DisableAppUpdate = Förhindra { -brand-short-name } från att uppdateras.

policy-DisableDefaultClientAgent = Förhindra standardklientagenten från att vidta några åtgärder. Gäller endast Windows; andra plattformar har inte agenten.

policy-DisableDeveloperTools = Blockera åtkomst till utvecklarverktygen.

policy-DisableFeedbackCommands = Inaktivera kommandon för att skicka återkoppling från hjälpmenyn (Skicka in återkoppling och rapportera vilseledande webbplats).

policy-DisableForgetButton = Förhindra åtkomst till ångraknappen.

policy-DisableFormHistory = Kom inte ihåg sök- och formulärhistorik.

policy-DisableMasterPasswordCreation = Om sant, ett huvudlösenord kan inte skapas.

policy-DisablePasswordReveal = Låt inte lösenord avslöjas i sparade inloggningar.

policy-DisableProfileImport = Inaktivera menykommandot för att importera data från en annan applikation.

policy-DisableSafeMode = Inaktivera funktionen för att starta om i felsäkert läge. Obs! Skift-tangenten för att gå in i felsäkert läge kan endast inaktiveras i Windows med hjälp av grupprincip.

policy-DisableSecurityBypass = Förhindra användaren att kringgå vissa säkerhetsvarningar.

policy-DisableSystemAddonUpdate = Förhindra { -brand-short-name } från att installera och uppdatera systemtillägg.

policy-DisableTelemetry = Stäng av telemetri.

policy-DisplayMenuBar = Visa menyraden som standard.

policy-DNSOverHTTPS = Konfigurera DNS över HTTPS.

policy-DontCheckDefaultClient = Inaktivera kontroll för standardklient vid start.

policy-DownloadDirectory = Ställa in och låsa nedladdningskatalogen.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Aktivera eller inaktivera innehållsblockering och eventuellt låsa den.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Aktivera eller inaktivera krypterade medieutökningar och lås den eventuellt.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Installera, avinstallera eller låsa tillägg. Installeringsalternativet tar webbadresser eller sökvägar som parametrar. Alternativen avinstallera och låst tar tilläggs-ID.

policy-ExtensionSettings = Hantera alla aspekter av tilläggsinstallation.

policy-ExtensionUpdate = Aktivera eller inaktivera automatiska tilläggsuppdateringar.

policy-Handlers = Konfigurera standardprogramhanterare.

policy-HardwareAcceleration = Om falsk, stängs hårdvaruacceleration av.

policy-InstallAddonsPermission = Tillåt vissa webbplatser att installera tillägg.

policy-LegacyProfiles = Inaktivera funktionen som framtvingar en separat profil för varje installation.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Aktivera standardinställningen för föråldrat SameSite-kakbeteende.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Återgå till föråldrat SameSite-kakbeteende på specifika webbplatser.

##

policy-LocalFileLinks = Tillåt specifika webbplatser att länka till lokala filer.

policy-ManualAppUpdateOnly = Tillåt endast manuella uppdateringar och meddela inte användaren om uppdateringar.

policy-NetworkPrediction = Aktivera eller inaktivera nätverksprediktning (DNS-förhämtning).

policy-OfferToSaveLogins = Tvinga inställningen för att tillåta { -brand-short-name } att erbjuda att komma ihåg sparade inloggningar och lösenord. Både sanna och falska värden accepteras.

policy-OfferToSaveLoginsDefault = Ange standardvärdet för att { -brand-short-name } ska erbjuda att komma ihåg sparade inloggningar och lösenord. Både sanna och falska värden accepteras.

policy-OverrideFirstRunPage = Åsidosätta startsidan. Ställ in den här policyn tom om du vill inaktivera den för startsidan.

policy-OverridePostUpdatePage = Åsidosätta sidan "Vad är nytt" efter uppdateringen. Ställ in denna policy tom om du vill inaktivera sidan efter uppdatering.

policy-PasswordManagerEnabled = Aktivera att spara lösenord i lösenordshanteraren.

# PDF.js and PDF should not be translated
policy-PDFjs = Inaktivera eller konfigurera PDF.js, den inbyggda PDF-visaren i { -brand-short-name }.

policy-Permissions2 = Konfigurera behörigheter för kamera, mikrofon, plats, aviseringar och autoplay.

policy-Preferences = Ställ in och låsa värdet för en delmängd av inställningar.

policy-PrimaryPassword = Kräv eller förhindra användning av ett huvudlösenord.

policy-PromptForDownloadLocation = Fråga var du ska spara filer när du laddar ner.

policy-Proxy = Konfigurera proxyinställningar.

policy-RequestedLocales = Ange listan över begärda språk för programmet efter ordning i inställningar.

policy-SanitizeOnShutdown2 = Rensa navigeringsdata vid avstängning.

policy-SearchEngines = Konfigurera sökmotorinställningar. Denna policy är endast tillgänglig i ESR-versionen (Extended Support Release).

policy-SearchSuggestEnabled = Aktivera eller inaktivera sökförslag.

# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Installera PKCS #11-moduler.

policy-SSLVersionMax = Ange den maximala SSL-versionen.

policy-SSLVersionMin = Ange den minimala SSL-versionen.

policy-SupportMenu = Lägg till ett anpassat supportmenyobjekt till hjälpmenyn.

policy-UserMessaging = Visa inte vissa meddelanden till användaren.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blockera webbplatser från att bli besökta. Se dokumentationen för mer information om formatet.
