# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = Ativa o suporte para o recurso experimental CSS Masonry Layout. Consulte o <a data-l10n-name="explainer">explicador</a> para obter uma descrição de alto nível do recurso. Para fornecer feedback, comente <a data-l10n-name="w3c-issue">neste problema no GitHub</a> ou <a data-l10n-name="bug">neste bug</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-cascade-layers =
    .label = CSS: Cascade Layers
experimental-features-css-cascade-layers-description = Ativa o suporte ao CSS Cascade Layers. Consulte detalhes na <a data-l10n-name="spec">especificação (em andamento)</a>. Registre erros relacionados a este recurso em <a data-l10n-name="bugzilla">bug 1699215</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = Esta nova API fornece suporte de baixo nível para a execução de computação e renderização gráfica usando a <a data-l10n-name="wikipedia">Unidade de processamento gráfico (GPU)</a>) do dispositivo ou computador do usuário. A <a data-l10n-name="spec">especificação</a> ainda é um trabalho em andamento. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1602129</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = Com esse recurso ativado, o { -brand-short-name } suporta o formato AV1 Image File (AVIF). Este é um formato de arquivo de imagem estática que potencializa as capacidades de algoritmos de compactação de vídeo AV1 para reduzir o tamanho da imagem. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1443863</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = Media: JPEG XL
experimental-features-media-jxl-description = Com este recurso ativado, o { -brand-short-name } oferece suporte ao formato JPEG XL (JXL). Este é um formato de arquivo de imagem aprimorado que suporta transição sem perdas a partir de arquivos JPEG tradicionais. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1539075</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Nossa implementação do atributo global <a data-l10n-name="mdn-inputmode">inputmode</a> foi atualizada conforme <a data-l10n-name="whatwg">a especificação WHATWG</a>, mas ainda precisamos fazer outras alterações, como disponibilizar em conteúdo contenteditable. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1205133</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = A adição de um construtor à interface <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>, assim como uma variedade de alterações relacionadas, possibilitam criar diretamente novas folhas de estilo sem precisar adicionar a folha ao HTML. Isso facilita muito criar folhas de estilo reusáveis para uso com <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1520690</a>.
experimental-features-devtools-color-scheme-simulation =
    .label = Ferramentas de desenvolvimento: Simulação de esquema de cores
experimental-features-devtools-color-scheme-simulation-description = Adiciona uma opção para simular diferentes esquemas de cores, permitindo testar consultas de mídia <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-scheme</a>. O uso desta consulta de mídia permite que sua folha de estilo responda à preferência do usuário de uma interface de usuário clara ou escura. Este recurso permite que você teste seu código sem precisar alterar configurações em seu navegador (ou sistema operacional, se o navegador seguir uma configuração de esquema de cores do sistema todo). Consulte mais detalhes em <a data-l10n-name="bugzilla1">bug 1550804</a> e <a data-l10n-name="bugzilla2">bug 1137699</a>.
experimental-features-devtools-execution-context-selector =
    .label = Developer Tools: Seletor de contexto de execução
experimental-features-devtools-execution-context-selector-description = Esse recurso exibe um botão na linha de comando do console que permite alterar o contexto em que a expressão inserida será executada. Consulte mais detalhes em <a data-l10n-name="bugzilla1">bug 1605154</a> e <a data-l10n-name="bugzilla2">bug 1605153</a>.
experimental-features-devtools-compatibility-panel =
    .label = Developer Tools: Painel de compatibilidade
experimental-features-devtools-compatibility-panel-description = Um painel lateral no inspetor de páginas que mostra informações que detalham o status de compatibilidade entre navegadores do seu aplicativo. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1584464</a>.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Cookies: SameSite=Lax por padrão
experimental-features-cookie-samesite-lax-by-default2-description = Tratar cookies por padrão como "SameSite=Lax", se nenhum atributo "SameSite" for especificado. Os desenvolvedores devem aceitar o status quo atual de uso irrestrito, impondo explicitamente "SameSite=None".
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Cookies: SameSite=None requer atributo seguro
experimental-features-cookie-samesite-none-requires-secure2-description = Cookies com o atributo "SameSite=None" requerem o atributo seguro. Esse recurso requer "Cookies: SameSite=Lax por padrão".
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = cache de inicialização de about:home
experimental-features-abouthome-startup-cache-description = Um cache para o documento inicial about:home, carregado por padrão ao iniciar. O objetivo do cache é melhorar o desempenho da inicialização.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookies: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Tratar cookies do mesmo domínio, mas com esquemas diferentes (por exemplo, http://example.com e https://example.com) como cross-site em vez de same-site. Melhora a segurança, mas pode potencialmente introduzir problemas.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Developer Tools: Debug de Service Worker
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Ativa o suporte experimental de Service Workers no painel Debugger. Este recurso pode tornar o Developer Tools mais lento e aumentar o consumo de memória.
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = Ativar/desativar som WebRTC globalmente
experimental-features-webrtc-global-mute-toggles-description = Adiciona controles ao indicador de compartilhamento global WebRTC, permitindo ao usuário silenciar globalmente seu microfone e câmera.
# Win32k Lockdown
experimental-features-win32k-lockdown =
    .label = Confinamento de Win32k
experimental-features-win32k-lockdown-description = Desativar o uso de APIs Win32k nas abas do navegador. Fornece um aumento na segurança, mas no momento pode apresentar instabilidade ou falhas (apenas em Windows).
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Ativar Warp, um projeto para melhorar o desempenho e uso de memória do JavaScript.
# Fission is the name of the feature and should not be translated.
experimental-features-fission =
    .label = Fission (isolamento de sites)
experimental-features-fission-description = Fission (isolamento de sites) é um recurso experimental no { -brand-short-name } para fornecer uma camada adicional de defesa contra falhas de segurança. Ao isolar cada site em um processo separado, o Fission dificulta a sites maliciosos obter acesso a informações de outras páginas que você está visitando. Esta é uma grande mudança de arquitetura no { -brand-short-name }, então agradecemos por testar e relatar qualquer problema que encontrar. Consulte mais detalhes no <a data-l10n-name="wiki">wiki</a>.
# Support for having multiple Picture-in-Picture windows open simultaneously
experimental-features-multi-pip =
    .label = Suporte a vários Picture-in-Picture
experimental-features-multi-pip-description = Suporte experimental para permitir que várias janelas Picture-in-Picture sejam abertas ao mesmo tempo.
# Search during IME
experimental-features-ime-search =
    .label = Barra de endereços: Mostrar resultados durante a composição IME
experimental-features-ime-search-description = Um IME (Input Method Editor, ou editor de método de entrada) é uma ferramenta que permite inserir símbolos complexos, como os usados em idiomas escritos do subcontinente indiano ou do leste asiático, usando um teclado padrão. Ativar este experimento faz com que o painel da barra de endereços se mantenha aberto, mostrando resultados e sugestões de pesquisa ao usar o IME para inserir texto. Note que o IME pode exibir um painel que cubra os resultados da barra de endereços, portanto essa preferência é sugerida apenas para IME que não usa esse tipo de painel.
