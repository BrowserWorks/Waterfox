# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry レイアウト
experimental-features-css-masonry-description = 実験的な CSS Masonry レイアウト機能のサポートを有効にします。この機能の解説は <a data-l10n-name="explainer">こちらの説明</a> を参照してください。フィードバックを提供するには、<a data-l10n-name="w3c-issue">GitHub issue</a> または <a data-l10n-name="bug">こちらのバグ</a> にコメントしてください。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = この新しい API は、ユーザーの端末やコンピューターに搭載された <a data-l10n-name="wikipedia">Graphics Processing Unit (GPU)</a> を使用するグラフィックス描画と計算を扱うための低レベルサポートを提供します。WebGPU の <a data-l10n-name="spec">仕様</a> はまだ策定中です。詳細は <a data-l10n-name="bugzilla">bug 1602129</a> を参照してください。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = メディア: AVIF
experimental-features-media-avif-description = この機能を有効にすると、{ -brand-short-name } が AV1 Image File (AVIF) 形式をサポートします。これは、AV1 動画圧縮アルゴリズムを利用して画像サイズを削減した静止画像のファイル形式です。詳細は <a data-l10n-name="bugzilla">bug 1443863</a> を参照してください。

 # The title of the experiment should be kept in English as it may be referenced
 # by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = メディア: JPEG XL
experimental-features-media-jxl-description = この機能を有効にすると、{ -brand-short-name } が JPEG XL (JXL) 形式をサポートします。これは、従来の JPEG ファイルにロスレス変形等のサポートが追加された画像ファイル形式です。詳細は <a data-l10n-name="bugzilla">bug 1539075</a> を参照してください。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = <a data-l10n-name="mdn-inputmode">inputmode</a> グローバル属性の実装が <a data-l10n-name="whatwg">WHATWG 仕様</a> の変更に従って更新されました。ただし、contenteditable コンテンツで利用可能にするなど、まだ他の部分の変更が必要です。詳細は <a data-l10n-name="bugzilla">bug 1205133</a> を参照してください。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: 構造化スタイルシート
experimental-features-css-constructable-stylesheets-description = <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> インターフェースにコンストラクターが追加され、様々な関連する変更によって、HTML にスタイルシートを追加せずに新しいスタイルシートを直接作成することが可能になりました。これにより、<a data-l10n-name="mdn-shadowdom">Shadow DOM</a> の使用時にも再利用可能なスタイルシートが簡単に作成できます。詳細は <a data-l10n-name="bugzilla">bug 1520690</a> を参照してください。

experimental-features-devtools-color-scheme-simulation =
    .label = 開発ツール: カラースキームのシミュレーション
experimental-features-devtools-color-scheme-simulation-description = <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-scheme</a> メディアクエリーがテストできる異なるカラースキームをシミュレートするオプションを追加しました。このメディアクエリーを使用すると、ライトテーマとダークテーマのどちらでも、ユーザーの好みに応じてスタイルシートを適用できます。この機能はブラウザーの設定 (または、ブラウザーがシステムのカラースキームに従う場合はオペレーティングシステムの設定) を変更せずにコードをテストできます。詳細は <a data-l10n-name="bugzilla1">bug 1550804</a> および <a data-l10n-name="bugzilla2">bug 1137699</a> を参照してください。

experimental-features-devtools-execution-context-selector =
    .label = 開発ツール: 実行コンテキストセレクター
experimental-features-devtools-execution-context-selector-description = この機能はコンソールのコマンドラインにボタンを表示します。このボタンを押すとコンソールで入力した式を実行できます。詳細は <a data-l10n-name="bugzilla1">bug 1605154</a> および <a data-l10n-name="bugzilla2">bug 1605153</a> を参照してください。

experimental-features-devtools-compatibility-panel =
    .label = 開発ツール: 互換性パネル
