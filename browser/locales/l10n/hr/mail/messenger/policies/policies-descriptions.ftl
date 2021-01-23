# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Postavite pravila kojima će WebExtensions moći pristupiti putem chrome.storage.managed.

policy-AppAutoUpdate = Omogući ili onemogući automatsko ažuriranje programa.

policy-AppUpdateURL = Postavi prilagođeni URL za ažuriranje aplikacije.

policy-Authentication = Konfigurirajte integriranu prijavu za web stranice koje ju podržavaju.

policy-BlockAboutAddons = Blokiraj pristup upravljaču dodataka (about:addons).

policy-BlockAboutConfig = Blokirajte pristup about:config stranici.

policy-BlockAboutProfiles = Blokirajte pristup about:profiles stranici.

policy-BlockAboutSupport = Blokirajte pristup about:support stranici.

policy-CaptivePortal = Omogućite ili onemogućite podršku za portal stranicu.

policy-CertificatesDescription = Dodajte certifikate ili koristite ugrađene certifikate.

policy-Cookies = Dopustite ili zabranite web stranicama da postavljaju kolačiće.

policy-DisabledCiphers = Deaktiviraj šifre.

policy-DefaultDownloadDirectory = Postavite zadanu mapu za preuzimanje datoteka.

policy-DisableAppUpdate = Spriječi { -brand-short-name } da se ažurira.

policy-DisableDefaultClientAgent = Spriječi zadanog agenta klijenta da poduzima bilo kakve radnje. Primjenjivo samo na Windows sustav, druge platforme nemaju agenta.

policy-DisableDeveloperTools = Blokiraj pristup programerskim alatima.

policy-DisableFeedbackCommands = Onemogući naredbe za slanje povratnih informacija iz izbornika pomoći (Pošalji povratne informacije i Prijavi obmanjujuću stranicu).

policy-DisableForgetButton = Spriječite pristup tipki Zaboravi.

policy-DisableFormHistory = Nemoj pamtiti povijest pretraživanja i obrazaca.

policy-DisableMasterPasswordCreation = Ukoliko je točno, neće biti moguće postaviti glavnu lozinku.

policy-DisablePasswordReveal = Nemoj dozvoliti prikaz lozinki u spremljenim prijavama.

policy-DisableProfileImport = Onemogućite naredbu izbornika za uvoz podataka iz drugih aplikacija.

policy-DisableSafeMode = Onemogućite značajku za ponovno pokretanje u sigurnom načinu rada. Napomena: Shift tipka za ulazak u sigurni način se može onemogućiti samo na Windowsima koristeći Grupne politike.

policy-DisableSecurityBypass = Spriječite korisnika da zaobilazi određena sigurnosna upozorenja.

policy-DisableSystemAddonUpdate = Spriječi { -brand-short-name } da instalira i ažurira sustavske dodatke.

policy-DisableTelemetry = Isključite telemetriju.

policy-DisplayMenuBar = Postavi kao početne postavke prikaz trake izbornika.

policy-DNSOverHTTPS = Postavi DNS preko HTTPS.

policy-DontCheckDefaultClient = Onemogući provjeru zadanog klijenta prilikom pokretanja.

policy-DownloadDirectory = Postavi i zaključaj mapu za preuzimanje.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Omogući i onemogući blokiranje sadržaja i opcionalno ga zaključajte.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Aktiviraj ili deaktiviraj proširenja za šifrirane medije i opcionalno ih zaključaj.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instaliraj, ukloni ili zaključaj dodatke. Mogućnost instalacije uzima URL-ove ili putanje kao parametre. Mogućnosti ukloni ili zaključaj uzima ID dodatka.

policy-ExtensionSettings = Upravljajte svim aspektima instalacije dodataka.

policy-ExtensionUpdate = Omogući ili onemogući automatsko ažuriranje dodataka.

policy-HardwareAcceleration = Ukoliko je postavljeno na netočno, isključuje hardversko ubrzanje.

policy-InstallAddonsPermission = Dopusti određenim stranicama za instaliraju dodatke.

policy-LegacyProfiles = Deaktiviraj funkciju koja nameće zaseban profil za svaku instalaciju.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Aktiviraj standardnu staru postavku ponašanja SameSite kolačića.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Vrati se na staro ponašanje SameSitea za kolačiće na određenim stranicama.

##

policy-LocalFileLinks = Omogućite određenim stranicama poveznice na lokalne datoteke.

policy-NetworkPrediction = Omogućite ili onemogućite predviđanje mreže (DNS prefetching).

policy-OfferToSaveLogins = Primorajte postavke dozvole da { -brand-short-name } nudi pamćenje prijava i lozinki. Preihvaćaju se vrijednosti točno i netočno.

policy-OfferToSaveLoginsDefault = Postavi standardnu vrijednost, kako bi { -brand-short-name }ponudio pamtiti spremljene prijave i lozinke. Prihvaćaju se vrijednosti za točno i netočno.

policy-OverrideFirstRunPage = Poništite postavke početne stranice. Postavite ovo pravilo na prazno ukoliko želite onemogućiti početnu stranicu.

policy-OverridePostUpdatePage = Poništite "Što je novo" stranicu nakon ažuriranja. Postavite ovo pravilo na prazno ukoliko želite onemogućiti stranicu nakon ažuriranja.

policy-PasswordManagerEnabled = Aktiviraj spremanje lozinki u upravljaču lozinki.

# PDF.js and PDF should not be translated
policy-PDFjs = Deaktiviraj ili konfiguriraj PDF.js, ugrađeni čitač PDF-a u { -brand-short-name }u.

policy-Permissions2 = Podesi dozvole za kameru, mikrofon, lokaciju, obavijesti i automatsku reprodukciju.

policy-Preferences = Postavite i zaključajte vrijednost za podskup postavki.

policy-PromptForDownloadLocation = Pitajte gdje spremiti datoteke prilikom preuzimanja.

policy-Proxy = Podesi proxy postavke.

policy-RequestedLocales = Postavite popis traženih jezika za aplikaciju prema redosljedu preferencija.

policy-SanitizeOnShutdown2 = Obrišite podatke o navigaciji prilikom gašenja.

policy-SearchEngines = Prilagodite postavke pretraživača. Ovo pravilo je dostupno samo u inačici proširene podrške (ESR).

policy-SearchSuggestEnabled = Aktiviraj ili deaktiviraj prijedloge za pretraživanje.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalirajte PKCS #11 module.

policy-SSLVersionMax = Postavite maksimalnu SSL inačicu.

policy-SSLVersionMin = Postavite minimalnu SSL inačicu.

policy-SupportMenu = Dodajte prilagođenu stavku za podršku u izbornik pomoći.

policy-UserMessaging = Ne prikazuj određene poruke korisniku.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blokirajte posjećivanje web stranica. Proučite dokumentaciju za više detalja oko oblika.
