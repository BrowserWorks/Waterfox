# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = कनेक्शन सेटिंग
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = एक्सटेंशन अक्षम करें

connection-proxy-configure = इंटरनेट चलने के लिए प्रॉक्सी विन्यस्त करें

connection-proxy-option-no =
    .label = कोई प्रॉक्सी नहीं
    .accesskey = y
connection-proxy-option-system =
    .label = तंत्र प्रॉक्सी सेटिंग का प्रयोग करें
    .accesskey = U
connection-proxy-option-auto =
    .label = इस संजाल के लिए प्रॉक्सी सेटिंग स्वतः जाँचें
    .accesskey = w
connection-proxy-option-manual =
    .label = खुद से प्रॉक्सी कॉन्फ़िगर करें
    .accesskey = m

connection-proxy-http = HTTP प्रॉक्सी
    .accesskey = x
connection-proxy-http-port = पोर्ट
    .accesskey = P

connection-proxy-http-sharing =
    .label = FTP और HTTPS के लिए इस प्रॉक्सी का भी उपयोग करें
    .accesskey = s

connection-proxy-https = HTTPS प्रॉक्सी
    .accesskey = H
connection-proxy-ssl-port = पोर्ट
    .accesskey = o

connection-proxy-ftp = FTP प्रॉक्सी
    .accesskey = F
connection-proxy-ftp-port = पोर्ट
    .accesskey = r

connection-proxy-socks = SOCKS होस्ट
    .accesskey = C
connection-proxy-socks-port = पोर्ट
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = के लिए कोई प्रॉक्सी नहीं
    .accesskey = n

connection-proxy-noproxy-desc = उदाहरण: .mozilla.org, .net.nz, 192.168.1.0/24

connection-proxy-autotype =
    .label = स्वचालित प्रॉक्सी कॉन्फ़िगरेशन URL
    .accesskey = A

connection-proxy-reload =
    .label = फिर लोड करें
    .accesskey = e

connection-proxy-autologin =
    .label = अगर शब्दकूट सहेजा जाता है तो प्रमाणीकरण के लिए संकेत न करें
    .accesskey = i
    .tooltip = यह विकल्प आपको धीमे से प्रॉक्सी के लिए सत्यापित करता है जब आप उसके लिए प्रमाण सहेजते हैं. आपको प्रांप्ट किया जाएगा यदि सत्यापन विफल रहता है.

connection-proxy-socks-remote-dns =
    .label = SOCKS v5 उपयोग करने पर स्थानापन्न डीएनएस
    .accesskey = d

connection-dns-over-https =
    .label = HTTPS पर DNS सक्षम करें
    .accesskey = H

connection-dns-over-https-url-resolver = प्रदाता का उपयोग करें
    .accesskey = P

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (तयशुदा)
    .tooltiptext = HTTPS पर DNS को हल करने के लिए तयशुदा URL का उपयोग करें

connection-dns-over-https-url-custom =
    .label = अनुकूलित करें
    .accesskey = स
    .tooltiptext = आप का प्रिफर्ड यूआरएल फॉर रेसोल्विंग डी न स  ओवर एचटीटीपीएस

connection-dns-over-https-custom-label = अनुकूलित
