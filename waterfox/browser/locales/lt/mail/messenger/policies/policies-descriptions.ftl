# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Nustatykite strategijas, kurias „WebExtensions“ galės pasiekti per „chrome.storage.managed“.

policy-AppAutoUpdate = Įjungti arba išjungti automatinius programos naujinimus.

policy-AppUpdateURL = Nustatyti kitą programos naujinimų URL.

policy-Authentication = Konfigūruoti integruotą autentifikaciją ją palaikančioms svetainėms.

policy-BlockAboutAddons = Blokuoti prieigą prie priedų valdymo („about:addons“).

policy-BlockAboutConfig = Blokuoti prieigą prie „about:config“ puslapio.

policy-BlockAboutProfiles = Blokuoti prieigą prie „about:profiles“ puslapio.

policy-BlockAboutSupport = Blokuoti prieigą prie „about:support“ puslapio.

policy-CaptivePortal = Įjungti arba išjungti pradinio tinklalapio palaikymą.

policy-CertificatesDescription = Pridėti liudijimus, arba naudoti integruotus.

policy-Cookies = Leisti ar drausti svetainėms įrašyti slapukus.

policy-DisabledCiphers = Išjungti šifrus.

policy-DefaultDownloadDirectory = Nustatyti numatytąjį atsiuntimų aplanką.

policy-DisableAppUpdate = Neleisti atnaujinti „{ -brand-short-name }“.

policy-DisableDefaultClientAgent = Neleisti numatytajam kliento agentui atlikti jokių veiksmų. Taikoma tik „Windows“; kitos platformos agento neturi.

policy-DisableDeveloperTools = Blokuoti prieigą prie programuotojų priemonių.

policy-DisableFeedbackCommands = Išjungti komandas, skirtas siųsti atsiliepimus iš „Žinyno“ meniu („Siųsti atsiliepimą“ ir „Pranešti apie apgaulingą svetainę“).

policy-DisableForgetButton = Blokuoti mygtuką „Pamiršti“.

policy-DisableFormHistory = Neįsiminti įvestų paieškos ir formų laukų reikšmių.

policy-DisableMasterPasswordCreation = Jei „true“, negalima sukurti pagrindinio slaptažodžio.

policy-DisablePasswordReveal = Neleisti parodyti slaptažodžių įrašytuose prisijungimuose.

policy-DisableProfileImport = Išjungti meniu komandą, importuojančią duomenis iš kitų programų.

policy-DisableSafeMode = Išjungti galimybę paleisti iš naujo ribotoje veiksenoje. Pastaba: klavišas „Shift“, skirtas pereiti į ribotąją veikseną, gali būtų išjungtas tik „Windows“ aplinkoje, naudojant „Group Policy“.

policy-DisableSecurityBypass = Neleisti naudotojui apeiti kai kurių saugumo įspėjimų.

policy-DisableSystemAddonUpdate = Neleisti „{ -brand-short-name }“ diegti ir atnaujinti sistemos priedų.

policy-DisableTelemetry = Išjungti telemetriją.

policy-DisplayMenuBar = Iš karto rodyti meniu juostą.

policy-DNSOverHTTPS = Konfigūruoti DNS per HTTPS.

policy-DontCheckDefaultClient = Išjungti numatytosios programos tikrinimą paleidžiant.

policy-DownloadDirectory = Nustatyti ir užrakinti atsiuntimų aplanką.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Įjungti arba išjungti turinio blokavimą, ir papildomai jį užrakinti.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Įjungti arba išjungti „Encrypted Media Extensions“ ir, papildomai, juos užrakinti.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Diegti, šalinti, arba užrakinti priedus. Diegimo nuostata priima URL adresus arba failų kelius. Šalinimo ir užrakinimo nuostatos priima priedų ID.

policy-ExtensionSettings = Tvarkyti visus priedų įdiegimo aspektus.

policy-ExtensionUpdate = Įjungti arba išjungti automatinius priedų naujinimus.

policy-HardwareAcceleration = Jei „false“, išjungti aparatinį spartinimą.

policy-InstallAddonsPermission = Leisti kai kurioms svetainėms diegti priedus.

policy-LegacyProfiles = Nekurti atskiro profilio kiekvienai įdiegčiai.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Įjungti numatytąją pasenusią „SameSite“ slapukų elgesio nuostatą.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Grįžti prie pasenusios „SameSite“ slapukų elgsenos nurodytose svetainėse.

##

policy-LocalFileLinks = Leisti konkrečioms svetainėms susieti vietinius failus.

policy-NetworkPrediction = Įjungti arba išjungti tinklo nuspėjimą (parengtinis DNS įkėlimas).

policy-OfferToSaveLogins = Nuostata leidžia siūlyti „{ -brand-short-name }“ vartotojui išisaugoti įvestus prisijungimus ir slaptažodžius. Priimamos „true“ ir „false“ reikšmės.

policy-OfferToSaveLoginsDefault = Nustatykite numatytąją reikšme, skirtą „{ -brand-short-name }“ siūlyti įsiminti įrašytus prisijungimus ir slaptažodžius. Priimamos „true“ ir „false“ reikšmės.

policy-OverrideFirstRunPage = Pakeisti pirmo paleidimo puslapį. Padarykite šią strategiją tuščią, jei norite nerodyti pirmojo paleidimo puslapio.

policy-OverridePostUpdatePage = Pakeisti po atnaujinimų rodomą puslapį „Kas naujo“. Padarykite šią strategiją tuščią, jei nenorite rodyti atnaujinimų puslapio.

policy-PasswordManagerEnabled = Įjungti slaptažodžių įrašymą į slaptažodžių tvarkytuvę.

# PDF.js and PDF should not be translated
policy-PDFjs = Išjungti arba konfigūruoti „PDF.js“, į „{ -brand-short-name }“ integruotą PDF failų žiūryklę.

policy-Permissions2 = Konfigūruoti kameros, mikrofono, buvimo vietos nustatymo, pranešimų ir automatinio grojimo leidimus.

policy-Preferences = Nustatyti ir užfiksuoti nuostatų rinkinio reikšmę.

policy-PromptForDownloadLocation = Klausti kur įrašyti atsiunčiamus failus.

policy-Proxy = Konfigūruoti įgaliotųjų serverių nuostatas.

policy-RequestedLocales = Nustatyti programos prašomų kalbų sąrašą ir jo eiliškumą.

policy-SanitizeOnShutdown2 = Išvalyti visus naršymo duomenis išjungiant programą.

policy-SearchEngines = Konfigūruoti ieškyklių nuostatas. Ši strategija galima tik prailginto palaikymo laidos (ESR) versijoje.

policy-SearchSuggestEnabled = Įjungti arba išjungti paieškos žodžių siūlymus.

# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Diegti PKCS #11 modulius.

policy-SSLVersionMax = Nustatykite maksimalią SSL versiją.

policy-SSLVersionMin = Nustatyti mažiausią SSL versiją.

policy-SupportMenu = Pridėti papildomą pagalbos meniu elementą į žinyno meniu.

policy-UserMessaging = Nerodyti naudotojui tam tikrų pranešimų.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blokuoti svetainių lankymą. Paskaitykite dokumentaciją apie blokavimo sintaksę.
