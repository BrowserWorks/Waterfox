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
