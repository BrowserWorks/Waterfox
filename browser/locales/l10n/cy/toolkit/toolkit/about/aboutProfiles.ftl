# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Ynghylch Proffiliau
profiles-subtitle = Mae'r dudalen hon yn eich helpu i reoli eich proffiliau. Mae pob proffil yn fyd ar wahân sy'n cynnwys hanes, nodau tudalen, gosodiadau ac yn ychwanegion gwahanol.
profiles-create = Creu Proffil Newydd
profiles-restart-title = Ailgychwyn
profiles-restart-in-safe-mode = Ailgychwyn gydag Ychwanegion wedi eu Hanablu…
profiles-restart-normal = Ailgychwyn fel arfer…
profiles-conflict = Mae copi arall o { -brand-product-name } wedi gwneud newidiadau i broffiliau. Rhaid ailgychwyn { -brand-short-name } cyn gwneud mwy o newidiadau.
profiles-flush-fail-title = Heb gadw'r newidiadau
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Mae gwall annisgwyl wedi atal eich newidiadau rhag cael eu cadw.
profiles-flush-restart-button = Ailgychwyn { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Proffil: { $name }
profiles-is-default = Proffil Ragosodedig
profiles-rootdir = Cyfarwyddiadur Gwraidd

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Cyfarwyddiadur Lleol
profiles-current-profile = Dyma'r proffil sy'n cael ei ddefnyddio ac nid oes modd ei ddileu.
profiles-in-use-profile = Mae'r proffil yn cael ei ddefnyddio o fewn rhaglen arall ac nid oes modd ei ddileu.

profiles-rename = Ailenwi
profiles-remove = Tynnu
profiles-set-as-default = Gosod fel y proffil ragosodedig
profiles-launch-profile = Cychwyn proffil yn y porwr newydd

profiles-cannot-set-as-default-title = Methu gosod y rhagosodedig
profiles-cannot-set-as-default-message = Nid oes modd newid y proffil rhagosodedig am { -brand-short-name }.

profiles-yes = iawn
profiles-no = na

profiles-rename-profile-title = Newid Enw Proffil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Ailenwi proffil { $name }

profiles-invalid-profile-name-title = Enw proffil annilys
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Methu caniatáu enw proffil "{ $name }".

profiles-delete-profile-title = Dileu Proffil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Bydd dileu proffil yn tynnu'r proffil o'r rhestr o broffiliau sydd ar gael ac nid oes modd ei ddadwneud.
    Gallwch hefyd ddewis i ddileu ffeiliau data proffil, gan gynnwys eich gosodiadau, tystysgrifau a data arall yn perthyn i ddefnyddwyr. Bydd y dewis hwn yn dileu ffolder "{ $dir }" ac nid oes modd ei ddadwneud.
    Hoffech chi ddileu'r ffeiliau data proffil?
profiles-delete-files = Dileu Ffeiliau
profiles-dont-delete-files = Peidio Dileu Ffeiliau

profiles-delete-profile-failed-title = Gwall
profiles-delete-profile-failed-message = Bu gwall wrth geisio dileu'r proffil hwn.


profiles-opendir =
    { PLATFORM() ->
        [macos] Dangos yn Finder
        [windows] Agor Ffolder
       *[other] Agor Cyfeiriadur
    }
