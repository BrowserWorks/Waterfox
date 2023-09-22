# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Bei der Übermittlung des Berichts ist ein Fehler aufgetreten. Bitte versuchen Sie es später erneut.
# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Website funktioniert? Bericht senden

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Streng
    .label = Streng
protections-popup-footer-protection-label-custom = Benutzerdefiniert
    .label = Benutzerdefiniert
protections-popup-footer-protection-label-standard = Standard
    .label = Standard

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Weitere Informationen zum verbesserten Schutz vor Aktivitätenverfolgung
protections-panel-etp-on-header = Verbesserter Schutz vor Aktivitätenverfolgung ist für diese Website AKTIVIERT
protections-panel-etp-off-header = Verbesserter Schutz vor Aktivitätenverfolgung ist für diese Website DEAKTIVIERT

## Text for the toggles shown when ETP is enabled/disabled for a given site.
## .description is transferred into a separate paragraph by the moz-toggle
## custom element code.
##   $host (String): the hostname of the site that is being displayed.

protections-panel-etp-on-toggle =
    .label = Verbesserter Tracking-Schutz
    .description = Aktiviert für diese Website
    .aria-label = Schutz für { $host } abschalten
protections-panel-etp-off-toggle =
    .label = Verbesserter Tracking-Schutz
    .description = Deaktiviert für diese Website
    .aria-label = Schutz für { $host } aktivieren
# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Funktioniert die Website nicht richtig?
# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Funktioniert die Website nicht richtig?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Warum?
protections-panel-not-blocking-why-etp-on-tooltip = Das Blockieren könnte Probleme mit Inhalten einiger Websites verursachen. Ohne Skripte zur Aktivitätenverfolgung funktionieren einige Schaltflächen, Formulare und Anmeldefelder vielleicht nicht.
protections-panel-not-blocking-why-etp-off-tooltip = Alle Elemente zur Aktivitätenverfolgung auf dieser Website wurden geladen, da der Schutz deaktiviert ist.

##

protections-panel-no-trackers-found = { -brand-short-name } erkannte keine Skripte zur Aktivitätenverfolgung auf dieser Seite.
protections-panel-content-blocking-tracking-protection = Inhalte zur Aktivitätenverfolgung
protections-panel-content-blocking-socialblock = Skripte zur Aktivitätenverfolgung durch soziale Netzwerke
protections-panel-content-blocking-cryptominers-label = Heimliche Digitalwährungsberechner (Krypto-Miner)
protections-panel-content-blocking-fingerprinters-label = Identifizierer (Fingerprinter)

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Blockiert
protections-panel-not-blocking-label = Erlaubt
protections-panel-not-found-label = Nicht erkannt

##

protections-panel-settings-label = Schutzmaßnahmen-Einstellungen
protections-panel-protectionsdashboard-label = Schutzmaßnahmen-Übersicht

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Deaktivieren Sie die Schutzmaßnahmen, falls es Probleme gibt mit:
# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Anmeldefeldern
protections-panel-site-not-working-view-issue-list-forms = Formularen
protections-panel-site-not-working-view-issue-list-payments = Zahlungen
protections-panel-site-not-working-view-issue-list-comments = Kommentaren
protections-panel-site-not-working-view-issue-list-videos = Videos
protections-panel-site-not-working-view-issue-list-fonts = Schriftarten
protections-panel-site-not-working-view-send-report = Einen Bericht senden

##

