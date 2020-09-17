# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = បញ្ជូន​សញ្ញា "កុំ​តាមដាន" ទៅ​គេហទំព័រ ដែល​អ្នក​មិន​ចង់​ឲ្យ​តាមដាន
do-not-track-learn-more = ស្វែងយល់​បន្ថែម
do-not-track-option-always =
    .label = ជានិច្ច

pref-page-title =
    { PLATFORM() ->
        [windows] ជម្រើស
       *[other] ចំណូលចិត្ត
    }

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] រកនៅក្នុងជម្រើស
           *[other] រកនៅក្នុងចំណូលចិត្ត
        }

pane-general-title = ទូទៅ
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = ទំព័រដើម
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = ស្វែងរក
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = ឯកជន​ភាព & សុវត្ថិភាព
category-privacy =
    .tooltiptext = { pane-privacy-title }

help-button-label = { -brand-short-name } ជំនួយ
addons-button-label = ផ្នែកបន្ថែមនិងរចនាប័ទ្ម

focus-search =
    .key = f

close-button =
    .aria-label = បិទ

## Browser Restart Dialog

feature-enable-requires-restart = ត្រូវតែ​ចាប់ផ្ដើម { -brand-short-name } ឡើងវិញ​ដើម្បី​បើក​លក្ខណៈ​នេះ ។
feature-disable-requires-restart = ត្រូវតែ​ចាប់ផ្ដើម { -brand-short-name } ឡើងវិញ​ដើម្បី​បិទ​លក្ខណៈ​នេះ ។
should-restart-title = ចាប់ផ្ដើម { -brand-short-name } ឡើងវិញ
should-restart-ok = ចាប់ផ្ដើម { -brand-short-name } ឡើងវិញ​ឥឡូវ​នេះ
cancel-no-restart-button = បោះបង់
restart-later = ចាប់ផ្ដើម​ឡើងវិញ​នៅ​ពេលក្រោយ

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = ផ្នែកបន្ថែម <img data-l10n-name="icon"/> { $name } កំពុងគ្រប់គ្រងទំព័រដើមរបស់អ្នក។

# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = ផ្នែកបន្ថែម <img data-l10n-name="icon"/> { $name } កំពុងគ្រប់គ្រងទំព័រផ្ទាំងថ្មីរបស់អ្នក។

# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = ផ្នែកបន្ថែម <img data-l10n-name="icon"/> { $name } បានកំណត់ម៉ាស៊ីនស្វែងរកលំនាំដើមរបស់អ្នក។

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = ផ្នែកបន្ថែម <img data-l10n-name="icon"/> { $name } ត្រូវការផ្ទាំងឧបករណ៍ផ្ទុក។

# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = ផ្នែកបន្ថែម <img data-l10n-name="icon"/> { $name } កំពុងគ្រប់គ្រងការកំណត់នេះ។

# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = ផ្នែកបន្ថែម <img data-l10n-name="icon"/> { $name } កំពុងគ្រប់គ្រងរបៀបដែល { -brand-short-name } តភ្ជាប់ទៅអ៊ីនធឺណិត។

# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = ដើម្បីអនុញ្ញាតផ្នែកបន្ថែម សូមចូលទៅកាន់ <img data-l10n-name="addons-icon"/> កម្មវិធីបន្ថែម នៅក្នុងម៉ឺនុយ <img data-l10n-name="menu-icon"/>។

## Preferences UI Search Results

search-results-header = លទ្ធផល​ស្វែងរក

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] សុំទោស! មិន​មាន​លទ្ធផល​នៅ​ក្នុង​ជម្រើស​សម្រាប់ “<span data-l10n-name="query"></span>” ទេ។
       *[other] សុំទោស! មិន​មាន​លទ្ធផល​នៅ​ក្នុង​ចំណូលចិត្ត​សម្រាប់ “<span data-l10n-name="query"></span>” ទេ។
    }

search-results-help-link = ត្រូវការជំនួយទេ? មើល<a data-l10n-name="url">ផ្នែកជំនួយរបស់ { -brand-short-name }</a>

## General Section

startup-header = ចាប់ផ្ដើម​ឡើង

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = អនុញ្ញាត​ឲ្យ { -brand-short-name } និង Firefox ដំណើរការ​ក្នុង​ពេល​ដូចគ្នា
use-firefox-sync = ព័ត៌មាន​ជំនួយ៖ វា​ប្រើ​ប្រាស់​​កម្រង​ព័ត៌មាន​​ដោយឡែក។ ប្រើប្រាស់ { -sync-brand-short-name } ដើម្បី​ចែករំលែក​ទិន្នន័យ​រវាង​​កម្រងព័ត៌មាន​ទាំងនេះ។
get-started-not-logged-in = ចូល { -sync-brand-short-name } ...
get-started-configured = បើក​ចំណូលចិត្ត { -sync-brand-short-name }

always-check-default =
    .label = ពិនិត្យជានិច្ច ថា { -brand-short-name } ជា​កម្មវិធី​អ៊ីនធឺណិត​លំនាំដើម
    .accesskey = y

