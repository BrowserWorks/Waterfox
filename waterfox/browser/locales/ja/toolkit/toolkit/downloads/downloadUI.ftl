# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = すべてのダウンロードをキャンセルしますか？

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] 今終了すると 1 個のダウンロードがキャンセルされます。終了してもよろしいですか？
       *[other] 今終了すると { $downloadsCount } 個のダウンロードがキャンセルされます。終了してもよろしいですか？
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] 今終了すると 1 個のダウンロードがキャンセルされます。終了してもよろしいですか？
       *[other] 今終了すると { $downloadsCount } 個のダウンロードがキャンセルされます。終了してもよろしいですか？
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] 終了しない
       *[other] 終了しない
    }
download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] 今オフラインにすると 1 個のダウンロードがキャンセルされます。オフラインにしてもよろしいですか？
       *[other] 今オフラインにすると { $downloadsCount } 個のダウンロードがキャンセルされます。オフラインにしてもよろしいですか？
    }
download-ui-dont-go-offline-button = オンラインを維持する
download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] プライベートブラウジングウィンドウを今すぐ閉じると、1 個のダウンロードがキャンセルされます。プライベートブラウジングモードを終了してもよろしいですか？
       *[other] プライベートブラウジングウィンドウを今すぐ閉じると、{ $downloadsCount } 個のダウンロードがキャンセルされます。プライベートブラウジングモードを終了してもよろしいですか？
    }
download-ui-dont-leave-private-browsing-button = プライベートブラウジングを継続する
download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] 1 個のダウンロードをキャンセル
       *[other] { $downloadsCount } 個のダウンロードをキャンセル
    }

##

download-ui-file-executable-security-warning-title = 実行可能なファイルを開きますか？
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = “{ $executable }” は実行可能なファイルです。実行可能なファイルにはあなたのコンピューターを破壊するウイルス、その他の悪意あるコードが含まれていることがあります。この形式のファイルを開く場合には注意してください。“{ $executable }” を実行してもよろしいですか？
