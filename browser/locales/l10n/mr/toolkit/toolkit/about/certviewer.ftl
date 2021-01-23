# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error messages


## Certificate information labels

certificate-viewer-authority-key-id = प्राधिकरण की ID
certificate-viewer-authority-info-aia = प्राधिकरण माहिती (AIA)
certificate-viewer-certificate-policies = प्रमाणपत्र धोरणे
certificate-viewer-embedded-scts = एम्बेड केलेले SCTs
certificate-viewer-crl-endpoints = CRL समापन बिंदू

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = डाउनलोड
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] हो
       *[false] नाही
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

## Labels for tabs displayed in stand-alone about:certificate page

