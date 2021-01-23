# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Պրոֆիլների մասին
profiles-subtitle = Այս էջը օգնում է ձեզ կառավարել ձեր պրոֆիլները: Յուրաքանչյուր պրոֆիլ առանձին աշխարհ է, որը պարունակում է առանձին պատմություն, էջանիշեր, կարգավորումներ և հավելումներ:
profiles-create = Ստեղծել նոր պրոֆիլ
profiles-restart-title = Վերամեկնարկել
profiles-restart-in-safe-mode = Վերամեկնարկել՝ հավելումներն անջատված...
profiles-restart-normal = Նորմալ վերամեկնարկում...
profiles-conflict = { -brand-product-name }-ի մեկ այլ օրինակը փոփոխություններ է կատարել հատկագիրներում։ Այլ փոփոխություններ կատարելուց առաջ անհրաժեշտ է վերագործարկել { -brand-short-name }-ը:
profiles-flush-fail-title = Փոփոխությունները պահպանված չեն
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Անսպասելի սխալը կանխել է ձեր փոփոխությունների պահպանումը։
profiles-flush-restart-button = Վերագործարկել { -brand-short-name }֊ը

# Variables:
#   $name (String) - Name of the profile
profiles-name = Պրոֆիլ. { $name }
profiles-is-default = Լռելյայն պրոֆիլ
profiles-rootdir = Արմատական գրացուցակ

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Տեղային թղթապանակ.
profiles-current-profile = Այս պրոֆիլը օգտագործվում է և չի կարող ջնջվել:
profiles-in-use-profile = Այս պրոֆիլը կիրառման մեջ է, և այն հնարավոր չէ ջնջել։

profiles-rename = Վերանվանում
profiles-remove = Հեռացնել
profiles-set-as-default = Կայել որպես լռելյայն պրոֆիլ
profiles-launch-profile = Բացել պրոֆիլը նոր դիտարկիչով

profiles-cannot-set-as-default-title = Հնարավոր չէ կայել պատկերը
profiles-cannot-set-as-default-message = Լռելյայն  պրոֆիլը հնարավոր չէ փոխել { -brand-short-name }

profiles-yes = այո
profiles-no = ոչ

profiles-rename-profile-title = Հաշիվը Վերանվանել
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Վերանվանել { $name } պրոֆիլը

profiles-invalid-profile-name-title = Պրոֆիլի անվավեր անվանում
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Հաշվի "{ $name }" անվանումն անթույլատրելի է:

profiles-delete-profile-title = Ջնջել պրոֆիլը
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Պրոֆիլի ջնջումը կջնջի այն հասանելի պրոֆիլների ցուցակից և չի կարող ետարկվել:
     Դուք նաև կարող եք ընտրել և ջնջել պրոֆիլի տվյալների ֆայլերը՝ ներառյալ կարգավորումները, արտոնագրերը և օգտագործողին վերաբերող այլ տվյալներ: Այս ընտրանքը կջնջի ՙ{ $dir }՚ թղթապանակը և չի կարող ետարկվել:
    Ջնջե՞լ պրոֆիլի տվյալները:
profiles-delete-files = Ջնջել Ֆայլերը
profiles-dont-delete-files = Ֆայլերը Չջնջել

profiles-delete-profile-failed-title = Սխալ
profiles-delete-profile-failed-message = Այս պրոֆիլը ջնջելու ընթացքում սխալ տեղի ունեցավ։


profiles-opendir =
    { PLATFORM() ->
        [macos] Ցուցադրել Finder-ում
        [windows] Բացել թղթապանակը
       *[other] Բացել թղթապանակը
    }
