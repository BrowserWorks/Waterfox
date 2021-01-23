# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Prawidła nastajić, na kotrež WebExtensions přez chrome.storage.managed přistup maja.

policy-AppAutoUpdate = Awtomatiske aktualizacije nałoženjow zmóžnić abo znjemóžnić.

policy-AppUpdateURL = Nastajće swójski URL za aktualizowanje nałoženjow.

policy-Authentication = Konfigurujće integrowanu awtentifikaciju za websydła, kotrež ju podpěruja.

policy-BlockAboutAddons = Přistup na zrjadowak přidatkow (about:addons) blokować.

policy-BlockAboutConfig = Přistup na stronu about:config blokować.

policy-BlockAboutProfiles = Přistup na stronu about:profiles blokować.

policy-BlockAboutSupport = Přistup na stronu about:support blokować.

policy-CaptivePortal = Podpěru za předstrony zmóžnić abo znjemóžnić.

policy-CertificatesDescription = Certifikaty přidać abo zatwarjene certifikaty wužiwać.

policy-Cookies = Websydłam dowolić abo zakazać, placki nastajić.

policy-DisabledCiphers = Šifry znjemóžnić.

policy-DefaultDownloadDirectory = Standardny sćehnjenski zapis nastajić.

policy-DisableAppUpdate = { -brand-short-name } při aktualizowanju haćić.

policy-DisableDefaultClientAgent = Haćće standardny klientowy agent při wuwjedźenju akcijow. To je jenoz za Windows k dispoziciji; druhe platformy agent nimaja.

policy-DisableDeveloperTools = Přistup na wuwiwarske nastroje blokować.

policy-DisableFeedbackCommands = Přikazy znjemóžnić, kotrež komentary z menija Pomoc sćelu (Posudk pósłać a Wobšudne sydło zdźělić)

policy-DisableForgetButton = Přistupej na tłóčatko Zabyć zadźěwać.

policy-DisableFormHistory = Pytansku a formularnu historiju sej njespomjatkować

policy-DisableMasterPasswordCreation = Jeli to trjechi, njeda so hłowne hesło wutworić.

policy-DisablePasswordReveal = Njedowolić, zo so hesła w składowanych přizjewjenjach pokazuja

policy-DisableProfileImport = Menijowy přikaz za importowanje datow z druheho nałoženja znjemóžnić.

policy-DisableSafeMode = Funkciju za znowastartowanje we wěstym modusu znjemóžnić. Kedźbu: Tasta Umsch, z kotrejž k wěstemu modusej přeńdźeće, da so jenož pod Windowsom z pomocu skupinskich prawidłow znjemóžnić.

policy-DisableSecurityBypass = Wužiwarja při wobeńdźenju wěstych wěstotnych warnowanjow haćić.

policy-DisableSystemAddonUpdate = { -brand-short-name } při instalowanju a aktualizowanju systemowych přidatkow haćić.

policy-DisableTelemetry = Telemetriju znjemóžnić.

policy-DisplayMenuBar = Menijowu lajstu po standardźe pokazać.

policy-DNSOverHTTPS = DNS přez HTTPS konfigurować.

policy-DontCheckDefaultClient = Přepruwowanje za standardnym programom při starće znjemóžnić.

policy-DownloadDirectory = Sćehnjenski zapis nastajić a zawrěć.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Blokowanje wobsaha zmóžnić abo znjemóžnić a na přeco zawrěć.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Encrypted Media Extensions zmóžnić abo znjemóžnić a je na přeće zawrěć.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Rozšěrjenja instalować, wotinstalować abo zawrěć. Instalaciska opcija ma URL abo šćežki jako parametry. Opciji Wotinstalować a Zawrěć ID wužiwatej.

policy-ExtensionSettings = Wšě aspekty instalacije rozšěrjenja rjadować.

policy-ExtensionUpdate = Awtomatiske aktualizacije rozšěrjenjow zmóžnić abo znjemóžnić.

policy-HardwareAcceleration = Jeli false, hardwarowe pospěšenje wupinać.

policy-InstallAddonsPermission = Wěstym websydłam dowolić, přidatki instalować.

policy-LegacyProfiles = Funkciju znjemóžnić, kotraž separatny profil za kóždu instalaciju wunuzuje.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Standardne zestarjene nastajenje za zadźerženje plackoweho atributa SameSite zmóžnić.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Zestarjene zadźerženje atributa SameSite za placki na wěstych sydłach wužiwać

##

policy-LocalFileLinks = Wěstym websydłam dowolić, na lokalne dataje wotskazać.

policy-NetworkPrediction = Syćowe předzačitanje (DNS-předzačitanje) zmóžnić abo znjemóžnić.

policy-OfferToSaveLogins = Nastajenje wunuzować, kotrež { -brand-short-name } zmóžnja, sej składowane přizjewjenja a hesła spomjatkować. True kaž tež false so akceptujetej.

policy-OfferToSaveLoginsDefault = Stajće standardnu hódnotu, kotraž { -brand-short-name } zmóžnja, sej składowane přizjewjenja a hesła spomjatkować. True kaž tež false so akceptujetej.

policy-OverrideFirstRunPage = Stronu přepisać, kotraž so při prěnim starće jewi. Stajće tute prawidło na prózdne, jeli chceće tutu stronu znjemóžnić.

policy-OverridePostUpdatePage = Stronu „Nowe funkcije a změny“ po aktualizaciji přepisać. Stajće tute prawidło na prózdne, jeli chceće tutu stronu znjemóžnić.

policy-PasswordManagerEnabled = Składowanje hesłow do zrjadowaka hesłow zmóžnić.

# PDF.js and PDF should not be translated
policy-PDFjs = PDF.js znjemóžnić abo konfigurować, zatwarjeny PDF-wobhladowak w { -brand-short-name }.

policy-Permissions2 = Prawa za kameru, mikrofon, adresu, zdźělenki a awtomatiske wothraće konfigurować.

policy-Preferences = Nastajće a zawrějće hódnotu za podsadźbu nastajenjow.

policy-PromptForDownloadLocation = Prašeć so, hdźež maja so dataja při sćehnjenju składować.

policy-Proxy = Proksynastajenja konfigurować.

policy-RequestedLocales = Podajće lisćinu požadanych rěčow za nałoženje w preferowanym porjedźe.

policy-SanitizeOnShutdown2 = Nawigaciske daty při kónčenju zhašeć.

policy-SearchEngines = Nastajenja pytawow konfigurować. Tute prawidło je jenož za wersiju Extended Support Release (ESR) k dispoziciji.

policy-SearchSuggestEnabled = Pytanske namjety zmóžnić abo znjemóžnić.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Module PKCS #11 instalować.

policy-SSLVersionMax = Maksimalnu SSL-wersiju nastajić.

policy-SSLVersionMin = Minimalnu SSL-wersiju nastajić.

policy-SupportMenu = Přidajće menijej pomocy swójski zapisk menija pomocy.

policy-UserMessaging = Wužiwarjej wěste powěsće njepokazać

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Wopytowanju websydłow zadźěwać. Hlejće dokumentaciju za dalše podrobnosće wo formaće.
