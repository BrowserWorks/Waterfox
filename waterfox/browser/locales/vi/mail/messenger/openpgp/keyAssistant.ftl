# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-key-assistant-title = Trợ lý khóa OpenPGP
openpgp-key-assistant-rogue-warning = Tránh chấp nhận một khóa giả mạo. Để đảm bảo bạn đã lấy đúng khóa, bạn nên xác minh nó. <a data-l10n-name="openpgp-link">Tìm hiểu thêm…</a>

## Encryption status

openpgp-key-assistant-recipients-issue-header = Không thể mã hóa
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-issue-description =
    { $count ->
       *[other] Để mã hóa, bạn phải lấy và chấp nhận các khóa có thể sử dụng cho { $count } người nhận. <a data-l10n-name="openpgp-link">Tìm hiểu thêm…</a>
    }
openpgp-key-assistant-info-alias = { -brand-short-name } thường yêu cầu khóa công khai của người nhận phải chứa ID người dùng có địa chỉ email phù hợp. Điều này có thể được ghi đè bằng cách sử dụng quy tắc bí danh người nhận OpenPGP. <a data-l10n-name="openpgp-link">Tìm hiểu thêm…</a>
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-description =
    { $count ->
       *[other] Bạn đã có các khóa có thể sử dụng và được chấp nhận cho { $count } người nhận.
    }
openpgp-key-assistant-recipients-description-no-issues = Thư này có thể được mã hóa. Bạn có các khóa có thể sử dụng và được chấp nhận cho tất cả người nhận.

## Resolve section

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
# $numKeys (Number) - The number of keys.
openpgp-key-assistant-resolve-title =
    { $numKeys ->
       *[other] { -brand-short-name } đã tìm thấy các khóa sau cho { $recipient }.
    }
openpgp-key-assistant-valid-description = Chọn khóa mà bạn muốn chấp nhận
# Variables:
# $numKeys (Number) - The number of available keys.
openpgp-key-assistant-invalid-title =
    { $numKeys ->
       *[other] Không thể sử dụng các khóa sau, trừ khi bạn nhận được bản cập nhật.
    }
openpgp-key-assistant-no-key-available = Không có sẵn khóa.
openpgp-key-assistant-multiple-keys = Nhiều khóa có sẵn.
# Variables:
# $count (Number) - The number of unaccepted keys.
openpgp-key-assistant-key-unaccepted =
    { $count ->
       *[other] Nhiều khóa có sẵn, nhưng chưa có khóa nào được chấp nhận.
    }
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = Khóa được chấp nhận đã hết hạn vào { $date }.
openpgp-key-assistant-keys-accepted-expired = Nhiều khóa được chấp nhận đã hết hạn.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = Khóa này trước đây đã được chấp nhận nhưng đã hết hạn vào { $date }.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one = Khóa hết hạn vào { $date }.
openpgp-key-assistant-key-unaccepted-expired-many = Nhiều khóa đã hết hạn.
openpgp-key-assistant-key-fingerprint = Vân tay
openpgp-key-assistant-key-source =
    { $count ->
       *[other] Nguồn
    }
openpgp-key-assistant-key-collected-attachment = tập tin đính kèm email
# Autocrypt is the name of a standard.
openpgp-key-assistant-key-collected-autocrypt = Tiêu đề tự động mã hóa
# Web Key Directory (WKD) is a concept.
openpgp-key-assistant-key-collected-wkd = Thư mục khoá Web
openpgp-key-assistant-keys-has-collected =
    { $count ->
       *[other] Nhiều khóa đã được tìm thấy, nhưng chưa có khóa nào được chấp nhận.
    }
openpgp-key-assistant-key-rejected = Khóa này đã bị từ chối trước đó.
openpgp-key-assistant-key-accepted-other = Khóa này trước đây đã được chấp nhận cho một địa chỉ email khác.
# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info = Khám phá các khóa bổ sung hoặc cập nhật trực tuyến cho { $recipient } hoặc nhập chúng từ tập tin.

## Discovery section

openpgp-key-assistant-discover-title = Đang khám phá trực tuyến.
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = Đang khám phá các khóa cho { $recipient }…
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-expired-key-update =
    Đã tìm thấy bản cập nhật cho một trong các khóa được chấp nhận trước đó cho { $recipient }.
    Bây giờ nó có thể được sử dụng vì nó không còn hết hạn.

## Dialog buttons

openpgp-key-assistant-discover-online-button = Khám phá khóa công khai trực tuyến…
openpgp-key-assistant-import-keys-button = Nhập khóa công khai từ tập tin…
openpgp-key-assistant-issue-resolve-button = Giải quyết…
openpgp-key-assistant-view-key-button = Xem khóa…
openpgp-key-assistant-recipients-show-button = Hiển thị
openpgp-key-assistant-recipients-hide-button = Ẩn
openpgp-key-assistant-cancel-button = Hủy bỏ
openpgp-key-assistant-back-button = Quay lại
openpgp-key-assistant-accept-button = Chấp nhận
openpgp-key-assistant-close-button = Đóng
# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = được tạo vào { $date }
