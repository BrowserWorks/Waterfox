# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-pin-invalid-long-prompt =
    { $retriesLeft ->
        [one] Niewłaściwy kod PIN. Została { $retriesLeft } próba, zanim trwale utracisz dostęp do danych logowania na tym urządzeniu.
        [few] Niewłaściwy kod PIN. Zostały { $retriesLeft } próby, zanim trwale utracisz dostęp do danych logowania na tym urządzeniu.
       *[many] Niewłaściwy kod PIN. Zostało { $retriesLeft } prób, zanim trwale utracisz dostęp do danych logowania na tym urządzeniu.
    }
webauthn-pin-invalid-short-prompt = Niewłaściwy kod PIN. Spróbuj ponownie.
webauthn-pin-required-prompt = Proszę podać kod PIN dla używanego urządzenia.

# Variables:
#  $retriesLeft (Number): number of tries left
webauthn-uv-invalid-long-prompt =
    { $retriesLeft ->
        [one] Weryfikacja użytkownika się nie powiodła. Została { $retriesLeft } próba. Spróbuj ponownie.
        [few] Weryfikacja użytkownika się nie powiodła. Zostały { $retriesLeft } próby. Spróbuj ponownie.
       *[many] Weryfikacja użytkownika się nie powiodła. Zostało { $retriesLeft } prób. Spróbuj ponownie.
    }
webauthn-uv-invalid-short-prompt = Weryfikacja użytkownika się nie powiodła. Spróbuj ponownie.
