# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = சுயவிவரங்கள் பற்றிய
profiles-subtitle = இப்பக்கம் உங்கள் விவரங்களை நிர்வகிக்க உதவுகிறது. ஒவ்வொரு விவரமும் வரலாறு, புத்தகக்குறிகள், அமைவுகள் மற்றும்துணை நிரல்கள் கொண்ட தனி உலகம்.
profiles-create = புதிய சுயவிவரத்தை உருவாக்கு
profiles-restart-title = மறுதுவக்கு
profiles-restart-in-safe-mode = துணை நிரல்கள் முடக்கத்துடன் மறுதுவக்கு…
profiles-restart-normal = இயல்பாக மறுதுவக்கு...

# Variables:
#   $name (String) - Name of the profile
profiles-name = சுயவிவரம்: { $name }
profiles-is-default = முன்னிருப்பு விவரம்
profiles-rootdir = மூல அடைவு

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = உள்ளூர் அடைவு
profiles-current-profile = இவ்விவரம் பயனில் உள்ளதால் அழிக்க முடியாது.

profiles-rename = மறுபெயரிடு
profiles-remove = நீக்கு
profiles-set-as-default = முன்னிருப்பு விவரமாக அமை
profiles-launch-profile = புதிய உலாவியில் விவரத்தை துவக்கு

profiles-yes = ஆம்
profiles-no = இல்லை

profiles-rename-profile-title = விவரக்குறிப்பை மறுபெயரிடு
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = { $name } விவரக்குறிப்பை மறுபெயரிடு

profiles-invalid-profile-name-title = செல்லாத விவரக்குறிப்பு பெயர்
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = "{ $name }" என்ற விவரக்குறிப்புக்கு அனுமதி இல்லை.

profiles-delete-profile-title = விவரக்குறிப்பை அழி
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    ஏற்கனவே உள்ள விவரக்குறிப்பு பட்டியலிலிருந்து ஒரு விவரக்குறிப்பை அழிப்பது அதனை நீக்கும் எனவே மீட்கபடாது.
    உங்கள் விவரக்குறிப்பு பிற கோப்புகளை, உங்கள் அமைவுகள், சான்றிதழ்கள் மற்றும் வேறு பயனர் தொடர்பான தரவு ஆகியவற்றையும் அழிக்க தேர்ந்தெடுக்கலாம். இவ்விருப்பம் "{ $dir } அடைவை அழித்ம மீண்டும் செய்யப்படாது.
    விவரக்குறிப்பு தரவு கோப்புகளை அழிக்கவா?
profiles-delete-files = கோப்புகளை அழி
profiles-dont-delete-files = கோப்புகளை அழிக்காதே


profiles-opendir =
    { PLATFORM() ->
        [macos] தேடியில் காட்டு
        [windows] அடைவினைத் திற
       *[other] கோப்பகத்தைத் திற
    }
