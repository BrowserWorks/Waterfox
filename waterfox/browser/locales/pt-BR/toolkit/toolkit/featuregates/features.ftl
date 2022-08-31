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
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = Esta nova API fornece suporte de baixo nível para a execução de computação e renderização gráfica usando a <a data-l10n-name="wikipedia">Unidade de processamento gráfico (GPU)</a>) do dispositivo ou computador do usuário. A <a data-l10n-name="spec">especificação</a> ainda é um trabalho em andamento. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1602129</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = Media: JPEG XL
experimental-features-media-jxl-description = Com este recurso ativado, o { -brand-short-name } oferece suporte ao formato JPEG XL (JXL). Este é um formato de arquivo de imagem aprimorado que suporta transição sem perdas a partir de arquivos JPEG tradicionais. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1539075</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = A adição de um construtor à interface <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>, assim como uma variedade de alterações relacionadas, possibilitam criar diretamente novas folhas de estilo sem precisar adicionar a folha ao HTML. Isso facilita muito criar folhas de estilo reusáveis para uso com <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1520690</a>.
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
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Ativar Warp, um projeto para melhorar o desempenho e uso de memória do JavaScript.
# Search during IME
experimental-features-ime-search =
    .label = Barra de endereços: Mostrar resultados durante a composição IME
experimental-features-ime-search-description = Um IME (Input Method Editor, ou editor de método de entrada) é uma ferramenta que permite inserir símbolos complexos, como os usados em idiomas escritos do subcontinente indiano ou do leste asiático, usando um teclado padrão. Ativar este experimento faz com que o painel da barra de endereços se mantenha aberto, mostrando resultados e sugestões de pesquisa ao usar o IME para inserir texto. Note que o IME pode exibir um painel que cubra os resultados da barra de endereços, portanto essa preferência é sugerida apenas para IME que não usa esse tipo de painel.
# Text recognition for images
experimental-features-text-recognition =
    .label = Reconhecimento de texto
experimental-features-text-recognition-description = Ativar recursos para reconhecer texto em imagens.
experimental-features-accessibility-cache =
    .label = Cache de acessibilidade
experimental-features-accessibility-cache-description = Armazena em cache todas as informações de acessibilidade de todos os documentos no processo principal do { -brand-short-name }. Isso melhora o desempenho de leitores de tela e outros aplicativos que usam APIs de acessibilidade.
