# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import os
import re
import simplejson as json
import zlib

from multiprocessing import Process

from firefox_puppeteer import PuppeteerMixin
from marionette_driver.addons import Addons
from marionette_driver.errors import MarionetteException
from marionette_driver.wait import Wait
from marionette_harness import MarionetteTestCase
from marionette_harness.runner import httpd

here = os.path.abspath(os.path.dirname(__file__))
doc_root = os.path.join(os.path.dirname(here), "www")
resources_dir = os.path.join(os.path.dirname(here), "resources")


class TelemetryTestCase(PuppeteerMixin, MarionetteTestCase):

    ping_list = []

    def setUp(self, *args, **kwargs):
        super(TelemetryTestCase, self).setUp()

        # Start and configure server
        self.httpd = httpd.FixtureServer(doc_root)
        ping_route = [("POST", re.compile('/pings'), self.pings)]
        self.httpd.routes.extend(ping_route)
        self.httpd.start()
        self.ping_server_url = '{}pings'.format(self.httpd.get_url('/'))

        telemetry_prefs = {
            'toolkit.telemetry.server': self.ping_server_url,
            'toolkit.telemetry.initDelay': 1,
            'toolkit.telemetry.minSubsessionLength': 0,
            'datareporting.healthreport.uploadEnabled': True,
            'datareporting.policy.dataSubmissionEnabled': True,
            'datareporting.policy.dataSubmissionPolicyBypassNotification': True,
            'toolkit.telemetry.log.level': 0,
            'toolkit.telemetry.log.dump': True,
            'toolkit.telemetry.send.overrideOfficialCheck': True
        }

        # Firefox will be forced to restart with the prefs enforced.
        self.marionette.enforce_gecko_prefs(telemetry_prefs)

    def wait_for_ping(self):
        if len(self.ping_list) == 0:
            try:
                Wait(self.marionette, 60).until(lambda t: len(self.ping_list) > 0)
            except Exception as e:
                self.fail('Error generating ping: {}'.format(e.message))
        return self.ping_list.pop()

    def toggle_update_pref(self):
        value = self.marionette.get_pref('app.update.enabled')
        self.marionette.enforce_gecko_prefs({'app.update.enabled': not value})

    def restart_browser(self):
        """Restarts browser while maintaining the same profile and session."""
        self.restart(clean=False, in_app=True)

    def install_addon(self):
        trigger = Process(target=self._install_addon)
        trigger.start()

    def _install_addon(self):
        # The addon that gets installed here is the easyscreenshot addon taken from AMO.
        # It has high compatibility with firefox and doesn't cause any adverse side affects that
        # could affect our tests like tabs opening, etc.
        # Developed by: MozillaOnline
        # Addon URL: https://addons.mozilla.org/en-US/firefox/addon/easyscreenshot/
        try:
            addon_path = os.path.join(resources_dir, 'easyscreenshot.xpi')
            addons = Addons(self.marionette)
            addons.install(addon_path)
        except MarionetteException as e:
            self.fail('{} - Error installing addon: {} - '.format(e.cause, e.message))

    @property
    def client_id(self):
        return self.marionette.execute_script('Cu.import("resource://gre/modules/ClientID.jsm");'
                                              'return ClientID.getCachedClientID();')

    @property
    def subsession_id(self):
        ping_data = self.marionette.execute_script(
            'Cu.import("resource://gre/modules/TelemetryController.jsm");'
            'return TelemetryController.getCurrentPingData(true);')
        return ping_data[u'payload'][u'info'][u'subsessionId']

    def tearDown(self, *args, **kwargs):
        self.httpd.stop()
        super(TelemetryTestCase, self).tearDown()

    def pings(self, request, response):
        json_data = json.loads(unpack(request.headers, request.body))
        self.ping_list.append(json_data)
        return 200


def unpack(headers, data):
    if "Content-Encoding" in headers and headers["Content-Encoding"] == "gzip":
        return zlib.decompress(data, zlib.MAX_WBITS | 16)
    else:
        return data
