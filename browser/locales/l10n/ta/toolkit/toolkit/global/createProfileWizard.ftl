# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = சுயவிவரத்தை உருவாக்கும் வழிகாட்டி
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] அறிமுகம்
       *[other] { create-profile-window.title } க்கு நல்வரவு
    }

profile-creation-explanation-1 = { -brand-short-name } உங்கள் அமைப்புகள் மற்றும் விருப்பங்களை தனி விருப்பங்களில் சேமிக்கும்.

profile-creation-explanation-2 = இந்த { -brand-short-name } இன் நகலை பகிர்ந்து தரவிரும்பினால். ஓவ்வொரு விவர தகவலையும் தனியாக வைத்துக்கொள்ளலாம். இதை செய்ய, பயனர்கள் அவர்களுக்கான தனி விவரக்குறிப்பை உருவாக்க வேண்டும்.

profile-creation-explanation-3 = { -brand-short-name }, ஐ நீங்கள் மட்டுமே பயன்படுத்துவதானால் உங்களிடம் ஒரு விவரக்குறிப்பாவது இருக்க வேண்டும். உங்களுக்கு விருப்பமிருந்தால் பல விவரக்குறிப்புகளை உருவாக்கொள்ளலாம். உதாரணமாக, வியாபாரம் மற்றும் தனிதகவலுக்கென தனித்தனி விவரக்குறிப்பை உருவாக்கிக்கொள்ளலாம்..

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] உங்கள் விவரக்குறிப்பை உருவாக்க, தொடரவும் என்பதை சொடுக்கவும்.
       *[other] உங்கள் விவரக்குறிப்பை உருவாக்க, அடுத்து என்பதை க்ளிக் செய்யவும்.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] முடிவுரை
       *[other] { create-profile-window.title } முடிகிறது
    }

profile-creation-intro = பல விவரக்குறிப்பை உருவாக்கினால் அவைகளுக்கு தனி பெயரை பயன்படுத்தலாம். இங்கே கொடுக்கப்பட்ட பெயர் அல்லது சொந்த பெயரை பயன்படுத்தலாம்.

profile-prompt = புதிய விவரக்குறிப்பு பெயரை உள்ளிடவும்:
    .accesskey = E

profile-default-name =
    .value = இயல்பான பெயர்

profile-directory-explanation = உங்கள் பயனர் அமைவுகள், முன்னுரிமைகள் மற்றும் வேறு பயனர் தொடர்புடைய தரவு இங்கு சேமிக்கப்படும்:

create-profile-choose-folder =
    .label = அடைவை தேர்வு செய்யவும்...
    .accesskey = C

create-profile-use-default =
    .label = இயல்பான அடைவை பயன்படுத்து
    .accesskey = U
