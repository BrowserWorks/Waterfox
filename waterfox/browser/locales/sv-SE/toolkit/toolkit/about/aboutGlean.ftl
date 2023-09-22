# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### "Glean" and "Glean SDK" should remain in English.

### "FOG", "Glean", and "Glean SDK" should remain in English.

-fog-brand-name = FOG
-glean-brand-name = Glean
glean-sdk-brand-name = { -glean-brand-name } SDK
glean-debug-ping-viewer-brand-name = { -glean-brand-name } Felsök Ping Viewer

about-glean-page-title2 = Om { -glean-brand-name }
about-glean-header = Om { -glean-brand-name }
about-glean-interface-description =
    <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name }</a>
    är ett datainsamlingsbibliotek som används i { -vendor-short-name }-projekt.
    Detta gränssnitt är utformat för att användas av utvecklare och testare för att manuellt
    <a data-l10n-name="fog-link">testa instrumentering</a>.

about-glean-upload-enabled = Dataöverföring är aktiverad.
about-glean-upload-disabled = Dataöverföring är inaktiverad.
about-glean-upload-enabled-local = Dataöverföring är endast aktiverad för sändning till en lokal server.
about-glean-upload-fake-enabled =
    Dataöverföring är inaktiverad,
    men vi ljuger och säger till { glean-sdk-brand-name } att det är aktiverat
    så att data fortfarande registreras lokalt.
    Obs: Om du ställer in en debug-tagg kommer pingar att laddas upp till
    <a data-l10n-name="glean-debug-ping-viewer">{ glean-debug-ping-viewer-brand-name }</a> oavsett inställningar.

# This message is followed by a bulleted list.
about-glean-prefs-and-defines = Relevanta <a data-l10n-name="fog-prefs-and-defines-doc-link">inställningar och definitioner</a> inkluderar:
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

about-glean-about-testing-header = Om testning
# This message is followed by a numbered list.
about-glean-manual-testing =
    Fullständiga instruktioner finns dokumenterade i
    <a data-l10n-name="fog-instrumentation-test-doc-link">{ -fog-brand-name } instrumenteringstestdokument</a>
    och i <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name } dokumentationen</a>,
    men kort sagt, för att manuellt testa att din instrumentering fungerar, bör du:

# This message is an option in a dropdown filled with untranslated names of pings.
about-glean-no-ping-label = (skicka inte in någon ping)
# An in-line text input field precedes this string.
about-glean-label-for-tag-pings = Se till att det finns en minnesvärd felsökningstagg i föregående fält så att du kan känna igen dina pingar senare.
# An in-line drop down list precedes this string.
# Do not translate strings between <code> </code> tags.
about-glean-label-for-ping-names =
    Välj från föregående lista i vilken ping din instrumentation finns.
    Om det finns i en <a data-l10n-name="custom-ping-link">anpassad ping</a> väljer du den.
    Annars är standardvärdena för <code>events</code>
    pingen <code>events</code>
    och standard för alla andra mätvärden är
    <code>metrics</code>-pingen.
# An in-line check box precedes this string.
about-glean-label-for-log-pings =
    (Valfritt. Markera föregående ruta om du vill att pingar också ska loggas när de skickas.
    Du måste dessutom <a data-l10n-name="enable-logging-link">aktivera loggning</a>.)
# Variables
#   $debug-tag (String): The user-set value of the debug tag input on this page. Like "about-glean-kV"
# An in-line button labeled "Apply settings and submit ping" precedes this string.
about-glean-label-for-controls-submit =
    Tryck på föregående knapp för att tagga alla { -glean-brand-name } pingar med din tagg och skicka den valda pingen.
    (Alla pingar som skickas in från och med då tills du startar om applikationen kommer att märkas med
    <code>{ $debug-tag }</code>.)
about-glean-li-for-visit-gdpv =
    <a data-l10n-name="gdpv-tagged-pings-link">Besök sidan { glean-debug-ping-viewer-brand-name } för pingar med din tagg</a>.
    Det bör inte ta mer än några sekunder från att du trycker på knappen tills din ping kommer.
    Ibland kan det ta några minuter.

# Do not translate strings between <code> </code> tags.
about-glean-adhoc-explanation =
    För mer <i>ad hoc</i>-tester,
    Du kan också bestämma det aktuella värdet för en viss instrumentering
    genom att öppna en devtools-konsol här på <code>about:glean</code>
    och använda <code>testGetValue()</code> API som
    <code>Glean.metricCategory.metricName.testGetValue()</code>.


controls-button-label-verbose = Tillämpa inställningar och skicka ping

about-glean-about-data-header = Om data
about-glean-about-data-explanation =
    För att bläddra i listan över insamlade data, vänligen konsultera
    <a data-l10n-name="glean-dictionary-link">{ -glean-brand-name } ordbok</a>.
