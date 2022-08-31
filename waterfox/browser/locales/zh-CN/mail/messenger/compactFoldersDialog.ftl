# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = 压缩邮件夹
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = 立即压缩
    .buttonaccesskeyaccept = C
    .buttonlabelcancel = 以后再提醒我
    .buttonaccesskeycancel = R
    .buttonlabelextra1 = 详细了解…
    .buttonaccesskeyextra1 = L

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } 需要定期压缩您的邮件夹，以提升性能。此操作可释放出 { $data } 磁盘空间，且不会影响邮件内容。若要让 { -brand-short-name } 未来自动进行压缩而不再询问，请勾选“{ compact-dialog.buttonlabelaccept }”旁的选择框。

compact-dialog-never-ask-checkbox =
    .label = 未来自动压缩邮件夹
    .accesskey = a

