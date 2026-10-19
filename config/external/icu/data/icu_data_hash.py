# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import hashlib


def main(output, data_file, template):
    # icu_data.S embeds the data with .incbin, which compiler caches can't see.
    # Emitting the hash at the top of the compiled source makes it change with
    # the data.
    with open(data_file, "rb") as f:
        digest = hashlib.sha256(f.read()).hexdigest()
    output.write(f'#define ICU_DATA_HASH "{digest}"\n')
    with open(template) as f:
        output.write(f.read())
