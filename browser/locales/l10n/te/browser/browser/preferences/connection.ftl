# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = అనుసంధాన అమరికలు
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }
connection-close-key =
    .key = w
connection-disable-extension =
    .label = పొడగింతను అచేతనించు
connection-proxy-configure = అంతర్జాలానికి ప్రాక్సీ అందుబాటును స్వరూపించండి
connection-proxy-option-no =
    .label = ప్రాక్సీ ఏమీలేదు
    .accesskey = y
connection-proxy-option-system =
    .label = సిస్టమ్ ప్రాక్సీ అమరికలు వాడు
    .accesskey = U
connection-proxy-option-auto =
    .label = ఈ నెట్‌వర్క్ ప్రాక్సీ అమరికలను స్వయంచాలకంగా గుర్తించు
    .accesskey = w
connection-proxy-option-manual =
    .label = మానవీయ ప్రాక్సీ స్వరూపణం
    .accesskey = m
connection-proxy-http = HTTP ప్రాక్సీ
    .accesskey = x
connection-proxy-http-port = పోర్టు
    .accesskey = P
connection-proxy-http-sharing =
    .label = FTP, HTTPSల కోసం కూడా ఈ ప్రాక్సీని వాడు
    .accesskey = s
connection-proxy-https = HTTPS ప్రాక్సీ
    .accesskey = H
connection-proxy-ssl-port = పోర్టు
    .accesskey = o
connection-proxy-ftp = FTP ప్రాక్సీ
    .accesskey = F
connection-proxy-ftp-port = పోర్టు
    .accesskey = r
connection-proxy-socks = SOCKS హోస్టు
    .accesskey = C
connection-proxy-socks-port = పోర్టు
    .accesskey = t
connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = వీటికి ప్రాక్సీ వద్దు
    .accesskey = n
connection-proxy-noproxy-desc = ఉదాహరణ: .mozilla.org, .net.nz, 192.168.1.0/24
connection-proxy-autotype =
    .label = స్వయంచాలక ప్రాక్సీ ఆకృతీకరణ URL
    .accesskey = A
connection-proxy-reload =
    .label = మళ్ళీ లోడుచేయి
    .accesskey = e
connection-proxy-autologin =
    .label = సంకేతపదం భద్రమైవుంటే అధీకరణకై అడుగకు
    .accesskey = i
    .tooltip = మీ ప్రాక్సీ ప్రవేశ వివరాలు భద్రపరచివుంటే ఈ ఎంపిక మిమ్మల్ని నిశ్శబ్దంగా ప్రాక్సీలకు అధీకరిస్తుంది. అధీకరణ విఫలమైనప్పుడు మిమ్మల్ని అడుగుతుంది.
connection-proxy-socks-remote-dns =
    .label = SOCKS v5 వాడేటప్పుడు ప్రాక్సీ DNS
    .accesskey = D
connection-dns-over-https =
    .label = HTTPS పై DNSను చేతనించు
    .accesskey = b
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (అప్రమేయం)
    .tooltiptext = HTTPS ద్వారా DNS పరిష్కరించడానికి అప్రమేయ చిరునామా వాడండి
connection-dns-over-https-url-custom =
    .label = అభిమతం
    .accesskey = C
    .tooltiptext = DNSను HTTPS ద్వారా పరిష్కరించడానికి మీరు ప్రాధాన్యమిచ్చే URL ఇవ్వండి
connection-dns-over-https-custom-label = అభిమతం
