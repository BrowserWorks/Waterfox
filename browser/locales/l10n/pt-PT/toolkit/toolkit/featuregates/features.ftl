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
experimental-features-media-jxl =
    .label = Media: JPEG XL
experimental-features-media-jxl-description = Com esta funcionalidade ativada, o { -brand-short-name } suporta o formato JPEG XL (JXL). Este é um formato de ficheiro de imagem melhorado que suporta uma transição sem perda dos ficheiros JPEG tradicionais. Consulte o <a data-l10n-name="bugzilla">bug 1539075</a> para mais detalhes.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = API da Web: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = A nossa implementação do atributo global <a data-l10n-name="mdn-inputmode">inputmode</a> foi atualizada de acordo com <a data-l10n-name="whatwg">a especificação WHATWG</a>, mas ainda precisamos de fazer outras alterações, como disponibilizar o mesmo em conteúdo editável. Consulte o <a data-l10n-name="bugzilla">bug 1205133</a> para obter mais detalhes.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Para além de um construtor para o interface <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>, bem como várias alterações relacionadas, tornam possível a criação direta de novas folhas de estilos sem ter de adicionar a folha ao HTML. Isto faz com que seja muito mais fácil criar folhas de estilo reutilizáveis para utilização no <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Consulte o <a data-l10n-name="bugzilla">bug 1520690</a> para mais detalhes.
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
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = WebRTC Global Mute Toggles
experimental-features-webrtc-global-mute-toggles-description = Adicionar controlos ao indicador global de partilha do WebRTC que permite que os utilizadores silenciem globalmente fontes como o microfone ou a câmara.
# Win32k Lockdown
experimental-features-win32k-lockdown =
    .label = Bloqueio Win32k
experimental-features-win32k-lockdown-description = Desativar a utilização da API Win32k nos separadores do navegador. Fornece um incremento de segurança, mas atualmente pode ser instável ou ter falhas. (Somente no Windows)
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Ativa o Warp, um projeto para melhorar a performance do JavaScript e utilização de memória.
# Fission is the name of the feature and should not be translated.
experimental-features-fission =
    .label = Fission (isolamento de sites)
experimental-features-fission-description = O Fission (isolamento de sites) é um recurso experimental do { -brand-short-name } para fornecer uma camada adicional de defesa contra problemas de segurança. Ao isolar cada site num processo independente, o Fission torna mais difícil aos sites maliciosos obter acesso às informações de outras páginas que você esteja a visitar. Esta é uma grande mudança da arquitetura do { -brand-short-name } e agradecemos que teste e reporte quaisquer problemas que possa encontrar. Para obter mais detalhes, consulte <a data-l10n-name="wiki">a wiki</a>.
# Support for having multiple Picture-in-Picture windows open simultaneously
experimental-features-multi-pip =
    .label = Suporte a múltiplos vídeos em janelas flutuantes
experimental-features-multi-pip-description = Suporte experimental para permitir que múltiplos vídeos possam ser abertos em várias janelas flutuantes em simultâneo.
experimental-features-http3 =
    .label = Protocolo HTTP/3
experimental-features-http3-description = Suporte experimental para o protocolo HTTP/3.
# Search during IME
experimental-features-ime-search =
    .label = Barra de endereços: mostrar resultados durante a composição do IME
experimental-features-ime-search-description = Um IME (Input Method Editor - editor do método de introdução) é uma ferramenta que lhe permite inserir símbolos complexos, como os utilizados em idiomas escritos do Leste Asiático ou Índico, utilizando um teclado padrão. Ativar esta experiência irá manter o painel da barra de endereço aberto, mostrando resultados e sugestões de pesquisa, enquanto utiliza o IME para inserir texto. Note que o IME pode mostrar um painel que se sobrepõe aos resultados da barra de endereço, portanto, esta preferência apenas é sugerida para o IME que não utilize este tipo de painel.
