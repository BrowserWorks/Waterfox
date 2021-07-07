# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Nustatykite strategijas, kurias „WebExtensions“ galės pasiekti per „chrome.storage.managed“.
policy-AllowedDomainsForApps = Nurodyti domenus, kuriems leidžiama pasiekti „Google Workspace“.
policy-AppAutoUpdate = Įjungti arba išjungti automatinius programos naujinimus.
policy-AppUpdateURL = Nustatyti pasirinktinį programos naujinimų URL.
policy-Authentication = Keisti integruotą autentikaciją ją palaikančioms svetainėms.
policy-AutoLaunchProtocolsFromOrigins = Nurodykite sąrašą išorinių protokolų, kurie galės būti naudojami iš išvardintų šaltinių, neperspėjant naudotojo.
policy-BackgroundAppUpdate2 = Įjungti arba išjungti foninio naujinimo tarnybą.
policy-BlockAboutAddons = Blokuoti prieigą prie priedų valdymo (about:addons).
policy-BlockAboutConfig = Blokuoti prieigą prie about:config puslapio.
policy-BlockAboutProfiles = Blokuoti prieigą prie about:profiles puslapio.
policy-BlockAboutSupport = Blokuoti prieigą prie about:support puslapio.
policy-Bookmarks = Kurti įrašus adresyno juostoje, adresyno meniu, arba nurodytame aplanke jų viduje.
policy-CaptivePortal = Įjungti arba išjungti pradinio tinklalapio palaikymą.
policy-CertificatesDescription = Pridėti liudijimus, arba naudoti integruotus.
policy-Cookies = Leisti ar drausti svetainėms įrašyti slapukus.
policy-DisabledCiphers = Išjungti šifrus.
policy-DefaultDownloadDirectory = Nustatyti numatytąjį atsiuntimų aplanką.
policy-DisableAppUpdate = Neleisti naršyklei diegti naujinimų.
policy-DisableBuiltinPDFViewer = Išjungti „PDF.js“, į „{ -brand-short-name }“ integruotą PDF failų žiūryklę.
policy-DisableDefaultBrowserAgent = Neleisti numatytajam naršyklės agentui atlikti jokių veiksmų. Taikoma tik „Windows“; kitos platformos agento neturi.
policy-DisableDeveloperTools = Blokuoti prieigą prie programuotojų priemonių.
policy-DisableFeedbackCommands = Išjungti komandas, skirtas siųsti atsiliepimus iš „Žinyno“ meniu („Siųsti atsiliepimą“ ir „Pranešti apie apgaulingą svetainę“).
policy-DisableFirefoxAccounts = Išjungti „{ -fxaccount-brand-name }“ paremtas paslaugas, įskaitant „Sync“.
# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Išjungti „Firefox“ ekrano nuotraukų funkcionalumą.
policy-DisableFirefoxStudies = Neleisti „{ -brand-short-name }“ vykdyti tyrimų.
policy-DisableForgetButton = Blokuoti prieigą prie mygtuką „Pamiršti“.
policy-DisableFormHistory = Neįsiminti įvestų paieškos ir formų laukų reikšmių.
policy-DisableMasterPasswordCreation = Jei „true“, negalima sukurti pagrindinio slaptažodžio.
policy-DisablePrimaryPasswordCreation = Jei „true“, negalima sukurti pagrindinio slaptažodžio.
policy-DisablePasswordReveal = Neleisti parodyti slaptažodžių įrašytuose prisijungimuose.
policy-DisablePocket = Išjungti funkcionalumą, skirtą tinklalapių įrašymui į „Pocket“.
policy-DisablePrivateBrowsing = Išjungti privatųjį naršymą.
policy-DisableProfileImport = Išjungti meniu komandą, skirtą importuoti duomenis iš kitos naršyklės.
policy-DisableProfileRefresh = Išjungti mygtuką „Atšviežinti { -brand-short-name }“, esantį about:support puslapyje.
policy-DisableSafeMode = Išjungti galimybę paleisti iš naujo ribotoje veiksenoje. Pastaba: mygtukas Lyg2, skirtas pereiti į ribotąją veikseną, gali būtų išjungtas tik „Windows“ aplinkoje, naudojant „Group Policy“.
policy-DisableSecurityBypass = Neleisti naudotojui apeiti kai kurių saugumo įspėjimų.
policy-DisableSetAsDesktopBackground = Išjungti meniu komandą „Naudoti kaip darbastalio foną“ paveikslams.
policy-DisableSystemAddonUpdate = Neleisti naršyklei diegti ir naujinti sistemos priedų.
policy-DisableTelemetry = Išjungti telemetriją.
policy-DisplayBookmarksToolbar = Rodyti adresyno juostą pagal numatymą.
policy-DisplayMenuBar = Rodyti meniu juostą pagal numatymą.
policy-DNSOverHTTPS = Konfigūruoti DNS per HTTPS.
policy-DontCheckDefaultBrowser = Išjungti numatytosios naršyklės tikrinimą paleidžiant.
policy-DownloadDirectory = Nustatyti ir užrakinti atsiuntimų aplanką.
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Įjungti arba išjungti turinio blokavimą, ir papildomai jį užrakinti.
# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Įjungti arba išjungti „Encrypted Media Extensions“ ir papildomai juos užrakinti.
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Diegti, šalinti, arba užrakinti priedus. Diegimo nuostata priima URL adresus arba kelius kaip parametrus. Šalinimo ir užrakinimo nuostatos priima priedų ID.
policy-ExtensionSettings = Tvarkyti visus priedų įdiegimo aspektus.
policy-ExtensionUpdate = Įjungti arba išjungti automatinius priedų naujinimus.
policy-FirefoxHome = Konfigūruoti „Firefox“ pradžios ekraną.
policy-FlashPlugin = Leisti arba drausti „Flash“ plėtinio naudojimą.
policy-Handlers = Konfigūruoti numatytąsias programas.
policy-HardwareAcceleration = Jei „false“, išjungti aparatinį spartinimą.
# “lock” means that the user won’t be able to change this setting
policy-Homepage = Nustatyti ir papildomai užrakinti pradžios tinklalapį.
policy-InstallAddonsPermission = Leisti kai kurioms svetainėms diegti priedus.
policy-LegacyProfiles = Išjungti reikalavimą turėti atskirą profilį kiekvienai įdiegčiai

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Įjungti numatytąją pasenusią „SameSite“ slapukų elgesio nuostatą.
policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Grįžti prie pasenusios „SameSite“ slapukų elgsenos nurodytose svetainėse.

