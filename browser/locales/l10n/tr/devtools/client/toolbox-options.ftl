# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Varsayılan geliştirici araçları

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Geçerli araç kutusu hedefinde desteklenmiyor

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Eklentiler tarafından kurulan geliştirici araçları

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Kullanılabilir araç kutusu düğmeleri

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Temalar

## Inspector section

# The heading
options-context-inspector = Denetçi

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Tarayıcı stillerini göster
options-show-user-agent-styles-tooltip =
    .title = Bunu açarsanız tarayıcı tarafından yüklenen varsayılan stiller gösterilir.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = DOM özniteliklerini kısalt
options-collapse-attrs-tooltip =
    .title = Denetçideki uzun öznitelikleri kısaltır

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Varsayılan renk birimi
options-default-color-unit-authored = Yazıldığı gibi
options-default-color-unit-hex = On altılık
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Renk adları

## Style Editor section

# The heading
options-styleeditor-label = Stil editörü

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = CSS’i otomatik tamamla
options-stylesheet-autocompletion-tooltip =
    .title = Stil editöründe siz yazdıkça CSS niteliklerini, değerleri ve seçicileri otomatik tamamlar

## Screenshot section

# The heading
options-screenshot-label = Ekran görüntüsü davranışı

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Ekran görüntüsü panoya
options-screenshot-clipboard-tooltip =
    .title = Ekran görüntüsünü doğrudan panoya kaydeder

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Fotoğraf çekme sesini çal
options-screenshot-audio-tooltip =
    .title = Ekran görüntüsü alırken fotoğraf çekme sesini oynatır

## Editor section

# The heading
options-sourceeditor-label = Editör tercihleri

options-sourceeditor-detectindentation-tooltip =
    .title = Kaynak içeriğe dayanarak girintilemeyi tahmin et
options-sourceeditor-detectindentation-label = Girintilemeyi tespit et
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Kapatma parantezlerini otomatik ekle
options-sourceeditor-autoclosebrackets-label = Parantezleri otomatik kapat
options-sourceeditor-expandtab-tooltip =
    .title = Tab karakteri yerine boşluk kullan
options-sourceeditor-expandtab-label = Boşluk kullanarak girinti ver
options-sourceeditor-tabsize-label = Sekme boyutu
options-sourceeditor-keybinding-label = Kısayol tuşları
options-sourceeditor-keybinding-default-label = Varsayılan

## Advanced section

# The heading
options-context-advanced-settings = Gelişmiş ayarlar

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = HTTP önbelleğini kapat (araç kutusu açıkken)
options-disable-http-cache-tooltip =
    .title = Bu seçeneği açarsanız araç kutusunun açık olduğu tüm sekmelerde HTTP önbelleği devre dışı kalacaktır. Bu seçenek Service Worker’ları etkilemez.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = JavaScript’i devre dışı bırak *
options-disable-javascript-tooltip =
    .title = Bu seçeneği açarsanız geçerli sekmede JavaScript devre dışı bırakılır. Sekme veya araç kutusu kapatılırsa bu ayar unutulacaktır.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Tarayıcı chrome’u ve eklenti hata ayıklama araç kutularını etkinleştir
options-enable-chrome-tooltip =
    .title = Bu seçeneği açarsanız tarayıcı bağlamında çeşitli geliştirici araçlarını (Araçlar > Web Geliştirici > Tarayıcı araç kutusu aracılığıyla) ve Eklenti Yöneticisi’nde hata ayıklama eklentilerini kullanabilirsiniz

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Uzaktan hata ayıklamayı etkinleştir
options-enable-remote-tooltip2 =
    .title = Bu seçeneği açarsanız bu tarayıcıda uzaktan hata ayıklamaya izin verilir

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = HTTP üzerinden Service Worker’ları etkinleştir (araç kutusu açıkken)
options-enable-service-workers-http-tooltip =
    .title = Bu seçeneği açarsanız, araç kutusunun açık olduğu tüm sekmelerde HTTP üzerinden Service Workers etkinleşir.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Kaynak haritalarını etkinleştir
options-source-maps-tooltip =
    .title = Bu seçeneği etkinleştirirseniz kaynaklar araçlarda haritalanacaktır.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Yalnızca bu oturumda geçerli, sayfayı yeniden yükler

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Gecko platform verilerini göster
options-show-platform-data-tooltip =
    .title = Bu seçeneği etkinleştirirseniz JavaScript Profilleyici raporlarına Gecko platform simgeleri eklenecektir
