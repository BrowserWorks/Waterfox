# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Отменить все загрузки?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] При выходе загрузка будет отменена. Вы уверены, что вы хотите выйти?
       *[other] При выходе будет отменено несколько ({ $downloadsCount }) загрузок. Вы уверены, что вы хотите выйти?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] При выходе загрузка будет отменена. Вы уверены, что вы хотите выйти?
       *[other] При выходе будет отменено несколько ({ $downloadsCount }) загрузок. Вы уверены, что вы хотите выйти?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] Не завершать работу
       *[other] Не завершать работу
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] При переходе в автономный режим работы будет отменена одна загрузка. Вы действительно этого хотите?
       *[other] При переходе в автономный режим работы будет отменено несколько ({ $downloadsCount }) загрузок. Вы действительно этого хотите?
    }
download-ui-dont-go-offline-button = Сохранить подключение

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Если вы сейчас закроете все приватные окна, будет отменена 1 загрузка. Вы уверены, что хотите выйти из приватного режима?
       *[other] Если вы сейчас закроете все приватные окна, будет отменено { $downloadsCount } загрузок. Вы уверены, что хотите выйти из приватного режима?
    }
download-ui-dont-leave-private-browsing-button = Остаться в приватном режиме

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] Отменить загрузку
       *[other] Отменить несколько ({ $downloadsCount }) загрузок
    }

##

download-ui-file-executable-security-warning-title = Открыть исполняемый файл?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = «{ $executable }» является исполняемым файлом. Исполняемые файлы могут содержать вирусы или другой вредоносный код, который может повредить информацию на компьютере. Будьте внимательны при открытии данного файла. Вы действительно хотите открыть файл «{ $executable }»?
