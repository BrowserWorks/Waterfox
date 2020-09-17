# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Setează politicile pe care WebExtensions le pot accesa prin chrome.storage.managed.

policy-AppAutoUpdate = Activează sau dezactivează actualizarea automată a aplicației.

policy-AppUpdateURL = Setează un URL personalizat de actualizare a aplicației.

policy-Authentication = Configurează autentificarea integrată pentru site-urile web care o acceptă.

policy-BlockAboutAddons = Blochează accesul la managerul de suplimente (about:addons).

policy-BlockAboutConfig = Blochează accesul la pagina about:config.

policy-BlockAboutProfiles = Blochează accesul la pagina about:profiles.

policy-BlockAboutSupport = Blochează accesul la pagina about:support.

policy-Bookmarks = Creează marcaje în bara de marcaje, în meniul de marcaje sau într-un dosar specificat din ele.

policy-CaptivePortal = Activează sau dezactivează suportul pentru portaluri captive.

policy-CertificatesDescription = Adaugă certificate sau folosește certificate încorporate.

policy-Cookies = Permite sau blochează setarea de cookie-uri de către site-urile web.

policy-DisabledCiphers = Dezactivează cifrurile.

policy-DefaultDownloadDirectory = Setează directorul implicit de descărcare.

policy-DisableAppUpdate = Împiedică actualizarea browserului.

policy-DisableBuiltinPDFViewer = Dezactivează PDF.js, lectorul de fișiere PDF încorporat în { -brand-short-name }.

policy-DisableDefaultBrowserAgent = Împiedică agentul implicit de browser să ia orice măsură. Aplicabil numai pentru Windows; alte platforme nu au agentul.

policy-DisableDeveloperTools = Blochează accesul la uneltele de dezvoltare.

policy-DisableFeedbackCommands = Dezactivează comenzile de trimis feedback în meniul de Ajutor (Trimite feedback și Raportează site-uri înșelătoare).

policy-DisableFirefoxAccounts = Dezactivează serviciile pe bază necesare pentru { -fxaccount-brand-name }, inclusiv Sync

# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Dezactivează funcționalitatea de capturi de ecran din Firefox.

policy-DisableFirefoxStudies = Împiedică efectuarea de studii de către { -brand-short-name }.

policy-DisableForgetButton = Împiedică accesul la butonul de uitare.

policy-DisableFormHistory = Nu memora istoricul căutărilor și al formularelor.

policy-DisableMasterPasswordCreation = Dacă este activat, nu se poate crea o parolă generală.

policy-DisablePrimaryPasswordCreation = Dacă valoarea este adevărată, nu se poate crea o parolă primară.

policy-DisablePasswordReveal = Nu permite dezvăluirea parolelor din datele de autentificare salvate.

policy-DisablePocket = Dezactivează funcționalitatea de salvare a paginilor web în Pocket.

policy-DisablePrivateBrowsing = Dezactivează navigarea privată.

policy-DisableProfileImport = Dezactivează comanda de meniu pentru importul de date din alte browsere.

policy-DisableProfileRefresh = Dezactivează butonul de reîmprospătare { -brand-short-name } în pagina about:support.

policy-DisableSafeMode = Dezactivează funcționalitatea de repornire în Modul sigur. Obs: Tasta Shift de intrare în Modul sigur poate fi dezactivată numai în Windows, folosind Politica de grup.

policy-DisableSecurityBypass = Împiedică utilizatorul să ocolească anumite avertismente de securitate.

policy-DisableSetAsDesktopBackground = Dezactivează comanda de meniu de setare ca fundal pe desktop pentru imagini.

policy-DisableSystemAddonUpdate = Împiedică browserul să instaleze și să actualizeze suplimente de sistem.

policy-DisableTelemetry = Dezactivează telemetria.

policy-DisplayBookmarksToolbar = Afișează implicit bara de marcaje.

policy-DisplayMenuBar = Afișează implicit bara de meniu.

policy-DNSOverHTTPS = Configurează DNS prin HTTPS.

policy-DontCheckDefaultBrowser = Dezactivează verificarea de browser implicit la pornire.

policy-DownloadDirectory = Setează și blochează directorul de descărcare.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Activează sau dezactivează blocarea conținutului și, opțional, blochează opțiunea.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Activează sau dezactivează extensiile media criptate și, opțional, poți bloca opțiunea.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instalează, dezinstalează sau blochează extensii. Opțiunea de instalare ia URL-urile sau căile drept parametri. Opțiunile Dezinstalează și Blocată iau ID-uri de extensii.

