# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = 建立設定檔精靈
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] 介紹
       *[other] 歡迎使用{ create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } 把您的設定、偏好等各種資料存於您的個人設定檔 (Profile) 中。

profile-creation-explanation-2 = 如果您與人共用電腦，只需要為每個使用者各自建立 { -brand-short-name } 設定檔即可將各個使用者的資訊分開。

profile-creation-explanation-3 = 如果只有自己使用，至少還是要建立一個設定檔。當然您若想把工作跟個人用途的資料分開，也可以建立多個 { -brand-short-name } 設定檔。

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] 要開始建立設定檔請按「繼續」。
       *[other] 要開始建立設定檔請按「下一步」。
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] 最後一步
       *[other] 完成{ create-profile-window.title }
    }

profile-creation-intro = 可用名稱來區分不同的設定檔。您可參考下列建議，或使用自己喜歡的名稱。

profile-prompt = 輸入新設定檔名稱:
    .accesskey = E

profile-default-name =
    .value = Default User

profile-directory-explanation = 您的使用者設定、偏好設定和其他個人資料會存放於:

create-profile-choose-folder =
    .label = 選擇資料夾…
    .accesskey = C

create-profile-use-default =
    .label = 使用預設資料夾
    .accesskey = U