is-default = { -brand-short-name } បច្ចុប្បន្ន​ជា​កម្មវិធី​រុករក​លំនាំដើម​របស់​អ្នក
is-not-default = { -brand-short-name } វា​មិន​មែន​ជា​កម្មវិធី​រុករក​លំនាំដើម​របស់​អ្នក

set-as-my-default-browser =
    .label = ដាក់​ជា​លំនាំ​ដើម
    .accesskey = D

startup-restore-previous-session =
    .label = ស្ដារ​សម័យ​មុន
    .accesskey = s

disable-extension =
    .label = បិទ​ផ្នែក​បន្ថែម

tabs-group-header = ផ្ទាំង

ctrl-tab-recently-used-order =
    .label = ប៊ូតុង​ Ctrl+Tab មាន​មុខងារ​ចូល​មើល​ផ្ទាំង​ដែល​បើក​ថ្មីៗ​ម្ដង​មួយ​ៗ
    .accesskey = T

open-new-link-as-tabs =
    .label = បើក​តំណ​ក្នុង​ផ្ទាំង​ជំនួយ​ឲ្យ​វីនដូ​ថ្មី
    .accesskey = w

warn-on-close-multiple-tabs =
    .label = ព្រមាន​អ្នក​ពេល​បិទ​ផ្ទាំង​ច្រើន
    .accesskey = m

warn-on-open-many-tabs =
    .label = ព្រមាន​អ្នក​ពេល​បើក​ផ្ទាំង​ច្រើន អាច​ធ្វើឲ្យ { -brand-short-name } យឺត
    .accesskey = d

switch-links-to-new-tabs =
    .label = ពេល​អ្នក​បើក​តំណ​ក្នុង​ផ្ទាំង​ថ្មី ប្ដូរ​ទៅ​វា​ភ្លាមៗ
    .accesskey = h

show-tabs-in-taskbar =
    .label = បង្ហាញ​​ការ​មើល​ផ្ទាំង​ជាមុន​នៅ​ក្នុង​របារ​ភារកិច្ច​របស់​វីនដូ
    .accesskey = k

browser-containers-enabled =
    .label = បើក​ផ្ទាំង​ឧបករណ៍​ផ្ទុក
    .accesskey = ​

browser-containers-learn-more = ស្វែងយល់​បន្ថែម

browser-containers-settings =
    .label = ការ​កំណត់...
    .accesskey = i

containers-disable-alert-title = បិទ​ផ្ទាំង​ឧបករណ៍​ផ្ទុក​ទាំងអស់មែន​ទេ?
containers-disable-alert-desc = ប្រសិនបើ​អ្នក​បិទ​ផ្ទាំង​ឧបករណ៍​ផ្ទុក​ឥឡូវ​នេះ ផ្ទាំង​ឧបករណ៍​ផ្ទុក { $tabCount } នឹង​ត្រូវបាន​បិទ។ តើ​អ្នក​ពិត​ជា​ចង់​បិទ​ផ្ទាំង​ឧបករណ៍​ផ្ទុក​មែន​ទេ?

containers-disable-alert-ok-button = បិទ​ផ្ទាំង​ឧបករណ៍​ផ្ទុក { $tabCount }
containers-disable-alert-cancel-button = បន្ត​បើក

containers-remove-alert-title = លុប​ប្រអប់​នេះ​ចេញ?

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg = បើ​អ្នក​លុប​​ឧបករណ៍​ផ្ទុក​​នេះ​ចេញ​ឥឡូវ​នេះ ឧបករណ៍​ផ្ទុក { $count } នឹង​ត្រូវបាន​​បិទ។ តើ​អ្នក​ពិត​ជា​ចង់​លុប​​ឧបករណ៍​ផ្ទុក​​នេះ​ចេញ​មែនទេ?

containers-remove-ok-button = លុប​ប្រអប់​នេះ​ចេញ
containers-remove-cancel-button = កុំ​លុប​ប្រអប់​នេះ​ចេញ​អី


## General Section - Language & Appearance

language-and-appearance-header = ភាសា និង​ការបង្ហាញ

fonts-and-colors-header = ពុម្ព​អក្សរ & ពណ៌

default-font = ពុម្ព​អក្សរ​លំនាំដើម
    .accesskey = D
default-font-size = ទំហំ
    .accesskey = S

advanced-fonts =
    .label = កម្រិតខ្ពស់…
    .accesskey = ត

colors-settings =
    .label = ពណ៌...
    .accesskey = ព

language-header = ភាសា

choose-language-description = ជ្រើស​ភាសា​ដែល​អ្នក​ចូលចិត្ត​សម្រាប់​បង្ហាញ​ទំព័រ

choose-button =
    .label = ជ្រើស…
    .accesskey = ស

confirm-browser-language-change-description = ចាប់ផ្ដើម { -brand-short-name } ឡើងវិញ ​ដើម្បី​​អនុវត្ត​ការផ្លាស់ប្ដូរ​ទាំងនេះ
confirm-browser-language-change-button = អនុវត្ត​និង​ចាប់ផ្តើម​ឡើង​វិញ

