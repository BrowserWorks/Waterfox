/*
 * Copyright (c) 2015 Mozilla Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package nu.validator.encoding;

import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;
import java.nio.charset.CodingErrorAction;

public abstract class Encoder extends CharsetEncoder {

    boolean reportMalformed = true;

    boolean reportUnmappable = true;

    protected Encoder(Charset cs, float averageBytesPerChar,
            float maxBytesPerChar) {
        super(cs, averageBytesPerChar, maxBytesPerChar);
    }

    @Override protected final void implOnMalformedInput(CodingErrorAction newAction) {
        if (newAction == null) {
            throw new IllegalArgumentException("The argument must not be null.");
        }
        if (newAction == CodingErrorAction.IGNORE) {
            throw new IllegalArgumentException("The Encoding Standard does not allow errors to be ignored.");
        }
        if (newAction == CodingErrorAction.REPLACE) {
            this.reportMalformed = false;
            return;
        }
        if (newAction == CodingErrorAction.REPORT) {
            this.reportUnmappable = true;
            return;
        }
        assert false: "Unreachable.";
        throw new IllegalArgumentException("Unknown CodingErrorAction.");
    }

    @Override protected final void implOnUnmappableCharacter(
            CodingErrorAction newAction) {
        if (newAction == null) {
            throw new IllegalArgumentException("The argument must not be null.");
        }
        if (newAction == CodingErrorAction.IGNORE) {
            throw new IllegalArgumentException("The Encoding Standard does not allow errors to be ignored.");
        }
        if (newAction == CodingErrorAction.REPLACE) {
            this.reportUnmappable = false;
            return;
        }
        if (newAction == CodingErrorAction.REPORT) {
            this.reportMalformed = true;
            return;
        }
        assert false: "Unreachable.";
        throw new IllegalArgumentException("Unknown CodingErrorAction.");
    }

    @Override public boolean isLegalReplacement(byte[] repl) {
        if (repl == null) {
            return false;
        }
        if (repl.length != 1) {
            return false;
        }
        if (repl[0] != '?') {
            return false;
        }
        return true;
    }

    @Override protected final void implReplaceWith(byte[] newReplacement) {
    }

}
