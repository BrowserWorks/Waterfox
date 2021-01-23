# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# DO NOT ADD THINGS OTHER THAN ERROR MESSAGES HERE.
# This file gets parsed into a JS dictionary of all known error message ids in
# gen_aboutneterror_codes.py . If we end up needing fluent attributes or
# refactoring them in some way, the script will need updating.

# Variables:
# $hostname (String) - Hostname of the website with SSL error.
# $errorMessage (String) - Error message corresponding to the type of error we are experiencing.
ssl-connection-error = Hua 'ngo sa gahui a'nan' ngà ruhuaj gi'iaj konektandoj riña { $hostname }. { $errorMessage }

# Variables:
# $error (string) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix = Si da'nga' sa gahui a'nan': { $error }

psmerr-ssl-disabled = Na'ue gi'iaj konektandô hue'ej dadin' gire' ngà dàj hua protokolô SSL.

ssl-error-export-only-server = Nitaj si yitinj huaj ga'mi' dadin' ané ni nitaj si huaj gida'a dugui' hue'ej.
ssl-error-rx-malformed-hello-done = SSL nahuin ra’a ‘ngō nuguan’ Server Hello Done nitāj sī huā hue’ê.
ssl-error-rx-malformed-cert-verify = SSL nahuin ra’a ‘ngō nuguan’ Verify handshake nitāj sī huā hue’ê.
ssl-error-rx-malformed-client-key-exch = SSL nahuin ra’a ‘ngō nuguan’ Client Key Exchange nitāj sī huā hue’ê.
ssl-error-rx-malformed-finished = SSL nahuin ra’a ‘ngō nuguan’ Finished nitāj sī huā hue’ê.
ssl-error-rx-malformed-change-cipher = SSL nahuin ra’a ‘ngō sa nadunâ dàj hua nej sa gītsi riña nej sa ahui a’nan’an.
ssl-error-rx-malformed-alert = SSL nahuin ra’a ‘ngō sa atāj snan’ānj nej sa ahui a’nan’an.
ssl-error-rx-malformed-handshake = SSL nahuin ra’a ‘ngō sa guchi’ rayi’î nuguan’ ahui a’nan’an.
ssl-error-rx-malformed-application-data = SSL nahuin ra’a ‘ngō sí nuguàn’ aplikasiûn gahui a’nan’an.
ssl-error-rx-unexpected-hello-request = SSL nahuin ra’a ‘ngō nuguan’ Hello Request ra’ñànj an.
ssl-error-rx-unexpected-client-hello = SSL nahuin ra’a ‘ngō nuguan’ Client Hello ra’ñànj an.
ssl-error-rx-unexpected-server-hello = SSL nahuin ra’a ‘ngō nuguan’ Server ra’ñànj an.
ssl-error-rx-unexpected-certificate = SSL nahuin ra’a ‘ngō nuguan’ Certificate ra’ñànj an.
ssl-error-rx-unexpected-server-key-exch = SSL nahuin ra’a ‘ngō nuguan’ Server Key Exchange ra’ñànj an.
ssl-error-rx-unexpected-cert-request = SSL nahuin ra’a ‘ngō nuguan’ Certificate Request ra’ñànj an.
ssl-error-rx-unexpected-hello-done = SSL nahuin ra’a ‘ngō nuguan’ Server Hello Done ra’ñànj an.
ssl-error-rx-unexpected-cert-verify = SSL nahuin ra’a ‘ngō nuguan’ Certificate Verify ra’ñànj an.
ssl-error-rx-unexpected-client-key-exch = SSL nahuin ra’a ‘ngō nuguan’ Client Key Exchange ra’ñànj an.
ssl-error-rx-unexpected-finished = SSL nahuin ra’a ‘ngō nuguan’ Finished ra’ñànj an.
sec-error-cert-valid = Huā hue’ê sertifikadô nan.
sec-error-cert-not-valid = Nitāj si huā hue’ê sertifikadô nan.
sec-error-cert-no-response = Riña ahui nej sertifikâdo: nitāj nuguan’ hua akuan’ nïn
xp-sec-fortezza-bad-pin = Nitaj si ni'ñanj Pin
