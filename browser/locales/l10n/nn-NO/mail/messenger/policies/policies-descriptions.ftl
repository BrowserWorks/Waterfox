# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Spesifiser policyar som WebExtensions kan få tilgang til via chrome.storage.managed.

policy-AppAutoUpdate = Slå på eller slå av automatisk programoppdatering.

policy-AppUpdateURL = Spesifiser eigendefinert programoppdateringsadresse.

policy-Authentication = Konfigurer integrert godkjenning for nettsider som støttar det.

policy-BlockAboutAddons = Blokker tilgang til Tilleggshandteraren (about:addons)

policy-BlockAboutConfig = Blokker tilgang til about:config-sida.

policy-BlockAboutProfiles = Blokker tilgang til about:profiles-sida.

policy-BlockAboutSupport = Blokker tilgang til about:support-sida.

policy-CaptivePortal = Aktiver eller deaktiver støtte for captive portal.

policy-CertificatesDescription = Legg til sertifikat eller bruk innebygde sertifikat.

policy-Cookies = Tillat eller nekt nettstadar å lagre infokapslar.

policy-DisabledCiphers = Slå av krypteringsmetodar.

policy-DefaultDownloadDirectory = Vel standardmappe for nedlastingar.

policy-DisableAppUpdate = Hindre at { -brand-short-name } vert oppdatert.

policy-DisableDefaultClientAgent = Hindre standardklientagenten frå å gjere noko. Gjeld berre Windows; andre plattformer har ikkje agenten.

policy-DisableDeveloperTools = Blokker tilgang til utviklarverktøya.

policy-DisableFeedbackCommands = Deaktiver kommandoar for å sende tilbakemelding frå Hjelp-menyen (Gje tilbakemelding og Rapporter villeiande nettstad).

policy-DisableForgetButton = Hindre tilgang til knappen Gløym.

policy-DisableFormHistory = Ikkje hugs søkje- og skjemahistorikk.

policy-DisableMasterPasswordCreation = Om aktiv, kan ikkje eit hovudpassord lagast.

policy-DisablePasswordReveal = Ikkje tillat at passord vert viste i lagra innloggingar.

policy-DisableProfileImport = Deaktiver meny-kommandoen for å importere data frå eit anna program.

policy-DisableSafeMode = Deaktiver funksjonen for å starte på nytt i trygg modus. NB: Deaktivering av tasten skift for å starte trygg modus kan berre gjennomførast i Windows via gruppepolicy.

policy-DisableSecurityBypass = Hindre brukaren frå å å omgå visse sikkerheitsåtvaringar.

policy-DisableSystemAddonUpdate = Hindre at { -brand-short-name } installerer og oppdaterer systemtillegg.

policy-DisableTelemetry = Slå av av telemetri.

policy-DisplayMenuBar = Vise menylinja som standard.

policy-DNSOverHTTPS = Konfigurer DNS-over-HTTPS.

policy-DontCheckDefaultClient = Deaktiver sjekk om standard-klient ved oppstart.

policy-DownloadDirectory = Spesifiser og lås netlastingskatalogen.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Aktiver eller deaktiver innhaldsblokkering med moglegheit til å låse valet.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Slå på eller av Encrypted Media Extensions. Brukaren kan eventuelt hindrast i å endre innstillinga.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Installere, avinstallere eller låse tillegg. Installeringsalternativet tar nettadresser eller baner som parameter. Avinstallerings- og Låse-alternativa tek tilleggs-ID som parameter.

policy-ExtensionSettings = Handter alle aspekt av utvidingsinstallasjonen.

policy-ExtensionUpdate = Slå på eller slå av automatisk utvidingsoppdateringar.

policy-HardwareAcceleration = Om inaktiv, slå av maskinvareakselerasjon.

policy-InstallAddonsPermission = Tillat visse nettstadar å installere tillegg.

policy-LegacyProfiles = Slå av funksjonen som tvingar fram ein separat profil for kvar installasjon.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Slå på standard-innstilling for forelda SameSite-oppførsel.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Gå tilbake til forelda SameSite-oppførsel for infokapslar på bestemte nettstadar.

##

policy-LocalFileLinks = Tillat at bestemte nettstadar koplar til lokale filer.

policy-NetworkPrediction = Aktiver eller deaktiver nettverkspredikering (DNS-prefetch).

policy-OfferToSaveLogins = Tving innstillinga til å tillate { -brand-short-name } å kunne kome i hug lagra innloggingar og passord. Både true- og falseverdiar er godkjende.

policy-OfferToSaveLoginsDefault = Vel om { -brand-short-name } skal tilby å hugse innloggingar og passord. Vel true, dersom { -brand-short-name } skal tilby å hugse innloggingar og passord, elles vel false.

policy-OverrideFirstRunPage = Erstatt sida som vert vist ved første oppstart. La policyen vere tom, viss sida ved første oppstart skal deaktiverast.

policy-OverridePostUpdatePage = Byt ut «Kva er nytt»-sida som vert vist etter ei oppdatering. La policyen stå tom viss sida etter ei oppdatering skal deaktiverast.

policy-PasswordManagerEnabled = Tillat at brukaren kan lagre passord i passord-handteraren.

# PDF.js and PDF should not be translated
policy-PDFjs = Slå av eller konfigurer PDF.js, det innebygde PDF-visingsprogrammet i { -brand-short-name }.

policy-Permissions2 = Konfigurer løyve for kamera, mikrofon, posisjon, varsel og automatisk avspeling.

policy-Preferences = Still inn og lås verdien for ei delmengde av innstillingar.

policy-PromptForDownloadLocation = Spør kvar nedlasta filer skal lagrast.

policy-Proxy = Konfigurer proxy-innstillingar.

policy-RequestedLocales = Vel rekkjefølgja av språk, som skal brukeast i programmet.

policy-SanitizeOnShutdown2 = Fjern nettlesingsdata ved avslutting.

policy-SearchEngines = Konfigurer søkjemotorinnstillingar. Denne policyen er kun tilgjengeleg for Extended Support Release (ESR).

policy-SearchSuggestEnabled = Slå på/av søkjeforslag.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Installer PKCS #11-modular.

policy-SSLVersionMax = Still inn den maksimale SSL-versjonen.

policy-SSLVersionMin = Still inn den minimale SSL-versjonen.

policy-SupportMenu = Legg til eit tilpassa menyelement med hjelp i hjelpemenyen.

policy-UserMessaging = Ikkje vis visse meldingar til brukaren.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blokker besøk på nettstadar. Les dokumentasjonen for detaljer om formatet.
