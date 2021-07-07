# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Đặt chính sách mà WebExtensions có thể truy cập thông qua chrome.storage.managed.
policy-AllowedDomainsForApps = Xác định các miền được phép truy cập Google Workspace.
policy-AppAutoUpdate = Bật hoặc tắt cập nhật chương trình tự động.
policy-AppUpdateURL = Thiết lập URL cập nhật của ứng dụng tùy chỉnh.
policy-Authentication = Cấu hình các phương thức xác thực tích hợp sẵn cho các trang web có hỗ trợ.
policy-AutoLaunchProtocolsFromOrigins = Xác định danh sách các giao thức bên ngoài có thể được sử dụng từ các origin được liệt kê mà không cần nhắc người dùng.
policy-BackgroundAppUpdate2 = Kích hoạt hoặc vô hiệu hóa trình cập nhật nền.
policy-BlockAboutAddons = Chặn quyền truy cập vào trình quản lý tiện ích (about: addons).
policy-BlockAboutConfig = Chặn truy cập vào trang about:config.
policy-BlockAboutProfiles = Chặn truy cập vào trang about:profiles.
policy-BlockAboutSupport = Chặn truy cập vào trang about:support.
policy-Bookmarks = Tạo dấu trang trong thanh công cụ dấu trang, menu dấu trang hoặc một thư mục xác định bên trong chúng.
policy-CaptivePortal = Kích hoạt hoặc vô hiệu hóa hỗ trợ kiểm soát truy cập.
policy-CertificatesDescription = Thêm chứng chỉ hoặc sử dụng chứng chỉ có sẵn.
policy-Cookies = Cho phép hoặc từ chối các trang web lưu cookie.
policy-DisabledCiphers = Vô hiệu hóa thuật toán mã hóa.
policy-DefaultDownloadDirectory = Đặt thư mục tải xuống mặc định.
policy-DisableAppUpdate = Chặn việc cập nhật trình duyệt.
policy-DisableBuiltinPDFViewer = Vô hiệu hóa PDF.js, trình xem PDF tích hợp trong { -brand-short-name }.
policy-DisableDefaultBrowserAgent = Ngăn chặn tác nhân người dùng trình duyệt mặc định làm bất cứ điều gì. Chỉ dành cho Windows, không có tác nhân người dùng nào khả dụng cho các nền tảng khác.
policy-DisableDeveloperTools = Chặn truy cập đến công cụ nhà phát triển.
policy-DisableFeedbackCommands = Tắt các lệnh để gửi phản hồi từ bảng chọn trợ giúp (gửi phản hồi và báo cáo trang web lừa đảo).
policy-DisableFirefoxAccounts = Vô hiệu hóa { -fxaccount-brand-name } dựa trên các dịch vụ, bao gồm cả đồng bộ.
# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Vô hiệu hóa tính năng Firefox Screenshots.
policy-DisableFirefoxStudies = Chặn { -brand-short-name } chạy các nghiên cứu.
policy-DisableForgetButton = Chặn truy cập vào nút Quên.
policy-DisableFormHistory = Không lưu lịch sử tìm kiếm và biểu mẫu.
policy-DisableMasterPasswordCreation = Nếu đúng, không thể tạo mật khẩu chính.
policy-DisablePrimaryPasswordCreation = Nếu đúng, không thể tạo mật khẩu chính.
policy-DisablePasswordReveal = Không cho phép mật khẩu được tiết lộ trong thông tin đăng nhập đã lưu.
policy-DisablePocket = Tắt tính năng lưu trang web vào Pocket.
policy-DisablePrivateBrowsing = Vô hiệu hóa duyệt web riêng tư.
policy-DisableProfileImport = Vô hiệu hóa lệnh nhập dữ liệu từ trình duyệt khác trên bảng chọn.
policy-DisableProfileRefresh = Vô hiệu hóa nút khôi phục { -brand-short-name } trong trang about:support.
policy-DisableSafeMode = Tắt tính năng này để khởi động lại ở chế độ an toàn. Lưu ý: phím Shift để vào chế độ an toàn chỉ có thể tắt trên Windows bằng Group Policy.
policy-DisableSecurityBypass = Ngăn người dùng bỏ qua một số cảnh báo bảo mật nhất định.
policy-DisableSetAsDesktopBackground = Vô hiệu hóa lệnh đặt làm hình nền desktop trong menu.
policy-DisableSystemAddonUpdate = Ngăn trình duyệt cài đặt và cập nhật tiện ích hệ thống.
policy-DisableTelemetry = Tắt Telemetry.
policy-DisplayBookmarksToolbar = Hiển thị thanh công cụ dấu trang theo mặc định.
policy-DisplayMenuBar = Hiển thị thanh bảng chọn theo mặc định.
policy-DNSOverHTTPS = Cấu hình DNS over HTTPS.
policy-DontCheckDefaultBrowser = Tắt kiểm tra trình duyệt mặc định khi khởi động.
policy-DownloadDirectory = Đặt và khóa thư mục tải xuống.
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Kích hoạt hoặc vô hiệu hóa chặn nội dung và tùy chọn khóa nó.
# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Bật hoặc tắt tiện ích mở rộng phương tiện được mã hóa và tùy chọn khóa nó.
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Cài đặt, gỡ cài đặt hoặc khóa tiện ích mở rộng. Tùy chọn Cài đặt lấy URL hoặc đường dẫn làm tham số. Các tùy chọn Gỡ cài đặt và Khóa lấy ID tiện ích mở rộng.
policy-ExtensionSettings = Quản lý các cài đặt cài đặt khác nhau cho tiện ích mở rộng.
policy-ExtensionUpdate = Bật hoặc tắt cập nhật tiện ích mở rộng tự động.
policy-FirefoxHome = Cấu hình trang chủ Firefox.
policy-FlashPlugin = Cho phép hoặc từ chối việc sử dụng phần bổ trợ Flash.
policy-Handlers = Cấu hình trình xử lý ứng dụng mặc định.
policy-HardwareAcceleration = Nếu không đúng, hãy tắt chế độ tăng tốc phần cứng.
# “lock” means that the user won’t be able to change this setting
policy-Homepage = Đặt và tùy chọn khóa trang chủ.
policy-InstallAddonsPermission = Cho phép một số trang web cài đặt tiện ích.
policy-LegacyProfiles = Vô hiệu hóa tính năng thực thi một cấu hình riêng cho mỗi cài đặt

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Bật cài đặt hành vi cookie SameSite cũ mặc định.
policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Hoàn nguyên hành vi SameSite cũ cho cookie trên các trang web được chỉ định.

