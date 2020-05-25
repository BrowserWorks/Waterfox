/*
 * Copyright (c) 2013-2015 Mozilla Foundation
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

import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.CoderResult;

public final class FallibleSingleByteDecoder extends InfallibleSingleByteDecoder {

    public FallibleSingleByteDecoder(Encoding cs, char[] upperHalf) {
        super(cs, upperHalf);
    }

    @Override protected CoderResult decodeLoop(ByteBuffer in, CharBuffer out) {
        if (!this.report) {
            return super.decodeLoop(in, out);
        } else {
            for (;;) {
                if (!in.hasRemaining()) {
                    return CoderResult.UNDERFLOW;
                }
                if (!out.hasRemaining()) {
                    return CoderResult.OVERFLOW;
                }
                int b = (int) in.get();
                if (b >= 0) {
                    out.put((char) b);
                } else {
                    char mapped = this.upperHalf[b + 128];
                    if (mapped == '\uFFFD') {
                        in.position(in.position() - 1);
                        return CoderResult.malformedForLength(1);
                    }
                    out.put(mapped);
                }
            }
        }
    }

}
