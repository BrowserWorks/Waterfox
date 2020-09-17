# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Firefox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = ახალი ჩანართი
newtab-settings-button =
    .title = მოირგეთ ახალი ჩანართის გვერდი

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = ძიება
    .aria-label = ძიება

newtab-search-box-search-the-web-text = ინტერნეტში ძიება
newtab-search-box-search-the-web-input =
    .placeholder = ინტერნეტში ძიება
    .title = ინტერნეტში ძიება
    .aria-label = ინტერნეტში ძიება

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = საძიებო სისტემის დამატება
newtab-topsites-add-topsites-header = ახალი საიტი რჩეულებში
newtab-topsites-edit-topsites-header = რჩეული საიტის ჩასწორება
newtab-topsites-title-label = დასახელება
newtab-topsites-title-input =
    .placeholder = სათაურის შეყვანა

newtab-topsites-url-label = URL-ბმული
newtab-topsites-url-input =
    .placeholder = აკრიფეთ ან ჩასვით URL-ბმული
newtab-topsites-url-validation = საჭიროა მართებული URL

newtab-topsites-image-url-label = სასურველი სურათის URL-ბმული
newtab-topsites-use-image-link = სასურველი სურათის გამოყენება…
newtab-topsites-image-validation = სურათი ვერ ჩაიტვირთა. სცადეთ სხვა URL-ბმული.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = გაუქმება
newtab-topsites-delete-history-button = ისტორიიდან ამოშლა
newtab-topsites-save-button = შენახვა
newtab-topsites-preview-button = შეთვალიერება
newtab-topsites-add-button = დამატება

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = ნამდვილად გსურთ, ამ გვერდის ყველა ჩანაწერის ისტორიიდან ამოშლა?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = ეს ქმედება შეუქცევადია.

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = მენიუს გახსნა
    .aria-label = მენიუს გახსნა

# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = მოცილება
    .aria-label = მოცილება

# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = მენიუს გახსნა
    .aria-label = კონტექსტური მენიუს გახსნა { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = საიტის ჩასწორება
    .aria-label = საიტის ჩასწორება

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = ჩასწორება
newtab-menu-open-new-window = ახალ ფანჯარაში გახსნა
newtab-menu-open-new-private-window = ახალ პირად ფანჯარაში გახსნა
newtab-menu-dismiss = დამალვა
newtab-menu-pin = მიმაგრება
newtab-menu-unpin = მოხსნა
newtab-menu-delete-history = ისტორიიდან ამოშლა
newtab-menu-save-to-pocket = { -pocket-brand-name }-ში შენახვა
newtab-menu-delete-pocket = წაშლა { -pocket-brand-name }-იდან
newtab-menu-archive-pocket = დაარქივება { -pocket-brand-name }-ში
newtab-menu-show-privacy-info = ჩვენი დამფინანსებლები და თქვენი პირადულობა

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = მზადაა
newtab-privacy-modal-button-manage = შეკვეთილი მასალის პარამეტრების მართვა
newtab-privacy-modal-header = თქვენი პირადულობა უმნიშვნელოვანესია.
newtab-privacy-modal-paragraph-2 =
    გარდა საინტერესო ამბებისა, ჩვენ ასევე გიჩვენებთ მნიშვნელოვან, ღირებულ
    მასალას შერჩეული მხარდამჭერებისგან. შეგიძლიათ მშვიდად იყოთ, თქვენ მიერ ნანახ
    მონაცემებს, მხოლოდ ინახავს თქვენი კუთვნილი { -brand-product-name }</strong>  — ვერც ჩვენ და ვერც
    ჩვენი მხარდამჭერი კომპანიები ვერ იხილავს მათ.
newtab-privacy-modal-link = იხილეთ, როგორ მუშაობს პირადი მონაცემების უსაფრთხოება ახალ ჩანართზე

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = სანიშნებიდან ამოშლა
# Bookmark is a verb here.
newtab-menu-bookmark = ჩანიშვნა

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = ჩამოტვირთვის ბმულის ასლი
newtab-menu-go-to-download-page = გადასვლა ჩამოტვირთვის გვერდზე
newtab-menu-remove-download = ისტორიიდან ამოშლა

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] ჩვენება Finder-ში
       *[other] შემცველი საქაღალდის გახსნა
    }
newtab-menu-open-file = ფაილის გახსნა

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = მონახულებული
newtab-label-bookmarked = ჩანიშნული
newtab-label-removed-bookmark = სანიშნი მოცილებულია
newtab-label-recommended = ფართოდ გავრცელებული
newtab-label-saved = შენახულია { -pocket-brand-name }-ში
newtab-label-download = ჩამოტვირთული

# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · დაკვეთილი

# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = დამკვეთია { $sponsor }

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = ამ ნაწილის მოცილება
newtab-section-menu-collapse-section = ამ ნაწილის აკეცვა
newtab-section-menu-expand-section = ამ ნაწილის გაშლა
newtab-section-menu-manage-section = გვერდის ნაწილების მართვა
newtab-section-menu-manage-webext = გაფართოების მართვა
newtab-section-menu-add-topsite = რჩეული საიტის დამატება
newtab-section-menu-add-search-engine = საძიებო სისტემის დამატება
newtab-section-menu-move-up = აწევა
newtab-section-menu-move-down = ჩამოწევა
newtab-section-menu-privacy-notice = პირადი მონაცემების დაცვის განაცხადი

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = ამ ნაწილის აკეცვა
newtab-section-expand-section-label =
    .aria-label = ამ ნაწილის გაშლა

## Section Headers.

newtab-section-header-topsites = რჩეული საიტები
newtab-section-header-highlights = მნიშვნელოვანი
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = { $provider } გირჩევთ

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = დაიწყეთ გვერდების დათვალიერება და აქ გამოჩნდება თქვენთვის სასურველი სტატიები, ვიდეოები და ბოლოს მონახულებული ან ჩანიშნული საიტები.

# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = უკვე ყველაფერს გაეცანით. მოგვიანებით შემოიარეთ მეტი რჩეული სტატიის სანახავად, რომელსაც { $provider } მოგაწვდით. ვერ ითმენთ? აირჩიეთ რომელიმე ფართოდ გავრცელებული საკითხი, ახალი საინტერესო სტატიების მოსაძიებლად.


## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = ყველაფერი წაკითხულია!
newtab-discovery-empty-section-topstories-content = ახალი ამბების სანახავად, შეამოწმეთ მოგვიანებით.
newtab-discovery-empty-section-topstories-try-again-button = ხელახლა ცდა
newtab-discovery-empty-section-topstories-loading = იტვირთება...
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = ჰმ! თითქმის ჩაიტვირთა, მაგრამ სრულად არა.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = მეტად გავრცელებული საკითხები:
newtab-pocket-more-recommendations = მეტი შემოთავაზებები
newtab-pocket-learn-more = იხილეთ ვრცლად
newtab-pocket-cta-button = გამოიყენეთ { -pocket-brand-name }
newtab-pocket-cta-text = გადაინახეთ სასურველი შიგთავსი { -pocket-brand-name }-ში და მიეცით გონებას საკვები, შთამბეჭდავი საკითხავი მასალის სახით.

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = სამწუხაროდ, შიგთავსის ჩატვირთვისას რაღაც ხარვეზი წარმოიქმნა.
newtab-error-fallback-refresh-link = განაახლეთ გვერდი და სცადეთ ხელახლა.
