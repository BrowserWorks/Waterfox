# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Chào mừng đến với { -brand-short-name }
onboarding-start-browsing-button-label = Bắt đầu duyệt web
onboarding-not-now-button-label = Không phải bây giờ
mr1-onboarding-get-started-primary-button-label = Bắt đầu

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Thật tuyệt, bạn đã có { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Bây giờ, bạn có thể cài đặt <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Thêm tiện ích mở rộng
return-to-amo-add-theme-label = Thêm chủ đề

##  Variables: $addon-name (String) - Name of the add-on to be installed

mr1-return-to-amo-subtitle = Gặp gỡ với { -brand-short-name }
mr1-return-to-amo-addon-title = Bạn đã có một trình duyệt nhanh, riêng tư trong tầm tay. Giờ đây, bạn có thể thêm <b>{ $addon-name }</b> và thậm chí còn làm được nhiều hơn thế với { -brand-short-name }
mr1-return-to-amo-add-extension-label = Thêm { $addon-name }

## Multistage onboarding strings (about:welcome pages)


# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator-label =
    .aria-label = Tiến trình: bước { $current }/{ $total }
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Tắt hoạt ảnh
# String for the Waterfox Accounts button
mr1-onboarding-sign-in-button-label = Đăng nhập
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Nhập từ { $previous }
mr1-onboarding-theme-header = Biến nó thành của riêng bạn
mr1-onboarding-theme-subtitle = Cá nhân hóa { -brand-short-name } với một chủ đề.
mr1-onboarding-theme-secondary-button-label = Không phải bây giờ
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Chủ đề hệ thống
mr1-onboarding-theme-label-light = Sáng
mr1-onboarding-theme-label-dark = Tối
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow
onboarding-theme-primary-button-label = Xong

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Áp dụng theo chủ đề hệ điều hành
        cho các nút, menu và cửa sổ.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Áp dụng theo chủ đề hệ điều hành
        cho các nút, menu và cửa sổ.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Áp dụng chủ đề sáng
        cho các nút, menu và cửa sổ.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Áp dụng chủ đề sáng
        cho các nút, menu và cửa sổ.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Áp dụng chủ đề tối
        cho các nút, menu và cửa sổ.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Áp dụng chủ đề tối
        cho các nút, menu và cửa sổ.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Sử dụng giao diện động, đầy màu sắc
        cho các nút, menu và cửa sổ
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Sử dụng giao diện động, đầy màu sắc
        cho các nút, menu và cửa sổ
# Selector description for default themes
mr2-onboarding-default-theme-label = Khám phá các chủ đề mặc định.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Cảm ơn bạn đã chọn chúng tôi
mr2-onboarding-thank-you-text = { -brand-short-name } là một trình duyệt độc lập được hỗ trợ bởi một tổ chức phi lợi nhuận. Cùng nhau, chúng ta đang làm cho web an toàn hơn, lành mạnh hơn và riêng tư hơn.
mr2-onboarding-start-browsing-button-label = Bắt đầu duyệt web

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"
##   $systemLanguage (String) - The name of the system language, e.g "Español (ES)"
##   $appLanguage (String) - The name of the language shipping in the browser build, e.g. "English (EN)"

onboarding-live-language-header = Chọn ngôn ngữ của bạn
mr2022-onboarding-live-language-text = { -brand-short-name } hỗ trợ ngôn ngữ của bạn
mr2022-language-mismatch-subtitle = Cảm ơn cộng đồng của chúng tôi, { -brand-short-name } được dịch sang hơn 90 ngôn ngữ. Có vẻ như hệ thống của bạn đang sử dụng { $systemLanguage } và { -brand-short-name } đang sử dụng { $appLanguage }.
onboarding-live-language-button-label-downloading = Đang tải xuống gói ngôn ngữ cho { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Nhận các ngôn ngữ khả dụng…
onboarding-live-language-installing = Đang cài đặt gói ngôn ngữ cho { $negotiatedLanguage }…
mr2022-onboarding-live-language-switch-to = Chuyển sang { $negotiatedLanguage }
mr2022-onboarding-live-language-continue-in = Tiếp tục với ngôn ngữ { $appLanguage }
onboarding-live-language-secondary-cancel-download = Hủy bỏ
onboarding-live-language-skip-button-label = Bỏ qua

## Waterfox 100 Thank You screens

# "Hero Text" displayed on left side of welcome screen. This text can be
# formatted to span multiple lines as needed. The <span data-l10n-name="zap">
# </span> in this string allows a "zap" underline style to be automatically
# added to the text inside it. "Yous" should stay inside the zap span, but
# "Thank" can be put inside instead if there's no "you" in the translation.
# The English text would normally be "100 Thank-Yous" i.e., plural noun, but for
# aesthetics of splitting it across multiple lines, the hyphen is omitted.
fx100-thank-you-hero-text =
    100
    Cảm ơn <span data-l10n-name="zap">bạn</span>
fx100-thank-you-subtitle = Đây là bản phát hành thứ 100 của chúng tôi! Cảm ơn bạn đã giúp chúng tôi xây dựng một Internet tốt hơn, lành mạnh hơn.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Giữ { -brand-short-name } trên thanh dock
       *[other] Ghim { -brand-short-name } vào thanh tác vụ
    }
fx100-upgrade-thanks-header = 100 lần cảm ơn bạn
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Đây là bản phát hành thứ 100 của chúng tôi về { -brand-short-name }. Cảm ơn <em>bạn</em> đã giúp chúng tôi xây dựng một Internet tốt hơn, lành mạnh hơn.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = Đây là bản phát hành thứ 100 của chúng tôi! Cảm ơn vì đã trở thành một phần của cộng đồng của chúng tôi. Giữ { -brand-short-name } một cú nhấp chuột cho lần tiếp theo thứ 100.
mr2022-onboarding-secondary-skip-button-label = Bỏ qua bước này

## MR2022 New User Easy Setup screen strings

# Primary button string used on new user onboarding first screen showing multiple actions such as Set Default, Import from previous browser.
mr2022-onboarding-easy-setup-primary-button-label = Lưu và tiếp tục
# Set Default action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-set-default-checkbox-label = Đặt { -brand-short-name } làm trình duyệt mặc định
# Import action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-import-checkbox-label = Nhập từ trình duyệt trước

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Mở ra một mạng internet tuyệt vời
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = Khởi chạy { -brand-short-name } từ bất kỳ đâu chỉ với một cú nhấp chuột. Mỗi lần như vậy, bạn đang chọn một trang web độc lập và cởi mở hơn.
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Giữ { -brand-short-name } trên thanh dock
       *[other] Ghim { -brand-short-name } vào thanh tác vụ
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = Bắt đầu với một trình duyệt được hỗ trợ bởi một tổ chức phi lợi nhuận. Chúng tôi bảo vệ quyền riêng tư của bạn trong khi bạn duyệt web.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = Cảm ơn bạn đã yêu thích { -brand-product-name }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = Khởi động một mạng internet lành mạnh hơn từ mọi nơi chỉ với một cú nhấp chuột. Bản cập nhật mới nhất của chúng tôi chứa đựng những điều mới mà chúng tôi nghĩ rằng bạn sẽ yêu thích.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = Sử dụng trình duyệt bảo vệ quyền riêng tư của bạn khi bạn lướt web. Bản cập nhật mới nhất của chúng tôi chứa đầy những thứ mà bạn yêu thích.
mr2022-onboarding-existing-pin-checkbox-label = Đồng thời thêm { -brand-short-name } duyệt web riêng tư

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = Đặt { -brand-short-name } làm trình duyệt truy cập của bạn
mr2022-onboarding-set-default-primary-button-label = Đặt { -brand-short-name } làm trình duyệt mặc định
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = Sử dụng trình duyệt được hỗ trợ bởi tổ chức phi lợi nhuận. Chúng tôi bảo vệ quyền riêng tư của bạn trong khi bạn duyệt web.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = Phiên bản mới nhất của chúng tôi được xây dựng xung quanh bạn, giúp bạn truy cập trên web dễ dàng hơn bao giờ hết. Nó được đóng gói với các tính năng mà chúng tôi nghĩ rằng bạn sẽ yêu thích.
mr2022-onboarding-get-started-primary-button-label = Thiết lập trong vài giây

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Thiết lập nhanh như chớp
mr2022-onboarding-import-subtitle = Thiết lập { -brand-short-name } theo cách bạn thích. Thêm dấu trang, mật khẩu và hơn thế nữa từ trình duyệt cũ của bạn.
mr2022-onboarding-import-primary-button-label-no-attribution = Nhập từ trình duyệt trước

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Chọn màu sắc truyền cảm hứng cho bạn
mr2022-onboarding-colorway-subtitle = Tiếng nói độc lập có thể thay đổi văn hóa.
mr2022-onboarding-colorway-primary-button-label-continue = Đặt và tiếp tục
mr2022-onboarding-existing-colorway-checkbox-label = Đặt { -firefox-home-brand-name } làm trang chủ đầy màu sắc của bạn
mr2022-onboarding-colorway-label-default = Mặc định
mr2022-onboarding-colorway-tooltip-default2 =
    .title = Màu hiện tại của { -brand-short-name }
mr2022-onboarding-colorway-description-default = <b>Sử dụng màu { -brand-short-name } hiện tại của tôi.</b>
mr2022-onboarding-colorway-label-playmaker = Người kiến tạo lối chơi
mr2022-onboarding-colorway-tooltip-playmaker2 =
    .title = Người kiến tạo lối chơi (đỏ)
mr2022-onboarding-colorway-description-playmaker = <b>Bạn là người kiến tạo lối chơi.</b> Bạn tạo cơ hội để giành chiến thắng và giúp mọi người xung quanh nâng tầm trò chơi của họ.
mr2022-onboarding-colorway-label-expressionist = Trường phái biểu hiện
mr2022-onboarding-colorway-tooltip-expressionist2 =
    .title = Trường phái biểu hiện (vàng)
mr2022-onboarding-colorway-description-expressionist = <b>Bạn là người theo chủ nghĩa biểu hiện.</b> Bạn nhìn thế giới một cách khác biệt và những sáng tạo của bạn khuấy động cảm xúc của người khác.
mr2022-onboarding-colorway-label-visionary = Nhìn xa trông rộng
mr2022-onboarding-colorway-tooltip-visionary2 =
    .title = Nhìn xa trông rộng (xanh lá)
mr2022-onboarding-colorway-description-visionary = <b>Bạn là một người có tầm nhìn xa.</b> Bạn đặt câu hỏi về hiện trạng và khiến người khác phải tưởng tượng về một tương lai tốt đẹp hơn.
mr2022-onboarding-colorway-label-activist = Nhà hoạt động
mr2022-onboarding-colorway-tooltip-activist2 =
    .title = Nhà hoạt động (xanh nước biển)
mr2022-onboarding-colorway-description-activist = <b>Bạn là một nhà hoạt động.</b> Bạn để lại cho thế giới một nơi tốt đẹp hơn những gì bạn đã tìm thấy và khiến người khác tin tưởng.
mr2022-onboarding-colorway-label-dreamer = Người mơ mộng
mr2022-onboarding-colorway-tooltip-dreamer2 =
    .title = Người mơ mộng (tím)
mr2022-onboarding-colorway-description-dreamer = <b>Bạn là một người mơ mộng.</b> Bạn tin rằng vận may ủng hộ những người mạnh dạn và truyền cảm hứng cho những người khác dũng cảm.
mr2022-onboarding-colorway-label-innovator = Người đổi mới
mr2022-onboarding-colorway-tooltip-innovator2 =
    .title = Người đổi mới (cam)
mr2022-onboarding-colorway-description-innovator = <b>Bạn là một người đổi mới.</b> Bạn nhìn thấy cơ hội ở khắp mọi nơi và tạo ra ảnh hưởng đến cuộc sống của mọi người xung quanh bạn.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Chuyển từ máy tính xách tay sang điện thoại và quay lại một lần nữa
mr2022-onboarding-mobile-download-subtitle = Lấy các thẻ từ một thiết bị và tiếp tục nơi bạn đã dừng lại trên một thiết bị khác. Ngoài ra, hãy đồng bộ hóa dấu trang và mật khẩu của bạn ở bất kỳ đâu bạn sử dụng { -brand-product-name }.
mr2022-onboarding-mobile-download-cta-text = Quét mã QR để lấy liên kết tải xuống { -brand-product-name } dành cho di động hoặc <a data-l10n-name="download-label">gửi liên kết cho chính bạn.</a>
mr2022-onboarding-no-mobile-download-cta-text = Quét mã QR để tải xuống { -brand-product-name } dành cho di động.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = Tự do duyệt web riêng tư trong một cú nhấp chuột
mr2022-upgrade-onboarding-pin-private-window-subtitle = Không có cookie hoặc lịch sử đã lưu, ngay từ màn hình của bạn. Duyệt như không có ai đang xem.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] Giữ { -brand-short-name } duyệt web ở chế độ riêng tư trong thanh Dock
       *[other] Ghim { -brand-short-name } duyệt web ở chế độ riêng tư vào thanh tác vụ
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Chúng tôi luôn tôn trọng quyền riêng tư của bạn
mr2022-onboarding-privacy-segmentation-subtitle = Từ các đề xuất thông minh đến tìm kiếm thông minh hơn, chúng tôi không ngừng nỗ lực để tạo ra { -brand-product-name } tốt hơn, cá nhân hóa hơn.
mr2022-onboarding-privacy-segmentation-text-cta = Bạn muốn thấy gì khi chúng tôi cung cấp các tính năng mới sử dụng dữ liệu của bạn để nâng cao khả năng duyệt web của bạn?
mr2022-onboarding-privacy-segmentation-button-primary-label = Sử dụng các đề xuất của { -brand-product-name }
mr2022-onboarding-privacy-segmentation-button-secondary-label = Hiển thị thông tin chi tiết

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = Bạn đang giúp chúng tôi xây dựng một trang web tốt hơn
mr2022-onboarding-gratitude-subtitle = Cảm ơn bạn đã sử dụng { -brand-short-name }, được hỗ trợ bởi BrowserWorks. Với sự hỗ trợ của bạn, chúng tôi đang nỗ lực để làm cho Internet trở nên cởi mở hơn, dễ tiếp cận hơn và tốt hơn cho mọi người.
mr2022-onboarding-gratitude-primary-button-label = Xem có gì mới
mr2022-onboarding-gratitude-secondary-button-label = Bắt đầu duyệt web

