# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = 疑難排解資訊
page-subtitle =
    此頁面包含技術資訊，可能可以幫您解決一些問題。
    如果您正在尋找關於 { -brand-short-name } 的一些常見問題，
    請看看我們的<a data-l10n-name="support-link">支援網站</a>。

crashes-title = 錯誤資訊報表
crashes-id = 報表編號
crashes-send-date = 送出日期
crashes-all-reports = 所有錯誤報表
crashes-no-config = 此應用程式並未設定為要顯示錯誤資訊報表。
support-addons-title = 附加元件
support-addons-name = 名稱
support-addons-type = 類型
support-addons-enabled = 已啟用
support-addons-version = 版本
support-addons-id = ID
security-software-title = 安全軟體
security-software-type = 類型
security-software-name = 名稱
security-software-antivirus = 防毒軟體
security-software-antispyware = 防間諜軟體
security-software-firewall = 防火牆
features-title = { -brand-short-name } 功能
features-name = 名稱
features-version = 版本
features-id = ID
processes-title = 遠端處理程序
processes-type = 類型
processes-count = 數量
app-basics-title = 應用程式一般資訊
app-basics-name = 名稱
app-basics-version = 版本
app-basics-build-id = Build ID
app-basics-distribution-id = 發行 ID
app-basics-update-channel = 更新頻道
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] 更新目錄
       *[other] 更新資料夾
    }
app-basics-update-history = 更新記錄
app-basics-show-update-history = 顯示更新記錄
# Represents the path to the binary used to start the application.
app-basics-binary = 應用程式二進位檔案
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] 設定檔目錄
       *[other] 設定檔目錄
    }
app-basics-enabled-plugins = 啟用的外掛程式
app-basics-build-config = 編譯組態
app-basics-user-agent = 使用者代理字串（User Agent）
app-basics-os = 作業系統
app-basics-os-theme = 作業系統佈景主題
# Rosetta is Apple's translation process to run apps containing x86_64
# instructions on Apple Silicon. This should remain in English.
app-basics-rosetta = 經 Rosetta 轉譯
app-basics-memory-use = 記憶體使用量
app-basics-performance = 效能
app-basics-service-workers = 註冊的 Service Worker
app-basics-third-party = 第三方模組
app-basics-profiles = 設定檔
app-basics-launcher-process-status = 啟動器處理程序
app-basics-multi-process-support = 多程序視窗
app-basics-fission-support = Fission 視窗
app-basics-remote-processes-count = 遠端處理程序
app-basics-enterprise-policies = 企業政策
app-basics-location-service-key-google = Google Location Service 金鑰
app-basics-safebrowsing-key-google = Google Safebrowsing 金鑰
app-basics-key-mozilla = Waterfox Location Service 金鑰
app-basics-safe-mode = 安全模式
show-dir-label =
    { PLATFORM() ->
        [macos] 顯示於 Finder
        [windows] 開啟資料夾
       *[other] 開啟資料夾
    }
environment-variables-title = 環境變數
environment-variables-name = 名稱
environment-variables-value = 值
experimental-features-title = 實驗功能
experimental-features-name = 名稱
experimental-features-value = 值
modified-key-prefs-title = 修改過的重要偏好設定
modified-prefs-name = 名稱
modified-prefs-value = 值
user-js-title = user.js 偏好設定
user-js-description = 您的設定檔資料夾中有一個 <a data-l10n-name="user-js-link">user.js 檔案</a>，當中包含不是由 { -brand-short-name } 所建立的偏好設定。
locked-key-prefs-title = 被鎖定的重要偏好設定
locked-prefs-name = 名稱
locked-prefs-value = 值
graphics-title = 圖形
graphics-features-title = 功能
graphics-diagnostics-title = 診斷
graphics-failure-log-title = 錯誤紀錄
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = 決策紀錄
graphics-crash-guards-title = 因 Crash Guard 停用的功能
graphics-workarounds-title = Workarounds
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = 視窗通訊協定
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = 桌面環境
place-database-title = Places 資料庫
place-database-integrity = 資料完整
place-database-verify-integrity = 確認資料完整
a11y-title = 輔助功能
a11y-activated = 已啟用
a11y-force-disabled = 已強迫停用輔助功能
a11y-handler-used = 已使用 Accessible Handler
a11y-instantiator = Accessibility Instantiator
library-version-title = 程式庫版本
copy-text-to-clipboard-label = 將文字複製到剪貼簿
copy-raw-data-to-clipboard-label = 將原始資料複製到剪貼簿
sandbox-title = 沙盒
sandbox-sys-call-log-title = 被拒絕的系統呼叫
sandbox-sys-call-index = #
sandbox-sys-call-age = 秒鐘前
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = 程序類型
sandbox-sys-call-number = 系統呼叫
sandbox-sys-call-args = 引數
troubleshoot-mode-title = 診斷問題
restart-in-troubleshoot-mode-label = 疑難排解模式…
clear-startup-cache-title = 也可清除啟動快取
clear-startup-cache-label = 清除啟動快取…
startup-cache-dialog-title2 = 要重新啟動 { -brand-short-name } 來清理啟動快取嗎？
startup-cache-dialog-body2 = 將不會更改您的設定或移除擴充套件。
restart-button-label = 重新啟動

