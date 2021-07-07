# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Открыть приватное окно
    .accesskey = о
about-private-browsing-search-placeholder = Поиск в Интернете
about-private-browsing-info-title = Вы в приватном окне
about-private-browsing-info-myths = Распространённые мифы о приватном просмотре
about-private-browsing =
    .title = Поиск в Интернете
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Найдите в { $engine } или введите адрес
about-private-browsing-handoff-no-engine =
    .title = Введите запрос или адрес
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Найдите в { $engine } или введите адрес
about-private-browsing-handoff-text-no-engine = Введите запрос или адрес
about-private-browsing-not-private = Сейчас вы не находитесь в приватном окне.
about-private-browsing-info-description = { -brand-short-name } удаляет историю поиска и просмотра страниц, когда вы выходите из приложения или закрываете все приватные вкладки и окна. Хотя это не делает вас анонимными для веб-сайтов или вашего Интернет-провайдера, вам будет легче сохранить конфиденциальность ваших действий в Интернете от других людей, которые используют этот компьютер.
about-private-browsing-need-more-privacy = Хотите большей приватности?
about-private-browsing-turn-on-vpn = Попробуйте { -mozilla-vpn-brand-name }
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } — ваша поисковая система по умолчанию в Приватных окнах
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Чтобы выбрать другую поисковую систему перейдите в <a data-l10n-name="link-options">Настройки</a>
       *[other] Чтобы выбрать другую поисковую систему перейдите в <a data-l10n-name="link-options">Настройки</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Закрыть
