# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = プロファイルについて
profiles-subtitle = このページは、プロファイルの管理を助けます。プロファイルごとに環境が分けられており、それぞれに履歴、ブックマーク、設定、アドオンが含まれています。
profiles-create = 新規プロファイルを作成
profiles-restart-title = 再起動
profiles-restart-in-safe-mode = アドオンを無効にして再起動...
profiles-restart-normal = 通常の再起動...
profiles-conflict = { -brand-product-name } の別のコピーがプロファイルに変更を加えています。さらに変更する前に { -brand-short-name } を再起動しなければなりません。
profiles-flush-fail-title = 変更は保存されません
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = 予期しないエラーにより変更の保存が妨げられました。
profiles-flush-restart-button = { -brand-short-name } を再起動

# Variables:
#   $name (String) - Name of the profile
profiles-name = プロファイル: { $name }
profiles-is-default = デフォルトプロファイル
profiles-rootdir = ルートディレクトリー

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = ローカルディレクトリー
profiles-current-profile = これは使用中のプロファイルです。削除できません。
profiles-in-use-profile = このプロファイルは別のアプリケーションが使用中です。削除できません。

profiles-rename = 名前を変更
profiles-remove = 削除
profiles-set-as-default = デフォルトプロファイルに設定
profiles-launch-profile = プロファイルを別のプロセスで起動

profiles-cannot-set-as-default-title = デフォルトに設定できません
profiles-cannot-set-as-default-message = { -brand-short-name } のデフォルトプロファイルは変更できません。

profiles-yes = はい
profiles-no = いいえ

profiles-rename-profile-title = プロファイルの名前変更
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = プロファイル { $name } の名前を変更します

profiles-invalid-profile-name-title = 不正なプロファイル名
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = “{ $name }” というプロファイル名は使用できません。

profiles-delete-profile-title = プロファイルの削除
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    プロファイルの削除は、使用可能なプロファイルのリストから項目を削除します。これを元に戻すことはできません。
    さらに、プロファイルのデータファイル (設定や証明書、他のユーザー関連のデータを含む) を削除することもできます。このオプションは “{ $dir }” フォルダーを完全に削除します。これを元に戻すことはできません。
    本当にプロファイルのデータファイルを削除しますか？
profiles-delete-files = ファイルを削除
profiles-dont-delete-files = 項目のみ削除

profiles-delete-profile-failed-title = エラー
profiles-delete-profile-failed-message = このプロファイルの削除中にエラーが発生しました。


profiles-opendir =
    { PLATFORM() ->
        [macos] Finder に表示
        [windows] フォルダーを開く
       *[other] ディレクトリーを開く
    }
