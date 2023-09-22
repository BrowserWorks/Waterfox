# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>В части этой страницы произошёл сбой.</strong> Чтобы сообщить { -brand-product-name } об этой проблеме и ускорить её исправление, отправьте сообщение.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = В части этой страницы произошёл сбой. Чтобы сообщить { -brand-product-name } об этой проблеме и ускорить её исправление, отправьте сообщение.
crashed-subframe-learnmore-link =
    .value = Узнать больше
crashed-subframe-submit =
    .label = Отправить сообщение
    .accesskey = п

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] У вас есть { $reportCount } неотправленное сообщение о падении
        [few] У вас есть { $reportCount } неотправленных сообщения о падении
       *[many] У вас есть { $reportCount } неотправленных сообщений о падении
    }
pending-crash-reports-view-all =
    .label = Просмотреть
pending-crash-reports-send =
    .label = Отправить
pending-crash-reports-always-send =
    .label = Всегда отправлять
