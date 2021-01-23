# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Үнсіз келісім бойынша әзірлеуші құралдары

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Ағымдағы құралдар панелінің мақсаты үшін қолдауы жоқ

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Қосымшалармен орнатылған әзірлеуші құралдары

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Қолжетерлік құралдар панелі батырмалары

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Темалар

## Inspector section

# The heading
options-context-inspector = Бақылаушы

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Браузер стильдерін көрсету
options-show-user-agent-styles-tooltip =
    .title = Бұны іске қосу нәтижесінде браузер жүктеген үнсіз келісім стильдері көрсетілетін болады.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = DOM атрибуттарын қысқарту
options-collapse-attrs-tooltip =
    .title = Бақылаушыда ұзын атрибуттарды қысқарту

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Негізгі түс бірлігі
options-default-color-unit-authored = As Authored
options-default-color-unit-hex = Он алтылық
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Түстер аттары

## Style Editor section

# The heading
options-styleeditor-label = Стильдер түзеткіші

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = CSS автотолтыруы
options-stylesheet-autocompletion-tooltip =
    .title = Стильдер түзеткіште CSS қасиеттерді, мәндерді және таңдаушыларды енгізген кезде, оларды автотолтыру

## Screenshot section

# The heading
options-screenshot-label = Скриншот мінез-құлығы

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Алмасу буферіне скриншотты жасау
options-screenshot-clipboard-tooltip =
    .title = Скриншотты тікелей алмасу буферіне сақтайды

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Камера түсіргішінің дыбысын ойнату
options-screenshot-audio-tooltip =
    .title = Скриншотты түсіру кезінде камера түсіру дыбысын іске қосады

## Editor section

# The heading
options-sourceeditor-label = Түзетуші баптаулары

options-sourceeditor-detectindentation-tooltip =
    .title = Бастапқы код құрамасына негізделіп, шегінуді анықтау
options-sourceeditor-detectindentation-label = Шегінуді анықтау
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Жабатын жақшаларды автокірістіру
options-sourceeditor-autoclosebrackets-label = Жақшаларды автожабу
options-sourceeditor-expandtab-tooltip =
    .title = Табуляция орнына бос аралық таңбасын қолдану
options-sourceeditor-expandtab-label = Шегіністі бос аралықтармен жасау
options-sourceeditor-tabsize-label = Табуляция өлшемі
options-sourceeditor-keybinding-label = Пернетақта байланыстары
options-sourceeditor-keybinding-default-label = Бастапқы

## Advanced section

# The heading
options-context-advanced-settings = Кеңейтілген баптаулар

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = HTTP кэшін сөндіру (құралдар панелі ашық кезде)
options-disable-http-cache-tooltip =
    .title = Бұл опцияны іске қосу HTTP кэшін барлық құралдар панелі ашық беттері үшін сөндіреді. Бұл опция Service Workers үшін іске аспайды.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = JavaScript сөндіру *
options-disable-javascript-tooltip =
    .title = Бұл баптауды іске қосу нәтижесінде ағымдағы бетте JavaScript сөндіріледі. Егер бет немесе құралдар панелі жабылса, бұл баптау ұмытылады.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Браузердің chrome және қосымшаларды жөндеу құралдар панельдерін іске қосу
options-enable-chrome-tooltip =
    .title = Бұл баптауды іске қосу (Құралдар > Веб-әзірлеуші > Браузердің құралдар панелі) нәтижесінде сіз браузер контекстінде түрлі әзірлеуші құралдарын қолдана алатын боласыз, және қосымшаларды Қосымшалар Басқарушысынан жөндей алатын боласыз.

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Қашықтан жөндеуді іске қосу
options-enable-remote-tooltip2 =
    .title = Бұл параметрді іске қосу осы браузер экземплярын қашықтан жөндеуге мүмкіндік береді

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = HTTP арқылы жасайтын қызметтік жұмыс үрдістерін іске қосу (құралдар панелі ашық болған кезде)
options-enable-service-workers-http-tooltip =
    .title = Бұл баптауды іске қосу нәтижесінде құралдар панелі ашық тұрған барлық беттер үшін HTTP service workers іске қосылады.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Бастапқы код карталарын іске қосу
options-source-maps-tooltip =
    .title = Бұл опцияны іске қоссаңыз, бастапқы код құралдарда сәйкестелген болады.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Ағымдағы сессия ғана, парақты қайта жүктейді

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Gecko платформасының деректерін көрсету
options-show-platform-data-tooltip =
    .title = Бұл баптауды іске қоссаңыз, JavaScript профильдеуші есептемелерінде Gecko платформа таңбалары болады
