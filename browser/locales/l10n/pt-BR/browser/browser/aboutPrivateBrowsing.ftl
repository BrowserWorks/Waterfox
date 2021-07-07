# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Abrir uma janela privativa
    .accesskey = p
about-private-browsing-search-placeholder = Pesquisar na web
about-private-browsing-info-title = Você está em uma janela privativa
about-private-browsing-info-myths = Mitos comuns sobre a navegação privativa
about-private-browsing =
    .title = Pesquisar na web
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Pesquise com { $engine } ou digite um endereço
about-private-browsing-handoff-no-engine =
    .title = Pesquise ou digite um endereço
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Pesquise com { $engine } ou digite um endereço
about-private-browsing-handoff-text-no-engine = Pesquise ou digite um endereço
about-private-browsing-not-private = No momento você não está em uma janela privativa.
about-private-browsing-info-description = O { -brand-short-name } limpa seu histórico de pesquisa e navegação quando você sai do aplicativo ou fecha todas as abas e janelas de navegação privativa. Apesar disso não tornar você anônimo para sites e para seu provedor de serviços de internet, facilita manter o que você faz online privativo para outras pessoas que usam este computador.
about-private-browsing-need-more-privacy = Precisa de mais privacidade?
about-private-browsing-turn-on-vpn = Experimente o { -mozilla-vpn-brand-name }
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } é seu mecanismo de pesquisa padrão em janelas privativas
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Para selecionar outro mecanismo de pesquisa, acesse as <a data-l10n-name="link-options">Opções</a>
       *[other] Para selecionar outro mecanismo de pesquisa, acesse as <a data-l10n-name="link-options">Preferências</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Fechar
