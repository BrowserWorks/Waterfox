# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = Modo de resolución de problemas de { -brand-short-name }
    .style = width: 37em;

troubleshoot-mode-description = Use el modo de resolución de problemas de { -brand-short-name } para diagnosticar problemas. Sus complementos y personalizaciones se desactivarán temporalmente.

troubleshoot-mode-description2 = Puede hacer permanentes todos o algunos de estos cambios:

troubleshoot-mode-disable-addons =
    .label = Desactivar todos los complementos
    .accesskey = D

troubleshoot-mode-reset-toolbars =
    .label = Restablecer barras de herramientas y controles
    .accesskey = R

troubleshoot-mode-change-and-restart =
    .label = Hacer cambios y reiniciar
    .accesskey = m

troubleshoot-mode-continue =
    .label = Continuar en el modo de resolución de problemas
    .accesskey = C

troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] Cerrar
           *[other] Salir
        }
    .accesskey =
        { PLATFORM() ->
            [windows] C
           *[other] S
        }
