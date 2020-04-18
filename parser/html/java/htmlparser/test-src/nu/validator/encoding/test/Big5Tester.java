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

import nu.validator.encoding.Encoding;

public class Big5Tester extends EncodingTester {

    public static void main(String[] args) {
        new Big5Tester().test();
    }

    private void test() {
        // ASCII
        decodeBig5("\u6162", "\u0061\u0062");
        // Edge cases
        decodeBig5("\u8740", "\u43F0");
        decodeBig5("\uFEFE", "\u79D4");
        decodeBig5("\uFEFD", "\uD864\uDD0D");
        decodeBig5("\u8862", "\u00CA\u0304");
        decodeBig5("\u8864", "\u00CA\u030C");
        decodeBig5("\u8866", "\u00CA");
        decodeBig5("\u88A3", "\u00EA\u0304");
        decodeBig5("\u88A5", "\u00EA\u030C");
        decodeBig5("\u88A7", "\u00EA");
        decodeBig5("\u99D4", "\u8991");
        decodeBig5("\u99D5", "\uD85E\uDD67");
        decodeBig5("\u99D6", "\u8A29");
        // Edge cases surrounded with ASCII
        decodeBig5("\u6187\u4062", "\u0061\u43F0\u0062");
        decodeBig5("\u61FE\uFE62", "\u0061\u79D4\u0062");
        decodeBig5("\u61FE\uFD62", "\u0061\uD864\uDD0D\u0062");
        decodeBig5("\u6188\u6262", "\u0061\u00CA\u0304\u0062");
        decodeBig5("\u6188\u6462", "\u0061\u00CA\u030C\u0062");
        decodeBig5("\u6188\u6662", "\u0061\u00CA\u0062");
        decodeBig5("\u6188\uA362", "\u0061\u00EA\u0304\u0062");
        decodeBig5("\u6188\uA562", "\u0061\u00EA\u030C\u0062");
        decodeBig5("\u6188\uA762", "\u0061\u00EA\u0062");
        decodeBig5("\u6199\uD462", "\u0061\u8991\u0062");
        decodeBig5("\u6199\uD562", "\u0061\uD85E\uDD67\u0062");
        decodeBig5("\u6199\uD662", "\u0061\u8A29\u0062");
        // Bad sequences
        decodeBig5("\u8061", "\uFFFD\u0061");
        decodeBig5("\uFF61", "\uFFFD\u0061");
        decodeBig5("\uFE39", "\uFFFD\u0039");
        decodeBig5("\u8766", "\uFFFD\u0066");
        decodeBig5("\u8140", "\uFFFD\u0040");
        decodeBig5("\u6181", "\u0061\uFFFD");

        // ASCII
        encodeBig5("\u0061\u0062", "\u6162");
        // Edge cases
        encodeBig5("\u9EA6\u0061", "\u3F61");
        encodeBig5("\uD858\uDE6B\u0061", "\u3F61");
        encodeBig5("\u3000", "\uA140");
        encodeBig5("\u20AC", "\uA3E1");
        encodeBig5("\u4E00", "\uA440");
        encodeBig5("\uD85D\uDE07", "\uC8A4");
        encodeBig5("\uFFE2", "\uC8CD");
        encodeBig5("\u79D4", "\uFEFE");
        // Not in index
        encodeBig5("\u2603\u0061", "\u3F61");
        // duplicate low bits
        encodeBig5("\uD840\uDFB5", "\uFD6A");
        // prefer last
        encodeBig5("\u2550", "\uF9F9");
    }

    private void decodeBig5(String input, String expectation) {
        decode(input, expectation, Encoding.BIG5);
    }

    private void encodeBig5(String input, String expectation) {
        encode(input, expectation, Encoding.BIG5);
    }
}
