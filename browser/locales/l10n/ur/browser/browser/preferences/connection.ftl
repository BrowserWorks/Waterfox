# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = کنکشن سیٹنگز
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = ایکسٹینشن غیرفعال بنائیں

connection-proxy-configure = انٹرنیٹ چلانے کے لئے پراکسی کنفیگر کریں

connection-proxy-option-no =
    .label = کوئی پراکسی نہیں
    .accesskey = y
connection-proxy-option-system =
    .label = نظام کی پراکسی سیٹنگز استعمال کریں
    .accesskey = U
connection-proxy-option-auto =
    .label = اس نیٹورک کے لیے پراکسی سیٹنگز خود کھوج کریں
    .accesskey = w
connection-proxy-option-manual =
    .label = من متابک پراکسی سیٹنگز
    .accesskey = M

connection-proxy-http = HTTP پراکسی
    .accesskey = x
connection-proxy-http-port = پورٹ
    .accesskey = P

connection-proxy-https = HTTPS پراکسی
    .accesskey = H
connection-proxy-ssl-port = پورٹ
    .accesskey = o

connection-proxy-ftp = FTP  پراکسی
    .accesskey = F
connection-proxy-ftp-port = پورٹ
    .accesskey = r

connection-proxy-socks = SOCKS ھوسٹ
    .accesskey = C
connection-proxy-socks-port = پورٹ
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS ورژن 4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS ورژن 5
    .accesskey = v
connection-proxy-noproxy = کے لئے کوئی پراکسی نہیں
    .accesskey = N

connection-proxy-noproxy-desc = مثال: .mozilla.org ،.net.nz ،192.168.1.0/24

connection-proxy-autotype =
    .label = خودکار پراکسی تشکیل URL
    .accesskey = A

connection-proxy-reload =
    .label = پھر لوڈ کریں
    .accesskey = e

connection-proxy-autologin =
    .label = تصدیق کے لئے فوری طور پر ترغیب نہیں دیں اگر پاس ورڈ پہلے سے محفوظ شدہ ہے
    .accesskey = i
    .tooltip = یہ اختیار خاموشی سے پراکسی پر توثیق کر دیتی ہے جب آپ نے ان کے لیے اسناد محفوظ کیے ہوں۔  توثیق ناکام ہونے کی صورت میں آپ کو بتا دیا جائے گا۔

connection-proxy-socks-remote-dns =
    .label = پراکسی DNS جب استعمال کر رہے ہوں SOCKS v5
    .accesskey = D

connection-dns-over-https =
    .label = HTTPS پر DNS بحال کریں
    .accesskey = b

connection-dns-over-https-url-resolver = فراہم کنندہ استعمال کریں
    .accesskey = P

connection-dns-over-https-custom-label = مخصوص
