# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = 열기
    .accesskey = O
places-open-in-tab =
    .label = 새 탭에 열기
    .accesskey = w
places-open-all-bookmarks =
    .label = 모든 북마크 열기
    .accesskey = O
places-open-all-in-tabs =
    .label = 모두 탭에 열기
    .accesskey = O
places-open-in-window =
    .label = 새 창에 열기
    .accesskey = N
places-open-in-private-window =
    .label = 새 사생활 보호 창에 열기
    .accesskey = P
places-add-bookmark =
    .label = 북마크 추가…
    .accesskey = B
places-add-folder-contextmenu =
    .label = 폴더 추가…
    .accesskey = F
places-add-folder =
    .label = 폴더 추가…
    .accesskey = o
places-add-separator =
    .label = 구분자 추가
    .accesskey = S
places-view =
    .label = 보기
    .accesskey = w
places-by-date =
    .label = 날짜순
    .accesskey = D
places-by-site =
    .label = 사이트순
    .accesskey = S
places-by-most-visited =
    .label = 자주 방문순
    .accesskey = V
places-by-last-visited =
    .label = 마지막 방문순
    .accesskey = L
places-by-day-and-site =
    .label = 날짜 및 사이트순
    .accesskey = t
places-history-search =
    .placeholder = 기록 검색
places-history =
    .aria-label = 기록
places-bookmarks-search =
    .placeholder = 북마크 검색
places-delete-domain-data =
    .label = 이 사이트 기억 안 함
    .accesskey = F
places-sortby-name =
    .label = 이름순 정렬
    .accesskey = r
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = 북마크 편집…
    .accesskey = i
places-edit-generic =
    .label = 편집…
    .accesskey = i
places-edit-folder =
    .label = 폴더 이름 변경…
    .accesskey = e
places-remove-folder =
    .label =
        { $count ->
            [1] 폴더 삭제
           *[other] 폴더 삭제
        }
    .accesskey = m
places-edit-folder2 =
    .label = 폴더 편집…
    .accesskey = i
places-delete-folder =
    .label =
        { $count ->
            [1] 폴더 삭제
           *[other] 폴더 삭제
        }
    .accesskey = D
# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = 관리되는 북마크
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = 하위 폴더
# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = 기타 북마크
# Variables:
# $count (number) - The number of elements being selected for removal.
places-remove-bookmark =
    .label =
        { $count ->
            [1] 북마크 삭제
           *[other] 북마크 삭제
        }
    .accesskey = e
places-show-in-folder =
    .label = 폴더에서 보기
    .accesskey = F
# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] 북마크 삭제
           *[other] 북마크 삭제
        }
    .accesskey = D
places-manage-bookmarks =
    .label = 북마크 관리
    .accesskey = M
places-forget-about-this-site-confirmation-title = 이 사이트 기억 안 함
# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-message = 이 작업은 기록, 비밀번호, 쿠키, 캐시 및 콘텐츠 기본 설정을 포함하여 { $hostOrBaseDomain } 사이트와 관련된 모든 데이터를 삭제합니다. 계속하시겠습니까?
places-forget-about-this-site-forget = 기억 안 함
places-library =
    .title = 라이브러리
    .style = width:700px; height:500px;
places-organize-button =
    .label = 관리
    .tooltiptext = 북마크 관리
    .accesskey = O
places-organize-button-mac =
    .label = 관리
    .tooltiptext = 북마크 관리
places-file-close =
    .label = 닫기
    .accesskey = C
places-cmd-close =
    .key = w
places-view-button =
    .label = 보기
    .tooltiptext = 보기 형식 변경
    .accesskey = V
places-view-button-mac =
    .label = 보기
    .tooltiptext = 보기 형식 변경
places-view-menu-columns =
    .label = 열 표시
    .accesskey = C
places-view-menu-sort =
    .label = 정렬
    .accesskey = S
places-view-sort-unsorted =
    .label = 정렬 안 함
    .accesskey = U
places-view-sort-ascending =
    .label = 내림차순 (A > Z)
    .accesskey = A
places-view-sort-descending =
    .label = 오름차순 (Z > A)
    .accesskey = Z
places-maintenance-button =
    .label = 가져오기 및 백업
    .tooltiptext = 북마크 가져오기 및 백업
    .accesskey = I
places-maintenance-button-mac =
    .label = 가져오기 및 백업
    .tooltiptext = 북마크 가져오기 및 백업
places-cmd-backup =
    .label = 백업하기…
    .accesskey = B
places-cmd-restore =
    .label = 복원하기
    .accesskey = R
places-cmd-restore-from-file =
    .label = 파일 선택…
    .accesskey = C
places-import-bookmarks-from-html =
    .label = HTML에서 북마크 가져오기…
    .accesskey = I
places-export-bookmarks-to-html =
    .label = 북마크를 HTML로 내보내기…
    .accesskey = E
places-import-other-browser =
    .label = 다른 브라우저에서 가져오기…
    .accesskey = A
places-view-sort-col-name =
    .label = 이름
places-view-sort-col-tags =
    .label = 태그
places-view-sort-col-url =
    .label = 주소
places-view-sort-col-most-recent-visit =
    .label = 최근 방문일
places-view-sort-col-visit-count =
    .label = 방문 횟수
places-view-sort-col-date-added =
    .label = 저장일
places-view-sort-col-last-modified =
    .label = 마지막 수정일
places-cmd-find-key =
    .key = f
places-back-button =
    .tooltiptext = 뒤로 가기
places-forward-button =
    .tooltiptext = 앞으로 가기
places-details-pane-select-an-item-description = 속성을 보고 편집할 항목을 선택하세요
