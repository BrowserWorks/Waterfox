# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Օգտագործել մատակարարից
    .accesskey = r

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Լռելյայն)
    .tooltiptext = Օգտագործեք լռելյայն URL-ը DNS-ը HTTPS-ի վրա լուծելու համար

connection-dns-over-https-url-custom =
    .label = Ընտրովի
    .accesskey = C
    .tooltiptext = Մուտքագրեք Ձեր նախընտրված URL-ը DNS-ը HTTPS-ի վրա լուծելու համար

connection-dns-over-https-custom-label = Ընտրովի

connection-dialog-window =
    .title = Կապի կարգավորումներ
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Կարգավորել պրոքսին

proxy-type-no =
    .label = Առանց պրոքսի
    .accesskey = y

proxy-type-wpad =
    .label = Ինքնաբացահայտել պրոսքի կարգավորումը այս ցանցի համար
    .accesskey = w

proxy-type-system =
    .label = Համակարգի պրոքսի կարգավորումները
    .accesskey = U

proxy-type-manual =
    .label = Պրոքսի ձեռադիր կարգավորում.
    .accesskey = M

proxy-http-label =
    .value = HTTP պրոքսի.
    .accesskey = H

http-port-label =
    .value = Դարպասը.
    .accesskey = P

proxy-http-sharing =
    .label = Նաև օգտագործել այս պրոքսին HTTPS-ի համար
    .accesskey = x

proxy-https-label =
    .value = HTTP պրոքսի.
    .accesskey = S

ssl-port-label =
    .value = Դարպասը.
    .accesskey = o

proxy-socks-label =
    .value = SOCKS հոսթը.
    .accesskey = C

socks-port-label =
    .value = Դարպասը.
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = Պրոքսի ինքնակարգավորման URL.
    .accesskey = A

proxy-reload-label =
    .label = Վերբեռնել
    .accesskey = բ

no-proxy-label =
    .value = Չկա պրոքսի՝
    .accesskey = N

no-proxy-example = Օրինակ՝ .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Միացումները localhost- ին ՝ 127.0.0.1 և :: 1-ին, երբեք չեն միջնորդվում:

proxy-password-prompt =
    .label = Իսկորոշում չհարցնել, եթե գաղտնաբառը պահպանվա է
    .accesskey = i
    .tooltiptext = Այս ընտրանքը լռությամբ իսկորոծում է Ձեզ պրոքիներին, երբ պահպանում եք դրա ց հավատարմագրերը: Ձեզ հարցում կկատարվի, եթե իսկորոշումը ձախողվի:

proxy-remote-dns =
    .label = Պրոքսի DNS՝ SOCKS v5 օգտագործելիս
    .accesskey = d

proxy-enable-doh =
    .label = Միացնել DNS-ը HTTPS-ով
    .accesskey = b
