# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Tìm cụm từ ở phần sau
findbar-previous =
    .tooltiptext = Tìm cụm từ ở phần trước

findbar-find-button-close =
    .tooltiptext = Đóng thanh tìm kiếm

findbar-highlight-all2 =
    .label = Tô sáng tất cả
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] a
        }
    .tooltiptext = Tô sáng tất cả các cụm từ được tìm thấy

findbar-case-sensitive =
    .label = Phân biệt HOA-thường
    .accesskey = C
    .tooltiptext = Tìm kiếm có phân biệt chữ hoa và chữ thường

findbar-match-diacritics =
    .label = Dấu phụ phù hợp
    .accesskey = i
    .tooltiptext = Phân biệt giữa các chữ cái có dấu và các chữ cái cơ sở của chúng (ví dụ: khi tìm kiếm về “resume”, “résumé” sẽ không khớp)

findbar-entire-word =
    .label = Toàn bộ từ
    .accesskey = W
    .tooltiptext = Chỉ tìm toàn bộ từ

findbar-not-found = Không tìm thấy

findbar-wrapped-to-top = Đã xuống tới cuối trang, bắt đầu lại từ đầu trang
findbar-wrapped-to-bottom = Đã lên tới đầu trang, bắt đầu lại từ cuối trang

findbar-normal-find =
    .placeholder = Tìm trong trang này
findbar-fast-find =
    .placeholder = Tìm nhanh
findbar-fast-find-links =
    .placeholder = Tìm nhanh (chỉ tìm liên kết)

findbar-case-sensitive-status =
    .value = (Phân biệt HOA-thường)
findbar-match-diacritics-status =
    .value = (Dấu phụ phù hợp)
findbar-entire-word-status =
    .value = (Chỉ toàn bộ từ)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value = { $current } trên { $total } kết quả

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value = Tìm thấy hơn { $limit } kết quả
