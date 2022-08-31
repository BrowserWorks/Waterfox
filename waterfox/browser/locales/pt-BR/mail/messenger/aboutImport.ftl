# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = Importar
export-page-title = Exportar

## Header

import-start = Ferramenta de importação
import-start-title = Importar configurações ou dados de um aplicativo ou arquivo.
import-start-description = Selecione de onde importar. Mais à frente você vai escolher que dados devem ser importados.
import-from-app = Importar do aplicativo
import-file = Importar de arquivo
import-file-title = Selecione um arquivo para importar seu conteúdo.
import-file-description = Escolha importar um backup de perfil, catálogos de endereços ou agendas.
import-address-book-title = Importar arquivo de catálogo de endereços
import-calendar-title = Importar arquivo de agenda
export-profile = Exportar

## Buttons

button-back = Voltar
button-continue = Continuar
button-export = Exportar
button-finish = Concluir

## Import from app steps

app-name-thunderbird = Thunderbird
app-name-seamonkey = SeaMonkey
app-name-outlook = Outlook
app-name-becky = Becky! Internet Mail
app-name-apple-mail = Apple Mail
source-thunderbird = Importar de outra instalação do { app-name-thunderbird }
source-thunderbird-description = Importar configurações, filtros, mensagens e outros dados de um perfil do { app-name-thunderbird }.
source-seamonkey = Importar de uma instalação do { app-name-seamonkey }
source-seamonkey-description = Importar configurações, filtros, mensagens e outros dados de um perfil do { app-name-seamonkey }.
source-outlook = Importar do { app-name-outlook }
source-outlook-description = Importar contas, catálogos de endereços e mensagens do { app-name-outlook }.
source-becky = Importar do { app-name-becky }
source-becky-description = Importar catálogos de endereços e mensagens do { app-name-becky }.
source-apple-mail = Importar do { app-name-apple-mail }
source-apple-mail-description = Importar mensagens do { app-name-apple-mail }.
source-file2 = Importar de arquivo
source-file-description = Selecione um arquivo para importar catálogos de endereços, agendas ou um backup de perfil (arquivo ZIP).

## Import from file selections

file-profile2 = Importar perfil de backup
file-profile-description = Selecione um backup de perfil do Thunderbird (.zip)
file-calendar = Importar agendas
file-calendar-description = Selecione um arquivo contendo agendas ou eventos exportados (.ics)
file-addressbook = Importar catálogos de endereços
file-addressbook-description = Selecione um arquivo contendo catálogos de endereços e contatos exportados

## Import from app profile steps

from-app-thunderbird = Importar de um perfil do { app-name-thunderbird }
from-app-seamonkey = Importar de um perfil do { app-name-seamonkey }
from-app-outlook = Importar do { app-name-outlook }
from-app-becky = Importar do { app-name-becky }
from-app-apple-mail = Importar do { app-name-apple-mail }
profiles-pane-title-thunderbird = Importar configurações e dados de um perfil do { app-name-thunderbird }.
profiles-pane-title-seamonkey = Importar configurações e dados de um perfil do { app-name-seamonkey }.
profiles-pane-title-outlook = Importar dados do { app-name-outlook }.
profiles-pane-title-becky = Importar dados do { app-name-becky }.
profiles-pane-title-apple-mail = Importar mensagens do { app-name-apple-mail }.
profile-source = Importar de perfil
# $profileName (string) - name of the profile
profile-source-named = Importar do perfil <strong>"{ $profileName }"</strong>
profile-file-picker-directory = Escolha uma pasta de perfil
profile-file-picker-archive = Escolha um arquivo <strong>ZIP</strong>
profile-file-picker-archive-description = O arquivo ZIP deve ser menor que 2 GB.
profile-file-picker-archive-title = Escolha um arquivo ZIP (menor que 2 GB)
items-pane-title2 = Escolha o que importar:
items-pane-directory = Diretório:
items-pane-profile-name = Nome do perfil:
items-pane-checkbox-accounts = Contas e configurações
items-pane-checkbox-address-books = Catálogos de endereços
items-pane-checkbox-calendars = Agendas
items-pane-checkbox-mail-messages = Mensagens de email
items-pane-override = Dados já existentes ou idênticos não são substituídos.

