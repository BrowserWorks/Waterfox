# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Over profielen
profiles-subtitle = Deze pagina helpt u uw profielen te beheren. Elk profiel is een aparte omgeving die aparte geschiedenis, bladwijzers, instellingen en add-ons bevat.
profiles-create = Een nieuw profiel aanmaken
profiles-restart-title = Herstarten
profiles-restart-in-safe-mode = Herstarten met uitgeschakelde add-ons…
profiles-restart-normal = Normaal herstarten…
profiles-conflict = Een ander exemplaar van { -brand-product-name } heeft wijzigingen in profielen aangebracht. U moet { -brand-short-name } opnieuw starten, voordat u meer wijzigingen aanbrengt.
profiles-flush-fail-title = Wijzigingen niet opgeslagen
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Door een onverwachte fout zijn uw wijzigingen niet opgeslagen.
profiles-flush-restart-button = { -brand-short-name } herstarten

# Variables:
#   $name (String) - Name of the profile
profiles-name = Profiel: { $name }
profiles-is-default = Standaardprofiel
profiles-rootdir = Hoofdmap

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Lokale map
profiles-current-profile = Dit is het profiel dat in gebruik is en kan daarom niet worden verwijderd.
profiles-in-use-profile = Dit profiel is in gebruik in een andere toepassing en kan daarom niet worden verwijderd.

profiles-rename = Hernoemen
profiles-remove = Verwijderen
profiles-set-as-default = Instellen als standaardprofiel
profiles-launch-profile = Profiel starten in nieuwe browser

profiles-cannot-set-as-default-title = Kan standaardprofiel niet instellen
profiles-cannot-set-as-default-message = Het standaardprofiel kan niet worden gewijzigd voor { -brand-short-name }.

profiles-yes = ja
profiles-no = nee

profiles-rename-profile-title = Profiel hernoemen
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Profiel { $name } hernoemen

profiles-invalid-profile-name-title = Ongeldige profielnaam
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = De profielnaam ‘{ $name }’ is niet toegestaan.

profiles-delete-profile-title = Profiel verwijderen
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Het verwijderen van een profiel zal het profiel van de lijst met beschikbare profielen verwijderen en kan niet ongedaan worden gemaakt.
    U kunt er ook voor kiezen om de bestanden met profielgegevens, waaronder uw instellingen, certificaten en andere gebruikersgegevens te verwijderen. Deze optie zal de map ‘{ $dir }’ verwijderen en kan niet ongedaan worden gemaakt.
    Wilt u de bestanden met profielgegevens verwijderen?
profiles-delete-files = Bestanden verwijderen
profiles-dont-delete-files = Bestanden niet verwijderen

profiles-delete-profile-failed-title = Fout
profiles-delete-profile-failed-message = Er is een fout opgetreden tijdens een poging om dit profiel te verwijderen.


profiles-opendir =
    { PLATFORM() ->
        [macos] Tonen in Finder
        [windows] Map openen
       *[other] Map openen
    }
