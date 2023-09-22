# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### "Glean" and "Glean SDK" should remain in English.

### "FOG", "Glean", and "Glean SDK" should remain in English.

-fog-brand-name = FOG
-glean-brand-name = Glean
glean-sdk-brand-name = { -glean-brand-name } SDK
glean-debug-ping-viewer-brand-name = Trình xem gỡ lỗi ping { -glean-brand-name }

about-glean-page-title2 = Về { -glean-brand-name }
about-glean-header = Về { -glean-brand-name }
about-glean-interface-description =
    <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name }</a>
    là một thư viện thu thập dữ liệu được sử dụng trong các dự án { -vendor-short-name }.
    Giao diện này được thiết kế để các nhà phát triển và người thử nghiệm sử dụng
    <a data-l10n-name="fog-link">thiết bị đo đạc kiểm tra</a> theo cách thủ công.

about-glean-upload-enabled = Tải lên dữ liệu được bật.
about-glean-upload-disabled = Tải lên dữ liệu bị tắt.
about-glean-upload-enabled-local = Tải lên dữ liệu chỉ được bật để gửi đến máy chủ cục bộ.
about-glean-upload-fake-enabled =
    Tải lên dữ liệu bị tắt,
    nhưng chúng tôi đang nói dối với { glean-sdk-brand-name } nó đang bật
    để dữ liệu vẫn được ghi cục bộ.
    Lưu ý: Nếu bạn đặt thẻ gỡ lỗi, ping sẽ được tải lên
    bất kể cài đặt nào của <a data-l10n-name="glean-debug-ping-viewer">{ glean-debug-ping-viewer-brand-name }</a>.

# This message is followed by a bulleted list.
about-glean-prefs-and-defines = <a data-l10n-name="fog-prefs-and-defines-doc-link">Các tùy chọn và định nghĩa</a> có liên quan bao gồm:
# Variables:
#   $data-upload-pref-value (String): the value of the datareporting.healthreport.uploadEnabled pref. Typically "true", sometimes "false"
# Do not translate strings between <code> </code> tags.
about-glean-data-upload = <code>datareporting.healthreport.uploadEnabled</code>: { $data-upload-pref-value }
# Variables:
#   $local-port-pref-value (Integer): the value of the telemetry.fog.test.localhost_port pref. Typically 0. Can be negative.
# Do not translate strings between <code> </code> tags.
about-glean-local-port = <code>telemetry.fog.test.localhost_port</code>: { $local-port-pref-value }
# Variables:
#   $glean-android-define-value (Boolean): the value of the MOZ_GLEAN_ANDROID define. Typically "false", sometimes "true".
# Do not translate strings between <code> </code> tags.
about-glean-glean-android = <code>MOZ_GLEAN_ANDROID</code>: { $glean-android-define-value }
# Variables:
#   $moz-official-define-value (Boolean): the value of the MOZILLA_OFFICIAL define.
# Do not translate strings between <code> </code> tags.
about-glean-moz-official = <code>MOZILLA_OFFICIAL</code>: { $moz-official-define-value }

about-glean-about-testing-header = Về thử nghiệm
# This message is followed by a numbered list.
about-glean-manual-testing =
    Hướng dẫn đầy đủ được ghi lại trong
    <a data-l10n-name="fog-instrumentation-test-doc-link">tài liệu thí nghiệm thiết bị { -fog-brand-name }</a>
    và trong <a data-l10n-name="glean-sdk-doc-link">tài liệu { glean-sdk-brand-name }</a>,
    nhưng tóm lại, để kiểm tra thủ công xem thiết bị của bạn có hoạt động hay không, bạn nên:

# This message is an option in a dropdown filled with untranslated names of pings.
about-glean-no-ping-label = (không gửi bất kỳ ping nào)
# An in-line text input field precedes this string.
about-glean-label-for-tag-pings = Trong trường văn bản, hãy đảm bảo có một thẻ gỡ lỗi đáng nhớ để bạn có thể nhận ra các lần ping của mình sau này.
# An in-line drop down list precedes this string.
# Do not translate strings between <code> </code> tags.
about-glean-label-for-ping-names =
    Chọn từ danh sách ping mà thiết bị của bạn đang ở.
    Nếu nó ở trong một <a data-l10n-name="custom-ping-link">ping tùy chỉnh</a>, chọn cái đó.
    Mặt khác, mặc định cho chỉ số <code>event</code> là
    ping <code>events</code>
    và mặc định cho tất cả các chỉ số khác là
    ping <code>metrics</code>.
# An in-line check box precedes this string.
about-glean-label-for-log-pings =
    (Không bắt buộc. Chọn hộp kiểm nếu bạn muốn ping cũng được ghi lại khi chúng được gửi.
    Bạn sẽ cần phải cần <a data-l10n-name="enable-logging-link">bật nhật ký</a> bổ sung.)
# Variables
#   $debug-tag (String): The user-set value of the debug tag input on this page. Like "about-glean-kV"
# An in-line button labeled "Apply settings and submit ping" precedes this string.
about-glean-label-for-controls-submit =
    Nhấn nút để gắn thẻ tất cả các ping { -glean-brand-name } với thẻ của bạn và gửi ping đã chọn.
    (Tất cả các ping được gửi từ đó cho đến khi bạn khởi động lại ứng dụng sẽ được gắn thẻ
    <code>{ $debug-tag }</code>.)
about-glean-li-for-visit-gdpv =
    <a data-l10n-name="gdpv-tagged-pings-link">Truy cập trang { glean-debug-ping-viewer-brand-name } cho ping với thẻ của bạn</a>.
    Sẽ không mất quá vài giây từ khi nhấn nút đến khi ping của bạn đến.
    Đôi khi có thể mất vài phút.

# Do not translate strings between <code> </code> tags.
about-glean-adhoc-explanation =
    Để biết thêm về kiểm thử <i>đặc biệt</i>,
    bạn cũng có thể xác định giá trị hiện tại của một thiết bị cụ thể
    bằng cách mở bảng điều khiển devtools tại đây trên <code>about:glean</code>
    và sử dụng API <code>testGetValue()</code> như
    <code>Glean.metricCategory.metricName.testGetValue()</code>.


controls-button-label-verbose = Áp dụng cài đặt và gửi ping

about-glean-about-data-header = Về dữ liệu
about-glean-about-data-explanation =
    Để duyệt danh sách dữ liệu đã thu thập, vui lòng tham khảo
    <a data-l10n-name="glean-dictionary-link">{ -glean-brand-name } Dictionary</a>.
