# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = ඇඩෝන කළමනාකරු

addons-page-title = ඇඩෝන කළමනාකරු

search-header =
    .placeholder = addons.mozilla.org සොයන්න
    .searchbuttonlabel = සොයන්න

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = මේ ආකාරයේ කිසිඳු ඇඩෝනයක් ඔබ ස්ථාපනය කර නැත

list-empty-available-updates =
    .value = යාවත්කාලීන හමු නොවීය

list-empty-recent-updates =
    .value = ඔබ කිසිඳු ඇඩෝනයක් මෑතකදී යාවත්කාලීන කර නැත

list-empty-find-updates =
    .label = යාවත්කාලීන සඳහා පරීක්ෂා කරන්න

list-empty-button =
    .label = ඇඩෝන පිළිබඳව වැඩිදුරටත් දැනගන්න

help-button = ඇඩෝන සහාය

sidebar-help-button-title =
    .title = ඇඩෝන සහාය

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } විකල්ප
       *[other] { -brand-short-name } අභිප්‍රේත
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } විකල්ප
           *[other] { -brand-short-name } අභිප්‍රේත
        }

show-unsigned-extensions-button =
    .label = ඇතැම් දිගු තහවුරු කළ නොහැක

show-all-extensions-button =
    .label = සියළු දිගු පෙන්වන්න

cmd-show-details =
    .label = තවත් තොරතුරු පෙන්වන්න
    .accesskey = S

cmd-find-updates =
    .label = යාවත්කාලීන සොයන්න
    .accesskey = F

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] විකල්ප
           *[other] මනාපයන්
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }

cmd-enable-theme =
    .label = තේමාව දමන්න
    .accesskey = W

cmd-disable-theme =
    .label = තේමාව දැමීම නවතන්න
    .accesskey = W

cmd-install-addon =
    .label = ස්ථාපනය කරන්න
    .accesskey = I

cmd-contribute =
    .label = දායකවන්න
    .accesskey = C
    .tooltiptext = මෙම ඇඩෝනයේ සංවර්ධනය වෙනුවෙන් දායකවන්න

detail-version =
    .label = න්කුතුව

detail-last-updated =
    .label = අවසන් වරට යාවත්කාලීන කළේ

detail-contributions-description = මෙම ඇඩෝන සංවර්ධකයා එහි අඛණ්ඩ සංවර්ධනය වෙනුවෙන් ඔබගේ දායකත්වය ඉල්ලා සිටියි.

detail-update-type =
    .value = ස්වයංක්‍රීය යාවත්කාලීන

detail-update-default =
    .label = පෙරනිමි
    .tooltiptext = එය පෙරනිමියෙන් පමණක් නම්, ස්වයංක්‍රීයව ඇඩෝන යාවත්කාලීන කරන්නA

detail-update-automatic =
    .label = On
    .tooltiptext = ස්වයංක්‍රීයව යාවත්කාලීන ස්ථාපනය කරන්න

detail-update-manual =
    .label = Off
    .tooltiptext = ස්වයංක්‍රීයව යාවත්කාලීන ස්ථාපනය නොකරන්න

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = පුද්ගලික කවුළු තුළ ක්‍රියාකරවන්න

detail-private-browsing-on =
    .label = ඉඩදෙන්න
    .tooltiptext = පුද්ගලික ගවේශණ තුළ සක්‍රීයයි

detail-private-browsing-off =
    .label = ඉඩ නොදෙන්න
    .tooltiptext = පුද්ගලික ගවේශණ තුළ අක්‍රීයයි

detail-home =
    .label = මුල්පිටුව

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Add-on Profile

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = යාවත්කාලීන සඳහා පරීක්ෂා කරන්න
    .accesskey = f
    .tooltiptext = මෙම ඇඩෝනය සඳහා යාවත්කාලීන පරීක්ෂා කරන්න

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] විකල්ප
           *[other] මනාපයන්
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] මෙම ඇඩෝනයේ විකල්ප වෙනස් කරන්න
           *[other] මෙම ඇඩෝනයේ මනාපයන් වෙනස් කරන්න
        }

detail-rating =
    .value = ඇගැයුම (Rating)

addon-restart-now =
    .label = දැන් ප්‍රත්‍යාරම්භ (Restart) කරන්න

disabled-unsigned-heading =
    .value = ඇතැම් ඇඩෝන අක්‍රීය කර ඇත

disabled-unsigned-description = පහත ඇඩෝන { -brand-short-name } හි භාවිතයට තහවුරු කර නොමැත. ඔබට හැක්කේ <label data-l10n-name="find-addons">ප්‍රතිස්ථාපනයන් සොයන්න</label> හෝ තහවුරු කිරීම සඳහා සංවර්දකයාගෙන් විමසන්න.

