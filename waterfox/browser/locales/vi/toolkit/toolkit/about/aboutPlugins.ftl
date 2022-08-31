# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Thông tin về các phần bổ trợ

installed-plugins-label = Các phần bổ trợ đã cài đặt
no-plugins-are-installed-label = Không tìm thấy phần bổ trợ nào được cài đặt

deprecation-description = Bạn đang thấy thiếu gì đó? Một số phần bổ trợ không còn được hỗ trợ. <a data-l10n-name="deprecation-link">Tìm hiểu thêm.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Tập tin:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Đường dẫn:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Phiên bản:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Tình trạng:</span> Đã bật
state-dd-enabled-block-list-state = <span data-l10n-name="state">Tình trạng:</span> Đã bật ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Tình trạng:</span> Đã vô hiệu hóa
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Tình trạng:</span> Đã vô hiệu hóa ({ $blockListState })

mime-type-label = Kiểu MIME
description-label = Mô tả
suffixes-label = Phần mở rộng

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = Thông tin giấy phép
plugins-gmp-privacy-info = Thông tin bảo mật

plugins-openh264-name = Bộ giải mã OpenH264 được cung cấp bởi Cisco Systems, Inc.
plugins-openh264-description = Phần bổ trợ này được Waterfox cài đặt tự động để tương thích với quy chuẩn WebRTC và để cho phép tạo cuộc gọi WebRTC với các thiết bị yêu cầu sử dụng mã hóa H.264. Xin hãy truy cập http://www.openh264.org/ để xem mã nguồn của bộ giải mã và tìm hiểu thêm.

plugins-widevine-name = Mô-đun giải mã nội dung Widevine được cung cấp bởi Google Inc.
plugins-widevine-description = Phần bổ trợ này cho phép phát lại phương tiện được mã hóa tuân thủ theo thông số kỹ thuật của phần mở rộng phương tiện được mã hóa. Phương tiện được mã hóa thường được sử dụng bởi các trang web để bảo vệ chống sao chép nội dung phương tiện cao cấp. Truy cập https://www.w3.org/TR/encrypted-media/ để biết thêm thông tin về tiện ích mở rộng phương tiện được mã hóa.
