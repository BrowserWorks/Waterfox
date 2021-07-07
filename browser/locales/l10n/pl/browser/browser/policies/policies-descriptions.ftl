# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Ustawienie zasad, do których rozszerzenia WebExtension mają dostęp przez „chrome.storage.managed”.
policy-AllowedDomainsForApps = Określenie domen, które mają dostęp do Google Workspace.
policy-AppAutoUpdate = Włączenie lub wyłączenie automatycznego aktualizowania aplikacji.
policy-AppUpdateURL = Ustawienie niestandardowego adresu URL aktualizacji programu.
policy-Authentication = Konfiguracja zintegrowanego uwierzytelniania dla witryn, które je obsługują.
policy-AutoLaunchProtocolsFromOrigins = Określenie listy zewnętrznych protokołów, które mogą być używane z wymienionych źródeł bez pytania użytkownika.
policy-BackgroundAppUpdate2 = Włączenie lub wyłączenie aktualizatora w tle.
policy-BlockAboutAddons = Blokowanie dostępu do menedżera dodatków (about:addons).
policy-BlockAboutConfig = Blokowanie dostępu do strony about:config.
policy-BlockAboutProfiles = Blokowanie dostępu do strony about:profiles.
policy-BlockAboutSupport = Blokowanie dostępu do strony about:support.
policy-Bookmarks = Tworzenie zakładek na pasku zakładek, w menu zakładek lub w podanym folderze w powyższych.
policy-CaptivePortal = Włączenie lub wyłączenie obsługi portalu przechwytującego.
policy-CertificatesDescription = Dodawanie certyfikatów lub używanie wbudowanych.
policy-Cookies = Zezwalanie lub zabranianie witrynom ustawiania ciasteczek.
policy-DisabledCiphers = Wyłączenie szyfrów.
policy-DefaultDownloadDirectory = Ustawienie domyślnego katalogu pobierania.
policy-DisableAppUpdate = Uniemożliwienie aktualizowania przeglądarki.
policy-DisableBuiltinPDFViewer = Wyłączenie PDF.js, wbudowanej przeglądarki plików PDF w programie { -brand-short-name }.
policy-DisableDefaultBrowserAgent = Uniemożliwienie agentowi domyślnej przeglądarki wykonywania jakichkolwiek działań. Dotyczy tylko systemu Windows, inne platformy nie mają agenta.
policy-DisableDeveloperTools = Blokowanie dostępu do narzędzi dla twórców witryn.
policy-DisableFeedbackCommands = Wyłączenie poleceń do wysyłania opinii z menu Pomoc („Prześlij swoją opinię” i „Zgłoś oszustwo internetowe”).
policy-DisableFirefoxAccounts = Wyłączenie usług korzystających z { -fxaccount-brand-name(case: "gen", capitalization: "lower") }, w tym synchronizacji.
# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Wyłączenie funkcji Firefox Screenshots.
policy-DisableFirefoxStudies = Uniemożliwienie przeprowadzania badań przez program { -brand-short-name }.
policy-DisableForgetButton = Wyłączenie dostępu do przycisku „Wyczyść”.
policy-DisableFormHistory = Wyłączenie zachowywania historii wyszukiwania i formularzy.
policy-DisableMasterPasswordCreation = Wartość „prawda” powoduje, że nie można utworzyć hasła głównego.
policy-DisablePrimaryPasswordCreation = Wartość „prawda” powoduje, że nie można utworzyć hasła głównego.
policy-DisablePasswordReveal = Wyłączenie możliwości wyświetlania haseł w zachowanych danych logowania.
policy-DisablePocket = Wyłączenie funkcji zachowywania stron w Pocket.
policy-DisablePrivateBrowsing = Wyłączenie trybu prywatnego.
policy-DisableProfileImport = Wyłączenie polecenia menu do importowania danych z innej przeglądarki.
policy-DisableProfileRefresh = Wyłączenie przycisku „Odśwież program { -brand-short-name }” na stronie about:support.
policy-DisableSafeMode = Wyłączenie funkcji ponownego uruchomienia w trybie awaryjnym. Uwaga: użycie klawisza Shift do przejścia do trybu awaryjnego można wyłączyć w systemie Windows tylko za pomocą Group Policy.
policy-DisableSecurityBypass = Uniemożliwienie użytkownikowi obejścia pewnych ostrzeżeń bezpieczeństwa.
policy-DisableSetAsDesktopBackground = Wyłączenie polecenia menu „Ustaw jako tło pulpitu” dla obrazów.
policy-DisableSystemAddonUpdate = Uniemożliwienie przeglądarce instalowania i aktualizowania dodatków systemowych.
policy-DisableTelemetry = Wyłączenie telemetrii.
policy-DisplayBookmarksToolbar = Domyślne wyświetlanie paska zakładek.
policy-DisplayMenuBar = Domyślne wyświetlanie paska menu.
policy-DNSOverHTTPS = Konfiguracja DNS poprzez HTTPS.
policy-DontCheckDefaultBrowser = Wyłączenie sprawdzania domyślnej przeglądarki podczas uruchamiania.
policy-DownloadDirectory = Ustawienie i zablokowanie katalogu pobierania.
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Włączenie lub wyłączenie blokowania treści i opcjonalnie jej blokada.
# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Włączenie lub wyłączenie Encrypted Media Extensions i opcjonalnie ich blokada.
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Instalacja, odinstalowywanie lub blokowanie rozszerzeń. Opcja instalacji przyjmuje adresy URL lub ścieżki jako parametry. Opcje odinstalowywania i blokady przyjmują identyfikatory rozszerzeń.
policy-ExtensionSettings = Zarządzanie wszystkimi aspektami instalacji rozszerzeń.
policy-ExtensionUpdate = Włączenie lub wyłączenie automatycznego aktualizowania rozszerzeń.
policy-FirefoxHome = Konfiguracja strony startowej Firefoksa.
policy-FlashPlugin = Zezwalanie lub zabranianie korzystania z wtyczki Flash.
policy-Handlers = Konfiguracja domyślnych aplikacji obsługujących typy plików.
policy-HardwareAcceleration = Wartość „fałsz” wyłącza przyspieszanie sprzętowe.
# “lock” means that the user won’t be able to change this setting
policy-Homepage = Ustawienie i opcjonalna blokada strony startowej.
policy-InstallAddonsPermission = Zezwalanie pewnym witrynom na instalowanie dodatków.
policy-LegacyProfiles = Wyłączenie funkcji wymuszającej oddzielny profil dla każdej instalacji.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Włączenie domyślnego ustawienia starego zachowania ciasteczek „SameSite”.
policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Wracanie do starego zachowania „SameSite” dla ciasteczek na podanych witrynach.