##

policy-LocalFileLinks = Cho phép các trang web cụ thể để liên kết đến các tập tin cục bộ.
policy-ManagedBookmarks = Định cấu hình danh sách các dấu trang do quản trị viên quản lý mà người dùng không thể thay đổi.
policy-MasterPassword = Yêu cầu hoặc ngăn chặn sử dụng mật khẩu chính.
policy-ManualAppUpdateOnly = Chỉ cho phép cập nhật thủ công và không thông báo cho người dùng về các bản cập nhật.
policy-PrimaryPassword = Yêu cầu hoặc ngăn không sử dụng mật khẩu chính.
policy-NetworkPrediction = Kích hoạt hoặc vô hiệu hóa dự đoán mạng (tìm nạp trước DNS).
policy-NewTabPage = Kích hoạt hoặc vô hiệu hóa trang Thẻ mới.
policy-NoDefaultBookmarks = Vô hiệu hóa việc tạo dấu trang mặc định đi kèm với { -brand-short-name } và dấu trang thông minh (được truy cập nhiều nhất, thẻ gần đây). Lưu ý: chính sách này chỉ có hiệu lực nếu được sử dụng trước lần chạy đầu tiên của hồ sơ.
policy-OfferToSaveLogins = Thực thi cài đặt để cho phép { -brand-short-name } cung cấp và ghi nhớ thông tin đăng nhập và mật khẩu đã lưu. Cả hai giá trị đúng và sai đều được chấp nhận.
policy-OfferToSaveLoginsDefault = Đặt giá trị mặc định để cho phép { -brand-short-name } cung cấp ghi nhớ các thông tin đăng nhập và mật khẩu đã lưu. Cả giá trị đúng và sai đều được chấp nhận.
policy-OverrideFirstRunPage = Ghi đè trang chạy đầu tiên. Bỏ trống chính sách này nếu bạn muốn vô hiệu hóa trang chạy đầu tiên.
policy-OverridePostUpdatePage = Ghi đè lên trang cập nhật "Có gì mới". Bỏ trống chính sách này nếu bạn muốn tắt trang cập nhật sau.
policy-PasswordManagerEnabled = Cho phép lưu mật khẩu vào trình quản lý mật khẩu.
# PDF.js and PDF should not be translated
policy-PDFjs = Vô hiệu hóa hoặc cấu hình PDF.js, trình xem PDF tích hợp trong { -brand-short-name }.
policy-Permissions2 = Cấu hình quyền truy cập cho máy ảnh, micrô, vị trí, thông báo và tự động phát.
policy-PictureInPicture = Kích hoạt hoặc vô hiệu hóa hình trong hình.
policy-PopupBlocking = Cho phép các trang web nhất định hiển thị cửa sổ bật lên theo mặc định.
policy-Preferences = Đặt và khóa giá trị cho một tập hợp con ưu tiên.
policy-PromptForDownloadLocation = Hỏi nơi lưu tập tin khi tải xuống.
policy-Proxy = Cài đặt cấu hình proxy.
policy-RequestedLocales = Đặt danh sách các ngôn ngữ được yêu cầu cho ứng dụng theo thứ tự ưu tiên.
policy-SanitizeOnShutdown2 = Xóa dữ liệu điều hướng khi tắt máy.
policy-SearchBar = Đặt thanh tìm kiếm ở vị trí mặc định. Người dùng vẫn được phép tùy chỉnh nó.
policy-SearchEngines = Cấu hình cài đặt công cụ tìm kiếm. Chính sách này chỉ có sẵn trên phiên bản phát hành hỗ trợ mở rộng (ESR).
policy-SearchSuggestEnabled = Kích hoạt hoặc vô hiệu hóa các đề xuất tìm kiếm.
# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Cài đặt các mô-đun PKCS # 11.
policy-ShowHomeButton = Hiển thị nút trang chủ trên thanh công cụ.
policy-SSLVersionMax = Chỉnh phiên bản SSL tối đa.
policy-SSLVersionMin = Chỉnh phiên bản SSL tối thiểu.
policy-SupportMenu = Thêm một mục menu hỗ trợ tùy chỉnh vào menu trợ giúp.
policy-UserMessaging = Không hiển thị một số thông điệp nhất định cho người dùng.
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Chặn các trang web không được truy cập. Xem tài liệu để biết thêm chi tiết về định dạng.
policy-Windows10SSO = Cho phép Windows đăng nhập một lần cho tài khoản Microsoft, cơ quan và trường học.
