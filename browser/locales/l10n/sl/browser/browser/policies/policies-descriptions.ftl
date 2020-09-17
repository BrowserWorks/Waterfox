# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Nastavi, do katerih pravilnikov lahko dostopajo razširitve WebExtensions preko chrome.storage.managed.

policy-AppAutoUpdate = Omogoči ali onemogoči samodejne posodobitve programa.

policy-AppUpdateURL = Nastavi poljuben URL za posodobitve programa.

policy-Authentication = Nastavi integrirano overjanje za spletne strani, ki ga podpirajo.

policy-BlockAboutAddons = Zavrni dostop do upravitelja dodatkov (about:addons).

policy-BlockAboutConfig = Zavrni dostop do strani about:config.

policy-BlockAboutProfiles = Zavrni dostop do strani about:profiles.

policy-BlockAboutSupport = Zavrni dostop do strani about:support.

policy-Bookmarks = Ustvarjaj zaznamke v orodni vrstici, meniju zaznamkov ali v določeni mapi.

policy-CaptivePortal = Omogoči ali onemogoči podporo za prestrezni portal.

policy-CertificatesDescription = Dodaj digitalna potrdila ali uporabi vgrajena potrdila.

policy-Cookies = Spletnim stranem dovoli ali zavrni nastavljanje piškotkov.

policy-DisabledCiphers = Onemogoči šifre.

policy-DefaultDownloadDirectory = Nastavi privzeto mapo za prenose.

policy-DisableAppUpdate = Prepreči posodabljanje brskalnika.

policy-DisableBuiltinPDFViewer = Onemogoči PDF.js, pregledovalnik PDF brskalnika { -brand-short-name }.

policy-DisableDefaultBrowserAgent = Prepreči privzetemu uporabniškemu agentu izvajanje kakršnihkoli ukrepov. To velja samo za Windows, druge platforme nimajo agenta.

policy-DisableDeveloperTools = Zavrni dostop do razvojnih orodij.

policy-DisableFeedbackCommands = Onemogoči ukaze v meniju Pomoč za pošiljanje povratnih informacij ("Povratne informacije" in "Prijavi zavajajočo stran").

policy-DisableFirefoxAccounts = Onemogoči storitve na osnovi { -fxaccount-brand-name }ov, na primer Sync.

# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Onemogoči možnost Firefox Screenshots.

policy-DisableFirefoxStudies = { -brand-short-name }u prepreči izvajanje raziskav.

policy-DisableForgetButton = Prepreči dostop do gumba Pozabi.

policy-DisableFormHistory = Ne shranjuj zgodovine iskanja in obrazcev.

policy-DisableMasterPasswordCreation = Če je "true", glavnega gesla ni mogoče ustvariti.

policy-DisablePrimaryPasswordCreation = Če je "true", glavnega gesla ni mogoče ustvariti.

policy-DisablePasswordReveal = Ne dovoli razkrivanja gesel na seznamu shranjenih prijav.

policy-DisablePocket = Onemogoči možnost shranjevanja spletnih strani v Pocket.

policy-DisablePrivateBrowsing = Onemogoči zasebno brskanje.

policy-DisableProfileImport = Onemogoči menijski ukaz Uvozi podatke drugega brskalnika.

policy-DisableProfileRefresh = Onemogoči gumb Osveži { -brand-short-name } na strani about:support.

policy-DisableSafeMode = Onemogoči možnost za ponovni zagon v varnem načinu. Opomba: zagon varnega načina s tipko Shift lahko v sistemu Windows onemogočite le z uporabo pravilnika skupine.

policy-DisableSecurityBypass = Uporabniku prepreči, da zaobide določena varnostna opozorila.

policy-DisableSetAsDesktopBackground = Onemogoči menijski ukaz Nastavi kot ozadje namizja za slike.

policy-DisableSystemAddonUpdate = Prepreči brskalniku nameščanje in posodabljanje sistemskih dodatkov.

policy-DisableTelemetry = Izključi telemetrijo.

policy-DisplayBookmarksToolbar = Privzeto prikaži orodno vrstico zaznamkov.

policy-DisplayMenuBar = Privzeto prikaži vrstico z menijem.

policy-DNSOverHTTPS = Nastavi DNS preko HTTPS.

policy-DontCheckDefaultBrowser = Onemogoči preverjanje privzetega brskalnika ob zagonu.

policy-DownloadDirectory = Nastavi in zakleni mapo za prenose.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Omogoči ali onemogoči zavračanje vsebine ter ga po potrebi zakleni.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Omogoči ali onemogoči Encrypted Media Extensions ter jih po potrebi zakleni.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Namesti, odstrani ali zakleni razširitve. Možnost "Install" kot parametre sprejema URL-je ali poti. Možnosti "Uninstall" in "Locked" sprejemata ID-je razširitev.