##

policy-LocalFileLinks = Zezwalanie podanym witrynom na odnośniki do lokalnych plików.
policy-ManagedBookmarks = Ustawienie listy zakładek zarządzanych przez administratora, których użytkownik nie może zmieniać.
policy-MasterPassword = Wymaganie lub uniemożliwienie używania hasła głównego.
policy-ManualAppUpdateOnly = Zezwalanie tylko na aktualizacje ręczne i wyłączenie powiadamiania użytkownika o aktualizacjach.
policy-PrimaryPassword = Wymaganie lub uniemożliwienie używania hasła głównego.
policy-NetworkPrediction = Włączenie lub wyłączenie przewidywania sieci (wstępnego pobierania DNS).
policy-NewTabPage = Włączenie lub wyłączenie strony nowej karty.
policy-NoDefaultBookmarks = Wyłączenie tworzenia domyślnych zakładek dołączonych do przeglądarki { -brand-short-name } oraz dynamicznych zakładek („Często odwiedzane” i „Ostatnio używane etykiety”). Uwaga: ta zasada jest uwzględniana tylko przed pierwszym uruchomieniem profilu.
policy-OfferToSaveLogins = Wymuszenie ustawienia zezwalającego przeglądarce { -brand-short-name } pytanie o zapamiętanie zachowanych danych logowania i haseł. Przyjmowane są wartości „prawda” i „fałsz”.
policy-OfferToSaveLoginsDefault = Ustawienie domyślnej wartości ustawienia zezwalającego programowi { -brand-short-name } pytanie o zapamiętanie zachowanych danych logowania i haseł. Przyjmowane są wartości „prawda” i „fałsz”.
policy-OverrideFirstRunPage = Zastąpienie strony pierwszego uruchomienia. Ustawienie tej zasady na pustą wyłączy stronę pierwszego uruchomienia.
policy-OverridePostUpdatePage = Zastąpienie strony „Co nowego” wyświetlanej po aktualizacji. Ustawienie tej zasady na pustą wyłączy stronę wyświetlaną po aktualizacji.
policy-PasswordManagerEnabled = Włączenie zachowywania haseł w menedżerze haseł.
# PDF.js and PDF should not be translated
policy-PDFjs = Wyłączenie lub konfiguracja PDF.js, wbudowanej przeglądarki plików PDF w programie { -brand-short-name }.
policy-Permissions2 = Konfiguracja uprawnień kamery, mikrofonu, położenia, powiadomień i automatycznego odtwarzania.
policy-PictureInPicture = Włączenie lub wyłączenie funkcji „Obraz w obrazie”.
policy-PopupBlocking = Domyślne zezwalanie pewnym witrynom na otwieranie wyskakujących okien.
policy-Preferences = Ustawienie i zablokowanie wartości dla podzbioru preferencji.
policy-PromptForDownloadLocation = Pytanie, gdzie zapisywać pliki podczas pobierania.
policy-Proxy = Konfiguracja ustawień proxy.
policy-RequestedLocales = Ustawienie listy żądanych języków dla programu w preferowanej kolejności.
policy-SanitizeOnShutdown2 = Usuwanie danych nawigacji podczas wyłączania.
policy-SearchBar = Ustawienie domyślnego położenia paska wyszukiwania. Użytkownik nadal może go konfigurować.
policy-SearchEngines = Konfiguracja ustawień wyszukiwarki. Ta zasada jest dostępna tylko w wersji ESR (Extended Support Release).
policy-SearchSuggestEnabled = Włączenie lub wyłączenie podpowiedzi wyszukiwania.
# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalacja modułów PKCS #11.
policy-ShowHomeButton = Wyświetlanie przycisku strony domowej na pasku narzędzi.
policy-SSLVersionMax = Ustawienie maksymalnej wersji SSL.
policy-SSLVersionMin = Ustawienie minimalnej wersji SSL.
policy-SupportMenu = Dodanie niestandardowego elementu menu pomocy.
policy-UserMessaging = Wyłączenie wyświetlania użytkownikowi pewnych komunikatów.
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blokowanie odwiedzania witryn. Dokumentacja zawiera więcej informacji o formacie.
