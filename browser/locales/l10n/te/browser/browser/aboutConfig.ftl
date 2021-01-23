# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = జాగ్రత్తతో ముందుకువెళ్ళండి
about-config-intro-warning-text = ఉన్నత స్వరూపణ అభిరుచులను మార్చడం { -brand-short-name } పనితీరు లేక భద్రతను ప్రభావితం చేయగలదు.
about-config-intro-warning-checkbox = ఈ అభిరుచులను చూడటానికి నేను ప్రయత్నించినపుడు నన్ను హెచ్చరించు
about-config-intro-warning-button = నష్టభయాన్ని అంగీకరించి ముందుకు కొనసాగండి

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = ఈ అభిరుచులను మార్చడం { -brand-short-name } పనితీరు లేక భద్రతను ప్రభావితం చేయగలదు.

about-config-page-title = ఉన్నత అభిరుచులు

about-config-search-input1 =
    .placeholder = శోధన ప్రాధాన్యత పేరు
about-config-show-all = అన్నిటినీ చూపించు

about-config-pref-add-button =
    .title = చేర్చు
about-config-pref-toggle-button =
    .title = అటుదిటుచేయి
about-config-pref-edit-button =
    .title = మార్చు
about-config-pref-save-button =
    .title = భద్రపరుచు
about-config-pref-reset-button =
    .title = పునరుద్ధరించు
about-config-pref-delete-button =
    .title = తొలగించు

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = బూలియన్
about-config-pref-add-type-number = సంఖ్య
about-config-pref-add-type-string = పదబంధం

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (అప్రమేయం)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (అభిమతం)
