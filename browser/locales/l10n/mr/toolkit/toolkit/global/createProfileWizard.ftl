# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = सहाय्यक निवडसंच कार्यक्रम तयार करा
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] प्रस्तावना
       *[other] { create-profile-window.title } वर आपले स्वागत आहे
    }

profile-creation-explanation-1 = आपल्या खाजगी निवडसंचात { -brand-short-name } मांडणी आणि प्राधान्यक्रम माहिती साठवून ठेवतो.

profile-creation-explanation-2 = जर आपण { -brand-short-name } च्या ह्या प्रतीचा वापर दुसऱ्या उपयोगकर्त्यांशी करत असाल तर प्रत्येक उपयोगकर्त्याची माहिती वेगवेगळी ठेवण्याकरीता आपण निवडसंचाचा वापर करू शकता. हे करण्याकरीता, प्रत्येक उपयोगकर्त्याने स्वतःचा निवडसंच तयार करावा.

profile-creation-explanation-3 = जर आपण { -brand-short-name } च्या ह्या प्रतीचा वापर करणारी एकमेव व्यक्ती असाल तर आपल्याकडे कमीतकमी एकतरी निवडसंच असलाच पाहीजे. आपणाला वाटत असल्यास, आपण एकापेक्षा जास्त निवडसंच वेगवेगळ्या संचाची मांडणी आणि प्राधान्यक्रम साठविण्याकरीता तयार करू शकता. उदाहरणार्थ, व्यवसाय आणि खाजगी उपयोगाकरीता वेगवेगळा निवडसंच आपण ठेवू शकता.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] आपले संक्षिप्त चरित्र निर्माण करण्याकरीता, पुढे चलावर क्लिक करा.
       *[other] आपल्या निवडसंचाच्या तयारीची सुरूवात करण्याकरीता, पुढे चला वर क्लिक करा.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] निष्कर्ष
       *[other] { create-profile-window.title } पूर्ण करत आहे
    }

profile-creation-intro = जर आपण अनेक निवडसंच तयार केले असाल तर आपण निवडसंचाच्या नावा व्यतीरीक्त त्यांना सांगू शकता. आपण पुरविलेल्या नावाचा उपयोग किंवा स्वतः निवडलेल्या नावाचा उपयोग करू शकता.

profile-prompt = नवीन प्रोफाइल नावाची नोंदणी करा:
    .accesskey = E

profile-default-name =
    .value = मूलभूत उपयोकर्ता

profile-directory-explanation = आपले वापरकर्ता संयोजना, प्राधान्यक्रम व अन्य-संबंधित येथे संचयीत केले जाईल:

create-profile-choose-folder =
    .label = फोल्डरची निवडा...
    .accesskey = C

create-profile-use-default =
    .label = पूर्वनिर्धारित फोल्डरचा वापर करा
    .accesskey = U
