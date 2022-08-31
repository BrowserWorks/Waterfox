# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Abrir uma janela privativa
    .accesskey = p
about-private-browsing-search-placeholder = Pesquisar na web
about-private-browsing-info-title = Você está em uma janela privativa
about-private-browsing-search-btn =
    .title = Pesquisar na internet
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
about-private-browsing-info-description-private-window = Janela privativa: O { -brand-short-name } limpa o histórico de pesquisa e navegação quando você fecha todas as janelas privativas. Isso não torna você anônimo.
about-private-browsing-info-description-simplified = O { -brand-short-name } limpa seu histórico de pesquisa e navegação quando você fecha todas as janelas privativas, mas isso não o torna anônimo.
about-private-browsing-learn-more-link = Saiba mais
about-private-browsing-hide-activity = Oculte sua atividade e localização, onde quer que navegue
about-private-browsing-get-privacy = Tenha proteções de privacidade onde quer que navegue
about-private-browsing-hide-activity-1 = Oculte sua localização e atividade de navegação com o { -mozilla-vpn-brand-name }. Um único clique cria uma conexão segura, mesmo em redes públicas de WiFi.
about-private-browsing-prominent-cta = Proteja sua privacidade com o { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = Instale o { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name }: Navegação privativa em qualquer lugar
about-private-browsing-focus-promo-text = Nosso aplicativo móvel de navegação dedicado à privacidade sempre limpa seu histórico e cookies.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Leve a navegação privativa para seu celular
about-private-browsing-focus-promo-text-b = Use o { -focus-brand-name } naquelas pesquisas privativas que você não quer que seu navegador principal para celular veja.
about-private-browsing-focus-promo-header-c = Privacidade de nível superior em dispositivos móveis
about-private-browsing-focus-promo-text-c = O { -focus-brand-name } limpa o histórico toda vez, além de bloquear anúncios e rastreadores.
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
about-private-browsing-promo-close-button =
    .title = Fechar

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = Liberdade de navegação privativa em apenas um clique
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Manter no Dock
       *[other] Fixar na barra de tarefas
    }
about-private-browsing-pin-promo-title = Não salva cookies nem histórico, direto da sua área de trabalho. Navegue como se ninguém estivesse vendo.