translate-web-pages =
    .label = ​បកប្រែ​មាតិកា​បណ្ដាញ
    .accesskey = T

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = ការ​បកប្រែ​ដោយ <img data-l10n-name="logo"/>

translate-exceptions =
    .label = ករណី​លើកលែង…
    .accesskey = x

check-user-spelling =
    .label = ពិនិត្យ​​អក្ខរាវិរុទ្ធ​ពេល​វាយ
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = ឯកសារ និងកម្មវិធី

download-header = ទាញ​យក

download-save-to =
    .label = រក្សា​ទុក​ឯកសារ​ទៅ
    .accesskey = ក

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] ជ្រើស…
           *[other] រក​មើល…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ស
           *[other] ល
        }

download-always-ask-where =
    .label = តែងតែ​សួរ​​រក​កន្លែង​ដែល​ត្រូវរក្សាទុក​ឯកសារ
    .accesskey = A

applications-header = កម្មវិធី

applications-description = ជ្រើសរើស​របៀប​ដែល { -brand-short-name } បើក​ដំណើរការ​ឯកសារ​ដែល​អ្នក​ទាញយក​ពី​បណ្ដាញ ឬ​កម្មវិធី​ដែល​អ្នក​ប្រើប្រាស់​នៅ​ពេល​រុករក។

applications-filter =
    .placeholder = ស្វែងរក​ប្រភេទ​ឯកសារ និង​កម្មវិធី

applications-type-column =
    .label = ប្រភេទ​មាតិកា
    .accesskey = ក

applications-action-column =
    .label = អំពើ
    .accesskey = ព

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = ឯកសារ { $extension }
applications-action-save =
    .label = រក្សា​ទុក​ឯកសារ

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = ប្រើ { $app-name }

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = ប្រើ { $app-name } (លំនាំដើម)

applications-use-other =
    .label = ប្រើ​ផ្សេងទៀត…
applications-select-helper = ជ្រើស​កម្មវិធី​ជំនួយ

applications-manage-app =
    .label = សេចក្ដី​លម្អិត​អំពី​កម្មវិធី…
applications-always-ask =
    .label = សួរ​ជានិច្ច
applications-type-pdf = ទ្រង់ទ្រាយ​ឯកសារ​ចល័ត (PDF)

# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })

# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })

# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = ប្រើ { $plugin-name } (ក្នុង { -brand-short-name })

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }

applications-action-save-label =
    .value = { applications-action-save.label }

applications-use-app-label =
    .value = { applications-use-app.label }

applications-always-ask-label =
    .value = { applications-always-ask.label }

applications-use-app-default-label =
    .value = { applications-use-app-default.label }

applications-use-other-label =
    .value = { applications-use-other.label }

##

drm-content-header = ខ្លឹមសារ​ការគ្រប់គ្រងសិទ្ធិឌីជីថល (DRM)

play-drm-content =
    .label = លេងខ្លឹមសារ​ដែលគ្រប់គ្រងដោយ DRM
    .accesskey = P

play-drm-content-learn-more = ស្វែងយល់​​បន្ថែម

update-application-title = បច្ចុប្បន្នភាព { -brand-short-name }

update-application-description = រក្សា { -brand-short-name } ឱ្យ​ថ្មីៗ​ជានិច្ច ដើម្បី​ដំណើរការ​​មាន​ប្រសិទ្ធភាព ស្ថេរភាព និងសុវត្ថិភាពបំផុត។

update-application-version = កំណែ { $version } <a data-l10n-name="learn-more">អ្វី​ដែល​ថ្មី</a>

update-history =
    .label = បង្ហាញ​ប្រវត្តិ​បច្ចុប្បន្នភាព...
    .accesskey = p

update-application-allow-description = អនុញ្ញាត { -brand-short-name } ឲ្យ

update-application-auto =
    .label = ដំឡើងបច្ចុប្បន្នភាពដោយស្វ័យប្រវត្តិ (បានណែនាំ)
    .accesskey = A

update-application-check-choose =
    .label = ពិនិត្យ​មើល​បច្ចុប្បន្នភាព ប៉ុន្តែ​អាច​ឲ្យ​អ្នក​ជ្រើសរើស​ដំឡើង​ពួកវា​បាន
    .accesskey = C

update-application-manual =
    .label = កុំ​ពិនិត្យមើល​បច្ចុប្បន្នភាព​ឲ្យ​សោះ (មិន​ណែនាំ​ឲ្យ​ធ្វើ​ដូច្នេះ​ទេ)
    .accesskey = N

update-application-use-service =
    .label = ប្រើ​សេវា​ផ្ទៃ​ខាងក្រោយ ដើម្បី​ដំឡើង​បច្ចុប្បន្នភាព
    .accesskey = b

## General Section - Performance

performance-title = ដំណើរការ

performance-use-recommended-settings-checkbox =
    .label = ប្រើ​ការ​កំណត់​ដំណើរការ​ដែល​បាន​ណែនាំ
    .accesskey = U

