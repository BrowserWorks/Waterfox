# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-type = { $type } 필드 삭제

#   $type (String) - the type of the addressing row
remove-address-row-type-label =
    .tooltiptext = { $type } 필드 삭제

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
       *[other] { $count } 개 주소의 { $type } 형식을 사용하려면 왼쪽 화살표 키를 사용하십시오.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: 수정하려면 엔터를, 지우려면 삭제를 누르세요.
       *[other] { $email }, { $count } 개 중 1: 수정하려면 엔터를, 지우려면 삭제를 누르세요.
    }

pill-action-edit =
    .label = 주소 수정
    .accesskey = e

pill-action-move-to =
    .label = 받는 사람으로 이동
    .accesskey = t

pill-action-move-cc =
    .label = 참조로 이동
    .accesskey = c

pill-action-move-bcc =
    .label = 숨은 참조로 이동
    .accesskey = b

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } 첨부파일
           *[other] { $count } 첨부파일
        }
    .accesskey = m

#   $count (Number) - the number of attachments in the attachment bucket
attachments-placeholder-tooltip =
    .tooltiptext =
        { $count ->
            [1] { $count } 첨부파일
           *[other] { $count } 첨부파일
        }

#   { attachment-bucket-count.accesskey } - Do not localize this message.
key-toggle-attachment-pane =
    .key = { attachment-bucket-count.accesskey }

button-return-receipt =
    .label = 수신 확인
    .tooltiptext = 이 메시지에 대한 수신 확인을 요청
