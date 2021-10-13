# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title =
    Dai il benvenuto a un
    nuovo { -brand-short-name }
upgrade-dialog-new-subtitle = Progettato per portarti dove ti serve, alla massima velocità.
upgrade-dialog-new-item-menu-title = Barra degli strumenti e menu più semplici
upgrade-dialog-new-item-menu-description = Priorità agli elementi più importanti, così potrai trovare al volo ciò che ti serve.
upgrade-dialog-new-item-tabs-title = Schede moderne
upgrade-dialog-new-item-tabs-description = Includono tutte le informazioni in modo chiaro, ti aiutano a concentrarti e sono facili da riorganizzare.
upgrade-dialog-new-item-icons-title = Nuove icone e messaggi più chiari
upgrade-dialog-new-item-icons-description = Trova la tua strada con un tocco più leggero.
upgrade-dialog-new-primary-default-button = Imposta { -brand-short-name } come browser predefinito
upgrade-dialog-new-primary-theme-button = Scegli un tema
upgrade-dialog-new-secondary-button = Non adesso
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = OK, tutto chiaro

## Pin Waterfox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title = { PLATFORM() ->
    [macos] Mantieni { -brand-short-name } nel Dock
   *[other] Aggiungi { -brand-short-name } alla barra delle applicazioni
}
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    La versione più moderna di { -brand-short-name } mai realizzata,
    sempre a portata di mano.
upgrade-dialog-pin-primary-button = { PLATFORM() ->
    [macos] Mantieni nel Dock
   *[other] Aggiungi alla barra delle applicazioni
}
upgrade-dialog-pin-secondary-button = Non adesso

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Imposta { -brand-short-name } come browser predefinito
upgrade-dialog-default-subtitle-2 = Velocità, sicurezza e privacy senza preoccupazioni.
upgrade-dialog-default-primary-button-2 = Imposta come browser predefinito
upgrade-dialog-default-secondary-button = Non adesso

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 =
    Inizia al meglio con un nuovo tema
upgrade-dialog-theme-system = Tema di sistema
    .title = Utilizza la stessa combinazione di colori del sistema operativo per pulsanti, menu e finestre.
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Utilizza una combinazione di colori dinamica e variegata per pulsanti, menu e finestre.
upgrade-dialog-theme-keep = Mantieni esistente
    .title = Continua a utilizzare il tema già installato prima di aggiornare { -brand-short-name }
upgrade-dialog-theme-primary-button = Salva tema
upgrade-dialog-theme-secondary-button = Non adesso

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = Una vita a colori
upgrade-dialog-start-subtitle = Nuove vibranti tonalità. Disponibili per un periodo limitato.
upgrade-dialog-start-primary-button = Esplora tonalità
upgrade-dialog-start-secondary-button = Non adesso

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = Scegli la tua combinazione di colori
upgrade-dialog-colorway-home-checkbox = Passa alla Pagina iniziale di Waterfox con uno sfondo a tema
upgrade-dialog-colorway-primary-button = Salva tonalità
upgrade-dialog-colorway-secondary-button = Mantieni il tema precedente
upgrade-dialog-colorway-theme-tooltip =
    .title = Scopri i temi predefiniti
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = Scopri le tonalità { $colorwayName }
upgrade-dialog-colorway-default-theme = Tema predefinito
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = Automatico
    .title = Utilizza la stessa combinazione di colori del sistema operativo per pulsanti, menu e finestre
upgrade-dialog-theme-light = Chiaro
    .title = Utilizza una combinazione di colori chiara per pulsanti, menu e finestre
upgrade-dialog-theme-dark = Scuro
    .title = Utilizza una combinazione di colori scura per pulsanti, menu e finestre
upgrade-dialog-colorway-variation-soft = Delicata
    .title = Utilizza questa tonalità
upgrade-dialog-colorway-variation-balanced = Bilanciata
    .title = Utilizza questa tonalità
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = Forte
    .title = Utilizza questa tonalità

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = Grazie per averci scelto
upgrade-dialog-thankyou-subtitle = { -brand-short-name } è un browser indipendente sostenuto da un’organizzazione senza fini di lucro. Insieme possiamo rendere il Web più sicuro, più sano e più rispettoso della privacy.
upgrade-dialog-thankyou-primary-button = Inizia a navigare
