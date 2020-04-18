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

/*
 * THIS IS A GENERATED FILE. PLEASE DO NOT EDIT.
 * Instead, please regenerate using generate-encoding-data.py
 */

package nu.validator.encoding;

import java.nio.charset.CharsetDecoder;

class Iso8I extends Encoding {

    private static final char[] TABLE = {
        '\u0080',
        '\u0081',
        '\u0082',
        '\u0083',
        '\u0084',
        '\u0085',
        '\u0086',
        '\u0087',
        '\u0088',
        '\u0089',
        '\u008a',
        '\u008b',
        '\u008c',
        '\u008d',
        '\u008e',
        '\u008f',
        '\u0090',
        '\u0091',
        '\u0092',
        '\u0093',
        '\u0094',
        '\u0095',
        '\u0096',
        '\u0097',
        '\u0098',
        '\u0099',
        '\u009a',
        '\u009b',
        '\u009c',
        '\u009d',
        '\u009e',
        '\u009f',
        '\u00a0',
        '\ufffd',
        '\u00a2',
        '\u00a3',
        '\u00a4',
        '\u00a5',
        '\u00a6',
        '\u00a7',
        '\u00a8',
        '\u00a9',
        '\u00d7',
        '\u00ab',
        '\u00ac',
        '\u00ad',
        '\u00ae',
        '\u00af',
        '\u00b0',
        '\u00b1',
        '\u00b2',
        '\u00b3',
        '\u00b4',
        '\u00b5',
        '\u00b6',
        '\u00b7',
        '\u00b8',
        '\u00b9',
        '\u00f7',
        '\u00bb',
        '\u00bc',
        '\u00bd',
        '\u00be',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\u2017',
        '\u05d0',
        '\u05d1',
        '\u05d2',
        '\u05d3',
        '\u05d4',
        '\u05d5',
        '\u05d6',
        '\u05d7',
        '\u05d8',
        '\u05d9',
        '\u05da',
        '\u05db',
        '\u05dc',
        '\u05dd',
        '\u05de',
        '\u05df',
        '\u05e0',
        '\u05e1',
        '\u05e2',
        '\u05e3',
        '\u05e4',
        '\u05e5',
        '\u05e6',
        '\u05e7',
        '\u05e8',
        '\u05e9',
        '\u05ea',
        '\ufffd',
        '\ufffd',
        '\u200e',
        '\u200f',
        '\ufffd'
    };
    
    private static final String[] LABELS = {
        "csiso88598i",
        "iso-8859-8-i",
        "logical"
    };
    
    private static final String NAME = "iso-8859-8-i";
    
    static final Encoding INSTANCE = new Iso8I();
    
    private Iso8I() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new FallibleSingleByteDecoder(this, TABLE);
    }

}