## Onboarding spotlight for infrequent users

onboarding-infrequent-import-title = Tự nhiên như ở nhà
onboarding-infrequent-import-subtitle = Cho dù bạn đang giải quyết hay chỉ ghé qua, hãy nhớ rằng bạn có thể nhập dấu trang, mật khẩu của mình và hơn thế nữa.
onboarding-infrequent-import-primary-button = Nhập vào { -brand-short-name }

## MR2022 Illustration alt tags
## Descriptive tags for illustrations used by screen readers and other assistive tech

mr2022-onboarding-pin-image-alt =
    .aria-label = Người đang làm việc trên máy tính xách tay được bao quanh bởi các ngôi sao và hoa
mr2022-onboarding-default-image-alt =
    .aria-label = Người ôm logo { -brand-product-name }
mr2022-onboarding-import-image-alt =
    .aria-label = Người cưỡi ván trượt với một hộp biểu tượng phần mềm
mr2022-onboarding-mobile-download-image-alt =
    .aria-label = Ếch nhảy qua tấm lót lily với mã QR để tải xuống { -brand-product-name } cho thiết bị di động ở giữa
mr2022-onboarding-pin-private-image-alt =
    .aria-label = Cây đũa thần làm cho biểu trưng duyệt web riêng tư của { -brand-product-name } xuất hiện trên một chiếc mũ
