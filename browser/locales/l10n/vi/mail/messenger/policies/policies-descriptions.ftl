# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Đặt chính sách mà WebExtensions có thể truy cập thông qua chrome.storage.managed.
policy-AppAutoUpdate = Bật hoặc tắt cập nhật chương trình tự động.
policy-AppUpdateURL = Đặt URL cập nhật ứng dụng tùy chỉnh.
policy-Authentication = Định cấu hình xác thực tích hợp cho các trang web hỗ trợ nó.
policy-BlockAboutAddons = Chặn quyền truy cập vào trình quản lý tiện ích (about:addons).
policy-BlockAboutConfig = Chặn quyền truy cập vào trang about:config.
policy-BlockAboutProfiles = Chặn quyền truy cập vào trang about:profiles.
policy-BlockAboutSupport = Chặn quyền truy cập vào trang about:support.
policy-CaptivePortal = Kích hoạt hoặc vô hiệu hóa hỗ trợ cổng bị khóa.
policy-CertificatesDescription = Thêm chứng chỉ hoặc sử dụng chứng chỉ tích hợp.
policy-Cookies = Cho phép hoặc từ chối các trang web để đặt cookie.
policy-DisabledCiphers = Vô hiệu hóa thuật toán mã hóa.
policy-DefaultDownloadDirectory = Đặt thư mục tải xuống mặc định.
policy-DisableAppUpdate = Ngăn { -brand-short-name } cập nhật.
policy-DisableDefaultClientAgent = Ngăn không cho tác nhân khách mặc định thực hiện bất kỳ hành động nào. Chỉ áp dụng cho Windows; các nền tảng khác không có tác nhân.
policy-DisableDeveloperTools = Chặn quyền truy cập vào các công cụ dành cho nhà phát triển.
policy-DisableFeedbackCommands = Tắt các lệnh để gửi phản hồi từ bảng chọn trợ giúp (gửi phản hồi và báo cáo trang web lừa đảo).
policy-DisableForgetButton = Ngăn chặn truy cập vào nút Quên.
policy-DisableFormHistory = Không lưu lịch sử tìm kiếm và biểu mẫu.
policy-DisableMasterPasswordCreation = Nếu đúng, mật khẩu chính không thể được tạo ra.
policy-DisablePasswordReveal = Không cho phép mật khẩu được tiết lộ trong thông tin đăng nhập đã lưu.
policy-DisableProfileImport = Vô hiệu hóa lệnh menu để nhập dữ liệu từ một ứng dụng khác.
policy-DisableSafeMode = Tắt tính năng này để khởi động lại ở chế độ an toàn. Lưu ý: phím Shift để vào chế độ an toàn chỉ có thể tắt trên Windows bằng Group Policy.
policy-DisableSecurityBypass = Ngăn chặn người dùng bỏ qua các cảnh báo bảo mật nhất định.
policy-DisableSystemAddonUpdate = Ngăn { -brand-short-name } cài đặt và cập nhật các tiện ích hệ thống.
policy-DisableTelemetry = Tắt Telemetry.
policy-DisplayMenuBar = Hiển thị thanh menu theo mặc định.
policy-DNSOverHTTPS = Định cấu hình DNS qua HTTPS.
policy-DontCheckDefaultClient = Vô hiệu hóa kiểm tra cho máy khách mặc định khi khởi động.
policy-DownloadDirectory = Đặt và khóa thư mục tải xuống.
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Bật hoặc tắt chặn nội dung và tùy chọn khóa nó.
# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Bật hoặc tắt tiện ích mở rộng phương tiện được mã hóa và tùy chọn khóa nó.
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Cài đặt, gỡ cài đặt hoặc khóa tiện ích mở rộng. Tùy chọn cài đặt lấy URL hoặc đường dẫn làm tham số. Các tùy chọn gỡ cài đặt và khóa có ID tiện ích mở rộng.
policy-ExtensionSettings = Quản lý các cài đặt cài đặt khác nhau cho tiện ích mở rộng.
policy-ExtensionUpdate = Bật hoặc tắt cập nhật tiện ích mở rộng tự động.
policy-HardwareAcceleration = Nếu sai, tắt tăng tốc phần cứng.
policy-InstallAddonsPermission = Cho phép các trang web nhất định để cài đặt tiện ích.
policy-LegacyProfiles = Vô hiệu hóa tính năng thực thi một cấu hình riêng cho mỗi cài đặt.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Bật cài đặt hành vi cookie SameSite cũ mặc định.
policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Hoàn nguyên hành vi SameSite cũ cho cookie trên các trang web được chỉ định.

##

policy-LocalFileLinks = Cho phép các trang web cụ thể để liên kết đến các tập tin cục bộ.
policy-NetworkPrediction = Kích hoạt hoặc vô hiệu hóa dự đoán mạng (tìm nạp trước DNS).
policy-OfferToSaveLogins = Thực thi cài đặt để cho phép { -brand-short-name } cung cấp và ghi nhớ thông tin đăng nhập và mật khẩu đã lưu. Cả hai giá trị đúng và sai đều được chấp nhận.
policy-OfferToSaveLoginsDefault = Đặt giá trị mặc định để cho phép { -brand-short-name } đề nghị ghi nhớ thông tin đăng nhập và mật khẩu đã lưu. Cả giá trị đúng và sai đều được chấp nhận.
policy-OverrideFirstRunPage = Ghi đè trang chạy đầu tiên. Bỏ trống chính sách này nếu bạn muốn vô hiệu hóa trang chạy đầu tiên.
policy-OverridePostUpdatePage = Ghi đè lên trang cập nhật "Có gì mới". Bỏ trống chính sách này nếu bạn muốn tắt trang cập nhật sau.
policy-PasswordManagerEnabled = Cho phép lưu mật khẩu vào trình quản lý mật khẩu.
# PDF.js and PDF should not be translated
policy-PDFjs = Vô hiệu hóa hoặc định cấu hình PDF.js, trình xem PDF tích hợp trong { -brand-short-name }.
policy-Permissions2 = Cấu hình quyền truy cập cho máy ảnh, micrô, vị trí, thông báo và tự động phát.
policy-Preferences = Đặt và khóa giá trị cho một tập hợp con ưu tiên.
policy-PromptForDownloadLocation = Hỏi nơi lưu tập tin khi tải xuống.
policy-Proxy = Định cấu hình cài đặt proxy.
policy-RequestedLocales = Đặt danh sách các ngôn ngữ được yêu cầu cho ứng dụng theo thứ tự ưu tiên.
policy-SanitizeOnShutdown2 = Xóa dữ liệu điều hướng khi tắt máy.
policy-SearchEngines = Cấu hình cài đặt công cụ tìm kiếm. Chính sách này chỉ có sẵn trên phiên bản phát hành hỗ trợ mở rộng (ESR).
policy-SearchSuggestEnabled = Bật hoặc tắt đề xuất tìm kiếm.
# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Cài đặt các mô-đun PKCS #11.
policy-SSLVersionMax = Đặt phiên bản SSL tối đa.
policy-SSLVersionMin = Đặt phiên bản SSL tối thiểu.
policy-SupportMenu = Thêm một mục menu hỗ trợ tùy chỉnh vào menu trợ giúp.
policy-UserMessaging = Không hiển thị một số thông điệp nhất định cho người dùng.
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Chặn các trang web không được truy cập. Xem tài liệu để biết thêm chi tiết về định dạng.