## Import from address book file steps

import-from-addr-book-file-description = Escolha o formato de arquivo que contém os dados do catálogo de endereços.
addr-book-csv-file = Arquivo com valores separados por vírgulas ou tabulações (.csv, .tsv)
addr-book-ldif-file = Arquivo LDIF (.ldif)
addr-book-vcard-file = Arquivo vCard (.vcf, .vcard)
addr-book-sqlite-file = Arquivo de base de dados SQLite (.sqlite)
addr-book-mab-file = Arquivo de banco de dados Mork (.mab)
addr-book-file-picker = Selecione um arquivo de catálogo de endereços
addr-book-csv-field-map-title = Corresponder nomes de campo
addr-book-csv-field-map-desc = Selecione os campos do catálogo de endereços correspondentes aos campos de origem. Desmarque os campos que você não quer importar.
addr-book-directories-title = Selecione para onde importar os dados escolhidos
addr-book-directories-pane-source = Arquivo de origem:
# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = Criar um novo diretório chamado <strong>"{ $addressBookName }"</strong>
# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = Importar os dados escolhidos para o diretório "{ $addressBookName }"
# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = Será criado um novo catálogo de endereços chamado "{ $addressBookName }".

## Import from calendar file steps

import-from-calendar-file-desc = Selecione o arquivo iCalendar (.ics) que você quer importar.
calendar-items-title = Selecione quais itens importar.
calendar-items-loading = Carregando itens…
calendar-items-filter-input =
    .placeholder = Filtrar itens…
calendar-select-all-items = Selecionar tudo
calendar-deselect-all-items = Desmarcar tudo
calendar-target-title = Selecione para onde importar os itens escolhidos.
# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = Criar uma nova agenda chamada <strong>"{ $targetCalendar }"</strong>
# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
    { $itemCount ->
        [one] Importar um item para a agenda "{ $targetCalendar }"
       *[other] Importar { $itemCount } itens para a agenda "{ $targetCalendar }"
    }
# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = Será criada uma nova agenda chamada "{ $targetCalendar }".

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = Importando… { $progressPercent }
# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = Exportando… { $progressPercent }
progress-pane-finished-desc2 = Pronto.
error-pane-title = Erro
error-message-zip-file-too-big2 = O arquivo ZIP selecionado tem mais de 2GB. Primeiro extraia o conteúdo, depois importe a partir da pasta onde foi extraído.
error-message-extract-zip-file-failed2 = Falha ao extrair o arquivo ZIP. Extraia manualmente, depois importe a partir da pasta onde foi extraído.
error-message-failed = A importação falhou inesperadamente; mais informações podem estar disponíveis no console de erros.
error-failed-to-parse-ics-file = Não foi encontrado nenhum item importável no arquivo.
error-export-failed = A exportação falhou inesperadamente, mais informações podem estar disponíveis no console de erros.
error-message-no-profile = Nenhum perfil encontrado.

## <csv-field-map> element

csv-first-row-contains-headers = A primeira linha contém nomes de campos
csv-source-field = Campo de origem
csv-source-first-record = Primeiro registro
csv-source-second-record = Segundo registro
csv-target-field = Campo do catálogo de endereços

## Export tab

export-profile-title = Exportar contas, mensagens, catálogos de endereços e configurações para um arquivo ZIP.
export-profile-description = Se o tamanho do seu perfil atual for maior que 2GB, sugerimos que faça o backup você mesmo.
export-open-profile-folder = Abrir pasta do perfil
export-file-picker2 = Exportar para um arquivo ZIP
export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = Dados a ser importados
summary-pane-start = Iniciar importação
summary-pane-warning = O { -brand-product-name } precisa ser reiniciado ao terminar a importação.
summary-pane-start-over = Reiniciar ferramenta de importação

## Footer area

footer-help = Precisa de ajuda?
footer-import-documentation = Documentação de importação
footer-export-documentation = Documentação de exportação
footer-support-forum = Fórum de suporte

## Step navigation on top of the wizard pages

step-list =
    .aria-label = Etapas de importação
step-confirm = Confirmar
# Variables:
# $number (number) - step number
step-count = { $number }
