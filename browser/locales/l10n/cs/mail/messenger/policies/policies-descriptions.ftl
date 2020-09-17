# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Nastavení pravidel, ke kterým mají přístup rozšíření skrze chrome.storage.managed.
policy-AppUpdateURL = Nastavení vlastní URL pro aktualizace aplikace.
policy-Authentication = Konfigurace integrované autentizace webových stránek, které ji podporují.
policy-BlockAboutAddons = Zablokování přístupu do správce doplňků (about:addons).
policy-BlockAboutConfig = Zablokování přístupu do editoru předvoleb (about:config).
policy-BlockAboutProfiles = Zablokování přístupu do správce profilů (about:profiles).
policy-BlockAboutSupport = Zablokování přístupu na stránku s technickými informacemi (about:support).
policy-CaptivePortal = Povolení nebo zakázání podpory captive portálů.
policy-CertificatesDescription = Přidat certifikáty nebo použít vestavěné certifikáty.
policy-Cookies = Pravidla pro ukládání nebo blokování cookies.
policy-DisabledCiphers = Zakázané metody šifrování.
policy-DefaultDownloadDirectory = Nastavení výchozího adresáře pro stahování souborů.
policy-DisableAppUpdate =
    Blokování aktualizací { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }.
policy-DisableDeveloperTools = Blokování přístupu k nástrojům pro vývojáře.
policy-DisableFeedbackCommands = Blokování odeslání zpětné vazby z nabídky Nápověda (volby Odeslat zpětnou vazbu a Nahlásit klamavou stránku).
policy-DisableForgetButton = Zablokování tlačítka Zapomenout.
policy-DisableMasterPasswordCreation = Hodnota true znemožní nastavení hlavního hesla.
policy-DisableProfileImport = Blokování importu dat z jiných aplikací.
policy-DisableSafeMode = Zablokování možnosti restartovat se zakázanými doplňky. Poznámka: přechod do nouzového režimu podržením klávesy Shift lze zablokovat jen na systému Windows pomocí zásad skupin.
policy-DisableSecurityBypass = Zabránit uživateli obcházení některých bezpečnostních varování.
policy-DisableSystemAddonUpdate =
    Blokování { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "dat") }
        [feminine] { -brand-short-name(case: "dat") }
        [neuter] { -brand-short-name(case: "dat") }
       *[other] aplikaci { -brand-short-name }
    } aktualizovat systémové doplňky.
policy-DisableTelemetry = Vypnutí telemetrie.
policy-DisplayMenuBar = Zobrazení hlavní nabídky ve výchozím nastavení.
policy-DNSOverHTTPS = Nastavení DNS over HTTPS.
policy-DontCheckDefaultClient = Vypnutí kontroly nastavení výchozí aplikace při spuštění.
policy-DownloadDirectory = Nastavení a uzamčení nastavení adresáře pro stahování souborů.
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Zapnutí nebo vypnutí blokování obsahu a případně jeho uzamčení.
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instalace, odinstalace a uzamčení rozšíření. Pro instalaci je potřeba jako parametr zadat URL adresy nebo cesty. Pro odinstalaci nebo uzamčení ID rozšíření.
policy-ExtensionSettings = Správa všech aspektů instalace rozšíření.
policy-ExtensionUpdate = Vypnutí nebo zapnutí automatických aktualizací rozšíření.
policy-HardwareAcceleration = Hodnota false vypne použití hardwarové akcelerace.
policy-InstallAddonsPermission = Povolení instalace doplňků z vybraných webových stránek.

## Do not translate "SameSite", it's the name of a cookie attribute.


##

policy-LocalFileLinks = Povolí vybraným stránkám odkazovat na soubory uložené na místním disku.
policy-NetworkPrediction = Povolení nebo zakázání přednačítání DNS.
policy-OfferToSaveLogins =
    Nastavení dotazu na uložení přihlašovacích údajů v { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "loc") }
        [feminine] { -brand-short-name(case: "loc") }
        [neuter] { -brand-short-name(case: "loc") }
       *[other] aplikaci { -brand-short-name }
    }. Lze použít hodnoty true i false.
policy-OverrideFirstRunPage = Nastavení vlastní stránky při prvním spuštění. Pokud nechcete při prvním spuštění zobrazovat žádnou stránku, nastavte toto pravidlo jako prázdné.
policy-OverridePostUpdatePage = Nastavení vlastní stránky po aktualizaci. Pokud nechcete po aktualizaci zobrazovat žádnou stránku, nastavte toto pravidlo jako prázdné.
policy-Preferences = Nastavení a uzamčení hodnoty pro podmnožinu předvoleb.
policy-PromptForDownloadLocation = Zeptat se na adresář před stažením souboru.
policy-Proxy = Nastavení proxy.
policy-RequestedLocales = Nastavení seznamu požadovaných jazyků pro zobrazení aplikace, v pořadí podle preference.
policy-SanitizeOnShutdown2 = Vymazání dat o prohlížení během vypnutí.
policy-SearchEngines = Nastavení vyhledávačů. Toto pravidlo je dostupné jen pro verzi s rozšířenou podporou (ESR).
# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalace modulů PKCS #11.
policy-SSLVersionMax = Nastavení maximální verze SSL.
policy-SSLVersionMin = Nastavení minimální verze SSL.
policy-SupportMenu = Přidání vlastní položky nabídky s nápovědou.
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blokování návštěvy webových stránek. Více informací o formátu najdete v dokumentaci.
