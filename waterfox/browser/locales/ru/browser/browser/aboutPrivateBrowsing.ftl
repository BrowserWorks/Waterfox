# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Открыть приватное окно
    .accesskey = о
about-private-browsing-search-placeholder = Поиск в Интернете
about-private-browsing-info-title = Вы в приватном окне
about-private-browsing-search-btn =
    .title = Искать в Интернете
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Ищите в { $engine } или введите адрес
about-private-browsing-handoff-no-engine =
    .title = Введите запрос или адрес
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Ищите в { $engine } или введите адрес
about-private-browsing-handoff-text-no-engine = Введите запрос или адрес
about-private-browsing-not-private = Сейчас вы не в приватном окне.
about-private-browsing-info-description-private-window = Приватное окно: { -brand-short-name } удаляет историю поиска и просмотра при закрытии всех приватных окон. Это не делает вас анонимными.
about-private-browsing-info-description-simplified = { -brand-short-name } удаляет историю поиска и просмотра при закрытии всех приватных окон, но это не делает вас анонимными.
about-private-browsing-learn-more-link = Подробнее
about-private-browsing-hide-activity = Скрывайте свою активность и местоположение в любой части Интернета
about-private-browsing-get-privacy = Получите защиту приватности в любой части Интернета
about-private-browsing-hide-activity-1 = Скрывайте активность и местоположение в любой части Интернета с помощью { -mozilla-vpn-brand-name }. Одним щелчком мыши создавайте безопасное соединение даже при использовании общедоступной сети Wi-Fi.
about-private-browsing-prominent-cta = Сохраняйте приватность с { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = Загрузить { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name }: Приватный веб-сёрфинг на лету
about-private-browsing-focus-promo-text = Наше специальное мобильное приложение для приватного просмотра каждый раз удаляет вашу историю и куки.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Приватный просмотр на телефоне
about-private-browsing-focus-promo-text-b = Используйте { -focus-brand-name }, когда не хотите сохранять свой поиск в основном мобильном браузере.
about-private-browsing-focus-promo-header-c = Новый уровень приватности на мобильных устройствах
about-private-browsing-focus-promo-text-c = { -focus-brand-name } каждый раз стирает вашу историю, блокируя при этом рекламу и трекеры.
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } — ваша поисковая система по умолчанию в приватных окнах
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Чтобы выбрать другую поисковую систему, перейдите в <a data-l10n-name="link-options">настройки</a>
       *[other] Чтобы выбрать другую поисковую систему, перейдите в <a data-l10n-name="link-options">настройки</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Закрыть
about-private-browsing-promo-close-button =
    .title = Закрыть

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = Свобода приватного просмотра одним щелчком
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Добавить в Dock
       *[other] Закрепить на панели задач
    }
about-private-browsing-pin-promo-title = Никаких сохранённых кук или истории, прямо с вашего рабочего стола. Сёрфите так, как будто никто не смотрит.
