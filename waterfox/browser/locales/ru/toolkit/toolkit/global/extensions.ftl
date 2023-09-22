# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Headers used in the webextension permissions dialog,
## See https://bug1308309.bmoattachments.org/attachment.cgi?id=8814612
## for an example of the full dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension.

webext-perms-header = Добавить { $extension }?
webext-perms-header-with-perms = Добавить { $extension }? Это расширение будет иметь разрешение на:
webext-perms-header-unsigned = Добавить { $extension }? Это расширение не проверено. Вредоносные расширения могут украсть вашу личную информацию или подвергнуть риску ваш компьютер. Добавляйте его, только если вы доверяете источнику.
webext-perms-header-unsigned-with-perms = Добавить { $extension }? Это расширение не проверено. Вредоносные расширения могут украсть вашу личную информацию или подвергнуть риску ваш компьютер. Добавляйте его, только если вы доверяете источнику. Это расширение будет иметь разрешение на:
webext-perms-sideload-header = { $extension } добавлено
webext-perms-optional-perms-header = { $extension } запрашивает дополнительные разрешения.

##

webext-perms-add =
    .label = Добавить
    .accesskey = Д
webext-perms-cancel =
    .label = Отмена
    .accesskey = О

webext-perms-sideload-text = Другая программа на вашем компьютере установила дополнение, которое может повлиять на ваш браузер. Пожалуйста, ознакомьтесь с запросами разрешений для этого дополнения и выберите «Включить» или «Отмена» (чтобы оставить его отключённым).
webext-perms-sideload-text-no-perms = Другая программа на вашем компьютере установила дополнение, которое может повлиять на ваш браузер. Пожалуйста, выберите «Включить» или «Отмена» (чтобы оставить его отключённым).
webext-perms-sideload-enable =
    .label = Включить
    .accesskey = В
webext-perms-sideload-cancel =
    .label = Отмена
    .accesskey = О

# Variables:
#   $extension (String): replaced with the localized name of the extension.
webext-perms-update-text = { $extension } было обновлено. Вы должны одобрить новые разрешения перед установкой обновлённой версии. Выбрав «Отмена», вы сохраните текущую версию расширения. Оно будет иметь разрешение на:
webext-perms-update-accept =
    .label = Обновить
    .accesskey = Н

webext-perms-optional-perms-list-intro = Оно хочет получить разрешение на:
webext-perms-optional-perms-allow =
    .label = Разрешить
    .accesskey = Р
webext-perms-optional-perms-deny =
    .label = Отклонить
    .accesskey = О

webext-perms-host-description-all-urls = Доступ к вашим данным для всех веб-сайтов

# Variables:
#   $domain (String): will be replaced by the DNS domain for which a webextension is requesting access (e.g., mozilla.org)
webext-perms-host-description-wildcard = Доступ к вашим данным для сайтов в домене { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-wildcards =
    { $domainCount ->
        [one] Доступ к вашим данным для ещё { $domainCount } домена
        [few] Доступ к вашим данным для ещё { $domainCount } доменов
       *[many] Доступ к вашим данным для ещё { $domainCount } доменов
    }
# Variables:
#   $domain (String): will be replaced by the DNS host name for which a webextension is requesting access (e.g., www.mozilla.org)
webext-perms-host-description-one-site = Доступ к вашим данным для { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-sites =
    { $domainCount ->
        [one] Доступ к вашим данным для ещё { $domainCount } сайта
        [few] Доступ к вашим данным для ещё { $domainCount } сайтов
       *[many] Доступ к вашим данным для ещё { $domainCount } сайтов
    }

## Headers used in the webextension permissions dialog for synthetic add-ons.
## The part of the string describing what privileges the extension gives should be consistent
## with the value of webext-site-perms-description-gated-perms-{sitePermission}.
## Note, this string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $hostname (String): the hostname of the site the add-on is being installed from.

webext-site-perms-header-with-gated-perms-midi = Это дополнение предоставляет { $hostname } доступ к вашим MIDI-устройствам.
webext-site-perms-header-with-gated-perms-midi-sysex = Это дополнение предоставляет { $hostname } доступ к вашим MIDI-устройствам (с поддержкой SysEx).

##

# This string is used as description in the webextension permissions dialog for synthetic add-ons.
# Note, the empty line is used to create a line break between the two sections.
# Note, this string will be used as raw markup. Avoid characters like <, >, &
webext-site-perms-description-gated-perms-midi =
    Обычно это подключаемые устройства, такие как синтезаторы звука, но они также могут быть встроены в ваш компьютер.
    
    Веб-сайтам обычно запрещен доступ к MIDI-устройствам. Неправильное использование может привести к повреждению или нарушению безопасности.

## Headers used in the webextension permissions dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension being installed.
##   $hostname (String): will be replaced by the DNS host name for which a webextension enables permissions.

webext-site-perms-header-with-perms = Добавить { $extension }? Это расширение предоставляет { $hostname } следующие возможности:
webext-site-perms-header-unsigned-with-perms = Добавить { $extension }? Это расширение не проверено. Вредоносные расширения могут украсть вашу личную информацию или подвергнуть риску ваш компьютер. Устанавливайте его, только если вы доверяете его источнику. Это расширение предоставляет { $hostname } следующие возможности:

## These should remain in sync with permissions.NAME.label in sitePermissions.properties

webext-site-perms-midi = Доступ к MIDI-устройствам
webext-site-perms-midi-sysex = Доступ к MIDI-устройствам с поддержкой SysEx
