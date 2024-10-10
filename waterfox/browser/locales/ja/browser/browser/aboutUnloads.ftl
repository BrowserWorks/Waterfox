# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = タブの解放
about-unloads-intro = { -brand-short-name } には、システムのメモリーの空き領域が少なくなったときに、メモリー不足によるアプリケーションのクラッシュを防ぐための自動的にタブを解放する機能があります。次に解放されるタブは、複数の属性から選択されます。このページは、タブが解放される時、{ -brand-short-name } がどのようにタブに優先度を付けて解放するかを表示します。以下の <em>解放</em> ボタンを押すと、手動でタブを解放できます。

# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more = このページと機能についての詳細は <a data-l10n-name="doc-link">Tab Unloading</a> を参照してください。

about-unloads-last-updated =
    最終更新日時: { DATETIME($date,
        year: "numeric", month: "numeric", day: "numeric",
        hour: "numeric", minute: "numeric", second: "numeric",
        hour12: "false") }
about-unloads-button-unload = 解放
    .title = 最も優先度の高いタブを解放します
about-unloads-no-unloadable-tab = 解放できるタブはありません。

about-unloads-column-priority = 優先度
about-unloads-column-host = ホスト
about-unloads-column-last-accessed = 最終アクセス日時
about-unloads-column-weight = 基本ウエイト
    .title = タブはまずこの値で並べ替えられます。これは音声の再生や WebRTC など、一部の特別な属性から算出されます。
about-unloads-column-sortweight = 二次ウエイト
    .title = 基本ウエイトで並べ替えられた後、利用可能であれば、この値でタブが並べ替えられます。この値はタブのメモリー消費量とプロセス数から算出されます。
about-unloads-column-memory = メモリー
    .title = タブの推定メモリー消費量
about-unloads-column-processes = プロセス ID
    .title = タブの内容を保持しているプロセスの ID

about-unloads-last-accessed = { DATETIME($date,
        year: "numeric", month: "numeric", day: "numeric",
        hour: "numeric", minute: "numeric", second: "numeric",
        hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
