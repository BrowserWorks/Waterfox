# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = ダウンロード
downloads-panel =
    .aria-label = ダウンロード

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-items =
    .style = width: 35em

downloads-cmd-pause =
    .label = 中断
    .accesskey = P
downloads-cmd-resume =
    .label = 再開
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = キャンセル
downloads-cmd-cancel-panel =
    .aria-label = キャンセル
# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = 保存フォルダーを開く
    .accesskey = F
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Finder に表示
    .accesskey = F

downloads-cmd-use-system-default =
  .label = システムのビューアーで開く
  .accesskey = V

downloads-cmd-always-use-system-default =
  .label = 常にシステムのビューアーで開く
  .accesskey = w

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Finder に表示
           *[other] 保存フォルダーを開く
        }
downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Finder に表示
           *[other] 保存フォルダーを開く
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Finder に表示
           *[other] 保存フォルダーを開く
        }
downloads-cmd-show-downloads =
    .label = ダウンロードフォルダーを表示
downloads-cmd-retry =
    .tooltiptext = 再試行
downloads-cmd-retry-panel =
    .aria-label = 再試行
downloads-cmd-go-to-download-page =
    .label = ダウンロード元のページを開く
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = ダウンロード元の URL をコピー
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = 履歴から削除
    .accesskey = e
downloads-cmd-clear-list =
    .label = プレビューパネルの消去
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = ダウンロード履歴をすべて消去
    .accesskey = D
# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = ダウンロードを許可
    .accesskey = o
# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = ファイルを削除
downloads-cmd-remove-file-panel =
    .aria-label = ファイルを削除
# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = ファイルを削除またはダウンロードを許可
downloads-cmd-choose-unblock-panel =
    .aria-label = ファイルを削除またはダウンロードを許可
# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = 開くまたはファイルを削除
downloads-cmd-choose-open-panel =
    .aria-label = 開くまたはファイルを削除
# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = 詳細情報を表示
# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = ファイルを開く

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = { $hours } 時間 { $minutes } 分後に開きます...
downloading-file-opens-in-minutes = { $minutes } 分後に開きます...
downloading-file-opens-in-minutes-and-seconds = { $minutes } 分 { $seconds } 秒後に開きます...
downloading-file-opens-in-seconds = { $seconds } 秒後に開きます...
downloading-file-opens-in-some-time = ダウンロードが完了したら開きます...

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = ダウンロードを再試行
# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = ダウンロードをキャンセル
# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = すべてのダウンロード履歴を表示
    .accesskey = S
# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = ダウンロードの詳細
downloads-clear-downloads-button =
    .label = ダウンロード履歴を消去
    .tooltiptext = 完了、キャンセル、失敗したすべてのダウンロード履歴を消去します
# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = ダウンロードはありません。
# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = このセッションでのダウンロードはありません。
