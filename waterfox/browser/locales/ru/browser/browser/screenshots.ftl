# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

screenshot-toolbarbutton =
    .label = Снимок экрана
    .tooltiptext = Сделать снимок экрана

screenshot-shortcut =
    .key = S

screenshots-instructions = Потяните мышью или щёлкните по странице, чтобы выбрать область. Нажмите ESC для отмены.
screenshots-cancel-button = Отмена
screenshots-save-visible-button = Сохранить видимую область
screenshots-save-page-button = Сохранить всю страницу
screenshots-download-button = Загрузить
screenshots-download-button-tooltip = Загрузить снимок экрана
screenshots-copy-button = Скопировать
screenshots-copy-button-tooltip = Скопировать снимок экрана в буфер обмена
screenshots-download-button-title =
    .title = Загрузить снимок экрана
screenshots-copy-button-title =
    .title = Скопировать снимок экрана в буфер обмена
screenshots-cancel-button-title =
    .title = Отмена
screenshots-retry-button-title =
    .title = Повторить снимок экрана

screenshots-meta-key =
    { PLATFORM() ->
        [macos] ⌘
       *[other] Ctrl
    }
screenshots-notification-link-copied-title = Ссылка скопирована
screenshots-notification-link-copied-details = Ссылка на ваш снимок была скопирована в буфер обмена. Нажмите { screenshots-meta-key }-V для её вставки.

screenshots-notification-image-copied-title = Снимок скопирован
screenshots-notification-image-copied-details = Ваш снимок был скопирован в буфер обмена. Нажмите { screenshots-meta-key }-V для его вставки.

screenshots-request-error-title = Произошла ошибка.
screenshots-request-error-details = Извините! Мы не смогли сохранить ваш снимок. Пожалуйста, попробуйте позже.

screenshots-connection-error-title = Мы не можем получить доступ к вашим снимкам экрана.
screenshots-connection-error-details = Пожалуйста, проверьте соединение с Интернетом. Если вам удаётся войти в Интернет, то возможно, возникла временная проблема со службой { -screenshots-brand-name }.

screenshots-login-error-details = Мы не смогли сохранить ваш снимок, так как возникла проблема со службой { -screenshots-brand-name }. Пожалуйста, попробуйте позже.

screenshots-unshootable-page-error-title = Мы не можем сделать снимок экрана этой страницы.
screenshots-unshootable-page-error-details = Так как это не обычная страница, мы не можем сделать её снимок экрана.

screenshots-empty-selection-error-title = Выбрана слишком небольшая область

screenshots-private-window-error-title = { -screenshots-brand-name } отключены в приватном режиме
screenshots-private-window-error-details = Приносим извинения за неудобства. Мы работаем над добавлением этой возможности в будущих выпусках.

screenshots-generic-error-title = Ой! { -screenshots-brand-name } вышли из строя.
screenshots-generic-error-details = Мы не уверены, в чём проблема. Попробовать ещё раз или сделать снимок другой страницы?

screenshots-too-large-error-title = Ваш снимок экрана был обрезан, потому что он был слишком большим
screenshots-too-large-error-details = Попытайтесь выбрать область размером менее 32 700 пикселей по самой длинной стороне или общей площадью менее 124 900 000 пикселей.
