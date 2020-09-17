# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = இணைப்பு அமைப்புகள்
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = துணைநிரலை முடக்கவும்

connection-proxy-configure = இணையத்தை அணுக பதிலாளை கட்டமைக்கவும்

connection-proxy-option-no =
    .label = பதிலாள் இல்லை
    .accesskey = y
connection-proxy-option-system =
    .label = கணினி பதிலாள் அமைவுகளை பயன்படுத்துக
    .accesskey = U
connection-proxy-option-auto =
    .label = இந்தப் பிணையத்திற்குத் தானாக பதிலாள் அமைவுகளை கண்டறி
    .accesskey = w
connection-proxy-option-manual =
    .label = கைமுறை பதிலாள் கட்டமைப்பு
    .accesskey = m

connection-proxy-http = HTTP பதிலாள்
    .accesskey = x
connection-proxy-http-port = முனையம்
    .accesskey = P

connection-proxy-ssl-port = முனையம்
    .accesskey = o

connection-proxy-ftp = FTP பதிலாள்
    .accesskey = F
connection-proxy-ftp-port = முனையம்
    .accesskey = r

connection-proxy-socks = SOCKS புரவலன்
    .accesskey = C
connection-proxy-socks-port = முனையம்
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = இதற்கு பதிலாள் இல்லை
    .accesskey = n

connection-proxy-noproxy-desc = எடுத்துக்காட்டு: .mozilla.org, .net.nz, 192.168.1.0/24

connection-proxy-autotype =
    .label = தானியக்க பதிலாள் கட்டமைப்பு URL
    .accesskey = A

connection-proxy-reload =
    .label = மீளேற்று
    .accesskey = e

connection-proxy-autologin =
    .label = கடவுச்சொல் சேமிக்கப்பட்டிருந்தால் அங்கீகரிப்புக்காக நினைவுப்படத்த வே்டாம்
    .accesskey = i
    .tooltip = நீங்கள் கடவுச்சொற்களை சேமித்திருந்தால் இந்த விருப்பத்தேர்வானது சத்தமில்லாமல் உங்களை ப்ராக்ஸியில் அங்கீகரிக்கும். நீங்கள் அங்கீகரிக்கப்படாமல் இருந்தால் நினைவூட்டப்பட்டிருக்கும்.

connection-proxy-socks-remote-dns =
    .label = பதிலாள் DNS SOCKS V5 பயன்படுத்தும் போது
    .accesskey = d

connection-dns-over-https-url-resolver = வழங்குநரைப் பயன்படுத்தவும்
    .accesskey = P

connection-dns-over-https-url-custom =
    .label = தனிப்பயனாக்கு
    .accesskey = த
    .tooltiptext = HTTPS வழி DNS ஐ தீர்ப்பதற்கு உங்களின் விருப்ப URL ஐ உள்ளிடுக

connection-dns-over-https-custom-label = தனிப்பயன்
