# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Waterfox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Nastavení pravidel, ke kterým mají přístup rozšíření skrze chrome.storage.managed.

policy-AllowedDomainsForApps = Nastavení domén, které mají povolený přístup ke Google Workspace.

policy-AppAutoUpdate = Vypnutí nebo zapnutí automatických aktualizací aplikace.

policy-AppUpdateURL = Nastavení vlastní URL pro aktualizace aplikace.

policy-Authentication = Konfigurace integrované autentizace webových stránek, které ji podporují.

policy-AutoLaunchProtocolsFromOrigins = Seznam externích protokolů, které lze použít z uvedených originů bez varování uživatele.

policy-BackgroundAppUpdate2 = Povolení nebo zákaz aktualizací na pozadí.

policy-BlockAboutAddons = Zablokování přístupu do správce doplňků (about:addons).

policy-BlockAboutConfig = Zablokování přístupu do editoru předvoleb (about:config).

policy-BlockAboutProfiles = Zablokování přístupu do správce profilů (about:profiles).

policy-BlockAboutSupport = Zablokování přístupu na stránku s technickými informacemi (about:support).

policy-Bookmarks = Vytvoření záložek na liště, v nabídce nebo vybrané složce.

policy-CaptivePortal = Povolení nebo zakázání podpory captive portálů.

policy-CertificatesDescription = Přidat certifikáty nebo použít vestavěné certifikáty.

policy-Cookies = Pravidla pro ukládání nebo blokování cookies.

policy-DisabledCiphers = Zakázané metody šifrování.

policy-DefaultDownloadDirectory = Nastavení výchozího adresáře pro stahování souborů.

policy-DisableAppUpdate = Blokování aktualizací prohlížeče.

policy-DisableBuiltinPDFViewer =
    Zablokování PDF prohlížeče PDF.js vestavěného { -brand-short-name.gender ->
        [masculine] ve { -brand-short-name(case: "loc") }
        [feminine] v { -brand-short-name(case: "loc") }
        [neuter] v { -brand-short-name(case: "loc") }
       *[other] v aplikaci { -brand-short-name }
    }.

policy-DisableDefaultBrowserAgent = Zabraňuje „výchozímu agentovi prohlížeče“ provádět jakékoliv akce. Dostupné pouze pro Windows, ostatní platformy agenty nemají.

policy-DisableDeveloperTools = Blokování přístupu k nástrojům pro vývojáře.

policy-DisableFeedbackCommands = Blokování odeslání zpětné vazby z nabídky Nápověda (volby Odeslat zpětnou vazbu a Nahlásit klamavou stránku).

policy-DisableWaterfoxAccounts = Vypnutí služeb používajících { -fxaccount-brand-name(case: "acc", capitalization: "lower") }, včetně Syncu.

# Waterfox Screenshots is the name of the feature, and should not be translated.
policy-DisableWaterfoxScreenshots = Vypnutí funkce Waterfox Screenshots.

policy-DisableWaterfoxStudies =
    Zablokování spouštění studií { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }.

policy-DisableForgetButton = Zablokování tlačítka Zapomenout.

policy-DisableFormHistory = Vypnutí ukládání historie vyhledávání a formulářů.

policy-DisablePrimaryPasswordCreation = Hodnota true znemožní nastavení hlavního hesla.

policy-DisablePasswordReveal = Zakázání možnosti zobrazit hesla ve správci přihlašovacích údajů.

policy-DisablePocket = Vypnutí funkce pro ukládání stránek do služby Pocket.

policy-DisablePrivateBrowsing = Zablokování anonymního prohlížení.

policy-DisableProfileImport = Blokování importu dat z jiných prohlížečů.

policy-DisableProfileRefresh =
    Blokování tlačítka pro obnovu { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } na stránce about:support.

policy-DisableSafeMode = Zablokování možnosti restartovat se zakázanými doplňky. Poznámka: přechod do nouzového režimu podržením klávesy Shift lze zablokovat jen na systému Windows pomocí zásad skupin.

policy-DisableSecurityBypass = Zabránit uživateli obcházení některých bezpečnostních varování.

policy-DisableSetAsDesktopBackground = Zablokování kontextové nabídky obrázků pro jejich nastavení jako pozadí plochy.

policy-DisableSystemAddonUpdate = Zablokování instalace a aktualizací systémových doplňků prohlížeče.

policy-DisableTelemetry = Vypnutí telemetrie.

policy-DisplayBookmarksToolbar = Zobrazení lišty záložek ve výchozím nastavení.

policy-DisplayMenuBar = Zobrazení hlavní nabídky ve výchozím nastavení.

policy-DNSOverHTTPS = Nastavení DNS over HTTPS.

policy-DontCheckDefaultBrowser = Vypnutí kontroly nastavení výchozího prohlížeče při spuštění.

policy-DownloadDirectory = Nastavení a uzamčení nastavení adresáře pro stahování souborů.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Zapnutí nebo vypnutí blokování obsahu a případně jeho uzamčení.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Zapnutí nebo vypnutí Encrypted Media Extensions a případně uzamčení tohoto nastavení.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instalace, odinstalace a uzamčení rozšíření. Pro instalaci je potřeba jako parametr zadat URL adresy nebo cesty. Pro odinstalaci nebo uzamčení ID rozšíření.

