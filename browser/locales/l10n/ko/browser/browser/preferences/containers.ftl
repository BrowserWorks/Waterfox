# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = 새 컨테이너 추가
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } 컨테이너 설정
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = { $name } 컨테이너 설정
    .style = width: 45em
containers-window-close =
    .key = w
# This is a term to store style to be applied
# on the three labels in the containers add/edit dialog:
#   - name
#   - icon
#   - color
#
# Using this term and referencing it in the `.style` attribute
# of the three messages ensures that all three labels
# will be aligned correctly.
-containers-labels-style = min-width: 4rem
containers-name-label = 이름
    .accesskey = N
    .style = { -containers-labels-style }
containers-name-text =
    .placeholder = 컨테이너 이름 입력
containers-icon-label = 아이콘
    .accesskey = I
    .style = { -containers-labels-style }
containers-color-label = 색상
    .accesskey = o
    .style = { -containers-labels-style }
containers-button-done =
    .label = 완료
    .accesskey = D
containers-dialog =
    .buttonlabelaccept = 완료
    .buttonaccesskeyaccept = D
containers-color-blue =
    .label = 파랑
containers-color-turquoise =
    .label = 청록
containers-color-green =
    .label = 초록
containers-color-yellow =
    .label = 노랑
containers-color-orange =
    .label = 주황
containers-color-red =
    .label = 빨강
containers-color-pink =
    .label = 분홍
containers-color-purple =
    .label = 보라
containers-color-toolbar =
    .label = 도구 모음과 맞춤
containers-icon-fence =
    .label = 울타리
containers-icon-fingerprint =
    .label = 지문
containers-icon-briefcase =
    .label = 서류 가방
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = 달러 기호
containers-icon-cart =
    .label = 쇼핑 카트
containers-icon-circle =
    .label = 점
containers-icon-vacation =
    .label = 휴가
containers-icon-gift =
    .label = 선물
containers-icon-food =
    .label = 먹을거리
containers-icon-fruit =
    .label = 과일
containers-icon-pet =
    .label = 애완동물
containers-icon-tree =
    .label = 나무
containers-icon-chill =
    .label = 추운
