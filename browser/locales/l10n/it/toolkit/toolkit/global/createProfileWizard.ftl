# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Creazione guidata profilo
    .style = width: 45em; height: 33em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introduzione
       *[other] Benvenuti in { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } salva le informazioni personali e le opzioni in un profilo personale.

profile-creation-explanation-2 = Se si condivide questa copia di { -brand-short-name } con altre persone è possibile utilizzare i profili per mantenere separate le informazioni di ciascun utente. Per ottenere questo ogni utente deve creare un proprio profilo.

profile-creation-explanation-3 = Se si è l’unica persona a utilizzare questa copia di { -brand-short-name } è comunque necessario avere almeno un profilo. È possibile creare più profili per salvare gruppi di informazioni e impostazioni differenti, ad esempio per separare il profilo di lavoro da quello personale.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Per avviare la creazione di un profilo fare clic su Continua.
       *[other] Per avviare la creazione di un profilo fare clic su Avanti.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Conclusione
       *[other] Conclusione - { create-profile-window.title }
    }

profile-creation-intro = Se si creano più profili è possibile identificarli con un nome. Si può scegliere di utilizzare il nome suggerito o indicarne uno diverso.

profile-prompt = Inserire il nome del profilo:
    .accesskey = n

profile-default-name =
    .value = Utente predefinito

profile-directory-explanation = Le impostazioni personali, le preferenze e gli altri dati relativi all’utente verranno memorizzati in:

create-profile-choose-folder =
    .label = Scegli cartella…
    .accesskey = S

create-profile-use-default =
    .label = Utilizza la cartella predefinita
    .accesskey = U