policy-ExtensionSettings = Upravljaj vse vidike namestitve razširitve.

policy-ExtensionUpdate = Omogoči ali onemogoči samodejno posodabljanje razširitev.

policy-FirefoxHome = Nastavi Firefoxovo domačo stran.

policy-FlashPlugin = Dovoli ali zavrni uporabo vtičnika Flash.

policy-Handlers = Nastavite privzete upravljalce aplikacij.

policy-HardwareAcceleration = Če je "false", izklopi strojno pospeševanje.

# “lock” means that the user won’t be able to change this setting
policy-Homepage = Nastavi in po potrebi zakleni domačo stran.

policy-InstallAddonsPermission = Določenim spletnim stranem dovoli nameščanje dodatkov.

policy-LegacyProfiles = Onemogoči možnost ustvarjanja ločenega profila za vsako namestitev.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Omogoči privzeto zastarelo nastavitev vedenja piškotkov SameSite.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Ponastavi zastarelo vedenje piškotkov SameSite na določenih straneh.

##

policy-LocalFileLinks = Določenim spletnim stranem dovoli povezovanje na krajevne datoteke.

policy-MasterPassword = Zahtevaj ali prepreči uporabo glavnega gesla.

policy-PrimaryPassword = Zahtevaj ali prepreči uporabo glavnega gesla.

policy-NetworkPrediction = Omogoči ali onemogoči napovedovanje omrežja (vnaprejšnje pridobivanje DNS).

policy-NewTabPage = Omogoči ali onemogoči stran novega zavihka.

policy-NoDefaultBookmarks = Onemogoči ustvarjanje privzetih zaznamkov, vključenih v { -brand-short-name }, in Pametnih zaznamkov (Najbolj obiskano, Nedavne oznake). Opomba: ta pravilnik je uveljavljen, samo če je nastavljen pred prvo uporabo profila.

policy-OfferToSaveLogins = Vsili shranjevanje prijav in gesel v { -brand-short-name }u. Možna je tako vrednost "true" kot "false".

policy-OfferToSaveLoginsDefault = Nastavi privzeto vrednost, ki dovoljuje shranjevanje prijav in gesel v { -brand-short-name }u. Možna je tako vrednost "true" kot "false".

policy-OverrideFirstRunPage = Preglasi stran prvega zagona. Če želite onemogočiti prikaz strani prvega zagona, nastavite pravilnik na prazno vrednost.

policy-OverridePostUpdatePage = Preglasi stran "Kaj je novega", ki se odpre po posodobitvi. Če želite onemogočiti prikaz strani po posodobitvi, nastavite pravilnik na prazno vrednost.

policy-PasswordManagerEnabled = Omogoči shranjevanje gesel v upravitelja gesel.

# PDF.js and PDF should not be translated
policy-PDFjs = Onemogoči ali nastavi PDF.js, pregledovalnik PDF brskalnika { -brand-short-name }.

policy-Permissions2 = Nastavi dovoljenja za kamero, mikrofon, lokacijo, obvestila in samodejno predvajanje.

policy-PictureInPicture = Omogoči ali onemogoči sliko v sliki

policy-PopupBlocking = Določenim spletnim stranem dovoli privzeto prikazovanje pojavnih oken.

policy-Preferences = Nastavi in zakleni vrednost podnabora nastavitev.

policy-PromptForDownloadLocation = Pri prenosu vprašaj, kam shraniti datoteko.

policy-Proxy = Nastavi posrednika.

policy-RequestedLocales = Nastavi vrstni red zahtevanih jezikov za program.

policy-SanitizeOnShutdown2 = Ob izhodu počisti podatke brskanja.

policy-SearchBar = Nastavi privzet položaj vrstice za iskanje. Uporabnik ga lahko še vedno prilagodi.

policy-SearchEngines = Nastavi iskalnike. Ta pravilnik je na voljo le v izdaji Extended Support Release (ESR).

policy-SearchSuggestEnabled = Omogoči ali onemogoči predloge iskanja.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Namesti module PKCS #11.

policy-SSLVersionMax = Nastavi najnovejšo dovoljeno različico SSL.

policy-SSLVersionMin = Nastavi najstarejšo dovoljeno različico SSL.

policy-SupportMenu = Dodaj poljubno povezavo za podporo v meni Pomoč.

policy-UserMessaging = Uporabniku ne prikazuj določenih sporočil.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Prepreči obisk določenih spletnih mest. Za več podrobnosti o obliki glejte dokumentacijo.