## Media titles

audio-backend = 音效後端
max-audio-channels = 最大頻道數
sample-rate = 偏好取樣率
roundtrip-latency = 往返延遲（標準差）
media-title = 媒體
media-output-devices-title = 輸出裝置
media-input-devices-title = 輸入裝置
media-device-name = 名稱
media-device-group = 群組
media-device-vendor = 廠商
media-device-state = 狀態
media-device-preferred = 偏好使用
media-device-format = 格式
media-device-channels = 頻道
media-device-rate = 取樣率
media-device-latency = 延滯
media-capabilities-title = 媒體能力
# List all the entries of the database.
media-capabilities-enumerate = 列舉資料庫

##

intl-title = 國際化與在地化
intl-app-title = 應用程式設定
intl-locales-requested = 要求使用的語系
intl-locales-available = 可用的語系
intl-locales-supported = 應用程式語系
intl-locales-default = 預設語系
intl-os-title = 作業系統
intl-os-prefs-system-locales = 系統語系
intl-regional-prefs = 區域偏好設定

## Remote Debugging
##
## The Waterfox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = 遠端除錯（Chromium 通訊協定）
remote-debugging-accepting-connections = 接受連線
remote-debugging-url = 網址

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days = 最近 { $days } 天內的錯誤資訊報表

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes = { $minutes } 分鐘前

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours = { $hours } 小時前

# Variables
# $days (integer) - Number of days since crash
crashes-time-days = { $days } 天前

# Variables
# $reports (integer) - Number of pending reports
pending-reports = 所有錯誤資訊報表（包含 { $reports } 筆在指定時間範圍內，還在處理中的報表）

raw-data-copied = 已複製原始資料至剪貼簿
text-copied = 已複製文字至剪貼簿

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = 因為您的顯示卡驅動程式版本過舊，已封鎖此功能。
blocked-gfx-card = 因為未解決的顯示卡驅動程式問題，已封鎖此功能。
blocked-os-version = 因為您的作業系統版本過舊，已封鎖此功能。
blocked-mismatched-version = 因為您的系統登錄檔與顯示卡驅動程式 DLL 檔案的版本不符，已封鎖此功能。
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = 因為您的顯示卡驅動程式版本過舊，已封鎖此功能。請試著更新您的顯示卡驅動程式到 { $driverVersion } 或更新版本。

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType 參數

compositing = 合成
hardware-h264 = H264 硬體解碼
main-thread-no-omtc = 主執行緒，無 OMTC
yes = 是
no = 否
unknown = 未知
virtual-monitor-disp = 虛擬螢幕顯示

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = 找到
missing = 缺少

gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = 顯示卡名稱
gpu-vendor-id = 銷售商 ID (Vendor ID)
gpu-device-id = 裝置 ID (Device ID)
gpu-subsys-id = Subsys ID
gpu-drivers = 顯示卡驅動程式
gpu-ram = 顯示卡記憶體大小
gpu-driver-vendor = 驅動程式廠商
gpu-driver-version = 驅動程式版本
gpu-driver-date = 驅動程式日期
gpu-active = 啟用
webgl1-wsiinfo = WebGL 1 驅動程式 WSI 資訊
webgl1-renderer = WebGL 1 驅動程式 Renderer
webgl1-version = WebGL 1 驅動程式版本
webgl1-driver-extensions = WebGL 1 驅動程式擴充套件
webgl1-extensions = WebGL 1 擴充套件
webgl2-wsiinfo = WebGL 2 驅動程式 WSI 資訊
webgl2-renderer = WebGL2 Renderer
webgl2-version = WebGL 2 驅動程式 Renderer
webgl2-driver-extensions = WebGL 2 驅動程式擴充套件
webgl2-extensions = WebGL 2 擴充套件

# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = 由於有已知問題，被加入封鎖名單: <a data-l10n-name="bug-link">bug { $bugNumber }</a>

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = 已封鎖，錯誤代碼 { $failureCode }

d3d11layers-crash-guard = D3D11 合成器
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = WMF VPX 視訊解碼器

reset-on-next-restart = 下次重新啟動時重設
gpu-process-kill-button = 結束 GPU 處理程序
gpu-device-reset = 裝置重設
gpu-device-reset-button = 觸發裝置重設
uses-tiling = 使用 Tiling
content-uses-tiling = 使用 Tiling（內容）
off-main-thread-paint-enabled = 已啟用 Off Main Thread Painting
off-main-thread-paint-worker-count = Off Main Thread Painting Worker 數量
target-frame-rate = 目標畫框率

min-lib-versions = 預期應有的最小版本
loaded-lib-versions = 使用中的版本

has-seccomp-bpf = Seccomp-BPF（過濾系統呼叫）
has-seccomp-tsync = Seccomp 執行緒同步
has-user-namespaces = 使用者命名空間
has-privileged-user-namespaces = 取得權限程序的使用者命名空間
can-sandbox-content = 內容程序沙盒
can-sandbox-media = 媒體外掛程式沙盒
content-sandbox-level = 內容程序沙盒等級
effective-content-sandbox-level = 有效內容處理程序沙盒等級
content-win32k-lockdown-state = 內容處理程序的 Win32k Lockdown 狀態
sandbox-proc-type-content = 內容
sandbox-proc-type-file = 檔案內容
sandbox-proc-type-media-plugin = 媒體外掛程式
sandbox-proc-type-data-decoder = 資料解碼器

startup-cache-title = 啟動快取
startup-cache-disk-cache-path = 磁碟快取路徑
startup-cache-ignore-disk-cache = 忽略磁碟快取
startup-cache-found-disk-cache-on-init = 在初始化時找到磁碟快取
startup-cache-wrote-to-disk-cache = 已寫入磁碟快取

launcher-process-status-0 = 啟用
launcher-process-status-1 = 由於失敗而停用
launcher-process-status-2 = 強制停用
launcher-process-status-unknown = 未知狀態

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/{ $totalWindows }
fission-status-experiment-control = 由實驗關閉
fission-status-experiment-treatment = 由實驗開啟
fission-status-disabled-by-e10s-env = 由環境關閉
fission-status-enabled-by-env = 由環境開啟
fission-status-disabled-by-safe-mode = 因安全模式關閉
fission-status-enabled-by-default = 預設開啟
fission-status-disabled-by-default = 預設關閉
fission-status-enabled-by-user-pref = 由使用者開啟
fission-status-disabled-by-user-pref = 由使用者關閉
fission-status-disabled-by-e10s-other = 已停用 e10s
fission-status-enabled-by-rollout = 透過分階段推出啟用

async-pan-zoom = 異步 Pan/Zoom
apz-none = 無
wheel-enabled = 已啟用滾輪輸入
touch-enabled = 已啟用觸控輸入
drag-enabled = 已開啟捲動列拖曳
keyboard-enabled = 已啟用鍵盤
autoscroll-enabled = 已開啟自動捲動
zooming-enabled = 已開啟平滑手指縮放

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = 因為不支援的偏好設定: { $preferenceKey }，已停用異步滾輪輸入
touch-warning = 因為不支援的偏好設定: { $preferenceKey }，已停用異步觸控輸入

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = 未使用
policies-active = 使用中
policies-error = 錯誤

## Printing section

support-printing-title = 列印
support-printing-troubleshoot = 疑難排解
support-printing-clear-settings-button = 清除儲存的列印設定
support-printing-modified-settings = 更改過的列印設定
support-printing-prefs-name = 名稱
support-printing-prefs-value = 值

## Normandy sections

support-remote-experiments-title = 遠端實驗
support-remote-experiments-name = 名稱
support-remote-experiments-branch = 實驗分支
support-remote-experiments-see-about-studies = 若需更多資訊，請參考 <a data-l10n-name="support-about-studies-link">about:studies</a>。當中包含如何關閉單一實驗，或防止 { -brand-short-name } 在未來進行任何此類實驗的資訊。

support-remote-features-title = 遠端功能
support-remote-features-name = 名稱
support-remote-features-status = 狀態
