# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Layout Masonry
experimental-features-css-masonry-description = Ativa o suporte ao recurso experimental de layout Masonry no CSS. Consulte a <a data-l10n-name="explainer">explicação</a> para obter uma descrição de alto nível do recurso. Para fornecer feedback, comente <a data-l10n-name="w3c-issue">este problema do GitHub</a> ou <a data-l10n-name="bug">este bug</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = API da Web: WebGPU
experimental-features-web-gpu-description2 = Esta nova API fornece suporte de baixo nível para computação de alto desempenho e renderização gráfica utilizando a <a data-l10n-name="wikipedia">unidade de processamento gráfico (GPU)</a> do dispositivo ou computador do utilizador. A <a data-l10n-name="spec">especificação</a> ainda está em desenvolvimento. Consulte o <a data-l10n-name="bugzilla">bug 1602129</a> para mais detalhes.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = Com esta funcionalidade ativada, o { -brand-short-name } suporta o formato de ficheiro de imagem AV1 (AVIF). Este é um formato de ficheiro de imagem estática que aproveita os recursos dos algoritmos de compactação de vídeo AV1 para reduzir o tamanho da imagem. Consulte o <a data-l10n-name="bugzilla">bug 1443863</a> para obter mais detalhes.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = API da Web: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = A nossa implementação do atributo global <a data-l10n-name="mdn-inputmode">inputmode</a> foi atualizada de acordo com <a data-l10n-name="whatwg">a especificação WHATWG</a>, mas ainda precisamos de fazer outras alterações, como disponibilizar o mesmo em conteúdo editável. Consulte o <a data-l10n-name="bugzilla">bug 1205133</a> para obter mais detalhes.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = API da Web: <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = O atributo <a data-l10n-name="rel">rel</a> com o valor <code>"preload"</code> num elemento <a data-l10n-name="link">&lt;link&gt;</a> destina-se a ajudar a fornecer melhorias de desempenho, permitindo que descarregue recursos no início do ciclo de vida da página, garantindo que estes estejam disponíveis mais cedo e tenham uma probabilidade inferior de bloquear a renderização da página. Consulte <a data-l10n-name="readmore">“Pré-carregamento de conteúdo com o <code>rel="preload"</code>”</a> ou consulte o <a data-l10n-name="bugzilla">bug 1583604</a> para mais detalhes.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS: Pseudo-classe: :focus-visible
experimental-features-css-focus-visible-description = Permite que os estilos de foco sejam aplicados a elementos como botões e controlos de formulário, apenas quando estes são focados utilizando o teclado (por exemplo, ao tabular entre elementos) e não quando estes são focados utilizando um rato ou outro dispositivo apontador. Consulte o <a data-l10n-name="bugzilla">bug 1617600</a> para obter mais detalhes.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = API da Web: evento beforeinput
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = O evento global <a data-l10n-name="mdn-beforeinput">beforeinput</a> é acionado em elementos <a data-l10n-name="mdn-input">&lt;input&gt;</a> e <a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a>, ou qualquer outro elemento cujo atributo <a data-l10n-name="mdn-contenteditable">contenteditable</a> esteja ativado, imediatamente antes do valor do elemento ser alterado. O evento permite que as aplicações de Internet substituam o comportamento predefinido do navegador para a interação com o utilizador, por exemplo, as aplicações de Internet podem limitar a introdução de carateres por parte do utilizador apenas para caracteres específicos ou modificar os estilos do texto colado para limitar os mesmos apenas aos estilos autorizados.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Para além de um construtor para o interface <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>, bem como várias alterações relacionadas, tornam possível a criação direta de novas folhas de estilos sem ter de adicionar a folha ao HTML. Isto faz com que seja muito mais fácil criar folhas de estilo reutilizáveis para utilização no <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Consulte o <a data-l10n-name="bugzilla">bug 1520690</a> para mais detalhes.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = API da Web: Media Session API
experimental-features-media-session-api-description = Atualmente, toda a implementação do { -brand-short-name } da Media Session API é experimental. Esta API é utilizada para personalizar o tratamento de notificações relacionadas com media, gerir eventos e dados úteis para apresentar uma interface de utilizador para gerir a reprodução de media e obter metadados de ficheiros de media. Consulte o <a data-l10n-name="bugzilla">bug 1112032</a> para mais detalhes.

