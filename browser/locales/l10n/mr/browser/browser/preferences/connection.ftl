# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = जोडणी सेटिंग्स्
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = वाढीव कार्यक्रम निष्क्रिय करा

connection-proxy-configure = इंटरनेट वापरण्यासाठी प्रॉक्सी ची मांडणी करा

connection-proxy-option-no =
    .label = प्रॉक्सी नाही
    .accesskey = y
connection-proxy-option-system =
    .label = प्रणाली प्रॉक्सी सेटिंग्जचा वापर करा
    .accesskey = U
connection-proxy-option-auto =
    .label = या नेटवर्कसाठी प्रतिनिधी(प्रॉक्सी) सेटींग्स आपोआप शोधून काढा
    .accesskey = w
connection-proxy-option-manual =
    .label = मानवीय प्रॉक्सी संयोजना
    .accesskey = m

connection-proxy-http = HTTP प्रॉक्सी
    .accesskey = x
connection-proxy-http-port = पोर्ट
    .accesskey = P

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
    .label = सॉक्स(SOCKS) v5
    .accesskey = v
connection-proxy-noproxy = करिता प्रॉक्सी नाही
    .accesskey = n

connection-proxy-noproxy-desc = उदाहरणार्थ: .mozilla.org, .net.nz, 192.168.1.0/24

connection-proxy-autotype =
    .label = स्वयं प्रॉक्सी संयोजना URL
    .accesskey = A

connection-proxy-reload =
    .label = पुन्हा लोड करा
    .accesskey = e

connection-proxy-autologin =
    .label = पासवर्ड साठवले असल्यास ओळख पटविण्याकरिता विचारू नका
    .accesskey = i
    .tooltip = प्रॉक्सीजकरिता श्रेय अगोदर साठवले असल्यास, हे पर्याय आपली ओळख पटवते. ओळख पटवणे अपयशी ठरल्यास आपणास विचारले जाईल.

connection-proxy-socks-remote-dns =
    .label = SOCKS v5 वापरताना DNS ची प्रॉक्सी करा
    .accesskey = d

connection-dns-over-https =
    .label = HTTPS वरील DNS सक्षम करा
    .accesskey = H

connection-dns-over-https-url-resolver = प्रदाता वापरा
    .accesskey = P

connection-dns-over-https-url-custom =
    .label = पसंतीचे
    .accesskey = C
    .tooltiptext = HTTPS वरील DNS चे निराकरण करण्यासाठी URL प्रविष्ट करा

connection-dns-over-https-custom-label = स्वपसंत
