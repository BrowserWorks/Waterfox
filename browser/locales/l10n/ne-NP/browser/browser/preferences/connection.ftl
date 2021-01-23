# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = जडान सेटिङहरू
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = एक्सटेन्सन अक्षम गर्नुहोस्

connection-proxy-option-no =
    .label = प्रोक्सी प्रयोग नगर्नु
    .accesskey = y
connection-proxy-option-system =
    .label = प्रणालीको प्रोक्सी व्यवस्था प्रयोग गर्नुहोस्
    .accesskey = U
connection-proxy-option-auto =
    .label = यो नेटवर्क को लागि प्रोक्सी व्यवस्था आफै पत्ता लगाउनु
    .accesskey = w
connection-proxy-option-manual =
    .label = मानवचालित प्रोक्सी कन्फिगरेसन
    .accesskey = m

connection-proxy-http = HTTP प्रोक्सी
    .accesskey = x
connection-proxy-http-port = पोर्ट
    .accesskey = P

connection-proxy-ssl-port = पोर्ट
    .accesskey = o

connection-proxy-ftp = FTP प्रोक्सी
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
connection-proxy-noproxy = को लागि कुनै प्रोक्सी छैन
    .accesskey = n

connection-proxy-noproxy-desc = उदाहरण: .mozilla.org, .net.nz, १९२.१६८.१.०/२४

connection-proxy-autotype =
    .label = स्वचालित प्रोक्सी कन्फिगरेसन URL
    .accesskey = A

connection-proxy-reload =
    .label = फेरी पेजको सामग्री भर्नुहोस
    .accesskey = e

connection-proxy-autologin =
    .label = यदि गोप्यशब्द सङ्ग्रह गरिएको छ भने गोप्यशब्द प्रमाणीकरणको लागि झक्झक्याउने नगर्नुहोस्
    .accesskey = i
    .tooltip = यो विकल्पले तपाईँलाई सुचना नदिई प्रोक्सीहरू सामु तपाईँको पहिचान स्थापना गराउँछ यदि ती प्रोक्सीहरूका प्रमाणपत्र सङ्ग्रह गर्नुभएको खण्डमा। पहिचान स्थापना गराउन असफल भएमा तपाईँलाई सुचना दिइनेछ।

connection-proxy-socks-remote-dns =
    .label = SOCKS v5 प्रयोग गर्दा DNS प्रोक्सी गर्नुहोस्
    .accesskey = द

