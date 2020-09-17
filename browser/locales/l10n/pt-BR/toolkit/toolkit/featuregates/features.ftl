# This Source Code Form is subject to the terms of the Mozilla Public
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
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = Com esse recurso ativado, o { -brand-short-name } suporta o formato AV1 Image File (AVIF). Este é um formato de arquivo de imagem estática que potencializa as capacidades de algoritmos de compactação de vídeo AV1 para reduzir o tamanho da imagem. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1443863</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Nossa implementação do atributo global <a data-l10n-name="mdn-inputmode">inputmode</a> foi atualizada conforme <a data-l10n-name="whatwg">a especificação WHATWG</a>, mas ainda precisamos fazer outras alterações, como disponibilizar em conteúdo contenteditable. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1205133</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = Web API: <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = O atributo <a data-l10n-name="rel">rel</a> com valor <code>"preload"</code> em um elemento <a data-l10n-name="link">&lt;link&gt;</a> destina-se a ajudar a fornecer ganhos de desempenho, permitindo baixar recursos no início do ciclo de vida da página, garantindo que estejam disponíveis mais cedo e tenham menos probabilidade de bloquear a renderização da página. Leia <a data-l10n-name="readmore">“Pré-carregando conteúdo com <code>rel="preload"</code>”</a> ou consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1583604</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS: Pseudo-class: :focus-visible
experimental-features-css-focus-visible-description = Permite que estilos de foco sejam aplicados a elementos como botões e controles de formulários, apenas quando recebem foco através do teclado (por exemplo, ao mover entre elementos com a tecla Tab), e não quando recebem foco usando um mouse ou outro dispositivo apontador. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1617600</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = Web API: beforeinput Event
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = O evento global <a data-l10n-name="mdn-beforeinput">beforeinput</a> é acionado em elementos <a data-l10n-name="mdn-input">&lt;input&gt;</a> e <a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a>, ou qualquer elemento cujo atributo <a data-l10n-name="mdn-contenteditable">contenteditable</a> esteja ativado, imediatamente antes de alterações no valor do elemento. O evento permite que aplicativos web substituam o comportamento padrão do navegador em interações do usuário. Por exemplo, aplicativos web podem cancelar a entrada do usuário apenas para caracteres específicos, ou modificar a colagem de texto com estilo para apenas estilos aprovados.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = A adição de um construtor à interface <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>, assim como uma variedade de alterações relacionadas, possibilitam criar diretamente novas folhas de estilo sem precisar adicionar a folha ao HTML. Isso facilita muito criar folhas de estilo reusáveis para uso com <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1520690</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = Web API: Media Session API
experimental-features-media-session-api-description = Atualmente, a implementação completa do { -brand-short-name } da Media Session API é experimental. Esta API é usada para personalizar o tratamento de notificações relacionadas a mídia, gerenciar eventos e dados úteis para apresentar uma interface do usuário para gerenciamento de reprodução de mídia e obter metadados de arquivos de mídia. Consulte mais detalhes em <a data-l10n-name="bugzilla">bug 1112032</a>.

experimental-features-devtools-color-scheme-simulation =
    .label = Developer Tools: Simulação de esquema de cores
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

experimental-features-print-preview-tab-modal =
    .label = Novo projeto de visualização de impressão
experimental-features-print-preview-tab-modal-description = Apresenta a visualização de impressão reprojetada e a disponibiliza no macOS. Isso potencialmente introduz problemas e não inclui todas as configurações relacionadas à impressão. Para acessar todas as configurações relacionadas à impressão, selecione “Imprimir usando o diálogo do sistema…” no painel Imprimir.

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

# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = Gráfico: Zoom suave com movimento de pinça com os dedos
experimental-features-graphics-desktop-zooming-description = Ativa o suporte a zoom suave com movimento de pinça com os dedos em telas sensíveis ao toque e em touch pads de precisão.
