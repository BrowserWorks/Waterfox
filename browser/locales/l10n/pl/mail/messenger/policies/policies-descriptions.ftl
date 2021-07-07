# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Ustawienie zasad, do których rozszerzenia WebExtension mają dostęp przez „chrome.storage.managed”.

policy-AppAutoUpdate = Włączenie lub wyłączenie automatycznego aktualizowania aplikacji.

policy-AppUpdateURL = Ustawienie niestandardowego adresu URL aktualizacji programu.

policy-Authentication = Konfiguracja zintegrowanego uwierzytelniania dla witryn, które je obsługują.

policy-BlockAboutAddons = Blokowanie dostępu do menedżera dodatków (about:addons).

policy-BlockAboutConfig = Blokowanie dostępu do strony about:config.

policy-BlockAboutProfiles = Blokowanie dostępu do strony about:profiles.

policy-BlockAboutSupport = Blokowanie dostępu do strony about:support.

policy-CaptivePortal = Włączenie lub wyłączenie obsługi portalu przechwytującego.

policy-CertificatesDescription = Dodawanie certyfikatów lub używanie wbudowanych.

policy-Cookies = Zezwalanie lub zabranianie witrynom ustawiania ciasteczek.

policy-DisabledCiphers = Wyłączenie szyfrów.

policy-DefaultDownloadDirectory = Ustawienie domyślnego katalogu pobierania.

policy-DisableAppUpdate = Uniemożliwienie aktualizowania programu { -brand-short-name }.

policy-DisableDefaultClientAgent = Uniemożliwienie agentowi domyślnego klienta wykonywania jakichkolwiek działań. Dotyczy tylko systemu Windows, inne platformy nie mają agenta.

policy-DisableDeveloperTools = Blokowanie dostępu do narzędzi dla twórców witryn.

policy-DisableFeedbackCommands = Wyłączenie poleceń do wysyłania opinii z menu Pomoc („Prześlij swoją opinię” i „Zgłoś oszustwo internetowe”).

policy-DisableForgetButton = Wyłączenie dostępu do przycisku „Wyczyść”.

policy-DisableFormHistory = Wyłączenie zachowywania historii wyszukiwania i formularzy.

policy-DisableMasterPasswordCreation = Wartość „prawda” powoduje, że nie można utworzyć hasła głównego.

policy-DisablePasswordReveal = Wyłączenie możliwości wyświetlania haseł w zachowanych danych logowania.

policy-DisableProfileImport = Wyłączenie polecenia menu do importowania danych z innego programu.

policy-DisableSafeMode = Wyłączenie funkcji ponownego uruchomienia w trybie awaryjnym. Uwaga: użycie klawisza Shift do przejścia do trybu awaryjnego można wyłączyć w systemie Windows tylko za pomocą Group Policy.

policy-DisableSecurityBypass = Uniemożliwienie użytkownikowi obejścia pewnych ostrzeżeń bezpieczeństwa.

policy-DisableSystemAddonUpdate = Uniemożliwienie programowi { -brand-short-name } instalowania i aktualizowania dodatków systemowych.

policy-DisableTelemetry = Wyłączenie telemetrii.

policy-DisplayMenuBar = Domyślne wyświetlanie paska menu.

policy-DNSOverHTTPS = Konfiguracja DNS poprzez HTTPS.

policy-DontCheckDefaultClient = Wyłączenie sprawdzania domyślnego klienta podczas uruchamiania.

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

policy-HardwareAcceleration = Wartość „fałsz” wyłącza przyspieszanie sprzętowe.

policy-InstallAddonsPermission = Zezwalanie pewnym witrynom na instalowanie dodatków.

policy-LegacyProfiles = Wyłączenie funkcji wymuszającej oddzielny profil dla każdej instalacji.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Włączenie domyślnego ustawienia starego zachowania ciasteczek „sameSite”.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Wracanie do starego zachowania „sameSite” dla ciasteczek na podanych witrynach.

##

policy-LocalFileLinks = Zezwalanie podanym witrynom na odnośniki do lokalnych plików.

policy-NetworkPrediction = Włączenie lub wyłączenie przewidywania sieci (wstępnego pobierania DNS).

policy-OfferToSaveLogins = Wymuszenie ustawienia zezwalającego programowi { -brand-short-name } pytanie o zapamiętanie zachowanych danych logowania i haseł. Przyjmowane są wartości „prawda” i „fałsz”.

policy-OfferToSaveLoginsDefault = Ustawienie domyślnej wartości ustawienia zezwalającego programowi { -brand-short-name } pytanie o zapamiętanie zachowanych danych logowania i haseł. Przyjmowane są wartości „prawda” i „fałsz”.

policy-OverrideFirstRunPage = Zastąpienie strony pierwszego uruchomienia. Ustawienie tej zasady na pustą wyłączy stronę pierwszego uruchomienia.

policy-OverridePostUpdatePage = Zastąpienie strony „Co nowego” wyświetlanej po aktualizacji. Ustawienie tej zasady na pustą wyłączy stronę wyświetlaną po aktualizacji.

policy-PasswordManagerEnabled = Włączenie zachowywania haseł w menedżerze haseł.

# PDF.js and PDF should not be translated
policy-PDFjs = Wyłączenie lub konfiguracja PDF.js, wbudowanej przeglądarki plików PDF w programie { -brand-short-name }.

policy-Permissions2 = Konfiguracja uprawnień kamery, mikrofonu, położenia, powiadomień i automatycznego odtwarzania.

policy-Preferences = Ustawienie i zablokowanie wartości dla podzbioru preferencji.

policy-PromptForDownloadLocation = Pytanie, gdzie zapisywać pliki podczas pobierania.

policy-Proxy = Konfiguracja ustawień proxy.

policy-RequestedLocales = Ustawienie listy żądanych języków dla programu w preferowanej kolejności.

policy-SanitizeOnShutdown2 = Usuwanie danych nawigacji podczas wyłączania.

policy-SearchEngines = Konfiguracja ustawień wyszukiwarki. Ta zasada jest dostępna tylko w wersji ESR (Extended Support Release).

policy-SearchSuggestEnabled = Włączenie lub wyłączenie podpowiedzi wyszukiwania.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Instalacja modułów PKCS #11.

policy-SSLVersionMax = Ustawienie maksymalnej wersji SSL.

policy-SSLVersionMin = Ustawienie minimalnej wersji SSL.

policy-SupportMenu = Dodanie niestandardowego elementu menu pomocy.

policy-UserMessaging = Wyłączenie wyświetlania użytkownikowi pewnych komunikatów.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Blokowanie odwiedzania witryn. Dokumentacja zawiera więcej informacji o formacie.
