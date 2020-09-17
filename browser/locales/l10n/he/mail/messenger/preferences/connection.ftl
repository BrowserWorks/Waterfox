# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dialog-window =
    .title = הגדרות חיבור
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 46em !important
        }

connection-proxy-legend = קבע תצורה לשרתים מתווכים לגישה לאינטרנט

proxy-type-no =
    .label = ללא שרת מתווך
    .accesskey = ל

proxy-type-wpad =
    .label = זיהוי אוטומטי של הגדרות שרת המתווך עבור רשת זו
    .accesskey = ז

proxy-type-system =
    .label = השתמש בהגדרות השרת המתווך של המערכת
    .accesskey = מ

proxy-type-manual =
    .label = הגדרות שרת מתווך ידניות:
    .accesskey = ה

proxy-http-label =
    .value = שרת מתווך HTTP‏:
    .accesskey = H

http-port-label =
    .value = שער:
    .accesskey = ש

ssl-port-label =
    .value = שער:
    .accesskey = ע

proxy-socks-label =
    .value = שרת מארח SOCKS:
    .accesskey = C

socks-port-label =
    .value = שער:
    .accesskey = ר

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = כתובת לתצורה אוטומטית של שרת מתווך:
    .accesskey = ת

proxy-reload-label =
    .label = טען מחדש
    .accesskey = ט

no-proxy-label =
    .value = אין צורך בשרת מתווך עבור:
    .accesskey = ב

no-proxy-example = דוגמה: mozilla.org,‏ .net.il, 192.168.1.0/24

proxy-password-prompt =
    .label = לא לבקש אימות אם הססמה נשמרה
    .accesskey = נ
    .tooltiptext = אפשרות זו מאמתת אותך מאחורי הקלעים מול מתווכים שמולם שמרת פרטי אימות. אם האימות נכשל תופיע הודעה.

proxy-remote-dns =
    .label = DNS מצד המתווך בעת שימוש ב־SOCKS v5
    .accesskey = צ

