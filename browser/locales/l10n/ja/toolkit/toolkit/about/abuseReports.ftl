# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title.
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = { $addon-name } を報告

abuse-report-title-extension = この拡張機能を { -vendor-short-name } に報告
abuse-report-title-theme = このテーマを { -vendor-short-name } に報告
abuse-report-subtitle = どのような問題ですか？

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = 作者: <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
  どれを選択すべきか分からない時は、
  <a data-l10n-name="learnmore-link">拡張機能やテーマの報告について学んでください。</a>

abuse-report-submit-description = 問題の詳細を記入してください (任意)
abuse-report-textarea =
  .placeholder = 詳細を報告していただければ、問題を解決しやすくなります。あなたの体験した問題について記入してください。健全なウェブを保つためのご協力に感謝します。
abuse-report-submit-note =
  注意: 個人情報 (氏名、メールアドレス、電話番号、所在地など) を記入してはいけません。
  { -vendor-short-name } は、これらの報告を永久に保管します。

## Panel buttons.

abuse-report-cancel-button = キャンセル
abuse-report-next-button = 次へ
abuse-report-goback-button = 戻る
abuse-report-submit-button = 送信

## Message bars descriptions.
##
## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = <span data-l10n-name="addon-name">{ $addon-name }</span> についての報告をキャンセルしました。
abuse-report-messagebar-submitting = <span data-l10n-name="addon-name">{ $addon-name }</span> についての報告を送信しています。
abuse-report-messagebar-submitted = ご報告ありがとうございます。<span data-l10n-name="addon-name">{ $addon-name }</span> を削除しますか？
abuse-report-messagebar-submitted-noremove = ご報告ありがとうございました。
abuse-report-messagebar-removed-extension = ご報告ありがとうございました。拡張機能 <span data-l10n-name="addon-name">{ $addon-name }</span> を削除しました。
abuse-report-messagebar-removed-theme = ご報告ありがとうございました。テーマ <span data-l10n-name="addon-name">{ $addon-name }</span> を削除しました。
abuse-report-messagebar-error = <span data-l10n-name="addon-name">{ $addon-name }</span> についての報告の送信中にエラーが発生しました。
abuse-report-messagebar-error-recent-submit = 別の報告が最近送信されているため、<span data-l10n-name="addon-name">{ $addon-name }</span> についての報告は送信されませんでした。

## Message bars actions.

abuse-report-messagebar-action-remove-extension = はい、削除します
abuse-report-messagebar-action-keep-extension = いいえ、保持します
abuse-report-messagebar-action-remove-theme = はい、削除します
abuse-report-messagebar-action-keep-theme = いいえ、保持します
abuse-report-messagebar-action-retry = 再試行
abuse-report-messagebar-action-cancel = キャンセル

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = コンピューターに損害を与えた、または個人データを漏洩させた
abuse-report-damage-example = 例: マルウェアを忍び込ませたりデータを盗んだりする

abuse-report-spam-reason-v2 = スパムを含む、または不要な広告を挿入した
abuse-report-spam-example = 例: ウェブページに広告を挿入する

abuse-report-settings-reason-v2 = ユーザーに確認せずに検索エンジンやホームページ、新しいタブの設定を変更した
abuse-report-settings-suggestions = 拡張機能を報告する前に設定を変更してみてください:
abuse-report-settings-suggestions-search = 既定の検索設定を変更する
abuse-report-settings-suggestions-homepage = ホームページと新しいタブの設定を変更する

abuse-report-deceptive-reason-v2 = 説明とは違うものだった
abuse-report-deceptive-example = 例: 実際の動作とは違う説明やイメージ

abuse-report-broken-reason-extension-v2 = 動作しない、ウェブサイトの表示を崩す、{ -brand-product-name } の動作を遅くする
abuse-report-broken-reason-theme-v2 = 動作しない、またはブラウザーの表示を崩す
abuse-report-broken-example = 例: 機能の動作が遅い、使うのが困難、まったく動作しない、ウェブサイトの一部が読み込まれない、または表示が異常
abuse-report-broken-suggestions-extension =
  拡張機能のバグを見つけたのかもしれません。ここに報告するのもよいですが、動作の問題を解決する最善の方法は、拡張機能の開発者に問い合わせることです。
  開発者の情報を得るには、<a data-l10n-name="support-link">その拡張機能のウェブサイト</a> を訪れてください。
abuse-report-broken-suggestions-theme =
  テーマのバグを見つけたのかもしれません。ここに報告するのもよいですが、動作の問題を解決する最善の方法は、テーマの作者に問い合わせることです。
  作者の情報を得るには、<a data-l10n-name="support-link">そのテーマのウェブサイト</a> を訪れてください。

abuse-report-policy-reason-v2 = 不愉快または暴力的、違法なコンテンツを含む
abuse-report-policy-suggestions =
  注意: 著作権や商標の問題は別のプロセスで報告してください。
  <a data-l10n-name="report-infringement-link">こちらの説明に従って問題を報告</a> してください。

abuse-report-unwanted-reason-v2 = 不要なのに削除の方法が分からない
abuse-report-unwanted-example = 例: 別のプログラムがユーザーの許可なくインストールした

abuse-report-other-reason = その他
