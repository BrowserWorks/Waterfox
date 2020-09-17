# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Нова вкладка
newtab-settings-button =
    .title = Налаштуйте свою сторінку нової вкладки

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Пошук
    .aria-label = Пошук

newtab-search-box-search-the-web-text = Пошук в Інтернеті
newtab-search-box-search-the-web-input =
    .placeholder = Пошук в Інтернеті
    .title = Пошук в Інтернеті
    .aria-label = Пошук в Інтернеті

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Додати засіб пошуку
newtab-topsites-add-topsites-header = Новий популярний сайт
newtab-topsites-edit-topsites-header = Редагувати популярний сайт
newtab-topsites-title-label = Заголовок
newtab-topsites-title-input =
    .placeholder = Введіть назву

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Введіть або вставте URL-адресу
newtab-topsites-url-validation = Необхідна дійсна адреса URL

newtab-topsites-image-url-label = URL власного зображення
newtab-topsites-use-image-link = Використати власне зображення…
newtab-topsites-image-validation = Не вдалося завантажити зображення. Спробуйте інший URL.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Скасувати
newtab-topsites-delete-history-button = Видалити з історії
newtab-topsites-save-button = Зберегти
newtab-topsites-preview-button = Попередній перегляд
newtab-topsites-add-button = Додати

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Ви справді хочете видалити всі записи про цю сторінку з історії?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Цю дію неможливо скасувати.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Відкрити меню
    .aria-label = Відкрити меню

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Вилучити
    .aria-label = Вилучити

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Відкрити меню
    .aria-label = Відкрити контекстне меню для { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Змінити цей сайт
    .aria-label = Змінити цей сайт

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Змінити
newtab-menu-open-new-window = Відкрити в новому вікні
newtab-menu-open-new-private-window = Відкрити в приватному вікні
newtab-menu-dismiss = Сховати
newtab-menu-pin = Прикріпити
newtab-menu-unpin = Відкріпити
newtab-menu-delete-history = Видалити з історії
newtab-menu-save-to-pocket = Зберегти в { -pocket-brand-name }
newtab-menu-delete-pocket = Видалити з { -pocket-brand-name }
newtab-menu-archive-pocket = Архівувати в { -pocket-brand-name }
newtab-menu-show-privacy-info = Наші спонсори і ваша приватність

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Готово
newtab-privacy-modal-button-manage = Налаштування спонсорованого вмісту
newtab-privacy-modal-header = Ваша приватність має значення.
newtab-privacy-modal-paragraph-2 =
    Окрім захопливих історій, ми також показуємо вам відповідний,
    перевірений вміст від обраних спонсорів. Будьте впевнені, що <strong>ваші дані
    перегляду ніколи не виходять за межі { -brand-product-name }</strong> — ми їх не бачимо,
    і наші спонсори теж.
newtab-privacy-modal-link = Дізнайтеся, як працює приватність, у новій вкладці

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Вилучити закладку
# Bookmark is a verb here.
newtab-menu-bookmark = Додати до закладок

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Копіювати адресу завантаження
newtab-menu-go-to-download-page = Перейти на сторінку завантаження
newtab-menu-remove-download = Вилучити з історії

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Показати у Finder
       *[other] Відкрити теку з файлом
    }
newtab-menu-open-file = Відкрити файл

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Відвідано
newtab-label-bookmarked = Закладено
newtab-label-removed-bookmark = Закладку вилучено
newtab-label-recommended = Популярне
newtab-label-saved = Збережено в { -pocket-brand-name }
newtab-label-download = Завантажено

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Спонсоровано

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Від спонсора { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Вилучити розділ
newtab-section-menu-collapse-section = Згорнути розділ
newtab-section-menu-expand-section = Розгорнути розділ
newtab-section-menu-manage-section = Керувати розділом
newtab-section-menu-manage-webext = Керувати розширенням
newtab-section-menu-add-topsite = Додати до популярних сайтів
newtab-section-menu-add-search-engine = Додати засіб пошуку
newtab-section-menu-move-up = Вгору
newtab-section-menu-move-down = Вниз
newtab-section-menu-privacy-notice = Повідомлення про приватність

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Згорнути розділ
newtab-section-expand-section-label =
    .aria-label = Розгорнути розділ

## Section Headers.

newtab-section-header-topsites = Популярні сайти
newtab-section-header-highlights = Обране
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Рекомендовано { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Почніть перегляд, і тут відобразяться деякі цікаві статті, відео та інші сторінки, нещодавно відвідані чи збережені вами до закладок.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Готово. Перевірте згодом, щоб побачити більше матеріалів від { $provider }. Не хочете чекати? Оберіть популярну тему, щоб знайти більше цікавих матеріалів з усього Інтернету.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Ви все прочитали!
newtab-discovery-empty-section-topstories-content = Перевірте згодом, щоб побачити більше матеріалів.
newtab-discovery-empty-section-topstories-try-again-button = Спробувати знову
newtab-discovery-empty-section-topstories-loading = Завантаження…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Отакої! Ми майже завантажили цей розділ, але не повністю.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Популярні теми:
newtab-pocket-more-recommendations = Інші рекомендації
newtab-pocket-learn-more = Докладніше
newtab-pocket-cta-button = Отримати { -pocket-brand-name }
newtab-pocket-cta-text = Зберігайте улюблені статті в { -pocket-brand-name } і задовольніть себе захопливим читанням.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Ой, при завантаженні цього вмісту щось пішло не так.
newtab-error-fallback-refresh-link = Оновіть сторінку, щоб спробувати знову.
