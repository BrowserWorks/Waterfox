# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Daftar Blokir
    .style = width: 55em

blocklist-description = Pilih daftar yang akan digunakan { -brand-short-name } untuk memblokir pelacak daring. Daftar disediakan oleh <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Daftar

blocklist-dialog =
    .buttonlabelaccept = Simpan Perubahan
    .buttonaccesskeyaccept = S


# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Daftar blokir level 1 (disarankan).
blocklist-item-moz-std-description = Izinkan beberapa pelacak agar lebih sedikit situs yang rusak.
blocklist-item-moz-full-listName = Daftar blokir level 2.
blocklist-item-moz-full-description = Blokir semua pelacak yang terdeteksi. Beberapa situs atau konten mungkin tidak dapat dimuat dengan baik.
