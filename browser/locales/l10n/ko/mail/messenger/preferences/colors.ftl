# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = 색상
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = 글자와 배경

text-color-label =
    .value = 글자:
    .accesskey = t

background-color-label =
    .value = 배경
    .accesskey = b

use-system-colors =
    .label = 시스템 색상 사용
    .accesskey = s

colors-link-legend = 링크 색상

link-color-label =
    .value = 방문하지 않은 링크:
    .accesskey = l

visited-link-color-label =
    .value = 방문한 링크:
    .accesskey = v

underline-link-checkbox =
    .label = 링크에 밑줄
    .accesskey = u

override-color-label =
    .value = 지정한 색상 덮어쓰기:
    .accesskey = O

override-color-always =
    .label = 항상

override-color-auto =
    .label = 높은 채도 테마에서만

override-color-never =
    .label = 사용하지 않음