experimental-features-devtools-compatibility-panel-description = アプリのブラウザー互換性情報を表示するページインスペクターのサイドパネルです。詳細は <a data-l10n-name="bugzilla">bug 1584464</a> を参照してください。

# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Cookie: 既定で SameSite=Lax
experimental-features-cookie-samesite-lax-by-default2-description = Cookie に “SameSite” 属性が指定されていない場合、既定で “SameSite=Lax” として扱います。開発者は、“SameSite=None” が暗黙的に濫用されている現状にオプトインする必要があります。

# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Cookie: SameSite=None は secure 属性が必要
experimental-features-cookie-samesite-none-requires-secure2-description = “SameSite=None” 属性が指定された Cookie は secure 属性を必要とします。この機能は “Cookie: 既定で SameSite=Lax” を必要とします。

# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = about:home 起動時キャッシュ
experimental-features-abouthome-startup-cache-description = 起動時に既定で読み込まれる初期 about:home ドキュメントのキャッシュ。このキャッシュの目的は起動時のパフォーマンスを向上させることです。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookie: SameSite でスキームも区別
experimental-features-cookie-samesite-schemeful-description = 同じドメインで異なるスキーム (例: http://example.com と https://example.com) の Cookie を同一サイトではなく別のサイトとして扱います。セキュリティが向上しますが、コンテンツが機能しなくなる可能性があります。

# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = 開発ツール: Service Worker のデバッグ
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = 開発ツールのデバッガーパネルで Service Worker の実験的なサポートを有効にします。この機能は開発ツールの動作を遅くし、メモリー消費が増加します。

# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = WebRTC の全ミュート切り替え
experimental-features-webrtc-global-mute-toggles-description = WebRTC グローバル共有インジケーターで、マイクとカメラの映像のミュートをグローバルに操作できるようになりました。

# Win32k Lockdown
experimental-features-win32k-lockdown =
    .label = Win32k ロックダウン
experimental-features-win32k-lockdown-description = ブラウザータブ内での Win32k API の使用を無効化します。セキュリティが向上しますが、まだ不安定で問題を抱えている可能性があります。 (Windows のみ)

# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = JavaScript の性能とメモリ効率を改善するプロジェクトである Warp を有効にします。

# Fission is the name of the feature and should not be translated.
experimental-features-fission =
    .label = Fission (サイト隔離)
experimental-features-fission-description = Fission (サイト隔離) は、セキュリティバグ防御の追加レイヤーを提供する { -brand-short-name } の実験的な機能です。Fission が各サイトを別のプロセスに隔離することにより、ユーザーが訪れている他のページからの情報に悪意のあるサイトがアクセスすることを困難にします。これは { -brand-short-name } における大きな構造上の変更を伴うため、動作テストと遭遇した問題の報告にご協力をお願いします。詳しい情報は、<a data-l10n-name="wiki">Wiki ページ</a> を参照してください。

# Support for having multiple Picture-in-Picture windows open simultaneously
experimental-features-multi-pip =
    .label = ピクチャーインピクチャーの複数サポート
experimental-features-multi-pip-description = 複数のピクチャーインピクチャーウィンドウを同時に開けるようにする実験的なサポートです。

experimental-features-http3 =
    .label = HTTP/3 プロトコル
experimental-features-http3-description = HTTP/3 プロトコルの実験的なサポートです。

# Search during IME
experimental-features-ime-search =
    .label = アドレスバー: IME 変換中に結果を表示
experimental-features-ime-search-description = IME (Input Method Editor) は、東アジアまたはインド系の言語の複雑な文字 (かな漢字変換など) を標準のキーボードで入力するためのツールです。この実験的な機能を有効にすると、IME を使用した文字入力中に、アドレスバーパネルを開いたまま検索結果や検索候補を表示できます。ただし、IME のパネルがアドレスバーの検索結果を隠してしまうことがあります。この設定は、IME のパネルのこのような挙動を想定していません。
