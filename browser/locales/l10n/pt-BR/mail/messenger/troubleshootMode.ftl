# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = Modo de solução de problemas do { -brand-short-name }
    .style = width: 37em;
troubleshoot-mode-description = Use o modo de solução de problemas do { -brand-short-name } para diagnosticar problemas. Suas extensões e personalizações são temporariamente desativadas.
troubleshoot-mode-description2 = Você pode tornar algumas ou todas essas mudanças permanentes:
troubleshoot-mode-disable-addons =
    .label = Desativar todas as extensões
    .accesskey = D
troubleshoot-mode-reset-toolbars =
    .label = Restaurar barras de ferramentas e controles
    .accesskey = R
troubleshoot-mode-change-and-restart =
    .label = Aplicar alterações e reiniciar
    .accesskey = A
troubleshoot-mode-continue =
    .label = Continuar em modo de solução de problemas
    .accesskey = C
troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] Sair
           *[other] Sair
        }
    .accesskey =
        { PLATFORM() ->
            [windows] r
           *[other] r
        }
