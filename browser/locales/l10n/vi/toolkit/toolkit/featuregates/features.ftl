# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = Cho phép hỗ trợ cho tính năng thử nghiệm CSS Masonry Layout. Xem <a data-l10n-name="explainer">giải thích</a> để biết mô tả cấp cao về tính năng. Để cung cấp phản hồi, vui lòng nhận xét trong <a data-l10n-name="w3c-su">GitHub issue này</a> hoặc <a data-l10n-name="bug">báo cáo lỗi này</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = API mới này cung cấp hỗ trợ cấp thấp để thực hiện tính toán và kết xuất đồ họa bằng cách sử dụng <a data-l10n-name="wikipedia">bộ xử lí đồ họa(GPU)</a> của thiết bị hoặc máy tính của người dùng. <a data-l10n-name="spec">Thông số kĩ thuật</a> vẫn đang được tiến hành. Xem <a data-l10n-name="bugzilla">bug 1602129</a> để biết thêm chi tiết.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Phương tiện: AVIF
experimental-features-media-avif-description = Với tính năng này được bật, { -brand-short-name } hỗ trợ định dạng tập tin hình ảnh AV1 (AVIF). Đây là định dạng hình ảnh tĩnh, tận dụng các khả năng của thuật toán nén video AV1 để giảm kích thước hình ảnh. Xem <a data-l10n-name="bugzilla">bug 1443863</a> để biết thêm chi tiết.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Việc triển khai thuộc tính toàn cục <a data-l10n-name="mdn-inputmode">inputmode</a> của chúng tôi đã được cập nhật theo <a data-l10n-name="whatwg">thông số của WHATWG</a>, nhưng chúng tôi vẫn cần phải thực hiện các thay đổi khác, như làm cho nó có sẵn trên nội dung của contenteditable. Xem <a data-l10n-name="bugzilla">bug 1205133</a> để biết thêm chi tiết.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = Web API: <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = Thuộc tính <a data-l10n-name="rel">rel</a> có giá trị <code>"preload"</code> trên một phần tử <a data-l10n-name="link">&lt;link&gt;</a> nhằm giúp cung cấp hiệu suất tăng bằng cách cho phép bạn tải xuống các tài nguyên sớm hơn trong vòng đời của trang, đảm bảo rằng chúng có sẵn sớm hơn và ít có khả năng chặn kết xuất trang. Đọc <a data-l10n-name="readmore">“Tải trước nội dung với <code>rel="preload"</code>”</a> hoặc xem <a data-l10n-name="bugzilla">bug 1583604</a> để biết thêm chi tiết.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS: Pseudo-class: :focus-visible
experimental-features-css-focus-visible-description = Cho phép các kiểu mẫu đã được chọn được áp dụng cho các thành phần như nút và điều khiển biểu mẫu, chỉ khi chúng được chọn bằng bàn phím (ví dụ: khi tab giữa các thành phần), chứ không phải khi chúng được chọn bằng chuột hoặc thiết bị trỏ khác. Xem <a data-l10n-name="bugzilla">bug 1617600</a> để biết thêm chi tiết.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = Web API: beforeinput Event
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = Sự kiện toàn cục <a data-l10n-name="mdn-beforeinput">beforeinput</a> sẽ xảy ra trên một phần tử <a data-l10n-name="mdn-input">&lt;input&gt;</a> và<a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a>, hoặc bất kỳ yếu tố nào có thuật tính <a data-l10n-name="mdn-contenteditable">contenteditable</a> được bật, ngay lập tức trước khi phần tử giá trị thay đổi. Sự kiện này cho phép các ứng dụng web ghi đè hành vi mặc định của trình duyệt để tương tác với người dùng, ví dụ: ứng dụng web chỉ có thể hủy nhập dữ liệu người dùng cho các ký tự cụ thể hoặc chỉ có thể sửa đổi dán văn bản theo kiểu với các kiểu được phê duyệt.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Việc bổ sung một hàm tạo vào giao diện <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> cũng như một loạt các thay đổi liên quan giúp có thể trực tiếp tạo các bảng định kiểu mới mà không cần phải thêm trang tính vào HTML. Điều này giúp tạo các biểu định kiểu có thể tái sử dụng dễ dàng hơn nhiều để sử dụng với <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Xem <a data-l10n-name="bugzilla">bug 1520690</a> để biết thêm chi tiết.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = Web API: Media Session API
experimental-features-media-session-api-description = Toàn bộ triển khai { -brand-short-name } của Media Session API hiện đang thử nghiệm. API này được sử dụng để tùy chỉnh xử lý các thông báo liên quan đến phương tiện, để quản lý các sự kiện và dữ liệu hữu ích để hiển thị giao diện người dùng để quản lý phát lại phương tiện và để có được siêu dữ liệu tệp phương tiện. Xem <a data-l10n-name="bugzilla">bug 1112032</a> để biết thêm chi tiết.
experimental-features-devtools-color-scheme-simulation =
    .label = Developer Tools: Color Scheme Simulation
