# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-provisioner-tab-title = Получите новый адрес электронной почты от поставщика услуг
provisioner-searching-icon =
    .alt = Поиск…
account-provisioner-title = Создать новый адрес электронной почты
account-provisioner-description = Используйте наших надежных партнеров, чтобы получить новый приватный и безопасный адрес электронной почты.
account-provisioner-start-help = Используемые условия поиска отправляются { -vendor-short-name } (<a data-l10n-name="mozilla-privacy-link">Политика конфиденциальности</a>) и сторонним поставщикам услуг электронной почты <strong>mailfence.com</strong> (<a data-l10n-name="mailfence-privacy-link">Политика конфиденциальности</a>, <a data-l10n-name="mailfence-tou-link">Условия использования</a>) и <strong>gandi.net</strong> (<a data-l10n-name="gandi-privacy-link">Политика конфиденциальности</a>, <a data-l10n-name="gandi-tou-link">Условия использования</a>), чтобы найти доступные адреса электронной почты.
account-provisioner-mail-account-title = Купить новый адрес электронной почты
account-provisioner-mail-account-description = Thunderbird заключил партнерское соглашение с  <a data-l10n-name="mailfence-home-link">Mailfence</a>, чтобы предложить вам новую приватную и безопасную электронную почту. Мы считаем, что у каждого должна быть безопасная электронная почта.
account-provisioner-domain-title = Купить собственный адрес и домен электронной почты
account-provisioner-domain-description = Thunderbird заключил партнерское соглашение с <a data-l10n-name="gandi-home-link">Gandi</a>, чтобы предложить вам собственный домен. Это позволяет вам использовать любой адрес в этом домене.

## Forms

account-provisioner-mail-input =
    .placeholder = Ваше имя, псевдоним или другой поисковый запрос
account-provisioner-domain-input =
    .placeholder = Ваше имя, псевдоним или другой поисковый запрос
account-provisioner-search-button = Поиск
account-provisioner-button-cancel = Отмена
account-provisioner-button-existing = Использовать существующую учётную запись электронной почты
account-provisioner-button-back = Вернуться назад

## Notifications

account-provisioner-fetching-provisioners = Загрузка от поставщиков…
account-provisioner-connection-issues = Не удалось связаться с нашими серверами регистрации. Пожалуйста, проверьте ваше соединение.
account-provisioner-searching-email = Поиск доступных учётных записей электронной почты…
account-provisioner-searching-domain = Поиск доступных доменов…
account-provisioner-searching-error = Не удалось найти для предложения никаких адресов. Попробуйте изменить условия поиска.

## Illustrations

account-provisioner-step1-image =
    .title = Выберите, какую учётную запись нужно создать

## Search results

# Variables:
# $count (Number) - The number of domains found during search.
account-provisioner-results-title =
    { $count ->
        [one] Найден { $count } доступный адрес для:
        [few] Найдено { $count } доступных адреса для:
       *[many] Найдено { $count } доступных адресов для:
    }
account-provisioner-mail-results-caption = Чтобы найти больше адресов, вы можете попробовать произвести поиск по прозвищам или любым другим терминам.
account-provisioner-domain-results-caption = Чтобы найти больше доменов, вы можете попробовать произвести поиск по прозвищам или любым другим терминам.
account-provisioner-free-account = Бесплатно
account-provision-price-per-year = { $price } в год
account-provisioner-all-results-button = Показать все результаты
account-provisioner-open-in-tab-img =
    .title = Открыть в новой вкладке
