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

package nu.validator.encoding.test;

import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.CharsetDecoder;
import java.nio.charset.CharsetEncoder;
import java.nio.charset.CoderResult;
import java.nio.charset.CodingErrorAction;

import nu.validator.encoding.Encoding;

public class EncodingTester {

    protected byte[] stringToBytes(String str) {
        byte[] bytes = new byte[str.length() * 2];
        for (int i = 0; i < str.length(); i++) {
            int pair = (int) str.charAt(i);
            bytes[i * 2] = (byte) (pair >> 8);
            bytes[i * 2 + 1] = (byte) (pair & 0xFF);
        }
        return bytes;
    }

    protected void decode(String input, String expectation, Encoding encoding) {
        // Use the convenience method from Charset

        byte[] bytes = stringToBytes(input);
        ByteBuffer byteBuf = ByteBuffer.wrap(bytes);
        CharBuffer charBuf = encoding.decode(byteBuf);

        if (charBuf.remaining() != expectation.length()) {
            err("When decoding from a single long buffer, the output length was wrong. Expected: "
                    + expectation.length() + ", got: " + charBuf.remaining(),
                    bytes, expectation);
            return;
        }

        for (int i = 0; i < expectation.length(); i++) {
            char expect = expectation.charAt(i);
            char actual = charBuf.get();
            if (actual != expect) {
                err("When decoding from a single long buffer, failed at position "
                        + i
                        + ", expected: "
                        + charToHex(expect)
                        + ", got: "
                        + charToHex(actual), bytes, expectation);
                return;
            }
        }

        // Decode with a 1-byte input buffer

        byteBuf = ByteBuffer.allocate(1);
        charBuf = CharBuffer.allocate(expectation.length() + 2);
        CharsetDecoder decoder = encoding.newDecoder();
        decoder.onMalformedInput(CodingErrorAction.REPLACE);
        for (int i = 0; i < bytes.length; i++) {
            byteBuf.position(0);
            byteBuf.put(bytes[i]);
            byteBuf.position(0);
            CoderResult result = decoder.decode(byteBuf, charBuf,
                    (i + 1) == bytes.length);
            if (result.isMalformed()) {
                err("Decoder reported a malformed sequence when asked to replace at index: "
                        + i, bytes, expectation);
                return;
            } else if (result.isUnmappable()) {
                err("Decoder claimed unmappable sequence, which none of these decoders should do.",
                        bytes, expectation);
                return;
            } else if (result.isOverflow()) {
                err("Decoder claimed overflow when the output buffer is know to be large enough.",
                        bytes, expectation);
            } else if (!result.isUnderflow()) {
                err("Bogus coder result, expected underflow.", bytes,
                        expectation);
            }
        }
        CoderResult result = decoder.flush(charBuf);
        if (result.isMalformed()) {
            err("Decoder reported a malformed sequence when asked to replace when flushing.",
                    bytes, expectation);
            return;
        } else if (result.isUnmappable()) {
            err("Decoder claimed unmappable sequence when flushing, which none of these decoders should do.",
                    bytes, expectation);
            return;
        } else if (result.isOverflow()) {
            err("Decoder claimed overflow when flushing when the output buffer is know to be large enough.",
                    bytes, expectation);
        } else if (!result.isUnderflow()) {
            err("Bogus coder result when flushing, expected underflow.", bytes,
                    expectation);
        }

        charBuf.limit(charBuf.position());
        charBuf.position(0);

        for (int i = 0; i < expectation.length(); i++) {
            char expect = expectation.charAt(i);
            char actual = charBuf.get();
            if (actual != expect) {
                err("When decoding one byte at a time in REPORT mode, failed at position "
                        + i
                        + ", expected: "
                        + charToHex(expect)
                        + ", got: "
                        + charToHex(actual), bytes, expectation);
                return;
            }
        }

        // Decode with 1-char output buffer

        byteBuf = ByteBuffer.wrap(bytes);
        charBuf = CharBuffer.allocate(1);

        decoder.reset(); // Let's test this while at it
        decoder.onMalformedInput(CodingErrorAction.REPLACE);
        int codeUnitPos = 0;
        while (byteBuf.hasRemaining()) {
            charBuf.position(0);
            charBuf.put('\u0000');
            charBuf.position(0);
            result = decoder.decode(byteBuf, charBuf, false);
            if (result.isMalformed()) {
                err("Decoder reported a malformed sequence when asked to replace at index (decoding one output code unit at a time): "
                        + byteBuf.position(), bytes, expectation);
                return;
            } else if (result.isUnmappable()) {
                err("Decoder claimed unmappable sequence (decoding one output code unit at a time), which none of these decoders should do.",
                        bytes, expectation);
                return;
            } else if (result.isUnderflow()) {
                if (byteBuf.hasRemaining()) {
                    err("When decoding one output code unit at a time, decoder claimed underflow when there was input remaining.",
                            bytes, expectation);
                    return;
                }
            } else if (!result.isOverflow()) {
                err("Bogus coder result, expected overflow.", bytes,
                        expectation);
            }
            if (charBuf.position() == 1) {
                charBuf.position(0);
                char actual = charBuf.get();
                char expect = expectation.charAt(codeUnitPos);
                if (actual != expect) {
                    err("When decoding one output code unit at a time in REPLACE mode, failed at position "
                            + byteBuf.position()
                            + ", expected: "
                            + charToHex(expect) + ", got: " + charToHex(actual),
                            bytes, expectation);
                    return;
                }
                codeUnitPos++;
            }
        }

        charBuf.position(0);
        charBuf.put('\u0000');
        charBuf.position(0);
        result = decoder.decode(byteBuf, charBuf, true);

        if (charBuf.position() == 1) {
            charBuf.position(0);
            char actual = charBuf.get();
            char expect = expectation.charAt(codeUnitPos);
            if (actual != expect) {
                err("When decoding one output code unit at a time in REPLACE mode, failed at position "
                        + byteBuf.position()
                        + ", expected: "
                        + charToHex(expect) + ", got: " + charToHex(actual),
                        bytes, expectation);
                return;
            }
            codeUnitPos++;
        }

        charBuf.position(0);
        charBuf.put('\u0000');
        charBuf.position(0);
        result = decoder.flush(charBuf);
        if (result.isMalformed()) {
            err("Decoder reported a malformed sequence when asked to replace when flushing (one output at a time).",
                    bytes, expectation);
            return;
        } else if (result.isUnmappable()) {
            err("Decoder claimed unmappable sequence when flushing, which none of these decoders should do (one output at a time).",
                    bytes, expectation);
            return;
        } else if (result.isOverflow()) {
            err("Decoder claimed overflow when flushing when the output buffer is know to be large enough (one output at a time).",
                    bytes, expectation);
        } else if (!result.isUnderflow()) {
            err("Bogus coder result when flushing, expected underflow (one output at a time).",
                    bytes, expectation);
        }

        if (charBuf.position() == 1) {
            charBuf.position(0);
            char actual = charBuf.get();
            char expect = expectation.charAt(codeUnitPos);
            if (actual != expect) {
                err("When decoding one output code unit at a time in REPLACE mode, failed when flushing, expected: "
                        + charToHex(expect) + ", got: " + charToHex(actual),
                        bytes, expectation);
                return;
            }
        }

        // TODO: 2 bytes at a time starting at 0 and 2 bytes at a time starting
        // at 1
    }

