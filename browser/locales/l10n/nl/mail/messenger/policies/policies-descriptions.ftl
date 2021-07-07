# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Beleidsregels instellen zodat WebExtensions via chrome.storage.managed toegang kunnen krijgen.

policy-AppAutoUpdate = Automatische applicatie-update in- of uitschakelen.

policy-AppUpdateURL = Aangepaste app-update-URL instellen.

policy-Authentication = Geïntegreerde authenticatie configureren voor websites die dit ondersteunen.

policy-BlockAboutAddons = Toegang tot de Add-onbeheerder (about:addons) blokkeren.

policy-BlockAboutConfig = Toegang tot de about:config-pagina blokkeren.

policy-BlockAboutProfiles = Toegang tot de about:profiles-pagina blokkeren.

policy-BlockAboutSupport = Toegang tot de about:support-pagina blokkeren.

policy-CaptivePortal = Ondersteuning voor hotspot-aanmeldingspagina inschakelen of uitschakelen.

policy-CertificatesDescription = Certificaten toevoegen of ingebouwde certificaten gebruiken.

policy-Cookies = Toestaan of weigeren dat websites cookies instellen.

policy-DisabledCiphers = Coderingssuites uitschakelen.

policy-DefaultDownloadDirectory = Standaard downloadmap instellen.

policy-DisableAppUpdate = Voorkomen dat { -brand-short-name } wordt bijgewerkt.

policy-DisableDefaultClientAgent = Voorkomen dat de standaard clientagent enige actie onderneemt. Alleen van toepassing op Windows; andere platformen beschikken niet over de agent.

policy-DisableDeveloperTools = Toegang tot de ontwikkelaarshulpmiddelen blokkeren.

policy-DisableFeedbackCommands = Opdrachten voor het verzenden van feedback vanuit het menu Help uitschakelen (Feedback verzenden en Misleidende website rapporteren).

policy-DisableForgetButton = Toegang tot de knop Vergeten voorkomen.

policy-DisableFormHistory = Geen zoek- en formuliergeschiedenis onthouden.

policy-DisableMasterPasswordCreation = Wanneer true, kan geen hoofdwachtwoord worden aangemaakt.

policy-DisablePasswordReveal = Niet toestaan dat wachtwoorden worden onthuld in opgeslagen aanmeldingen.

policy-DisableProfileImport = De menuopdracht voor het importeren van gegevens vanuit een andere applicatie uitschakelen.

policy-DisableSafeMode = De functie voor het herstarten in Veilige modus uitschakelen. Noot: de Shift-toets voor het betreden van de Veilige modus kan in Windows alleen worden uitgeschakeld via Groepsbeleid.

policy-DisableSecurityBypass = Voorkomen dat de gebruiker bepaalde beveiligingsinstellingen omzeilt.

policy-DisableSystemAddonUpdate = Voorkomen dat { -brand-short-name } systeemadd-ons installeert en bijwerkt.

policy-DisableTelemetry = Telemetry uitschakelen.

policy-DisplayMenuBar = Standaard de Menubalk weergeven.

policy-DNSOverHTTPS = DNS over HTTPS configureren.

policy-DontCheckDefaultClient = Controle op standaardclient bij opstarten uitschakelen.

policy-DownloadDirectory = De downloadmap instellen en vergrendelen.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Inhoudsblokkering inschakelen of uitschakelen en optioneel vergrendelen.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Versleutelde media-extensies in- of uitschakelen en optioneel vergrendelen.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Extensies installeren, de-installeren of vergrendelen. De optie voor installeren gebruikt URL’s of paden als parameters. De opties voor de-installeren en vergrendelen gebruiken extensie-ID’s.

policy-ExtensionSettings = Alle aspecten van installatie van extensies beheren.

policy-ExtensionUpdate = Automatische extensie-updates inschakelen of uitschakelen.

policy-HardwareAcceleration = Wanneer false, hardwareversnelling uitschakelen.

policy-InstallAddonsPermission = Toestaan dat bepaalde websites add-ons installeren.

policy-LegacyProfiles = Functie om een afzonderlijk profiel voor elke installatie af te dwingen uitschakelen.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Standaardinstelling voor verouderd SameSite-gedrag voor cookies inschakelen.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Op specifieke websites terugkeren naar verouderd SameSite-gedrag voor cookies.

##

policy-LocalFileLinks = Specifieke websites toestaan te koppelen naar lokale bestanden.

policy-NetworkPrediction = ‘Network prediction’ (DNS prefetching) inschakelen of uitschakelen.

policy-OfferToSaveLogins = De instelling voor het toestaan dat { -brand-short-name } mag aanbieden opgeslagen aanmeldingen en wachtwoorden te onthouden afdwingen. Zowel de waarde true als false wordt geaccepteerd.

policy-OfferToSaveLoginsDefault = De standaardwaarde instellen voor het toestaan dat { -brand-short-name } mag aanbieden opgeslagen aanmeldingen en wachtwoorden te onthouden. Zowel de waarde true als false wordt geaccepteerd.

policy-OverrideFirstRunPage = De pagina voor eerste keer uitvoeren vervangen. Stel deze beleidsregel in op leeg als u de betreffende pagina wilt uitschakelen.

policy-OverridePostUpdatePage = De pagina ‘Wat is er nieuw’ na een update vervangen. Stel deze beleidsregel in op leeg als u de betreffende pagina wilt uitschakelen.

policy-PasswordManagerEnabled = Opslaan van wachtwoorden in de wachtwoordenbeheerder inschakelen.

# PDF.js and PDF should not be translated
policy-PDFjs = PDF.js, de in { -brand-short-name } ingebouwde PDF-lezer, uitschakelen of instellen.

policy-Permissions2 = Toestemmingen voor camera, microfoon, locatie, notificaties en automatisch afspelen configureren.

policy-Preferences = De waarde voor een subset van voorkeuren instellen en vergrendelen.

policy-PromptForDownloadLocation = Vragen waar gedownloade bestanden moeten worden opgeslagen.

policy-Proxy = Proxyinstellingen configureren.

policy-RequestedLocales = De lijst van gevraagde locales voor de toepassing instellen, op volgorde van voorkeur.

policy-SanitizeOnShutdown2 = Navigatiegegevens wissen bij afsluiten.

policy-SearchEngines = Instellingen voor zoekmachines configureren. Deze beleidsregel is alleen beschikbaar in de Extended Support Release (ESR)-versie.

policy-SearchSuggestEnabled = Zoeksuggesties inschakelen of uitschakelen.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = PKCS #11-modules installeren.

policy-SSLVersionMax = De maximale SSL-versie instellen.

policy-SSLVersionMin = De minimale SSL-versie instellen.

policy-SupportMenu = Een aangepast menu-item voor ondersteuning aan het menu Help toevoegen.

policy-UserMessaging = Bepaalde berichten niet aan de gebruiker tonen.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Het bezoeken van websites blokkeren. Zie de documentatie voor meer informatie over de notatie.