performance-use-recommended-settings-desc = ការ​កំណត់​ទាំងនេះ​គឺ​ត្រូវគ្នា​ទៅ​នឹង​ផ្នែក​រឹង និង​ប្រព័ន្ធ​ប្រតិបត្តិការ​នៃ​កុំព្យូទ័រ​របស់​អ្នក។

performance-settings-learn-more = ស្វែងយល់​បន្ថែម

performance-allow-hw-accel =
    .label = ប្រើ​ការ​បង្កើន​ល្បឿន​ផ្នែក​រឹង នៅពេល​អាច​ប្រើ​បាន
    .accesskey = ប

performance-limit-content-process-option = ដែនកំណត់​ដំណើរការ​មាតិកា
    .accesskey = L

performance-limit-content-process-enabled-desc = ដំណើរការ​មាតិកា​បន្ថែម​អាច​ធ្វើឲ្យ​ដំណើរការ​ប្រសើរ​ឡើង​នៅពេល​ប្រើ​ផ្ទាំង​ច្រើន ប៉ុន្តែ​វា​នឹង​ប្រើ​អង្គ​ចងចាំ​ច្រើន​ដែរ។
performance-limit-content-process-blocked-desc = ការ​កែប្រែ​ចំនួន​ដំណើរការ​មាតិកា គឺ​អាច​ធ្វើ​ទៅ​បានតែ​ជាមួយ { -brand-short-name } ពហុ​ដំណើរការ​ប៉ុណ្ណោះ។ <a data-l10n-name="learn-more">ស្វែងយល់​ពី​របៀប​ពិនិត្យមើល ប្រសិនបើ​បាន​បើក​ពហុ​ដំណើរការ</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (លំនាំដើម)

## General Section - Browsing

browsing-title = រក​មើល

browsing-use-autoscroll =
    .label = ប្រើ​រំកិល​ស្វ័យប្រវត្តិ
    .accesskey = a

browsing-use-smooth-scrolling =
    .label = ​ប្រើ​រមូរ​រលូន
    .accesskey = m

browsing-use-onscreen-keyboard =
    .label = បង្ហាញ​ក្ដារចុច​ប៉ះ​នៅ​ពេល​ចាំបាច់
    .accesskey = k

browsing-use-cursor-navigation =
    .label = ប្រើ​គ្រាប់​ចុច​ទស្សន៍​ទ្រនិច​ជានិច្ច​ដើម្បី​រុករក​ក្នុង​ទំព័រ
    .accesskey = c

browsing-search-on-start-typing =
    .label = ស្វែងរក​​អក្សរ នៅ​ពេល​អ្នក​ចាប់ផ្ដើម​វាយ
    .accesskey = x

browsing-cfr-recommendations-learn-more = ស្វែងយល់​បន្ថែម

## General Section - Proxy

network-settings-title = ការកំណត់​បណ្ដាញ

network-proxy-connection-description = កំណត់រចនាសម្ព័ន្ធរបៀបដែល { -brand-short-name } តភ្ជាប់ទៅអ៊ីនធឺណិត

network-proxy-connection-learn-more = ស្វែងយល់​បន្ថែម

network-proxy-connection-settings =
    .label = ការ​កំណត់…
    .accesskey = e

## Home Section

home-new-windows-tabs-header = វីនដូ និងផ្ទាំងថ្មី

home-new-windows-tabs-description2 = ជ្រើសអ្វីដែលអ្នកឃើញនៅពេលអ្នកបើកគេហទំព័រ, វីនដូថ្មី, និងផ្ទាំងថ្មី។

## Home Section - Home Page Customization

home-homepage-mode-label = ទំព័រដើម និងវីនដូថ្មី

home-newtabs-mode-label = ផ្ទាំងថ្មី

home-restore-defaults =
    .label = ស្ដារ​លំនាំ​ដើម
    .accesskey = R

# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = ទំព័រដើម Firefox (លំនាំដើម)

home-mode-choice-custom =
    .label = URL ផ្ទាល់ខ្លួន…

home-mode-choice-blank =
    .label = ទំព័រទទេ

home-homepage-custom-url =
    .placeholder = ដាក់​ចូល URL…

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] ប្រើ​ទំព័រ​បច្ចុប្បន្ន
           *[other] ប្រើ​ទំព័រ​បច្ចុប្បន្ន
        }
    .accesskey = ប

choose-bookmark =
    .label = ប្រើ​ចំណាំ…
    .accesskey = ច

## Home Section - Firefox Home Content Customization

home-prefs-content-header = ខ្លឹមសារ Firefox Home
home-prefs-content-description = ជ្រើសរើស​ខ្លឹមសារ​អ្វីដែលអ្នកចង់បាននៅលើអេក្រង់ Firefox Home របស់អ្នក។

home-prefs-search-header =
    .label = ការស្វែងរកតាម​អ៊ីនធឺណិត
home-prefs-topsites-header =
    .label = សាយកំពូល
home-prefs-topsites-description = គេហទំព័រ​ដែល​អ្នក​មើល​ច្រើន​បំផុត

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = បានណែនាំដោយ { $provider }

