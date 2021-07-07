# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Новая вкладка
newtab-settings-button =
    .title = Настроить свою страницу новой вкладки
newtab-personalize-button-label = Настроить
    .title = Настроить новую вкладку
    .aria-label = Настроить новую вкладку
newtab-personalize-dialog-label =
    .aria-label = Настроить

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Искать
    .aria-label = Искать
newtab-search-box-search-the-web-text = Искать в Интернете
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = Найдите в { $engine } или введите адрес
newtab-search-box-handoff-text-no-engine = Введите запрос или адрес
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = Найдите в { $engine } или введите адрес
    .title = Найдите в { $engine } или введите адрес
    .aria-label = Найдите в { $engine } или введите адрес
newtab-search-box-handoff-input-no-engine =
    .placeholder = Введите запрос или адрес
    .title = Введите запрос или адрес
    .aria-label = Введите запрос или адрес
newtab-search-box-search-the-web-input =
    .placeholder = Искать в Интернете
    .title = Искать в Интернете
    .aria-label = Искать в Интернете
newtab-search-box-text = Поиск в Интернете
newtab-search-box-input =
    .placeholder = Поиск в Интернете
    .aria-label = Поиск в Интернете

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Добавить поисковую систему
newtab-topsites-add-topsites-header = Новый сайт в топе
newtab-topsites-add-shortcut-header = Новый ярлык
newtab-topsites-edit-topsites-header = Изменить сайт из топа
newtab-topsites-edit-shortcut-header = Изменить ярлык
newtab-topsites-title-label = Заголовок
newtab-topsites-title-input =
    .placeholder = Введите название
newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Введите или вставьте URL
newtab-topsites-url-validation = Введите корректный URL
newtab-topsites-image-url-label = Свой URL изображения
newtab-topsites-use-image-link = Использовать своё изображение…
newtab-topsites-image-validation = Изображение не загрузилось. Попробуйте использовать другой URL.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Отмена
newtab-topsites-delete-history-button = Удалить из истории
newtab-topsites-save-button = Сохранить
newtab-topsites-preview-button = Предпросмотр
newtab-topsites-add-button = Добавить

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Вы действительно хотите удалить все записи об этой странице из вашей истории?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Это действие нельзя отменить.

## Top Sites - Sponsored label

newtab-topsite-sponsored = Спонсировано

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Открыть меню
    .aria-label = Открыть меню
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Убрать
    .aria-label = Убрать
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Открыть меню
    .aria-label = Открыть контекстное меню для { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Изменить этот сайт
    .aria-label = Изменить этот сайт

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Изменить
newtab-menu-open-new-window = Открыть в новом окне
newtab-menu-open-new-private-window = Открыть в новом приватном окне
newtab-menu-dismiss = Скрыть
newtab-menu-pin = Прикрепить
newtab-menu-unpin = Открепить
newtab-menu-delete-history = Удалить из истории
newtab-menu-save-to-pocket = Сохранить в { -pocket-brand-name }
newtab-menu-delete-pocket = Удалить из { -pocket-brand-name }
newtab-menu-archive-pocket = Архивировать в { -pocket-brand-name }
newtab-menu-show-privacy-info = Наши спонсоры и ваша приватность

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Готово
newtab-privacy-modal-button-manage = Управление настройками контента спонсоров
newtab-privacy-modal-header = Ваша приватность имеет значение.
newtab-privacy-modal-paragraph-2 =
    Помимо сохранения увлекательных статей, мы также показываем вам
    проверенный контент от избранных спонсоров. Будьте уверены, <strong>ваши данные
    веб-сёрфинга никогда не покинут вашу личную копию { -brand-product-name }</strong> — мы не имеем
    к ним доступа, и наши спонсоры тоже не имеют.
newtab-privacy-modal-link = Посмотрите, как работает приватность, в новой вкладке

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Удалить закладку
# Bookmark is a verb here.
newtab-menu-bookmark = Добавить в закладки

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Копировать ссылку на загрузку
newtab-menu-go-to-download-page = Перейти на страницу загрузки
newtab-menu-remove-download = Удалить из истории

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Показать в Finder
       *[other] Открыть папку с файлом
    }
newtab-menu-open-file = Открыть файл

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Посещено
newtab-label-bookmarked = В закладках
newtab-label-removed-bookmark = Закладка удалена
newtab-label-recommended = Популярные
newtab-label-saved = Сохранено в { -pocket-brand-name }
newtab-label-download = Загружено
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · На правах рекламы
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = От спонсора { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Удалить раздел
newtab-section-menu-collapse-section = Свернуть раздел
newtab-section-menu-expand-section = Развернуть раздел
newtab-section-menu-manage-section = Управление разделом
newtab-section-menu-manage-webext = Управление расширением
newtab-section-menu-add-topsite = Добавить в топ сайтов
newtab-section-menu-add-search-engine = Добавить поисковую систему
newtab-section-menu-move-up = Вверх
newtab-section-menu-move-down = Вниз
newtab-section-menu-privacy-notice = Уведомление о конфиденциальности

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Свернуть раздел
newtab-section-expand-section-label =
    .aria-label = Развернуть раздел

## Section Headers.

newtab-section-header-topsites = Топ сайтов
newtab-section-header-highlights = Избранное
newtab-section-header-recent-activity = Последние действия
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Рекомендовано { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Начните веб-сёрфинг, и мы покажем вам здесь некоторые из интересных статей, видеороликов и других страниц, которые вы недавно посетили или добавили в закладки.
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Вы всё прочитали. Зайдите попозже, чтобы увидеть больше лучших статей от { $provider }. Не можете ждать? Выберите популярную тему, чтобы найти больше интересных статей со всего Интернета.

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Вы всё прочитали!
newtab-discovery-empty-section-topstories-content = Зайдите попозже, чтобы увидеть больше статей.
newtab-discovery-empty-section-topstories-try-again-button = Попробовать снова
newtab-discovery-empty-section-topstories-loading = Загрузка…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Ой! Мы почти загрузили этот раздел, но не совсем.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Популярные темы:
newtab-pocket-more-recommendations = Ещё рекомендации
newtab-pocket-learn-more = Подробнее
newtab-pocket-cta-button = Загрузить { -pocket-brand-name }
newtab-pocket-cta-text = Сохраняйте интересные статьи в { -pocket-brand-name } и подпитывайте свой ум увлекательным чтением.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = К сожалению что-то пошло не так при загрузке этого содержимого.
newtab-error-fallback-refresh-link = Обновить страницу, чтобы попробовать ещё раз.

## Customization Menu

newtab-custom-shortcuts-title = Ярлыки
newtab-custom-shortcuts-subtitle = Сохранённые или посещаемые сайты
newtab-custom-row-selector =
    { $num ->
        [one] { $num } строка
        [few] { $num } строки
       *[many] { $num } строк
    }
newtab-custom-sponsored-sites = Спонсируемые ярлыки
newtab-custom-pocket-title = Рекомендуемые { -pocket-brand-name }
newtab-custom-pocket-subtitle = Особый контент, курируемый { -pocket-brand-name }, частью семейства { -brand-product-name }
newtab-custom-pocket-sponsored = Статьи спонсоров
newtab-custom-recent-title = Последние действия
newtab-custom-recent-subtitle = Подборка недавних сайтов и контента
newtab-custom-close-button = Закрыть
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
newtab-custom-snippets-title = Заметки
newtab-custom-snippets-subtitle = Советы и новости от { -vendor-short-name } и { -brand-product-name }
newtab-custom-settings = Управление дополнительными настройками
