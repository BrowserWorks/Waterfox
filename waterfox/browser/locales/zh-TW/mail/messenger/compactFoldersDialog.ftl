# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = 壓實重整郵件匣
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = 立即壓實重整
    .buttonaccesskeyaccept = C
    .buttonlabelcancel = 稍後再提醒我
    .buttonaccesskeycancel = R
    .buttonlabelextra1 = 了解更多…
    .buttonaccesskeyextra1 = L

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } 需要定期進行壓實重整您的信件匣檔案，以維護效能。這個動作可清理出 { $data } 磁碟空間，不會影響信件內容。若要讓 { -brand-short-name } 未來自動進行壓實重整，而不先詢問您，請勾選「{ compact-dialog.buttonlabelaccept }」旁的選取盒。

compact-dialog-never-ask-checkbox =
    .label = 未來自動壓實重整郵件匣
    .accesskey = a

