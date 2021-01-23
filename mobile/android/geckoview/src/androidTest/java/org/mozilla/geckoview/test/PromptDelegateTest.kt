package org.mozilla.geckoview.test

import org.mozilla.geckoview.AllowOrDeny
import org.mozilla.geckoview.GeckoResult
import org.mozilla.geckoview.GeckoSession
import org.mozilla.geckoview.GeckoSession.NavigationDelegate.LoadRequest
import org.mozilla.geckoview.GeckoSession.PromptDelegate
import org.mozilla.geckoview.test.rule.GeckoSessionTestRule
import org.mozilla.geckoview.test.rule.GeckoSessionTestRule.AssertCalled
import org.mozilla.geckoview.test.util.Callbacks

import androidx.test.filters.MediumTest
import androidx.test.ext.junit.runners.AndroidJUnit4
import org.hamcrest.Matchers.*
import org.junit.Assert
import org.junit.Ignore
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
@MediumTest
class PromptDelegateTest : BaseSessionTest() {
    @Test fun popupTestAllow() {
        // Ensure popup blocking is enabled for this test.
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to true))

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate, Callbacks.NavigationDelegate {
            @AssertCalled(count = 1)
            override fun onPopupPrompt(session: GeckoSession, prompt: PromptDelegate.PopupPrompt)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("URL should not be null", prompt.targetUri, notNullValue())
                assertThat("URL should match", prompt.targetUri, endsWith(HELLO_HTML_PATH))
                return GeckoResult.fromValue(prompt.confirm(AllowOrDeny.ALLOW))
            }

            @AssertCalled(count = 2)
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest): GeckoResult<AllowOrDeny>? {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("URL should not be null", request.uri, notNullValue())
                assertThat("URL should match", request.uri, endsWith(forEachCall(POPUP_HTML_PATH, HELLO_HTML_PATH)))
                return null
            }

            @AssertCalled(count = 1)
            override fun onNewSession(session: GeckoSession, uri: String): GeckoResult<GeckoSession>? {
                assertThat("URL should not be null", uri, notNullValue())
                assertThat("URL should match", uri, endsWith(HELLO_HTML_PATH))
                return null
            }
        })

        sessionRule.session.loadTestPath(POPUP_HTML_PATH)
        sessionRule.waitUntilCalled(Callbacks.NavigationDelegate::class, "onNewSession")
    }

    @Test fun popupTestBlock() {
        // Ensure popup blocking is enabled for this test.
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to true))

        sessionRule.delegateUntilTestEnd(object : Callbacks.PromptDelegate, Callbacks.NavigationDelegate {
            @AssertCalled(count = 1)
            override fun onPopupPrompt(session: GeckoSession, prompt: PromptDelegate.PopupPrompt)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("URL should not be null", prompt.targetUri, notNullValue())
                assertThat("URL should match", prompt.targetUri, endsWith(HELLO_HTML_PATH))
                return GeckoResult.fromValue(prompt.confirm(AllowOrDeny.DENY))
            }

            @AssertCalled(count = 1)
            override fun onLoadRequest(session: GeckoSession,
                                       request: LoadRequest): GeckoResult<AllowOrDeny>? {
                assertThat("Session should not be null", session, notNullValue())
                assertThat("URL should not be null", request.uri, notNullValue())
                assertThat("URL should match", request.uri, endsWith(POPUP_HTML_PATH))
                return null
            }

            @AssertCalled(count = 0)
            override fun onNewSession(session: GeckoSession, uri: String): GeckoResult<GeckoSession>? {
                return null
            }
        })

        sessionRule.session.loadTestPath(POPUP_HTML_PATH)
        sessionRule.waitForPageStop()
        sessionRule.session.waitForRoundTrip()
    }

    @Ignore // TODO: Reenable when 1501574 is fixed.
    @Test fun alertTest() {
        sessionRule.session.evaluateJS("alert('Alert!');")

        sessionRule.waitUntilCalled(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onAlertPrompt(session: GeckoSession, prompt: PromptDelegate.AlertPrompt): GeckoResult<PromptDelegate.PromptResponse> {
                assertThat("Message should match", "Alert!", equalTo(prompt.message))
                return GeckoResult.fromValue(prompt.dismiss())
            }
        })
    }

    @Test fun authTest() {
        sessionRule.session.loadTestPath("/basic-auth/foo/bar")

        sessionRule.waitUntilCalled(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onAuthPrompt(session: GeckoSession, prompt: PromptDelegate.AuthPrompt): GeckoResult<PromptDelegate.PromptResponse>? {
                //TODO: Figure out some better testing here.
                return null
            }
        })
    }

    @Test fun buttonTest() {
        sessionRule.session.loadTestPath(HELLO_HTML_PATH)
        sessionRule.waitForPageStop()

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onButtonPrompt(session: GeckoSession, prompt: PromptDelegate.ButtonPrompt): GeckoResult<PromptDelegate.PromptResponse> {
                assertThat("Message should match", "Confirm?", equalTo(prompt.message))
                return GeckoResult.fromValue(prompt.confirm(PromptDelegate.ButtonPrompt.Type.POSITIVE))
            }
        })

        assertThat("Result should match",
                sessionRule.session.waitForJS("confirm('Confirm?')") as Boolean,
                equalTo(true))

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onButtonPrompt(session: GeckoSession, prompt: PromptDelegate.ButtonPrompt): GeckoResult<PromptDelegate.PromptResponse> {
                assertThat("Message should match", "Confirm?", equalTo(prompt.message))
                return GeckoResult.fromValue(prompt.confirm(PromptDelegate.ButtonPrompt.Type.NEGATIVE))
            }
        })

        assertThat("Result should match",
                sessionRule.session.waitForJS("confirm('Confirm?')") as Boolean,
                equalTo(false))
    }

    @Test
    fun onBeforeUnloadTest() {
        sessionRule.setPrefsUntilTestEnd(mapOf(
                "dom.require_user_interaction_for_beforeunload" to false
        ))
        sessionRule.session.loadTestPath(BEFORE_UNLOAD)
        sessionRule.waitForPageStop()

        val result = GeckoResult<Void>()
        sessionRule.delegateUntilTestEnd(object: Callbacks.ProgressDelegate {
            override fun onPageStart(session: GeckoSession, url: String) {
                assertThat("Only HELLO2_HTML_PATH should load", url, endsWith(HELLO2_HTML_PATH))
                result.complete(null)
            }
        })

        var promptResult = GeckoResult<PromptDelegate.PromptResponse>()
        sessionRule.delegateUntilTestEnd(object : Callbacks.PromptDelegate {
            override fun onBeforeUnloadPrompt(session: GeckoSession, prompt: PromptDelegate.BeforeUnloadPrompt): GeckoResult<PromptDelegate.PromptResponse>? {
                // We have to return something here because otherwise the delegate will be invoked
                // before we have a chance to override it in the waitUntilCalled call below
                return promptResult
            }
        })

        // This will try to load "hello.html" but will be denied, if the request
        // goes through anyway the onLoadRequest delegate above will throw an exception
        sessionRule.session.evaluateJS("document.querySelector('#navigateAway').click()")
        sessionRule.waitUntilCalled(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onBeforeUnloadPrompt(session: GeckoSession, prompt: PromptDelegate.BeforeUnloadPrompt): GeckoResult<PromptDelegate.PromptResponse>? {
                promptResult.complete(prompt.confirm(AllowOrDeny.DENY))
                return promptResult
            }
        })

        // This request will go through and end the test. Doing the negative case first will
        // ensure that if either of this tests fail the test will fail.
        promptResult = GeckoResult()
        sessionRule.session.evaluateJS("document.querySelector('#navigateAway2').click()")
        sessionRule.waitUntilCalled(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onBeforeUnloadPrompt(session: GeckoSession, prompt: PromptDelegate.BeforeUnloadPrompt): GeckoResult<PromptDelegate.PromptResponse>? {
                promptResult.complete(prompt.confirm(AllowOrDeny.ALLOW))
                return promptResult
            }
        })

        sessionRule.waitForResult(result)
    }

    @Test fun textTest() {
        sessionRule.session.loadTestPath(HELLO_HTML_PATH)
        sessionRule.session.waitForPageStop()

        sessionRule.delegateUntilTestEnd(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onTextPrompt(session: GeckoSession, prompt: PromptDelegate.TextPrompt): GeckoResult<PromptDelegate.PromptResponse> {
                assertThat("Message should match", "Prompt:", equalTo(prompt.message))
                assertThat("Default should match", "default", equalTo(prompt.defaultValue))
                return GeckoResult.fromValue(prompt.confirm("foo"))
            }
        })

        assertThat("Result should match",
                sessionRule.session.waitForJS("prompt('Prompt:', 'default')") as String,
                equalTo("foo"))
    }

    @Ignore // TODO: Figure out weird test env behavior here.
    @Test fun choiceTest() {
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to false))

        sessionRule.session.loadTestPath(PROMPT_HTML_PATH)
        sessionRule.session.waitForPageStop()

        sessionRule.session.evaluateJS("document.getElementById('selectexample').click();")

        sessionRule.waitUntilCalled(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onChoicePrompt(session: GeckoSession, prompt: PromptDelegate.ChoicePrompt): GeckoResult<PromptDelegate.PromptResponse> {
                return GeckoResult.fromValue(prompt.dismiss())
            }
        })
    }

    @Test fun colorTest() {
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to false))

        sessionRule.session.loadTestPath(PROMPT_HTML_PATH)
        sessionRule.session.waitForPageStop()

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onColorPrompt(session: GeckoSession, prompt: PromptDelegate.ColorPrompt): GeckoResult<PromptDelegate.PromptResponse> {
                assertThat("Value should match", "#ffffff", equalTo(prompt.defaultValue))
                return GeckoResult.fromValue(prompt.confirm("#123456"))
            }
        })

        sessionRule.session.evaluateJS("""
            this.c = document.getElementById('colorexample');
        """.trimIndent())

        val promise = sessionRule.session.evaluatePromiseJS("""
            new Promise((resolve, reject) => {
                this.c.addEventListener(
                    'change',
                    event => resolve(event.target.value),
                    false
                );
            })""".trimIndent())

        sessionRule.session.evaluateJS("this.c.click();")

        assertThat("Value should match",
                promise.value as String,
                equalTo("#123456"))
    }

    @Ignore // TODO: Figure out weird test env behavior here.
    @Test fun dateTest() {
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to false))

        sessionRule.session.loadTestPath(PROMPT_HTML_PATH)
        sessionRule.session.waitForPageStop()

        sessionRule.session.evaluateJS("document.getElementById('dateexample').click();")

        sessionRule.waitUntilCalled(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onDateTimePrompt(session: GeckoSession, prompt: PromptDelegate.DateTimePrompt): GeckoResult<PromptDelegate.PromptResponse> {
                return GeckoResult.fromValue(prompt.dismiss())
            }
        })
    }

    @Test fun fileTest() {
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.disable_open_during_load" to false))

        sessionRule.session.loadTestPath(PROMPT_HTML_PATH)
        sessionRule.session.waitForPageStop()

        sessionRule.session.evaluateJS("document.getElementById('fileexample').click();")

        sessionRule.waitUntilCalled(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onFilePrompt(session: GeckoSession, prompt: PromptDelegate.FilePrompt): GeckoResult<PromptDelegate.PromptResponse> {
                assertThat("Length of mimeTypes should match", 2, equalTo(prompt.mimeTypes!!.size))
                assertThat("First accept attribute should match", "image/*", equalTo(prompt.mimeTypes?.get(0)))
                assertThat("Second accept attribute should match", ".pdf", equalTo(prompt.mimeTypes?.get(1)))
                assertThat("Capture attribute should match", PromptDelegate.FilePrompt.Capture.USER, equalTo(prompt.capture))
                return GeckoResult.fromValue(prompt.dismiss())
            }
        })
    }

    @Test fun shareTextSucceeds() {
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.webshare.requireinteraction" to false))
        mainSession.loadTestPath(HELLO_HTML_PATH)
        mainSession.waitForPageStop()

        val shareText = "Example share text"

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onSharePrompt(session: GeckoSession, prompt: PromptDelegate.SharePrompt): GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Text field is not null", prompt.text, notNullValue())
                assertThat("Title field is null", prompt.title, nullValue())
                assertThat("Url field is null", prompt.uri, nullValue())
                assertThat("Text field contains correct value", prompt.text, equalTo(shareText))
                return GeckoResult.fromValue(prompt.confirm(PromptDelegate.SharePrompt.Result.SUCCESS))
            }
        })

        try {
            mainSession.waitForJS("""window.navigator.share({text: "${shareText}"})""")
        } catch (e: GeckoSessionTestRule.RejectedPromiseException) {
            Assert.fail("Share must succeed." + e.reason as String)
        }
    }

    @Test fun shareUrlSucceeds() {
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.webshare.requireinteraction" to false))
        mainSession.loadTestPath(HELLO_HTML_PATH)
        mainSession.waitForPageStop()

        val shareUrl = "https://example.com/"

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onSharePrompt(session: GeckoSession, prompt: PromptDelegate.SharePrompt): GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Text field is null", prompt.text, nullValue())
                assertThat("Title field is null", prompt.title, nullValue())
                assertThat("Url field is not null", prompt.uri, notNullValue())
                assertThat("Text field contains correct value", prompt.uri, equalTo(shareUrl))
                return GeckoResult.fromValue(prompt.confirm(PromptDelegate.SharePrompt.Result.SUCCESS))
            }
        })

        try {
            mainSession.waitForJS("""window.navigator.share({url: "${shareUrl}"})""")
        } catch (e: GeckoSessionTestRule.RejectedPromiseException) {
            Assert.fail("Share must succeed." + e.reason as String)
        }
    }

    @Test fun shareTitleSucceeds() {
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.webshare.requireinteraction" to false))
        mainSession.loadTestPath(HELLO_HTML_PATH)
        mainSession.waitForPageStop()

        val shareTitle = "Title!"

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onSharePrompt(session: GeckoSession, prompt: PromptDelegate.SharePrompt): GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Text field is null", prompt.text, nullValue())
                assertThat("Title field is not null", prompt.title, notNullValue())
                assertThat("Url field is null", prompt.uri, nullValue())
                assertThat("Text field contains correct value", prompt.title, equalTo(shareTitle))
                return GeckoResult.fromValue(prompt.confirm(PromptDelegate.SharePrompt.Result.SUCCESS))
            }
        })

        try {
            mainSession.waitForJS("""window.navigator.share({title: "${shareTitle}"})""")
        } catch (e: GeckoSessionTestRule.RejectedPromiseException) {
            Assert.fail("Share must succeed." + e.reason as String)
        }
    }

    @Test fun failedShareReturnsDataError() {
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.webshare.requireinteraction" to false))
        mainSession.loadTestPath(HELLO_HTML_PATH)
        mainSession.waitForPageStop()

        val shareUrl = "https://www.example.com"

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onSharePrompt(session: GeckoSession, prompt: PromptDelegate.SharePrompt): GeckoResult<PromptDelegate.PromptResponse>? {
                return GeckoResult.fromValue(prompt.confirm(PromptDelegate.SharePrompt.Result.FAILURE))
            }
        })

        try {
            mainSession.waitForJS("""window.navigator.share({url: "${shareUrl}"})""")
            Assert.fail("Request should have failed")
        } catch (e: GeckoSessionTestRule.RejectedPromiseException) {
            assertThat("Error should be correct",
                    e.reason as String, containsString("DataError"))
        }
    }

    @Test fun abortedShareReturnsAbortError() {
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.webshare.requireinteraction" to false))
        mainSession.loadTestPath(HELLO_HTML_PATH)
        mainSession.waitForPageStop()

        val shareUrl = "https://www.example.com"

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onSharePrompt(session: GeckoSession, prompt: PromptDelegate.SharePrompt): GeckoResult<PromptDelegate.PromptResponse>? {
                return GeckoResult.fromValue(prompt.confirm(PromptDelegate.SharePrompt.Result.ABORT))
            }
        })

        try {
            mainSession.waitForJS("""window.navigator.share({url: "${shareUrl}"})""")
            Assert.fail("Request should have failed")
        } catch (e: GeckoSessionTestRule.RejectedPromiseException) {
            assertThat("Error should be correct",
                    e.reason as String, containsString("AbortError"))
        }
    }

    @Test fun dismissedShareReturnsAbortError() {
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.webshare.requireinteraction" to false))
        mainSession.loadTestPath(HELLO_HTML_PATH)
        mainSession.waitForPageStop()

        val shareUrl = "https://www.example.com"

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onSharePrompt(session: GeckoSession, prompt: PromptDelegate.SharePrompt): GeckoResult<PromptDelegate.PromptResponse>? {
                return GeckoResult.fromValue(prompt.dismiss())
            }
        })

        try {
            mainSession.waitForJS("""window.navigator.share({url: "${shareUrl}"})""")
            Assert.fail("Request should have failed")
        } catch (e: GeckoSessionTestRule.RejectedPromiseException) {
            assertThat("Error should be correct",
                    e.reason as String, containsString("AbortError"))
        }
    }

    @Test fun emptyShareReturnsTypeError() {
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.webshare.requireinteraction" to false))
        mainSession.loadTestPath(HELLO_HTML_PATH)
        mainSession.waitForPageStop()

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 0)
            override fun onSharePrompt(session: GeckoSession, prompt: PromptDelegate.SharePrompt): GeckoResult<PromptDelegate.PromptResponse>? {
                return GeckoResult.fromValue(prompt.dismiss())
            }
        })

        try {
            mainSession.waitForJS("""window.navigator.share({})""")
            Assert.fail("Request should have failed")
        } catch (e: GeckoSessionTestRule.RejectedPromiseException) {
            assertThat("Error should be correct",
                    e.reason as String, containsString("TypeError"))
        }
    }

    @Test fun invalidShareUrlReturnsTypeError() {
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.webshare.requireinteraction" to false))
        mainSession.loadTestPath(HELLO_HTML_PATH)
        mainSession.waitForPageStop()

        // Invalid port should cause URL parser to fail.
        val shareUrl = "http://www.example.com:123456"

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 0)
            override fun onSharePrompt(session: GeckoSession, prompt: PromptDelegate.SharePrompt): GeckoResult<PromptDelegate.PromptResponse>? {
                return GeckoResult.fromValue(prompt.dismiss())
            }
        })

        try {
            mainSession.waitForJS("""window.navigator.share({url: "${shareUrl}"})""")
            Assert.fail("Request should have failed")
        } catch (e: GeckoSessionTestRule.RejectedPromiseException) {
            assertThat("Error should be correct",
                    e.reason as String, containsString("TypeError"))
        }
    }

    @Test fun shareRequiresUserInteraction() {
        sessionRule.setPrefsUntilTestEnd(mapOf("dom.webshare.requireinteraction" to true))
        mainSession.loadTestPath(HELLO_HTML_PATH)
        mainSession.waitForPageStop()

        val shareUrl = "https://www.example.com"

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 0)
            override fun onSharePrompt(session: GeckoSession, prompt: PromptDelegate.SharePrompt): GeckoResult<PromptDelegate.PromptResponse>? {
                return GeckoResult.fromValue(prompt.dismiss())
            }
        })

        try {
            mainSession.waitForJS("""window.navigator.share({url: "${shareUrl}"})""")
            Assert.fail("Request should have failed")
        } catch (e: GeckoSessionTestRule.RejectedPromiseException) {
            assertThat("Error should be correct",
                    e.reason as String, containsString("NotAllowedError"))
        }
    }
}
