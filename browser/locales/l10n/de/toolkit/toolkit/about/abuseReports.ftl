# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title.
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Meldung über { $addon-name }

abuse-report-title-extension = Erweiterung melden an { -vendor-short-name }
abuse-report-title-theme = Theme melden an { -vendor-short-name }
abuse-report-subtitle = Was ist das Problem?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = von <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Sind Sie nicht sicher, was Sie auswählen sollen?
    <a data-l10n-name="learnmore-link">Erfahren Sie mehr über das Melden von Erweiterungen und Themes.</a>

abuse-report-submit-description = Beschreiben Sie das Problem (freiwillig)
abuse-report-textarea =
    .placeholder = Details erlauben es uns, einfacher etwas gegen das Problem zu unternehmen. Bitte beschreiben Sie, was passiert ist oder wo das Problem liegt. Vielen Dank, dass Sie mit uns das Web gesund halten.
abuse-report-submit-note =
    Hinweis: Fügen Sie keine persönlichen Informationen (wie Name, E-Mail-Adresse, Telefonnummer, Postadresse) hinzu.
    { -vendor-short-name } speichert die Meldungen dauerhaft.

## Panel buttons.

abuse-report-cancel-button = Abbrechen
abuse-report-next-button = Weiter
abuse-report-goback-button = Zurück
abuse-report-submit-button = Absenden

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

## Message bars descriptions.
##
## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Senden der Meldung für <span data-l10n-name="addon-name">{ $addon-name }</span> wurde abgebrochen.
abuse-report-messagebar-submitting = Meldung für <span data-l10n-name="addon-name">{ $addon-name }</span> wird gesendet…
abuse-report-messagebar-submitted = Vielen Dank für das Senden der Meldung. Soll <span data-l10n-name="addon-name">{ $addon-name }</span> entfernt werden?
abuse-report-messagebar-submitted-noremove = Vielen Dank für das Senden der Meldung.
abuse-report-messagebar-removed-extension = Vielen Dank für das Senden der Meldung. Sie haben die Erweiterung <span data-l10n-name="addon-name">{ $addon-name }</span> entfernt.
abuse-report-messagebar-removed-theme = Vielen Dank für das Senden der Meldung. Sie haben das Theme <span data-l10n-name="addon-name">{ $addon-name }</span> entfernt.
abuse-report-messagebar-error = Beim Senden der Meldung über <span data-l10n-name="addon-name">{ $addon-name }</span> trat ein Fehler auf.
abuse-report-messagebar-error-recent-submit = Die Meldung für <span data-l10n-name="addon-name">{ $addon-name }</span> wurde nicht gesendet, da kürzlich eine andere Meldung dafür übermittelt wurde.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Ja, entfernen
abuse-report-messagebar-action-keep-extension = Nein, behalten
abuse-report-messagebar-action-remove-theme = Ja, entfernen
abuse-report-messagebar-action-keep-theme = Nein, behalten
abuse-report-messagebar-action-retry = Erneut versuchen
abuse-report-messagebar-action-cancel = Abbrechen

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Es hat meinen Computer beschädigt oder meine Daten kompromittiert
abuse-report-damage-example = Beispiel: Installiert Malware oder stiehlt Daten

abuse-report-spam-reason-v2 = Es enthält Spam oder fügt unerwünschte Werbung ein
abuse-report-spam-example = Beispiel: Fügt Werbung zu Webseiten hinzu

abuse-report-settings-reason-v2 = Es hat meine Suchmaschine oder die Startseite beim Start von Waterfox oder eines neuen Tabs geändert, ohne mich darüber zu informieren oder um Erlaubnis zu bitten
abuse-report-settings-suggestions = Sie können Folgendes versuchen, bevor Sie die Erweiterung melden:
abuse-report-settings-suggestions-search = Ändern Sie die Standardsucheinstellungen
abuse-report-settings-suggestions-homepage = Ändern Sie die Startseiten für den Start von Waterfox oder eines neuen Tabs

abuse-report-deceptive-reason-v2 = Es täuscht vor, etwas zu sein, das es nicht ist
abuse-report-deceptive-example = Beispiel: Irreführende Beschreibung oder Bilder

abuse-report-broken-reason-extension-v2 = Es funktioniert nicht, verursacht Probleme mit Websites oder verlangsamt { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Es funktioniert nicht oder verursacht Probleme mit der Browser-Darstellung
abuse-report-broken-example = Beispiel: Das Programm reagiert langsam auf Befehle und ist schwierig zu verwenden oder funktioniert nicht; Teile von Webseiten laden nicht oder sehen nicht wie erwartet aus
abuse-report-broken-suggestions-extension =
    Vermutlich haben Sie ein Problem mit der Erweiterung erkannt. Damit es behoben wird, sollten Sie zusätzlich zum Senden der Meldung hier die Entwickler der Erweiterung kontaktieren.
    Besuchen Sie die <a data-l10n-name="support-link">Homepage der Erweiterung</a>, um Informationen dafür zu erhalten.
abuse-report-broken-suggestions-theme =
    Vermutlich haben Sie ein Problem mit dem Theme erkannt. Damit es behoben wird, sollten Sie zusätzlich zum Senden der Meldung hier die Entwickler des Themes kontaktieren.
    Besuchen Sie die <a data-l10n-name="support-link">Homepage des Themes</a>, um Informationen dafür zu erhalten.

abuse-report-policy-reason-v2 = Es enthält hasserfüllte, gewalttätige oder illegale Inhalte
abuse-report-policy-suggestions =
    Hinweis: Probleme bezüglich des Urheberrechts oder der Verletzung von Marken müssen in einem eigenen Prozess gemeldet werden.
    Folgen Sie <a data-l10n-name="report-infringement-link">diesen Anweisungen</a>, um ein derartiges Problem zu melden.

abuse-report-unwanted-reason-v2 = Ich wollte es nie und weiß nicht, wie ich es loswerden kann
abuse-report-unwanted-example = Beispiel: Eine Anwendung hat die Erweiterung ohne meine Erlaubnis installiert.

abuse-report-other-reason = Etwas anderes

