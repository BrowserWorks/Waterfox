# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Waterfox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = नया टैब
newtab-settings-button =
    .title = अपने नए टैब पृष्ठ को अनुकूलित करें

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = खोजें
    .aria-label = खोजें

newtab-search-box-search-the-web-text = वेब पर खोजें
newtab-search-box-search-the-web-input =
    .placeholder = वेब पर खोजें
    .title = वेब पर खोजें
    .aria-label = वेब पर खोजें

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = खोज ईंजन जोड़ें
newtab-topsites-add-topsites-header = नई शीर्ष साइट
newtab-topsites-edit-topsites-header = शीर्ष साइट संपादित करें
newtab-topsites-title-label = शीर्षक
newtab-topsites-title-input =
    .placeholder = एक शीर्षक दर्ज करें

newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = एक URL टाइप करें अथवा पेस्ट करें
newtab-topsites-url-validation = मान्य URL आवश्यक

newtab-topsites-image-url-label = कस्टम छवि URL
newtab-topsites-use-image-link = कस्टम छवि का उपयोग करें…
newtab-topsites-image-validation = छवि लोड करने में विफल । किसी भिंन URL का प्रयास करें ।

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = रद्द करें
newtab-topsites-delete-history-button = इतिहास से मिटाएँ
newtab-topsites-save-button = सहेजें
newtab-topsites-preview-button = पूर्वावलोकन
newtab-topsites-add-button = जोड़ें

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = क्या वाकई आप इस पृष्ठ का हर उदाहरण के अपने इतिहास से हटाना चाहते हैं?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = इस क्रिया को पहले जैसा नहीं किया जा सकता है.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = मेन्यू खोलें
    .aria-label = मेन्यू खोलें

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = हटाएं
    .aria-label = हटाएं

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = मेन्यू खोलें
    .aria-label = { $title } के लिए कॉन्टेक्स्ट मेनू खोलें
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = इस साइट को संपादित करें
    .aria-label = इस साइट को संपादित करें

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = संपादित करें
newtab-menu-open-new-window = एक नई विंडो में खोलें
newtab-menu-open-new-private-window = एक नई निजी विंडो में खोलें
newtab-menu-dismiss = निरस्त करें
newtab-menu-pin = पिन करें
newtab-menu-unpin = पिन हटाएँ
newtab-menu-delete-history = इतिहास से मिटाएँ
newtab-menu-save-to-pocket = { -pocket-brand-name } में सहेजें
newtab-menu-delete-pocket = { -pocket-brand-name } से हटाएं
newtab-menu-archive-pocket = { -pocket-brand-name } में संग्रहित करें
newtab-menu-show-privacy-info = हमारे प्रायोजक और आपकी गोपनीयता

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = संपन्न
newtab-privacy-modal-header = आपकी गोपनीयता मायने रखती है।
newtab-privacy-modal-link = जानिए नए टैब पर गोपनीयता कैसे काम करती है

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = बुकमार्क हटाएँ
# Bookmark is a verb here.
newtab-menu-bookmark = बुकमार्क

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = डाउनलोड लिंक कॉपी करें
newtab-menu-go-to-download-page = डाउनलोड पृष्ठ पर जाएं
newtab-menu-remove-download = इतिहास से हटाएँ

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] फाइंडर में दिखाएँ
       *[other] संग्राहक फोल्डर खोलें
    }
newtab-menu-open-file = फ़ाइल खोलें

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = देखी गई
newtab-label-bookmarked = बुकमार्क लगाया हुआ
newtab-label-removed-bookmark = बुकमार्क हटाया गया
newtab-label-recommended = लोकप्रिय
newtab-label-saved = { -pocket-brand-name } में सहेजा
newtab-label-download = डाउनलोड की गई

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } . द्वारा प्रायोजित

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = { $sponsor } द्वारा प्रायोजित

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = अनुभाग निकालें
newtab-section-menu-collapse-section = अनुभाग संक्षिप्त करें
newtab-section-menu-expand-section = अनुभाग विस्तृत करें
newtab-section-menu-manage-section = अनुभाग प्रबंधित करें
newtab-section-menu-manage-webext = विस्तारक प्रबंधित करें
newtab-section-menu-add-topsite = शीर्ष साइट जोड़ें
newtab-section-menu-add-search-engine = खोज ईंजन जोड़ें
newtab-section-menu-move-up = ऊपर जाएँ
newtab-section-menu-move-down = नीचे जाएँ
newtab-section-menu-privacy-notice = गोपनीयता नीति

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = अनुभाग संक्षिप्त करें
newtab-section-expand-section-label =
    .aria-label = अनुभाग विस्तृत करें

## Section Headers.

newtab-section-header-topsites = सर्वोच्च साइटें
newtab-section-header-highlights = प्रमुखताएँ
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = { $provider } द्वारा अनुशंसित

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = ब्राउज़िंग प्रारंभ करें, और हम कुछ प्रमुख आलेख, विडियो, तथा अन्य पृष्ठों को प्रदर्शित करेंगे जिन्हें आपने हाल ही में देखा या पुस्तचिन्हित किया है.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = आप अंत तक आ गए हैं. { $provider } से और शीर्ष घटनाओं के लिए कुछ समय में पुनः आइए. इंतज़ार नहीं कर सकते? वेब से और प्रमुख घटनाएं ढूंढने के लिए एक लोकप्रिय विषय चुनें.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = आपने सब पढ़ लिया!
newtab-discovery-empty-section-topstories-content = और कहानियों के लिए कुछ बाद में वापस देखें।
newtab-discovery-empty-section-topstories-try-again-button = पुनः प्रयास करें
newtab-discovery-empty-section-topstories-loading = लोड हो रहा है...

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = लोकप्रिय विषय:
newtab-pocket-more-recommendations = अधिक अनुशंसाएँ
newtab-pocket-learn-more = अधिक जानें
newtab-pocket-cta-button = { -pocket-brand-name } प्राप्त करें
newtab-pocket-cta-text = अपने पसंदीद कहानियाँ { -pocket-brand-name } में सहेजें, और आकर्षक पढ़ाई के साथ अपने दिमाग को शक्ति दें।

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = उफ़, कुछ गलत इस सामग्री लोड हो गया ।
newtab-error-fallback-refresh-link = पुन: प्रयास करने के लिए पृष्ठ ताज़ा करें ।
