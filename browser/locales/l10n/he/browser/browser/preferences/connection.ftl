# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = הגדרות חיבור
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = השבתת הרחבה

connection-proxy-configure = הגדרת גישה לאינטרנט דרך מתווך

connection-proxy-option-no =
    .label = ללא שרת מתווך
    .accesskey = ל
connection-proxy-option-system =
    .label = שימוש בהגדרות השרת המתווך של המערכת
    .accesskey = מ
connection-proxy-option-auto =
    .label = זיהוי אוטומטי של הגדרות שרת המתווך עבור רשת זו
    .accesskey = ז
connection-proxy-option-manual =
    .label = הגדרות שרת מתווך ידניות
    .accesskey = ש

connection-proxy-http = שרת מתווך HTTP‏
    .accesskey = H
connection-proxy-http-port = שער
    .accesskey = ש

connection-proxy-http-sharing =
    .label = שימוש בשרת מתווך זה גם עבור FTP ו־HTTPS
    .accesskey = ש

connection-proxy-https = שרת מתווך HTTPS
    .accesskey = S
connection-proxy-ssl-port = שער
    .accesskey = ע

connection-proxy-ftp = שרת מתווך FTP
    .accesskey = F
connection-proxy-ftp-port = שער
    .accesskey = ר

connection-proxy-socks = שרת מארח SOCKS
    .accesskey = C
connection-proxy-socks-port = שער
    .accesskey = ש

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = 4
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = 5
connection-proxy-noproxy = אין צורך בשרת מתווך עבור
    .accesskey = ב

connection-proxy-noproxy-desc = דוגמה: mozilla.org.,‏ net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = חיבורים אל localhost,‏ 127.0.0.1 ואל ‎::1 לעולם לא יועברו דרך מתווך.

connection-proxy-autotype =
    .label = כתובת לתצורה אוטומטית של שרת מתווך
    .accesskey = ת

connection-proxy-reload =
    .label = טעינה מחדש
    .accesskey = ט

connection-proxy-autologin =
    .label = לא לבקש ססמת הזדהות אם נשמרה הססמה
    .accesskey = ס
    .tooltip = אפשרות זו מבצעת הזדהות שקטה מול שרתים מתווכים כאשר נשמרו פרטי ההתחברות עבורם. בקשת ההזדהות תופיע אם האימות נכשל.

connection-proxy-socks-remote-dns =
    .label = שימוש ב־DNS דרך מתווך בעת שימוש ב־SOCKS v5
    .accesskey = מ

connection-dns-over-https =
    .label = הפעלת DNS על גבי HTTPS
    .accesskey = פ

connection-dns-over-https-url-resolver = שימוש בספק
    .accesskey = ש

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = ‏{ $name } (ברירת מחדל)
    .tooltiptext = שימוש בכתובת ברירת המחדל כדי לפתור שאילתות DNS על גבי HTTPS

connection-dns-over-https-url-custom =
    .label = מותאם אישית
    .accesskey = א
    .tooltiptext = נא להקליד את הכתובת המועדפת עליך לפתרון DNS על גבי HTTPS

connection-dns-over-https-custom-label = מותאם אישית
