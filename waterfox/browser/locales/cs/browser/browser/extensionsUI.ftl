# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = Zjistit více
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = Rozšíření { $addonName } chce změnit váš výchozí vyhledávač z { $currentEngine } na { $newEngine }. Chcete tuto změnu provést?
webext-default-search-yes =
    .label = Ano
    .accesskey = A
webext-default-search-no =
    .label = Ne
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = Rozšíření { $addonName } bylo nainstalováno.

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = Spouštět rozšíření { $addonName } na serverech s omezením?
webext-quarantine-confirmation-line-1 = Z důvodu ochrany vašich dat není toto rozšíření na těchto stránkách povoleno.
webext-quarantine-confirmation-line-2 =
    { -vendor-short-name.case-status ->
        [with-cases] Povolte toto rozšíření, pokud mu důvěřujete, aby mohlo číst a měnit vaše data na webech omezených { -vendor-short-name(case: "ins") }.
       *[no-cases] Povolte toto rozšíření, pokud mu důvěřujete, aby mohlo číst a měnit vaše data na webech omezených organizací { -vendor-short-name }.
    }
webext-quarantine-confirmation-allow =
    .label = Povolit
    .accesskey = P
webext-quarantine-confirmation-deny =
    .label = Nepovolit
    .accesskey = N