policy-ExtensionSettings = Gestionează toate aspectele de instalare a extensiilor.

policy-ExtensionUpdate = Activează sau dezactivează actualizările automate de extensii.

policy-FirefoxHome = Configurează pagina de start Firefox.

policy-FlashPlugin = Permite sau respinge utilizarea pluginului Flash.

policy-Handlers = Configurează gestionarii aplicațiilor implicite.

policy-HardwareAcceleration = Dacă este dezactivat, oprește accelerarea hardware.

# “lock” means that the user won’t be able to change this setting
policy-Homepage = Setează și, opțional, blochează pagina de start.

policy-InstallAddonsPermission = Permite anumitor site-uri web să instaleze suplimente.

policy-LegacyProfiles = Dezactivează funcționalitatea care forțează crearea unui profil separat pentru fiecare versiune instalată.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Activează setarea implicită pentru comportamentul cookie-urilor SameSite moștenite.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Revenire la comportamentul moștenit al atributului SameSite pentru cookie-uri de pe site-urile specificate.

##

policy-LocalFileLinks = Permite anumitor site-uri web să se lege la fișiere locale.

policy-MasterPassword = Necesită sau împiedică folosirea unei parole generale.

policy-PrimaryPassword = Necesită sau împiedică folosirea unei parole primare.

policy-NetworkPrediction = Activează sau dezactivează predicția de rețea (prelectură DNS).

policy-NewTabPage = Activează sau dezactivează pagina Filă nouă.

policy-NoDefaultBookmarks = Dezactivează crearea marcajelor implicite care vin la pachet cu { -brand-short-name } și crearea de marcaje inteligente (Cele mai vizitate, Etichete recente). Obs: politica produce efecte numai dacă este folosită înainte de prima utilizare a profilului.

policy-OfferToSaveLogins = Impune setarea care permite { -brand-short-name } să se ofere să țină minte datele de autentificare și parolele salvate. Sunt acceptate atât valoarea de adevărat, cât și cea de fals.

policy-OfferToSaveLoginsDefault = Setează valoarea implicită ca să permiți { -brand-short-name } să se ofere să rețină datele de autentificare și parolele salvate. Sunt acceptate atât valori adevărate, cât și false.

policy-OverrideFirstRunPage = Anulează pagina de întâmpinare la prima utilizare. Lasă politica goală dacă vrei să dezactivezi pagina de întâmpinare la prima utilizare.

policy-OverridePostUpdatePage = Anulează pagina „Noutăți” după actualizare. Lasă politica goală dacă vrei să dezactivezi pagina post-actualizare.

policy-PasswordManagerEnabled = Activează salvarea parolelor în managerul de parole.

# PDF.js and PDF should not be translated
policy-PDFjs = Dezactivează sau configurează PDF.js, lectorul PDF încorporat în { -brand-short-name }.

policy-Permissions2 = Configurează permisiunile pentru cameră, microfon, locație, notificări și redare automată.

policy-PictureInPicture = Activează sau dezactivează vizualizarea imagine-în-imagine.

policy-PopupBlocking = Permite anumitor site-uri web să afișeze implicit ferestre pop-up.

policy-Preferences = Setează și blochează valoarea pentru un subset de preferințe.

policy-PromptForDownloadLocation = Întreabă unde să fie salvate fișierele la descărcare.

policy-Proxy = Configurează setările proxy.

policy-RequestedLocales = Setează lista de limbi solicitate de aplicație, în ordinea preferinței.

policy-SanitizeOnShutdown2 = Șterge datele de navigare la închidere.

policy-SearchBar = Setează locația implicită în bara de căutare. Utilizatorul are în continuare posibilitatea de personalizare.

policy-SearchEngines = Configurează setările motorului de căutare. Politica este disponibilă numai în versiunea Ediție cu suport extins (ERS).

policy-SearchSuggestEnabled = Activează sau dezactivează sugestiile de căutare.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalează module PKCS #11.

policy-SSLVersionMax = Setează versiunea maximă SSL.

policy-SSLVersionMin = Setează versiunea minimă SSL.

policy-SupportMenu = Adaugă un element personalizat din meniul de asistență în meniul Ajutor.

policy-UserMessaging = Nu afișa anumite mesaje utilizatorului.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blochează intrarea pe site-uri web. Vezi documentația pentru detalii suplimentare despre format.
