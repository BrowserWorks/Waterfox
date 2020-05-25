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

public class Big5Decoder extends Decoder {
   
    private int big5Lead = 0;
    
    private char pendingTrail = '\u0000';
    
    protected Big5Decoder(Charset cs) {
        super(cs, 0.5f, 1.0f);
    }

    @Override protected CoderResult decodeLoop(ByteBuffer in, CharBuffer out) {
        assert !(this.report && (big5Lead != 0)):
            "When reporting, this method should never return with big5Lead set.";
        if (pendingTrail != '\u0000') {
            if (!out.hasRemaining()) {
                return CoderResult.OVERFLOW;
            }
            out.put(pendingTrail);
            pendingTrail = '\u0000';
        }
        for (;;) {
            if (!in.hasRemaining()) {
                return CoderResult.UNDERFLOW;
            }
            if (!out.hasRemaining()) {
                return CoderResult.OVERFLOW;
            }
            int b = ((int) in.get() & 0xFF);
            if (big5Lead == 0) {
                if (b <= 0x7F) {
                    out.put((char) b);
                    continue;
                }
                if (b >= 0x81 && b <= 0xFE) {
                    if (this.report && !in.hasRemaining()) {
                        // The Java API is badly documented. Need to do this
                        // crazy thing and hope the caller knows about the
                        // undocumented aspects of the API!
                        in.position(in.position() - 1);
                        return CoderResult.UNDERFLOW;
                    }
                    big5Lead = b;
                    continue;
                }
                if (this.report) {
                    in.position(in.position() - 1);
                    return CoderResult.malformedForLength(1);
                }
                out.put('\uFFFD');
                continue;
            }
            int lead = big5Lead;
            big5Lead = 0;
            int offset = (b < 0x7F) ? 0x40 : 0x62;
            if ((b >= 0x40 && b <= 0x7E) || (b >= 0xA1 && b <= 0xFE)) {
                int pointer = (lead - 0x81) * 157 + (b - offset);
                char outTrail;
                switch (pointer) {
                    case 1133:
                        out.put('\u00CA');
                        outTrail = '\u0304';
                        break;
                    case 1135:
                        out.put('\u00CA');
                        outTrail = '\u030C';
                        break;
                    case 1164:
                        out.put('\u00EA');
                        outTrail = '\u0304';
                        break;
                    case 1166:
                        out.put('\u00EA');
                        outTrail = '\u030C';
                        break;
                    default:
                        char lowBits = Big5Data.lowBits(pointer);
                        if (lowBits == '\u0000') {
                            // The following |if| block fixes
                            // https://github.com/whatwg/encoding/issues/5
                            if (b <= 0x7F) {
                                // prepend byte to stream
                                // Always legal, since we've always just read a byte
                                // if we come here.
                                in.position(in.position() - 1);
                            }
                            if (this.report) {
                                // This can go past the start of the buffer
                                // if the caller does not conform to the
                                // undocumented aspects of the API.
                                in.position(in.position() - 1);
                                return CoderResult.malformedForLength(b <= 0x7F ? 1 : 2);
                            }
                            out.put('\uFFFD');
                            continue;
                        }
                        if (Big5Data.isAstral(pointer)) {
                            int codePoint = lowBits | 0x20000;
                            out.put((char) (0xD7C0 + (codePoint >> 10)));
                            outTrail = (char) (0xDC00 + (codePoint & 0x3FF));
                            break;
                        }
                        out.put(lowBits);
                        continue;
                }
                if (!out.hasRemaining()) {
                    pendingTrail = outTrail;
                    return CoderResult.OVERFLOW;
                }
                out.put(outTrail);
                continue;
            }
            // pointer is null
            if (b <= 0x7F) {
                // prepend byte to stream
                // Always legal, since we've always just read a byte
                // if we come here.
                in.position(in.position() - 1);
            }
            if (this.report) {
                // if position() == 0, the caller is not using the
                // undocumented part of the API right and the line
                // below will throw!
                in.position(in.position() - 1);
                return CoderResult.malformedForLength(b <= 0x7F ? 1 : 2);
            }
            out.put('\uFFFD');
            continue;
        }
    }

    @Override protected CoderResult implFlush(CharBuffer out) {
        if (pendingTrail != '\u0000') {
            if (!out.hasRemaining()) {
                return CoderResult.OVERFLOW;
            }
            out.put(pendingTrail);
            pendingTrail = '\u0000';
        }
        if (big5Lead != 0) {
            assert !this.report: "How come big5Lead got to be non-zero when decodeLoop() returned in the reporting mode?";
            if (!out.hasRemaining()) {
                return CoderResult.OVERFLOW;
            }
            out.put('\uFFFD');
            big5Lead = 0;            
        }
        return CoderResult.UNDERFLOW;
    }

    @Override protected void implReset() {
        big5Lead = 0;
        pendingTrail = '\u0000';
    }

}
