# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Waterfox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Állítson be házirendeket, amelyeket a WebExtensionök a chrome.storage.managed segítségével érhetnek el.

policy-AllowedDomainsForApps = Adja meg azokat a domaineket, amelyek hozzáférhetnek a Google Workspace-hez.

policy-AppAutoUpdate = Az automatikus alkalmazásfrissítés engedélyezése vagy letiltása.

policy-AppUpdateURL = Egyéni alkalmazás-frissítési URL megadása.

policy-Authentication = Integrált hitelesítés beállítása azokhoz a weboldalakhoz, melyek támogatják.

policy-AutoLaunchProtocolsFromOrigins = Adjon meg egy listát azokról a külső protokollokról, amelyek a felhasználó megkérdezése nélkül használhatók a felsorolt eredetektől.

policy-BackgroundAppUpdate2 = Engedélyezze vagy tiltsa le a háttérfrissítőt.

policy-BlockAboutAddons = Hozzáférés blokkolása a Kiegészítőkezelőhöz (about:addons).

policy-BlockAboutConfig = Hozzáférés blokkolása az about:config oldalhoz.

policy-BlockAboutProfiles = Hozzáférés blokkolása az about:profiles oldalhoz.

policy-BlockAboutSupport = Hozzáférés blokkolása az about:support oldalhoz.

policy-Bookmarks = Könyvjelzők létrehozása a Könyvjelzők eszköztáron, a Könyvjelző menüben vagy az abban megadott mappában.

policy-CaptivePortal = Beléptető oldal támogatás engedélyezése vagy letiltása.

policy-CertificatesDescription = Tanúsítványok hozzáadása vagy beépített tanúsítványok használata.

policy-Cookies = A weboldalak süti elhelyezésének engedélyezése vagy letiltása.

policy-DisabledCiphers = Titkosítási módok letiltása.

policy-DefaultDownloadDirectory = Az alapértelmezett letöltési könyvtár beállítása.

policy-DisableAppUpdate = A böngésző frissítésének megakadályozása.

policy-DisableBuiltinPDFViewer = A PDF.js-nek, a { -brand-short-name } beépített PDF-megjelenítőjének letiltása.

policy-DisableDefaultBrowserAgent = Akadályozza meg, hogy az alapértelmezett böngésző-ügynök bármilyen műveletet végezzen. Csak Windowsra vonatkozik, más platformokon nincs meg ez az ügynök.

policy-DisableDeveloperTools = A fejlesztői eszközökhöz hozzáférés blokkolása.

policy-DisableFeedbackCommands = A visszajelzés küldési parancsok letiltása a Súgó menüben (Visszajelzés beküldése és Félrevezető oldal jelentése).

policy-DisableWaterfoxAccounts = A { -fxaccount-brand-name } alapú szolgáltatások letiltása, beleértve a Syncet.

# Waterfox Screenshots is the name of the feature, and should not be translated.
policy-DisableWaterfoxScreenshots = A Waterfox Screenshots funkció letiltása.

policy-DisableWaterfoxStudies = Annak a megakadályozása, hogy a { -brand-short-name } tanulmányokat futtasson.

policy-DisableForgetButton = Az Elfelejtés gombhoz hozzáférés megakadályozása.

policy-DisableFormHistory = Ne jegyezze meg a keresőmezők és űrlapmezők előzményeit.

policy-DisablePrimaryPasswordCreation = Ha igaz, akkor nem hozható létre elsődleges jelszó.

policy-DisablePasswordReveal = Ne engedje, hogy a mentet bejelentkezésekben szereplő jelszavak megjelenítésre kerüljenek.

policy-DisablePocket = A weboldalak Pocketbe mentését biztosító funkció letiltása.

policy-DisablePrivateBrowsing = Privát böngészés letiltása.

policy-DisableProfileImport = A más böngészőből történő adatimportálás parancsok letiltása.

policy-DisableProfileRefresh = A { -brand-short-name } felfrissítése gomb letiltása az about:support oldalon.

policy-DisableSafeMode = Az Újraindítás letiltott kiegészítőkkel funkció letiltása. Megjegyzés: a kiegészítők nélküli indításhoz használható Shift billentyű csak Windowson tiltható le csoportházirend segítségével.

policy-DisableSecurityBypass = Annak a megakadályozása, hogy a felhasználó átugorjon bizonyos biztonsági figyelmeztetéseket.

policy-DisableSetAsDesktopBackground = A Beállítás háttérképként menüparancs letiltása a képeknél.

policy-DisableSystemAddonUpdate = Annak a megakadályozása, hogy a böngésző rendszer-kiegészítőket telepítsen és frissítsen.

policy-DisableTelemetry = Telemetria kikapcsolása.

policy-DisplayBookmarksToolbar = A Könyvjelző eszköztár megjelenítése alapértelmezetten.

policy-DisplayMenuBar = A Menüsáv megjelenítése alapértelmezetten.

policy-DNSOverHTTPS = HTTPS-en keresztüli DNS beállítása.

policy-DontCheckDefaultBrowser = Az alapértelmezett böngésző ellenőrzés kikapcsolása indításkor.

policy-DownloadDirectory = A letöltési könyvtár beállítása és zárolása.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = A Tartalomblokkolás engedélyezése vagy letiltása, és válaszható módon, annak zárolása.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = A Titkosított médiakiterjesztések engedélyezése vagy letiltása, és válaszható módon, annak zárolása.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Kiegészítők telepítése, eltávolítása vagy zárolása. A Telepítés lehetőség URL-t vagy útvonalat vár paraméterként. Az Eltávolítás és Zárolás kiegészítőazonosítót vár.