experimental-features-devtools-color-scheme-simulation =
    .label = Ferramentas de programação: Simulação de esquema de cores
experimental-features-devtools-color-scheme-simulation-description = Adiciona uma opção para simular diferentes esquemas de cores, permitindo testar media queries <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-scheme</a>. A utilização desta consulta de media permite que a folha de estilo indique se o utilizador prefere uma interface de utilizador clara ou escura. Este recurso permite que você teste o seu código sem precisar de alterar as configurações do seu navegador (ou sistema operativo, se o navegador seguir uma configuração de esquema de cores global do sistema). Consulte o <a data-l10n-name="bugzilla1">bug 1550804</a> e o <a data-l10n-name="bugzilla2">bug 1137699</a> para obter mais detalhes.

experimental-features-devtools-execution-context-selector =
    .label = Ferramentas de programação: Seletor do contexto de execução
experimental-features-devtools-execution-context-selector-description = Esta funcionalidade mostra um botão na linha de comando da consola que permite alterar o contexto em que a expressão inserida será executada. Consulte o <a data-l10n-name="bugzilla1">bug 1605154</a> e o <a data-l10n-name="bugzilla2">bug 1605153</a> para obter mais detalhes.

experimental-features-devtools-compatibility-panel =
    .label = Ferramentas de programação: Painel de compatibilidade
experimental-features-devtools-compatibility-panel-description = Um painel lateral para o Inspetor de página que mostra informações que detalham o estado de compatibilidade da sua aplicação entre navegadores. Consulte o <a data-l10n-name="bugzilla">bug 1584464</a> para obter mais detalhes.

# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Cookies: SameSite=Lax por predefinição
experimental-features-cookie-samesite-lax-by-default2-description = Tratar as cookies como "SameSite=Lax" por predefinição, se nenhum atributo "SameSite" for especificado. Os programadores devem aceitar o estado atual da utilização sem restrições especificando, explicitamente, "SameSite=None".

# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Cookies: SameSite=None requer atributo seguro
experimental-features-cookie-samesite-none-requires-secure2-description = As cookies com o atributo "SameSite=None" requerem o atributo seguro. Este recurso requer "Cookies: SameSite=Lax por predefinição".

# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = Cache de arranque de about:home
experimental-features-abouthome-startup-cache-description = Uma cache para o documento about:home inicial carregado por predefinição na inicialização. O objetivo da cache é melhorar o desempenho da inicialização.

experimental-features-print-preview-tab-modal =
    .label = Redesenho da pré-visualização da impressão
experimental-features-print-preview-tab-modal-description = Apresenta o redesenho da pré-visualização da impressão e disponibiliza a pré-visualização da impressão no macOS. Potencialmente isto introduz falhas e não inclui todas as configurações relacionadas com a impressão. Para aceder a todas as configurações relacionadas com a impressão, selecione “Imprimir utilizando a janela do sistema…” no painel de Impressão.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookies: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Tratar os cookies do mesmo domínio, mas com esquemas diferentes (por exemplo, http://example.com e https://example.com) como inter-sites em vez do mesmo site. Melhora a segurança mas, potencialmente, introduz falhas.

# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Ferramentas de programação: Depuração de service worker
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Ativa o suporte experimental para Service Workers no painel Depurador. Este recurso pode diminuir a velocidade das Ferramentas de programação e aumentar o consumo de memória.

# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = Gráficos: Zoom suave com os dedos
experimental-features-graphics-desktop-zooming-description = Ativar o suporte para um zoom suave ao beliscar em ecrãs sensíveis ao toque e em touchpads de precisão.
