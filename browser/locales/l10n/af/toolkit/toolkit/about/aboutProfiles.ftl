# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Aangaande profiele
profiles-subtitle = Dié bladsy help om profiele te bestuur. Elke profiel is sy eie wêreld wat afsonderlike geskiedenis, boekmerke, instelling en byvoegings bevat.
profiles-create = Skep 'n nuwe profiel
profiles-restart-title = Herbegin
profiles-restart-in-safe-mode = Herbegin met byvoegings gedeaktiveer…
profiles-restart-normal = Herbegin gewoonweg…
profiles-flush-fail-title = Wysigings nie gestoor nie
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = 'n Onverwagte fout het verhoed dat u veranderinge gestoor word.
profiles-flush-restart-button = Herbegin { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profiel: { $name }
profiles-is-default = Verstekprofiel
profiles-rootdir = Wortelgids

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Plaaslike gids
profiles-current-profile = Hierdie profiel is tans in gebruik en kan nie geskrap word nie.
profiles-in-use-profile = Hierdie profiel word in 'n ander program gebruik en kan nie uitgevee word nie.

profiles-rename = Hernoem
profiles-remove = Verwyder
profiles-set-as-default = Stel as verstekprofiel
profiles-launch-profile = Begin met profiel in nuwe blaaier

profiles-cannot-set-as-default-title = Kan nie verstek stel nie

profiles-yes = ja
profiles-no = nee

profiles-rename-profile-title = Hernoem profiel
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Hernoem profiel { $name }

profiles-invalid-profile-name-title = Ongeldige profielnaam
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Die profielnaam “{ $name }” word nie toegelaat nie.

profiles-delete-profile-title = Skrap profiel
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    As u 'n profiel skrap, sal die profiel van die lys beskikbare profiele verwyder word, en dit kan nie ontdoen word nie.
    U kan ook kies om die profieldatalêers te skrap, waaronder u instellings, sertifikate en ander gebruikerverwante data. Hierdie opsie sal die gids “{ $dir }” skrap, en dit kan nie ontdoen word nie.
    Wil u die profieldatalêers skrap?
profiles-delete-files = Skrap lêers
profiles-dont-delete-files = Moenie lêers skrap nie

profiles-delete-profile-failed-title = Fout


profiles-opendir =
    { PLATFORM() ->
        [macos] Wys in Finder
        [windows] Open gids
       *[other] Open gids
    }
