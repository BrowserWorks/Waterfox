# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

unknowncontenttype-handleinternally =
    .label = 用 { -brand-short-name } 開啟
    .accesskey = e

unknowncontenttype-settingschange =
    .value =
        { PLATFORM() ->
            [windows] 請從 { -brand-short-name } 的選項變更設定值。
           *[other] 請從 { -brand-short-name } 的偏好設定變更設定值。
        }

unknowncontenttype-intro = 您已決定開啟:
unknowncontenttype-which-is = 檔案類型:
unknowncontenttype-from = 從:
unknowncontenttype-prompt = 您確定要儲存此檔案？
unknowncontenttype-action-question = { -brand-short-name } 應該如何處理此檔案？
unknowncontenttype-open-with =
    .label = 開啟方式:
    .accesskey = O
unknowncontenttype-other =
    .label = 其它…
unknowncontenttype-choose-handler =
    .label =
        { PLATFORM() ->
            [macos] 選擇…
           *[other] 瀏覽…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] B
        }
unknowncontenttype-save-file =
    .label = 儲存檔案
    .accesskey = S
unknowncontenttype-remember-choice =
    .label = 對此類檔案自動採用此處理方式。
    .accesskey = a
