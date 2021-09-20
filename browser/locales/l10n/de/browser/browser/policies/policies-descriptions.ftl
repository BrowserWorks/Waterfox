# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Für WebExtensions mittels chrome.storage.managed zugängliche Richtlinien festlegen
policy-AllowedDomainsForApps = Domains festlegen, die auf Google Workspace zugreifen dürfen
policy-AppAutoUpdate = Automatische Anwendungsaktualisierung aktivieren oder deaktivieren
policy-AppUpdateURL = Anwendungsaktualisierung über benutzerdefinierte Adresse festlegen
policy-Authentication = Integrierte Authentifizierung für Websites, welche dies unterstützen, konfigurieren
policy-AutoLaunchProtocolsFromOrigins = Eine Liste externer Protokolle festlegen, die von aufgelisteten Quellen verwendet werden können, ohne den Benutzer zu fragen
policy-BackgroundAppUpdate2 = Hintergrundaktualisierung aktivieren oder deaktivieren
policy-BlockAboutAddons = Add-ons-Verwaltung-Seitenzugriff (about:addons) blockieren
policy-BlockAboutConfig = about:config-Seitenzugriff (erweiterte Einstellungen ohne Dokumentation) blockieren
policy-BlockAboutProfiles = about:profiles-Seitenzugriff (Profilverwaltung) blockieren
policy-BlockAboutSupport = about:support-Seitenzugriff (Informationen zur Fehlerbehebung) blockieren
policy-Bookmarks = Lesezeichen erstellen in der Lesezeichen-Symbolleiste, im Lesezeichen-Menü oder in einem vorgegebenen Ordner in diesen
policy-CaptivePortal = Erkennung von Anmelde- oder Bestätigungspflicht für Internetzugriff aktivieren oder deaktivieren
policy-CertificatesDescription = Zertifikate hinzufügen oder eingebaute Zertifikate verwenden
policy-Cookies = Cookies setzen durch Websites erlauben oder verbieten
policy-DisabledCiphers = Chiffren deaktivieren
policy-DefaultDownloadDirectory = Standardordner für Downloads festlegen
policy-DisableAppUpdate = Browser-Updates deaktivieren
policy-DisableBuiltinPDFViewer = Eingebauten PDF-Betrachter von { -brand-short-name } (PDF.js) deaktivieren
policy-DisableDefaultBrowserAgent = Aktionen des Programms zur Erkennung des Standardbrowser deaktivieren. Findet nur auf Windows Anwendung, da andere Betriebssysteme nicht über dieses Programm verfügen.
policy-DisableDeveloperTools = Zugriff auf Entwicklerwerkzeuge deaktivieren
policy-DisableFeedbackCommands = Feedback senden über "Hilfe"-Menü deaktivieren ("Feedback senden…" und "Betrügerische Website melden…")
policy-DisableFirefoxAccounts = { -fxaccount-brand-name }-basierte Dienste (z.B. Sync) deaktivieren
# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = "Firefox Screenshots"-Funktion deaktivieren
policy-DisableFirefoxStudies = { -brand-short-name } keine Studien durchführen lassen
policy-DisableForgetButton = Zugriff auf "Vergessen"-Schaltfläche verhindern
policy-DisableFormHistory = Formular- und Suchchronik nicht speichern
policy-DisableMasterPasswordCreation = Master-Passwort kann nicht erstellt werden, falls true
policy-DisablePrimaryPasswordCreation = Hauptpasswort kann nicht erstellt werden, falls true
policy-DisablePasswordReveal = Option zur Klartextanzeige von Passwörtern in gespeicherten Zugangsdaten deaktivieren
policy-DisablePocket = Pocket als Speicherliste für Webseiten deaktivieren
policy-DisablePrivateBrowsing = Privates Surfen deaktivieren
policy-DisableProfileImport = Datenimport aus anderen Browsern (Menüeintrag) deaktivieren
policy-DisableProfileRefresh = "{ -brand-short-name } bereinigen"-Schaltfläche in Hilfeseite "Informationen zur Fehlerbehebung" (about:support) deaktivieren
policy-DisableSafeMode = Neustart in den Abgesicherten Modus deaktivieren. Hinweis: Das Starten in den Abgesicherten Modus mittels der Umschalt-Taste in Windows kann nur per Festlegung als Gruppenrichtlinie deaktiviert werden.
policy-DisableSecurityBypass = Umgehen einiger Sicherheitswarnungen durch Benutzer deaktivieren
policy-DisableSetAsDesktopBackground = "Als Hintergrundbild einrichten"-Menüeintrag deaktivieren
policy-DisableSystemAddonUpdate = Installieren und Aktualisieren von System-Add-ons durch den Browser deaktivieren
policy-DisableTelemetry = Datenerhebung zur Verbesserung von Firefox (Telemetrie) deaktivieren
policy-DisplayBookmarksToolbar = Lesezeichen-Symbolleiste standardmäßig anzeigen
policy-DisplayMenuBar = Menüleiste standardmäßig anzeigen
policy-DNSOverHTTPS = DNS über HTTPS einrichten
policy-DontCheckDefaultBrowser = Standardbrowser-Überprüfung beim Start nicht durchführen
policy-DownloadDirectory = Ordner für Downloads festlegen und Änderung dieser Einstellung verbieten
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Seitenelementeblockierung aktivieren oder deaktivieren und optional deren Änderung verbieten
# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Encrypted Media Extensions (Module zur Wiedergabe verschlüsselter Mediendateien) aktivieren oder deaktivieren und optional Änderung dieser Einstellung verbieten
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Installieren, Deinstallieren oder Fixieren von Erweiterungen. Die Install-Option akzeptiert Adressen und Pfade als Werte. Die Uninstall- und Locked-Optionen erfordern Erweiterungs-IDs.
policy-ExtensionSettings = Alle Einstellungen für die Erweiterungsinstallation verwalten
policy-ExtensionUpdate = Automatische Add-on-Updates aktivieren oder deaktivieren
policy-FirefoxHome = Waterfox-Startseite konfigurieren
policy-FlashPlugin = Flash-Plugin-Verwendung erlauben oder verbieten
policy-Handlers = Standardanwendungen für das Öffnen von Dateien, Protokollen und MIME-Typen festlegen
policy-HardwareAcceleration = Hardwarebeschleunigung deaktiviert, falls false
# “lock” means that the user won’t be able to change this setting
policy-Homepage = Startseite festlegen und optional zusätzlich unveränderbar setzen
policy-InstallAddonsPermission = Add-on-Installation von festgelegten Websites erlauben
policy-LegacyProfiles = Erzwingen eines eigenen Profils für jede Installation deaktivieren

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Veraltetes Cookie-Verhalten "SameSite" aktivieren
policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Veraltetes Cookie-Verhalten "SameSite" auf angegebenen Websites aktivieren