policy-ExtensionSettings = Kezelje a kiegészítők telepítésének összes vonatkozását.

policy-ExtensionUpdate = Az automatikus kiegészítőfrissítések engedélyezése vagy letiltása.

policy-WaterfoxHome = A Waterfox kezdőlap beállítása.

policy-FlashPlugin = A Flash bővítmény használatának engedélyezése vagy tiltása.

policy-Handlers = Alapértelmezett alkalmazáskezelők beállítása

policy-HardwareAcceleration = Ha hamis, akkor kikapcsolja a hardveres gyorsítást.

# “lock” means that the user won’t be able to change this setting
policy-Homepage = A kezdőlap beállítása, és választható módon, annak zárolása.

policy-InstallAddonsPermission = Bizonyos weboldalak telepíthetnek kiegészítőket.

policy-LegacyProfiles = A funkció letiltása, amely kikényszeríti, hogy minden telepítés külön profilt használjon

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Az alapértelmezett, örökölt SameSite süti viselkedési beállítás engedélyezése.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = A sütik örökölt SameSite viselkedésének visszaállítása a megadott oldalaknál.

##

policy-LocalFileLinks = Lehetővé teszi, hogy bizonyos webhelyek helyi fájlokra hivatkozzanak.

policy-ManagedBookmarks = Beállítja a rendszergazda által kezelt könyvjelzők listáját, amelyet a felhasználó nem módosíthat.

policy-ManualAppUpdateOnly = Csak a kézi frissítések engedélyezése, és ne értesítse a felhasználót a frissítésekről.

policy-PrimaryPassword = Elsődleges jelszó használatának előírása vagy megakadályozása.

policy-NetworkPrediction = Hálózati előrejelzés engedélyezése vagy letiltása (DNS előhívás).

policy-NewTabPage = Az Új lap oldal engedélyezése vagy letiltása.

policy-NoDefaultBookmarks = A { -brand-short-name }szal szállított alapértelmezett könyvjelzők és okos könyvjelzők (Legtöbbet látogatott, Friss címkék) létrehozásának letiltása. Megjegyzés: ez a házirend csak a profil első futtatása előtt van érvényben.

policy-OfferToSaveLogins = A beállítás erőltetése, miszerint a { -brand-short-name } felajánlja a mentett bejelentkezések és jelszavak megjegyzését. Mind az igaz, mind a hamis érték elfogadott.

policy-OfferToSaveLoginsDefault = Adja meg az alapértelmezett értéket, hogy a { -brand-short-name } felajánlja-e a mentett bejelentkezések és jelszavak megjegyzését. Mind az igaz, mind a hamis érték elfogadott.

policy-OverrideFirstRunPage = Az első indítás oldal felülbírálása. Állítsa üres értékre ezt a házirendet, ha le akarja tiltani a az első indítás oldalt.

policy-OverridePostUpdatePage = A frissítés utáni „Újdonságok” oldal felülbírálása. Állítsa üres ezt a házirendet, ha azt szeretné, hogy ne legyen frissítés utáni oldal.

policy-PasswordManagerEnabled = A jelszavak jelszókezelőbe történő mentésének engedélyezése.

# PDF.js and PDF should not be translated
policy-PDFjs = A PDF.js-nek, a { -brand-short-name } beépített PDF-megjelenítőjének, letiltása vagy beállítása.

policy-Permissions2 = A kamera, mikrofon, helyadatok, értesítések és automatikus lejátszás jogosultságának beállítása.

policy-PictureInPicture = Kép a képben engedélyezése vagy letiltása.

policy-PopupBlocking = Bizonyos weboldalak alapértelmezetten jeleníthessenek meg felugró ablakokat.

policy-Preferences = Értékek beállítása és zárolása a beállítások egy részhalmazánál.

policy-PromptForDownloadLocation = Kérdezze meg, hogy hová legyenek letöltve a fájlok.

policy-Proxy = Proxy-beállítások konfigurálása.

policy-RequestedLocales = Adja meg a kért területi beállításokat az alkalmazásnak, az Ön által előnyben részesített sorrendben.

policy-SanitizeOnShutdown2 = Navigációs adatok törlése leállításkor.

policy-SearchBar = A keresősáv alapértelmezett helyének megadása. A felhasználó továbbra is testreszabhatja.

policy-SearchEngines = Keresőszolgáltatások beállításainak konfigurálása. Ez a házirend csak a kibővített támogatású kiadásban (ESR) érhető el.

policy-SearchSuggestEnabled = A keresési javaslatok engedélyezése vagy letiltása.

# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = PKCS #11 modulok telepítése.

policy-ShowHomeButton = A kezdőoldal gomb megjelenítése az eszköztáron.

policy-SSLVersionMax = A legmagasabb SSL verzió beállítása.

policy-SSLVersionMin = A legkisebb SSL verzió beállítása.

policy-SupportMenu = Egyéni támogatási menüpont hozzáadása a súgó menühöz.

policy-UserMessaging = Ne mutasson bizonyos üzeneteket a felhasználónak.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Weboldalak felkeresésének blokkolása. Lásd a dokumentációt a formátum részleteiért.

policy-Windows10SSO = Lehetővé teszi a Windows egyszeri bejelentkezésének használatát a microsoftos, munkahelyi és iskolai fiókok számára.
