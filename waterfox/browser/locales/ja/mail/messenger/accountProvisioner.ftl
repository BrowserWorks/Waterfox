# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-provisioner-tab-title = サービスプロバイダーから新しいメールアドレスを取得
provisioner-searching-icon =
    .alt = 検索しています...
account-provisioner-title = 新しいメールアドレスの作成
account-provisioner-description = 私たちが信頼するパートナー企業のサービスを利用して、プライベートで安全な新しいメールアドレスを取得できます。
account-provisioner-start-help = 検索語句は、利用可能なメールアドレスを見つける目的で { -vendor-short-name } (<a data-l10n-name="mozilla-privacy-link">プライバシーポリシー</a>) とサードパーティのメールプロバイダー <strong>mailfence.com</strong> (<a data-l10n-name="mailfence-privacy-link">プライバシーポリシー</a>、<a data-l10n-name="mailfence-tou-link">利用規約</a>) および <strong>gandi.net</strong> (<a data-l10n-name="gandi-privacy-link">プライバシーポリシー</a>、<a data-l10n-name="gandi-tou-link">利用規約</a>) に送信されます。
account-provisioner-mail-account-title = 新しいメールアドレスの購入
account-provisioner-mail-account-description = Thunderbird はユーザーにプライベートで安全な新しいメールアドレスを提供するために <a data-l10n-name="mailfence-home-link">Mailfence 社</a> と提携しています。私たちは、すべての人が安全にメールを利用できるべきであると信じています。
account-provisioner-domain-title = 個人のメールアドレスおよびドメインの購入
account-provisioner-domain-description = Thunderbird はユーザーにカスタムドメインを提供するために <a data-l10n-name="gandi-home-link">Gandi 社</a> と提携しています。このドメイン上で任意のアドレスを使用することができます。

## Forms

account-provisioner-mail-input =
    .placeholder = あなたの氏名、ニックネーム、または他の検索語句
account-provisioner-domain-input =
    .placeholder = あなたの氏名、ニックネーム、または他の検索語句
account-provisioner-search-button = 検索
account-provisioner-button-cancel = キャンセル
account-provisioner-button-existing = 既存のメールアカウントを使用
account-provisioner-button-back = 戻る

## Notifications

account-provisioner-fetching-provisioners = プロビジョナーを受信しています...
account-provisioner-connection-issues = サインアップサーバーと通信できませんでした。接続を確認してください。
account-provisioner-searching-email = 利用可能なメールアカウントを検索しています...
account-provisioner-searching-domain = 利用可能なドメイン名を検索しています...
account-provisioner-searching-error = 候補のアドレスが見つかりませんでした。別の検索語句を試してください。

## Illustrations

account-provisioner-step1-image =
    .title = 作成するアカウントを選択してください

## Search results

# Variables:
# $count (Number) - The number of domains found during search.
account-provisioner-results-title =
    { $count ->
        [one] 利用可能なアドレスが 1 件見つかりました:
        *[other] 利用可能なアドレスが { $count } 件見つかりました:
    }
account-provisioner-mail-results-caption = ニックネームや他の検索語句を試して別のメールアドレスを見つけてください。
account-provisioner-domain-results-caption = ニックネームや他の検索語句を試して別のドメイン名を見つけてください。
account-provisioner-free-account = 無料
account-provision-price-per-year = { $price } / 年
account-provisioner-all-results-button = すべての検索結果を表示
account-provisioner-open-in-tab-img =
    .title = 新しいタブで開く