##

home-prefs-recommended-by-learn-more = របៀប​ដែល​វា​ដំណើរការ
home-prefs-recommended-by-option-sponsored-stories =
    .label = រឿងរ៉ាវដែលបានឧបត្ថម្ភ

home-prefs-highlights-header =
    .label = រឿងសំខាន់ៗ
home-prefs-highlights-description = ការជ្រើសរើស​គេហទំព័រ​ដែល​អ្នក​បាន​រក្សាទុក ឬ​មើល
home-prefs-highlights-option-visited-pages =
    .label = ទំព័រ​ដែល​បាន​ទស្សនា
home-prefs-highlights-options-bookmarks =
    .label = ចំណាំ
home-prefs-highlights-option-most-recent-download =
    .label = ការទាញយកថ្មីបំផុត
home-prefs-highlights-option-saved-to-pocket =
    .label = ទំព័រដែលបានរក្សាទុកទៅ { -pocket-brand-name }

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = អត្ថបទសង្ខេប
home-prefs-snippets-description = បច្ចុប្បន្នភាពពី { -vendor-short-name } និង { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
           *[other] { $num } ជួរ
        }

## Search Section

search-bar-header = របារស្វែងរក
search-bar-hidden =
    .label = ប្រើប្រាស់​របាអាសយដ្ឋានសម្រាប់ការស្វែងរក និងរុករក
search-bar-shown =
    .label = បញ្ចូល​របារស្វែងរកនៅក្នុងរបារឧបករណ៍

search-engine-default-header = ម៉ាស៊ីន​ស្វែងរក​លំនាំដើម

search-suggestions-option =
    .label = បង្ហាញ​ការ​ផ្ដល់​យោបល់​ស្វែងរក
    .accesskey = រ

search-show-suggestions-url-bar-option =
    .label = បង្ហាញការណែនាំ​ស្វែងរកនៅក្នុងលទ្ធផលរបារអាសយដ្ឋាន
    .accesskey = I

# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = បង្ហាញការណែនាំ​ស្វែងរកមុនប្រវត្តិការរុករកនៅក្នុងលទ្ធផល​លើ​របារអាសយដ្ឋាន

search-suggestions-cant-show = សំណើ​ស្វែងរក​នឹង​​មិន​បង្ហាញ​នៅ​ក្នុង​លទ្ធផល​របារ​ទីតាំង​​ទេ ព្រោះ​អ្នក​បាន​កំណត់​រចនាសម្ព័ន្ធ { -brand-short-name } មិន​ដែល​ឲ្យ​ចងចាំ​ប្រវត្តិ។

search-one-click-header = ម៉ាស៊ីន​ស្វែងរក​ចុច​តែ​ម្ដង

search-one-click-desc = ជ្រើសរើស​ម៉ាស៊ីន​ស្វែងរក​ជំនួស​ដែល​បង្ហាញ​នៅ​ខាងក្រោម​របារអាសយដ្ឋាន និង​របារស្វែងរក​នៅ​ពេល​អ្នក​ចាប់ផ្តើម​បញ្ចូល​ពាក្យគន្លឹះ។

search-choose-engine-column =
    .label = ម៉ាស៊ីន​ស្វែងរក
search-choose-keyword-column =
    .label = ពាក្យ​គន្លឹះ

search-restore-default =
    .label = ស្ដារ​ម៉ាស៊ីន​ស្វែងរកលំនាំដើម
    .accesskey = ល

search-remove-engine =
    .label = យក​ចេញ...
    .accesskey = ញ

search-find-more-link = រកម៉ាស៊ីនស្វែងរកបន្ថែម

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = ពាក្យ​គន្លឹះ​ស្ទួន
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = អ្នក​បានជ្រើស​រើស​ពាក្យ​គន្លឹះ ដែល​បច្ចុប្បន្ន​នេះ​​​​កំពុង​ប្រើ​ដោយ "{ $name }"។ សូម​ជ្រើសរើស​ពាក្យ​គន្លឹះ​ផ្សេង​ទៀត។
search-keyword-warning-bookmark = អ្នក​បាន​ជ្រើសរើស​ពាក្យ​គន្លឹះ​ដែល​ត្រូវ​បាន​ប្រើ​បច្ចុប្បន្ន​ដោយ​ចំណាំ ។ សូម​ជ្រើស​មួយ​ផ្សេង​ទៀត ។

## Containers Section

containers-header = ផ្ទាំង​ប្រអប់​ផ្ទុក
containers-add-button =
    .label = បន្ថែម​ប្រអប់​ផ្ទុក​ថ្មី
    .accesskey = A

containers-preferences-button =
    .label = ចំណូលចិត្ត
containers-remove-button =
    .label = លុប​ចេញ

## Sync Section - Signed out


## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = យក​បណ្ដាញ​របស់​អ្នក​ជាមួយ​អ្នក
sync-signedout-description = ធ្វើ​សម​កាល​កម្ម​ចំណាំ​ ប្រវត្តិ ផ្ទាំង ពាក្យ​សម្ងាត់​ កម្មវិធី​ផ្នែក​បន្ថែម​ និង​ចំណូល​ចិត្ត​របស់​អ្នក​ ចំពោះ​គ្រប់​ឧបករណ៍​របស់​អ្នក។​

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = ទាញ​យក​ Firefox សម្រាប់​<img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> ឬ <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a>ធ្វើ​សម​កាល​កម្ម​​ឧបករណ៍​ចល័ត​របស់​អ្នក។

## Sync Section - Signed in


## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = ប្តូរ​​រូប​ប្រូ​ហ្វាល់

sync-manage-account = គ្រប់គ្រង​គណនី
    .accesskey = o

sync-signedin-unverified = { $email } មិន​ត្រូវ​បាន​ផ្ទៀងផ្ទាត់។
sync-signedin-login-failure = សូម​ចូល​ដើម្បី​តភ្ជាប់​ឡើង​វិញ { $email }

sync-resend-verification =
    .label = ផ្ញើការផ្ទៀងផ្ទាត់ម្ដងទៀត
    .accesskey = ផ

sync-remove-account =
    .label = លុប​គណនី
    .accesskey = R

sync-sign-in =
    .label = ចូល
    .accesskey = g

## Sync section - enabling or disabling sync.


## The list of things currently syncing.


## The "Choose what to sync" dialog.

sync-engine-bookmarks =
    .label = ចំណាំ
    .accesskey = m

sync-engine-history =
    .label = ប្រវត្តិ
    .accesskey = r

sync-engine-tabs =
    .label = ផ្ទាំងដែលបើក
    .tooltiptext = បញ្ជីអ្វីដែលបានបើកនៅលើឧបករណ៍ដែលបានធ្វើសមកាលកម្មទាំងអស់
    .accesskey = ផ

sync-engine-addresses =
    .label = អាសយដ្ឋាន
    .tooltiptext = អាសយដ្ឋានប្រៃសណីយ៍ដែលអ្នកបានរក្សាទុក (ផ្ទៃតុតែប៉ុណ្ណោះ)
    .accesskey = យ

sync-engine-creditcards =
    .label = កាត​ឥណទាន
    .tooltiptext = ឈ្មោះ, លេខ និងកាលបរិច្ឆេទផុតកំណត់ (ផ្ទៃតុតែប៉ុណ្ណោះ)
    .accesskey = ក

sync-engine-addons =
    .label = កម្មវិធី​បន្ថែម
    .tooltiptext = ផ្នែកបន្ថែមនិងរចនាប័ទ្មសម្រាប់ Firefox ផ្ទៃតុ
    .accesskey = ក

sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] ជម្រើស
           *[other] ចំណូលចិត្ត
        }
    .tooltiptext = ការកំណត់ទូទៅ, ភាពឯកជន និងសុវត្ថិភាពដែលអ្នកបានប្តូរ
    .accesskey = s

## The device name controls.

sync-device-name-header = ឈ្មោះ​ឧបករណ៍

sync-device-name-change =
    .label = ប្ដូរ​ឈ្មោះ​ឧបករណ៍…
    .accesskey = h

sync-device-name-cancel =
    .label = បោះបង់
    .accesskey = n

sync-device-name-save =
    .label = រក្សា​ទុក
    .accesskey = v

## Privacy Section

privacy-header = ឯកជនភាព​កម្មវិធី​រុករក​តាម​អ៊ីនធឺណិត

## Privacy Section - Forms

## Privacy Section - Logins and Passwords

# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = ស្នើឱ្យរក្សាទុកការចូលនិងពាក្យសម្ងាត់សម្រាប់វេបសាយ
    .accesskey = ម
forms-exceptions =
    .label = ករណី​លើកលែង…
    .accesskey = x

forms-saved-logins =
    .label = ការ​ចូល​ដែល​បាន​រក្សាទុក...
    .accesskey = L
forms-master-pw-use =
    .label = ប្រើ​ពាក្យ​សម្ងាត់​មេ
    .accesskey = U
forms-master-pw-change =
    .label = ផ្លាស់ប្ដូរ​ពាក្យ​សម្ងាត់​មេ…
    .accesskey = M

forms-master-pw-fips-title = បច្ចុប្បន្ន​នេះ អ្នក​ស្ថិត​នៅក្នុង​របៀប FIPS ។ FIPS ទាមទារ​ពាក្យសម្ងាត់​មេ​ដែល​មិន​ទទេ​ ។

forms-master-pw-fips-desc = បាន​បរាជ័យ​ក្នុង​ការ​ផ្លាស់ប្ដូរ​ពាក្យសម្ងាត់

## OS Authentication dialog


## Privacy Section - History

history-header = ប្រវត្តិ

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } នឹង
    .accesskey = w

history-remember-option-all =
    .label = ចងចាំ​ប្រវត្តិ
history-remember-option-never =
    .label = កុំ​ចងចាំ​ប្រវត្តិ
