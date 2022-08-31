# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = Modo de diagnóstico do { -brand-short-name }
    .style = width: 37em;

troubleshoot-mode-description = Utilizar este modo de diagnóstico do { -brand-short-name } para identificar problemas. As suas extensões e personalizações serão temporariamente desativadas.

troubleshoot-mode-description2 = Pode tornar algumas ou todas as alterações permanentes:

troubleshoot-mode-disable-addons =
    .label = Desativar todos os extras
    .accesskey = D

troubleshoot-mode-reset-toolbars =
    .label = Repor as barras de ferramentas e controlos
    .accesskey = R

troubleshoot-mode-change-and-restart =
    .label = Fazer as alterações e reiniciar
    .accesskey = F

troubleshoot-mode-continue =
    .label = Continuar no modo de diagnóstico
    .accesskey = C

troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] Sair
           *[other] Sair
        }
    .accesskey =
        { PLATFORM() ->
            [windows] i
           *[other] i
        }