    protected void encode(String input, String expectation, Encoding encoding) {
        byte[] expectedBytes = stringToBytes(expectation);
        CharBuffer charBuf = CharBuffer.wrap(input);

        // Use the convenience method from Charset

        ByteBuffer byteBuf = encoding.encode(charBuf);

        if (byteBuf.remaining() != expectedBytes.length) {
            err("When encoding from a single long buffer, the output length was wrong. Expected: "
                    + expectedBytes.length + ", got: " + byteBuf.remaining(),
                    input, expectedBytes);
            return;
        }

        for (int i = 0; i < expectedBytes.length; i++) {
            byte expect = expectedBytes[i];
            byte actual = byteBuf.get();
            if (actual != expect) {
                err("When encoding from a single long buffer, failed at position "
                        + i
                        + ", expected: "
                        + byteToHex(expect)
                        + ", got: "
                        + byteToHex(actual), input, expectedBytes);
                return;
            }
        }

        // Encode with a 1-char input buffer

        charBuf = CharBuffer.allocate(1);
        byteBuf = ByteBuffer.allocate(expectedBytes.length + 2);
        CharsetEncoder encoder = encoding.newEncoder();
        encoder.onMalformedInput(CodingErrorAction.REPLACE);
        encoder.onUnmappableCharacter(CodingErrorAction.REPLACE);
        for (int i = 0; i < input.length(); i++) {
            charBuf.position(0);
            charBuf.put(input.charAt(i));
            charBuf.position(0);
            CoderResult result = encoder.encode(charBuf, byteBuf,
                    (i + 1) == input.length());
            if (result.isMalformed()) {
                err("Encoder reported a malformed sequence when asked to replace at index: "
                        + i, input, expectedBytes);
                return;
            } else if (result.isUnmappable()) {
                err("Encoder reported an upmappable sequence when asked to replace at index: "
                        + i, input, expectedBytes);
                return;
            } else if (result.isOverflow()) {
                err("Encoder claimed overflow when the output buffer is know to be large enough.",
                        input, expectedBytes);
            } else if (!result.isUnderflow()) {
                err("Bogus coder result, expected underflow.", input,
                        expectedBytes);
            }
        }
        CoderResult result = encoder.flush(byteBuf);
        if (result.isMalformed()) {
            err("Encoder reported a malformed sequence when asked to replace when flushing.",
                    input, expectedBytes);
            return;
        } else if (result.isUnmappable()) {
            err("Encoder reported an unmappable sequence when asked to replace when flushing.",
                    input, expectedBytes);
            return;
        } else if (result.isOverflow()) {
            err("Encoder claimed overflow when flushing when the output buffer is know to be large enough.",
                    input, expectedBytes);
        } else if (!result.isUnderflow()) {
            err("Bogus coder result when flushing, expected underflow.", input,
                    expectedBytes);

        }

        byteBuf.limit(byteBuf.position());
        byteBuf.position(0);

        for (int i = 0; i < expectedBytes.length; i++) {
            byte expect = expectedBytes[i];
            byte actual = byteBuf.get();
            if (actual != expect) {
                err("When encoding one char at a time in REPORT mode, failed at position "
                        + i
                        + ", expected: "
                        + byteToHex(expect)
                        + ", got: "
                        + byteToHex(actual), input, expectedBytes);
                return;
            }
        }

        // Decode with 1-byte output buffer

        charBuf = CharBuffer.wrap(input);
        byteBuf = ByteBuffer.allocate(1);

        encoder.reset(); // Let's test this while at it
        encoder.onMalformedInput(CodingErrorAction.REPLACE);
        encoder.onUnmappableCharacter(CodingErrorAction.REPLACE);
        int bytePos = 0;
        while (charBuf.hasRemaining()) {
            byteBuf.position(0);
            byteBuf.put((byte)0);
            byteBuf.position(0);
            result = encoder.encode(charBuf, byteBuf, false);
            if (result.isMalformed()) {
                err("Encoder reported a malformed sequence when asked to replace at index (decoding one output code unit at a time): "
                        + charBuf.position(), input, expectedBytes);
                return;
            } else if (result.isUnmappable()) {
                err("Encoder reported an unmappable sequence when asked to replace at index (decoding one output code unit at a time): "
                        + charBuf.position(), input, expectedBytes);
                return;
            } else if (result.isUnderflow()) {
                if (charBuf.hasRemaining()) {
                    err("When encoding one output byte at a time, encoder claimed underflow when there was input remaining.",
                            input, expectedBytes);
                    return;
                }
            } else if (!result.isOverflow()) {
                err("Bogus coder result, expected overflow.", input, expectedBytes);
            }
            if (byteBuf.position() == 1) {
                byteBuf.position(0);
                byte actual = byteBuf.get();
                byte expect = expectedBytes[bytePos];
                if (actual != expect) {
                    err("When encoding one output byte at a time in REPLACE mode, failed at position "
                            + charBuf.position()
                            + ", expected: "
                            + byteToHex(expect) + ", got: " + byteToHex(actual),
                            input, expectedBytes);
                    return;
                }
                bytePos++;
            }
        }

        byteBuf.position(0);
        byteBuf.put((byte)0);
        byteBuf.position(0);
        result = encoder.encode(charBuf, byteBuf, true);

        if (byteBuf.position() == 1) {
            byteBuf.position(0);
            byte actual = byteBuf.get();
            byte expect = expectedBytes[bytePos];
            if (actual != expect) {
                err("When encoding one output byte at a time in REPLACE mode, failed at position "
                        + charBuf.position()
                        + ", expected: "
                        + byteToHex(expect) + ", got: " + byteToHex(actual),
                        input, expectedBytes);
                return;
            }
            bytePos++;
        }

        byteBuf.position(0);
        byteBuf.put((byte)0);
        byteBuf.position(0);
        result = encoder.flush(byteBuf);
        if (result.isMalformed()) {
            err("Encoder reported a malformed sequence when asked to replace when flushing (one output at a time).",
                    input, expectedBytes);
            return;
        } else if (result.isUnmappable()) {
            err("Encoder reported an unmappable sequence when asked to replace when flushing (one output at a time).",
                    input, expectedBytes);
            return;
        } else if (result.isOverflow()) {
            err("Encoder claimed overflow when flushing when the output buffer is know to be large enough (one output at a time).",
                    input, expectedBytes);
        } else if (!result.isUnderflow()) {
            err("Bogus coder result when flushing, expected underflow (one output at a time).",
                    input, expectedBytes);
        }

        if (byteBuf.position() == 1) {
            byteBuf.position(0);
            byte actual = byteBuf.get();
            byte expect = expectedBytes[bytePos];
            if (actual != expect) {
                err("When encoding one output code unit at a time in REPLACE mode, failed when flushing, expected: "
                        + byteToHex(expect) + ", got: " + byteToHex(actual),
                        input, expectedBytes);
                return;
            }
        }

        // TODO: 2 bytes at a time starting at 0 and 2 bytes at a time starting
        // at 1
    }

