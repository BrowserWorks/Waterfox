# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-custom-label = مخصّص

connection-dialog-window =
    .title = إعدادات الاتّصال
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = اضبط وسطاء الدخول إلى الإنترنت

proxy-type-no =
    .label = بدون وسيط
    .accesskey = و

proxy-type-wpad =
    .label = تعرَّف تلقائيًّا على إعدادات وسيط هذه الشَّبكة
    .accesskey = ش

proxy-type-system =
    .label = استخدم إعدادات وسيط النظام
    .accesskey = م

proxy-type-manual =
    .label = ضبط يدوي للوسيط:
    .accesskey = ي

proxy-http-label =
    .value = وسيط HTTP:
    .accesskey = H

http-port-label =
    .value = المنفذ:
    .accesskey = م

ssl-port-label =
    .value = المنفذ:
    .accesskey = ن

proxy-socks-label =
    .value = مُضيف SOCKS:
    .accesskey = C

socks-port-label =
    .value = المنفذ:
    .accesskey = ذ

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = مسار الضبط التلقائي للوسيط:
    .accesskey = ت

proxy-reload-label =
    .label = أعد التحميل
    .accesskey = ح

no-proxy-label =
    .value = لا وسيط لأجل:
    .accesskey = و

no-proxy-example = مثال: .mozilla.org, .net.nz, 192.168.1.0/24

proxy-password-prompt =
    .label = لا تسأل الاستيثاق إذا كانت كلمة السر محفوظة
    .accesskey = س
    .tooltiptext = يستوثق هذا الخيار مع وسطاء الشبكة تلقائيًا إذا كان لديك بيانات ولوج محفوظة لهم. ستُسأل إذا فشل الاستيثاق.

proxy-remote-dns =
    .label = خادوم عناوين نطاقات الوسيط أثناء استخدام SOCKS v5
    .accesskey = ن

