# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Χρήση παρόχου
    .accesskey = ρ

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Προεπιλογή)
    .tooltiptext = Χρήση προεπιλεγμένου URL για επίλυση DNS αντί HTTPS

connection-dns-over-https-url-custom =
    .label = Προσαρμοσμένο
    .accesskey = Π
    .tooltiptext = Εισάγετε το προτιμώμενο URL για επίλυση DNS αντί HTTPS

connection-dns-over-https-custom-label = Προσαρμοσμένο

connection-dialog-window =
    .title = Ρυθμίσεις σύνδεσης
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Ρύθμιση διαμεσολαβητών για την πρόσβαση στο διαδίκτυο

proxy-type-no =
    .label = Χωρίς διαμεσολαβητή
    .accesskey = ω

proxy-type-wpad =
    .label = Αυτόματος εντοπισμός ρυθμίσεων διαμεσολαβητή για αυτό το δίκτυο
    .accesskey = υ

proxy-type-system =
    .label = Χρήση ρυθμίσεων διαμεσολαβητή συστήματος
    .accesskey = σ

proxy-type-manual =
    .label = Χειροκίνητη ρύθμιση διαμεσολαβητή:
    .accesskey = Χ

proxy-http-label =
    .value = Διαμεσολαβητής HTTP:
    .accesskey = h

http-port-label =
    .value = Θύρα:
    .accesskey = Θ

proxy-http-sharing =
    .label = Χρησιμοποιήστε επίσης αυτό το διακομιστή μεσολάβησης για το HTTPS
    .accesskey = x

proxy-https-label =
    .value = Διακομιστής μεσολάβησης HTTPS:
    .accesskey = S

ssl-port-label =
    .value = Θύρα:
    .accesskey = ρ

proxy-socks-label =
    .value = Σύστημα SOCKS:
    .accesskey = c

socks-port-label =
    .value = Θύρα:
    .accesskey = α

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL αυτόματης ρύθμισης διαμεσολαβητή:
    .accesskey = υ

proxy-reload-label =
    .label = Ανανέωση
    .accesskey = ν

no-proxy-label =
    .value = Χωρίς διαμεσολαβητή για:
    .accesskey = Χ

no-proxy-example = Για παράδειγμα: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Συνδέσεις στο localhost, 127.0.0.1 και ::1 δεν περνούν ποτέ μέσω διαμεσολαβητή.

proxy-password-prompt =
    .label = Να μην ζητείται έλεγχος ταυτοποίησης αν είναι αποθηκευμένος ο κωδικός πρόσβασης
    .accesskey = α
    .tooltiptext = Αυτή η επιλογή κάνει κρυφά την ταυτοποίησή σας σε διαμεσολαβητές, όταν έχετε αποθηκευμένα τα διαπιστευτήριά τους. Θα ειδοποιηθείτε αν αποτύχει η ταυτοποίηση.

proxy-remote-dns =
    .label = Διαμεσολαβητής DNS κατά τη χρήση του SOCKS v5
    .accesskey = d

proxy-enable-doh =
    .label = Ενεργοποίηση DNS αντί HTTPS
    .accesskey = γ
