# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
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

policy-CaptivePortal = Omogoči ali onemogoči podporo za prestrezni portal.

policy-CertificatesDescription = Dodaj digitalna potrdila ali uporabi vgrajena potrdila.

policy-Cookies = Spletnim stranem dovoli ali zavrni nastavljanje piškotkov.

policy-DisabledCiphers = Onemogoči šifre.

policy-DefaultDownloadDirectory = Nastavi privzeto mapo za prenose.

policy-DisableAppUpdate = Prepreči posodabljanje { -brand-short-name }a.

policy-DisableDefaultClientAgent = Prepreči privzetemu agentu odjemalca izvajanje kakršnihkoli dejanj. To velja samo za Windows, druge platforme nimajo agenta.

policy-DisableDeveloperTools = Zavrni dostop do razvojnih orodij.

policy-DisableFeedbackCommands = Onemogoči ukaze v meniju Pomoč za pošiljanje povratnih informacij ("Povratne informacije" in "Prijavi zavajajočo stran").

policy-DisableForgetButton = Prepreči dostop do gumba Pozabi.

policy-DisableFormHistory = Ne shranjuj zgodovine iskanja in obrazcev.

policy-DisableMasterPasswordCreation = Če je "true", glavnega gesla ni mogoče ustvariti.

policy-DisablePasswordReveal = Ne dovoli razkrivanja gesel na seznamu shranjenih prijav.

policy-DisableProfileImport = Onemogoči menijski ukaz Uvozi podatke drugega brskalnika.

policy-DisableSafeMode = Onemogoči možnost za ponovni zagon v varnem načinu. Opomba: zagon varnega načina s tipko Shift lahko v sistemu Windows onemogočite le z uporabo pravilnika skupine.

policy-DisableSecurityBypass = Uporabniku prepreči, da zaobide določena varnostna opozorila.

policy-DisableSystemAddonUpdate = Prepreči { -brand-short-name }u nameščanje in posodabljanje sistemskih dodatkov.

policy-DisableTelemetry = Izključi telemetrijo.

policy-DisplayMenuBar = Privzeto prikaži vrstico z menijem.

policy-DNSOverHTTPS = Nastavi DNS preko HTTPS.

policy-DontCheckDefaultClient = Onemogoči preverjanje privzetega odjemalca ob zagonu.

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

policy-HardwareAcceleration = Če je "false", izklopi strojno pospeševanje.

policy-InstallAddonsPermission = Določenim spletnim stranem dovoli nameščanje dodatkov.

policy-LegacyProfiles = Onemogoči možnost ustvarjanja ločenega profila za vsako namestitev.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Omogoči privzeto zastarelo nastavitev vedenja piškotkov SameSite.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Ponastavi zastarelo vedenje piškotkov SameSite na določenih straneh.

##

policy-LocalFileLinks = Določenim spletnim stranem dovoli povezovanje na krajevne datoteke.

policy-NetworkPrediction = Omogoči ali onemogoči napovedovanje omrežja (vnaprejšnje pridobivanje DNS).

policy-OfferToSaveLogins = Vsili shranjevanje prijav in gesel v { -brand-short-name }u. Možna je tako vrednost "true" kot "false".

policy-OfferToSaveLoginsDefault = Nastavi privzeto vrednost, ki dovoljuje shranjevanje prijav in gesel v { -brand-short-name }u. Možna je tako vrednost "true" kot "false".

policy-OverrideFirstRunPage = Preglasi stran prvega zagona. Če želite onemogočiti prikaz strani prvega zagona, nastavite pravilnik na prazno vrednost.

policy-OverridePostUpdatePage = Preglasi stran "Kaj je novega", ki se odpre po posodobitvi. Če želite onemogočiti prikaz strani po posodobitvi, nastavite pravilnik na prazno vrednost.

policy-PasswordManagerEnabled = Omogoči shranjevanje gesel v upravitelja gesel.

# PDF.js and PDF should not be translated
policy-PDFjs = Onemogoči ali nastavi PDF.js, pregledovalnik PDF brskalnika { -brand-short-name }.

policy-Permissions2 = Nastavi dovoljenja za kamero, mikrofon, lokacijo, obvestila in samodejno predvajanje.

policy-Preferences = Nastavi in zakleni vrednost podnabora nastavitev.

policy-PromptForDownloadLocation = Pri prenosu vprašaj, kam shraniti datoteko.

policy-Proxy = Nastavi posrednika.

policy-RequestedLocales = Nastavi vrstni red zahtevanih jezikov za program.

policy-SanitizeOnShutdown2 = Ob izhodu počisti podatke brskanja.

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