experimental-features-devtools-color-scheme-simulation-description = Thêm một tùy chọn để mô phỏng các lược đồ màu khác nhau cho phép bạn kiểm tra các truy vấn phương tiện <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-scheme</a>. Sử dụng truy vấn phương tiện này cho phép biểu định kiểu của bạn phản hồi xem người dùng thích giao diện người dùng sáng hay tối. Tính năng này cho phép bạn kiểm tra mã của mình mà không phải thay đổi cài đặt trong trình duyệt (hoặc hệ điều hành, nếu trình duyệt tuân theo cài đặt bảng màu toàn hệ thống). Xem <a data-l10n-name="bugzilla1">bug 1550804</a> và <a data-l10n-name="bugzilla2">bug 1137699</a> để biết thêm chi tiết.
experimental-features-devtools-execution-context-selector =
    .label = Developer Tools: Execution Context Selector
experimental-features-devtools-execution-context-selector-description = Tính năng này hiển thị một nút trên dòng lệnh Bảng điều khiển cho phép bạn thay đổi ngữ cảnh trong đó biểu thức bạn nhập sẽ được thực thi. Xem <a data-l10n-name="bugzilla1">bug 1605154</a> và <a data-l10n-name="bugzilla2">bug 1605153</a> để biết thêm chi tiết.
experimental-features-devtools-compatibility-panel =
    .label = Developer Tools: Compatibility Panel
experimental-features-devtools-compatibility-panel-description = Một bảng điều khiển bên lề cho Trình kiểm tra trang cho bạn thông tin chi tiết về trạng thái tương thích trình duyệt chéo của ứng dụng của bạn. Xem <a data-l10n-name="bugzilla">bug 1584464</a> để biết thêm chi tiết.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Cookie: SameSite=Lax theo mặc định
experimental-features-cookie-samesite-lax-by-default2-description = Xử lý cookie như “SameSite=Lax” theo mặc định nếu không có thuộc tính “SameSite” được chỉ định. Các nhà phát triển phải chọn tham gia vào hiện trạng sử dụng không hạn chế bằng cách xác nhận rõ ràng “SameSite=None”.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Cookie: SameSite=None yêu cầu thuộc tính bảo mật
experimental-features-cookie-samesite-none-requires-secure2-description = Cookie với thuộc tính “SameSite=None” yêu cầu thuộc tính bảo mật. Tính năng này yêu cầu “Cookie: SameSite=Lax theo mặc định”.
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = Bộ nhớ đệm tự chạy của about:home
experimental-features-abouthome-startup-cache-description = Một bộ nhớ đệm cho tài liệu about:home được tải theo mặc định khi khởi động. Mục đích của bộ nhớ đệm là cải thiện hiệu suất khởi động.
experimental-features-print-preview-tab-modal =
    .label = Thiết kế lại bản xem trước trang in
experimental-features-print-preview-tab-modal-description = Giới thiệu bản xem trước bản in được thiết kế lại và cung cấp bản xem trước bản in trên macOS. Điều này có khả năng gây ra vỡ và không bao gồm tất cả các cài đặt liên quan đến in. Để truy cập tất cả các cài đặt liên quan đến in, hãy chọn “In bằng hộp thoại hệ thống…” từ trong bảng In.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookies: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Xem cookie từ cùng một tên miền, nhưng với các chương trình khác nhau (ví dụ: http://example.com và https://example.com) là trang web chéo thay vì cùng một trang web. Cải thiện bảo mật, nhưng có thể khiến một số trang web hoạt động không đúng.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Developer Tools: Service Worker debugging
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Cho phép hỗ trợ thử nghiệm Service Workers trong thẻ Trình gỡ lỗi. Tính năng này có thể làm chậm Công cụ dành cho nhà phát triển và tăng mức tiêu thụ bộ nhớ.
# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = Đồ họa: Smooth Pinch Zoom
experimental-features-graphics-desktop-zooming-description = Cho phép hỗ trợ cho việc phóng to pinch mịn trên màn hình cảm ứng và cảm ứng chính xác.
