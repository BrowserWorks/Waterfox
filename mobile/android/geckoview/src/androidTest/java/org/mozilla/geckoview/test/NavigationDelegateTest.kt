/* -*- Mode: Java; c-basic-offset: 4; tab-width: 4; indent-tabs-mode: nil; -*-
 * Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

package org.mozilla.geckoview.test

import org.mozilla.geckoview.GeckoSession.NavigationDelegate.LoadRequest

import org.mozilla.geckoview.test.rule.GeckoSessionTestRule.AssertCalled
import org.mozilla.geckoview.test.rule.GeckoSessionTestRule.NullDelegate
import org.mozilla.geckoview.test.rule.GeckoSessionTestRule.Setting
import org.mozilla.geckoview.test.rule.GeckoSessionTestRule.WithDisplay
import org.mozilla.geckoview.test.util.Callbacks

import androidx.test.filters.MediumTest
import androidx.test.ext.junit.runners.AndroidJUnit4
import org.hamcrest.MatcherAssert
import org.hamcrest.Matchers.*
import org.json.JSONObject
import org.junit.Assert
import org.junit.Assume.assumeThat
import org.junit.Ignore
import org.junit.Test
import org.junit.runner.RunWith
import org.mozilla.geckoview.*
import org.mozilla.geckoview.test.rule.GeckoSessionTestRule
import org.mozilla.geckoview.test.util.UiThreadUtils

@RunWith(AndroidJUnit4::class)
@MediumTest
class NavigationDelegateTest : BaseSessionTest() {

    fun testLoadErrorWithErrorPage(testUri: String, expectedCategory: Int,
                                   expectedError: Int,
                                   errorPageUrl: String?) {
        sessionRule.delegateDuringNextWait(
                object : Callbacks.ProgressDelegate, Callbacks.NavigationDelegate, Callbacks.ContentDelegate {
                    @AssertCalled(count = 1, order = [1])
                    override fun onLoadRequest(session: GeckoSession,
                                               request: LoadRequest):
                                               GeckoResult<AllowOrDeny>? {
                        assertThat("URI should be " + testUri, request.uri, equalTo(testUri))
                        assertThat("App requested this load", request.isDirectNavigation,
                                equalTo(true))
                        return null
                    }

                    @AssertCalled(count = 1, order = [2])
                    override fun onPageStart(session: GeckoSession, url: String) {
                        assertThat("URI should be " + testUri, url, equalTo(testUri))
                    }

                    @AssertCalled(count = 1, order = [3])
                    override fun onLoadError(session: GeckoSession, uri: String?,
                                             error: WebRequestError): GeckoResult<String>? {
                        assertThat("Error category should match", error.category,
                                equalTo(expectedCategory))
                        assertThat("Error code should match", error.code,
                                equalTo(expectedError))
                        return GeckoResult.fromValue(errorPageUrl)
                    }

                    @AssertCalled(count = 1, order = [4])
                    override fun onPageStop(session: GeckoSession, success: Boolean) {
                        assertThat("Load should fail", success, equalTo(false))
                    }
                })

        sessionRule.session.loadUri(testUri)
        sessionRule.waitForPageStop()

        if (errorPageUrl != null) {
            sessionRule.waitUntilCalled(object : Callbacks.ContentDelegate, Callbacks.NavigationDelegate {
                @AssertCalled(count = 1, order = [1])
                override fun onLocationChange(session: GeckoSession, url: String?) {
                    assertThat("URL should match", url, equalTo(testUri))
                }

                @AssertCalled(count = 1, order = [2])
                override fun onTitleChange(session: GeckoSession, title: String?) {
                    assertThat("Title should not be empty", title, not(isEmptyOrNullString()))
                }
            })
        }
    }

    fun testLoadExpectError(testUri: String, expectedCategory: Int,
                            expectedError: Int) {
        testLoadErrorWithErrorPage(testUri, expectedCategory,
                expectedError, createTestUrl(HELLO_HTML_PATH))
        testLoadErrorWithErrorPage(testUri, expectedCategory,
                expectedError, null)
    }

    fun testLoadEarlyErrorWithErrorPage(testUri: String, expectedCategory: Int,
                                        expectedError: Int,
                                        errorPageUrl: String?) {
        sessionRule.delegateDuringNextWait(
                object : Callbacks.ProgressDelegate, Callbacks.NavigationDelegate, Callbacks.ContentDelegate {

                    @AssertCalled(false)
                    override fun onPageStart(session: GeckoSession, url: String) {
                        assertThat("URI should be " + testUri, url, equalTo(testUri))
                    }

                    @AssertCalled(count = 1, order = [1])
                    override fun onLoadError(session: GeckoSession, uri: String?,
                                             error: WebRequestError): GeckoResult<String>? {
                        assertThat("Error category should match", error.category,
                                equalTo(expectedCategory))
                        assertThat("Error code should match", error.code,
                                equalTo(expectedError))
                        return GeckoResult.fromValue(errorPageUrl)
                    }

                    @AssertCalled(false)
                    override fun onPageStop(session: GeckoSession, success: Boolean) {
                    }
                })

        sessionRule.session.loadUri(testUri)
        sessionRule.waitUntilCalled(Callbacks.NavigationDelegate::class, "onLoadError")

        if (errorPageUrl != null) {
            sessionRule.waitUntilCalled(object: Callbacks.ContentDelegate {
                @AssertCalled(count = 1)
                override fun onTitleChange(session: GeckoSession, title: String?) {
                    assertThat("Title should not be empty", title, not(isEmptyOrNullString()))
                }
            })
        }
    }

    fun testLoadEarlyError(testUri: String, expectedCategory: Int,
                           expectedError: Int) {
        testLoadEarlyErrorWithErrorPage(testUri, expectedCategory, expectedError, createTestUrl(HELLO_HTML_PATH))
        testLoadEarlyErrorWithErrorPage(testUri, expectedCategory, expectedError, null)
    }

    @Test fun loadFileNotFound() {
        testLoadExpectError("file:///test.mozilla",
                WebRequestError.ERROR_CATEGORY_URI,
                WebRequestError.ERROR_FILE_NOT_FOUND)

        val promise = mainSession.evaluatePromiseJS("document.addCertException(false)")
        var exceptionCaught = false
        try {
            val result = promise.value as Boolean
            assertThat("Promise should not resolve", result, equalTo(false))
        } catch (e: GeckoSessionTestRule.RejectedPromiseException) {
            exceptionCaught = true;
        }
        assertThat("document.addCertException failed with exception", exceptionCaught, equalTo(true))
    }

    @Test fun loadUnknownHost() {
        testLoadExpectError(UNKNOWN_HOST_URI,
                WebRequestError.ERROR_CATEGORY_URI,
                WebRequestError.ERROR_UNKNOWN_HOST)
    }

    @Test fun loadInvalidUri() {
        testLoadEarlyError(INVALID_URI,
                WebRequestError.ERROR_CATEGORY_URI,
                WebRequestError.ERROR_MALFORMED_URI)
    }

    @Test fun loadBadPort() {
        testLoadEarlyError("http://localhost:1/",
                WebRequestError.ERROR_CATEGORY_NETWORK,
                WebRequestError.ERROR_PORT_BLOCKED)
    }

    @Test fun loadUntrusted() {
        val host = if (sessionRule.env.isAutomation) {
            "expired.example.com"
        } else {
            "expired.badssl.com"
        }
        val uri = "https://$host/"
        testLoadExpectError(uri,
                WebRequestError.ERROR_CATEGORY_SECURITY,
                WebRequestError.ERROR_SECURITY_BAD_CERT)

        mainSession.waitForJS("document.addCertException(false)")
        mainSession.delegateDuringNextWait(
                object : Callbacks.ProgressDelegate, Callbacks.NavigationDelegate, Callbacks.ContentDelegate {
                    @AssertCalled(count = 1, order = [1])
                    override fun onPageStart(session: GeckoSession, url: String) {
                        assertThat("URI should be " + uri, url, equalTo(uri))
                    }

                    @AssertCalled(count = 1, order = [2])
                    override fun onPageStop(session: GeckoSession, success: Boolean) {
                        assertThat("Load should succeed", success, equalTo(true))
                        sessionRule.removeCertOverride(host, -1)
                    }
                })
        mainSession.evaluateJS("location.reload()")
        mainSession.waitForPageStop()
    }

    @Ignore // Disabled for bug 1619344.
    @Test fun loadUnknownProtocol() {
        testLoadEarlyError(UNKNOWN_PROTOCOL_URI,
                WebRequestError.ERROR_CATEGORY_URI,
                WebRequestError.ERROR_UNKNOWN_PROTOCOL)
    }

    @Test fun loadUnknownProtocolIframe() {
        // Should match iframe URI from IFRAME_UNKNOWN_PROTOCOL
        val iframeUri = "foo://bar"
        sessionRule.session.loadTestPath(IFRAME_UNKNOWN_PROTOCOL)
        sessionRule.session.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 1)
            override fun onLoadRequest(session: GeckoSession, request: LoadRequest) : GeckoResult<AllowOrDeny>? {
                assertThat("URI should not be null", request.uri, notNullValue())
                assertThat("URI should match", request.uri, endsWith(IFRAME_UNKNOWN_PROTOCOL))
                return null
            }

            @AssertCalled(count = 1)
            override fun onSubframeLoadRequest(session: GeckoSession,
                                               request: LoadRequest):
                                               GeckoResult<AllowOrDeny>? {
                assertThat("URI should not be null", request.uri, notNullValue())
                assertThat("URI should match", request.uri, endsWith(iframeUri))
                return null
            }
        })
    }

    @Setting(key = Setting.Key.USE_TRACKING_PROTECTION, value = "true")
    @Ignore // TODO: Bug 1564373
    @Test fun trackingProtection() {
        val category = ContentBlocking.AntiTracking.TEST
        sessionRule.runtime.settings.contentBlocking.setAntiTracking(category)
        sessionRule.session.loadTestPath(TRACKERS_PATH)

        sessionRule.waitUntilCalled(
                object : Callbacks.ContentBlockingDelegate {
            @AssertCalled(count = 3)
            override fun onContentBlocked(session: GeckoSession,
                                          event: ContentBlocking.BlockEvent) {
                assertThat("Category should be set",
                           event.antiTrackingCategory,
                           equalTo(category))
                assertThat("URI should not be null", event.uri, notNullValue())
                assertThat("URI should match", event.uri, endsWith("tracker.js"))
            }

            @AssertCalled(false)
            override fun onContentLoaded(session: GeckoSession, event: ContentBlocking.BlockEvent) {
            }
        })

        sessionRule.session.settings.useTrackingProtection = false

        sessionRule.session.reload()
        sessionRule.session.waitForPageStop()

        sessionRule.forCallbacksDuringWait(
                object : Callbacks.ContentBlockingDelegate {
            @AssertCalled(false)
            override fun onContentBlocked(session: GeckoSession,
                                          event: ContentBlocking.BlockEvent) {
            }

            @AssertCalled(count = 3)
            override fun onContentLoaded(session: GeckoSession, event: ContentBlocking.BlockEvent) {
                assertThat("Category should be set",
                           event.antiTrackingCategory,
                           equalTo(category))
                assertThat("URI should not be null", event.uri, notNullValue())
                assertThat("URI should match", event.uri, endsWith("tracker.js"))
            }
        })
    }

    @Test fun redirectLoad() {
        val redirectUri = if (sessionRule.env.isAutomation) {
            "http://example.org/tests/junit/hello.html"
        } else {
            "http://jigsaw.w3.org/HTTP/300/Overview.html"
        }
        val uri = if (sessionRule.env.isAutomation) {
            "http://example.org/tests/junit/simple_redirect.sjs?$redirectUri"
        } else {
            "http://jigsaw.w3.org/HTTP/300/301.html"
        }

        sessionRule.session.loadUri(uri)
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 2, order = [1, 2])
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("URI should not be null", request.uri, notNullValue())
                assertThat("URL should match", request.uri,
                        equalTo(forEachCall(request.uri, redirectUri)))
                assertThat("Trigger URL should be null", request.triggerUri,
                           nullValue())
                assertThat("From app should be correct", request.isDirectNavigation,
                        equalTo(forEachCall(true, false)))
                assertThat("Target should not be null", request.target, notNullValue())
                assertThat("Target should match", request.target,
                        equalTo(GeckoSession.NavigationDelegate.TARGET_WINDOW_CURRENT))
                assertThat("Redirect flag is set", request.isRedirect,
                        equalTo(forEachCall(false, true)))
                return null
            }
        })
    }

    @Test fun redirectLoadIframe() {
        val path = if (sessionRule.env.isAutomation) {
            IFRAME_REDIRECT_AUTOMATION
        } else {
            IFRAME_REDIRECT_LOCAL
        }

        sessionRule.session.loadTestPath(path)
        sessionRule.waitForPageStop()

        // We shouldn't be firing onLoadRequest for iframes, including redirects.
        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 1)
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                    GeckoResult<AllowOrDeny>? {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("App requested this load", request.isDirectNavigation, equalTo(true))
                assertThat("URI should not be null", request.uri, notNullValue())
                assertThat("URI should match", request.uri, endsWith(path))
                assertThat("isRedirect should match", request.isRedirect, equalTo(false))
                return null
            }

            @AssertCalled(count = 2)
            override fun onSubframeLoadRequest(session: GeckoSession,
                                               request: LoadRequest):
                    GeckoResult<AllowOrDeny>? {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("App did not request this load", request.isDirectNavigation, equalTo(false))
                assertThat("URI should not be null", request.uri, notNullValue())
                assertThat("isRedirect should match", request.isRedirect,
                        equalTo(forEachCall(false, true)))
                return null
            }
        })
    }

    @Test fun redirectDenyLoad() {
        val redirectUri = if (sessionRule.env.isAutomation) {
            "http://example.org/tests/junit/hello.html"
        } else {
            "http://jigsaw.w3.org/HTTP/300/Overview.html"
        }
        val uri = if (sessionRule.env.isAutomation) {
            "http://example.org/tests/junit/simple_redirect.sjs?$redirectUri"
        } else {
            "http://jigsaw.w3.org/HTTP/300/301.html"
        }

        sessionRule.delegateDuringNextWait(
                object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 2, order = [1, 2])
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("URI should not be null", request.uri, notNullValue())
                assertThat("URL should match", request.uri,
                        equalTo(forEachCall(request.uri, redirectUri)))
                assertThat("Trigger URL should be null", request.triggerUri,
                           nullValue())
                assertThat("From app should be correct", request.isDirectNavigation,
                        equalTo(forEachCall(true, false)))
                assertThat("Target should not be null", request.target, notNullValue())
                assertThat("Target should match", request.target,
                        equalTo(GeckoSession.NavigationDelegate.TARGET_WINDOW_CURRENT))
                assertThat("Redirect flag is set", request.isRedirect,
                        equalTo(forEachCall(false, true)))

                return forEachCall(
                    GeckoResult.fromValue(AllowOrDeny.ALLOW),
                    GeckoResult.fromValue(AllowOrDeny.DENY))
            }
        })

        sessionRule.session.loadUri(uri)
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(
                object : Callbacks.ProgressDelegate {
            @AssertCalled(count = 1, order = [1])
            override fun onPageStart(session: GeckoSession, url: String) {
                assertThat("URL should match", url, equalTo(uri))
            }
        })
    }

    @Test fun redirectIntentLoad() {
        assumeThat(sessionRule.env.isAutomation, equalTo(true))

        val redirectUri = "intent://test"
        val uri = "http://example.org/tests/junit/simple_redirect.sjs?$redirectUri"

        sessionRule.session.loadUri(uri)
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 2, order = [1, 2])
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                assertThat("URL should match", request.uri, equalTo(forEachCall(uri, redirectUri)))
                assertThat("From app should be correct", request.isDirectNavigation,
                        equalTo(forEachCall(true, false)))
                return null
            }
        })
    }


    @Test fun bypassClassifier() {
        val phishingUri = "https://www.itisatrap.org/firefox/its-a-trap.html"
        val category = ContentBlocking.SafeBrowsing.PHISHING

        sessionRule.runtime.settings.contentBlocking.setSafeBrowsing(category)

        sessionRule.session.loadUri(phishingUri + "?bypass=true",
                                    GeckoSession.LOAD_FLAGS_BYPASS_CLASSIFIER)
        sessionRule.session.waitForPageStop()

        sessionRule.forCallbacksDuringWait(
                object : Callbacks.NavigationDelegate {
            @AssertCalled(false)
            override fun onLoadError(session: GeckoSession, uri: String?,
                                     error: WebRequestError): GeckoResult<String>? {
                return null
            }
        })
    }

    @Test fun safebrowsingPhishing() {
        val phishingUri = "https://www.itisatrap.org/firefox/its-a-trap.html"
        val category = ContentBlocking.SafeBrowsing.PHISHING

        sessionRule.runtime.settings.contentBlocking.setSafeBrowsing(category)

        // Add query string to avoid bypassing classifier check because of cache.
        testLoadExpectError(phishingUri + "?block=true",
                        WebRequestError.ERROR_CATEGORY_SAFEBROWSING,
                        WebRequestError.ERROR_SAFEBROWSING_PHISHING_URI)

        sessionRule.runtime.settings.contentBlocking.setSafeBrowsing(ContentBlocking.SafeBrowsing.NONE)

        sessionRule.session.loadUri(phishingUri + "?block=false")
        sessionRule.session.waitForPageStop()

        sessionRule.forCallbacksDuringWait(
                object : Callbacks.NavigationDelegate {
            @AssertCalled(false)
            override fun onLoadError(session: GeckoSession, uri: String?,
                                     error: WebRequestError): GeckoResult<String>? {
                return null
            }
        })
    }

    @Test fun safebrowsingMalware() {
        val malwareUri = "https://www.itisatrap.org/firefox/its-an-attack.html"
        val category = ContentBlocking.SafeBrowsing.MALWARE

        sessionRule.runtime.settings.contentBlocking.setSafeBrowsing(category)

        testLoadExpectError(malwareUri + "?block=true",
                        WebRequestError.ERROR_CATEGORY_SAFEBROWSING,
                        WebRequestError.ERROR_SAFEBROWSING_MALWARE_URI)

        sessionRule.runtime.settings.contentBlocking.setSafeBrowsing(ContentBlocking.SafeBrowsing.NONE)

        sessionRule.session.loadUri(malwareUri + "?block=false")
        sessionRule.session.waitForPageStop()

        sessionRule.forCallbacksDuringWait(
                object : Callbacks.NavigationDelegate {
            @AssertCalled(false)
            override fun onLoadError(session: GeckoSession, uri: String?,
                                     error: WebRequestError): GeckoResult<String>? {
                return null
            }
        })
    }

    @Test fun safebrowsingUnwanted() {
        val unwantedUri = "https://www.itisatrap.org/firefox/unwanted.html"
        val category = ContentBlocking.SafeBrowsing.UNWANTED

        sessionRule.runtime.settings.contentBlocking.setSafeBrowsing(category)

        testLoadExpectError(unwantedUri + "?block=true",
                        WebRequestError.ERROR_CATEGORY_SAFEBROWSING,
                        WebRequestError.ERROR_SAFEBROWSING_UNWANTED_URI)

        sessionRule.runtime.settings.contentBlocking.setSafeBrowsing(ContentBlocking.SafeBrowsing.NONE)

        sessionRule.session.loadUri(unwantedUri + "?block=false")
        sessionRule.session.waitForPageStop()

        sessionRule.forCallbacksDuringWait(
                object : Callbacks.NavigationDelegate {
            @AssertCalled(false)
            override fun onLoadError(session: GeckoSession, uri: String?,
                                     error: WebRequestError): GeckoResult<String>? {
                return null
            }
        })
    }

    @Test fun safebrowsingHarmful() {
        val harmfulUri = "https://www.itisatrap.org/firefox/harmful.html"
        val category = ContentBlocking.SafeBrowsing.HARMFUL

        sessionRule.runtime.settings.contentBlocking.setSafeBrowsing(category)

        testLoadExpectError(harmfulUri + "?block=true",
                        WebRequestError.ERROR_CATEGORY_SAFEBROWSING,
                        WebRequestError.ERROR_SAFEBROWSING_HARMFUL_URI)

        sessionRule.runtime.settings.contentBlocking.setSafeBrowsing(ContentBlocking.SafeBrowsing.NONE)

        sessionRule.session.loadUri(harmfulUri + "?block=false")
        sessionRule.session.waitForPageStop()

        sessionRule.forCallbacksDuringWait(
                object : Callbacks.NavigationDelegate {
            @AssertCalled(false)
            override fun onLoadError(session: GeckoSession, uri: String?,
                                     error: WebRequestError): GeckoResult<String>? {
                return null
            }
        })
    }

    // Checks that the User Agent matches the user agent built in
    // nsHttpHandler::BuildUserAgent
    @Test fun defaultUserAgentMatchesActualUserAgent() {
        var userAgent = sessionRule.waitForResult(sessionRule.session.userAgent)
        assertThat("Mobile user agent should match the default user agent",
                userAgent, equalTo(GeckoSession.getDefaultUserAgent()))
    }

    @Test fun desktopMode() {
        sessionRule.session.loadUri("https://example.com")
        sessionRule.waitForPageStop()

        val userAgentJs = "window.navigator.userAgent"
        val mobileSubStr = "Mobile"
        val desktopSubStr = "X11"

        assertThat("User agent should be set to mobile",
                   sessionRule.session.evaluateJS(userAgentJs) as String,
                   containsString(mobileSubStr))

        var userAgent = sessionRule.waitForResult(sessionRule.session.userAgent)
        assertThat("User agent should be reported as mobile",
                    userAgent, containsString(mobileSubStr))

        sessionRule.session.settings.userAgentMode = GeckoSessionSettings.USER_AGENT_MODE_DESKTOP

        sessionRule.session.reload()
        sessionRule.session.waitForPageStop()

        assertThat("User agent should be set to desktop",
                   sessionRule.session.evaluateJS(userAgentJs) as String,
                   containsString(desktopSubStr))

        userAgent = sessionRule.waitForResult(sessionRule.session.userAgent)
        assertThat("User agent should be reported as desktop",
                    userAgent, containsString(desktopSubStr))

        sessionRule.session.settings.userAgentMode = GeckoSessionSettings.USER_AGENT_MODE_MOBILE

        sessionRule.session.reload()
        sessionRule.session.waitForPageStop()

        assertThat("User agent should be set to mobile",
                   sessionRule.session.evaluateJS(userAgentJs) as String,
                   containsString(mobileSubStr))

        userAgent = sessionRule.waitForResult(sessionRule.session.userAgent)
        assertThat("User agent should be reported as mobile",
                    userAgent, containsString(mobileSubStr))

        val vrSubStr = "Mobile VR"
        sessionRule.session.settings.userAgentMode = GeckoSessionSettings.USER_AGENT_MODE_VR

        sessionRule.session.reload()
        sessionRule.session.waitForPageStop()

        assertThat("User agent should be set to VR",
                sessionRule.session.evaluateJS(userAgentJs) as String,
                containsString(vrSubStr))

        userAgent = sessionRule.waitForResult(sessionRule.session.userAgent)
        assertThat("User agent should be reported as VR",
                userAgent, containsString(vrSubStr))

    }

    @Test fun uaOverride() {
        sessionRule.session.loadUri("https://example.com")
        sessionRule.waitForPageStop()

        val userAgentJs = "window.navigator.userAgent"
        val mobileSubStr = "Mobile"
        val vrSubStr = "Mobile VR"
        val overrideUserAgent = "This is the override user agent"

        var userAgent = sessionRule.session.evaluateJS(userAgentJs) as String
        assertThat("User agent should be reported as mobile",
                userAgent, containsString(mobileSubStr))

        sessionRule.session.settings.userAgentOverride = overrideUserAgent

        sessionRule.session.reload()
        sessionRule.session.waitForPageStop()

        userAgent = sessionRule.session.evaluateJS(userAgentJs) as String

        assertThat("User agent should be reported as override",
                userAgent, equalTo(overrideUserAgent))

        sessionRule.session.settings.userAgentMode = GeckoSessionSettings.USER_AGENT_MODE_VR

        sessionRule.session.reload()
        sessionRule.session.waitForPageStop()

        assertThat("User agent should still be reported as override even when USER_AGENT_MODE is set",
                userAgent, equalTo(overrideUserAgent))

        sessionRule.session.settings.userAgentOverride = null

        sessionRule.session.reload()
        sessionRule.session.waitForPageStop()

        userAgent = sessionRule.session.evaluateJS(userAgentJs) as String
        assertThat("User agent should now be reported as VR",
                userAgent, containsString(vrSubStr))

        sessionRule.delegateDuringNextWait(object : Callbacks.NavigationDelegate {
            override fun onLoadRequest(session: GeckoSession, request: LoadRequest): GeckoResult<AllowOrDeny>? {
                sessionRule.session.settings.userAgentOverride = overrideUserAgent
                return null
            }
        })

        sessionRule.session.reload()
        sessionRule.session.waitForPageStop()

        userAgent = sessionRule.session.evaluateJS(userAgentJs) as String

        assertThat("User agent should be reported as override after being set in onLoadRequest",
                userAgent, equalTo(overrideUserAgent))

        sessionRule.delegateDuringNextWait(object : Callbacks.NavigationDelegate {
            override fun onLoadRequest(session: GeckoSession, request: LoadRequest): GeckoResult<AllowOrDeny>? {
                sessionRule.session.settings.userAgentOverride = null
                return null
            }
        })

        sessionRule.session.reload()
        sessionRule.session.waitForPageStop()

        userAgent = sessionRule.session.evaluateJS(userAgentJs) as String
        assertThat("User agent should again be reported as VR after disabling override in onLoadRequest",
                userAgent, containsString(vrSubStr))
    }

    @WithDisplay(width = 600, height = 200)
    @Test fun viewportMode() {
        sessionRule.session.loadTestPath(VIEWPORT_PATH)
        sessionRule.waitForPageStop()

        val desktopInnerWidth = 980.0
        val physicalWidth = 600.0
        val pixelRatio = sessionRule.session.evaluateJS("window.devicePixelRatio") as Double
        val mobileInnerWidth = physicalWidth / pixelRatio
        val innerWidthJs = "window.innerWidth"

        var innerWidth = sessionRule.session.evaluateJS(innerWidthJs) as Double
        assertThat("innerWidth should be equal to $mobileInnerWidth",
                innerWidth, closeTo(mobileInnerWidth, 0.1))

        sessionRule.session.settings.viewportMode = GeckoSessionSettings.VIEWPORT_MODE_DESKTOP

        sessionRule.session.reload()
        sessionRule.session.waitForPageStop()

        innerWidth = sessionRule.session.evaluateJS(innerWidthJs) as Double
        assertThat("innerWidth should be equal to $desktopInnerWidth", innerWidth,
                closeTo(desktopInnerWidth, 0.1))

        sessionRule.session.settings.viewportMode = GeckoSessionSettings.VIEWPORT_MODE_MOBILE

        sessionRule.session.reload()
        sessionRule.session.waitForPageStop()

        innerWidth = sessionRule.session.evaluateJS(innerWidthJs) as Double
        assertThat("innerWidth should be equal to $mobileInnerWidth again",
                innerWidth, closeTo(mobileInnerWidth, 0.1))
    }

    @Suppress("deprecation")
    @Ignore // This test needs to set RuntimeSettings, TODO: Bug 1572245
    @Test fun telemetrySnapshots() {
        sessionRule.session.loadTestPath(HELLO_HTML_PATH)
        sessionRule.waitForPageStop()

        val telemetry = sessionRule.runtime.telemetry
        val result = sessionRule.waitForResult(telemetry.getSnapshots(false))

        assertThat("Snapshots should not be null",
                   result?.get("parent"), notNullValue())

        if (sessionRule.env.isMultiprocess) {
            assertThat("Snapshots should not be null",
                       result?.get("content"), notNullValue())
        }
    }

    @Test fun load() {
        sessionRule.session.loadUri("$TEST_ENDPOINT$HELLO_HTML_PATH")
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 1, order = [1])
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("URI should not be null", request.uri, notNullValue())
                assertThat("URI should match", request.uri, endsWith(HELLO_HTML_PATH))
                assertThat("Trigger URL should be null", request.triggerUri,
                           nullValue())
                assertThat("App requested this load", request.isDirectNavigation,
                        equalTo(true))
                assertThat("Target should not be null", request.target, notNullValue())
                assertThat("Target should match", request.target,
                           equalTo(GeckoSession.NavigationDelegate.TARGET_WINDOW_CURRENT))
                assertThat("Redirect flag is not set", request.isRedirect, equalTo(false))
                assertThat("Should not have a user gesture", request.hasUserGesture, equalTo(false))
                return null
            }

            @AssertCalled(count = 1, order = [2])
            override fun onLocationChange(session: GeckoSession, url: String?) {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("URL should not be null", url, notNullValue())
                assertThat("URL should match", url, endsWith(HELLO_HTML_PATH))
            }

            @AssertCalled(count = 1, order = [2])
            override fun onCanGoBack(session: GeckoSession, canGoBack: Boolean) {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("Cannot go back", canGoBack, equalTo(false))
            }

            @AssertCalled(count = 1, order = [2])
            override fun onCanGoForward(session: GeckoSession, canGoForward: Boolean) {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("Cannot go forward", canGoForward, equalTo(false))
            }

            @AssertCalled(false)
            override fun onNewSession(session: GeckoSession, uri: String): GeckoResult<GeckoSession>? {
                return null
            }
        })
    }

    @Test fun load_dataUri() {
        val dataUrl = "data:,Hello%2C%20World!"
        sessionRule.session.loadUri(dataUrl)
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate, Callbacks.ProgressDelegate {
            @AssertCalled(count = 1)
            override fun onLocationChange(session: GeckoSession, url: String?) {
                assertThat("URL should match the provided data URL", url, equalTo(dataUrl))
            }

            @AssertCalled(count = 1)
            override fun onPageStop(session: GeckoSession, success: Boolean) {
                assertThat("Page should load successfully", success, equalTo(true))
            }
        })
    }

    @NullDelegate(GeckoSession.NavigationDelegate::class)
    @Test fun load_withoutNavigationDelegate() {
        // Test that when navigation delegate is disabled, we can still perform loads.
        sessionRule.session.loadTestPath(HELLO_HTML_PATH)
        sessionRule.session.waitForPageStop()

        sessionRule.session.reload()
        sessionRule.session.waitForPageStop()
    }

    @NullDelegate(GeckoSession.NavigationDelegate::class)
    @Test fun load_canUnsetNavigationDelegate() {
        // Test that if we unset the navigation delegate during a load, the load still proceeds.
        var onLocationCount = 0
        sessionRule.session.navigationDelegate = object : Callbacks.NavigationDelegate {
            override fun onLocationChange(session: GeckoSession, url: String?) {
                onLocationCount++
            }
        }
        sessionRule.session.loadTestPath(HELLO_HTML_PATH)
        sessionRule.session.waitForPageStop()

        assertThat("Should get callback for first load",
                   onLocationCount, equalTo(1))

        sessionRule.session.reload()
        sessionRule.session.navigationDelegate = null
        sessionRule.session.waitForPageStop()

        assertThat("Should not get callback for second load",
                   onLocationCount, equalTo(1))
    }

    @Test fun loadString() {
        val dataString = "<html><head><title>TheTitle</title></head><body>TheBody</body></html>"
        val mimeType = "text/html"
        sessionRule.session.loadString(dataString, mimeType)
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate, Callbacks.ProgressDelegate, Callbacks.ContentDelegate {
            @AssertCalled
            override fun onTitleChange(session: GeckoSession, title: String?) {
                assertThat("Title should match", title, equalTo("TheTitle"))
            }

            @AssertCalled(count = 1)
            override fun onLocationChange(session: GeckoSession, url: String?) {
                assertThat("URL should be a data URL", url,
                           equalTo(GeckoSession.createDataUri(dataString, mimeType)))
            }

            @AssertCalled(count = 1)
            override fun onPageStop(session: GeckoSession, success: Boolean) {
                assertThat("Page should load successfully", success, equalTo(true))
            }
        })
    }

    @Test fun loadString_noMimeType() {
        sessionRule.session.loadString("Hello, World!", null)
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate, Callbacks.ProgressDelegate {
            @AssertCalled(count = 1)
            override fun onLocationChange(session: GeckoSession, url: String?) {
                assertThat("URL should be a data URL", url, startsWith("data:"))
            }

            @AssertCalled(count = 1)
            override fun onPageStop(session: GeckoSession, success: Boolean) {
                assertThat("Page should load successfully", success, equalTo(true))
            }
        })
    }

    @Test fun loadData_html() {
        val bytes = getTestBytes(HELLO_HTML_PATH)
        assertThat("test html should have data", bytes.size, greaterThan(0))

        sessionRule.session.loadData(bytes, "text/html")
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate, Callbacks.ProgressDelegate, Callbacks.ContentDelegate {
            @AssertCalled(count = 1)
            override fun onTitleChange(session: GeckoSession, title: String?) {
                assertThat("Title should match", title, equalTo("Hello, world!"))
            }

            @AssertCalled(count = 1)
            override fun onLocationChange(session: GeckoSession, url: String?) {
                assertThat("URL should match", url, equalTo(GeckoSession.createDataUri(bytes, "text/html")))
            }

            @AssertCalled(count = 1)
            override fun onPageStop(session: GeckoSession, success: Boolean) {
                assertThat("Page should load successfully", success, equalTo(true))
            }
        })
    }

    fun loadDataHelper(assetPath: String, mimeType: String? = null) {
        val bytes = getTestBytes(assetPath)
        assertThat("test data should have bytes", bytes.size, greaterThan(0))

        sessionRule.session.loadData(bytes, mimeType)
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate, Callbacks.ProgressDelegate {
            @AssertCalled(count = 1)
            override fun onLocationChange(session: GeckoSession, url: String?) {
                assertThat("URL should match", url, equalTo(GeckoSession.createDataUri(bytes, mimeType)))
            }

            @AssertCalled(count = 1)
            override fun onPageStop(session: GeckoSession, success: Boolean) {
                assertThat("Page should load successfully", success, equalTo(true))
            }
        })
    }


    @Test fun loadData() {
        loadDataHelper("/assets/www/images/test.gif", "image/gif")
    }

    @Test fun loadData_noMimeType() {
        loadDataHelper("/assets/www/images/test.gif")
    }

    @Test fun reload() {
        sessionRule.session.loadUri("$TEST_ENDPOINT$HELLO_HTML_PATH")
        sessionRule.waitForPageStop()

        sessionRule.session.reload()
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 1, order = [1])
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                assertThat("URI should match", request.uri, endsWith(HELLO_HTML_PATH))
                assertThat("Trigger URL should be null", request.triggerUri,
                           nullValue())
                assertThat("Target should match", request.target,
                           equalTo(GeckoSession.NavigationDelegate.TARGET_WINDOW_CURRENT))
                assertThat("Load should not be direct", request.isDirectNavigation,
                        equalTo(false))
                return null
            }

            @AssertCalled(count = 1, order = [2])
            override fun onLocationChange(session: GeckoSession, url: String?) {
                assertThat("URL should match", url, endsWith(HELLO_HTML_PATH))
            }

            @AssertCalled(count = 1, order = [2])
            override fun onCanGoBack(session: GeckoSession, canGoBack: Boolean) {
                assertThat("Cannot go back", canGoBack, equalTo(false))
            }

            @AssertCalled(count = 1, order = [2])
            override fun onCanGoForward(session: GeckoSession, canGoForward: Boolean) {
                assertThat("Cannot go forward", canGoForward, equalTo(false))
            }

            @AssertCalled(false)
            override fun onNewSession(session: GeckoSession, uri: String): GeckoResult<GeckoSession>? {
                return null
            }
        })
    }

    @Test fun goBackAndForward() {
        sessionRule.session.loadUri("$TEST_ENDPOINT$HELLO_HTML_PATH")
        sessionRule.waitForPageStop()

        sessionRule.session.loadUri("$TEST_ENDPOINT$HELLO2_HTML_PATH")
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 1)
            override fun onLocationChange(session: GeckoSession, url: String?) {
                assertThat("URL should match", url, endsWith(HELLO2_HTML_PATH))
            }
        })

        sessionRule.session.goBack()
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 0, order = [1])
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                assertThat("Load should not be direct", request.isDirectNavigation,
                        equalTo(false))
                return null
            }

            @AssertCalled(count = 1, order = [2])
            override fun onLocationChange(session: GeckoSession, url: String?) {
                assertThat("URL should match", url, endsWith(HELLO_HTML_PATH))
            }

            @AssertCalled(count = 1, order = [2])
            override fun onCanGoBack(session: GeckoSession, canGoBack: Boolean) {
                assertThat("Cannot go back", canGoBack, equalTo(false))
            }

            @AssertCalled(count = 1, order = [2])
            override fun onCanGoForward(session: GeckoSession, canGoForward: Boolean) {
                assertThat("Can go forward", canGoForward, equalTo(true))
            }

            @AssertCalled(false)
            override fun onNewSession(session: GeckoSession, uri: String): GeckoResult<GeckoSession>? {
                return null
            }
        })

        sessionRule.session.goForward()
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 0, order = [1])
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                assertThat("Load should not be direct", request.isDirectNavigation,
                        equalTo(false))
                return null
            }

            @AssertCalled(count = 1, order = [2])
            override fun onLocationChange(session: GeckoSession, url: String?) {
                assertThat("URL should match", url, endsWith(HELLO2_HTML_PATH))
            }

            @AssertCalled(count = 1, order = [2])
            override fun onCanGoBack(session: GeckoSession, canGoBack: Boolean) {
                assertThat("Can go back", canGoBack, equalTo(true))
            }

            @AssertCalled(count = 1, order = [2])
            override fun onCanGoForward(session: GeckoSession, canGoForward: Boolean) {
                assertThat("Cannot go forward", canGoForward, equalTo(false))
            }

            @AssertCalled(false)
            override fun onNewSession(session: GeckoSession, uri: String): GeckoResult<GeckoSession>? {
                return null
            }
        })
    }

    @Test fun onLoadUri_returnTrueCancelsLoad() {
        sessionRule.delegateDuringNextWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 2)
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                val res : AllowOrDeny
                if (request.uri.endsWith(HELLO_HTML_PATH)) {
                    res = AllowOrDeny.DENY
                } else {
                    res = AllowOrDeny.ALLOW
                }
                return GeckoResult.fromValue(res)
            }
        })

        sessionRule.session.loadTestPath(HELLO_HTML_PATH)
        sessionRule.session.loadTestPath(HELLO2_HTML_PATH)
        sessionRule.waitForPageStop()

        sessionRule.forCallbacksDuringWait(object : Callbacks.ProgressDelegate {
            @AssertCalled(count = 1, order = [1])
            override fun onPageStart(session: GeckoSession, url: String) {
                assertThat("URL should match", url, endsWith(HELLO2_HTML_PATH))
            }

            @AssertCalled(count = 1, order = [2])
            override fun onPageStop(session: GeckoSession, success: Boolean) {
                assertThat("Load should succeed", success, equalTo(true))
            }
        })
    }

    @Test fun onNewSession_calledForWindowOpen() {
        // Disable popup blocker.
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to false))

        sessionRule.session.loadTestPath(NEW_SESSION_HTML_PATH)
        sessionRule.session.waitForPageStop()

        sessionRule.session.evaluateJS("window.open('newSession_child.html', '_blank')")

        sessionRule.session.waitUntilCalled(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 1, order = [1])
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                assertThat("URI should be correct", request.uri, endsWith(NEW_SESSION_CHILD_HTML_PATH))
                assertThat("Trigger URL should match", request.triggerUri,
                           endsWith(NEW_SESSION_HTML_PATH))
                assertThat("Target should be correct", request.target,
                           equalTo(GeckoSession.NavigationDelegate.TARGET_WINDOW_NEW))
                assertThat("Load should not be direct", request.isDirectNavigation,
                        equalTo(false))
                return null
            }

            @AssertCalled(count = 1, order = [2])
            override fun onNewSession(session: GeckoSession, uri: String): GeckoResult<GeckoSession>? {
                assertThat("URI should be correct", uri, endsWith(NEW_SESSION_CHILD_HTML_PATH))
                return null
            }
        })
    }

    @Test(expected = GeckoSessionTestRule.RejectedPromiseException::class)
    fun onNewSession_rejectLocal() {
        // Disable popup blocker.
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to false))

        sessionRule.session.loadTestPath(NEW_SESSION_HTML_PATH)
        sessionRule.session.waitForPageStop()

        sessionRule.session.evaluateJS("window.open('file:///data/local/tmp', '_blank')")
    }

    @Test fun onNewSession_calledForTargetBlankLink() {
        // Disable popup blocker.
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to false))

        sessionRule.session.loadTestPath(NEW_SESSION_HTML_PATH)
        sessionRule.session.waitForPageStop()

        sessionRule.session.evaluateJS("document.querySelector('#targetBlankLink').click()")

        sessionRule.session.waitUntilCalled(object : Callbacks.NavigationDelegate {
            // We get two onLoadRequest calls for the link click,
            // one when loading the URL and one when opening a new window.
            @AssertCalled(count = 1, order = [1])
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                assertThat("URI should be correct", request.uri, endsWith(NEW_SESSION_CHILD_HTML_PATH))
                assertThat("Trigger URL should be null", request.triggerUri,
                           endsWith(NEW_SESSION_HTML_PATH))
                assertThat("Target should be correct", request.target,
                           equalTo(GeckoSession.NavigationDelegate.TARGET_WINDOW_NEW))
                return null
            }

            @AssertCalled(count = 1, order = [2])
            override fun onNewSession(session: GeckoSession, uri: String): GeckoResult<GeckoSession>? {
                assertThat("URI should be correct", uri, endsWith(NEW_SESSION_CHILD_HTML_PATH))
                return null
            }
        })
    }

    private fun delegateNewSession(settings: GeckoSessionSettings = mainSession.settings): GeckoSession {
        val newSession = sessionRule.createClosedSession(settings)

        sessionRule.session.delegateDuringNextWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 1)
            override fun onNewSession(session: GeckoSession, uri: String): GeckoResult<GeckoSession> {
                return GeckoResult.fromValue(newSession)
            }
        })

        return newSession
    }

    @Test fun onNewSession_childShouldLoad() {
        // Disable popup blocker.
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to false))

        sessionRule.session.loadTestPath(NEW_SESSION_HTML_PATH)
        sessionRule.session.waitForPageStop()

        val newSession = delegateNewSession()
        sessionRule.session.evaluateJS("document.querySelector('#targetBlankLink').click()")
        // about:blank
        newSession.waitForPageStop()
        // NEW_SESSION_CHILD_HTML_PATH
        newSession.waitForPageStop()

        newSession.forCallbacksDuringWait(object : Callbacks.ProgressDelegate {
            @AssertCalled(count = 1)
            override fun onPageStart(session: GeckoSession, url: String) {
                assertThat("URL should match", url, endsWith(NEW_SESSION_CHILD_HTML_PATH))
            }

            @AssertCalled(count = 1)
            override fun onPageStop(session: GeckoSession, success: Boolean) {
                assertThat("Load should succeed", success, equalTo(true))
            }
        })
    }

    @Test fun onNewSession_setWindowOpener() {
        // Disable popup blocker.
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to false))

        sessionRule.session.loadTestPath(NEW_SESSION_HTML_PATH)
        sessionRule.session.waitForPageStop()

        val newSession = delegateNewSession()
        sessionRule.session.evaluateJS("document.querySelector('#targetBlankLink').click()")
        newSession.waitForPageStop()

        assertThat("window.opener should be set",
                   newSession.evaluateJS("window.opener.location.pathname") as String,
                   equalTo(NEW_SESSION_HTML_PATH))
    }

    @Test fun onNewSession_supportNoOpener() {
        // Disable popup blocker.
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to false))

        sessionRule.session.loadTestPath(NEW_SESSION_HTML_PATH)
        sessionRule.session.waitForPageStop()

        val newSession = delegateNewSession()
        sessionRule.session.evaluateJS("document.querySelector('#noOpenerLink').click()")
        newSession.waitForPageStop()

        assertThat("window.opener should not be set",
                   newSession.evaluateJS("window.opener"),
                   equalTo(JSONObject.NULL))
    }

    @Test fun onNewSession_notCalledForHandledLoads() {
        // Disable popup blocker.
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to false))

        sessionRule.session.loadTestPath(NEW_SESSION_HTML_PATH)
        sessionRule.session.waitForPageStop()

        sessionRule.session.delegateDuringNextWait(object : Callbacks.NavigationDelegate {
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                // Pretend we handled the target="_blank" link click.
                val res : AllowOrDeny
                if (request.uri.endsWith(NEW_SESSION_CHILD_HTML_PATH)) {
                    res = AllowOrDeny.DENY
                } else {
                    res = AllowOrDeny.ALLOW
                }
                return GeckoResult.fromValue(res)
            }
        })

        sessionRule.session.evaluateJS("document.querySelector('#targetBlankLink').click()")

        sessionRule.session.reload()
        sessionRule.session.waitForPageStop()

        // Assert that onNewSession was not called for the link click.
        sessionRule.session.forCallbacksDuringWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 2)
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                assertThat("URI must match", request.uri,
                           endsWith(forEachCall(NEW_SESSION_CHILD_HTML_PATH, NEW_SESSION_HTML_PATH)))
                assertThat("Load should not be direct", request.isDirectNavigation,
                        equalTo(false))
                return null
            }

            @AssertCalled(count = 0)
            override fun onNewSession(session: GeckoSession, uri: String): GeckoResult<GeckoSession>? {
                return null
            }
        })
    }

    @Test fun loadUriReferrer() {
        val uri = "https://example.com"
        val referrer = "https://foo.org/"

        sessionRule.session.loadUri(uri, referrer, GeckoSession.LOAD_FLAGS_NONE)
        sessionRule.session.waitForPageStop()

        assertThat("Referrer should match",
                   sessionRule.session.evaluateJS("document.referrer") as String,
                   equalTo(referrer))
    }

    @Test fun loadUriReferrerSession() {
        val uri = "https://example.com/bar"
        val referrer = "https://example.org/foo"

        sessionRule.session.loadUri(referrer)
        sessionRule.session.waitForPageStop()

        val newSession = sessionRule.createOpenSession()
        newSession.loadUri(uri, sessionRule.session, GeckoSession.LOAD_FLAGS_NONE)
        newSession.waitForPageStop()

        assertThat("Referrer should match",
                newSession.evaluateJS("document.referrer") as String,
                equalTo(referrer))
    }

    @Test fun loadUriReferrerSessionFileUrl() {
        val uri = "file:///system/etc/fonts.xml"
        val referrer = "https://example.org"

        sessionRule.session.loadUri(referrer)
        sessionRule.session.waitForPageStop()

        val newSession = sessionRule.createOpenSession()
        newSession.loadUri(uri, sessionRule.session, GeckoSession.LOAD_FLAGS_NONE)
        newSession.waitUntilCalled(object : Callbacks.NavigationDelegate {
            @AssertCalled
            override fun onLoadError(session: GeckoSession, uri: String?, error: WebRequestError): GeckoResult<String>? {
                return null
            }
        })
    }

    @Test fun loadUriHeader() {
        val headers = mapOf<String, String>("Header1" to "Value", "Header2" to "Value1, Value2")

        sessionRule.session.loadUri("$TEST_ENDPOINT/anything", headers)
        sessionRule.session.waitForPageStop()

        val content = sessionRule.session.evaluateJS("document.body.children[0].innerHTML") as String
        val body = JSONObject(content)

        MatcherAssert.assertThat("Headers should match", body.getJSONObject("headers")
                .getString("Header1"), equalTo("Value"))
        MatcherAssert.assertThat("Headers should match", body.getJSONObject("headers")
                .getString("Header2"), equalTo("Value1, Value2"))
    }

    @Ignore("HttpBin incorrectly filters empty field values")
    @Test fun loadUriHeaderEmptyFieldValue() {
        val headers = mapOf<String?, String?>(
                "ValueLess1" to "",
                "ValueLess2" to null)

        sessionRule.session.loadUri("$TEST_ENDPOINT/anything", headers)
        sessionRule.session.waitForPageStop()

        val content = sessionRule.session.evaluateJS("document.body.children[0].innerHTML") as String
        val body = JSONObject(content)
        val headersJSON = body.getJSONObject("headers")

        MatcherAssert.assertThat("Header with no field value should be included",
                headersJSON.has("ValueLess1"))
        MatcherAssert.assertThat("Header with no field value should be included",
                headersJSON.has("ValueLess2"))
    }

    @Test fun loadUriHeaderBadOverrides() {
        val headers = mapOf<String?, String?>(
                null to "BadNull",
                "Connection" to "BadConnection",
                "Host" to "BadHost")

        sessionRule.session.loadUri("$TEST_ENDPOINT/anything", headers)
        sessionRule.session.waitForPageStop()

        val content = sessionRule.session.evaluateJS("document.body.children[0].innerHTML") as String
        val body = JSONObject(content)
        val headersJSON = body.getJSONObject("headers")

        headersJSON.keys().forEach { key ->
            MatcherAssert.assertThat( "No value field should be empty or null",
                    headersJSON.optString(key), not(isEmptyOrNullString()))
            MatcherAssert.assertThat( "No value field should be only whitespace",
                    headersJSON.getString(key).trim(), not(isEmptyOrNullString()))
            MatcherAssert.assertThat( "BadNull should not exist as a header value",
                    headersJSON.getString(key), not("BadNull"))
        }

        MatcherAssert.assertThat("Headers should not match", headersJSON
                .getString("Connection"), not("BadConnection"))
        MatcherAssert.assertThat("Headers should not match", headersJSON
                .getString("Host"), not("BadHost"))

    }

    @Test(expected = GeckoResult.UncaughtException::class)
    fun onNewSession_doesNotAllowOpened() {
        // Disable popup blocker.
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to false))

        sessionRule.session.loadTestPath(NEW_SESSION_HTML_PATH)
        sessionRule.session.waitForPageStop()

        sessionRule.session.delegateDuringNextWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 1)
            override fun onNewSession(session: GeckoSession, uri: String): GeckoResult<GeckoSession> {
                return GeckoResult.fromValue(sessionRule.createOpenSession())
            }
        })

        sessionRule.session.evaluateJS("document.querySelector('#targetBlankLink').click()")

        sessionRule.session.waitUntilCalled(GeckoSession.NavigationDelegate::class,
                                            "onNewSession")
        UiThreadUtils.loopUntilIdle(sessionRule.env.defaultTimeoutMillis)
    }

    @Test
    fun extensionProcessSwitching() {
        sessionRule.setPrefsUntilTestEnd(mapOf(
                "xpinstall.signatures.required" to false,
                "extensions.install.requireBuiltInCerts" to false,
                "extensions.update.requireBuiltInCerts" to false
        ))

        val controller = sessionRule.runtime.webExtensionController

        sessionRule.addExternalDelegateUntilTestEnd(
                WebExtensionController.PromptDelegate::class,
                controller::setPromptDelegate,
                { controller.promptDelegate = null },
                object : WebExtensionController.PromptDelegate {
            @AssertCalled
            override fun onInstallPrompt(extension: WebExtension): GeckoResult<AllowOrDeny> {
                return GeckoResult.fromValue(AllowOrDeny.ALLOW)
            }
        })

        val extension = sessionRule.waitForResult(
                controller.install("https://example.org/tests/junit/page-history.xpi"))

        assertThat("baseUrl should be a valid extension URL",
                extension.metaData!!.baseUrl, startsWith("moz-extension://"))

        val url = extension.metaData!!.baseUrl + "page.html"
        val isRemote = sessionRule.getPrefs("extensions.webextensions.remote")[0] as Boolean
        processSwitchingTest(url, isRemote)

        sessionRule.waitForResult(controller.uninstall(extension))
    }

    @Test
    fun mainProcessSwitching() {
        processSwitchingTest("about:config")
    }

    fun processSwitchingTest(url: String, isRemoteExtension: Boolean = false) {
        val settings = sessionRule.runtime.settings
        val aboutConfigEnabled = settings.aboutConfigEnabled
        settings.aboutConfigEnabled = true

        var currentUrl: String? = null
        mainSession.delegateUntilTestEnd(object: GeckoSession.NavigationDelegate {
            override fun onLocationChange(session: GeckoSession, url: String?) {
                currentUrl = url
            }

            override fun onLoadError(session: GeckoSession, uri: String?, error: WebRequestError): GeckoResult<String>? {
                assertThat("Should not get here", false, equalTo(true))
                return null
            }
        })

        // This loads in the parent process
        mainSession.loadUri(url)
        // Switching processes involves loading about:blank
        sessionRule.waitForPageStops(2)

        assertThat("URL should match", currentUrl!!, equalTo(url))

        // This will load a page in the child
        mainSession.loadTestPath(HELLO_HTML_PATH)
        sessionRule.waitForPageStops(2)

        assertThat("URL should match", currentUrl!!, endsWith(HELLO_HTML_PATH))

        mainSession.loadUri(url)
        sessionRule.waitForPageStops(2)

        assertThat("URL should match", currentUrl!!, equalTo(url))

        // History navigation to or from the extension process does not trigger
        // an about:blank load when browser.tabs.documentchannel == true
        sessionRule.session.goBack()
        sessionRule.waitForPageStops(if (isRemoteExtension) 1 else 2)

        assertThat("URL should match", currentUrl!!, endsWith(HELLO_HTML_PATH))

        sessionRule.session.goBack()
        sessionRule.waitForPageStops(if (isRemoteExtension) 1 else 2)

        assertThat("URL should match", currentUrl!!, equalTo(url))

        settings.aboutConfigEnabled = aboutConfigEnabled
    }

    @Test fun setLocationHash() {
        sessionRule.session.loadUri("$TEST_ENDPOINT$HELLO_HTML_PATH")
        sessionRule.waitForPageStop()

        sessionRule.session.evaluateJS("location.hash = 'test1';")

        sessionRule.session.waitUntilCalled(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 0)
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                assertThat("Load should not be direct", request.isDirectNavigation,
                        equalTo(false))
                return null
            }

            @AssertCalled(count = 1)
            override fun onLocationChange(session: GeckoSession, url: String?) {
                assertThat("URI should match", url, endsWith("#test1"))
            }
        })

        sessionRule.session.evaluateJS("location.hash = 'test2';")

        sessionRule.session.waitUntilCalled(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 0)
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest):
                                       GeckoResult<AllowOrDeny>? {
                return null
            }

            @AssertCalled(count = 1)
            override fun onLocationChange(session: GeckoSession, url: String?) {
                assertThat("URI should match", url, endsWith("#test2"))
            }
        })
    }

    @Test fun purgeHistory() {
        sessionRule.session.loadUri("$TEST_ENDPOINT$HELLO_HTML_PATH")
        sessionRule.waitUntilCalled(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 1)
            override fun onCanGoBack(session: GeckoSession, canGoBack: Boolean) {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("Cannot go back", canGoBack, equalTo(false))
            }

            @AssertCalled(count = 1)
            override fun onCanGoForward(session: GeckoSession, canGoForward: Boolean) {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("Cannot go forward", canGoForward, equalTo(false))
            }
        })
        sessionRule.session.loadUri("$TEST_ENDPOINT$HELLO2_HTML_PATH")
        sessionRule.waitUntilCalled(object : Callbacks.All {
            @AssertCalled(count = 1)
            override fun onCanGoBack(session: GeckoSession, canGoBack: Boolean) {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("Cannot go back", canGoBack, equalTo(true))
            }
            @AssertCalled(count = 1)
            override fun onCanGoForward(session: GeckoSession, canGoForward: Boolean) {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("Cannot go forward", canGoForward, equalTo(false))
            }
            @AssertCalled(count = 1)
            override fun onHistoryStateChange(session: GeckoSession, state: GeckoSession.HistoryDelegate.HistoryList) {
                assertThat("History should have two entries", state.size, equalTo(2))
            }
        })
        sessionRule.session.purgeHistory()
        sessionRule.waitUntilCalled(object : Callbacks.All {
            @AssertCalled(count = 1)
            override fun onHistoryStateChange(session: GeckoSession, state: GeckoSession.HistoryDelegate.HistoryList) {
                assertThat("History should have one entry", state.size, equalTo(1))
            }
            @AssertCalled(count = 1)
            override fun onCanGoBack(session: GeckoSession, canGoBack: Boolean) {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("Cannot go back", canGoBack, equalTo(false))
            }

            @AssertCalled(count = 1)
            override fun onCanGoForward(session: GeckoSession, canGoForward: Boolean) {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("Cannot go forward", canGoForward, equalTo(false))
            }
        })
    }

    @WithDisplay(width = 100, height = 100)
    @Test fun userGesture() {
        mainSession.loadUri("$TEST_ENDPOINT$CLICK_TO_RELOAD_HTML_PATH")
        mainSession.waitForPageStop()

        mainSession.synthesizeTap(50, 50)

        sessionRule.waitUntilCalled(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 1)
            override fun onLoadRequest(session: GeckoSession, request: LoadRequest): GeckoResult<AllowOrDeny>? {
                assertThat("Should have a user gesture", request.hasUserGesture, equalTo(true))
                assertThat("Load should not be direct", request.isDirectNavigation,
                        equalTo(false))
                return GeckoResult.fromValue(AllowOrDeny.ALLOW)
            }
        })
    }

    @Test fun loadAfterLoad() {
        sessionRule.session.delegateDuringNextWait(object : Callbacks.NavigationDelegate {
            @AssertCalled(count = 2)
            override fun onLoadRequest(session: GeckoSession, request: LoadRequest): GeckoResult<AllowOrDeny>? {
                assertThat("URLs should match", request.uri, endsWith(forEachCall(HELLO_HTML_PATH, HELLO2_HTML_PATH)))
                return GeckoResult.fromValue(AllowOrDeny.ALLOW)
            }
        })

        mainSession.loadUri("$TEST_ENDPOINT$HELLO_HTML_PATH")
        mainSession.loadUri("$TEST_ENDPOINT$HELLO2_HTML_PATH")
        mainSession.waitForPageStop()
    }

}