##

policy-LocalFileLinks = Leisti konkrečioms svetainėms susieti vietinius failus.
policy-ManagedBookmarks = Nustato administratoriaus tvarkomą adresyną, kurio naudotojas negali keisti.
policy-MasterPassword = Reikalauti arba neleisti naudoti pagrindinio slaptažodžio.
policy-ManualAppUpdateOnly = Leisti naujinti tik rankiniu būdų, ir nepranešti apie esamus naujinimus.
policy-PrimaryPassword = Reikalauti arba neleisti naudoti pagrindinio slaptažodžio.
policy-NetworkPrediction = Įjungti arba išjungti tinklo nuspėjimą (parengtinis DNS įkėlimas).
policy-NewTabPage = Įjungti arba išjungti naujos kortelės puslapį.
policy-NoDefaultBookmarks = Išjungti numatytųjų adresyno įrašų, kurie ateina su „{ -brand-short-name }“, kūrimą, bei išmanųjį adresyną („Lankomiausi“, „Paskiausiai naudotos gairės“). Pastaba: šis nuostatas veikia tik jeigu yra panaudojamas prieš pirmąjį profilio paleidimą.
policy-OfferToSaveLogins = Taikyti nuostatą, skirtą leisti „{ -brand-short-name }“ siūlyti įsiminti įrašytus prisijungimus ir slaptažodžius. Priimamos „true“ ir „false“ reikšmės.
policy-OfferToSaveLoginsDefault = Nustatykite numatytąją reikšme, skirtą leisti „{ -brand-short-name }“ siūlyti įsiminti įrašytus prisijungimus ir slaptažodžius. Priimamos „true“ ir „false“ reikšmės.
policy-OverrideFirstRunPage = Pakeisti pirmo paleidimo puslapį. Padarykite šią strategiją „blank“, norėdami išjungti pirmojo paleidimo puslapį.
policy-OverridePostUpdatePage = Pakeisti po atnaujinimų rodomą puslapį „Kas naujo“. Padarykite šią strategiją „blank“, norėdami išjungti po atnaujinimų rodomą puslapį.
policy-PasswordManagerEnabled = Įjungti slaptažodžių įrašymą į slaptažodžių tvarkytuvę.
# PDF.js and PDF should not be translated
policy-PDFjs = Išjungti arba konfigūruoti „PDF.js“, į „{ -brand-short-name }“ integruotą PDF failų žiūryklę.
policy-Permissions2 = Konfigūruoti kameros, mikrofono, buvimo vietos nustatymo, pranešimų ir automatinio grojimo leidimus.
policy-PictureInPicture = Įjungti arba išjungti vaizdą-vaizde.
policy-PopupBlocking = Leisti kai kurioms svetainėms pagal numatymą rodyti iškylančiuosius langus.
policy-Preferences = Nustatykite ir užfiksuokite nuostatų rinkinio reikšmę.
policy-PromptForDownloadLocation = Klausti, kur įrašyti atsiunčiamus failus.
policy-Proxy = Konfigūruoti įgaliotųjų serverių nuostatas.
policy-RequestedLocales = Nustatyti programos prašomų kalbų sąrašo pageidavimo tvarką.
policy-SanitizeOnShutdown2 = Išvalyti navigacijos duomenis išjungimo metu.
policy-SearchBar = Parinkti numatytąją paieškos lauko vietą. Naudotojui vis tiek leidžiama ją keisti.
policy-SearchEngines = Konfigūruoti ieškyklių nuostatas. Ši strategija galima tik prailginto palaikymo laidos (ESR) versijoje.
policy-SearchSuggestEnabled = Įjungti arba išjungti paieškos žodžių siūlymus.
# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Diegti PKCS #11 modulius.
policy-ShowHomeButton = Rodyti pradžios mygtuką priemonių juostoje.
policy-SSLVersionMax = Nustatyti didžiausią SSL versiją.
policy-SSLVersionMin = Nustatyti mažiausią SSL versiją.
policy-SupportMenu = Pridėti specialų pagalbos meniu elementą į žinyno meniu.
policy-UserMessaging = Nerodyti naudotojui tam tikrų pranešimų.
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blokuoti svetainių lankymą. Paskaitykite dokumentaciją dėl informacijos apie formatą.
