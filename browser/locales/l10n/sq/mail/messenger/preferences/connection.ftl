# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Përdor Furnizues
    .accesskey = P

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Parazgjedhje)
    .tooltiptext = Për ftillim DNS-je përmes HTTPS-je përdor URL-në parazgjedhje

connection-dns-over-https-url-custom =
    .label = Vetjake
    .accesskey = V
    .tooltiptext = Jepni URL-në tuaj të parapëlqyer për ftillim DNS-je përmes HTTPS-së

connection-dns-over-https-custom-label = Vetjake

connection-dialog-window =
    .title = Rregullime Lidhjeje
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Formësim Ndërmjetësish për Hyrje në Internet

proxy-type-no =
    .label = Pa ndërmjetës
    .accesskey = P

proxy-type-wpad =
    .label = Vetëzbulo rregullime ndërmjetësi për këtë rrjet
    .accesskey = v

proxy-type-system =
    .label = Për ndërmjetësin përdor rregullime sistemi
    .accesskey = n

proxy-type-manual =
    .label = Formësim ndërmjetësi dorazi:
    .accesskey = f

proxy-http-label =
    .value = Ndërmjetës HTTP:
    .accesskey = h

http-port-label =
    .value = Portë:
    .accesskey = o

proxy-http-sharing =
    .label = Përdor gjithashtu këtë ndërmjetës për HTTPS
    .accesskey = x

proxy-https-label =
    .value = Ndërmjetës HTTPS:
    .accesskey = S

ssl-port-label =
    .value = Portë:
    .accesskey = r

proxy-socks-label =
    .value = Strehë SOCKS:
    .accesskey = C

socks-port-label =
    .value = Portë:
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = 4

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = 5

proxy-type-auto =
    .label = URL formësimi të vetvetishëm ndërmjetësi:
    .accesskey = U

proxy-reload-label =
    .label = Ringarkoje
    .accesskey = R

no-proxy-label =
    .value = Pa Ndërmjetës për:
    .accesskey = a

no-proxy-example = Shembull: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Lidhjet me localhost, 127.0.0.1, dhe ::1 nuk kalohen kurrë përmes ndërmjetësi.

proxy-password-prompt =
    .label = Mos shfaq kërkesë mirëfilltësimi, nëse është ruajtur fjalëkalim
    .accesskey = o
    .tooltiptext = Me këtë mundësi, mirëfilltësimi te ndërmjetësit, bëhet heshtazi, kur keni kredenciale të ruajtura për ta. Nëse mirëfilltësimi dështon, do të shfaqet kërkesa.

proxy-remote-dns =
    .label = DNS ndërmjetësi kur përdoret SOCKS v5
    .accesskey = D

proxy-enable-doh =
    .label = Aktivizoni DNS përmes HTTPS-je
    .accesskey = z
