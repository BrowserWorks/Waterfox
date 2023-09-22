# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Cancelar todas as transferências?

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Se sair agora, será cancelada 1 transferência. Tem a certeza que pretende sair?
       *[other] Se sair agora, serão canceladas { $downloadsCount } transferências. Tem a certeza que pretende sair?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Se sair agora, será cancelada 1 transferência. Tem a certeza que pretende sair?
       *[other] Se sair agora, serão canceladas { $downloadsCount } transferências. Tem a certeza que pretende sair?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] Não sair
       *[other] Não sair
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Se ativar o modo desligado agora, será cancelada 1 transferência. Tem a certeza que pretende ficar desligado?
       *[other] Se ativar o modo desligado agora, serão canceladas { $downloadsCount } transferências. Tem a certeza que pretende ficar desligado?
    }
download-ui-dont-go-offline-button = Ficar online

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Se fechar agora todas as janelas de Navegação privada, será cancelada 1 transferência. Tem a certeza que pretende sair da Navegação privada?
       *[other] Se fechar agora todas as janelas de Navegação privada, { $downloadsCount } serão canceladas transferências. Tem a certeza que pretende sair da Navegação privada?
    }
download-ui-dont-leave-private-browsing-button = Ficar na navegação privada

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] Cancelar 1 transferência
       *[other] Cancelar { $downloadsCount } transferências
    }

##

download-ui-file-executable-security-warning-title = Abrir ficheiro executável?
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = “{ $executable }” é um ficheiro executável. Os ficheiros executáveis podem conter vírus ou outro tipo de código malicioso que pode prejudicar o seu computador. Tenha cuidado ao abrir este ficheiro. Tem a certeza que pretende executar “{ $executable }”?
