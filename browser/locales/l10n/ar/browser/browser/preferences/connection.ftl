# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = إعدادات الاتّصال
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }
connection-close-key =
    .key = w
connection-disable-extension =
    .label = عطّل الامتداد
connection-proxy-configure = اضبط وصول الوسيط إلى الإنترنت
connection-proxy-option-no =
    .label = لا وسيط
    .accesskey = ل
connection-proxy-option-system =
    .label = استخدم إعدادات النظام للوسيط
    .accesskey = ن
connection-proxy-option-auto =
    .label = تعرَّف تلقائيًّا على إعدادات وسيط هذه الشَّبكة
    .accesskey = ش
connection-proxy-option-manual =
    .label = إعداد الوسيط يدويا
    .accesskey = ي
connection-proxy-http = وسيط HTTP
    .accesskey = س
connection-proxy-http-port = المنفذ
    .accesskey = م
connection-proxy-http-sharing =
    .label = استعمل هذا الوسيط لبروتوكولات FTP وHTTPS أيضًا
    .accesskey = ك
connection-proxy-https = وسيط HTTPS
    .accesskey = ط
connection-proxy-ssl-port = المنفذ
    .accesskey = ن
connection-proxy-ftp = وسيط FTP
    .accesskey = و
connection-proxy-ftp-port = المنفذ
    .accesskey = ف
connection-proxy-socks = مستضيف SOCKS
    .accesskey = ض
connection-proxy-socks-port = المنفذ
    .accesskey = ذ
connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = لا وسيط ل‍
    .accesskey = ل
connection-proxy-noproxy-desc = مثلًا: .mozilla.org, .net.nz, 192.168.1.0/24
# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = ما من وسيط يقع بين اتصالك مع localhost و 127.0.0.1 و ‎::1 .
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = ما من وسيط يقع بين اتصالك مع localhost و 127.0.0.1/8 و ‎::1 .
connection-proxy-autotype =
    .label = مسار إعداد الوسيط آليا
    .accesskey = و
connection-proxy-reload =
    .label = أعد التحميل
    .accesskey = ع
connection-proxy-autologin =
    .label = لا تسأل الاستيثاق إذا كانت كلمة السر محفوظة
    .accesskey = س
    .tooltip = يستوثق هذا الخيار مع وسطاء الشبكة تلقائيًا إذا كان لديك بيانات ولوج محفوظة لهم. ستُسأل إذا فشل الاستيثاق.
connection-proxy-socks-remote-dns =
    .label = خادوم عناوين نطاقات الوسيط أثناء استخدام SOCKS v5
    .accesskey = ط
connection-dns-over-https =
    .label = فعّل DNS عبر HTTPS
    .accesskey = ع
connection-dns-over-https-url-resolver = استعمل المزوّد
    .accesskey = ع
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (المبدئي)
    .tooltiptext = استخدم المسار المبدئي لحلّ DNS عبر HTTPS
connection-dns-over-https-url-custom =
    .label = مخصّص
    .accesskey = خ
    .tooltiptext = أدخِل المسار الذي تريده لحلّ DNS عبر HTTPS
connection-dns-over-https-custom-label = مخصّص
