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

class Iso14 extends Encoding {

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
        '\u1e02',
        '\u1e03',
        '\u00a3',
        '\u010a',
        '\u010b',
        '\u1e0a',
        '\u00a7',
        '\u1e80',
        '\u00a9',
        '\u1e82',
        '\u1e0b',
        '\u1ef2',
        '\u00ad',
        '\u00ae',
        '\u0178',
        '\u1e1e',
        '\u1e1f',
        '\u0120',
        '\u0121',
        '\u1e40',
        '\u1e41',
        '\u00b6',
        '\u1e56',
        '\u1e81',
        '\u1e57',
        '\u1e83',
        '\u1e60',
        '\u1ef3',
        '\u1e84',
        '\u1e85',
        '\u1e61',
        '\u00c0',
        '\u00c1',
        '\u00c2',
        '\u00c3',
        '\u00c4',
        '\u00c5',
        '\u00c6',
        '\u00c7',
        '\u00c8',
        '\u00c9',
        '\u00ca',
        '\u00cb',
        '\u00cc',
        '\u00cd',
        '\u00ce',
        '\u00cf',
        '\u0174',
        '\u00d1',
        '\u00d2',
        '\u00d3',
        '\u00d4',
        '\u00d5',
        '\u00d6',
        '\u1e6a',
        '\u00d8',
        '\u00d9',
        '\u00da',
        '\u00db',
        '\u00dc',
        '\u00dd',
        '\u0176',
        '\u00df',
        '\u00e0',
        '\u00e1',
        '\u00e2',
        '\u00e3',
        '\u00e4',
        '\u00e5',
        '\u00e6',
        '\u00e7',
        '\u00e8',
        '\u00e9',
        '\u00ea',
        '\u00eb',
        '\u00ec',
        '\u00ed',
        '\u00ee',
        '\u00ef',
        '\u0175',
        '\u00f1',
        '\u00f2',
        '\u00f3',
        '\u00f4',
        '\u00f5',
        '\u00f6',
        '\u1e6b',
        '\u00f8',
        '\u00f9',
        '\u00fa',
        '\u00fb',
        '\u00fc',
        '\u00fd',
        '\u0177',
        '\u00ff'
    };
    
    private static final String[] LABELS = {
        "iso-8859-14",
        "iso8859-14",
        "iso885914"
    };
    
    private static final String NAME = "iso-8859-14";
    
    static final Encoding INSTANCE = new Iso14();
    
    private Iso14() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new InfallibleSingleByteDecoder(this, TABLE);
    }

}
