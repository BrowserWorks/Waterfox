# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Gosod polisïau y gall WebExtensions gael mynediad atyn nhw trwy chrome.storage.managed.

policy-AppAutoUpdate = Galluogi neu analluogi diweddariad rhaglen awtomatig.

policy-AppUpdateURL = Gosod URL diweddaru ap cyfaddas.

policy-Authentication = Ffurfweddu dilysu integredig ar gyfer gwefannau sy'n ei gefnogi.

policy-BlockAboutAddons = Rhwystro mynediad i'r Rheolwr Ychwanegion (about:addons).

policy-BlockAboutConfig = Rhwystro mynediad i dudalen about:config.

policy-BlockAboutProfiles = Rhwystro mynediad i dudalen about:profiles.

policy-BlockAboutSupport = Rhwystro mynediad i dudalen about:support.

policy-CaptivePortal = Galluogi neu analluogi cefnogaeth porth caeth.

policy-CertificatesDescription = Ychwanegu dystysgrifau neu ddefnyddio dystysgrifau mewnol.

policy-Cookies = Caniatáu neu rwystro gwefannau rhag gosod cwcis.

policy-DisabledCiphers = Analluogi seifferau.

policy-DefaultDownloadDirectory = Gosod y cyfeiriadur llwytho i lawr rhagosodedig.

policy-DisableAppUpdate = Rhwystro { -brand-short-name } rhag diweddaru.

policy-DisableDefaultClientAgent = Atal asiant y cleient rhagosodedig rhag cymryd unrhyw gamau. Dim ond yn berthnasol i Windows; nid oes gan lwyfannau eraill yr asiant.

policy-DisableDeveloperTools = Rhwystro mynediad i offer datblygwr.

policy-DisableFeedbackCommands = Analluogi gorchmynion anfon adborth o'r ddewislen Cymorth (Cyflwyno Adborth ac Adrodd ar Wefan Dwyllodrus).

policy-DisableForgetButton = Rhwystro mynediad i'r botwm Anghofio.

policy-DisableFormHistory = Peidio cofio chwilio a hanes ffurflenni.

policy-DisableMasterPasswordCreation = Os true, nid oes modd creu prif gyfrinair.

policy-DisablePasswordReveal = Peidio gadael i gyfrineiriau gael eu datgelu mewn mewngofnodion wedi'u cadw.

policy-DisableProfileImport = Analluogi'r gorchymyn dewislen i Fewnforio data o raglen arall.

policy-DisableSafeMode = Analluogi'r nodwedd i ailgychwyn yn y Modd Diogel. Sylw: dim ond drwy Bolisi Grŵp Windows y mae modd analluogi'r defnydd o fysell Shift i fynd i'r Modd Diogel.

policy-DisableSecurityBypass = Rhwystro'r defnyddiwr rhag osgoi rhai rhybuddion diogelwch.

policy-DisableSystemAddonUpdate = Rhwystro { -brand-short-name } rhag gosod a diweddaru ychwanegion y system.

policy-DisableTelemetry = Diffodd Telemetreg.

policy-DisplayMenuBar = Dangos y Bar Dewislen drwy ragosodiad.

policy-DNSOverHTTPS = FFurfweddu DNS dros HTTPS

policy-DontCheckDefaultClient = Analluogi gwirio am gleient rhagosodedig wrth gychwyn.

policy-DownloadDirectory = Gosod a chloi'r cyfeiriadur llwytho i lawr.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Galluogi neu analluogi Rhwystro Cynnwys ac o ddewis ei gloi.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Galluogi neu analluogi Estyniadau Cyfryngau Amgryptiedig a'i gloi o ddewis.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Gosod, dadosod neu gloi estyniadau. Mae'r dewis gosod yn cymryd URL neu lwybrau fel paramedrau. Mae'r dewisiadau Dadosod a Chloi yn cymryd dynodiad estyniadau.

policy-ExtensionSettings = Rheoli pob agwedd ar osod estyniad.

policy-ExtensionUpdate = Galluogi neu analluogi diweddariadau awtomatig estyniad.

policy-HardwareAcceleration = Os false, diffoddwch gyflymder y caledwedd.

policy-InstallAddonsPermission = Caniatáu i wefannau penodol osod ychwanegion.

policy-LegacyProfiles = Analluoga'r nodwedd gan orfodi proffil ar wahân ar gyfer pob gosodiad.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Galluogi gosodiad ymddygiad rhagosodedig y cwci SameSite blaenorol.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Dychwelyd i'r ymddygiad SameSite blaenorol ar gyfer cwcis ar wefannau penodol.

##

policy-LocalFileLinks = Caniatáu i wefannau penodol gysylltu â ffeiliau lleol.

policy-NetworkPrediction = Galluogi neu analluogi rhagfynegiad rhwydwaith (DNS prefetching).

policy-OfferToSaveLogins = Gorfodi'r gosodiad i ganiatáu i { -brand-short-name } gynnig cofio mewngofnodion a chyfrineiriau wedi eu cadw. Mae gwerthoedd gwir a gau'n cael eu derbyn.

policy-OfferToSaveLoginsDefault = Gosod y gwerth rhagosodedig ar gyfer caniatáu i { -brand-short-name } gynnig cofio mewngofnodion a chyfrineiriau wedi'u cadw. Mae gwerthoedd gwir a ffug yn cael eu derbyn.

policy-OverrideFirstRunPage = Diystyru y dudalen rhediad gyntaf. Gosod y polisi hwn i gwag os ydych am analluogi'r dudalen rhediad cyntaf.

policy-OverridePostUpdatePage = Diystyru'r dudalen ôl ddiweddaru "Beth sy'n Newydd". Gosodwch y polisi hwn i gwag os hoffech chi analluogi'r dudalen ôl ddiweddaru.

policy-PasswordManagerEnabled = Galluogi cadw cyfrineiriau i'r rheolwr cyfrinair.

# PDF.js and PDF should not be translated
policy-PDFjs = Analluogi neu ffurfweddu PDF.js, darllenydd PDF mewnol { -brand-short-name }.

policy-Permissions2 = Ffurfweddu caniatâd ar gyfer camera, meicroffon, lleoliad, hysbysiadau ac awtochwarae.

policy-Preferences = Gosod a chloi'r gwerth ar gyfer is-set o ddewisiadau.

policy-PromptForDownloadLocation = Gofynnwch ble i arbed ffeiliau wrth eu llwytho i lawr.

policy-Proxy = Ffurfweddi gosodiadau dirprwyol.

policy-RequestedLocales = Gosod y rhestr o locales gofynnol ar gyfer y rhaglen yn ôl eich trefn dewis.

policy-SanitizeOnShutdown2 = Clirio data llywio wrth gau.

policy-SearchEngines = Ffurfweddu gosodiadau peiriannau chwilio. Dim ond yn y fersiwn Extended Support Release (ESR) mae'r polisi hwn ar gael.

policy-SearchSuggestEnabled = Galluogi neu analluogi awgrymiadau chwilio.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Gosod modiwlau PKCS#11.

policy-SSLVersionMax = Gosod y fersiwn SSL uchaf.

policy-SSLVersionMin = Gosodwch y fersiwn SSL leiaf.

policy-SupportMenu = Ychwanegu eitem dewislen cymorth cyfaddas i'r ddewislen gymorth.

policy-UserMessaging = Peidio dangos rhai negeseuon i'r defnyddiwr.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Rhwystro gwefannau rhag derbyn ymweliadau. Gw. dogfennaeth am ragor o wybodaeth ar y fformat.
