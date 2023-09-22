# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = Importar dados do navegador
migration-wizard-selection-list = Selecione os dados que pretende importar.
# Shown in the new migration wizard's dropdown selector for choosing the browser
# to import from. This variant is shown when the selected browser doesn't support
# user profiles, and so we only show the browser name.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
migration-wizard-selection-option-without-profile = { $sourceBrowser }
# Shown in the new migration wizard's dropdown selector for choosing the browser
# and user profile to import from. This variant is shown when the selected browser
# supports user profiles.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
#  $profileName (String): the name of the user profile to import from.
migration-wizard-selection-option-with-profile = { $sourceBrowser } — { $profileName }

# Each migrator is expected to include a display name string, and that display
# name string should have a key with "migration-wizard-migrator-display-name-"
# as a prefix followed by the unique identification key for the migrator.

migration-wizard-migrator-display-name-brave = Brave
migration-wizard-migrator-display-name-canary = Chrome Canary
migration-wizard-migrator-display-name-chrome = Chrome
migration-wizard-migrator-display-name-chrome-beta = Chrome Beta
migration-wizard-migrator-display-name-chrome-dev = Chrome Dev
migration-wizard-migrator-display-name-chromium = Chromium
migration-wizard-migrator-display-name-chromium-360se = 360 Secure Browser
migration-wizard-migrator-display-name-chromium-edge = Microsoft Edge
migration-wizard-migrator-display-name-chromium-edge-beta = Microsoft Edge Beta
migration-wizard-migrator-display-name-edge-legacy = Microsoft Edge Legacy
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-file-password-csv = Palavras-passe do ficheiro CSV
migration-wizard-migrator-display-name-file-bookmarks = Marcadores de ficheiro HTML
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = Importar todos os dados disponíveis
migration-no-selected-data-label = Nenhum dado selecionado para importação
migration-selected-data-label = Importar dados selecionados

##

