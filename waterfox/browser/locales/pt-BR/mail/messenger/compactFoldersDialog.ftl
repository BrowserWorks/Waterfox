# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = Compactar pastas
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = Compactar agora
    .buttonaccesskeyaccept = C
    .buttonlabelcancel = Lembrar mais tarde
    .buttonaccesskeycancel = L
    .buttonlabelextra1 = Saiba mais…
    .buttonaccesskeyextra1 = S

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = O { -brand-short-name } precisa fazer manutenção regular de arquivos para melhorar o desempenho de suas pastas de email. Isso recupera { $data } de espaço em disco sem alterar suas mensagens. Para deixar o { -brand-short-name } fazer isso automaticamente sem preguntar, marque a opção abaixo antes de selecionar ‘{ compact-dialog.buttonlabelaccept }’.

compact-dialog-never-ask-checkbox =
    .label = Compactar pastas automaticamente
    .accesskey = a

