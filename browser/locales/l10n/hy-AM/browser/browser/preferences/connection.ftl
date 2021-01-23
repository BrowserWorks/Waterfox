# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Միացման կարգավորումներ
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Անջատել ընդլայնումը

connection-proxy-configure = Կազմաձևել պրոքսի մատչումը համացանց

connection-proxy-option-no =
    .label = Առանց միջնորդի
    .accesskey = ի
connection-proxy-option-system =
    .label = Օգտագործել համակարգի միջնորդի կարգավորումները
    .accesskey = Օ
connection-proxy-option-auto =
    .label = Ինքնաբացահայտել միջնորդի կազմաձեվումն այս ցանցի համար
    .accesskey = ն
connection-proxy-option-manual =
    .label = Պրոքսիի ձեռքով կազմաձևում
    .accesskey = m

connection-proxy-http = HTTP պրոքսի
    .accesskey = x
connection-proxy-http-port = Պորտ
    .accesskey = Դ

connection-proxy-http-sharing =
    .label = Այս միջնորդը օգտագործեք նաև FTP-ի և HTTPS-ի համար
    .accesskey = s

connection-proxy-https = HTTPS միջնորդ
    .accesskey = H
connection-proxy-ssl-port = Պորտ
    .accesskey = ա

connection-proxy-ftp = FTP պրոքսի
    .accesskey = F
connection-proxy-ftp-port = Պորտ
    .accesskey = ր

connection-proxy-socks = SOCKS հոսթ
    .accesskey = C
connection-proxy-socks-port = Պորտ
    .accesskey = պ

connection-proxy-socks4 =
    .label = SOCKS տ4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS տ5
    .accesskey = տ
connection-proxy-noproxy = Չկա պրոքսի
    .accesskey = n

connection-proxy-noproxy-desc = Օրինակ՝ .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Միացումները տեղայինհանգույցին՝ 127.0.0.1 և ::1-ին, երբեք չեն վստահվում:

connection-proxy-autotype =
    .label = Պրոքսիի ինքնաբար կազմաձևում URL
    .accesskey = A

connection-proxy-reload =
    .label = Վերբեռնել
    .accesskey = ե

connection-proxy-autologin =
    .label = Գաղտնաբառը պահելիս վավերացում չհարցնել
    .accesskey = ր
    .tooltip = Այս ընտրանքը լռությամբ իսկորոշում է պրոքսիները, երբ պահպանում եք դրանց հավաստագրերը: Ձախողման դեպքում Ձեզ հարցում կկատարվի:

connection-proxy-socks-remote-dns =
    .label = Պրոքսի DNS՝ SOCKS v5 օգտագործելիս
    .accesskey = d

connection-dns-over-https =
    .label = Միացնել DNS-ը HTTPS-ով
    .accesskey = b

connection-dns-over-https-url-resolver = Օգտագործել մատակարար
    .accesskey = P

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Լռելյայն)
    .tooltiptext = Օգտագործեք լռելյայն  URL ՝ DNS ֊ HTTPS լուծելու համար։

connection-dns-over-https-url-custom =
    .label = Հարմարեցված
    .accesskey = C
    .tooltiptext = Մուտքագրե՛ք ձեր նախընտրած URL-ը DNS ֊ HTTPS լուծելու համար։

connection-dns-over-https-custom-label = Հարմարեցված
