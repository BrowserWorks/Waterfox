# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### "Glean" and "Glean SDK" should remain in English.

### "FOG", "Glean", and "Glean SDK" should remain in English.

-fog-brand-name = FOG
-glean-brand-name = Glean
glean-sdk-brand-name = { -glean-brand-name } SDK
glean-debug-ping-viewer-brand-name = Depurador de visualização de ping { -glean-brand-name }

about-glean-page-title2 = Sobre { -glean-brand-name }
about-glean-header = Sobre { -glean-brand-name }
about-glean-interface-description =
    O <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name }</a>
    é uma biblioteca de recolha de dados utilizada em projetos { -vendor-short-name }.
    Este interface foi projetado para ser utilizado por programadores e testadores para
    <a data-l10n-name="fog-link">testar instrumentação</a> manualmente.

about-glean-upload-enabled = O carregamento de dados está ativado.
about-glean-upload-disabled = O carregamento de dados está desativado.
about-glean-upload-enabled-local = O carregamento de dados está ativo apenas para o envio para um servidor local.
about-glean-upload-fake-enabled =
    O carregamento de dados está desativado,
    mas estamos a mentir e a dizer que { glean-sdk-brand-name } está ativo
    para que os dados possam ser registados localmente.
    Observação: se você definir uma etiqueta de depuração, os pings serão enviados para o
    <a data-l10n-name="glean-debug-ping-viewer">{ glean-debug-ping-viewer-brand-name }</a> independentemente das configurações.

# This message is followed by a bulleted list.
about-glean-prefs-and-defines = As <a data-l10n-name="fog-prefs-and-defines-doc-link">preferências e definições</a> relevantes incluem:
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

about-glean-about-testing-header = Sobre os testes
# This message is followed by a numbered list.
about-glean-manual-testing =
    As instruções completas estão documentadas na
    <a data-l10n-name="fog-instrumentation-test-doc-link">documentação de teste de instrumentação { -fog-brand-name } </a>
    e na <a data-l10n-name="glean-sdk-doc-link">documentação do { glean-sdk-brand-name }</a>,
    mas, resumindo, para verificar manualmente se a sua instrumentação funciona, você deve:

# This message is an option in a dropdown filled with untranslated names of pings.
about-glean-no-ping-label = (não enviar qualquer ping)
# An in-line text input field precedes this string.
about-glean-label-for-tag-pings = No campo anterior, certifique-se que existe uma etiqueta de depuração memorável para que você possa reconhecer os seus pings mais tarde.
# An in-line drop down list precedes this string.
# Do not translate strings between <code> </code> tags.
about-glean-label-for-ping-names =
    Selecione na lista anterior o ping no qual se encontra a sua instrumentação.
    Se estiver num <a data-l10n-name="custom-ping-link">ping personalizado</a>, escolha esse.
    Caso contrário, a predefinição para métricas de <code>evento</code> é
    o ping <code>events</code>
    e o padrão para todas as outras métricas é
    o ping <code>metrics</code>.
# An in-line check box precedes this string.
about-glean-label-for-log-pings =
    (Opcional. Marque a caixa anterior se quiser que os pings também sejam registados quando forem enviados.
    Além disto, irá precisar de <a data-l10n-name="enable-logging-link">ativar o registo</a>.)
# Variables
#   $debug-tag (String): The user-set value of the debug tag input on this page. Like "about-glean-kV"
# An in-line button labeled "Apply settings and submit ping" precedes this string.
about-glean-label-for-controls-submit =
    Pressione o botão anterior para marcar todos os pings de { -glean-brand-name } com a sua etiqueta e envie o ping selecionado.
    (Todos os pings enviados até reiniciar a aplicação serão marcados com
    <code>{ $debug-tag }</code>.)
about-glean-li-for-visit-gdpv =
    <a data-l10n-name="gdpv-tagged-pings-link">Visite a página { glean-debug-ping-viewer-brand-name } para consultar os pings com a sua etiqueta</a>.
    Não deve demorar mais do que alguns segundos desde o momento em que ativar o botão, até o seu ping chegar.
    Por vezes, pode demorar alguns minutos.

# Do not translate strings between <code> </code> tags.
about-glean-adhoc-explanation =
    Para mais testes <i>ad hoc</i>,
    também pode determinar o valor atual de uma determinada peça de instrumentação
    abrindo uma consola devtools em <code>about:glean</code>
    e utilizando a API <code>testGetValue()</code> como
    <code>Glean.metricCategory.metricName.testGetValue()</code>.


controls-button-label-verbose = Aplicar configurações e enviar ping

about-glean-about-data-header = Sobre os dados
about-glean-about-data-explanation =
    Para navegar na lista de dados recolhidos, consulte o
    <a data-l10n-name="glean-dictionary-link">Dicionário { -glean-brand-name }</a>.
