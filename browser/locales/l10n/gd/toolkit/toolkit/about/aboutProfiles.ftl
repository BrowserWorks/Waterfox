# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Mu na pròifilean
profiles-subtitle = ’S urrainn dhut na pròifilean agad a stiùireadh air an duilleag seo. Tha gach pròifil ’na shaoghal fa leth a thaobh na h-eachdraidh, nan comharran-lìn, roghainnean is tuilleadan.
profiles-create = Cruthaich pròifil ùr
profiles-restart-title = Ath-thòisich
profiles-restart-in-safe-mode = Ath-thòisich leis na tuilleadan à comas…
profiles-restart-normal = Ath-thòisich air an dòigh àbhaisteach…
profiles-conflict = Rinn lethbhreac eile de { -brand-product-name } atharraichean air pròifilean. Feumaidh tu { -brand-short-name } ath-thòiseachadh mus atharraich thu dad eile.
profiles-flush-fail-title = Cha deach na h-atharraichean a shàbhaladh
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Thachair mearachd ris nach robh dùil agus cha deach na h-atharraichean agad a shàbhaladh ri linn sin.
profiles-flush-restart-button = Ath-thòisich { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Pròifil: { $name }
profiles-is-default = A’ phròifil bhunaiteach
profiles-rootdir = Am pasgan root

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Am pasgan ionadail
profiles-current-profile = Tha a’ phròifil seo ’ga chleachdadh is cha ghabh a sguabadh às.
profiles-in-use-profile = Tha a’ phròifil seo ’ga chleachdadh ann an aplacaid eile ’s cha ghabh a sguabadh às.

profiles-rename = Thoir ainm ùr air
profiles-remove = Thoir air falbh
profiles-set-as-default = Suidhich mar a’ phròifil bhunaiteach
profiles-launch-profile = Cuir gu dol a’ phròifil ann am brabhsair ùr

profiles-cannot-set-as-default-title = Cha ghabh bun-roghainn a shuidheachadh
profiles-cannot-set-as-default-message = Cha ghabh a’ phròifil bhunaiteach atharrachadh airson { -brand-short-name }.

profiles-yes = tha
profiles-no = chan eil

profiles-rename-profile-title = Thoir ainm ùr air a’ phròifil
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Thoir ainm ùr air pròifil { $name }

profiles-invalid-profile-name-title = Tha ainm na pròifil mì-dhligheach
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Chan eil an t-ainm “{ $name }” ceadaichte airson pròifil.

profiles-delete-profile-title = Sguab às a’ phròifil
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Ma sguabas tu às pròifil, thèid a chur far liosta nam pròifilean a tha rim faighinn is chan urrainn dhut seo aiseag.
    ’S urrainn dhut faidhlichean dàta na pròifile a sguabadh às cuideachd, a’ gabhail a-steach nan roghainnean, ceadachasan is dàta eile co-cheangailte ris a’ chleachdaiche. Sguabaidh an roghainn seo às am pasgan “{ $dir }” is chan urrainn dhut seo aiseag.
    A bheil thu airson faidhlichean dàta na pròifile a sguabadh às?
profiles-delete-files = Sguab às na faidhlichean
profiles-dont-delete-files = Na sguab às na faidhlichean

profiles-delete-profile-failed-title = Mearachd
profiles-delete-profile-failed-message = Thachair mearachd fhad ’s a bha sinn a’ feuchainn ris a’ phròifil seo a sguabadh às.


profiles-opendir =
    { PLATFORM() ->
        [macos] Seall san lorgair
        [windows] Fosgail pasgan
       *[other] Fosgail am pasgan
    }
