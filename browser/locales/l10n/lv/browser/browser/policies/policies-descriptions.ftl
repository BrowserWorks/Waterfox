# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-AppUpdateURL = Iestatīs pielāgotu atjaunināšanas adresi

policy-Authentication = Konfigurēt integrēto autentifikāciju lapām, kas to atbalsta.

policy-BlockAboutAddons = Bloķēt piekļuvi papildinājumu pārvaldniekam (about:addons).

policy-BlockAboutConfig = Bloķēt pieeju about:config lapai.

policy-BlockAboutProfiles = Bloķēt pieeju about:profiles lapai.

policy-BlockAboutSupport = Bloķēt pieeju about:support lapai.

policy-Bookmarks = Izveidojiet grāmatzīmes grāmatzīmju rīkjoslā, grāmatzīmju izvēlnē vai konkrētā mapē kādā no šīm vietām.

policy-CertificatesDescription = Pievienojiet sertifikātus vai izmantojiet iebūvētos sertifikātus.

policy-Cookies = Atļaujiet vai aizliedziet vietnēm iestatīt sīkdatnes.

policy-DisableAppUpdate = Neļaut pārlūkam atjaunināties.

policy-DisableBuiltinPDFViewer = Deaktivēt PDF.js, { -brand-short-name } iebūvēto PDF lasītāju.

policy-DisableDeveloperTools = Bloķēt pieeju izstrādātāju rīkiem.

policy-DisableFeedbackCommands = Atspējo komandas, kas var nosūtīt atsauksmes no Palīdzības izvēlnes (Sūtīt atsauksmi un Ziņot par krāpnieku lapu).

policy-DisableFirefoxAccounts = Deaktivē { -fxaccount-brand-name } pakalpojumus, piemēram Sync.

# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Deaktivē Firefox ekrānattēlu rīku.

policy-DisableFirefoxStudies = Liedz { -brand-short-name } veikt pētījumus.

policy-DisableForgetButton = Liedz pieeju Aizmirst pogai.

policy-DisableFormHistory = Neatceras meklēšanu un formu vēsturi.

policy-DisableMasterPasswordCreation = Ja iestatīts, nevar iestatīt galveno paroli.

policy-DisablePocket = Deaktivē iespēju saglabāt lapas Pocket.

policy-DisablePrivateBrowsing = Deaktivē privāto pārūkošanu.

policy-DisableProfileImport = Deaktivē iespēju importēt datus no cita pārlūka.

policy-DisableProfileRefresh = Deaktivē { -brand-short-name } atjaunināšanas pogu  about:support lapā

policy-DisableSafeMode = Deaktivē iespēju pārstartēties drošajā režīmā. Piezēmi: Shift taustiņa lietošanu, lai ieslēgtos drošajā režīmā ir iespējams atslēgt vienīgi Windows platformā.

policy-DisableSecurityBypass = Liedz lietotājam apiet noteiktus drošības brīdinājumus.

policy-DisableSetAsDesktopBackground = Deaktivē attēlu izvēlnes iespēju Iestatīt kā darba virsmas fona attēlu.

policy-DisableSystemAddonUpdate = Liedz pārlūkam atjaunināt un instalēt sistēmas papildinājumus.

policy-DisableTelemetry = Atslēdz telemetriju.

policy-DisplayBookmarksToolbar = Pēc noklusējuma rāda grāmatzīmju rīkjoslu.

policy-DisplayMenuBar = Pēc noklusējuma rāda izvēlnes joslu.

policy-DNSOverHTTPS = DNS konfigurēšana, izmantojot HTTPS.

policy-DontCheckDefaultBrowser = Deaktivē noklusētā pārlūka pārbaudi startējot.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Aktivē vai deaktivē satura bloķēšanu.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs. See also:
# https://github.com/mozilla/policy-templates/blob/master/README.md#extensions-machine-only
policy-Extensions = Instalē, atinstalē vai fiksē papildinājumus. Instalēšanas iespējai ir jānorāda adreses vai sistēmas ceļi. Atinstalēšanas un fiksēšanas iespējai paplašinājuma ID.

policy-FlashPlugin = Atļauj vai lieds Flash spraudņa izmantošanu.

policy-HardwareAcceleration = Ja atslēgts (false), atslēdz aparatūras paātrināšanu.

# “lock” means that the user won’t be able to change this setting
policy-Homepage = Iestata un iespējams fiksē sākuma lapu.

policy-InstallAddonsPermission = Ļauj konkrētām lapām instalēt papildinājumus.

## Do not translate "SameSite", it's the name of a cookie attribute.

##

policy-NoDefaultBookmarks = Deaktivē standarta { -brand-short-name } grāmatzīmju izveidi, piemēram Biežāk izmantotās, Jaunākie tagi. Piezīme: Šī politika būs efektīva vienīgi, ja ir aktivēta pirms pirmās pārlūka palaišanas.

policy-OfferToSaveLogins = Iestata vērtību { -brand-short-name } paroļu saglabāšanas iespējai. Iespējamās vērtības it gan true gan false.

policy-OverrideFirstRunPage = Pārraksta pirmās palaišanas lapu. Iestatiet šeit tukšumu, lai deaktivētu pirmās palaišanas lapu.

policy-OverridePostUpdatePage = Pārraksta pēc atjauninājumu "Kas jauns" lapu. Iestatiet šeit tukšumu, lai deaktivētu šo lapu.

policy-PopupBlocking = Ļaut zināmām lapām pēc noklusējuma rādīt uznirstošos logus.

policy-Proxy = Konfigurē starpniekservera iestatījumus.

policy-RequestedLocales = Iestatiet pieejamo valodu sarakstu prioritātes secībā.

policy-SearchBar = Iestata noklusēto meklēšanas joslas atrašanos. Šis joprojām ļauj lietotājam to mainīt.

policy-SearchEngines = Konfigurē meklētāju iestatījumus. Šī politika ir pieejama vienīgi pagarinātā atbalsta laidienos (ESR).

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalēt PCKS #11 moduļus.

# “format” refers to the format used for the value of this policy. See also:
# https://github.com/mozilla/policy-templates/blob/master/README.md#websitefilter-machine-only
policy-WebsiteFilter = Bloķēt lapu apmeklēšanu. Sīkāka informācija par formātu pieejama dokumentācijā.
