# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Maidir le Próifílí
profiles-subtitle = Tá cuidiú ar an leathanach seo don té a bheas ag bainistiú próifíle. Is domhan ar leith gach aon phróifíl a bhfuil stair ar leith, leabharmharcanna ar leith, socruithe ar leith, agus breiseáin ar leith leo.
profiles-create = Cruthaigh Próifíl Nua
profiles-restart-title = Atosaigh
profiles-restart-in-safe-mode = Atosaigh agus Breiseáin Díchumasaithe…
profiles-restart-normal = Atosaigh sa ghnáthshlí…
profiles-conflict = D'athraigh cóip eile de { -brand-product-name } na próifílí. Caithfidh tú { -brand-short-name } a atosú sular féidir leat tuilleadh athruithe a chur i bhfeidhm.
profiles-flush-fail-title = Níor sábháladh na hathruithe
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Níor sábháladh na hathruithe mar gheall ar earráid nach rabhthas ag súil leis.
profiles-flush-restart-button = Atosaigh { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Próifíl: { $name }
profiles-is-default = Próifíl Réamhshocraithe
profiles-rootdir = Fréamhchomhadlann

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Comhadlann Logánta
profiles-current-profile = Is é seo an phróifíl atá in úsáid agat agus ní féidir í a scriosadh dá réir.
profiles-in-use-profile = Ní féidir an phróifíl seo a scriosadh toisc go bhfuil sí in úsáid ag feidhmchlár eile.

profiles-rename = Athainmnigh
profiles-remove = Bain
profiles-set-as-default = Socraigh mar an phróifíl réamhshocraithe
profiles-launch-profile = Tosaigh an phróifíl i mbrabhsálaí nua

profiles-cannot-set-as-default-title = Níor athraíodh an réamhshocrú
profiles-cannot-set-as-default-message = Ní féidir an phróifíl réamhshocraithe in { -brand-short-name } a athrú.

profiles-yes = tá
profiles-no = níl

profiles-rename-profile-title = Athainmnigh an Phróifíl
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Athainmnigh próifíl { $name }

profiles-invalid-profile-name-title = Ainm neamhbhailí próifíle
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Ní cheadaítear don ainm próifíle “{ $name }”.

profiles-delete-profile-title = Scrios an Phróifíl
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Bainfear an phróifíl ó liosta na bpróifílí atá ar fáil má scriostar í, agus ní féidir é seo a chur ar ceal.
    Is féidir leat scriosadh comhaid sonraí na bpróifílí a roghnú, do chuid socruithe san áireamh, chomh maith le teastais agus sonraí úsáideora eile. Scriosfaidh an rogha seo an fillteán “{ $dir }” agus ní féidir é a chur ar ceal.
    An bhfuil fonn ort comhaid sonraí na bpróifílí a scriosadh?
profiles-delete-files = Scrios na Comhaid
profiles-dont-delete-files = Ná Scrios na Comhaid

profiles-delete-profile-failed-title = Earráid
profiles-delete-profile-failed-message = Tharla earráid nuair a rinneadh iarracht an phróifíl seo a scriosadh.


profiles-opendir =
    { PLATFORM() ->
        [macos] Taispeáin san Aimsitheoir
        [windows] Oscail Fillteán
       *[other] Oscail an Comhadlann
    }
