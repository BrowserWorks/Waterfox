# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Ikom propwail
profiles-subtitle = Potbuk man konyi me loono propwail mamegi. Propwail acelacel tye i lobo ne kene ma tye ki gin mukato, alamabuk, ter ki med-ikome ne kene.
profiles-create = Cwe propwail manyen
profiles-restart-title = Cak odoco
profiles-restart-in-safe-mode = Cak odoco ki Med-ikome ma kijuko woko…
profiles-restart-normal = Cak odoco kit ma jwi…

# Variables:
#   $name (String) - Name of the profile
profiles-name = Propwail: { $name }
profiles-is-default = Propwail makwongo

profiles-current-profile = Man aye propwail ma tye katic kadong pe kitwero kwanyo ne.

profiles-rename = Lok nyinge
profiles-remove = Kwany
profiles-set-as-default = Ter calo propwail makwongo
profiles-launch-profile = Cak propwail i layeny manyen

profiles-yes = eyo
profiles-no = pe

profiles-rename-profile-title = Lok nying propwail
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Lok nying propwail { $name }

profiles-invalid-profile-name-title = Nying propwail mape atir
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Pe ki yee nying me propwail ni "{ $name }".

profiles-delete-profile-title = Kwany propwail
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Kwanyo propwail bikwanyo propwail ne ki ikin propwail matye kadong pe bi gonye.
    Bene itwero yero me kwanyo pwail pa data me propwail, medo ki ter mamegi, catibiket ki data mukene malubo me tic. Gin ayera man bikwanyo boc me "{ $dir }" kadong pe bi gonye.
    Imito kwanyo pwail pa data me propwail?
profiles-delete-files = Kwany pwail
profiles-dont-delete-files = Pe i kwany pwail

profiles-delete-profile-failed-title = Bal


profiles-opendir =
    { PLATFORM() ->
        [macos] Nyut i Layeny
        [windows] Yab Boc
       *[other] Yab Boc
    }