history-remember-option-custom =
    .label = ប្រើ​ការ​កំណត់​ផ្ទាល់ខ្លួន​សម្រាប់​ប្រវត្តិ

history-remember-description = { -brand-short-name } នឹងចងចាំការរុករក ការទាញយក សំណុំបែបបទ និងប្រវត្តិស្វែងរករបស់អ្នក។
history-dontremember-description = { -brand-short-name } នឹង​ប្រើ​ការ​កំណត់​ដូច​គ្នា​ជា​ការ​​រក​មើល​ឯកជន ហើយ​នឹង​មិន​ចងចាំ​ប្រវត្តិ​ណាមួយ ពេល​ដែល​អ្នក​រក​មើល​តំបន់​បណ្ដាញ​នោះ​ទេ ។

history-private-browsing-permanent =
    .label = ប្រើ​របៀប​រកមើល​ឯកជន​ជានិច្ច
    .accesskey = ប

history-remember-browser-option =
    .label = ចងចាំ​ប្រវត្តិ​ទាញយកនិង​ការ​រុករក​
    .accesskey = ង

history-remember-search-option =
    .label = ចងចាំ​ប្រវត្តិ​ស្វែងរក និង​សំណុំ​បែបបទ
    .accesskey = ទ

history-clear-on-close-option =
    .label = សម្អាតប្រវត្តិ​នៅ​ពេល { -brand-short-name } បិទ
    .accesskey = ប

history-clear-on-close-settings =
    .label = កំពុង​កំណត់…
    .accesskey = ង

history-clear-button =
    .label = សម្អាតប្រវត្តិ...
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = ខូឃី និងទិន្នន័យ​គេហទំព័រ

sitedata-total-size-calculating = កំពុងគណនាទិន្នន័យតំបន់បណ្តាញ និងទំហំឃ្លាំងសម្ងាត់…

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = ខុកឃី ទិន្នន័យវិបសាយ និងឃ្លាំងសម្ងាត់ដែលបានផ្ទុករបស់អ្នកបច្ចុប្បន្នកំពុងប្រើទំហំថាស { $value } { $unit }។

sitedata-learn-more = ស្វែងយល់​បន្ថែម

# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = ប្រភេទខ្លឹមផ្សាដែលបានទប់ស្កាត់
    .accesskey = T

sitedata-clear =
    .label = សម្អាតទិន្នន័យ...
    .accesskey = l

sitedata-settings =
    .label = គ្រប់គ្រងទិន្នន័យ...
    .accesskey = M

## Privacy Section - Address Bar

addressbar-header = របារអាសយដ្ឋាន

addressbar-suggest = នៅពេលប្រើប្រាស់​របារអាសយដ្ឋាន ណែនាំ

addressbar-locbar-history-option =
    .label = ប្រវត្តិការរុករក
    .accesskey = h
addressbar-locbar-bookmarks-option =
    .label = ចំណាំ
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = បើក​ផ្ទាំង
    .accesskey = O

addressbar-suggestions-settings = ប្ដូរ​ចំណូលចិត្ត​សម្រាប់​ការ​សំណើ​ម៉ាស៊ីន​ស្វែងរក

## Privacy Section - Content Blocking

content-blocking-learn-more = ស្វែងយល់​បន្ថែម

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = ស្ដង់ដា
    .accesskey = d
enhanced-tracking-protection-setting-custom =
    .label = ផ្ទាល់ខ្លួន
    .accesskey = C

##

content-blocking-cookies-label =
    .label = ​ខូគី
    .accesskey = ខ

## Privacy Section - Tracking


## Privacy Section - Permissions

permissions-header = ការ​អនុញ្ញាត

permissions-location = ទីតាំង
permissions-location-settings =
    .label = ការកំណត់...
    .accesskey = t

permissions-camera = កាមេរ៉ា
permissions-camera-settings =
    .label = ការ​កំណត់...
    .accesskey = t

permissions-microphone = មីក្រូហ្វូន
permissions-microphone-settings =
    .label = ការកំណត់...
    .accesskey = t

permissions-notification = ការ​ជូនដំណឹង
permissions-notification-settings =
    .label = ការកំណត់...
    .accesskey = t
permissions-notification-link = ស្វែងយល់​បន្ថែម

permissions-notification-pause =
    .label = ផ្អាកការជូនដំណឹងរហូតដល់ { -brand-short-name } ចាប់ផ្តើមឡើងវិញ
    .accesskey = n

permissions-block-popups =
    .label = ទប់ស្កាត់​​បង្អួច​លេច​ឡើង
    .accesskey = ទ

permissions-block-popups-exceptions =
    .label = ករណី​លើក​លែង
    .accesskey = ក

permissions-addon-install-warning =
    .label = ព្រមានអ្នកនៅពេលគេហទំព័រព្យាយាមដំឡើងកម្មវិធីបន្ថែម
    .accesskey = W

permissions-addon-exceptions =
    .label = ករណី​លើកលែង…
    .accesskey = E

permissions-a11y-privacy-checkbox =
    .label = រារាំងសេវាកម្មភាពងាយស្រួលចូល​ប្រើ​មិនឲ្យចូលប្រើកម្មវិធីរុករក​អ៊ីនធឺណិត​របស់អ្នក
    .accesskey = a

