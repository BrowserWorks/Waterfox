# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

mkdir dictionaries
mv da.dic dictionaries/da.dic
mv da.aff dictionaries/da.aff
zip extension.xpi install.rdf icon.png README dictionaries/da.dic dictionaries/da.aff
mv dictionaries/da.dic da.dic
mv dictionaries/da.aff da.aff
rmdir dictionaries
