# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Nastaví, ku ktorým pravidlám majú prístup rozšírenia cez chrome.storage.managed.

policy-AppAutoUpdate = Zapne alebo vypne automatické aktualizácie aplikácie.

policy-AppUpdateURL = Nastaví vlastnú URL adresu pre aktualizáciu aplikácie.

policy-Authentication = Nakonfiguruje integrovanú autentifikáciu webových stránok, ktoré ju podporujú.

policy-BlockAboutAddons = Zablokuje prístup ku správcovi doplnkov (about:addons).

policy-BlockAboutConfig = Zablokuje prístup na stránku about:config.

policy-BlockAboutProfiles = Zablokuje prístup na stránku about:profiles.

policy-BlockAboutSupport = Zablokuje prístup na stránku about:support.

policy-CaptivePortal = Povolenie alebo zakázanie podpory pre captive portály.

policy-CertificatesDescription = Pridá certifikáty alebo použije zabudované certifikáty.

policy-Cookies = Povolí alebo zakáže webovým stránkam nastavovať cookies.

policy-DisabledCiphers = Zakáže šifry.

policy-DefaultDownloadDirectory = Nastaví predvolené umiestnenie pre preberanie súborov.

policy-DisableAppUpdate = Zabráni aktualizáciám aplikácie { -brand-short-name }.

policy-DisableDeveloperTools = Zablokuje prístup k vývojárskym nástrojom.

policy-DisableFeedbackCommands = Zablokuje možnosť odoslať spätnú väzbu z ponuky Pomocník (možnosti Odoslať spätnú väzbu a Nahlásenie podvodnej stránky).

policy-DisableForgetButton = Zablokuje prístup ku tlačidlu Zabudnúť.

policy-DisableFormHistory = Vypne ukladanie histórie vyhľadávania a formulárov.

policy-DisableMasterPasswordCreation = Hodnota true znemožní nastavenie hlavného hesla.

policy-DisablePasswordReveal = Zablokuje zobrazovanie hesiel v správcovi prihlasovacích údajov.

policy-DisableProfileImport = Zablokuje možnosť importu údajov z iných aplikácií.

policy-DisableSafeMode = Zablokuje funkciu reštartu so zakázanými doplnkami. Poznámka: prechod do núdzového režimu podržaním klávesy Shift je v systéme Windows možné len pomocou skupinovej politiky.

policy-DisableSecurityBypass = Zabráni používateľovi v obchádzaní niektorých bezpečnostných varovaní.

policy-DisableSystemAddonUpdate = Zablokuje inštaláciu a aktualizáciu systémových doplnkov aplikácie { -brand-short-name }.

policy-DisableTelemetry = Vypne telemetriu.

policy-DisplayMenuBar = Zobrazí hlavnú ponuku v predvolenom nastavení.

policy-DNSOverHTTPS = Nastavenie DNS cez HTTPS.

policy-DontCheckDefaultClient = Vypne kontrolu predvoleného klienta pri spustení.

policy-DownloadDirectory = Nastaví a uzamkne umiestnenie pre preberanie súborov.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Zapne alebo vypne blokovanie obsahu a prípadne túto funkciu uzamkne.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Zapne alebo vypne Encrypted Media Extensions a prípadne uzamkne toto nastavenie.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Nainštaluje, odinštaluje alebo uzamkne rozšírenie. Pre inštaláciu je potrebné ako parameter zadať URL adresy alebo cesty. Pre odinštaláciu alebo uzamknutie je potrebné ID rozšírenia.

policy-ExtensionSettings = Spravuje všetky aspekty inštalácie rozšírenia.

policy-ExtensionUpdate = Zapne alebo vypne automatické aktualizácie rozšírení.

policy-HardwareAcceleration = Ak je nastavená hodnota false, vypne hardvérové urýchľovanie.

policy-InstallAddonsPermission = Povolí určitým webovým stránkam inštalovať doplnky.

policy-LegacyProfiles = Vypne funkciu, ktorá vynucuje samostatný profil pre každú inštaláciu aplikácie.

## Do not translate "SameSite", it's the name of a cookie attribute.


##

policy-LocalFileLinks = Povolí určitým webovým stránkam odkazovať na súbory uložené na pevnom disku.

policy-NetworkPrediction = Povolí alebo zakáže prednačítavanie DNS (prefetching).

policy-OfferToSaveLogins = Nastaví pravidlo na uloženie prihlasovacích údajov v aplikácii { -brand-short-name }. Je možné použiť hodnoty true aj false.

policy-OfferToSaveLoginsDefault = Nastaví predvolenú hodnotu, či má { -brand-short-name } ponúkať ukladanie prihlasovacích údajov. Platné hodnoty sú true a false.

policy-OverrideFirstRunPage = Nastaví vlastnú stránku pri prvom spustení. Ak nechcete pri prvom spustení zobrazovať žiadnu stránku, nastavte toto pravidlo ako prázdne.

policy-OverridePostUpdatePage = Nastaví vlastnú stránku po aktualizácii aplikácie. Ak nechcete po aktualizácii zobrazovať žiadnu stránku, nastavte toto pravidlo ako prázdne.

policy-PasswordManagerEnabled = Povolí ukladanie hesiel do správcu hesiel.

# PDF.js and PDF should not be translated
policy-PDFjs = Zablokuje alebo nakonfiguruje PDF prehliadač PDF.js zabudovaný v aplikácii { -brand-short-name }.

policy-Permissions2 = Nastaví povolenia pre kameru, mikrofón, polohu, upozornenia a automatické prehrávanie.

policy-Preferences = Nastaví a uzamkne hodnotu pre podmnožinu predvolieb.

policy-PromptForDownloadLocation = Spýta sa na umiestnenie súboru pred jeho prevzatím.

policy-Proxy = Nakonfiguruje nastavenia proxy.

policy-RequestedLocales = Nastaví zoznam požadovaných jazykov aplikácie, v poradí podľa nastavenej priority.

policy-SanitizeOnShutdown2 = Vymaže všetky údaje o prehliadaní v priebehu vypnutia.

policy-SearchEngines = Nakonfiguruje nastavenie vyhľadávacích modulov. Toto pravidlo je dostupné len vo verzii s rozšírenou podporou (ESR).

policy-SearchSuggestEnabled = Povolí alebo zakáže návrhy vyhľadávania.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Nainštaluje moduly PKCS #11.

policy-SSLVersionMax = Nastaví maximálnu verziu SSL.

policy-SSLVersionMin = Nastaví minimálnu verziu SSL.

policy-SupportMenu = Pridá vlastnú položku do ponuky pomocníka.

policy-UserMessaging = Používateľovi sa nebudú zobrazovať určité oznámenia.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Zablokuje prístup na určité webové stránky. Ďalšie informácie o formáte nájdete v dokumentácii.
