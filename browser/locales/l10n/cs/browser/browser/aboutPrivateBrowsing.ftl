# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Otevřít anonymní okno
    .accesskey = a
about-private-browsing-search-placeholder = Vyhledat na webu
about-private-browsing-info-title = Jste v anonymním okně
about-private-browsing-info-myths = Časté omyly o fungování anonymního prohlížení
about-private-browsing =
    .title = Vyhledat na webu
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Zadejte webovou adresu nebo dotaz pro vyhledávač { $engine }
about-private-browsing-handoff-no-engine =
    .title = Zadejte webovou adresu nebo dotaz pro vyhledávač
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Zadejte webovou adresu nebo dotaz pro vyhledávač { $engine }
about-private-browsing-handoff-text-no-engine = Zadejte webovou adresu nebo dotaz pro vyhledávač
about-private-browsing-not-private = Nyní nejste v anonymním okně.
about-private-browsing-info-description =
    { -brand-short-name } vymaže vaši historii vyhledávání a navštívených stránek po ukončení aplikace nebo zavření všech anonymních panelů a oken.
    
    S touto funkcí nejste na internetu zcela neviditelní a např. poskytovatel připojení k internetu může stále zjistit, které stránky navštěvujete. Vaše aktivita na internetu ale zůstane utajena před dalšími uživateli tohoto počítače.
about-private-browsing-need-more-privacy = Potřebujete více soukromí?
about-private-browsing-turn-on-vpn = Vyzkoušejte { -mozilla-vpn-brand-name(case: "acc") }
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = Pro režim anonymního prohlížení máte jako výchozí nastavený vyhledávač { $engineName }.
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Nastavení výchozího vyhledávače můžete změnit v <a data-l10n-name="link-options">Možnostech</a>
       *[other] Nastavení výchozího vyhledávače můžete změnit v <a data-l10n-name="link-options">Předvolbách</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Zavřít
