# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = მომსახურების გამოყენება
    .accesskey = რ

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (ნაგულისხმევი)
    .tooltiptext = ნაგულისხმევი URL-ბმული DNS-ის HTTPS-ით გადასაცემად

connection-dns-over-https-url-custom =
    .label = მითითებული
    .accesskey = თ
    .tooltiptext = შეიყვანეთ სასურველი URL-ბმული DNS-ის HTTPS-ით გადასაცემად

connection-dns-over-https-custom-label = მითითებული

connection-dialog-window =
    .title = კავშირის პარამეტრები
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 45em !important
        }

connection-proxy-legend = პროქსის გამართვა ინტერნეტ კავშირისთვის

proxy-type-no =
    .label = პროქსი არაა
    .accesskey = y

proxy-type-wpad =
    .label = ამ ქსელისთვის პროქსის პარამეტრების თვითამოცნობა
    .accesskey = w

proxy-type-system =
    .label = პროქსის სისტემური პარამეტრების გამოყენება
    .accesskey = u

proxy-type-manual =
    .label = პროქსის ხელით გამართვა:
    .accesskey = m

proxy-http-label =
    .value = HTTP პროქსი:
    .accesskey = h

http-port-label =
    .value = პორტი:
    .accesskey = p

proxy-http-sharing =
    .label = აგრეთვე, ამ პროქსის გამოყენება HTTPS-ისთვის
    .accesskey = ქ

proxy-https-label =
    .value = HTTPS-პროქსი:
    .accesskey = ს

ssl-port-label =
    .value = პორტი:
    .accesskey = o

proxy-socks-label =
    .value = SOCKS ჰოსტი:
    .accesskey = c

socks-port-label =
    .value = პორტი:
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = პროქსის თვითგამართვის URL:
    .accesskey = A

proxy-reload-label =
    .label = განახლება
    .accesskey = l

no-proxy-label =
    .value = პროქსი არაა:
    .accesskey = n

no-proxy-example = მაგალითი: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = ადგილობრივი კავშირები, 127.0.0.1 და ::1 არასდროს გამოიყენებს პროქსის.

proxy-password-prompt =
    .label = შესვლის მოთხოვნის გამოტოვება, თუ პაროლი დამახსოვრებულია
    .accesskey = ე
    .tooltiptext = ამ მითითების შედეგად, პროქსის ანგარიშზე ავტომატურად შეხვალთ, თუ ანგარიშის მონაცემები დამახსოვრებული იქნება. ასევე გეცნობებათ, თუ შესვლა ვერ მოხერხდება.

proxy-remote-dns =
    .label = პროქსის DNS SOCKS v5-ის გამოყენებისას
    .accesskey = D

proxy-enable-doh =
    .label = DNS-ის HTTPS-ით გადაცემის ჩართვა
    .accesskey = ვ
