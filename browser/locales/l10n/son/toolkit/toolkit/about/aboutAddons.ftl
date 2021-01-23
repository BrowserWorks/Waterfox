# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Tontoney juwalkaa

addons-page-title = Tontoney juwalkaa

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = War ši nda dumoo woo tontoni kul kaŋ sinjandi.

list-empty-available-updates =
    .value = Taagandiri kul mana duwandi

list-empty-recent-updates =
    .value = War ma tontoni kul taagandiri cee korawey

list-empty-find-updates =
    .label = Taagandirey ceeci

list-empty-button =
    .label = Tontoney wey bay ka tonton

show-unsigned-extensions-button =
    .label = Dobuyan fooyaŋ mana hin ka tabatandi

show-all-extensions-button =
    .label = Dobuyaney kul cebe

cmd-show-details =
    .label = Alhabar cebe ka tonton
    .accesskey = c

cmd-find-updates =
    .label = Taagandirey ceeci
    .accesskey = T

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Suubarey
           *[other] Ibaayey
        }
    .accesskey =
        { PLATFORM() ->
            [windows] S
           *[other] b
        }

cmd-enable-theme =
    .label = Bankaaray furari
    .accesskey = B

cmd-disable-theme =
    .label = Bankaaray furari kayandi
    .accesskey = B

cmd-install-addon =
    .label = Sinji
    .accesskey = S

cmd-contribute =
    .label = Kanbuzaamay
    .accesskey = K
    .tooltiptext = Kanbuzaamay tontonoo woo cineyanoo še

detail-version =
    .label = Dumi

detail-last-updated =
    .label = Taagandiri koraa

detail-contributions-description = Tontonoo woo cinekaa ga wiri war ma nga gaa ka cin ka koy jine nda kanbuzaamay kayna.

detail-update-type =
    .value = Boŋtaagandirey

detail-update-default =
    .label = Tilasu
    .tooltiptext = Taagandirey sinji ngey boŋše de nda tilasu no

detail-update-automatic =
    .label = Ga goy
    .tooltiptext = Boŋtaagandirey sinji

detail-update-manual =
    .label = Šii goy ra
    .tooltiptext = Ši boŋtaagandirey sinji

detail-home =
    .label = Šintinmoo

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Alhal tontoni

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Taagandirey ceeci
    .accesskey = c
    .tooltiptext = Taagandirey ceeci tontonoo woo še

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Suubarey
           *[other] Ibaayey
        }
    .accesskey =
        { PLATFORM() ->
            [windows] S
           *[other] b
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Tontonoo woo suubarey barmay
           *[other] Tontonoo woo ibaayey barmay
        }

detail-rating =
    .value = Kanandiyan

addon-restart-now =
    .label = Tunandi taaga sohõ

disabled-unsigned-heading =
    .value = I na tontoni fooyaŋ kayandi

disabled-unsigned-description = Tontoney wey mana hin ka tabatandi ka goy nda { -brand-short-name }. War ga hin ka <label data-l10n-name="find-addons">duu barmay hayey</label> wala wa cinakaa hãa k'i tabatandi.

disabled-unsigned-learn-more = Bay ka tonton kaŋ ir ga durkutu ka war saajaw interneti ra.

disabled-unsigned-devinfo = Cinakey kaŋ ga boona ngi tontoney ma korosandi ma gaabandi ka caw ir <label data-l10n-name="learn-more">fahamandi tiira ra</label>.

plugin-deprecation-description = Haya foo ga kuma? Sukari fooyaŋ ši kanbandi koyne { -brand-short-name } ga. <label data-l10n-name="learn-more">Bay ka tonton.</label>

addon-category-extension = Dobuyaney
addon-category-extension-title =
    .title = Dobuyaney
addon-category-plugin = Sukarey
addon-category-plugin-title =
    .title = Sukarey
addon-category-dictionary = Kamasey
addon-category-dictionary-title =
    .title = Kamasey
addon-category-locale = Šenney
addon-category-locale-title =
    .title = Šenney
addon-category-available-updates = Taagandiri barantey
addon-category-available-updates-title =
    .title = Taagandiri barantey
addon-category-recent-updates = Taagandiri kokorantey
addon-category-recent-updates-title =
    .title = Taagandiri kokorantey

## These are global warnings

extensions-warning-safe-mode = Saajaw alhaalooo na tontoney kul kayandi.
extensions-warning-check-compatibility = Tontoni cerekanbeyan koroširoo kayandi. I ga hima tontoniyaŋ kaŋ ši cerekanbe.
extensions-warning-check-compatibility-button = Tunandi
    .title = Tontoni cerekanbeyan korošiyan tunandi
extensions-warning-update-security = Tontoni saajaw taagandiri koroširoo kayandi. A ga hima taagandirey ga šendayyaŋ kate.
extensions-warning-update-security-button = Tunandi
    .title = Tontoni saajaw taagandiri koroširoo tunandi


## Strings connected to add-on updates

addon-updates-check-for-updates = Taagandirey ceeci
    .accesskey = c
addon-updates-view-updates = Taagandiri kokorantey guna
    .accesskey = g

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Tontoni boŋ-taagandiri
    .accesskey = T

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Tontoney kul willi boŋ-taagandiri bande
    .accesskey = w
addon-updates-reset-updates-to-manual = Tontoney kul willi boŋ-taagandiri nda kanbe
    .accesskey = w

## Status messages displayed when updating add-ons

addon-updates-updating = Goo ma tontoney taagandi
addon-updates-installed = War tontoney n' ka taagandi.
addon-updates-none-found = Taagandiri kul mana duwandi
addon-updates-manual-updates-found = Taagandiri barantey guna

## Add-on install/debug strings for page options menu

addon-install-from-file = Sinji tontoni tuku boŋ…
    .accesskey = i
addon-install-from-file-dialog-title = Tontoni suuba k'a sinji
addon-install-from-file-filter-name = Tontoney
addon-open-about-debugging = Hanseyan tontoney
    .accesskey = a

## Extension shortcut management


## Recommended add-ons page


## Add-on actions


## Pending uninstall message bar


## Page headings

addon-page-options-button =
    .title = Goyjinayyaŋ tontoney kul še
