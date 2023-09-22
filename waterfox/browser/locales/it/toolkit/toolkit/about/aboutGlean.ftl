# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### "Glean" and "Glean SDK" should remain in English.

### "FOG", "Glean", and "Glean SDK" should remain in English.

-fog-brand-name = FOG
-glean-brand-name = Glean
glean-sdk-brand-name = { -glean-brand-name } SDK
glean-debug-ping-viewer-brand-name = Visualizzatore ping per il debug di { -glean-brand-name }

about-glean-page-title2 = Informazioni su { -glean-brand-name }
about-glean-header = Informazioni su { -glean-brand-name }
about-glean-interface-description =
  <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name }</a> è una libreria per la raccolta di dati utilizzata nei progetti { -vendor-short-name }. Questa interfaccia è progettata per consentire a sviluppatori e tester di <a data-l10n-name="fog-link">effettuare test manuali della strumentazione</a>.

about-glean-upload-enabled = Il caricamento dei dati è attivo.
about-glean-upload-disabled = Il caricamento dei dati è disattivato.
about-glean-upload-enabled-local = Il caricamento dei dati è attivo solo per l’invio a un server locale.
about-glean-upload-fake-enabled =
  Il caricamento dei dati è disattivato, ma viene fatto credere a { glean-sdk-brand-name } che questo sia attivo, in modo che i dati vengano comunque registrati localmente. Attenzione: se viene impostata un’etichetta di debug, i ping verranno caricati nel <a data-l10n-name="glean-debug-ping-viewer">{ glean-debug-ping-viewer-brand-name }</a> a prescindere dalle impostazioni.

# This message is followed by a bulleted list.
about-glean-prefs-and-defines = <a data-l10n-name="fog-prefs-and-defines-doc-link">Impostazioni e definizioni</a> rilevanti:
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
about-glean-moz-official =<code>MOZILLA_OFFICIAL</code>: { $moz-official-define-value }

about-glean-about-testing-header = Informazioni sui test
# This message is followed by a numbered list.
about-glean-manual-testing =
  Istruzioni dettagliate sono disponibili nella <a data-l10n-name="fog-instrumentation-test-doc-link">documentazione relativa alla strumentazione dei test per { -fog-brand-name }</a> e nella <a data-l10n-name="glean-sdk-doc-link">documentazione di { glean-sdk-brand-name }</a>. In sintesi, per effettuare un test manuale della strumentazione:

# This message is an option in a dropdown filled with untranslated names of pings.
about-glean-no-ping-label = (non inviare alcun ping)
# An in-line text input field precedes this string.
about-glean-label-for-tag-pings =
  Assicurarsi di avere indicato un tag di debug facile da ricordare, in modo da poter riconoscere i ping in seguito.
# An in-line drop down list precedes this string.
# Do not translate strings between <code> </code> tags.
about-glean-label-for-ping-names =
  Selezionare nell’elenco il ping in cui si trova la strumentazione. Se si tratta di un <a data-l10n-name="custom-ping-link">ping personalizzato</a>, selezionarlo nell’elenco. Altrimenti, il valore predefinito per le metriche di tipo <code>event</code> è il ping <code>events</code>, mentre per tutte le altre metriche è il ping <code>metrics</code>.
# An in-line check box precedes this string.
about-glean-label-for-log-pings =
  (Facoltativo: selezionare la casella di controllo per registrare i ping in un log oltre a inviarli. È necessario <a data-l10n-name="enable-logging-link">attivare la registrazione dei log</a>.)
# Variables
#   $debug-tag (String): The user-set value of the debug tag input on this page. Like "about-glean-kV"
# An in-line button labeled "Apply settings and submit ping" precedes this string.
about-glean-label-for-controls-submit =
  Premere il pulsante per aggiungere l’etichetta a tutti i ping { -glean-brand-name } e inviare il ping selezionato. (Tutti i ping inviati da questo momento avranno l’etichetta <code>{ $debug-tag }</code> fino al riavvio dell’applicazione.)
about-glean-li-for-visit-gdpv =
  <a data-l10n-name="gdpv-tagged-pings-link">Visita la pagina del { glean-debug-ping-viewer-brand-name } per vedere i ping con l’etichetta specificata</a>. Dovrebbero trascorrere solo alcuni secondi tra la pressione del pulsante e la ricezione dei ping, ma in alcuni casi potrebbero servire alcuni minuti.

# Do not translate strings between <code> </code> tags.
about-glean-adhoc-explanation =
  Per effettuare test più specifici è possibile determinare il valore corrente di uno specifico elemento della strumentazione aprendo la console degli strumenti di sviluppo in <code>about:glean</code> e utilizzando API <code>testGetValue()</code>, come ad esempio <code>Glean.metricCategory.metricName.testGetValue()</code>.


controls-button-label-verbose = Applica impostazioni e invia ping

# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-glean-about-data-header = Informazioni sui dati
about-glean-about-data-explanation =
  Per sfogliare l’elenco dei dati raccolti, consultare il <a data-l10n-name="glean-dictionary-link">Dizionario { -glean-brand-name }</a>.