protections-panel-cross-site-tracking-cookies = Diese Cookies werden über viele Websites hinweg verwendet und sammeln Informationen über Ihre Online-Aktivitäten. Sie werden durch Drittanbieter wie Werbe- oder Analyseunternehmen gesetzt.
protections-panel-cryptominers = Heimliche Digitalwährungsberechner (Krypto-Miner) verwenden die Rechenleistung Ihres Computers, um digitales Geld zu berechnen. Die dabei verwendeten Skripte verursachen ein schnelles Absinken des Batterieladestands, verlangsamen den Computer und können die Energierechnung in die Höhe treiben.
protections-panel-fingerprinters = Identifizierer (Fingerprinter) sammeln Eigenschaften Ihres Browsers und Computers und erstellen daraus ein Profil. Mit diesem digitalen Fingerabdruck können diese Sie über Websites hinweg verfolgen.
protections-panel-tracking-content = Websites können Werbung, Videos und andere Inhalte mit Skripten zur Aktivitätenverfolgung von anderen Websites laden. Das Blockieren von Inhalten zur Aktivitätenverfolgung ermöglicht es unter Umständen, dass Websites schneller laden, aber einige Schaltflächen, Formulare und Anmeldefelder funktionieren dann eventuell nicht richtig.
protections-panel-social-media-trackers = Auf anderen Websites eingebundene Elemente sozialer Netzwerke (z.B. zum Teilen von Inhalten) können Skripte enthalten, die verfolgen, was Sie online machen, angezeigt bekommen und sich anschauen. Dies ermöglicht den Unternehmen hinter den sozialen Netzwerken, mehr über Sie zu erfahren als allein durch die Inhalte, die Sie mit Ihrem Profil im sozialen Netzwerk teilen.
protections-panel-description-shim-allowed = Die Blockierung von einigen der unten markierten Skripte zur Aktivitätenverfolgung wurde teilweise aufgehoben, weil Sie mit diesen interagiert haben.
protections-panel-description-shim-allowed-learn-more = Weitere Informationen
protections-panel-shim-allowed-indicator =
    .tooltiptext = Blockierung von Skripten zur Aktivitätenverfolgung teilweise aufgehoben
protections-panel-content-blocking-manage-settings =
    .label = Schutzmaßnahmen-Einstellungen verwalten
    .accesskey = E
protections-panel-content-blocking-breakage-report-view =
    .title = Problem mit Website melden
protections-panel-content-blocking-breakage-report-view-description = Das Blockieren bestimmter Skripte zur Aktivitätenverfolgung kann bei einigen Websites zu Problemen führen. Wenn Sie Probleme melden, helfen Sie { -brand-short-name } für alle besser zu machen. Beim Senden des Berichts werden eine Adresse sowie Informationen über Ihre Browser-Einstellungen an BrowserWorks gesendet. <label data-l10n-name="learn-more">Weitere Informationen</label>
protections-panel-content-blocking-breakage-report-view-description2 = Das Blockieren bestimmter Skripte zur Aktivitätenverfolgung kann bei einigen Websites zu Problemen führen. Wenn Sie Probleme melden, helfen Sie { -brand-short-name } für alle besser zu machen. Beim Senden des Berichts werden eine Adresse sowie Informationen über Ihre Browser-Einstellungen an { -vendor-short-name } gesendet.
protections-panel-content-blocking-breakage-report-view-collection-url = Adresse
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = Adresse
protections-panel-content-blocking-breakage-report-view-collection-comments = Freiwillig: Beschreiben Sie das Problem.
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Freiwillig: Beschreiben Sie das Problem.
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Abbrechen
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Bericht senden

# Cookie Banner Handling

protections-panel-cookie-banner-handling-header = Reduzierung von Cookie-Bannern
protections-panel-cookie-banner-handling-enabled = Für diese Website aktiviert
protections-panel-cookie-banner-handling-disabled = Für diese Website deaktiviert
protections-panel-cookie-banner-handling-undetected = Website derzeit nicht unterstützt
protections-panel-cookie-banner-view-title =
    .title = Reduzierung von Cookie-Bannern
# Variables
#  $host (String): the hostname of the site that is being displayed.
protections-panel-cookie-banner-view-turn-off-for-site = Cookie-Banner-Reduzierung für { $host } deaktivieren?
protections-panel-cookie-banner-view-turn-on-for-site = Cookie-Banner-Reduzierung für diese Website aktivieren?
protections-panel-cookie-banner-view-cookie-clear-warning = { -brand-short-name } löscht die Cookies dieser Website und aktualisiert die Seite. Das Löschen aller Cookies kann Sie abmelden oder Warenkörbe leeren.
protections-panel-cookie-banner-view-turn-on-description = { -brand-short-name } versucht, alle Cookie-Anforderungen auf unterstützten Websites automatisch abzulehnen.
protections-panel-cookie-banner-view-cancel = Abbrechen
protections-panel-cookie-banner-view-turn-off = Deaktivieren
protections-panel-cookie-banner-view-turn-on = Aktivieren
