# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Abrir uma janela privada
    .accesskey = p
about-private-browsing-search-placeholder = Pesquisar na Web
about-private-browsing-info-title = Está numa janela privada
about-private-browsing-info-myths = Mitos comuns acerca da navegação privada
about-private-browsing =
    .title = Pesquisar na Web
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Pesquisar com { $engine } ou introduzir endereço
about-private-browsing-handoff-no-engine =
    .title = Pesquisar ou introduzir endereço
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Pesquisar com { $engine } ou introduzir endereço
about-private-browsing-handoff-text-no-engine = Pesquisar ou introduzir endereço
about-private-browsing-not-private = Atualmente, não está numa janela privada.
about-private-browsing-info-description = O { -brand-short-name } limpa o seu histórico de pesquisa e navegação quando sai da aplicação ou fecha todos os separadores e janelas de navegação privada. Embora não o torne anónimo(a) para sites ou para o seu provedor de serviço de Internet, isto torna mais fácil manter privado o que faz na Internet de alguém que utilize este computador.
about-private-browsing-need-more-privacy = Precisa de mais privacidade?
about-private-browsing-turn-on-vpn = Experimente a { -mozilla-vpn-brand-name }
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = O { $engineName } é o seu motor de pesquisa predefinido nas 'Janelas Privadas'
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Para selecionar um motor de pesquisa diferente, aceda às <a data-l10n-name="link-options">Opções</a>
       *[other] Para selecionar um motor de pesquisa diferente, aceda às <a data-l10n-name="link-options">Preferências</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Fechar
