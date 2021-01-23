# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Ezarri politikak WebExtension gehigarriek chrome.storage.managed bidez sarbidea izan dezaten.

policy-AppAutoUpdate = Gaitu edo desgaitu aplikazioaren eguneraketa automatikoa.

policy-AppUpdateURL = Ezarri aplikazioa-eguneraketen URL pertsonalizatua

policy-Authentication = Konfiguratu onartzen duten webguneentzat integratutako autentifikazioa.

policy-BlockAboutAddons = Blokeatu gehigarrien kudeatzailerako sarbidea (about:addons).

policy-BlockAboutConfig = Blokeatu about:config orrirako sarbidea.

policy-BlockAboutProfiles = Blokeatu about:profiles orrirako sarbidea.

policy-BlockAboutSupport = Blokeatu about:support orrirako sarbidea.

policy-CaptivePortal = Gaitu edo desgaitu atari gatibuen euskarria.

policy-CertificatesDescription = Ziurtagiriak gehitzea edo integratutako ziurtagiriak erabiltzea.

policy-Cookies = Baimendu edo ukatu webguneei cookieak ezartzea.

policy-DisabledCiphers = Desgaitu zifratzeak.

policy-DefaultDownloadDirectory = Ezarri deskarga-direktorio lehenetsia.

policy-DisableAppUpdate = Eragotzi { -brand-short-name }(r)i eguneratzea.

policy-DisableDefaultClientAgent = Eragotzi lehenetsitako bezero agenteak ekintzarik egitea. Windowsen bakarrik; beste plataformek ez dute agentea.

policy-DisableDeveloperTools = Blokeatu garatzaile-tresnetarako sarbidea.

policy-DisableFeedbackCommands = Desgaitu iritzia bidaltzeko komandoak 'Laguntza' menutik ('Bidali iritzia' eta 'Eman gune iruzurtiaren berri').

policy-DisableForgetButton = Eragotzi 'Ahaztu' botoirako sarbidea.

policy-DisableFormHistory = Ez gogoratu bilaketa- eta inprimaki-historia.

policy-DisableMasterPasswordCreation = Ezarrita badago, ezingo da pasahitz nagusia sortu.

policy-DisablePasswordReveal = Ez baimendu gordetako saio-hasieretan pasahitzak agerraraztea.

policy-DisableProfileImport = Desgaitu beste aplikazio batetik datuak inportatzeko menu-komandoa.

policy-DisableSafeMode = Desgaitu modu seguruan berrabiarazteko eginbidea. Oharra: modu segurura sartzeko shift tekla sakatzea Windowsen desgai daiteke soilik, talde-gidalerroak erabilita.

policy-DisableSecurityBypass = Eragotzi erabiltzaileak zenbait segurtasun-abisu saihestea.

policy-DisableSystemAddonUpdate = Eragotzi { -brand-short-name } sistemaren gehigarriak instalatzea eta eguneratzea.

policy-DisableTelemetry = Itzali telemetria.

policy-DisplayMenuBar = Bistaratu lehenespenez menu-barra.

policy-DNSOverHTTPS = Konfiguratu HTTPS gaineko DNSa.

policy-DontCheckDefaultClient = Desgaitu abioan bezero lehenetsia egiaztatzea.

policy-DownloadDirectory = Ezarri eta blokeatu deskarga-direktorioa.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Gaitu edo desgaitu edukia blokeatzea eta blokeatu ezarpen hau.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Gaitu edo desgaitu Encrypted Media Extensions eta aukeran blokeatu ezarpen hau.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instalatu, desinstalatu edo blokeatu hedapenak. Instalatzeko aukerak URLak edo bide-izenak hartzen ditu parametro gisa. Desinstalatzeko eta blokeatzeko aukerek, berriz, hedapen-IDak.

policy-ExtensionSettings = Kudeatu hedapenen instalazioko arlo guztiak.

policy-ExtensionUpdate = Gaitu edo desgaitu hedapenen eguneraketa automatikoa.

policy-HardwareAcceleration = Ez badago ezarrita, hardware-azelerazioa desgaituko da.

policy-InstallAddonsPermission = Baimendu zenbait webgunek gehigarriak instalatzea.

policy-LegacyProfiles = Desgaitu instalazio bakoitzerako profil bereiziak behartzen dituen eginbidea

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Gaitu lehenetsitako SameSite cookie portaera zaharraren ezarpena.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Leheneratu SameSite portaera zaharrera zehaztutako guneetako cookientzat.

##

policy-LocalFileLinks = Baimendu gune zehatzei fitxategi lokalen loturak egitea.

policy-NetworkPrediction = Gaitu edo desgaitu sarearen iragarpena (DNS aurre-eskuratzea).

policy-OfferToSaveLogins = Behartu { -brand-short-name }(e)k gordetako saio-hasierak eta pasahitzak gogoratzea eskaintzeko ezarpena. Ezarrita eta ezarri gabeko balioak onartzen dira.

policy-OfferToSaveLoginsDefault = Ezarri balio lehenetsia { -brand-short-name }(e)k gordetako saio-hasierak eta pasahitzak gogoratzea eskaintzeko. Ezarrita eta ezarri gabeko balioak onartzen dira.

policy-OverrideFirstRunPage = Gainidatzi lehen abioko orria. Utzi zurian politika hau lehen abioko orria desgaitu nahi baduzu.

policy-OverridePostUpdatePage = Gainidatzi eguneraketen ondoko "Nobedadeak" orria. Utzi politika hau zurian eguneraketen ondoko orria desgaitu nahi baduzu.

policy-PasswordManagerEnabled = Gaitu pasahitzak pasahitz-kudeatzailean gordetzea.

# PDF.js and PDF should not be translated
policy-PDFjs = Desgaitu edo konfiguratu PDF.js, { -brand-short-name }(r)en integratutako PDF ikustailea.

policy-Permissions2 = Konfiguratu kamera, mikrofonoa, kokapena, jakinarazpenak eta erreprodukzio automatikoa erabiltzeko baimenak.

policy-Preferences = Ezarri eta blokeatu hobespen-azpimultzo baten balioak.

policy-PromptForDownloadLocation = Galdetu non gorde deskargatutako fitxategiak.

policy-Proxy = Konfiguratu proxy-ezarpenak.

policy-RequestedLocales = Ezarri aplikazioari eskatuko zaizkion hizkuntza-kodeen zerrenda, hobetsitakoen arabera ordenatuta.

policy-SanitizeOnShutdown2 = Garbitu nabigazio datuak itzaltzean.

policy-SearchEngines = Konfiguratu bilaketa-motorren ezarpenak. Politika hau Extended Support Release (ESR) bertsiorako dago erabilgarri soilik.

policy-SearchSuggestEnabled = Gaitu edo desgaitu bilaketa-iradokizunak.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalatu PKCS #11 moduluak.

policy-SSLVersionMax = Ezarri gehienezko SSL bertsioa.

policy-SSLVersionMin = Ezarri gutxieneko SSL bertsioa.

policy-SupportMenu = Gehitu euskarrirako menu-elementu pertsonalizatua laguntzaren menuan.

policy-UserMessaging = Ez erakutsi zenbait mezu erabiltzaileari.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blokeatu zenbait webgune bisitatzea. Irakurri dokumentazioa formatuaren gaineko xehetasun gehiagorako.
