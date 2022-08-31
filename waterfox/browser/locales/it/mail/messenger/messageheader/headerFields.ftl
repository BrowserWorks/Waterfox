# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Header lists

message-header-to-list-name = A

message-header-from-list-name = Da

message-header-sender-list-name = Mittente

message-header-reply-to-list-name = Rispondi a

message-header-cc-list-name = Cc

message-header-bcc-list-name = Ccn

message-header-newsgroups-list-name = Gruppi di discussione

message-header-tags-list-name = Etichette

## Other message headers.
## The field-separator is for screen readers to separate the field name from the field value.

message-header-author-field = Autore<span data-l10n-name="field-separator">:</span>

message-header-organization-field = Organizzazione<span data-l10n-name="field-separator">:</span>

message-header-subject-field = Oggetto<span data-l10n-name="field-separator">:</span>

message-header-followup-to-field = Inoltra a<span data-l10n-name="field-separator">:</span>


message-header-date-field = Data<span data-l10n-name="field-separator">:</span>

message-header-user-agent-field = User agent<span data-l10n-name="field-separator">:</span>

message-header-references-field = Riferimenti<span data-l10n-name="field-separator">:</span>

message-header-message-id-field = ID messaggio<span data-l10n-name="field-separator">:</span>

message-header-in-reply-to-field = In risposta a<span data-l10n-name="field-separator">:</span>

message-header-website-field = Sito web<span data-l10n-name="field-separator">:</span>

# An additional email header field that the user has chosen to display. Unlike
# the other headers, the name of this header is not expected to be localised
# because it is generated from the raw field name found in the email header.
#   $fieldName (String) - The field name.
message-header-custom-field = { $fieldName }<span data-l10n-name="field-separator">:</span>

##

message-header-address-in-address-book-icon2 =
    .alt = In rubrica

message-header-address-not-in-address-book-icon2 =
    .alt = Non in rubrica

message-header-address-not-in-address-book-button =
    .title = Salva questo indirizzo nella rubrica

message-header-address-in-address-book-button =
    .title = Modifica contatto

message-header-field-show-more = Altro
    .title = Mostra tutti i destinatari

message-ids-field-show-all = Mostra tutti
