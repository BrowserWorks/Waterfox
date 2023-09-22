# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The button for "Waterfox Translations" in the url bar.
urlbar-translations-button =
    .tooltiptext = Dịch trang này
# The button for "Waterfox Translations" in the url bar. Note that here "Beta" should
# not be translated, as it is a reflection of the un-localized BETA icon that is in the
# panel.
urlbar-translations-button2 =
    .tooltiptext = Dịch trang này - Beta
# Note that here "Beta" should not be translated, as it is a reflection of the
# un-localized BETA icon that is in the panel.
urlbar-translations-button-intro =
    .tooltiptext = Thử bản dịch riêng tư trong { -brand-shorter-name } - Beta
# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `Page translated from: { $fromLanguage }. Current target language: { $toLanguage }`
#
# Variables:
#   $fromLanguage (string) - The original language of the document.
#   $toLanguage (string) - The target language of the translation.
urlbar-translations-button-translated =
    .tooltiptext = Đã dịch trang từ { $fromLanguage } sang { $toLanguage }
urlbar-translations-button-loading =
    .tooltiptext = Đang dịch trang
translations-panel-settings-button =
    .aria-label = Quản lý cài đặt dịch
# Text displayed on a language dropdown when the language is in beta
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-displayname-beta =
    .label = { $language } BETA

## Options in the Waterfox Translations settings.

translations-panel-settings-manage-languages =
    .label = Quản lý ngôn ngữ
translations-panel-settings-about = Về bản dịch trong { -brand-shorter-name }
translations-panel-settings-about2 =
    .label = Về bản dịch trong { -brand-shorter-name }
# Text displayed for the option to always translate a given language
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-settings-always-translate-language =
    .label = Luôn dịch { $language }
translations-panel-settings-always-translate-unknown-language =
    .label = Luôn dịch ngôn ngữ này
translations-panel-settings-always-offer-translation =
    .label = Luôn đề nghị để dịch
# Text displayed for the option to never translate a given language
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-settings-never-translate-language =
    .label = Không bao giờ dịch { $language }
translations-panel-settings-never-translate-unknown-language =
    .label = Không bao giờ dịch ngôn ngữ này
# Text displayed for the option to never translate this website
translations-panel-settings-never-translate-site =
    .label = Không bao giờ dịch trang này

## The translation panel appears from the url bar, and this view is the default
## translation view.

translations-panel-header = Dịch trang này?
translations-panel-translate-button =
    .label = Dịch
translations-panel-translate-button-loading =
    .label = Vui lòng chờ…
translations-panel-translate-cancel =
    .label = Hủy bỏ
translations-panel-learn-more-link = Tìm hiểu thêm
translations-panel-intro-header = Thử bản dịch riêng tư trong { -brand-shorter-name }
translations-panel-intro-description = Vì riêng tư của bạn, bản dịch sẽ không bao giờ rời khỏi thiết bị của bạn. Sắp có các ngôn ngữ và cải tiến mới!
translations-panel-error-translating = Có sự cố khi dịch. Hãy thử lại.
translations-panel-error-load-languages = Không thể tải ngôn ngữ
translations-panel-error-load-languages-hint = Kiểm tra kết nối Internet của bạn và thử lại.
translations-panel-error-load-languages-hint-button =
    .label = Thử lại
translations-panel-error-unsupported = Bản dịch không có sẵn cho trang này
translations-panel-error-dismiss-button =
    .label = Đã hiểu
translations-panel-error-change-button =
    .label = Thay đổi ngôn ngữ nguồn
# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `Sorry, we don't support the language yet: { $language }
#
# Variables:
#   $language (string) - The language of the document.
translations-panel-error-unsupported-hint-known = Xin lỗi, chúng tôi chưa hỗ trợ { $language }.
translations-panel-error-unsupported-hint-unknown = Xin lỗi, chúng tôi chưa hỗ trợ ngôn ngữ này.

## Each label is followed, on a new line, by a dropdown list of language names.
## If this structure is problematic for your locale, an alternative way is to
## translate them as `Source language:` and `Target language:`

translations-panel-from-label = Dịch từ
translations-panel-to-label = Dịch sang

## The translation panel appears from the url bar, and this view is the "restore" view
## that lets a user restore a page to the original language, or translate into another
## language.

# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `The page is translated from: { $fromLanguage }. Current target language: { $toLanguage }`
#
# Variables:
#   $fromLanguage (string) - The original language of the document.
#   $toLanguage (string) - The target language of the translation.
translations-panel-revisit-header = Trang này đã được dịch từ { $fromLanguage } sang { $toLanguage }
translations-panel-choose-language =
    .label = Chọn ngôn ngữ
translations-panel-restore-button =
    .label = Hiển thị bản gốc

## Waterfox Translations language management in about:preferences.

translations-manage-header = Dịch
translations-manage-settings-button =
    .label = Cài đặt…
    .accesskey = t
translations-manage-description = Tải xuống ngôn ngữ để dịch ngoại tuyến.
translations-manage-all-language = Tất cả ngôn ngữ
translations-manage-download-button = Tải xuống
translations-manage-delete-button = Xóa
translations-manage-error-download = Đã xảy ra sự cố khi tải xuống tập tin ngôn ngữ. Hãy thử lại.
translations-manage-error-delete = Đã xảy ra sự cố khi xóa tập tin ngôn ngữ. Hãy thử lại.
translations-manage-intro = Đặt tùy chọn ngôn ngữ và bản dịch trang web của bạn, đồng thời quản lý các ngôn ngữ được cài đặt để dịch ngoại tuyến.
translations-manage-install-description = Cài đặt ngôn ngữ để dịch ngoại tuyến
translations-manage-language-install-button =
    .label = Cài đặt
translations-manage-language-install-all-button =
    .label = Cài đặt tất cả
    .accesskey = I
translations-manage-language-remove-button =
    .label = Xóa
translations-manage-language-remove-all-button =
    .label = Xóa tất cả
    .accesskey = e
translations-manage-error-install = Đã xảy ra sự cố khi cài đặt tập tin ngôn ngữ. Vui lòng thử lại.
translations-manage-error-remove = Đã xảy ra lỗi khi xóa tập tin ngôn ngữ. Vui lòng thử lại.
translations-manage-error-list = Không tải được danh sách các ngôn ngữ có sẵn để dịch. Làm mới trang để thử lại.
translations-settings-title =
    .title = Cài đặt dịch
    .style = min-width: 36em
translations-settings-close-key =
    .key = w
translations-settings-always-translate-langs-description = Bản dịch sẽ được tự động thực hiện cho các ngôn ngữ sau
translations-settings-never-translate-langs-description = Bản dịch sẽ không được cung cấp cho các ngôn ngữ sau
translations-settings-never-translate-sites-description = Bản dịch sẽ không được cung cấp cho các trang web sau
translations-settings-languages-column =
    .label = Ngôn ngữ
translations-settings-remove-language-button =
    .label = Xóa ngôn ngữ
    .accesskey = R
translations-settings-remove-all-languages-button =
    .label = Xóa tất cả ngôn ngữ
    .accesskey = e
translations-settings-sites-column =
    .label = Trang web
translations-settings-remove-site-button =
    .label = Xóa trang
    .accesskey = s
translations-settings-remove-all-sites-button =
    .label = Xóa tất cả trang
    .accesskey = m
translations-settings-close-dialog =
    .buttonlabelaccept = Đóng
    .buttonaccesskeyaccept = C
