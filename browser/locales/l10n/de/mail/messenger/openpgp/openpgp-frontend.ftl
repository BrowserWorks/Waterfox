# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-manage-keys-openpgp-cmd =
    .label = OpenPGP-Schlüssel verwalten
    .accesskey = p

openpgp-ctx-decrypt-open =
    .label = Entschlüsseln und öffnen
    .accesskey = E
openpgp-ctx-decrypt-save =
    .label = Entschlüsseln und speichern als…
    .accesskey = s
openpgp-ctx-import-key =
    .label = OpenPGP-Schlüssel importieren
    .accesskey = m
openpgp-ctx-verify-att =
    .label = Unterschrift verifizieren
    .accesskey = v

openpgp-has-sender-key = Die Nachricht gibt an, den öffentlichen OpenPGP-Schlüssel des Absenders zu enthalten.
openpgp-be-careful-new-key =
    Warnung: Der neue öffentliche OpenPGP-Schlüssel in dieser Nachricht unterscheidet sich von vorherigen Schlüsseln für { $email }, die Sie akzeptiert haben.

openpgp-import-sender-key =
    .label = Importieren…

openpgp-search-keys-openpgp =
    .label = OpenPGP-Schlüssel suchen

openpgp-missing-signature-key = Diese Nachricht wurde mit einem Schlüssel unterschrieben, über den Sie nicht verfügen.

openpgp-search-signature-key =
    .label = Suchen…

# Don't translate the terms "OpenPGP" and "MS-Exchange"
openpgp-broken-exchange-opened = Diese OpenPGP-Nachricht wurde offensichtlich durch MS-Exchange beschädigt und kann nicht repariert werden, da sie aus einer lokalen Datei geöffnet wurde. Kopieren Sie die Nachricht in einen Nachrichtenordner für E-Mails und versuchen Sie eine automatische Reparatur.
openpgp-broken-exchange-info = Diese OpenPGP-Nachricht wurde offensichtlich durch MS-Exchange beschädigt. Falls die Nachricht nicht wie erwartet dargestellt wird, können Sie eine automatische Reparatur versuchen.
openpgp-broken-exchange-repair =
    .label = Nachricht reparieren
openpgp-broken-exchange-wait = Bitte warten…

openpgp-cannot-decrypt-because-mdc =
    Dies ist eine verschlüsselte Nachricht, welche einen alten und nicht mehr sicheren Mechanismus für die Verschlüsselung verwendet.
    Sie könnte während des Transports verändert worden sein, um den Inhalt zu stehlen.
    Zum Schutz vor dieser Gefahr werden die Inhalte nicht angezeigt.

openpgp-cannot-decrypt-because-missing-key =
    Der zum Entschlüsseln dieser Nachricht benötigte geheime Schlüssel ist nicht vorhanden.

openpgp-partially-signed =
    Nur ein Teil dieser Nachricht wurde mit OpenPGP digital unterschrieben.
    Wenn die Schaltfläche "Verifizieren" angeklickt wird, werden die nicht geschützten Nachrichtenteile ausgeblendet und der Status der digitalen Unterschrift wird angezeigt.

openpgp-partially-encrypted =
    Nur ein Teil dieser Nachricht wurde mit OpenPGP verschlüsselt.
    Die bereits angezeigten lesbaren Nachrichtenteile waren unverschlüsselt.
    Wenn die Schaltfläche "Entschlüsseln" angeklickt wird, werden die Inhalte der verschlüsselten Nachrichtenteile angezeigt.

openpgp-reminder-partial-display = Erinnerung: Die unten angezeigt Nachricht ist nur ein Teil der eigentlichen Nachricht.

openpgp-partial-verify-button = Verifizieren
openpgp-partial-decrypt-button = Entschlüsseln

