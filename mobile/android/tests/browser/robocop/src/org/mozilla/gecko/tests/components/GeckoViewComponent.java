/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.tests.components;

import static org.mozilla.gecko.tests.helpers.AssertionHelper.fAssertEquals;
import static org.mozilla.gecko.tests.helpers.AssertionHelper.fAssertNotNull;
import static org.mozilla.gecko.tests.helpers.AssertionHelper.fAssertNotSame;
import static org.mozilla.gecko.tests.helpers.AssertionHelper.fAssertSame;
import static org.mozilla.gecko.tests.helpers.AssertionHelper.fAssertTrue;

import org.mozilla.gecko.GeckoThread;
import org.mozilla.gecko.R;
import org.mozilla.gecko.tests.UITestContext;
import org.mozilla.gecko.tests.helpers.FrameworkHelper;
import org.mozilla.gecko.tests.helpers.WaitHelper;

import android.content.Context;
import android.content.ContextWrapper;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.MessageQueue;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.ExtractedText;
import android.view.inputmethod.ExtractedTextRequest;
import android.view.inputmethod.InputConnection;
import android.view.inputmethod.InputMethodManager;

import com.robotium.solo.Condition;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

/**
 * A class representing any interactions that take place on GeckoView.
 */
public class GeckoViewComponent extends BaseComponent {

    public final TextInput mTextInput;

    public GeckoViewComponent(final UITestContext testContext) {
        super(testContext);
        mTextInput = new TextInput();
    }

    /**
     * Returns the GeckoView.
     */
    private View getView() {
        // Solo.getView asserts returning a valid View
        return mSolo.getView(R.id.layer_view);
    }

    private void setContext(final Context newContext) {
        final View geckoView = getView();
        // Switch to a no-InputMethodManager context to avoid interference
        mTestContext.getInstrumentation().runOnMainSync(new Runnable() {
            @Override
            public void run() {
                FrameworkHelper.setViewContext(geckoView, newContext);
            }
        });
    }

    public static abstract class InputConnectionTest {
        protected Handler inputConnectionHandler;

        /**
         * Processes pending events on the input connection thread before returning.
         * Must be called on the input connection thread during a test.
         */
        protected void processInputConnectionEvents() {
            fAssertSame("Should be called on input connection thread",
                    Looper.myLooper(), inputConnectionHandler.getLooper());

            // Adapted from GeckoThread.pumpMessageLoop.
            MessageQueue queue = Looper.myQueue();
            queue.addIdleHandler(new MessageQueue.IdleHandler() {
                @Override
                public boolean queueIdle() {
                    final Message msg = Message.obtain(inputConnectionHandler);
                    msg.obj = inputConnectionHandler;
                    inputConnectionHandler.sendMessageAtFrontOfQueue(msg);
                    return false; // Remove this idle handler.
                }
            });

            final Method getNextMessage;
            try {
                getNextMessage = queue.getClass().getDeclaredMethod("next");
            } catch (final NoSuchMethodException e) {
                throw new UnsupportedOperationException(e);
            }
            getNextMessage.setAccessible(true);

            while (true) {
                final Message msg;
                try {
                    msg = (Message) getNextMessage.invoke(queue);
                } catch (final IllegalAccessException | InvocationTargetException e) {
                    throw new UnsupportedOperationException(e);
                }
                if (msg.obj == inputConnectionHandler &&
                        msg.getTarget() == inputConnectionHandler) {
                    // Our idle signal
                    break;
                } else if (msg.getTarget() == null) {
                    Looper.myLooper().quit();
                    break;
                }
                msg.getTarget().dispatchMessage(msg);
            }
        }

        /**
         * Processes pending events on the Gecko thread before returning.
         * Must be called on the input connection thread during a test.
         */
        protected void processGeckoEvents() {
            fAssertSame("Should be called on input connection thread",
                    Looper.myLooper(), inputConnectionHandler.getLooper());

            GeckoThread.waitOnGecko();
        }

        private static ExtractedText getExtractedText(final InputConnection ic) {
            final ExtractedTextRequest req = new ExtractedTextRequest();
            return ic.getExtractedText(req, 0);
        }

        protected String getText(final InputConnection ic) {
            return getExtractedText(ic).text.toString();
        }

        private static void assertText(final String message,
                                       final String expected,
                                       final String actual) {
            // In an HTML editor, Gecko may insert an additional element that show up as a
            // return character at the end. Deal with that here.
            int end = actual.length();
            if (end > 0 && actual.charAt(end - 1) == '\n') {
                end--;
            }
            fAssertEquals(message, expected, actual.substring(0, end));
        }

        protected void assertText(final String message,
                                  final InputConnection ic,
                                  final String text) {
            processGeckoEvents();
            processInputConnectionEvents();

            assertText(message, text, getText(ic));
        }

        protected void assertSelection(final String message,
                                       final InputConnection ic,
                                       final int start,
                                       final int end) {
            processGeckoEvents();
            processInputConnectionEvents();

            final ExtractedText extract = getExtractedText(ic);
            fAssertEquals(message, start, extract.selectionStart);
            fAssertEquals(message, end, extract.selectionEnd);
        }

