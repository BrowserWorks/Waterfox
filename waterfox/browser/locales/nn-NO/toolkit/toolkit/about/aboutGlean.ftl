# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### "Glean" and "Glean SDK" should remain in English.

### "FOG", "Glean", and "Glean SDK" should remain in English.

-fog-brand-name = FOG
-glean-brand-name = Glean
glean-sdk-brand-name = { -glean-brand-name } SDK
glean-debug-ping-viewer-brand-name = Ping-visar for { -glean-brand-name }-feilsøking

about-glean-page-title2 = Om { -glean-brand-name }
about-glean-header = Om { -glean-brand-name }
about-glean-interface-description =
    <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name }</a>
    er eit datainnsamlingsbibliotek som vert brukt i { -vendor-short-name }-prosjekt.
    Dette grensesnittet er designa for å brukast av utviklarar og testarar for å manuelt
    <a data-l10n-name="fog-link">teste instrumentering</a>.

about-glean-upload-enabled = Dataopplasting er aktivert.
about-glean-upload-disabled = Dataopplasting er deaktivert.
about-glean-upload-enabled-local = Dataopplasting er berre aktivert for sending til ein lokal server.
about-glean-upload-fake-enabled =
    Dataopplasting er deaktivert,
    men vi lyg og fortel { glean-sdk-brand-name } at det er aktivert
    slik at data framleis vert registrert lokalt.
    Merk: Dersom du spesifiserer ein feilsøkingskode, vil ping bli lasta opp til
    <a data-l10n-name="glean-debug-ping-viewer">{ glean-debug-ping-viewer-brand-name }</a> uavhengig av innstillingar.

# This message is followed by a bulleted list.
about-glean-prefs-and-defines = Relevante <a data-l10n-name="fog-prefs-and-defines-doc-link">innstillingar og definisjonar</a> inkluderer:
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

about-glean-about-testing-header = Om testing
# This message is followed by a numbered list.
about-glean-manual-testing =
    Fullstendige instruksjonar er dokumentert i
    <a data-l10n-name="fog-instrumentation-test-doc-link">{ -fog-brand-name } instrumenteringstestdokument</a>
    og i <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name }-dokumentasjonen</a>,
    men kort sagt, for å manuelt teste at instrumenteringa fungerer, bør du:

# This message is an option in a dropdown filled with untranslated names of pings.
about-glean-no-ping-label = (ikkje send inn ping)
# An in-line text input field precedes this string.
about-glean-label-for-tag-pings = Sørg for at det i det føregåande feltet er ein feilsøkingskode som du kan hugse, slik at du kan kjenne att pinga dine seinare.
# An in-line drop down list precedes this string.
# Do not translate strings between <code> </code> tags.
about-glean-label-for-ping-names =
    Vel pinget frå den føregåande lista, som inneheld instrumenteringa di.
    Dersom det er eit <a data-l10n-name="custom-ping-link">tilpassa ping</a>, så vel det.
    Elles er standardverdien for <code>hendings</code>-berekningar
    <code>hendingar</code>-pinga
    og standard for alle andre målingar er
    <code>metrics</code>-pinget.
# An in-line check box precedes this string.
about-glean-label-for-log-pings =
    (Valfritt. Kryss av i den føregåande boksen dersom du vil at pinga også skal loggast når dei vert sende inn.
    Du må i tillegg <a data-l10n-name="enable-logging-link">aktivere logging</a>.)
# Variables
#   $debug-tag (String): The user-set value of the debug tag input on this page. Like "about-glean-kV"
# An in-line button labeled "Apply settings and submit ping" precedes this string.
about-glean-label-for-controls-submit =
    Trykk på den føregåande knappen for å merke alle { -glean-brand-name }-pinga med taggen din og sende inn det valde pinget.
    (Alle ping som vert sende inn frå då og til du startar applikasjonen på nytt, vil bli merkte med
    <code>{ $debug-tag }</code>.)
about-glean-li-for-visit-gdpv =
    <a data-l10n-name="gdpv-tagged-pings-link">Besøk sida { glean-debug-ping-viewer-brand-name } for ping med taggen din</a>.
    Det bør ikkje ta meir enn nokre få sekund frå du trykkjer på knappen til pinget ditt kjem.
    Nokre gongar kan det ta nokre minutt.

# Do not translate strings between <code> </code> tags.
about-glean-adhoc-explanation =
    For meir <i>ad hoc</i>-testing,
    kan du òg bestemme gjeldande verdi for eit bestemt instrument
    ved å opne ein devtools-konsoll her på <code>about:glean</code>
    og bruke <code>testGetValue()</code> API som
    <code>Glean.metricCategory.metricName.testGetValue()</code>.


controls-button-label-verbose = Bruk innstillingar og send inn ping

about-glean-about-data-header = Om data
about-glean-about-data-explanation =
    For å sjå gjennom lista over innsamla data, sjå
    <a data-l10n-name="glean-dictionary-link">{ -glean-brand-name }-ordbok</a>.
