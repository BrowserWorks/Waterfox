/* -*- Mode: Java; c-basic-offset: 4; tab-width: 4; indent-tabs-mode: nil; -*-
 * Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

package org.mozilla.geckoview.test

import androidx.test.filters.MediumTest
import androidx.test.ext.junit.runners.AndroidJUnit4

import android.os.Handler

import org.hamcrest.Matchers.*

import org.junit.Ignore
import org.junit.Test
import org.junit.runner.RunWith

import org.mozilla.geckoview.GeckoResult
import org.mozilla.geckoview.GeckoSession
import org.mozilla.geckoview.GeckoSession.PromptDelegate
import org.mozilla.geckoview.GeckoSession.PromptDelegate.AutocompleteRequest
import org.mozilla.geckoview.Autocomplete
import org.mozilla.geckoview.Autocomplete.LoginEntry
import org.mozilla.geckoview.Autocomplete.LoginSaveOption
import org.mozilla.geckoview.Autocomplete.LoginSelectOption
import org.mozilla.geckoview.Autocomplete.LoginStorageDelegate
import org.mozilla.geckoview.test.rule.GeckoSessionTestRule
import org.mozilla.geckoview.test.rule.GeckoSessionTestRule.AssertCalled
import org.mozilla.geckoview.test.rule.GeckoSessionTestRule.WithDisplay
import org.mozilla.geckoview.test.util.Callbacks


@RunWith(AndroidJUnit4::class)
@MediumTest
class AutocompleteTest : BaseSessionTest() {
    val acceptDelay: Long = 100

    @Test
    fun fetchLogins() {
        sessionRule.setPrefsUntilTestEnd(mapOf(
                // Enable login management since it's disabled in automation.
                "signon.rememberSignons" to true,
                "signon.autofillForms.http" to true))

        val runtime = sessionRule.runtime
        val register = { delegate: LoginStorageDelegate ->
            runtime.loginStorageDelegate = delegate
        }
        val unregister = { _: LoginStorageDelegate ->
            runtime.loginStorageDelegate = null
        }

        val fetchHandled = GeckoResult<Void>()

        sessionRule.addExternalDelegateDuringNextWait(
                LoginStorageDelegate::class, register, unregister,
                object : LoginStorageDelegate {
            @AssertCalled(count = 1)
            override fun onLoginFetch(domain: String)
                    : GeckoResult<Array<LoginEntry>>? {
                assertThat("Domain should match", domain, equalTo("localhost"))

                Handler().postDelayed({
                    fetchHandled.complete(null)
                }, acceptDelay)

                return null
            }
        })

        mainSession.loadTestPath(FORMS3_HTML_PATH)
        sessionRule.waitForResult(fetchHandled)
    }

    @Test
    fun loginSaveDismiss() {
        sessionRule.setPrefsUntilTestEnd(mapOf(
                // Enable login management since it's disabled in automation.
                "signon.rememberSignons" to true,
                "signon.autofillForms.http" to true,
                "signon.userInputRequiredToCapture.enabled" to false))

        val runtime = sessionRule.runtime
        val register = { delegate: LoginStorageDelegate ->
            runtime.loginStorageDelegate = delegate
        }
        val unregister = { _: LoginStorageDelegate ->
            runtime.loginStorageDelegate = null
        }

        sessionRule.addExternalDelegateDuringNextWait(
                LoginStorageDelegate::class, register, unregister,
                object : LoginStorageDelegate {
            @AssertCalled(count = 1)
            override fun onLoginFetch(domain: String)
                    : GeckoResult<Array<LoginEntry>>? {
                assertThat("Domain should match", domain, equalTo("localhost"))

                return null
            }
        })

        mainSession.loadTestPath(FORMS3_HTML_PATH)
        mainSession.waitForPageStop()

        sessionRule.addExternalDelegateUntilTestEnd(
                LoginStorageDelegate::class, register, unregister,
                object : LoginStorageDelegate {
            @AssertCalled(count = 0)
            override fun onLoginSave(login: LoginEntry) {}
        })

        // Assign login credentials.
        mainSession.evaluateJS("document.querySelector('#user1').value = 'user1x'")
        mainSession.evaluateJS("document.querySelector('#pass1').value = 'pass1x'")

        // Submit the form.
        mainSession.evaluateJS("document.querySelector('#form1').submit()")

        sessionRule.waitUntilCalled(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onLoginSave(
                    session: GeckoSession,
                    prompt: AutocompleteRequest<LoginSaveOption>)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                val option = prompt.options[0]
                val login = option.value

                assertThat("Session should not be null", session, notNullValue())
                assertThat("Login should not be null", login, notNullValue())
                assertThat(
                    "Username should match",
                    login.username,
                    equalTo("user1x"))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo("pass1x"))

                return GeckoResult.fromValue(prompt.dismiss())
            }
        })
    }

    @Test
    fun loginSaveAccept() {
        sessionRule.setPrefsUntilTestEnd(mapOf(
                // Enable login management since it's disabled in automation.
                "signon.rememberSignons" to true,
                "signon.autofillForms.http" to true,
                "signon.userInputRequiredToCapture.enabled" to false))

        val runtime = sessionRule.runtime
        val register = { delegate: LoginStorageDelegate ->
            runtime.loginStorageDelegate = delegate
        }
        val unregister = { _: LoginStorageDelegate ->
            runtime.loginStorageDelegate = null
        }

        mainSession.loadTestPath(FORMS3_HTML_PATH)
        mainSession.waitForPageStop()

        val saveHandled = GeckoResult<Void>()

        sessionRule.addExternalDelegateUntilTestEnd(
                LoginStorageDelegate::class, register, unregister,
                object : LoginStorageDelegate {
            @AssertCalled
            override fun onLoginSave(login: LoginEntry) {
                assertThat(
                    "Username should match",
                    login.username,
                    equalTo("user1x"))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo("pass1x"))

                saveHandled.complete(null)
            }
        })

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onLoginSave(
                    session: GeckoSession,
                    prompt: AutocompleteRequest<LoginSaveOption>)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Session should not be null", session, notNullValue())

                val option = prompt.options[0]
                val login = option.value

                assertThat("Login should not be null", login, notNullValue())

                assertThat(
                    "Username should match",
                    login.username,
                    equalTo("user1x"))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo("pass1x"))

                return GeckoResult.fromValue(prompt.confirm(option))
            }
        })

        // Assign login credentials.
        mainSession.evaluateJS("document.querySelector('#user1').value = 'user1x'")
        mainSession.evaluateJS("document.querySelector('#pass1').value = 'pass1x'")

        // Submit the form.
        mainSession.evaluateJS("document.querySelector('#form1').submit()")

        sessionRule.waitForResult(saveHandled)
    }

    @Test
    fun loginSaveModifyAccept() {
        sessionRule.setPrefsUntilTestEnd(mapOf(
                // Enable login management since it's disabled in automation.
                "signon.rememberSignons" to true,
                "signon.autofillForms.http" to true,
                "signon.userInputRequiredToCapture.enabled" to false))

        val runtime = sessionRule.runtime
        val register = { delegate: LoginStorageDelegate ->
            runtime.loginStorageDelegate = delegate
        }
        val unregister = { _: LoginStorageDelegate ->
            runtime.loginStorageDelegate = null
        }

        mainSession.loadTestPath(FORMS3_HTML_PATH)
        mainSession.waitForPageStop()

        val saveHandled = GeckoResult<Void>()

        sessionRule.addExternalDelegateUntilTestEnd(
                LoginStorageDelegate::class, register, unregister,
                object : LoginStorageDelegate {
            @AssertCalled
            override fun onLoginSave(login: LoginEntry) {
                assertThat(
                    "Username should match",
                    login.username,
                    equalTo("user1x"))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo("pass1xmod"))

                saveHandled.complete(null)
            }
        })

        sessionRule.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onLoginSave(
                    session: GeckoSession,
                    prompt: AutocompleteRequest<LoginSaveOption>)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Session should not be null", session, notNullValue())

                val option = prompt.options[0]
                val login = option.value

                assertThat("Login should not be null", login, notNullValue())

                assertThat(
                    "Username should match",
                    login.username,
                    equalTo("user1x"))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo("pass1x"))

                val modLogin = LoginEntry.Builder()
                        .origin(login.origin)
                        .formActionOrigin(login.origin)
                        .httpRealm(login.httpRealm)
                        .username(login.username)
                        .password("pass1xmod")
                        .build()

                return GeckoResult.fromValue(prompt.confirm(LoginSaveOption(modLogin)))
            }
        })

        // Assign login credentials.
        mainSession.evaluateJS("document.querySelector('#user1').value = 'user1x'")
        mainSession.evaluateJS("document.querySelector('#pass1').value = 'pass1x'")

        // Submit the form.
        mainSession.evaluateJS("document.querySelector('#form1').submit()")

        sessionRule.waitForResult(saveHandled)
    }

    @Test
    fun loginUpdateAccept() {
        sessionRule.setPrefsUntilTestEnd(mapOf(
                // Enable login management since it's disabled in automation.
                "signon.rememberSignons" to true,
                "signon.autofillForms.http" to true,
                "signon.userInputRequiredToCapture.enabled" to false))

        val runtime = sessionRule.runtime
        val register = { delegate: LoginStorageDelegate ->
            runtime.loginStorageDelegate = delegate
        }
        val unregister = { _: LoginStorageDelegate ->
            runtime.loginStorageDelegate = null
        }

        val saveHandled = GeckoResult<Void>()
        val saveHandled2 = GeckoResult<Void>()

        val user1 = "user1x"
        val pass1 = "pass1x"
        val pass2 = "pass1up"
        val guid = "test-guid"
        val savedLogins = mutableListOf<LoginEntry>()

        sessionRule.addExternalDelegateUntilTestEnd(
                LoginStorageDelegate::class, register, unregister,
                object : LoginStorageDelegate {
            @AssertCalled
            override fun onLoginFetch(domain: String)
                    : GeckoResult<Array<LoginEntry>>? {
                assertThat("Domain should match", domain, equalTo("localhost"))

                return GeckoResult.fromValue(savedLogins.toTypedArray())
            }

            @AssertCalled(count = 2)
            override fun onLoginSave(login: LoginEntry) {
                assertThat(
                    "Username should match",
                    login.username,
                    equalTo(user1))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo(forEachCall(pass1, pass2)))

                assertThat(
                    "GUID should match",
                    login.guid,
                    equalTo(forEachCall(null, guid)))

                val savedLogin = LoginEntry.Builder()
                        .guid(guid)
                        .origin(login.origin)
                        .formActionOrigin(login.formActionOrigin)
                        .username(login.username)
                        .password(login.password)
                        .build()

                savedLogins.add(savedLogin)

                if (sessionRule.currentCall.counter == 1) {
                    saveHandled.complete(null)
                } else if (sessionRule.currentCall.counter == 2) {
                    saveHandled2.complete(null)
                }
            }
        })

        sessionRule.delegateUntilTestEnd(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 2)
            override fun onLoginSave(
                    session: GeckoSession,
                    prompt: AutocompleteRequest<LoginSaveOption>)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Session should not be null", session, notNullValue())

                val option = prompt.options[0]
                val login = option.value

                assertThat("Login should not be null", login, notNullValue())

                assertThat(
                    "Username should match",
                    login.username,
                    equalTo(user1))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo(forEachCall(pass1, pass2)))

                return GeckoResult.fromValue(prompt.confirm(option))
            }
        })

        // Assign login credentials.
        mainSession.loadTestPath(FORMS3_HTML_PATH)
        mainSession.waitForPageStop()
        mainSession.evaluateJS("document.querySelector('#user1').value = '$user1'")
        mainSession.evaluateJS("document.querySelector('#pass1').value = '$pass1'")
        mainSession.evaluateJS("document.querySelector('#form1').submit()")

        sessionRule.waitForResult(saveHandled)

        // Update login credentials.
        val session2 = sessionRule.createOpenSession()
        session2.loadTestPath(FORMS3_HTML_PATH)
        session2.waitForPageStop()
        session2.evaluateJS("document.querySelector('#pass1').value = '$pass2'")
        session2.evaluateJS("document.querySelector('#form1').submit()")

        sessionRule.waitForResult(saveHandled2)
    }

    fun testLoginUsed(autofillEnabled: Boolean) {
        sessionRule.setPrefsUntilTestEnd(mapOf(
                // Enable login management since it's disabled in automation.
                "signon.rememberSignons" to true,
                "signon.autofillForms.http" to true,
                "signon.userInputRequiredToCapture.enabled" to false))

        val runtime = sessionRule.runtime
        val register = { delegate: LoginStorageDelegate ->
            runtime.loginStorageDelegate = delegate
        }
        val unregister = { _: LoginStorageDelegate ->
            runtime.loginStorageDelegate = null
        }

        val usedHandled = GeckoResult<Void>()

        val user1 = "user1x"
        val pass1 = "pass1x"
        val guid = "test-guid"
        val origin = GeckoSessionTestRule.TEST_ENDPOINT
        val savedLogin = LoginEntry.Builder()
                .guid(guid)
                .origin(origin)
                .formActionOrigin(origin)
                .username(user1)
                .password(pass1)
                .build()
        val savedLogins = mutableListOf<LoginEntry>(savedLogin)

        if (autofillEnabled) {
            sessionRule.addExternalDelegateUntilTestEnd(
                    LoginStorageDelegate::class, register, unregister,
                    object : LoginStorageDelegate {
                @AssertCalled
                override fun onLoginFetch(domain: String)
                        : GeckoResult<Array<LoginEntry>>? {
                    assertThat("Domain should match", domain, equalTo("localhost"))

                    return GeckoResult.fromValue(savedLogins.toTypedArray())
                }

                @AssertCalled(count = 1)
                override fun onLoginUsed(login: LoginEntry, usedFields: Int) {
                    assertThat(
                        "Used fields should match",
                        usedFields,
                        equalTo(Autocomplete.UsedField.PASSWORD))

                    assertThat(
                        "Username should match",
                        login.username,
                        equalTo(user1))

                    assertThat(
                        "Password should match",
                        login.password,
                        equalTo(pass1))

                    assertThat(
                        "GUID should match",
                        login.guid,
                        equalTo(guid))

                    usedHandled.complete(null)
                }
            })
        } else {
            sessionRule.addExternalDelegateUntilTestEnd(
                    LoginStorageDelegate::class, register, unregister,
                    object : LoginStorageDelegate {
                @AssertCalled
                override fun onLoginFetch(domain: String)
                        : GeckoResult<Array<LoginEntry>>? {
                    assertThat("Domain should match", domain, equalTo("localhost"))

                    return GeckoResult.fromValue(savedLogins.toTypedArray())
                }

                @AssertCalled(false)
                override fun onLoginUsed(login: LoginEntry, usedFields: Int) {}
            })
        }

        sessionRule.delegateUntilTestEnd(object : Callbacks.PromptDelegate {
            @AssertCalled(false)
            override fun onLoginSave(
                    session: GeckoSession,
                    prompt: AutocompleteRequest<LoginSaveOption>)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                return null
            }
        })

        mainSession.loadTestPath(FORMS3_HTML_PATH)
        mainSession.waitForPageStop()
        mainSession.evaluateJS("document.querySelector('#form1').submit()")

        if (autofillEnabled) {
            sessionRule.waitForResult(usedHandled)
        } else {
            mainSession.waitForPageStop()
        }
    }

    @Test
    fun loginUsed() {
        testLoginUsed(true)
    }

    @Test
    fun loginAutofillDisabled() {
        sessionRule.runtime.settings.loginAutofillEnabled = false
        testLoginUsed(false)
        sessionRule.runtime.settings.loginAutofillEnabled = true
    }

    @Test
    fun loginSelectAccept() {
        sessionRule.setPrefsUntilTestEnd(mapOf(
                // Enable login management since it's disabled in automation.
                "signon.rememberSignons" to true,
                "signon.autofillForms.http" to true,
                "dom.disable_open_during_load" to false,
                "signon.userInputRequiredToCapture.enabled" to false))

        // Test:
        // 1. Load a login form page.
        // 2. Input un/pw and submit.
        //    a. Ensure onLoginSave is called accordingly.
        //    b. Save the submitted login entry.
        // 3. Reload the login form page.
        //    a. Ensure onLoginFetch is called.
        //    b. Return empty login entry list to avoid autofilling.
        // 4. Input a new set of un/pw and submit.
        //    a. Ensure onLoginSave is called again.
        //    b. Save the submitted login entry.
        // 5. Reload the login form page.
        // 6. Focus on the username input field.
        //    a. Ensure onLoginFetch is called.
        //    b. Return the saved login entries.
        //    c. Ensure onLoginSelect is called.
        //    d. Select and return one of the options.
        //    e. Submit the form.
        //    f. Ensure that onLoginUsed is called.

        val runtime = sessionRule.runtime
        val register = { delegate: LoginStorageDelegate ->
            runtime.loginStorageDelegate = delegate
        }
        val unregister = { _: LoginStorageDelegate ->
            runtime.loginStorageDelegate = null
        }

        val user1 = "user1x"
        val user2 = "user2x"
        val pass1 = "pass1x"
        val pass2 = "pass2x"
        val savedLogins = mutableListOf<LoginEntry>()

        val saveHandled1 = GeckoResult<Void>()
        val saveHandled2 = GeckoResult<Void>()
        val selectHandled = GeckoResult<Void>()
        val usedHandled = GeckoResult<Void>()

        sessionRule.addExternalDelegateUntilTestEnd(
                LoginStorageDelegate::class, register, unregister,
                object : LoginStorageDelegate {
            @AssertCalled
            override fun onLoginFetch(domain: String)
                    : GeckoResult<Array<LoginEntry>>? {
                assertThat("Domain should match", domain, equalTo("localhost"))

                var logins = mutableListOf<LoginEntry>()

                if (savedLogins.size == 2) {
                    logins = savedLogins
                }

                return GeckoResult.fromValue(logins.toTypedArray())
            }

            @AssertCalled(count = 2)
            override fun onLoginSave(login: LoginEntry) {
                var username = ""
                var password = ""
                var handle = GeckoResult<Void>()

                if (sessionRule.currentCall.counter == 1) {
                    username = user1
                    password = pass1
                    handle = saveHandled1
                } else if (sessionRule.currentCall.counter == 2) {
                    username = user2
                    password = pass2
                    handle = saveHandled2
                }

                val savedLogin = LoginEntry.Builder()
                        .guid(login.username)
                        .origin(login.origin)
                        .formActionOrigin(login.formActionOrigin)
                        .username(login.username)
                        .password(login.password)
                        .build()

                savedLogins.add(savedLogin)

                assertThat(
                    "Username should match",
                    login.username,
                    equalTo(username))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo(password))

                handle.complete(null)
            }

            @AssertCalled(count = 1)
            override fun onLoginUsed(login: LoginEntry, usedFields: Int) {
                assertThat(
                    "Used fields should match",
                    usedFields,
                    equalTo(Autocomplete.UsedField.PASSWORD))

                assertThat(
                    "Username should match",
                    login.username,
                    equalTo(user1))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo(pass1))

                assertThat(
                    "GUID should match",
                    login.guid,
                    equalTo(user1))

                usedHandled.complete(null)
            }
        })

        mainSession.loadTestPath(FORMS3_HTML_PATH)
        mainSession.waitForPageStop()

        mainSession.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onLoginSave(
                    session: GeckoSession,
                    prompt: AutocompleteRequest<LoginSaveOption>)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Session should not be null", session, notNullValue())

                val option = prompt.options[0]
                val login = option.value

                assertThat("Login should not be null", login, notNullValue())

                assertThat(
                    "Username should match",
                    login.username,
                    equalTo(user1))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo(pass1))

                return GeckoResult.fromValue(prompt.confirm(option))
            }
        })

        // Assign login credentials.
        mainSession.evaluateJS("document.querySelector('#user1').value = '$user1'")
        mainSession.evaluateJS("document.querySelector('#pass1').value = '$pass1'")

        // Submit the form.
        mainSession.evaluateJS("document.querySelector('#form1').submit()")
        sessionRule.waitForResult(saveHandled1)

        // Reload.
        val session2 = sessionRule.createOpenSession()
        session2.loadTestPath(FORMS3_HTML_PATH)
        session2.waitForPageStop()

        session2.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onLoginSave(
                    session: GeckoSession,
                    prompt: AutocompleteRequest<LoginSaveOption>)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Session should not be null", session, notNullValue())

                val option = prompt.options[0]
                val login = option.value

                assertThat("Login should not be null", login, notNullValue())

                assertThat(
                    "Username should match",
                    login.username,
                    equalTo(user2))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo(pass2))

                return GeckoResult.fromValue(prompt.confirm(option))
            }
        })

        // Assign alternative login credentials.
        session2.evaluateJS("document.querySelector('#user1').value = '$user2'")
        session2.evaluateJS("document.querySelector('#pass1').value = '$pass2'")

        // Submit the form.
        session2.evaluateJS("document.querySelector('#form1').submit()")
        sessionRule.waitForResult(saveHandled2)

        // Reload for the last time.
        val session3 = sessionRule.createOpenSession()

        session3.delegateUntilTestEnd(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onLoginSelect(
                    session: GeckoSession,
                    prompt: AutocompleteRequest<LoginSelectOption>)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Session should not be null", session, notNullValue())

                assertThat(
                    "There should be two options",
                    prompt.options.size,
                    equalTo(2))

                var usernames = arrayOf(user1, user2)
                var passwords = arrayOf(pass1, pass2)

                for (i in 0..1) {
                    val login = prompt.options[i].value

                    assertThat("Login should not be null", login, notNullValue())
                    assertThat(
                        "Username should match",
                        login.username,
                        equalTo(usernames[i]))
                    assertThat(
                        "Password should match",
                        login.password,
                        equalTo(passwords[i]))
                }


                Handler().postDelayed({
                    selectHandled.complete(null)
                }, acceptDelay)

                return GeckoResult.fromValue(prompt.confirm(prompt.options[0]))
            }
        })

        session3.loadTestPath(FORMS3_HTML_PATH)
        session3.waitForPageStop()

        // Focus on the username input field.
        session3.evaluateJS("document.querySelector('#user1').focus()")
        sessionRule.waitForResult(selectHandled)

        assertThat(
            "Filled username should match",
            session3.evaluateJS("document.querySelector('#user1').value") as String,
            equalTo(user1))

        assertThat(
            "Filled password should match",
            session3.evaluateJS("document.querySelector('#pass1').value") as String,
            equalTo(pass1))

        // Submit the selection.
        session3.evaluateJS("document.querySelector('#form1').submit()")
        sessionRule.waitForResult(usedHandled)
    }

    @Test
    fun loginSelectModifyAccept() {
        sessionRule.setPrefsUntilTestEnd(mapOf(
                // Enable login management since it's disabled in automation.
                "signon.rememberSignons" to true,
                "signon.autofillForms.http" to true,
                "dom.disable_open_during_load" to false,
                "signon.userInputRequiredToCapture.enabled" to false))

        // Test:
        // 1. Load a login form page.
        // 2. Input un/pw and submit.
        //    a. Ensure onLoginSave is called accordingly.
        //    b. Save the submitted login entry.
        // 3. Reload the login form page.
        //    a. Ensure onLoginFetch is called.
        //    b. Return empty login entry list to avoid autofilling.
        // 4. Input a new set of un/pw and submit.
        //    a. Ensure onLoginSave is called again.
        //    b. Save the submitted login entry.
        // 5. Reload the login form page.
        // 6. Focus on the username input field.
        //    a. Ensure onLoginFetch is called.
        //    b. Return the saved login entries.
        //    c. Ensure onLoginSelect is called.
        //    d. Select and return a new login entry.
        //    e. Submit the form.
        //    f. Ensure that onLoginUsed is not called.

        val runtime = sessionRule.runtime
        val register = { delegate: LoginStorageDelegate ->
            runtime.loginStorageDelegate = delegate
        }
        val unregister = { _: LoginStorageDelegate ->
            runtime.loginStorageDelegate = null
        }

        val user1 = "user1x"
        val user2 = "user2x"
        val pass1 = "pass1x"
        val pass2 = "pass2x"
        val userMod = "user1xmod"
        val passMod = "pass1xmod"
        val savedLogins = mutableListOf<LoginEntry>()

        val saveHandled1 = GeckoResult<Void>()
        val saveHandled2 = GeckoResult<Void>()
        val selectHandled = GeckoResult<Void>()

        sessionRule.addExternalDelegateUntilTestEnd(
                LoginStorageDelegate::class, register, unregister,
                object : LoginStorageDelegate {
            @AssertCalled
            override fun onLoginFetch(domain: String)
                    : GeckoResult<Array<LoginEntry>>? {
                assertThat("Domain should match", domain, equalTo("localhost"))

                var logins = mutableListOf<LoginEntry>()

                if (savedLogins.size == 2) {
                    logins = savedLogins
                }

                return GeckoResult.fromValue(logins.toTypedArray())
            }

            @AssertCalled(count = 2)
            override fun onLoginSave(login: LoginEntry) {
                var username = ""
                var password = ""
                var handle = GeckoResult<Void>()

                if (sessionRule.currentCall.counter == 1) {
                    username = user1
                    password = pass1
                    handle = saveHandled1
                } else if (sessionRule.currentCall.counter == 2) {
                    username = user2
                    password = pass2
                    handle = saveHandled2
                }

                val savedLogin = LoginEntry.Builder()
                        .guid(login.username)
                        .origin(login.origin)
                        .formActionOrigin(login.formActionOrigin)
                        .username(login.username)
                        .password(login.password)
                        .build()

                savedLogins.add(savedLogin)

                assertThat(
                    "Username should match",
                    login.username,
                    equalTo(username))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo(password))

                handle.complete(null)
            }

            @AssertCalled(false)
            override fun onLoginUsed(login: LoginEntry, usedFields: Int) {}
        })

        mainSession.loadTestPath(FORMS3_HTML_PATH)
        mainSession.waitForPageStop()

        mainSession.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onLoginSave(
                    session: GeckoSession,
                    prompt: AutocompleteRequest<LoginSaveOption>)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Session should not be null", session, notNullValue())

                val option = prompt.options[0]
                val login = option.value

                assertThat("Login should not be null", login, notNullValue())

                assertThat(
                    "Username should match",
                    login.username,
                    equalTo(user1))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo(pass1))

                return GeckoResult.fromValue(prompt.confirm(option))
            }
        })

        // Assign login credentials.
        mainSession.evaluateJS("document.querySelector('#user1').value = '$user1'")
        mainSession.evaluateJS("document.querySelector('#pass1').value = '$pass1'")

        // Submit the form.
        mainSession.evaluateJS("document.querySelector('#form1').submit()")
        sessionRule.waitForResult(saveHandled1)

        // Reload.
        val session2 = sessionRule.createOpenSession()
        session2.loadTestPath(FORMS3_HTML_PATH)
        session2.waitForPageStop()

        session2.delegateDuringNextWait(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onLoginSave(
                    session: GeckoSession,
                    prompt: AutocompleteRequest<LoginSaveOption>)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Session should not be null", session, notNullValue())

                val option = prompt.options[0]
                val login = option.value

                assertThat("Login should not be null", login, notNullValue())

                assertThat(
                    "Username should match",
                    login.username,
                    equalTo(user2))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo(pass2))

                return GeckoResult.fromValue(prompt.confirm(option))
            }
        })

        // Assign alternative login credentials.
        session2.evaluateJS("document.querySelector('#user1').value = '$user2'")
        session2.evaluateJS("document.querySelector('#pass1').value = '$pass2'")

        // Submit the form.
        session2.evaluateJS("document.querySelector('#form1').submit()")
        sessionRule.waitForResult(saveHandled2)

        // Reload for the last time.
        val session3 = sessionRule.createOpenSession()

        session3.delegateUntilTestEnd(object : Callbacks.PromptDelegate {
            @AssertCalled(count = 1)
            override fun onLoginSelect(
                    session: GeckoSession,
                    prompt: AutocompleteRequest<LoginSelectOption>)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Session should not be null", session, notNullValue())

                assertThat(
                    "There should be two options",
                    prompt.options.size,
                    equalTo(2))

                var usernames = arrayOf(user1, user2)
                var passwords = arrayOf(pass1, pass2)

                for (i in 0..1) {
                    val login = prompt.options[i].value

                    assertThat("Login should not be null", login, notNullValue())
                    assertThat(
                        "Username should match",
                        login.username,
                        equalTo(usernames[i]))
                    assertThat(
                        "Password should match",
                        login.password,
                        equalTo(passwords[i]))
                }

                val login = prompt.options[0].value
                val modOption = LoginSelectOption(LoginEntry.Builder()
                        .origin(login.origin)
                        .formActionOrigin(login.formActionOrigin)
                        .username(userMod)
                        .password(passMod)
                        .build())

                Handler().postDelayed({
                    selectHandled.complete(null)
                }, acceptDelay)

                return GeckoResult.fromValue(prompt.confirm(modOption))
            }
        })

        session3.loadTestPath(FORMS3_HTML_PATH)
        session3.waitForPageStop()

        // Focus on the username input field.
        session3.evaluateJS("document.querySelector('#user1').focus()")
        sessionRule.waitForResult(selectHandled)

        assertThat(
            "Filled username should match",
            session3.evaluateJS("document.querySelector('#user1').value") as String,
            equalTo(userMod))

        assertThat(
            "Filled password should match",
            session3.evaluateJS("document.querySelector('#pass1').value") as String,
            equalTo(passMod))

        // Submit the selection.
        session3.evaluateJS("document.querySelector('#form1').submit()")
        session3.waitForPageStop()
    }

    @Test
    fun loginSelectGeneratedPassword() {
        sessionRule.setPrefsUntilTestEnd(mapOf(
                // Enable login management since it's disabled in automation.
                "signon.rememberSignons" to true,
                "signon.autofillForms.http" to true,
                "signon.generation.enabled" to true,
                "signon.generation.available" to true,
                "dom.disable_open_during_load" to false,
                "signon.userInputRequiredToCapture.enabled" to false))

        // Test:
        // 1. Load a login form page.
        // 2. Input username.
        // 3. Focus on the password input field.
        //    a. Ensure onLoginSelect is called with a generated password.
        //    b. Return the login entry with the generated password.
        // 4. Submit the login form.
        //    a. Ensure onLoginSave is called with accordingly.

        val runtime = sessionRule.runtime
        val register = { delegate: LoginStorageDelegate ->
            runtime.loginStorageDelegate = delegate
        }
        val unregister = { _: LoginStorageDelegate ->
            runtime.loginStorageDelegate = null
        }

        val user1 = "user1x"
        var genPass = ""

        val saveHandled1 = GeckoResult<Void>()
        val selectHandled = GeckoResult<Void>()
        var numSelects = 0

        sessionRule.addExternalDelegateUntilTestEnd(
                LoginStorageDelegate::class, register, unregister,
                object : LoginStorageDelegate {
            @AssertCalled
            override fun onLoginFetch(domain: String)
                    : GeckoResult<Array<LoginEntry>>? {
                assertThat("Domain should match", domain, equalTo("localhost"))

                return GeckoResult.fromValue(null)
            }

            @AssertCalled(count = 1)
            override fun onLoginSave(login: LoginEntry) {
                assertThat(
                    "Username should match",
                    login.username,
                    equalTo(user1))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo(genPass))

                saveHandled1.complete(null)
            }

            @AssertCalled(false)
            override fun onLoginUsed(login: LoginEntry, usedFields: Int) {}
        })

        mainSession.loadTestPath(FORMS4_HTML_PATH)
        mainSession.waitForPageStop()

        mainSession.delegateUntilTestEnd(object : Callbacks.PromptDelegate {
            @AssertCalled
            override fun onLoginSelect(
                    session: GeckoSession,
                    prompt: AutocompleteRequest<LoginSelectOption>)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Session should not be null", session, notNullValue())

                assertThat(
                    "There should be one option",
                    prompt.options.size,
                    equalTo(1))

                val option = prompt.options[0]
                val login = option.value

                assertThat(
                    "Hint should match",
                    option.hint,
                    equalTo(LoginSelectOption.Hint.GENERATED))

                assertThat("Login should not be null", login, notNullValue())
                assertThat(
                    "Password should not be empty",
                    login.password,
                    not(isEmptyOrNullString()))

                genPass = login.password

                if (numSelects == 0) {
                    Handler().postDelayed({
                        selectHandled.complete(null)
                    }, acceptDelay)
                }
                ++numSelects

                return GeckoResult.fromValue(prompt.confirm(option))
            }

            @AssertCalled(count = 1)
            override fun onLoginSave(
                    session: GeckoSession,
                    prompt: AutocompleteRequest<LoginSaveOption>)
                    : GeckoResult<PromptDelegate.PromptResponse>? {
                assertThat("Session should not be null", session, notNullValue())

                val option = prompt.options[0]
                val login = option.value

                assertThat("Login should not be null", login, notNullValue())

                assertThat(
                    "Username should match",
                    login.username,
                    equalTo(user1))

                // TODO: The flag is only set for login entry updates yet.
                /*
                assertThat(
                    "Hint should match",
                    option.hint,
                    equalTo(LoginSaveOption.Hint.GENERATED))
                */

                assertThat(
                    "Password should not be empty",
                    login.password,
                    not(isEmptyOrNullString()))

                assertThat(
                    "Password should match",
                    login.password,
                    equalTo(genPass))

                return GeckoResult.fromValue(prompt.confirm(option))
            }
        })

        // Assign username and focus on password.
        mainSession.evaluateJS("document.querySelector('#user1').value = '$user1'")
        mainSession.evaluateJS("document.querySelector('#pass1').focus()")
        sessionRule.waitForResult(selectHandled)

        assertThat(
            "Filled username should match",
            mainSession.evaluateJS("document.querySelector('#user1').value") as String,
            equalTo(user1))

        val filledPass = mainSession.evaluateJS(
            "document.querySelector('#pass1').value") as String

        assertThat(
            "Password should not be empty",
            filledPass,
            not(isEmptyOrNullString()))

        assertThat(
            "Filled password should match",
            filledPass,
            equalTo(genPass))

        // Submit the selection.
        mainSession.evaluateJS("document.querySelector('#form1').submit()")
        mainSession.waitForPageStop()
    }
}
