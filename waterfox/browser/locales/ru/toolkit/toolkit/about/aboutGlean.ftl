# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### "Glean" and "Glean SDK" should remain in English.

### "FOG", "Glean", and "Glean SDK" should remain in English.

-fog-brand-name = FOG
-glean-brand-name = Glean
glean-sdk-brand-name = { -glean-brand-name } SDK
glean-debug-ping-viewer-brand-name = Просмотр отладочных пингов { -glean-brand-name }

about-glean-page-title2 = О { -glean-brand-name }
about-glean-header = О { -glean-brand-name }
about-glean-interface-description =
    <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name }</a>
    — это библиотека для сбора данных, используемая в проектах { -vendor-short-name }.
    Этот интерфейс предназначен для использования разработчиками и тестировщиками, чтобы вручную <a data-l10n-name="fog-link">тестировать инструментарий</a>.

about-glean-upload-enabled = Выгрузка данных включена.
about-glean-upload-disabled = Выгрузка данных отключена.
about-glean-upload-enabled-local = Выгрузка данных включена только для отправки на локальный сервер.
about-glean-upload-fake-enabled =
    Выгрузка данных отключена,
    но мы лжём и говорим { glean-sdk-brand-name }, что она включена,
    так что данные по-прежнему записываются локально.
    Примечание: если вы установите метку отладки, пинги будут выгружаться в
    <a data-l10n-name="glean-debug-ping-viewer">{ glean-debug-ping-viewer-brand-name }</a> независимо от настроек.

# This message is followed by a bulleted list.
about-glean-prefs-and-defines = Соответствующие <a data-l10n-name="fog-prefs-and-defines-doc-link">настройки и определения</a> включают:
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

about-glean-about-testing-header = О тестировании
# This message is followed by a numbered list.
about-glean-manual-testing =
    Полные инструкции задокументированы в
    <a data-l10n-name="fog-instrumentation-test-doc-link">документах по тестированию инструментария { -fog-brand-name }</a>
    и в <a data-l10n-name="glean-sdk-doc-link">документации { glean-sdk-brand-name }</a>,
    но, вкратце, чтобы вручную проверить работу вашего инструментария, вы должны:

# This message is an option in a dropdown filled with untranslated names of pings.
about-glean-no-ping-label = (не отправлять никаких пингов)
# An in-line text input field precedes this string.
about-glean-label-for-tag-pings = В предыдущем поле убедитесь, что установлен запоминающийся тег отладки, чтобы вы смогли позже распознать свои пинги.
# An in-line drop down list precedes this string.
# Do not translate strings between <code> </code> tags.
about-glean-label-for-ping-names =
    Выберите из предыдущего списка пинг, в котором находится ваш инструментарий.
    Если он находится в <a data-l10n-name="custom-ping-link">пользовательском пинге</a>, выберите его.
    В противном случае по умолчанию для метрик <code>event</code> используется
    пинг <code>events</code>,
    а по умолчанию для всех остальных метрик 
    пинг <code>metrics</code>.
# An in-line check box precedes this string.
about-glean-label-for-log-pings =
    (Необязательно. Установите предыдущий флажок, если вы хотите, чтобы пинги журналировались при их отправке.
    Вам также потребуется <a data-l10n-name="enable-logging-link">включить ведение журнала</a>).
# Variables
#   $debug-tag (String): The user-set value of the debug tag input on this page. Like "about-glean-kV"
# An in-line button labeled "Apply settings and submit ping" precedes this string.
about-glean-label-for-controls-submit =
    Нажмите на предыдущую кнопку, чтобы пометить все пинги { -glean-brand-name } своим тегом и отправить выбранный пинг.
    (Все пинги, отправленные с этого момента до перезапуска приложения, будут помечены тегом <code>{ $debug-tag }</code>).
about-glean-li-for-visit-gdpv =
    <a data-l10n-name="gdpv-tagged-pings-link">Посетите страницу { glean-debug-ping-viewer-brand-name } для работы с пингами с вашим тегом</a>.
    От нажатия кнопки до получения пинга должно пройти не более нескольких секунд.
    Иногда это может занять несколько минут.

# Do not translate strings between <code> </code> tags.
about-glean-adhoc-explanation =
    Для дополнительных <i>ad hoc</i> тестов
    вы также можете определить текущее значение конкретного инструмента
    открыв консоль devtools здесь, на <code>about:glean</code>
    и используя API <code>testGetValue()</code>, например,
    <code>Glean.metricCategory.metricName.testGetValue()</code>.


controls-button-label-verbose = Применить настройки и отправить пинг

about-glean-about-data-header = О данных
about-glean-about-data-explanation =
    Чтобы просмотреть список собранных данных, обратитесь к
    <a data-l10n-name="glean-dictionary-link">{ -glean-brand-name } Словарю</a>.
