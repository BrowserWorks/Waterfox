# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Отваряне на поверителен прозорец
    .accesskey = О
about-private-browsing-search-placeholder = Търсене в интернет
about-private-browsing-info-title = Вие сте в поверителен прозорец
about-private-browsing-info-myths = Разпространени легенди относно поверителното разглеждане
about-private-browsing =
    .title = Търсене в интернет
about-private-browsing-not-private = В момента не сте в поверителен прозорец.
about-private-browsing-info-description = { -brand-short-name } изчиства историята на търсенето и разглеждането, когато излезете от приложението или затворите всички раздели и прозорци в поверително разглеждане. Въпреки че това не ви прави анонимни за уеб сайтовете или доставчиците на интернет услуги, това улеснява запазването анонимността на вашите действия онлайн, от останалите ползващи същия компютър.

# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } е вашата търсеща машина по подразбиране в поверителните прозорци
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] За да изберете друга търсеща машина, отидете на <a data-l10n-name="link-options">Настройки</a>
       *[other] За да изберете друга търсачка, отидете на <a data-l10n-name="link-options">Предпочитания</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Затваряне
