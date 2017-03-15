# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import os

from firefox_puppeteer import PuppeteerMixin
from firefox_puppeteer.api.software_update import SoftwareUpdate
from marionette_harness import MarionetteTestCase


class TestSoftwareUpdate(PuppeteerMixin, MarionetteTestCase):

    def setUp(self):
        super(TestSoftwareUpdate, self).setUp()

        self.software_update = SoftwareUpdate(self.marionette)

        self.saved_mar_channels = self.software_update.mar_channels.channels
        self.software_update.mar_channels.channels = set(['expected', 'channels'])

    def tearDown(self):
        try:
            self.software_update.mar_channels.channels = self.saved_mar_channels
        finally:
            super(TestSoftwareUpdate, self).tearDown()

    def test_abi(self):
        self.assertTrue(self.software_update.ABI)

    def test_allowed(self):
        self.assertTrue(self.software_update.allowed)

    def test_build_info(self):
        build_info = self.software_update.build_info
        self.assertEqual(build_info['disabled_addons'], None)
        self.assertIn('Mozilla/', build_info['user_agent'])
        self.assertEqual(build_info['mar_channels'], set(['expected', 'channels']))
        self.assertTrue(build_info['version'])
        self.assertTrue(build_info['buildid'].isdigit())
        self.assertTrue(build_info['locale'])
        self.assertIn('force=1', build_info['update_url'])
        self.assertIn('xml', build_info['update_snippet'])
        self.assertEqual(build_info['channel'], self.software_update.update_channel)

    def test_force_fallback(self):
        status_file = os.path.join(self.software_update.staging_directory, 'update.status')

        try:
            self.software_update.force_fallback()
            with open(status_file, 'r') as f:
                content = f.read()
            self.assertEqual(content, 'failed: 6\n')
        finally:
            os.remove(status_file)

    def test_get_update_url(self):
        update_url = self.software_update.get_update_url()
        self.assertIn('Firefox', update_url)
        self.assertNotIn('force=1', update_url)
        update_url = self.software_update.get_update_url(True)
        self.assertIn('Firefox', update_url)
        self.assertIn('force=1', update_url)

    def test_os_version(self):
        self.assertTrue(self.software_update.os_version)

    def test_staging_directory(self):
        self.assertTrue(self.software_update.staging_directory)


class TestUpdateChannel(PuppeteerMixin, MarionetteTestCase):

    def setUp(self):
        super(TestUpdateChannel, self).setUp()

        self.software_update = SoftwareUpdate(self.marionette)

        self.saved_channel = self.software_update.update_channel
        self.software_update.update_channel = 'expected_channel'

    def tearDown(self):
        try:
            self.software_update.update_channel = self.saved_channel
        finally:
            super(TestUpdateChannel, self).tearDown()

    def test_update_channel_default_channel(self):
        # Without a restart the update channel will not change.
        self.assertEqual(self.software_update.update_channel, self.saved_channel)

    def test_update_channel_set_channel(self):
        try:
            # Use the clean option to force a non in_app restart, which would allow
            # Firefox to dump the logs to the console.
            self.restart(clean=True)
            self.assertEqual(self.software_update.update_channel, 'expected_channel')
        finally:
            self.software_update.update_channel = self.saved_channel
            self.restart(clean=True)


class TestMARChannels(PuppeteerMixin, MarionetteTestCase):

    def setUp(self):
        super(TestMARChannels, self).setUp()

        self.software_update = SoftwareUpdate(self.marionette)

        self.saved_mar_channels = self.software_update.mar_channels.channels
        self.software_update.mar_channels.channels = set(['expected', 'channels'])

    def tearDown(self):
        try:
            self.software_update.mar_channels.channels = self.saved_mar_channels
        finally:
            super(TestMARChannels, self).tearDown()

    def test_mar_channels_channels(self):
        self.assertEqual(self.software_update.mar_channels.channels, set(['expected', 'channels']))

    def test_mar_channels_set_channels(self):
        self.software_update.mar_channels.channels = set(['a', 'b', 'c'])
        self.assertEqual(self.software_update.mar_channels.channels, set(['a', 'b', 'c']))

    def test_mar_channels_add_channels(self):
        self.software_update.mar_channels.add_channels(set(['some', 'new', 'channels']))
        self.assertEqual(
            self.software_update.mar_channels.channels,
            set(['expected', 'channels', 'some', 'new']))

    def test_mar_channels_remove_channels(self):
        self.software_update.mar_channels.remove_channels(set(['expected']))
        self.assertEqual(self.software_update.mar_channels.channels, set(['channels']))
