# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

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

#   $email (String) - the email address
pill-tooltip-invalid-address = { $email }은 유효한 이메일 주소가 아닙니다.

#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email }은 주소록에 없습니다.

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

# Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Shift+
    }

trigger-attachment-picker-key = A
toggle-attachment-pane-key = M

menuitem-toggle-attachment-pane =
    .label = 첨부 창
    .accesskey = m
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }

toolbar-button-add-attachment =
    .label = 첨부
    .tooltiptext = 첨부파일 추가 ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })

add-attachment-notification-reminder =
    .label = 첨부 파일 추가…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }

menuitem-attach-files =
    .label = 파일…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }

context-menuitem-attach-files =
    .label = 첨부 파일…
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } 첨부파일
           *[other] { $count } 첨부파일
        }
    .accesskey = m

expand-attachment-pane-tooltip =
    .tooltiptext = 첨부 파일 창 보기 ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })

collapse-attachment-pane-tooltip =
    .tooltiptext = 첨부 파일 창 닫기 ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })

drop-file-label-attachment =
    { $count ->
       *[other] 첨부 파일로 추가
    }

drop-file-label-inline =
    { $count ->
       *[other] 인라인 추가
    }

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = 첫번째로 이동
move-attachment-left-panel-button =
    .label = 왼쪽으로 이동
move-attachment-right-panel-button =
    .label = 오른쪽으로 이동
move-attachment-last-panel-button =
    .label = 마지막으로 이동

button-return-receipt =
    .label = 수신 확인
    .tooltiptext = 이 메시지에 대한 수신 확인을 요청

# Encryption

# Addressing Area


## Notifications

## Editing

# Tools

