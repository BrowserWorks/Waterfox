# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Indstil politikker, som WebExtensions kan tilgå via chrome.storage.managed.
policy-AllowedDomainsForApps = Angiv domæner, der har tilladelse til at tilgå Google Workspace.
policy-AppAutoUpdate = Slå automatisk opdatering af programmet til eller fra.
policy-AppUpdateURL = Indstil tilpasset URL for app-opdateringer
policy-Authentication = Indstil integreret godkendelse for websteder, der understøtter det
policy-AutoLaunchProtocolsFromOrigins = Angiv en liste med eksterne protokoller, der kan anvendes fra specificerede kilder uden at spørge brugeren.
policy-BackgroundAppUpdate2 = Slå opdatering i baggrund til og fra.
policy-BlockAboutAddons = Bloker adgang til fanebladet Tilføjelser (about:addons).
policy-BlockAboutConfig = Bloker adgang til about:config.
policy-BlockAboutProfiles = Bloker adgang til about:profiles.
policy-BlockAboutSupport = Bloker adgang til about:support.
policy-Bookmarks = Opret bogmærker i Bogmærkelinjen, i menuen Bogmærker eller en nærmere angivet mappe i dem.
policy-CaptivePortal = Slå understøttelse af captive portal til eller fra.
policy-CertificatesDescription = Tilføj certifikater eller brug indbyggede certifikater.
policy-Cookies = Tillad eller nægt websteder at sætte cookies.
policy-DisabledCiphers = Deaktiver ciphers.
policy-DefaultDownloadDirectory = Indstil standard-mappe for hentede filer.
policy-DisableAppUpdate = Deaktiver opdatering af browseren.
policy-DisableBuiltinPDFViewer = Deaktiver PDF.js, den indbyggede PDF-viser i { -brand-short-name }.
policy-DisableDefaultBrowserAgent = Tillad ikke at standard browser-agenten foretager handlinger. Fungerer kun på Windows; andre platforme har ikke agenten.
policy-DisableDeveloperTools = Bloker adgang til Udviklerværktøj.
policy-DisableFeedbackCommands = Deaktiver kommandoer til at indsende feedback fra menuen Hjælp (Indsend feedback og Anmeld vildledende websted).
policy-DisableFirefoxAccounts = Deaktiver tjenester baseret på { -fxaccount-brand-name }, inklusive Sync.
# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Deaktiver funktionen Firefox Screenshots
policy-DisableFirefoxStudies = Deaktiver afvikling af { -brand-short-name }-undersøgelser.
policy-DisableForgetButton = Bloker adgang til knappen Glem.
policy-DisableFormHistory = Husk ikke formular- og søgehistorik.
policy-DisableMasterPasswordCreation = En hovedadgangskode kan ikke oprettes, hvis sat til true.
policy-DisablePrimaryPasswordCreation = En hovedadgangskode kan ikke oprettes, hvis værdien er sat til true.
policy-DisablePasswordReveal = Tillad ikke adgangskoder at blive vist i gemte logins.
policy-DisablePocket = Deaktiver funktionen at gemme websider til Pocket.
policy-DisablePrivateBrowsing = Deaktiver privat browsing.
policy-DisableProfileImport = Deaktiver menu-kommandoen til at importere data fra en anden browser.
policy-DisableProfileRefresh = Deaktiver knappen Nulstil { -brand-short-name } på siden about:support.
policy-DisableSafeMode = Deaktiver funktionen til at genstarte i fejlsikret tilstand. NB: Deaktivering af tasten Skift til at starte fejlsikret tilstand kan kun gennemføres i Windows via Gruppepolitik.
policy-DisableSecurityBypass = Deaktiver brugerens mulighed for at omgå bestemte sikkerhedsadvarsler
policy-DisableSetAsDesktopBackground = Deaktiver menu-kommandoen Brug som skrivebordsbaggrund
policy-DisableSystemAddonUpdate = Deaktiver browserens mulighed for at installere og opdatere system-tilføjelser.
policy-DisableTelemetry = Slå Telemetry fra.
policy-DisplayBookmarksToolbar = Vis bogmærkelinjen som standard.
policy-DisplayMenuBar = Vis menulinjen som standard.
policy-DNSOverHTTPS = Opsæt DNS via HTTPS.
policy-DontCheckDefaultBrowser = Deaktiver check om standard-browser ved opstart.
policy-DownloadDirectory = Indstil og lås valg af mappe til filhentninger.
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Slå Blokering af indhold til eller fra. Brugeren kan eventuelt forhindres i at ændre indstillingen.
# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Slå Encrypted Media Extensions til eller fra. Brugeren kan eventuelt forhindres i at ændre indstillingen.
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Installer, afinstaller eller lås udvidelser. Valgmuligheden Installer tager URL’er eller stier som parametre. Valgmulighederne Afinstaller og Låst tager udvidelelses-ID som parameter.
policy-ExtensionSettings = Håndter alle aspekter af udvidelses-installering.
policy-ExtensionUpdate = Slå automatisk opdatering af udvidelser til eller fra.
policy-FirefoxHome = Indstil Firefox' startside.
policy-FlashPlugin = Tillad eller afvis brug af Flash-plugin.
policy-Handlers = Indstil håndtering af standard-applikationer.
policy-HardwareAcceleration = False slår hardware-acceleration fra.
# “lock” means that the user won’t be able to change this setting
policy-Homepage = Indstil og lås eventuelt startsiden.
policy-InstallAddonsPermission = Tillad bestemte websteder at installere tilføjelser.
policy-LegacyProfiles = Deaktiver funktionen, der gennemtvinger at hver installation har en separat profil.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Aktiver standard-indstilling for forældet SameSite-opførsel.
policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Gå tilbage til forældet SameSite-opførsel for cookies på bestemte websteder.

