
"installation" ping
===================

This mobile-specific ping is intended to keep track of installs and Adjust attribution.

There should only be two installation pings sent, for different reasons:

* One sent immediately after the app start.
* One sent immediately after the Adjust attribution data becomes available.

If the app is later deleted and installed again, the Installation Pings must be send again.

Submission will be per the Edge server specification (legacy) and also use the unified telemetry version - 4::

    /submit/telemetry/docId/docType/appName/appVersion/appUpdateChannel/appBuildID/?v=4

* ``docId`` is a UUID for deduping
* ``docType`` is “installation”
* ``appName`` is “Fennec”
* ``appVersion`` is the version of the application (e.g. "68.0.0")
* ``appUpdateChannel`` is “release”, “beta”, etc.
* ``appBuildID`` is the build number

Structure:

.. code-block:: js

    {
      "reason": <string>, // Ping reason. Either "app-started", either "adjust-available".
      "seq": <integer>, // running ping counter, 1-based. e.g. 2.
      "client_id": <string>, // Gecko client id, e.g. "de0efb06-6b57-4ee0-b13b-e8aabfccdcb9".
      "device_id": <string>, // hashed Google Ad ID, e.g. "$2a$10$ZfglUfcbmTyaBbAQ7SL9OO".
                             // null if Google Play Service from which to get the advertisingId is not available.
      "locale": <string>, // application locale, e.g. "en-US".
      "os": <string>, // device platform, e.g. "Android".
      "osversion": <string>, // device platform version, e.g. "25".
      "manufacturer": <string>, // device manufacturer - Build.MANUFACTURER, e.g. "Google".
      "model": <string>, // device model - Build.MODEL, e.g. "Pixel 3".
      "arch": <string>, // device ABI, e.g. "arm".
      "profile_date": <integer>, // Profile creation date in days since UNIX epoch.
                                 // 0 if the value could not be read.
      "created": <string>, // date the ping was created in local time, "yyyy-MM-dd"
      "tz": <integer>, // timezone offset (in minutes) of the
                       // device when the ping was created
      "app_name": <string>, // "Fennec"
      "channel": <string>, // Release channel, e.g. "beta"
      "campaign": <string>, // Adjust campaign. Can be null.
      "adgroup": <string>, // Adjust adgroup. Can be null.
      "creative": <string>, // Adjust creative. Can be null.
      "network": <string>, // Adjust network. Can be null.
    }


Version history
---------------
* v1: initial version - shipped in Fennec 68 - (`bug 1633568 <https://bugzilla.mozilla.org/show_bug.cgi?id=1633568>`_).
