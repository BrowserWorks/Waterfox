# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Hủy tất cả các phiên tải xuống?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Nếu bạn thoát ngay lúc này, 1 phiên tải xuống sẽ bị hủy. Bạn có chắc muốn thoát ngay không?
       *[other] Nếu bạn thoát ngay lúc này, { $downloadsCount } phiên tải xuống sẽ bị hủy. Bạn có chắc muốn thoát ngay không?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Nếu bạn thoát ngay lúc này, 1 phiên tải xuống sẽ bị hủy. Bạn có chắc muốn thoát ngay không?
       *[other] Nếu bạn thoát ngay lúc này, { $downloadsCount } phiên tải xuống sẽ bị hủy. Bạn có chắc muốn thoát ngay không?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] Đừng Thoát
       *[other] Đừng Thoát
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Nếu bạn ngắt kết nối ngay lúc này, 1 phiên tải xuống sẽ bị hủy. Bạn có chắc muốn ngắt kết nối không?
       *[other] Nếu bạn ngắt kết nối ngay lúc này, { $downloadsCount } phiên tải xuống sẽ bị hủy. Bạn có chắc muốn ngắt kết nối không?
    }
download-ui-dont-go-offline-button = Vẫn Kết Nối

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Nếu bây giờ bạn đóng tất cả các cửa sổ riêng tư thì một tập tin đang tải xuống sẽ bị hủy. Bạn có chắc chắn muốn rời chế độ duyệt web riêng tư không?
       *[other] Nếu bây giờ bạn đóng tất cả các cửa sổ riêng tư thì { $downloadsCount } tập tin đang tải xuống sẽ bị hủy. Bạn có chắc bạn muốn rời chế độ duyệt web riêng tư không?
    }
download-ui-dont-leave-private-browsing-button = Vẫn ở lại chế độ duyệt web riêng tư

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] Hủy 1 phiên tải xuống
       *[other] Hủy { $downloadsCount } phiên tải xuống
    }

##

download-ui-file-executable-security-warning-title = Mở Tập Tin Thực Thi?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = "{ $executable }" là một tập tin thực thi. Các tập tin thực thi có khả năng chứa virus hoặc mã độc và có thể làm tổn hại máy tính của bạn. Hãy thận trọng khi mở tập tin này. Bạn có chắc là mình muốn chạy "{ $executable }" không?
