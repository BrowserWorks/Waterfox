# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = Compacter les dossiers
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = Compacter maintenant
    .buttonaccesskeyaccept = C
    .buttonlabelcancel = Me le rappeler plus tard
    .buttonaccesskeycancel = r
    .buttonlabelextra1 = En savoir plus…
    .buttonaccesskeyextra1 = p

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } doit effectuer régulièrement une maintenance des fichiers pour améliorer les performances de vos dossiers de messages. Cette opération récupèrera { $data } d’espace disque sans modifier vos messages. Pour permettre à { -brand-short-name } de le faire automatiquement à l’avenir sans rien demander, cochez la case ci-dessous avant de choisir « { compact-dialog.buttonlabelaccept } ».

compact-dialog-never-ask-checkbox =
    .label = Compacter automatiquement les dossiers à l’avenir
    .accesskey = a

