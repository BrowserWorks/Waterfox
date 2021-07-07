# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tab-context-new-tab =
    .label = 새 탭
    .accesskey = w
reload-tab =
    .label = 탭 새로 고침
    .accesskey = R
select-all-tabs =
    .label = 모든 탭 선택
    .accesskey = S
duplicate-tab =
    .label = 탭 복제
    .accesskey = D
duplicate-tabs =
    .label = 탭 복제
    .accesskey = D
# The following string is displayed on a menuitem that will close the tabs from the start of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Left" and in right-to-left languages this should use "Right".
close-tabs-to-the-start =
    .label = 왼쪽 탭 닫기
    .accesskey = l
# The following string is displayed on a menuitem that will close the tabs from the end of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Right" and in right-to-left languages this should use "Left".
close-tabs-to-the-end =
    .label = 오른쪽 탭 닫기
    .accesskey = i
close-other-tabs =
    .label = 다른 탭 닫기
    .accesskey = o
reload-tabs =
    .label = 탭 새로 고침
    .accesskey = R
pin-tab =
    .label = 탭 고정
    .accesskey = P
unpin-tab =
    .label = 탭 고정 해제
    .accesskey = p
pin-selected-tabs =
    .label = 탭 고정
    .accesskey = P
unpin-selected-tabs =
    .label = 탭 고정 해제
    .accesskey = p
bookmark-selected-tabs =
    .label = 탭 북마크…
    .accesskey = k
bookmark-tab =
    .label = 탭 북마크
    .accesskey = B
reopen-in-container =
    .label = 컨테이너에 다시 열기
    .accesskey = e
tab-context-open-in-new-container-tab =
    .label = 새 컨테이너에 열기
    .accesskey = e
move-to-start =
    .label = 처음으로 이동
    .accesskey = S
move-to-end =
    .label = 끝으로 이동
    .accesskey = E
move-to-new-window =
    .label = 새 창으로 이동
    .accesskey = W
tab-context-close-multiple-tabs =
    .label = 여러 탭 닫기
    .accesskey = M
tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] 닫은 탭 다시 열기
           *[other] 닫은 탭 다시 열기
        }
    .accesskey = U
close-tab =
    .label = 탭 닫기
    .accesskey = c
close-tabs =
    .label = 탭 닫기
    .accesskey = S
move-tabs =
    .label = 탭 이동
    .accesskey = v
move-tab =
    .label = 탭 이동
    .accesskey = v
tab-context-share-url =
    .label = 공유
    .accesskey = h
tab-context-share-more =
    .label = 더보기…

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-reopen-closed-tabs =
    .label =
        { $tabCount ->
            [1] 닫은 탭 다시 열기
           *[other] 닫은 탭 다시 열기
        }
    .accesskey = o
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] 탭 닫기
           *[other] 탭 닫기
        }
    .accesskey = C
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] 탭 이동
           *[other] 탭 이동
        }
    .accesskey = v