##

policy-LocalFileLinks = Festgelegten Websites Zugriff auf lokale Dateien erlauben
policy-ManagedBookmarks = Eine Liste von Lesezeichen festlegen, die von einem Administrator verwaltet wird und vom Benutzer nicht geändert werden kann.
policy-MasterPassword = Benutzung eines Master-Passworts erfordern oder verhindern
policy-ManualAppUpdateOnly = Nur manuelle Updates erlauben und den Benutzer nicht über Updates benachrichtigen.
policy-PrimaryPassword = Benutzung eines Hauptpassworts erfordern oder verhindern
policy-NetworkPrediction = Spekulative DNS-Abfragen für noch nicht angeforderte Ressourcen ("DNS-Prefetching") aktivieren oder deaktivieren
policy-NewTabPage = Startseite für neue Tabs aktivieren oder deaktivieren
policy-NoDefaultBookmarks = Standardlesezeichen von { -brand-short-name } und Intelligente Lesezeichenordner ("Meistbesucht", "Kürzlich verwendete Schlagwörter") nicht erstellen. Hinweis: Diese Richtlinie findet nur Anwendung, wenn sie vor dem ersten Ausführen des Profils aktiv wurde.
policy-OfferToSaveLogins = Frage zum Speichern von Zugangsdaten durch { -brand-short-name } anzeigen. Die Werte true und false werden akzeptiert.
policy-OfferToSaveLoginsDefault = Standardwert, ob Nachfrage zum Speichern von Zugangsdaten und Passwörtern in { -brand-short-name } angezeigt werden soll. Sowohl true als auch false sind gültige Werte.
policy-OverrideFirstRunPage = Einmalig geöffnete Einführungsseite beim Starten eines neuen Profils festlegen. Ein leerer Wert deaktiviert das Öffnen der Seite.
policy-OverridePostUpdatePage = Waterfox-Neuigkeiten-Seite - angezeigt nach Programmaktualisierung - festlegen. Ein leerer Wert deaktiviert das Öffnen der Seite.
policy-PasswordManagerEnabled = Speichern von Passwörtern in der Passwortverwaltung aktivieren
# PDF.js and PDF should not be translated
policy-PDFjs = Eingebauten PDF-Betrachter von { -brand-short-name } (PDF.js) deaktivieren oder konfigurieren
policy-Permissions2 = Berechtigungen für Kamera, Mikrofon, Standort, Benachrichtigungen und automatische Wiedergabe festlegen
policy-PictureInPicture = Bild-im-Bild-Modus aktivieren oder deaktivieren
policy-PopupBlocking = Popups für festgelegte Websites standardmäßig anzeigen
policy-Preferences = Werte von bestimmten Einstellungen festlegen und Änderungen daran verhindern
policy-PromptForDownloadLocation = Für gestartete Downloads nach Speicherort fragen
policy-Proxy = Proxy-Einstellungen festlegen
policy-RequestedLocales = Sprachen für die Anwendungsoberfläche in bevorzugter Reihenfolge festlegen
policy-SanitizeOnShutdown2 = Navigationsdaten beim Beenden löschen
policy-SearchBar = Standardposition der Suchleiste setzen. Der Benutzer darf sie weiterhin anpassen.
policy-SearchEngines = Suchmaschineneinstellungen anpassen. Diese Richtlinie ist nur für Versionen des Extended Support Release (ESR) verfügbar.
policy-SearchSuggestEnabled = Suchvorschläge aktivieren oder deaktivieren
# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = PKCS#11-Module installieren
policy-ShowHomeButton = Schaltfläche "Startseite" in der Symbolleiste anzeigen
policy-SSLVersionMax = Höchste zu verwendende SSL-Version festlegen
policy-SSLVersionMin = Niedrigste zu verwendende SSL-Version festlegen
policy-SupportMenu = Benutzerdefinierten Eintrag zum Menü "Hilfe" hinzufügen
policy-UserMessaging = Anzeige von bestimmten Nachrichten deaktivieren
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Bestimmte Website-Aufrufe blockieren. Weitere Details in der Dokumentation.