migration-select-all-option-label = Selecionar tudo
migration-bookmarks-option-label = Marcadores
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = Favoritos
migration-logins-and-passwords-option-label = Credenciais e palavras-passe guardadas
migration-history-option-label = Histórico de navegação
migration-extensions-option-label = Extensões
migration-form-autofill-option-label = Dados de preenchimento automático de formulários
migration-payment-methods-option-label = Métodos de pagamento
migration-cookies-option-label = Cookies
migration-session-option-label = Janelas e separadores
migration-otherdata-option-label = Outros dados
migration-passwords-from-file-progress-header = Importar ficheiro de Palavras-passe
migration-passwords-from-file-success-header = Palavras-passe importadas com sucesso
migration-passwords-from-file = A verificar palavras-passe no ficheiro
migration-passwords-new = Novas palavras-passe
migration-passwords-updated = Palavras-passe existentes
migration-passwords-from-file-no-valid-data = O ficheiro não inclui quaisquer dados de palavras-passe válidos. Escolha outro ficheiro.
migration-passwords-from-file-picker-title = Importar ficheiro de palavras-passe
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] Ficheiro CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] Documento TSV
       *[other] Ficheiro TSV
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords =
    { $newEntries ->
        [one] { $newEntries } adicionada
       *[other] { $newEntries } adicionadas
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords =
    { $updatedEntries ->
        [one] { $updatedEntries } atualizada
       *[other] { $updatedEntries } atualizadas
    }
migration-bookmarks-from-file-picker-title = Importar ficheiro de Marcadores
migration-bookmarks-from-file-progress-header = A importar Marcadores…
migration-bookmarks-from-file = Marcadores
migration-bookmarks-from-file-success-header = Marcadores importados com sucesso
migration-bookmarks-from-file-no-valid-data = O ficheiro não inclui quaisquer dados de marcadores. Escolha outro ficheiro.
# A description for the .html file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-html-filter-title =
    { PLATFORM() ->
        [macos] Documento HTML
       *[other] Ficheiro HTML
    }
# A description for the .json file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-json-filter-title = Ficheiro JSON
# Shown in the migration wizard after importing bookmarks from a file
# has completed.
#
# Variables:
#  $newEntries (Number): the number of imported bookmarks.
migration-wizard-progress-success-new-bookmarks =
    { $newEntries ->
        [one] { $newEntries } marcador
       *[other] { $newEntries } marcadores
    }
migration-import-button-label = Importar
migration-choose-to-import-from-file-button-label = Importar de um Ficheiro
migration-import-from-file-button-label = Selecionar Ficheiro
migration-cancel-button-label = Cancelar
migration-done-button-label = Concluído
migration-continue-button-label = Continuar
migration-wizard-import-browser-no-browsers = O { -brand-short-name } não conseguiu encontrar nenhum programa que contenha dados de marcadores, histórico ou palavras-passe.
migration-wizard-import-browser-no-resources = Ocorreu um erro. O { -brand-short-name } não conseguiu importar nenhum dado desse perfil de navegador.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = marcadores
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = favoritos
migration-list-password-label = palavras-passe
migration-list-history-label = histórico
migration-list-extensions-label = extensões
migration-list-autofill-label = dados de preenchimento automático
migration-list-payment-methods-label = métodos de pagamento

##

migration-wizard-progress-header = A importar dados
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = Dados importados com sucesso
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = Importação de dados concluída
migration-wizard-progress-icon-in-progress =
    .aria-label = A importar…
migration-wizard-progress-icon-completed =
    .aria-label = Concluído
migration-safari-password-import-header = Importar palavras-passe do Safari
migration-safari-password-import-steps-header = Para importar palavras-passe do Safari:
migration-safari-password-import-step1 = No Safari, abra o menu “Safari” e aceda a Preferências > Palavras-passe
migration-safari-password-import-step2 = Selecione o botão <img data-l10n-name="safari-icon-3dots"/> e escolha “Exportar todas as palavras-passe”
migration-safari-password-import-step3 = Guardar ficheiro de palavras-passe
migration-safari-password-import-step4 = Utilize “Selecionar ficheiro” abaixo para escolher o ficheiro de palavras-passe que guardou
migration-safari-password-import-skip-button = Ignorar
migration-safari-password-import-select-button = Selecionar ficheiro
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks =
    { $quantity ->
        [one] { $quantity } marcador
       *[other] { $quantity } marcadores
    }
# Shown in the migration wizard after importing bookmarks from either
# Internet Explorer or Edge.
#
# Use the same terminology if the browser is available in your language.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-favorites =
    { $quantity ->
        [one] { $quantity } favorito
       *[other] { $quantity } favoritos
    }

## The import process identifies extensions installed in other supported
## browsers and installs the corresponding (matching) extensions compatible
## with Waterfox, if available.

# Shown in the migration wizard after importing all matched extensions
# from supported browsers.
#
# Variables:
#   $quantity (Number): the number of successfully imported extensions
migration-wizard-progress-success-extensions =
    { $quantity ->
        [one] { $quantity } extensão
       *[other] { $quantity } extensões
    }
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions = { $matched } de { $quantity } extensões
migration-wizard-progress-extensions-support-link = Saiba como o { -brand-product-name } corresponde as extensões
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = Sem extensões correspondentes
migration-wizard-progress-extensions-addons-link = Explore as extensões para o { -brand-short-name }

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords =
    { $quantity ->
        [one] { $quantity } palavra-passe
       *[other] { $quantity } palavras-passe
    }
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] Do último dia
       *[other] Dos últimos { $maxAgeInDays } dias
    }
migration-wizard-progress-success-formdata = Histórico de formulários
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods =
    { $quantity ->
        [one] { $quantity } método de pagamento
       *[other] { $quantity } métodos de pagamento
    }
migration-wizard-safari-permissions-sub-header = Para importar os favoritos e histórico de navegação do Safari:
migration-wizard-safari-instructions-continue = Selecione “Continuar”
migration-wizard-safari-instructions-folder = Selecione a pasta Safari na lista e escolha “Abrir”