policy-ExtensionSettings = Správa všech aspektů instalace rozšíření.

policy-ExtensionUpdate = Vypnutí nebo zapnutí automatických aktualizací rozšíření.

policy-WaterfoxHome = Nastavení domovské stránky prohlížeče.

policy-FlashPlugin = Povolení nebo zablokování zásuvného modulu Flash.

policy-Handlers = Nastavení výchozích aplikací pro odkazy a typy souborů.

policy-HardwareAcceleration = Hodnota false vypne použití hardwarové akcelerace.

# “lock” means that the user won’t be able to change this setting
policy-Homepage = Nastavení a případné uzamčení domovské stránky.

policy-InstallAddonsPermission = Povolení instalace doplňků z vybraných webových stránek.

policy-LegacyProfiles = Vypnutí funkce vynucující samostatný profil pro každou instalaci aplikace.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Povoluje staré výchozí nastavení chování SameSite cookies.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Nastaví staré výchozí chování SameSite cookies z uvedených serverů.

##

policy-LocalFileLinks = Povolí vybraným stránkám odkazovat na soubory uložené na místním disku.

policy-ManagedBookmarks = Nastavení seznamu záložek spravovaných správcem. Takové záložky uživatel nemůže měnit.

policy-ManualAppUpdateOnly = Povolit pouze ruční aktualizace a uživatele na dostupnost aktualizací neupozorňovat.

policy-PrimaryPassword = Vyžadovat nebo zabránit používání hlavního hesla.

policy-NetworkPrediction = Povolení nebo zakázání přednačítání DNS.

policy-NewTabPage = Povolení nebo zákaz stránky nového panelu.

policy-NoDefaultBookmarks =
    Vypnutí vytváření výchozích záložek a chytrých záložek { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } (Nejnavštěvovanější, Poslední štítky). Poznámka: toto pravidlo se uplatní jen pokud bude nastaveno před prvním spuštěním.

policy-OfferToSaveLogins =
    Nastavení dotazu na uložení přihlašovacích údajů { -brand-short-name.gender ->
        [masculine] ve { -brand-short-name(case: "loc") }
        [feminine] v { -brand-short-name(case: "loc") }
        [neuter] v { -brand-short-name(case: "loc") }
       *[other] v aplikaci { -brand-short-name }
    }. Lze použít hodnoty true i false.

policy-OfferToSaveLoginsDefault = Nastavení výchozí hodnoty pro to, zda má { -brand-short-name } nabízet ukládání přihlašovacích údajů. Platné hodnoty jsou true a false.

policy-OverrideFirstRunPage = Nastavení vlastní stránky při prvním spuštění. Pokud nechcete při prvním spuštění zobrazovat žádnou stránku, nastavte toto pravidlo jako prázdné.

policy-OverridePostUpdatePage = Nastavení vlastní stránky po aktualizaci. Pokud nechcete po aktualizaci zobrazovat žádnou stránku, nastavte toto pravidlo jako prázdné.

policy-PasswordManagerEnabled = Povolení ukládat přihlašovací údaje do správce hesel.

# PDF.js and PDF should not be translated
policy-PDFjs =
    Zablokování nebo nastavení PDF prohlížeče PDF.js vestavěného { -brand-short-name.gender ->
        [masculine] ve { -brand-short-name(case: "loc") }
        [feminine] v { -brand-short-name(case: "loc") }
        [neuter] v { -brand-short-name(case: "loc") }
       *[other] v aplikaci { -brand-short-name }
    }.

policy-Permissions2 = Nastavení oprávnění pro kameru, mikrofon, zjišťování polohy, oznámení a automatické přehrávání.

policy-PictureInPicture = Povolení nebo zakázání režimu obraz v obraze.

policy-PopupBlocking = Povolení zobrazování vyskakovacích oken ve výchozím stavu.

policy-Preferences = Nastavení a uzamčení hodnoty pro podmnožinu předvoleb.

policy-PromptForDownloadLocation = Zeptat se na adresář před stažením souboru.

policy-Proxy = Nastavení proxy.

policy-RequestedLocales = Nastavení seznamu požadovaných jazyků pro zobrazení aplikace, v pořadí podle preference.

policy-SanitizeOnShutdown2 = Vymazání dat o prohlížení během vypnutí.

policy-SearchBar = Nastavení výchozího umístění vyhledávacího pole. Uživatel ho může přemístit.

policy-SearchEngines = Nastavení vyhledávačů. Toto pravidlo je dostupné jen pro verzi s rozšířenou podporou (ESR).

policy-SearchSuggestEnabled = Povolení nebo zákaz našeptávání dotazů pro vyhledávač.

# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalace modulů PKCS #11.

policy-ShowHomeButton = Zobrazení domovského tlačítka na liště.

policy-SSLVersionMax = Nastavení maximální verze SSL.

policy-SSLVersionMin = Nastavení minimální verze SSL.

policy-SupportMenu = Přidání vlastní položky nabídky s nápovědou.

policy-UserMessaging = Nezobrazovat uživateli určité zprávy.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blokování návštěvy webových stránek. Více informací o formátu najdete v dokumentaci.

policy-Windows10SSO = Povolení jednotného přihlašování Windows pro pracovní a školní účty a účty Microsoft.