##

policy-LocalFileLinks = Tillad specifikke websteder at linke til lokale filer.
policy-ManagedBookmarks = Indstiller en liste med bogmærker, der håndteres af en administrator, og som ikke kan ændres af brugeren.
policy-MasterPassword = Kræv eller deaktiver brug af hovedadgangskode.
policy-ManualAppUpdateOnly = Tillad kun manuelle opdateringer, og giv ikke brugeren besked om opdateringer.
policy-PrimaryPassword = Kræv eller forhindr brugen af en hovedadgangskode.
policy-NetworkPrediction = Slå network prediction (DNS prefetching) til eller fra.
policy-NewTabPage = Slå siden Nyt faneblad til eller fra.
policy-NoDefaultBookmarks = Deaktiver oprettelse af standard-bogmærker, der følger med { -brand-short-name }, samt de smarte bogmærker (Mest besøgte, Seneste mærkater). NB: Denne politik virker kun, hvis den aktiveres før profilen anvendes første gang.
policy-OfferToSaveLogins = Indstil om { -brand-short-name } skal tilbyde at huske gemte logins og adgangskoder. Vælg true, hvis { -brand-short-name } skal tilbyde at huske logins og adgangskoder, ellers vælg false.
policy-OfferToSaveLoginsDefault = Vælg om { -brand-short-name } skal tilbyde at huske logins og adgangskoder. Vælg true, hvis { -brand-short-name } skal tilbyde at huske logins og adgangskoder, ellers vælg false.
policy-OverrideFirstRunPage = Erstat siden, der vises ved første opstart. Lad politikken være tom, hvis siden ved første opstart skal deaktiveres.
policy-OverridePostUpdatePage = Erstat siden Nyheder, der vises efter opdatering. Lad politikken være tom, hvis siden efter opdatering skal deaktiveres.
policy-PasswordManagerEnabled = Tillad at brugeren kan gemme adgangskoder i Adgangskode-håndteringen.
# PDF.js and PDF should not be translated
policy-PDFjs = Deaktiver eller konfigurer PDF.js, den indbyggede PDF-læser i { -brand-short-name }.
policy-Permissions2 = Indstil tilladelser for kamera, mikrofon, position, beskeder og automatisk afspilning.
policy-PictureInPicture = Slå Billede-i-billede til eller fra.
policy-PopupBlocking = Tillad bestemte websteder at vise pop op-vinduer som standard.
policy-Preferences = Indstil og lås værdien for en undergruppe af indstillingerne.
policy-PromptForDownloadLocation = Spørg hvor hentede filer skal gemmes.
policy-Proxy = Opsæt proxy-indstillinger.
policy-RequestedLocales = Vælg rækkefølgen af sprog, der skal anvendes i programmet.
policy-SanitizeOnShutdown2 = Ryd browsing-data ved lukning.
policy-SearchBar = Indstil standard-placering af søgefeltet. Brugeren kan stadig tilpasse feltet.
policy-SearchEngines = Opsæt indstillinger for søgetjenester. Denne politik er kun tilgængelig for Extended Support Release (ESR).
policy-SearchSuggestEnabled = Slå søgeforslag til eller fra.
# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Installer PKCS #11 moduler.
policy-ShowHomeButton = Vis hjem-knappen på værktøjslinjen.
policy-SSLVersionMax = Angiv den højeste SSL-version.
policy-SSLVersionMin = Angiv den laveste SSL-version.
policy-SupportMenu = Føj et tilpasset menupunkt til menuen Hjælp.
policy-UserMessaging = Vis ikke bestemte beskeder til brugeren.
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Bloker websteder fra at blive besøgt. Se dokumentationen for detaljer om formatet.
