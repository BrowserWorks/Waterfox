# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Waterfox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = కొత్త ట్యాబు
newtab-settings-button =
    .title = మీ కొత్త ట్యాబు పేజీని మలచుకోండి

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = వెతకండి
    .aria-label = వెతకండి

newtab-search-box-search-the-web-text = జాలంలో వెతకండి
newtab-search-box-search-the-web-input =
    .placeholder = జాలంలో వెతకండి
    .title = జాలంలో వెతకండి
    .aria-label = జాలంలో వెతకండి

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = శోధన యంత్రాన్ని జోడించండి
newtab-topsites-add-topsites-header = కొత్త మేటి సైటు
newtab-topsites-edit-topsites-header = టాప్ సైట్ను సవరించండి
newtab-topsites-title-label = శీర్షిక
newtab-topsites-title-input =
    .placeholder = శీర్షికను నమోదు చేయండి

newtab-topsites-url-label = చిరునామా
newtab-topsites-url-input =
    .placeholder = URL ను టైప్ చేయండి లేదా అతికించండి
newtab-topsites-url-validation = చెల్లుబాటు అయ్యే URL అవసరం

newtab-topsites-image-url-label = అభిమత చిత్రపు చిరునామా
newtab-topsites-use-image-link = అభిమత చిత్రాన్ని వాడు…
newtab-topsites-image-validation = చిత్రాన్ని లోడు చెయ్యలేకపోయాం. మరో చిరునామా ప్రయత్నించండి.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = రద్దుచేయి
newtab-topsites-delete-history-button = చరిత్ర నుంచి తీసివేయి
newtab-topsites-save-button = భద్రపరచు
newtab-topsites-preview-button = మునుజూపు
newtab-topsites-add-button = చేర్చు

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = మీరు మీ చరిత్ర నుండి ఈ పేజీ యొక్క ప్రతి ఉదాహరణకు తొలగించాలనుకుంటున్నారా?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = ఈ చర్యను రద్దు చేయలేము.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = మెనూని తెరువు
    .aria-label = మెనూని తెరువు

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = తీసివేయి
    .aria-label = తీసివేయి

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = మెనూని తెరువు
    .aria-label = { $title } కోసం సందర్భోచిత మెనూని తెరవు
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = ఈ సైటును మార్చు
    .aria-label = ఈ సైటును మార్చు

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = మార్చు
newtab-menu-open-new-window = కొత్త విండోలో తెరువు
newtab-menu-open-new-private-window = కొత్త వ్యక్తిగత విండోలో తెరువు
newtab-menu-dismiss = విస్మరించు
newtab-menu-pin = పిన్ను
newtab-menu-unpin = పిన్ను తీసివేయి
newtab-menu-delete-history = చరిత్ర నుంచి తీసివేయి
newtab-menu-save-to-pocket = { -pocket-brand-name } కి సేవ్ చేయండి
newtab-menu-delete-pocket = { -pocket-brand-name } నుండి తొలగించు
newtab-menu-archive-pocket = { -pocket-brand-name }లో ఆర్కయివ్ చెయ్యి
newtab-menu-show-privacy-info = మా స్పాన్సర్లు & మీ అంతరంగికత

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = పూర్తయింది
newtab-privacy-modal-button-manage = ప్రాయోజిత విషయపు అమరికలను నిర్వహించండి
newtab-privacy-modal-header = మీ అంతరంగికత ముఖ్యమైనది.
newtab-privacy-modal-link = కొత్త ట్యాబులో అంతరంగికత ఎలా పనిచేస్తుందో తెలుసుకోండి

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = ఇష్టాంశాన్ని తొలగించు
# Bookmark is a verb here.
newtab-menu-bookmark = ఇష్టాంశం

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = దింపుకోలు లంకెను కాపీచేయి
newtab-menu-go-to-download-page = దింపుకోళ్ళ పేజీకి వెళ్ళు
newtab-menu-remove-download = చరిత్ర నుండి తొలగించు

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] ఫైండర్‌లో చూపించు
       *[other] కలిగిఉన్న సంచయాన్ని తెరువు
    }
newtab-menu-open-file = దస్త్రాన్ని తెరువు

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = సందర్శించారు
newtab-label-bookmarked = ఇష్టాంశంగా గుర్తుపెట్టారు
newtab-label-removed-bookmark = ఇష్టాంశం తొలగించబడింది
newtab-label-recommended = ట్రెండింగ్
newtab-label-saved = { -pocket-brand-name }లో భద్రపరచినది
newtab-label-download = దింపుకున్నవి

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · ప్రాయోజితం

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = { $sponsor }చే ప్రాయోజితం

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = విభాగాన్ని తీసివేయి
newtab-section-menu-collapse-section = విభాగాన్ని ముడిచివేయి
newtab-section-menu-expand-section = విభాగాన్ని విస్తరించు
newtab-section-menu-manage-section = విభాగ నిర్వహణ
newtab-section-menu-manage-webext = పొడగింత నిర్వహణ
newtab-section-menu-add-topsite = మేటి సైటును చేర్చు
newtab-section-menu-add-search-engine = శోధన యంత్రాన్ని జోడించండి
newtab-section-menu-move-up = పైకి జరుపు
newtab-section-menu-move-down = కిందకి జరుపు
newtab-section-menu-privacy-notice = అంతరంగికత గమనిక

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = విభాగాన్ని కుదించు
newtab-section-expand-section-label =
    .aria-label = విభాగాన్ని విస్తరించు

## Section Headers.

newtab-section-header-topsites = మేటి సైట్లు
newtab-section-header-highlights = విశేషాలు
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = { $provider }చే సిఫార్సు చేయబడినది

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = విహారించడం మొదలుపెట్టండి, మీరు ఈమధ్య చూసిన లేదా ఇష్టపడిన గొప్ప వ్యాసాలను, వీడియోలను, ఇతర పేజీలను ఇక్కడ చూపిస్తాం.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = మీరు పట్టుబడ్డారు. { $provider } నుండి మరింత అగ్ర కథనాల కోసం తరువాత తనిఖీ చేయండి. వేచి ఉండలేరా? జాలములోని అంతటి నుండి మరింత గొప్ప కథనాలను కనుగొనడానికి ప్రసిద్ధ అంశం ఎంచుకోండి.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = మీరు అన్నీ చూసేసారు!
newtab-discovery-empty-section-topstories-content = మరిన్న కథనాల కోసం కాసేపటి తర్వాత చూడండి.
newtab-discovery-empty-section-topstories-try-again-button = మళ్ళీ ప్రయత్నించు
newtab-discovery-empty-section-topstories-loading = వస్తోంది…

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = ప్రముఖ అంశాలు:
newtab-pocket-more-recommendations = మరిన్ని సిఫారసులు
newtab-pocket-learn-more = ఇంకా తెలుసుకోండి
newtab-pocket-cta-button = { -pocket-brand-name } పొందండి

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = అయ్యో, ఈ విషయం తేవడంలో ఏదో తప్పు దొర్లింది.
newtab-error-fallback-refresh-link = మళ్ళీ ప్రయత్నించడానికి పేజీని రీఫ్రెష్ చెయ్యండి.