disabled-unsigned-learn-more = ඔබව මාර්ගගතව ආරක්ෂිතව තැබීම සඳහා අපගේ උත්සාහයන් පිළිබඳ දැනගන්න.

disabled-unsigned-devinfo = මෙය කියවීම මගින් තම ඇඩෝන තහවුරු කරගැනීමට කැමති සංවර්ධකයන් ඉදිරියට යන්න <label data-l10n-name="learn-more">ශ්‍රමික</label>.

plugin-deprecation-description = යමක් අහිමිද? { -brand-short-name } විසින් ඇතැම් ප්ලගින වෙත තවදුරටත් සහය නොදක්වයි. <label data-l10n-name="learn-more"> තවත් දැනගන්න.</label>

addon-category-extension = දිගුකිරීම්
addon-category-extension-title =
    .title = දිගුකිරීම්
addon-category-plugin = ප්ලගීන
addon-category-plugin-title =
    .title = ප්ලගීන
addon-category-dictionary = ශබ්දකෝෂයන්
addon-category-dictionary-title =
    .title = ශබ්දකෝෂයන්
addon-category-locale = භාෂාවන්
addon-category-locale-title =
    .title = භාෂාවන්
addon-category-available-updates = පවතින යාවත්කාලීන
addon-category-available-updates-title =
    .title = පවතින යාවත්කාලීන
addon-category-recent-updates = මෑතකාලීන යාවත්කාලීන
addon-category-recent-updates-title =
    .title = මෑතකාලීන යාවත්කාලීන

## These are global warnings

extensions-warning-safe-mode = ආරක්ෂිත මාදිලිය (safe mode) විසින් සියළු ඇඩෝන කර ඇත.
extensions-warning-check-compatibility = ඇඩෝන අනුකූලතා පරීක්ෂාව අබල (disable) කර ඇත. මෙහි අනුකූල නොවන ඇඩෝන තිබිය හැකිය.
extensions-warning-check-compatibility-button = බලැති (Enable) කරන්න
    .title = ඇඩෝන අනුකූලතා පරීක්ෂාව බලැති (Enable) කරන්න
extensions-warning-update-security = Add-on update security checking is disabled. You may be compromised by updates.
extensions-warning-update-security-button = බලැති (Enable) කරන්න
    .title = ඇඩෝන යාවත්කාලීන කිරීමේ ආරක්ෂක සැකසුම් බලැතා (Enable) කරන්න


## Strings connected to add-on updates

addon-updates-check-for-updates = යාවත්කාලීන සඳහා පරීක්ෂා කරන්න
    .accesskey = C
addon-updates-view-updates = මෑතකාලීන යාවත්කාලීන පෙන්වන්න
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = ස්වයංක්‍රීයව ඇඩෝන යාවත්කාලීන කරන්න
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = ස්වයංක්‍රීයව යාවත්කාලීන කිරීමට සියළු ඇඩෝන ප්‍රත්‍යාරම්භ (Restart) කරන්න
    .accesskey = R
addon-updates-reset-updates-to-manual = Reset All Add-ons to Update Manually
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = ඇඩෝන යාවත්කාලීන කිරීම
addon-updates-installed = ඔබගේ ඇඩෝන යාවත්කාලීන නර ඇත.
addon-updates-none-found = යාවත්කාලීන හමු නොවීය
addon-updates-manual-updates-found = පවතින යාවත්කාලීන පෙන්වන්න

## Add-on install/debug strings for page options menu

addon-install-from-file = ඇඩෝන ගොනුවෙන් ස්ථාපනය කරන්න…
    .accesskey = I
addon-install-from-file-dialog-title = ස්ථාපනය සඳහා ඇඩෝන තෝරන්න
addon-install-from-file-filter-name = ඇඩෝන
addon-open-about-debugging = ඇඩෝන දෝශ නිරාකරණය
    .accesskey = B

## Extension shortcut management

shortcuts-input =
    .placeholder = කෙටිමඟක් ලියන්න

shortcuts-pageAction = පිටු ක්‍රියාව සක්‍රීය කරන්න

shortcuts-modifier-mac = Ctrl, Alt, හෝ ⌘ ඇතුලත් කරන්න
shortcuts-modifier-other = Ctrl හෝ Alt ඇතුලත් කරන්න

## Recommended add-ons page


## Add-on actions

remove-addon-button = ඉවත් කරන්න
disable-addon-button = අක්‍රීය කරන්න
enable-addon-button = සක්‍රීය

## Pending uninstall message bar


## Page headings

addons-heading-search-input =
    .placeholder = addons.mozilla.org සොයන්න

addon-page-options-button =
    .title = සියළු ඇඩෝන සඳහා මෙවලම්
