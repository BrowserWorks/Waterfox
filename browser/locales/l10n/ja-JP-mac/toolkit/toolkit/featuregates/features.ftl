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
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = <a data-l10n-name="mdn-inputmode">inputmode</a> グローバル属性の実装が <a data-l10n-name="whatwg">WHATWG 仕様</a> の変更に従って更新されました。ただし、contenteditable コンテンツで利用可能にするなど、まだ他の部分の変更が必要です。詳細は <a data-l10n-name="bugzilla">bug 1205133</a> を参照してください。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = Web API: <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = <a data-l10n-name="rel">rel</a> 属性の値に <code>"preload"</code> が設定された <a data-l10n-name="link">&lt;link&gt;</a> 要素は、ページのライフサイクルの早い段階でリソースをダウンロードさせます。これは、リソースを予め利用可能にしておき、ページの描画がブロックされるようなことを減らしてパフォーマンス向上を助けることを意図しています。詳細は <a data-l10n-name="readmore">“Preloading content with <code>rel="preload"</code>”</a> を読むか、<a data-l10n-name="bugzilla">bug 1583604</a> を参照してください。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS: 疑似クラス: :focus-visible
experimental-features-css-focus-visible-description = フォーカスのスタイルをボタンやフォームコントロールなどの要素に適用できるようにします。これらの要素が、マウスや他のポインティングデバイスではなく、キーボードでフォーカスされた時 (タブキーで要素を順に選択した場合など) のみ適用されます。詳細は <a data-l10n-name="bugzilla">bug 1617600</a> を参照してください。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = Web API: beforeinput イベント
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = グローバルの <a data-l10n-name="mdn-beforeinput">beforeinput</a> イベントは、<a data-l10n-name="mdn-input">&lt;input&gt;</a> および <a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a> 要素、または <a data-l10n-name="mdn-contenteditable">contenteditable</a> 属性が有効な任意の要素で、その要素の値が変更される直前に発生します。このイベントは、ユーザーインタラクションについて、ウェブアプリがブラウザーのデフォルト動作を上書きすることを許可します。ウェブアプリはユーザーが入力する特定の文字だけをキャンセルしたり、スタイル付けされたテキストのペーストを承認されたスタイルのみに変更できます。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: 構造化スタイルシート
experimental-features-css-constructable-stylesheets-description = <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> インターフェースにコンストラクターが追加され、様々な関連する変更によって、HTML にスタイルシートを追加せずに新しいスタイルシートを直接作成することが可能になりました。これにより、<a data-l10n-name="mdn-shadowdom">Shadow DOM</a> の使用時にも再利用可能なスタイルシートが簡単に作成できます。詳細は <a data-l10n-name="bugzilla">bug 1520690</a> を参照してください。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = Web API: Media Session API
experimental-features-media-session-api-description = { -brand-short-name } が現在実装する Media Session API はすべて実験段階です。この API は、メディア関連の通知の扱いをカスタマイズしたり、メディア再生を管理するインターフェースの提供に役立つイベントやデータの管理、メディアファイルのメタデータの取得に使用します。詳細は <a data-l10n-name="bugzilla">bug 1112032</a> を参照してください。

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
    .label = Cookie: デフォルトで SameSite=Lax
experimental-features-cookie-samesite-lax-by-default2-description = Cookie に “SameSite” 属性が指定されていない場合、デフォルトで “SameSite=Lax” として扱います。開発者は、“SameSite=None” が暗黙的に濫用されている現状にオプトインする必要があります。

# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Cookie: SameSite=None は secure 属性が必要
experimental-features-cookie-samesite-none-requires-secure2-description = “SameSite=None” 属性が指定された Cookie は secure 属性を必要とします。この機能は “Cookie: デフォルトで SameSite=Lax” を必要とします。

# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = about:home 起動時キャッシュ
experimental-features-abouthome-startup-cache-description = 起動時にデフォルトで読み込まれる初期 about:home ドキュメントのキャッシュ。このキャッシュの目的は起動時のパフォーマンスを向上させることです。

experimental-features-print-preview-tab-modal =
    .label = プリントプレビューの再設計
experimental-features-print-preview-tab-modal-description = 再設計されたプリントプレビューを導入し、macOS でもプリントプレビューが利用可能になりました。この再設計により、機能がうまく動作しなかったりプリント関連の設定がすべて含まれていない可能性があります。すべてのプリント関連の設定にアクセスするには、プリントパネルから “システムダイアログを使用してプリント...” を選択してください。

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

# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = グラフィックス: スムーズなピンチズーム
experimental-features-graphics-desktop-zooming-description = タッチスクリーンと精密なタッチパッドでのスムーズなピンチズームのサポートを有効にします。
