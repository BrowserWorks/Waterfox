# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings appear in the Unified Extensions panel.


## Panel

unified-extensions-header-title = Rozšíření
unified-extensions-manage-extensions =
    .label = Správa rozšíření

## An extension in the main list

# Each extension in the unified extensions panel (list) has a secondary button
# to open a context menu. This string is used for each of these buttons.
# Variables:
#   $extensionName (String) - Name of the extension
unified-extensions-item-open-menu =
    .aria-label = Otevřít nabídku pro { $extensionName }
unified-extensions-item-message-manage = Nastavení tohoto rozšíření

## Extension's context menu

unified-extensions-context-menu-pin-to-toolbar =
    .label = Připnout na lištu
unified-extensions-context-menu-manage-extension =
    .label = Nastavení tohoto rozšíření
unified-extensions-context-menu-remove-extension =
    .label = Odebrat rozšíření
unified-extensions-context-menu-report-extension =
    .label = Nahlásit rozšíření
unified-extensions-context-menu-move-widget-up =
    .label = Posunout výše
unified-extensions-context-menu-move-widget-down =
    .label = Posunout níže

## Notifications

unified-extensions-mb-quarantined-domain-title = Některá rozšíření nejsou povolena
unified-extensions-mb-quarantined-domain-message =
    { -vendor-short-name.case-status ->
        [with-cases] Kvůli ochraně vašich dat jsou na tomto webu povolena pouze některá rozšíření monitorovaná { -vendor-short-name(case: "ins") }.
       *[no-cases] Kvůli ochraně vašich dat jsou na tomto webu povolena pouze některá rozšíření monitorovaná organizací { -vendor-short-name }.
    }
unified-extensions-mb-quarantined-domain-message-2 =
    { -vendor-short-name.gender ->
        [masculine] V zájmu ochrany vašich údajů nemohou některá rozšíření číst nebo měnit údaje na této stránce. V nastavení rozšíření můžete povolit přístup na stránkách, na kterých { -vendor-short-name } zavedl omezení.
        [feminine] V zájmu ochrany vašich údajů nemohou některá rozšíření číst nebo měnit údaje na této stránce. V nastavení rozšíření můžete povolit přístup na stránkách, na kterých { -vendor-short-name } zavedla omezení.
        [neuter] V zájmu ochrany vašich údajů nemohou některá rozšíření číst nebo měnit údaje na této stránce. V nastavení rozšíření můžete povolit přístup na stránkách, na kterých { -vendor-short-name } zavedlo omezení.
       *[no-cases] V zájmu ochrany vašich údajů nemohou některá rozšíření číst nebo měnit údaje na této stránce. V nastavení rozšíření můžete povolit přístup na stránkách, na kterých organizace { -vendor-short-name } zavedla omezení.
    }
