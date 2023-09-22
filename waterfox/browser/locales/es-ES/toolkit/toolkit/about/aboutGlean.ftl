# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### "Glean" and "Glean SDK" should remain in English.

### "FOG", "Glean", and "Glean SDK" should remain in English.

-fog-brand-name = FOG
-glean-brand-name = Glean
glean-sdk-brand-name = { -glean-brand-name } SDK
glean-debug-ping-viewer-brand-name = Visor de ping para la depuración de { -glean-brand-name }

about-glean-page-title2 = Acerca de { -glean-brand-name }
about-glean-header = Acerca de { -glean-brand-name }
about-glean-interface-description =
    El <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name }</a>
    es una biblioteca de recopilación de datos utilizada en proyectos de { -vendor-short-name }.
    Esta interfaz está diseñada para que los desarrolladores y probadores
    <a data-l10n-name="fog-link">prueben manualmente la instrumentación</a>.

about-glean-upload-enabled = La carga de datos está activada.
about-glean-upload-disabled = La carga de datos está desactivada.
about-glean-upload-enabled-local = La carga de datos está activada solo para enviar a un servidor local.
about-glean-upload-fake-enabled =
    La carga de datos está desactivada,
    pero le decimos a { glean-sdk-brand-name } que está activado
    para que los datos se sigan registrando localmente.
    Nota: si establece una etiqueta de depuración, los pings se cargarán en el
    <a data-l10n-name="glean-debug-ping-viewer">{ glean-debug-ping-viewer-brand-name }</a> independientemente de la configuración.

# This message is followed by a bulleted list.
about-glean-prefs-and-defines = Las <a data-l10n-name="fog-prefs-and-defines-doc-link">preferencias y definiciones</a> relevantes incluyen:
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

about-glean-about-testing-header = Acerca de las pruebas
# This message is followed by a numbered list.
about-glean-manual-testing =
    Las instrucciones completas están documentadas en los
    <a data-l10n-name="fog-instrumentation-test-doc-link">documentos de pruebas de instrumentación de { -fog-brand-name }</a>
    y en la <a data-l10n-name="glean-sdk-doc-link">documentación de { glean-sdk-brand-name }</a>,
    pero, en resumen, para probar manualmente que su instrumentación funciona, debe:

# This message is an option in a dropdown filled with untranslated names of pings.
about-glean-no-ping-label = (no enviar ningún ping)
# An in-line text input field precedes this string.
about-glean-label-for-tag-pings = En el campo anterior, asegúrese de que haya una etiqueta de depuración fácil de recordar para que pueda reconocer sus pings más adelante.
# An in-line drop down list precedes this string.
# Do not translate strings between <code> </code> tags.
about-glean-label-for-ping-names =
    Seleccionar en la lista anterior el ping en el que se encuentra su instrumentación.
    Si está en un <a data-l10n-name="custom-ping-link">ping personalizado</a>, elija ése.
    De lo contrario, el valor predeterminado para las métricas de tipo <code>event</code> es
    el ping <code>events</code>
    y el valor predeterminado para todas las demás métricas es
    el ping <code>metrics</code>.
# An in-line check box precedes this string.
about-glean-label-for-log-pings =
    (Opcional. Marque la casilla anterior si desea que los ping también se registren cuando se envíen.
    Además, deberá <a data-l10n-name="enable-logging-link">activar el registro</a>).
# Variables
#   $debug-tag (String): The user-set value of the debug tag input on this page. Like "about-glean-kV"
# An in-line button labeled "Apply settings and submit ping" precedes this string.
about-glean-label-for-controls-submit =
    Presione el botón anterior para etiquetar todos los pings de { -glean-brand-name } con su etiqueta y enviar el ping seleccionado.
    (Todos los ping enviados desde entonces hasta que reinicie la aplicación se etiquetarán con
    <code>{ $debug-tag }</code>.)
about-glean-li-for-visit-gdpv =
    <a data-l10n-name="gdpv-tagged-pings-link">Visite la página { glean-debug-ping-viewer-brand-name } para ver los ping con su etiqueta</a>.
    No debería llevar más de unos pocos segundos desde que se presiona el botón hasta que llega su ping.
    Pero a veces puede tardar algunos minutos.

# Do not translate strings between <code> </code> tags.
about-glean-adhoc-explanation =
    Para más pruebas <i>ad hoc</i>,
    también puede determinar el valor actual de una pieza de instrumentación particular 
    abriendo una consola de herramientas de desarrollo aquí en <code>about:glean</code>
    y usando la API <code>testGetValue()</code> como
    <code>Glean.metricCategory.metricName.testGetValue()</code>.


controls-button-label-verbose = Aplicar ajustes y enviar ping

about-glean-about-data-header = Acerca de los datos
about-glean-about-data-explanation =
    Para navegar por la lista de datos recopilados, consulte el
    <a data-l10n-name="glean-dictionary-link">diccionario { -glean-brand-name }</a>.