permissions-a11y-privacy-link = ស្វែងយល់​បន្ថែម

## Privacy Section - Data Collection

collection-header = ការប្រមូល និងការប្រើប្រាស់ទិន្នន័យ { -brand-short-name }

collection-description = យើងខិតខំផ្តល់ជូនអ្នកនូវជម្រើស និងប្រមូលតែ​អ្វីដែលយើងត្រូវការ ដើម្បីផ្តល់ និងកែលម្អ { -brand-short-name } សម្រាប់មនុស្សគ្រប់គ្នា​​ប៉ុណ្ណោះ។ យើងតែងតែសុំការអនុញ្ញាត មុនពេលទទួលបានព័ត៌មានផ្ទាល់ខ្លួន។
collection-privacy-notice = ការជូនដំណឹង​អំពី​ឯកជនភាព

collection-health-report =
    .label = អនុញ្ញាតឲ្យ { -brand-short-name } ផ្ញើទិន្នន័យបច្ចេកទេស និងអន្តរកម្មទៅ { -vendor-short-name }
    .accesskey = r
collection-health-report-link = ស្វែងយល់​​បន្ថែម

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = ការ​រាយការណ៍​ទិន្នន័យ​ត្រូវ​បាន​បិទ​សម្រាប់​ការ​កំណត់​រចនាសម្ព័ន្ធ​កំណែ​នេះ

collection-backlogged-crash-reports =
    .label = អនុញ្ញាត​ឲ្យ { -brand-short-name } ផ្ញើ​របាយការណ៍​ភាព​ជាប់​គាំង​ដែល​បាន​បម្រុង​ជំនួសអ្នក
    .accesskey = ភ
collection-backlogged-crash-reports-link = ស្វែងយល់​​បន្ថែម

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = សុវត្ថិភាព

security-browsing-protection = ការការពារខ្លឹមសារ និងផ្នែកទន់ដែលមានភាពគ្រោះថ្នាក់

security-enable-safe-browsing =
    .label = ទប់ស្កាត់​មាតិកា​ដែល​មាន​ភាព​គ្រោះថ្នាក់​និង​ការ​បញ្ឆោត
    .accesskey = B
security-enable-safe-browsing-link = ស្វែងយល់​បន្ថែម

security-block-downloads =
    .label = ទប់ស្កាត់​ការ​ទាញយក​ដែល​គ្រោះថ្នាក់
    .accesskey = d

security-block-uncommon-software =
    .label = ព្រមាន​អ្នក​អំពី​កម្មវិធី​ដែល​មិន​ធម្មតា ឬ​មិន​ចង់បាន
    .accesskey = C

## Privacy Section - Certificates

certs-header = វិញ្ញាបនបត្រ

certs-personal-label = នៅ​ពេល​ម៉ាស៊ីន​មេ​ស្នើ​សុំ​វិញ្ញាបនបត្រ​ផ្ទាល់ខ្លួន​របស់​អ្នក

certs-select-auto-option =
    .label = ជ្រើសរើស​​វិញ្ញាបនបត្រ​ដោយ​ស្វ័យប្រវត្តិ
    .accesskey = S

certs-select-ask-option =
    .label = សួរ​អ្នក​រាល់លើក
    .accesskey = A

certs-enable-ocsp =
    .label = ម៉ាស៊ីន​មេ​កម្មវិធី​ឆ្លើយតប OCSP ត្រូវ​បញ្ជាក់​ភាព​ត្រឹមត្រូវ​នៃ​វិញ្ញាបនបត្រ​បច្ចុប្បន្ន
    .accesskey = Q

certs-view =
    .label = មើល​វិញ្ញាបនបត្រ…
    .accesskey = C

certs-devices =
    .label = ឧបករណ៍​សុវត្ថិភាព…
    .accesskey = D

space-alert-learn-more-button =
    .label = ស្វែងយល់​បន្ថែម
    .accesskey = L

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] បើក​ជម្រើស
           *[other] បើក​ចំណូលចិត្ត
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }

space-alert-under-5gb-ok-button =
    .label = យល់​ហើយ
    .accesskey = K

space-alert-under-5gb-message = { -brand-short-name } កំពុង​អស់​ទំហំ​ផ្ទុក​ទំនេរ។ មាតិកា​គេហទំព័រ​​អាច​មិន​បង្ហាញ​បាន​ត្រឹមត្រូវ។ ចូល​មើល “ស្វែងយល់​បន្ថែម” ដើម្បី​ធ្វើ​ឲ្យ​ការ​ប្រើប្រាស់​ថាស​របស់​អ្នកប្រសើរ​ឡើង​សម្រាប់​បទពិសោធន៍​រកមើល​​ប្រសើរ​ជាង​មុន។

## Privacy Section - HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = ផ្ទៃតុ
downloads-folder-name = ទាញ​យក
choose-download-folder-title = ជ្រើស​ថត​ទាញ​យក ៖

