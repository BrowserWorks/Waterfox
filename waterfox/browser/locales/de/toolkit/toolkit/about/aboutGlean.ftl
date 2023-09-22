# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### "Glean" and "Glean SDK" should remain in English.

### "FOG", "Glean", and "Glean SDK" should remain in English.

-fog-brand-name = FOG
-glean-brand-name = Glean
glean-sdk-brand-name = { -glean-brand-name } SDK
glean-debug-ping-viewer-brand-name = { -glean-brand-name }-Debug-Ping-Ansicht

about-glean-page-title2 = Über { -glean-brand-name }
about-glean-header = Über { -glean-brand-name }
about-glean-interface-description =
    Das <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name }</a>
    ist eine Datensammlungsbibliothek, die in { -vendor-short-name }-Projekten verwendet wird.
    Diese Schnittstelle wurde entwickelt, um von Entwicklern und Testern zum
    händischen <a data-l10n-name="fog-link">Testen von Instrumentierung</a> genutzt zu werden.

about-glean-upload-enabled = Das Hochladen von Daten ist aktiviert.
about-glean-upload-disabled = Das Hochladen von Daten ist deaktiviert.
about-glean-upload-enabled-local = Das Hochladen von Daten ist nur zum Senden an einen lokalen Server aktiviert.
about-glean-upload-fake-enabled =
    Das Hochladen von Daten ist deaktiviert.
    Aber wir lügen und sagen dem { glean-sdk-brand-name }, dass es aktiviert ist,
    sodass die Daten trotzdem lokal gespeichert werden.
    Hinweis: Wenn Sie ein Debug-Tag gesetzt haben, werden die Pings  unabhängig von den Einstellungen in der 
    <a data-l10n-name="glean-debug-ping-viewer">{ glean-debug-ping-viewer-brand-name }</a> hochgeladen.

# This message is followed by a bulleted list.
about-glean-prefs-and-defines = Zu den relevanten <a data-l10n-name="fog-prefs-and-defines-doc-link">Einstellungen und Definitionen</a> gehören:
# Variables:
#   $data-upload-pref-value (String): the value of the datareporting.healthreport.uploadEnabled pref. Typically "true", sometimes "false"
# Do not translate strings between <code> </code> tags.
about-glean-data-upload = <code>datareporting.healthreport.uploadEnabled</code>: { $data-upload-pref-value }
# Variables:
#   $local-port-pref-value (Integer): the value of the telemetry.fog.test.localhost_port pref. Typically 0. Can be negative.
# Do not translate strings between <code> </code> tags.
about-glean-local-port = <code>telemetry.fog.test.localhost_port</code>: { $local-port-pref-value }
# Variables:
#   $glean-android-define-value (Boolean): the value of the MOZ_GLEAN_ANDROID define. Typically "false", sometimes "true".
# Do not translate strings between <code> </code> tags.
about-glean-glean-android = <code>MOZ_GLEAN_ANDROID</code>: { $glean-android-define-value }
# Variables:
#   $moz-official-define-value (Boolean): the value of the MOZILLA_OFFICIAL define.
# Do not translate strings between <code> </code> tags.
about-glean-moz-official = <code>MOZILLA_OFFICIAL</code>: { $moz-official-define-value }

about-glean-about-testing-header = Über Testen
# This message is followed by a numbered list.
about-glean-manual-testing =
    Vollständige Anweisungen sind in der
    <a data-l10n-name="fog-instrumentation-test-doc-link">{ -fog-brand-name }-Dokumentation zum Testen der Instrumentierung</a>
    und in der <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name }-Dokumentation</a> beschrieben,
    aber kurz gesagt, um manuell zu testen, ob Ihre Instrumentierung funktioniert, sollten Sie Folgendes tun:

# This message is an option in a dropdown filled with untranslated names of pings.
about-glean-no-ping-label = (keinen Ping senden)
# An in-line text input field precedes this string.
about-glean-label-for-tag-pings = Stellen Sie sicher, dass im vorangehenden Feld ein einprägsames Debug-Tag vorhanden ist, damit Sie Ihre Pings später wiedererkennen können.
# An in-line drop down list precedes this string.
# Do not translate strings between <code> </code> tags.
about-glean-label-for-ping-names =
    Wählen Sie aus der vorhergehenden Liste den Ping, in dem sich Ihre Instrumentierung befindet.
    Wenn sie in einem <a data-l10n-name="custom-ping-link">benutzerdefinierten Ping</a> ist, wählen Sie diesen aus.
    Ansonsten ist der Standard für <code>event</code>-Metriken
    der <code>events</code>-Ping,
    und der Standard für alle anderen Metriken ist
    der <code>metrics</code>-Ping.
# An in-line check box precedes this string.
about-glean-label-for-log-pings =
    (Optional. Aktivieren Sie das vorherige Kästchen, wenn Sie möchten, dass Pings auch protokolliert werden, wenn sie gesendet werden.
    Sie müssen außerdem <a data-l10n-name="enable-logging-link">Protokollierung aktivieren</a>.)
# Variables
#   $debug-tag (String): The user-set value of the debug tag input on this page. Like "about-glean-kV"
# An in-line button labeled "Apply settings and submit ping" precedes this string.
about-glean-label-for-controls-submit =
    Drücken Sie die vorherige Schaltfläche, um alle { -glean-brand-name }-Pings mit Ihrem Tag zu markieren und den ausgewählten Ping zu senden.
    (Alle Pings, die von da an bis zum Neustart der Anwendung gesendet werden, werden mit <code>{ $debug-tag }</code> gekennzeichnet.)
about-glean-li-for-visit-gdpv =
    <a data-l10n-name="gdpv-tagged-pings-link">Besuchen Sie die Seite des { glean-debug-ping-viewer-brand-name } für Pings mit Ihrem Tag</a>.
    Es sollte nicht mehr als ein paar Sekunden vom Drücken der Schaltfläche bis zur Ankunft Ihres Pings dauern.
    Manchmal kann es ein paar Minuten dauern.

# Do not translate strings between <code> </code> tags.
about-glean-adhoc-explanation =
    Für weitere <i>Ad-hoc</i>-Tests
    können Sie auch den aktuellen Wert eines bestimmten Teils der Instrumentierung ermitteln,
    indem Sie hier auf <code>about:glean</code> eine devtools-Konsole öffnen
    und die <code>testGetValue()</code>-API wie folgt verwenden:
    <code>Glean.metricCategory.metricName.testGetValue()</code>.


controls-button-label-verbose = Einstellungen übernehmen und Ping senden

about-glean-about-data-header = Über Daten
about-glean-about-data-explanation =
    Um die Liste der gesammelten Daten zu durchsuchen, können Sie das
    <a data-l10n-name="glean-dictionary-link">{ -glean-brand-name }-Wörterbuch</a> lesen.