mr2022-onboarding-privacy-segmentation-image-alt =
    .aria-label = Tay da sáng và da ngăm đen cao năm
mr2022-onboarding-gratitude-image-alt =
    .aria-label = Cảnh hoàng hôn qua cửa sổ với một con cáo và cây nhà trên bệ cửa sổ
mr2022-onboarding-colorways-image-alt =
    .aria-label = Bình xịt tay vẽ một bức tranh cắt dán đầy màu sắc của mắt xanh lá cây, giày màu cam, quả bóng rổ màu đỏ, tai nghe màu tím, trái tim màu xanh lam và vương miện màu vàng

## Device migration onboarding

onboarding-device-migration-image-alt =
    .aria-label = Một con cáo trên màn hình máy tính xách tay đang vẫy tay. Máy tính xách tay có một thiết bị chuột cắm vào nó.
onboarding-device-migration-title = Chào mừng trở lại!
onboarding-device-migration-subtitle = Đăng nhập vào { -fxaccount-brand-name(capitalization: "sentence") } của bạn để mang theo dấu trang, mật khẩu và lịch sử của bạn trên thiết bị mới.
onboarding-device-migration-subtitle2 = Đăng nhập vào tài khoản của bạn để mang theo dấu trang, mật khẩu và lịch sử trên thiết bị mới của bạn.
onboarding-device-migration-primary-button-label = Đăng nhập
