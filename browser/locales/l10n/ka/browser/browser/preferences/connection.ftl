# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = კავშირის პარამეტრები
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = გაფართოების ამორთვა

connection-proxy-configure = პროქსის გამართვა ინტერნეტზე წვდომისათვის

connection-proxy-option-no =
    .label = პროქსის გარეშე
    .accesskey = გ
connection-proxy-option-system =
    .label = სისტემის პროქსის პარამეტრებით სარგებლობა
    .accesskey = ს
connection-proxy-option-auto =
    .label = პროქსის პარამეტრების ავტომატური დადგენა ამ ქსელისთვის
    .accesskey = ქ
connection-proxy-option-manual =
    .label = პროქსის ხელით გამართვა
    .accesskey = ხ

connection-proxy-http = HTTP პროქსი
    .accesskey = H
connection-proxy-http-port = პორტი
    .accesskey = პ

connection-proxy-http-sharing =
    .label = აგრეთვე, ამ პროქსის გამოყენება FTP-სა და HTTPS-ისთვის
    .accesskey = გ

connection-proxy-https = HTTPS-პროქსი
    .accesskey = H
connection-proxy-ssl-port = პორტი
    .accesskey = ო

connection-proxy-ftp = FTP პროქსი
    .accesskey = F
connection-proxy-ftp-port = პორტი
    .accesskey = რ

connection-proxy-socks = SOCKS ჰოსტი
    .accesskey = C
connection-proxy-socks-port = პორტი
    .accesskey = ტ

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = 4
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = 5
connection-proxy-noproxy = არ იქნება გამოყენებული შემდეგ მისამართებზე
    .accesskey = ა

connection-proxy-noproxy-desc = მაგალითი: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = ადგილობრივი კავშირები, 127.0.0.1 და ::1 არასდროს გამოიყენებს პროქსის.

connection-proxy-autotype =
    .label = პროქსის თვითგამართვის URL
    .accesskey = ა

connection-proxy-reload =
    .label = ხელახლა ჩატვირთვა
    .accesskey = ხ

connection-proxy-autologin =
    .label = შესვლის მოთხოვნის გამოტოვება, თუ პაროლი დამახსოვრებულია
    .accesskey = თ
    .tooltip = ამ მითითების შედეგად, პროქსის ანგარიშზე ავტომატურად შეხვალთ, თუ ანგარიშის მონაცემები შენახული იქნება. ასევე გეცნობებათ, თუ შესვლა ვერ მოხერხდება.

connection-proxy-socks-remote-dns =
    .label = პროქსის DNS SOCKS v5-ის გამოყენებისას
    .accesskey = d

connection-dns-over-https =
    .label = DNS-სთან HTTPS-კავშირი
    .accesskey = H

connection-dns-over-https-url-resolver = მომსახურების გამოყენება
    .accesskey = ხ

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (ნაგულისხმევი)
    .tooltiptext = ნაგულისხმევი URL-ბმულის გამოყენება DNS-გადაყვანებისთვის HTTPS-ით

connection-dns-over-https-url-custom =
    .label = მითითებული
    .accesskey = მ
    .tooltiptext = შეიყვანეთ სასურველი URL-მისამართი DNS-გადაყვანებისთვის HTTPS-ით

connection-dns-over-https-custom-label = მითითებული