        protected void assertSelectionAt(final String message,
                                         final InputConnection ic,
                                         final int value) {
            assertSelection(message, ic, value, value);
        }

        protected void assertTextAndSelection(final String message,
                                              final InputConnection ic,
                                              final String text,
                                              final int start,
                                              final int end) {
            processGeckoEvents();
            processInputConnectionEvents();

            final ExtractedText extract = getExtractedText(ic);
            assertText(message, text, extract.text.toString());
            fAssertEquals(message, start, extract.selectionStart);
            fAssertEquals(message, end, extract.selectionEnd);
        }

        protected void assertTextAndSelectionAt(final String message,
                                                final InputConnection ic,
                                                final String text,
                                                final int selection) {
            assertTextAndSelection(message, ic, text, selection, selection);
        }

        public abstract void test(InputConnection ic, EditorInfo info);
    }

    public class TextInput {
        private TextInput() {
        }

        private InputMethodManager getInputMethodManager() {
            final InputMethodManager imm = (InputMethodManager)
                mActivity.getSystemService(Context.INPUT_METHOD_SERVICE);
            fAssertNotNull("Must have an InputMethodManager", imm);
            return imm;
        }

        /**
         * Returns whether text input is being directed to the GeckoView.
         */
        private boolean isActive() {
            return getInputMethodManager().isActive(getView());
        }

        public TextInput assertActive() {
            fAssertTrue("Current view should be the active input view", isActive());
            return this;
        }

        public TextInput waitForActive() {
            WaitHelper.waitFor("current view to become the active input view", new Condition() {
                @Override
                public boolean isSatisfied() {
                    return isActive();
                }
            });
            return this;
        }

        /**
         * Returns whether an InputConnection is available.
         * An InputConnection is available when text input is being directed to the
         * GeckoView, and a text field (input, textarea, contentEditable, etc.) is
         * currently focused inside the GeckoView.
         */
        private boolean hasInputConnection() {
            final InputMethodManager imm = getInputMethodManager();
            return imm.isActive(getView()) && imm.isAcceptingText();
        }

        public TextInput assertInputConnection() {
            fAssertTrue("Current view should have an active InputConnection", hasInputConnection());
            return this;
        }

        public TextInput waitForInputConnection() {
            WaitHelper.waitFor("current view to have an active InputConnection", new Condition() {
                @Override
                public boolean isSatisfied() {
                    return hasInputConnection();
                }
            });
            return this;
        }

        /**
         * Starts an InputConnectionTest. An InputConnectionTest must run on the
         * InputConnection thread which may or may not be the main UI thread. Also,
         * during an InputConnectionTest, the system InputMethodManager service must
         * be temporarily disabled to prevent the system IME from interfering with our
         * tests. We disable the service by override the GeckoView's context with one
         * that returns a null InputMethodManager service.
         *
         * @param test Test to run
         */
        public TextInput testInputConnection(final InputConnectionTest test) {

            fAssertNotNull("Test must not be null", test);
            assertInputConnection();

            // GeckoInputConnection can run on another thread than the main thread,
            // so we need to be testing it on that same thread it's running on
            final View geckoView = getView();
            final Handler inputConnectionHandler = geckoView.getHandler();
            final Context oldGeckoViewContext = FrameworkHelper.getViewContext(geckoView);

            setContext(new ContextWrapper(oldGeckoViewContext) {
                @Override
                public Object getSystemService(String name) {
                    if (Context.INPUT_METHOD_SERVICE.equals(name)) {
                        return null;
                    }
                    return super.getSystemService(name);
                }
            });

            (new InputConnectionTestRunner(test, inputConnectionHandler)).launch();

            setContext(oldGeckoViewContext);
            return this;
        }

        private class InputConnectionTestRunner implements Runnable {
            private final InputConnectionTest mTest;
            private boolean mDone;

            public InputConnectionTestRunner(final InputConnectionTest test,
                                             final Handler handler) {
                test.inputConnectionHandler = handler;
                mTest = test;
            }

            public synchronized void launch() {
                // Below, we are blocking the instrumentation thread to wait on the
                // InputConnection thread. Therefore, the InputConnection thread must not be
                // the same as the instrumentation thread to avoid a deadlock. This should
                // always be the case and we perform a sanity check to make sure.
                fAssertNotSame("InputConnection should not be running on instrumentation thread",
                    Looper.myLooper(), mTest.inputConnectionHandler.getLooper());

                mDone = false;
                mTest.inputConnectionHandler.post(this);
                do {
                    try {
                        wait();
                    } catch (InterruptedException e) {
                        // Ignore interrupts
                    }
                } while (!mDone);
            }

            @Override
            public void run() {
                final EditorInfo info = new EditorInfo();
                final InputConnection ic = getView().onCreateInputConnection(info);
                fAssertNotNull("Must have an InputConnection", ic);
                // Restore the IC to a clean state
                ic.clearMetaKeyStates(-1);
                ic.finishComposingText();
                mTest.test(ic, info);
                synchronized (this) {
                    // Test finished; return from launch().
                    mDone = true;
                    notify();
                }
            }
        }
    }
}