    private String charToHex(char c) {
        String hex = Integer.toHexString(c);
        switch (hex.length()) {
            case 1:
                return "000" + hex;
            case 2:
                return "00" + hex;
            case 3:
                return "0" + hex;
            default:
                return hex;
        }
    }

    private String byteToHex(byte b) {
        String hex = Integer.toHexString(((int) b & 0xFF));
        switch (hex.length()) {
            case 1:
                return "0" + hex;
            default:
                return hex;
        }
    }

    private void err(String msg, byte[] bytes, String expectation) {
        System.err.println(msg);
        System.err.print("Input:");
        for (int i = 0; i < bytes.length; i++) {
            System.err.print(' ');
            System.err.print(byteToHex(bytes[i]));
        }
        System.err.println();
        System.err.print("Expect:");
        for (int i = 0; i < expectation.length(); i++) {
            System.err.print(' ');
            System.err.print(charToHex(expectation.charAt(i)));
        }
        System.err.println();
    }

    private void err(String msg, String chars, byte[] expectation) {
        System.err.println(msg);
        System.err.print("Input:");
        for (int i = 0; i < chars.length(); i++) {
            System.err.print(' ');
            System.err.print(charToHex(chars.charAt(i)));
        }
        System.err.println();
        System.err.print("Expect:");
        for (int i = 0; i < expectation.length; i++) {
            System.err.print(' ');
            System.err.print(byteToHex(expectation[i]));
        }
        System.err.println();
    }

}
