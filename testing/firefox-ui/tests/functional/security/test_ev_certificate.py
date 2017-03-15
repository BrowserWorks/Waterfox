# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from firefox_puppeteer import PuppeteerMixin
from marionette_driver import Wait
from marionette_harness import MarionetteTestCase


class TestEVCertificate(PuppeteerMixin, MarionetteTestCase):

    def setUp(self):
        super(TestEVCertificate, self).setUp()

        self.locationbar = self.browser.navbar.locationbar
        self.identity_popup = self.locationbar.identity_popup

        self.url = 'https://ssl-ev.mozqa.com/'

    def tearDown(self):
        try:
            self.browser.switch_to()
            self.identity_popup.close(force=True)
            self.puppeteer.windows.close_all([self.browser])
        finally:
            super(TestEVCertificate, self).tearDown()

    def test_ev_certificate(self):
        with self.marionette.using_context('content'):
            self.marionette.navigate(self.url)

        # Check the identity box
        self.assertEqual(self.locationbar.identity_box.get_property('className'),
                         'verifiedIdentity')

        # Get the information from the certificate
        cert = self.browser.tabbar.selected_tab.certificate
        address = self.puppeteer.security.get_address_from_certificate(cert)

        # Check the identity popup label displays
        self.assertEqual(self.locationbar.identity_organization_label.get_property('value'),
                         cert['organization'])
        self.assertEqual(self.locationbar.identity_country_label.get_property('value'),
                         '(' + address['country'] + ')')

        # Open the identity popup
        self.locationbar.open_identity_popup()

        # Check the idenity popup doorhanger
        self.assertEqual(self.identity_popup.element.get_attribute('connection'), 'secure-ev')

        # For EV certificates no hostname but the organization name is shown
        self.assertEqual(self.identity_popup.view.main.host.get_property('textContent'),
                         cert['organization'])

        # Only the secure label is visible in the main view
        secure_label = self.identity_popup.view.main.secure_connection_label
        self.assertNotEqual(secure_label.value_of_css_property('display'), 'none')

        insecure_label = self.identity_popup.view.main.insecure_connection_label
        self.assertEqual(insecure_label.value_of_css_property('display'), 'none')

        self.identity_popup.view.main.expander.click()
        Wait(self.marionette).until(lambda _: self.identity_popup.view.security.selected)

        security_view = self.identity_popup.view.security

        # Only the secure label is visible in the security view
        secure_label = security_view.secure_connection_label
        self.assertNotEqual(secure_label.value_of_css_property('display'), 'none')

        insecure_label = security_view.insecure_connection_label
        self.assertEqual(insecure_label.value_of_css_property('display'), 'none')

        # Check the organization name
        self.assertEqual(security_view.owner.get_property('textContent'), cert['organization'])

        # Check the owner location string
        # More information:
        # hg.mozilla.org/mozilla-central/file/eab4a81e4457/browser/base/content/browser.js#l7012
        location = self.browser.localize_property('identity.identified.state_and_country')
        location = location.replace('%S', address['state'], 1).replace('%S', address['country'])
        location = address['city'] + '\n' + location
        self.assertEqual(security_view.owner_location.get_property('textContent'), location)

        # Check the verifier
        l10n_verifier = self.browser.localize_property('identity.identified.verifier')
        l10n_verifier = l10n_verifier.replace('%S', cert['issuerOrganization'])
        self.assertEqual(security_view.verifier.get_property('textContent'), l10n_verifier)

        # Open the Page Info window by clicking the More Information button
        page_info = self.browser.open_page_info_window(
            lambda _: self.identity_popup.view.security.more_info_button.click())

        try:
            # Verify that the current panel is the security panel
            self.assertEqual(page_info.deck.selected_panel, page_info.deck.security)

            # Verify the domain listed on the security panel
            self.assertIn(cert['commonName'],
                          page_info.deck.security.domain.get_property('value'))

            # Verify the owner listed on the security panel
            self.assertEqual(page_info.deck.security.owner.get_property('value'),
                             cert['organization'])

            # Verify the verifier listed on the security panel
            self.assertEqual(page_info.deck.security.verifier.get_property('value'),
                             cert['issuerOrganization'])
        finally:
            page_info.close()
            self.browser.focus()
