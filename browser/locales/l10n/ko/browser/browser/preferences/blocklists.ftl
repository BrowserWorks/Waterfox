# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = 차단 목록
    .style = width: 50em
blocklist-description = 온라인 추적기를 차단하기 위해 { -brand-short-name }가 사용하는 목록을 선택하세요. <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>에서 목록 제공.
blocklist-close-key =
    .key = w
blocklist-treehead-list =
    .label = 목록
blocklist-button-cancel =
    .label = 취소
    .accesskey = C
blocklist-button-ok =
    .label = 변경 내용 저장
    .accesskey = S
blocklist-dialog =
    .buttonlabelaccept = 변경 내용 저장
    .buttonaccesskeyaccept = S
# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }
blocklist-item-moz-std-listName = 레벨 1 차단 목록 (권장).
blocklist-item-moz-std-description = 일부 추적기를 허용하여 웹 사이트 깨짐을 줄입니다.
blocklist-item-moz-full-listName = 레벨 2 차단 목록
blocklist-item-moz-full-description = 감지된 모든 추적기를 차단합니다. 일부 웹 사이트 또는 콘텐츠가 제대로 로드되지 않을 수 있습니다.
