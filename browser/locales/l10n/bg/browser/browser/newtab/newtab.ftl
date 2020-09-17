# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Нов раздел
newtab-settings-button =
    .title = Настройки на новия раздел

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Търсене
    .aria-label = Търсене

newtab-search-box-search-the-web-text = Търсене в интернет
newtab-search-box-search-the-web-input =
    .placeholder = Търсене в интернет
    .title = Търсене в интернет
    .aria-label = Търсене в интернет

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Добавяне на търсеща машина
newtab-topsites-add-topsites-header = Нова често посещавана страница
newtab-topsites-edit-topsites-header = Променяне на често посещавана страница
newtab-topsites-title-label = Заглавие
newtab-topsites-title-input =
    .placeholder = Въведете заглавие

newtab-topsites-url-label = Адрес
newtab-topsites-url-input =
    .placeholder = Адрес
newtab-topsites-url-validation = Необходим е валиден URL

newtab-topsites-image-url-label = Адрес на изображение по желание
newtab-topsites-use-image-link = Използване изображение по желание…
newtab-topsites-image-validation = Изображението не може да бъде заредено. Опитайте с друг адрес.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Отказ
newtab-topsites-delete-history-button = Премахване
newtab-topsites-save-button = Запазване
newtab-topsites-preview-button = Преглед
newtab-topsites-add-button = Добавяне

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Сигурни ли сте, че желаете да премахнете страницата навсякъде от историята?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Действието е необратимо.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Отваряне на меню
    .aria-label = Отваряне на меню

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Премахване
    .aria-label = Премахване

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Отваряне на меню
    .aria-label = Отваряне на менюто за { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Променяне
    .aria-label = Променяне

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Променяне
newtab-menu-open-new-window = Отваряне в раздел
newtab-menu-open-new-private-window = Отваряне в поверителен прозорец
newtab-menu-dismiss = Отхвърляне
newtab-menu-pin = Закачане
newtab-menu-unpin = Откачане
newtab-menu-delete-history = Премахване
newtab-menu-save-to-pocket = Запазване в { -pocket-brand-name }
newtab-menu-delete-pocket = Изтриване от { -pocket-brand-name }
newtab-menu-archive-pocket = Архивиране в { -pocket-brand-name }
newtab-menu-show-privacy-info = Спонсори и поверителност

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Готово
newtab-privacy-modal-button-manage = Управление на настройките за спонсорирано съдържание
newtab-privacy-modal-header = Вашата поверителност е от значение.
newtab-privacy-modal-paragraph-2 =
    Като допълнение на това, че намираме завладяващи истории,
    ние ви показваме и подходящо, проверено съдържание от избрани
    спонсори. Бъдете спокойни, <strong>данните ви от разглежданията никога
    не напускат вашето копие на { -brand-product-name }</strong> - ние не ги виждаме
    нашите спонсори също.
newtab-privacy-modal-link = Научете как работи поверителността на новия раздел

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Премахване на отметка
# Bookmark is a verb here.
newtab-menu-bookmark = Отметка

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Копиране на препратка за изтегляне
newtab-menu-go-to-download-page = Към страницата за изтегляне
newtab-menu-remove-download = Премахване от историята

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Показване във Finder
       *[other] Отваряне на съдържащата папка
    }
newtab-menu-open-file = Отваряне на файла

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Посетена
newtab-label-bookmarked = Отметната
newtab-label-removed-bookmark = Отметката е премахната
newtab-label-recommended = Тенденции
newtab-label-saved = Запазено в { -pocket-brand-name }
newtab-label-download = Изтеглено

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Спонсорирано

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Спонсорирано от { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Премахване на раздела
newtab-section-menu-collapse-section = Свиване на раздела
newtab-section-menu-expand-section = Разгъване на раздела
newtab-section-menu-manage-section = Управление на раздела
newtab-section-menu-manage-webext = Управление на добавката
newtab-section-menu-add-topsite = Добавяне на често посещавана страница
newtab-section-menu-add-search-engine = Добавяне на търсеща машина
newtab-section-menu-move-up = Преместване нагоре
newtab-section-menu-move-down = Преместване надолу
newtab-section-menu-privacy-notice = Политика за личните данни

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Свиване на раздела
newtab-section-expand-section-label =
    .aria-label = Разгъване на раздела

## Section Headers.

newtab-section-header-topsites = Често посещавани страници
newtab-section-header-highlights = Акценти
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Препоръчано от { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Разглеждайте и тук ще ви покажем някои от най-добрите статии, видео и други страници, които сте посетили или отметнали наскоро.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Разгледахте всичко. Проверете по-късно за повече истории от { $provider }. Нямате търпение? Изберете популярна тема, за да откриете повече истории от цялата Мрежа.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Изчетохте всичко!
newtab-discovery-empty-section-topstories-content = Проверете по-късно за повече статии.
newtab-discovery-empty-section-topstories-try-again-button = Нов опит
newtab-discovery-empty-section-topstories-loading = Зареждане…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Ами сега! Почти заредихме тази секция, но не съвсем.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Популярни теми:
newtab-pocket-more-recommendations = Повече препоръчани
newtab-pocket-learn-more = Научете повече
newtab-pocket-cta-button = Вземете { -pocket-brand-name }
newtab-pocket-cta-text = Запазете статиите, които харесвате в { -pocket-brand-name } и заредете ума си с увлекателни четива.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Ааах, нещо се обърка и съдържанието не е заредено.
newtab-error-fallback-refresh-link = Презаредете страницата за повторен опит.
