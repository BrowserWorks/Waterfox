# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = ಹೊಸ ಪ್ರೊಫೈಲ್‌ ಗಾರುಡಿ
    .style = width: 45em; height: 34em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] ಪರಿಚಯ
       *[other] { create-profile-window.title } ಗೆ ಸ್ವಾಗತ
    }

profile-creation-explanation-1 = { -brand-short-name } ನಿಮ್ಮ  ವೈಯಕ್ತಿಕ ಸಿದ್ಧತೆಗಳ ಹಾಗು ಆದ್ಯತೆಗಳ ಬಗೆಗಿನ ಮಾಹಿತಿಯನ್ನು ಒಂದು ಖಾಸಗಿ ಪ್ರೊಫೈಲ್‌ನಲ್ಲಿ ಇರಿಸುತ್ತದೆ.

profile-creation-explanation-2 = ಈ  { -brand-short-name } ನೀವೊಬ್ಬರಲ್ಲದೆ ಇತರರೂ ಬಳಸುವಂತಿದ್ದರೆ, ಎಲ್ಲರ ಮಾಹಿತಿಯನ್ನು ಬೇರೆಯಾಗಿ ಇಡಲು ಪ್ರೊಫೈಲುಗಳನ್ನು ಬಳಸಬಹುದು.ಹೀಗೆ ಮಾಡಲು, ಒಬ್ಬೊಬ್ಬರೂ ತಮ್ಮದೇ ಆದ ಪ್ರೊಫೈಲ್ ಸೇರಿಸಬೇಕು.

profile-creation-explanation-3 = ಒಂದುವೇಳೆ, ಈ { -brand-short-name } ನೀವೊಬ್ಬರೆ ಬಳಸುವುದಾದರೆ, ನಿಮ್ಮಲ್ಲಿ ಕಡೇಪಕ್ಷ ಒಂದು ಪ್ರೊಫೈಲ್ ಇರಬೇಕು. ನೀವು ಇಚ್ಚಿಸಿದಲ್ಲಿ, ಸಿದ್ಧತೆ ಹಾಗಿ ಆದ್ಯತೆಗಳನ್ನು ಉಳಿಸಲು ಒಂದಲ್ಲದೆ ಹೆಚ್ಚಿನ ಸೆಟ್ಟುಗಳನ್ನೂ ಸೇರಿಸಬಹುದು. ಉದಾ, ಸ್ವಂತಕ್ಕೊಂದು ಪ್ರೊಫೈಲ್, ವ್ಯವಹಾರಕ್ಕೆ ಬೇರೆಯ ಮತ್ತೊಂದು ಪ್ರೊಫೈಲ್ ಹೀಗೆ.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] ಹೊಸ ಪ್ರೊಫೈಲ್‌ ಒಂದನ್ನು ಸೇರಿಸುವುದನ್ನು ಆರಂಭಿಸಲು , 'ಮುಂದುವರೆ' ಅನ್ನು ಕ್ಲಿಕ್ಕಿಸಿ.
       *[other] ಹೊಸ ಪ್ರೊಫೈಲ್ ಒಂದನ್ನು ಸೇರಿಸಲು , 'ಮುಂದಕ್ಕೆ' ಅನ್ನು ಕ್ಲಿಕ್ಕಿಸಿ.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] ಮುಕ್ತಾಯ
       *[other] { create-profile-window.title } ಅನ್ನು ಪೂರ್ಣಗೊಳಿಸಲಾಗುತ್ತಿದೆ
    }

profile-creation-intro = ನೀವು ಅನೇಕ ಪ್ರೊಫೈಲ್‌ ಅನ್ನು ರಚಿಸಿದಲ್ಲಿ ಅವುಗಳ ಹೆಸರುಗಳ ಮೂಲಕ ಪ್ರತ್ಯೇಕವಾಗಿ ಉಲ್ಲೇಖಿಸಬಹುದು. ಇಲ್ಲಿ ಒದಗಿಸಲಾದ ಹೆಸರನ್ನು ಬಳಸಬಹುದು ಅಥವ ನಿಮ್ಮ ಸ್ವಂತದ್ದೇ ಆದಂತಹ ಹೆಸರನ್ನು ಬಳಸಬಹುದು.

profile-prompt = ಹೊಸ ಪ್ರೊಫೈಲ್‌ನ ಹೆಸರನ್ನು ನಮೂದಿಸಿ:
    .accesskey = E

profile-default-name =
    .value = ಡೀಫಾಲ್ಟ್‍ ಬಳಕೆದಾರ

profile-directory-explanation = ನಿಮ್ಮ ವೈಯಕ್ತಿಕ ಸಿದ್ಧತೆಗಳು, ಆದ್ಯತೆಗಳು ಹಾಗು ಇತರೆ ಬಳಕೆದಾರ-ಸಂಬಂಧಿತ ಮಾಹಿತಿಯು ಇಲ್ಲಿ ಶೇಖರಿಸಲ್ಪಡುತ್ತದೆ:

create-profile-choose-folder =
    .label = ಕೋಶವನ್ನು ಮುಚ್ಚು...
    .accesskey = C

create-profile-use-default =
    .label = ಡೀಫಾಲ್ಟ್‍  ಕೋಶವನ್ನು ಬಳಸು
    .accesskey = U
