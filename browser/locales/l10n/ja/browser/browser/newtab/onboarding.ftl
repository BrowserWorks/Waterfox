# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.

### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.

## Welcome page strings

onboarding-welcome-header = { -brand-short-name } にようこそ
onboarding-start-browsing-button-label = ブラウジングを開始
onboarding-not-now-button-label = 後で

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = { -brand-short-name } をインストールしました
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = <img data-l10n-name="icon"/> <b>{ $addon-name }</b> をインストールしてみましょう。
return-to-amo-add-extension-label = 拡張機能を追加

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = <span data-l10n-name="zap">{ -brand-short-name }</span> にようこそ
onboarding-multistage-welcome-subtitle = 高速で安全、プライバシー第一の、非営利組織によるブラウザーです。
onboarding-multistage-welcome-primary-button-label = 初期設定を開始
onboarding-multistage-welcome-secondary-button-label = ログイン
onboarding-multistage-welcome-secondary-button-text = アカウントをお持ちですか？

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = { -brand-short-name } を <span data-l10n-name="zap">既定のブラウザー</span> にしましょう
onboarding-multistage-set-default-subtitle = 高速で安全、いつでもプライバシーが第一です。
onboarding-multistage-set-default-primary-button-label = 既定のブラウザーにする
onboarding-multistage-set-default-secondary-button-label = 後で

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = クリックして <span data-l10n-name="zap">{ -brand-short-name }</span> を始めましょう
onboarding-multistage-pin-default-subtitle = いつでも高速で安全、プライベートなブラウジングを。
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = 既定のアプリの設定が開いたら、[Web ブラウザー]から { -brand-short-name } を選択してください
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = { -brand-short-name } をタスクバーにピン留めし、既定のアプリの設定を開きます
onboarding-multistage-pin-default-primary-button-label = { -brand-short-name } を既定のブラウザーに設定する

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = パスワード、ブックマーク、<span data-l10n-name="zap">その他のデータ</span>を<br/>インポートしましょう。
onboarding-multistage-import-subtitle = その他のブラウザーからですか？ 簡単に { -brand-short-name } に持ち込めます。
onboarding-multistage-import-primary-button-label = インポートを開始
onboarding-multistage-import-secondary-button-label = 後で

# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = この端末から見つかったサイトを表示しています。{ -brand-short-name } は、あなたがこれらのサイトをインポートすることを選択しない限り、他のブラウザーからデータを保存または同期することはありません。

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = はじめる: { $current } / { $total } ページ

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = <span data-l10n-name="zap">テーマ</span>を選択してください
onboarding-multistage-theme-subtitle = テーマで { -brand-short-name } をパーソナライズできます
onboarding-multistage-theme-primary-button-label2 = 完了
onboarding-multistage-theme-secondary-button-label = 後で

# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = 自動

onboarding-multistage-theme-label-light = Light
onboarding-multistage-theme-label-dark = Dark
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text =
  Fire starts
  here

# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — 家具デザイナー、Waterfox ファン

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = アニメーションをオフにする

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header = { PLATFORM() ->
    [macos] すぐアクセスできるよう { -brand-short-name } を Dock に追加しましょう
   *[other] すぐアクセスできるよう { -brand-short-name } をタスクバーにピン留めしましょう
}
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label = { PLATFORM() ->
    [macos] Dock に追加
   *[other] タスクバーにピン留め
}

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = はじめましょう

mr1-onboarding-welcome-header = { -brand-short-name } にようこそ
mr1-onboarding-set-default-pin-primary-button-label = { -brand-short-name } を優先ブラウザーに設定する
    .title = { -brand-short-name } を既定のブラウザーに設定して、タスクバーにピン留めしましょう

# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = { -brand-short-name } を既定のブラウザーに設定する
mr1-onboarding-set-default-secondary-button-label = 後で
mr1-onboarding-sign-in-button-label = ログイン

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = { -brand-short-name } を既定のブラウザーに設定
mr1-onboarding-default-subtitle = 高速、安全、プライベートなブラウザーにお任せください。
mr1-onboarding-default-primary-button-label = 既定のブラウザーに設定する

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = すべて持ってこられます
mr1-onboarding-import-subtitle = パスワードやブックマークなどを<br/>インポートできます。

# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = { $previous } からインポート

# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = 以前のブラウザーからインポート
mr1-onboarding-import-secondary-button-label = 後で

mr1-onboarding-theme-header = 自分らしく
mr1-onboarding-theme-subtitle = テーマで { -brand-short-name } をパーソナライズできます。
mr1-onboarding-theme-primary-button-label = テーマを保存
mr1-onboarding-theme-secondary-button-label = 後で

# System theme uses operating system color settings
mr1-onboarding-theme-label-system = システムテーマ

mr1-onboarding-theme-label-light = Light
mr1-onboarding-theme-label-dark = Dark
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title = ご使用の OS のボタン、メニュー、ウィンドウの外観を継承します

# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description = ご使用の OS のボタン、メニュー、ウィンドウの外観を継承します

# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title = 明るい外観のボタン、メニュー、ウィンドウを使用します

# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description = 明るい外観のボタン、メニュー、ウィンドウを使用します

# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title = 暗い外観のボタン、メニュー、ウィンドウを使用します

# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description = 暗い外観のボタン、メニュー、ウィンドウを使用します

# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title = カラフルな外観のボタン、メニュー、ウィンドウを使用します

# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description = カラフルな外観のボタン、メニュー、ウィンドウを使用します

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
  .title = OS のボタン、メニュー、ウィンドウの外観です。

# Input description for system theme
mr1-onboarding-theme-description-system =
  .aria-description = OS のボタン、メニュー、ウィンドウの外観です。

# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
  .title = 明るい外観のボタン、メニュー、ウィンドウを使用します。

# Input description for light theme
mr1-onboarding-theme-description-light =
  .aria-description = 明るい外観のボタン、メニュー、ウィンドウを使用します。

# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
  .title = 暗い外観のボタン、メニュー、ウィンドウを使用します。

# Input description for dark theme
mr1-onboarding-theme-description-dark =
  .aria-description = 暗い外観のボタン、メニュー、ウィンドウを使用します。

# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
  .title = ダイナミックでカラフルな外観のボタン、メニュー、ウィンドウを使用します。

# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
  .aria-description = ダイナミックでカラフルな外観のボタン、メニュー、ウィンドウを使用します。
