# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = プロファイル作成ウィザード
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] はじめに
       *[other] { create-profile-window.title }の開始
    }
profile-creation-explanation-1 = { -brand-short-name } はユーザー設定などの情報を個人プロファイルとして保存します。
profile-creation-explanation-2 = { -brand-short-name } を他のユーザーと共有しているときには各ユーザーが自分用のプロファイルを作成してください。これによりユーザー設定などを個別に保存できます。
profile-creation-explanation-3 = { -brand-short-name } を一人で使用する場合でも、少なくとも 1 つのプロファイルが必要です。もちろん必要に応じて複数のプロファイルを作成し、別々に保存しておくこともできます。例えば、仕事用とプライベート用とでプロファイルを分けることなどができます。
profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] プロファイルを作成するには [続ける] をクリックしてください。
       *[other] プロファイルを作成するには [次へ] をクリックしてください。
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] 完了
       *[other] { create-profile-window.title }の完了
    }
profile-creation-intro = プロファイルを複数使用する場合は、それぞれに名前を付けて区別します。あらかじめ入力されている名前をそのまま使用するか、新しい名前を入力し直してください。
profile-prompt = 新しいプロファイルの名前を入力してください:
    .accesskey = E
profile-default-name =
    .value = Default User
profile-directory-explanation = あなたのユーザー設定やユーザーデータの保存先:
create-profile-choose-folder =
    .label = フォルダーを選択...
    .accesskey = C
create-profile-use-default =
    .label = 標準のフォルダーを使用する
    .accesskey = U
