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

import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CoderResult;

class ReplacementDecoder extends Decoder {

    private boolean haveEmitted = false;
    
    ReplacementDecoder(Charset cs) {
        super(cs, 1.0f, 1.0f);
    }

    @Override protected CoderResult decodeLoop(ByteBuffer in, CharBuffer out) {
        for (;;) {
            if (!in.hasRemaining()) {
                return CoderResult.UNDERFLOW;
            }
            if (haveEmitted) {
                in.position(in.limit());
                return CoderResult.UNDERFLOW;                
            }
            if (!out.hasRemaining()) {
                return CoderResult.OVERFLOW;
            }
            in.position(in.limit());
            haveEmitted = true;
            if (this.report) {
                return CoderResult.malformedForLength(1);
            }
            out.put('\uFFFD');           
        }
    }

    /**
     * @see java.nio.charset.CharsetDecoder#implFlush(java.nio.CharBuffer)
     */
    @Override protected CoderResult implFlush(CharBuffer out) {
        // TODO Auto-generated method stub
        return super.implFlush(out);
    }

    /**
     * @see java.nio.charset.CharsetDecoder#implReset()
     */
    @Override protected void implReset() {
        // TODO Auto-generated method stub
        super.implReset();
    }

}
