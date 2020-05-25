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

public class Big5Encoder extends Encoder {

    private char utf16Lead = '\u0000';

    private byte pendingTrail = 0;

    protected Big5Encoder(Charset cs) {
        super(cs, 1.5f, 2.0f);
    }

    @Override protected CoderResult encodeLoop(CharBuffer in, ByteBuffer out) {
        assert !((this.reportMalformed || this.reportUnmappable) && (utf16Lead != '\u0000')):
            "When reporting, this method should never return with utf16Lead set.";
        if (pendingTrail != 0) {
            if (!out.hasRemaining()) {
                return CoderResult.OVERFLOW;
            }
            out.put(pendingTrail);
            pendingTrail = 0;
        }
        for (;;) {
            if (!in.hasRemaining()) {
                return CoderResult.UNDERFLOW;
            }
            if (!out.hasRemaining()) {
                return CoderResult.OVERFLOW;
            }
            boolean isAstral; // true means Plane 2, false means BMP
            char lowBits; // The low 16 bits of the code point
            char codeUnit = in.get();
            int highBits = (codeUnit & 0xFC00);
            if (highBits == 0xD800) {
                // high surrogate
                if (utf16Lead != '\u0000') {
                    // High surrogate follows another high surrogate. The
                    // *previous* code unit is in error.
                    if (this.reportMalformed) {
                        // The caller had better adhere to the API contract.
                        // Otherwise, this may throw.
                        in.position(in.position() - 2);
                        utf16Lead = '\u0000';
                        return CoderResult.malformedForLength(1);
                    }
                    out.put((byte) '?');
                }
                utf16Lead = codeUnit;
                continue;
            }
            if (highBits == 0xDC00) {
                // low surrogate
                if (utf16Lead == '\u0000') {
                    // Got low surrogate without a previous high surrogate
                    if (this.reportMalformed) {
                        in.position(in.position() - 1);
                        return CoderResult.malformedForLength(1);
                    }
                    out.put((byte) '?');
                    continue;
                }
                int codePoint = (utf16Lead << 10) + codeUnit - 56613888;
                utf16Lead = '\u0000';
                // Plane 2 is the only astral plane that has potentially
                // Big5-encodable characters.
                if ((0xFF0000 & codePoint) != 0x20000) {
                    if (this.reportUnmappable) {
                        in.position(in.position() - 2);
                        return CoderResult.unmappableForLength(2);
                    }
                    out.put((byte) '?');
                    continue;
                }
                isAstral = true;
                lowBits = (char)(codePoint & 0xFFFF);
            } else {
                // not a surrogate
                if (utf16Lead != '\u0000') {
                    // Non-surrogate follows a high surrogate. The *previous*
                    // code unit is in error.
                    utf16Lead = '\u0000';
                    if (this.reportMalformed) {
                        // The caller had better adhere to the API contract.
                        // Otherwise, this may throw.
                        in.position(in.position() - 2);
                        return CoderResult.malformedForLength(1);
                    }
                    out.put((byte) '?');
                    // Let's unconsume this code unit and reloop in order to
                    // re-check if the output buffer still has space.
                    in.position(in.position() - 1);
                    continue;
                }
                isAstral = false;
                lowBits = codeUnit;
            }
            // isAstral now tells us if we have a Plane 2 or a BMP character.
            // lowBits tells us the low 16 bits.
            // After all the above setup to deal with UTF-16, we are now
            // finally ready to follow the spec.
            if (!isAstral && lowBits <= 0x7F) {
                out.put((byte)lowBits);
                continue;
            }
            int pointer = Big5Data.findPointer(lowBits, isAstral);
            if (pointer == 0) {
                if (this.reportUnmappable) {
                    if (isAstral) {
                        in.position(in.position() - 2);
                        return CoderResult.unmappableForLength(2);
                    }
                    in.position(in.position() - 1);
                    return CoderResult.unmappableForLength(1);
                }
                out.put((byte)'?');
                continue;
            }
            int lead = pointer / 157 + 0x81;
            int trail = pointer % 157;
            if (trail < 0x3F) {
                trail += 0x40;
            } else {
                trail += 0x62;
            }
            out.put((byte)lead);
            if (!out.hasRemaining()) {
                pendingTrail = (byte)trail;
                return CoderResult.OVERFLOW;
            }
            out.put((byte)trail);
            continue;
        }
    }

    @Override protected CoderResult implFlush(ByteBuffer out) {
        if (pendingTrail != 0) {
            if (!out.hasRemaining()) {
                return CoderResult.OVERFLOW;
            }
            out.put(pendingTrail);
            pendingTrail = 0;
        }
        if (utf16Lead != '\u0000') {
            assert !this.reportMalformed: "How come utf16Lead got to be non-zero when decodeLoop() returned in the reporting mode?";
            if (!out.hasRemaining()) {
                return CoderResult.OVERFLOW;
            }
            out.put((byte)'?');
            utf16Lead = '\u0000';
        }
        return CoderResult.UNDERFLOW;
    }

    @Override protected void implReset() {
        utf16Lead = '\u0000';
        pendingTrail = 0;
    }
}
