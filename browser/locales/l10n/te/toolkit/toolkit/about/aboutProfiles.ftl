# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = ప్రొఫైళ్ళ గురించి
profiles-subtitle = ఈ పేజీ మీరు మీ ప్రొఫైల్స్ నిర్వహించడానికి సహాయపడుతుంది. ప్రతి పేజీ ప్రత్యేక చరిత్ర, బుక్మార్క్లు, సెట్టింగ్లు మరియు ఆడ్-ఆన్ లు కలిగిన ఒక ప్రత్యేక పదం.
profiles-create = కొత్త ప్రొఫైలును సృష్టించు
profiles-restart-title = పునఃప్రారంభించు
profiles-restart-in-safe-mode = పొడిగింతలు ఆపివేసి పునఃప్రారంభించు…
profiles-restart-normal = సాధారణంగా పునఃప్రారంభించు...
profiles-flush-conflict = { profiles-conflict }

# Variables:
#   $name (String) - Name of the profile
profiles-name = ప్రొఫైలు: { $name }
profiles-is-default = అప్రమేయ ప్రొఫైలు
profiles-rootdir = మూల సంచయం

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = స్థానిక సంచయం
profiles-current-profile = ఈ ప్రొఫైలు వాడుకలో ఉంది, దీన్ని తొలగించలేరు.
profiles-in-use-profile = ఈ ప్రొఫైలు మరో అనువర్తనంలో వాడుకలో ఉంది, దీన్ని తొలగించలేరు.

profiles-rename = పేరుమార్చు
profiles-remove = తీసివేయి
profiles-set-as-default = అప్రమేయ ప్రొఫైలుగా అమర్చు
profiles-launch-profile = ప్రొఫైలుని కొత్త విహారిణిలో తెరువు

profiles-yes = అవును
profiles-no = కాదు

profiles-rename-profile-title = ప్రొఫైలు పేరుమార్చు
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = ప్రొఫైలును పునఃనామకరణ చేయుము { $name }

profiles-invalid-profile-name-title = చెల్లని ప్రొఫైలు పేరు
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = "{ $name }" అనే ప్రొఫైలు పేరు అనుమతించబడదు.

profiles-delete-profile-title = ప్రొఫైలును తొలగించు
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    ఒక ప్రొఫైల్‌ను తొలగించితే అది అందుబాటులోవున్న ప్రొఫైల్ జాబితా నుండి తొలగించబడుతుంది మరియు తిరిగివుంచలేము.
    మీరు మీ ప్రొఫైల్ డాటా ఫైళ్ళు, అమరికలు, దృవీకరణపత్రములు మరియు ఇతర వాడుకిరి-సంభందిత డాటా తొలగించుటకుకూడా ఎంచుకొనవచ్చు. ఈ ఎంపిక సంచయం "{ $dir }"ను తొలగిస్తుంది మరియు తిరిగివుంచలేము.
    మీరు ప్రొఫైల్ డాటాఫైళ్ళను తొలగించుదామని అనుకుంటున్నారా?
profiles-delete-files = ఫైళ్ళను తొలగించు
profiles-dont-delete-files = ఫైళ్ళను తొలగించవద్దు

profiles-delete-profile-failed-title = దోషం


profiles-opendir =
    { PLATFORM() ->
        [macos] ఫైండర్ నందు చూపు
        [windows] సంచికను తెరువు
       *[other] నిఘంటువు తెరువు
    }
