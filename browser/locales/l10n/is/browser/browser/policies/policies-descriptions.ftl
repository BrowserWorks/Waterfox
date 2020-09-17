# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-AppUpdateURL = Stilla sérsniðna smáforrits uppfærslu slóð.

policy-Authentication = Stilla samþætta auðkenningu fyrir vefsíður sem styðja slíkt.

policy-BlockAboutAddons = Loka aðgangi við viðbótareftirlitið (um: viðbætur).

policy-BlockAboutConfig = Loka aðgangi að about:config síðu.

policy-BlockAboutProfiles = Loka aðgangi að about:profiles síðu.

policy-BlockAboutSupport = Loka aðgangi að about:support síðu.

policy-Bookmarks = Búa til bókamerki í bókamerkjastiku, bókamerkjalistanum eða tiltekinni möppu inni í þeim.

policy-CaptivePortal = Virkja eða slökkva á þjónustuaðgangi.

policy-CertificatesDescription = Bæta við vottorði eða nota innbyggða vottorðið.

policy-Cookies = Leyfa eða hafna vefsvæðum um að stilla smygildi.

policy-DefaultDownloadDirectory = Stilltu sjálfgefna möppu fyrir niðurhal.

policy-DisableAppUpdate = Koma í veg fyrir að vafrinn uppfærist.

policy-DisableBuiltinPDFViewer = Óvirkja PDF.js, innbyggða PDF-lesarann í { -brand-short-name }.

policy-DisableDeveloperTools = Loka aðgangi að þróunartólum.

policy-DisableFeedbackCommands = Slökkva á "Senda viðbrögð" og "Tilkynna villandi síðu" í hjálparvalmyndinni.

policy-DisableFirefoxAccounts = Slökkva á { -fxaccount-brand-name } tengdri þjónustu, m.a. Sync.

# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Slökkva á viðbótinni Firefox skjámyndir.

policy-DisableFirefoxStudies = Hamla aðgang að könnunum frá { -brand-short-name }

policy-DisableForgetButton = Hamla aðgang að Gleyma hnappnum.

policy-DisableFormHistory = Ekki geyma form- og leitarsögu

policy-DisableMasterPasswordCreation = Ef þetta er satt, geturðu ekki búið til aðal lykilorð.

policy-DisablePocket = Slökkva á valkostinum til að geyma vefsíður í Pocket.

policy-DisablePrivateBrowsing = Afvirkja huliðsstillingu

policy-DisableProfileImport = Slökkva á valmyndinni til að flytja inn gögn úr öðrum vafra.

policy-DisableProfileRefresh = Slökkva á Endurhlaða { -brand-short-name } takkanum á about:support siðunni.

policy-DisableSafeMode = Slökkva á endurræsa í Safe Mode. Athugið að aðeins er hægt að slökkva á Shift takkanum til að fara í Safe Mode á Windows með því að nota hópstefnu.

policy-DisableSecurityBypass = Forða notanda frá tilteknum öryggisviðvörunum.

policy-DisableSetAsDesktopBackground = Slökkva á valmyndarskipuninni "Velja forsíðubakgrunn" fyrir myndir.

policy-DisableSystemAddonUpdate = Forða því að vafrinn setji upp og uppfæri kerfisviðbætur.

policy-DisableTelemetry = Slökkva á gagnasöfnun til að bæta Firefox (telemetry)

policy-DisplayBookmarksToolbar = Sýna bókamerkjastikuna sjálfgefið.

policy-DisplayMenuBar = Birta valmyndarstikuna sjálfgefið.

policy-DNSOverHTTPS = Stilla DNS yfir HTTPS.

policy-DontCheckDefaultBrowser = Slökkva á sjálfgefinni athugun um aðalvafra kerfis er við ræsingu.

policy-DownloadDirectory = Stilltu og læstu möppu fyrir niðurhal.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Virkja eða slökkva á Efnablokkun og læsa henni mögulega.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Setja upp, fjarlægja eða læsa fyrir viðbætur. Uppsetningarvalkosturinn samþykkir vefslóðir og leiðir sem breytur. Valkostir um að fjarlægja viðbót eða læstir valkostir krefjast auðkennis viðbótarinnar.

policy-ExtensionSettings = Stjórna öllum uppsetningarþáttum viðbóta.

policy-ExtensionUpdate = Virkja eða slökkva á sjálfvirkri uppfærslu á viðbótum.

policy-FirefoxHome = Stilla Firefox heimasvæðið.

policy-FlashPlugin = Leyfa eða hafna notkun Flash-viðbótarinnar.

policy-HardwareAcceleration = Ef rangt, slökkva á hröðun vélbúnaðar.

# “lock” means that the user won’t be able to change this setting
policy-Homepage = Stilla og loka mögulega heimsíðu.

policy-InstallAddonsPermission = Leyfa ákveðnum vefsíðum að setja upp viðbætur.

## Do not translate "SameSite", it's the name of a cookie attribute.

##

policy-LocalFileLinks = Leyfa tilteknum vefsíðum að tengjast staðbundnum skrám.

policy-NetworkPrediction = Virkja eða slökkva forsögn nets (DNS prefetching).

policy-NewTabPage = Virkja eða slökkva á nýju flipasíðunni.

policy-NoDefaultBookmarks = Slökkva á stöðluðum bókamerkjum meðfylgjandi { -brand-short-name } og frá greindum bókamerkjum (flestar heimsóknir, nýleg meki) Ath. að þessi stefna hefur aðeins áhrif ef það er notað áður en sniðið er notað fyrst.

policy-OfferToSaveLogins = Skoðaðu spurningu um að geyma aðgangsupplýsingar með { -brand-short-name }. Gildin true og false eru bæði gild.

policy-OverrideFirstRunPage = Breyta upphafssíðu. Tómt gildi til að slökkva á opnun síðunnar.

policy-OverridePostUpdatePage = Setja Firefox News síðu - birtist eftir uppfærslu á forritinu. Tómt gildi gerir slökkt á því að opna síðuna.

policy-PopupBlocking = Leyfa tilteknum vefsíðum að birta sprettiglugga að sjálfgefnu.

policy-Preferences = Stilltu og læstu gildið fyrir undirhóp af stillingum.

policy-PromptForDownloadLocation = Spyrðja hvar eigi að vista skrár frá niðurhali.

policy-Proxy = Velja proxy-stillingar

policy-RequestedLocales = Stilla lista yfir tungumál sem óskað er eftir af forritinu, raðað eftir vali.

policy-SanitizeOnShutdown2 = Hreinsa ferilsgögn við lokun.

policy-SearchBar = Stilla sjálfgefna staðsetningu leitarstiku. Notanda er enn leyft að sérsníða hana.

policy-SearchEngines = Stilla leitarvélar. Þessi stefna er aðeins í boði í útgáfu ESR (Extended Support Release).

policy-SearchSuggestEnabled = Virkja eða slökkva á leitarábendingar.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Setja inn PKCS #11 forritseiningar.

policy-SSLVersionMax = Stilltu hámarks SSL útgáfu.

policy-SSLVersionMin = Stilltu lágmarks SSL útgáfuna.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Loka fyrir heimsókn á vefsvæði. Sjá skjöl fyrir frekari upplýsari um snið.
