# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = गोप्यशब्द गुणस्तर मापक

## Change Password dialog

change-password-window =
    .title = मुल गोप्यशब्द परिवर्तन गर्नुहोस्

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = सुरक्षा यन्त्र: { $tokenName }
change-password-old = हालको गोप्यशब्द:
change-password-new = नयाँ गोप्यशब्द:
change-password-reenter = नयाँ गोप्यशब्द(पुनः):

## Reset Password dialog

reset-password-window =
    .title = मुल गोप्यशब्द रिसेट गर्नुहोस्
    .style = width: 40em

## Reset Primary Password dialog

reset-password-button-label =
    .label = रिसेट गर्नुहोस्
reset-password-text = तपाईँले मास्टर प्रवेशचिन्ह रिसेट गर्नुभयो भने, तपाईँका सबै भण्डारण गरिएका वेब र इमेल प्रवेशचिन्हहरू, फाराम लगत, निजी प्रमाणपत्रहरू, र निजी कुञ्जीहरूलाई बिर्सिनेछ। के तपाईँ मास्टर प्रवेशचिन्ह रिसेट गर्ने कुरामा दृढ हुनुहुन्छ?

## Downloading cert dialog

download-cert-window =
    .title = प्रमाणपत्र डाउनलोड गरिँदै
    .style = width: 46em
download-cert-message = तपाईँलाई एउटा नयाँ प्रमाणपत्र अधिकारी (CA) लाई विश्वास गर्न भनिएको छ।
download-cert-trust-ssl =
    .label = Trust this CA to identify web sites.
download-cert-trust-email =
    .label = इमेल प्रयोगकर्ताहरू पहिचान गर्न यो CAलाई विश्वास गर्नुहोस्।
download-cert-message-desc = कुनै पनि उद्धेश्यका लागि यो CA विश्वास गर्नु अगाडि, तपाईँले यसको प्रमाणपत्र र यसको नीति र कार्यविधि(यदि उपलब्ध भएमा) जाँच गर्नुपर्दछ ।
download-cert-view-cert =
    .label = दृश्य
download-cert-view-text = CA प्रमाणपत्र जाँच गर्नुहोस्

## Client Authorization Ask dialog

client-auth-window =
    .title = प्रयोगकर्ता पहिचान अनुरोध
client-auth-site-description = यो साइटले तपाईलाई आफूलाई एउटा प्रमाणपत्र सहित पहिचान गर्न आग्रह गरेको छ।
client-auth-choose-cert = पहिचानका रूपमा प्रस्तुत गर्न एउटा प्रमाणपत्र छनोट गर्नुहोस्:
client-auth-cert-details = चयन भएको प्रमाणपत्र को विवरण:

## Set password (p12) dialog

set-password-window =
    .title = एउटा प्रमाणपत्र जगेडा गोप्यशब्द छनोट गर्नुहोस्
set-password-message = तपाईँले यहाँ सेट गर्नुभएको प्रमाणपत्र जगेडा गोप्यशब्दले तपाईँले सिर्जना गर्न लाग्नुभएको जगेडा फाइललाई सुरक्षित राख्छ। तपाईँले जगेडा सहित अघि बढ्न यो गोप्यशब्द सेट गर्नुपर्ने हुन्छ।
set-password-backup-pw =
    .value = प्रमाणपत्र जगेडा गोप्यशब्द:
set-password-repeat-backup-pw =
    .value = प्रमाणपत्र जगेडा गोप्यशब्द(पुनः):
set-password-reminder = महत्वपूर्ण: तपाईँले आफ्नो प्रमाणपत्रको जगेडा गोप्यशब्द बिर्सनुभयो भने, तपाईँले यो जगेडालाई पछि पुनः भण्डारण गर्न सक्नुहुन्न। कृपया यसलाई सुरक्षित स्थानमा रेकर्ड गर्नुहोस्।

## Protected Auth dialog

protected-auth-window =
    .title = सुरक्षित टोकन प्रमाणीकरण
protected-auth-msg = कृपया टोकनको लागि प्रमाणित गर्नुहोस् । प्रमाणीकरण विधि तपाईँको टोकनको प्रकारमा निर्भर गर्दछ।
protected-auth-token = टोकन:
