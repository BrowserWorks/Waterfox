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

class Iso16 extends Encoding {

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
        '\u0104',
        '\u0105',
        '\u0141',
        '\u20ac',
        '\u201e',
        '\u0160',
        '\u00a7',
        '\u0161',
        '\u00a9',
        '\u0218',
        '\u00ab',
        '\u0179',
        '\u00ad',
        '\u017a',
        '\u017b',
        '\u00b0',
        '\u00b1',
        '\u010c',
        '\u0142',
        '\u017d',
        '\u201d',
        '\u00b6',
        '\u00b7',
        '\u017e',
        '\u010d',
        '\u0219',
        '\u00bb',
        '\u0152',
        '\u0153',
        '\u0178',
        '\u017c',
        '\u00c0',
        '\u00c1',
        '\u00c2',
        '\u0102',
        '\u00c4',
        '\u0106',
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
        '\u0110',
        '\u0143',
        '\u00d2',
        '\u00d3',
        '\u00d4',
        '\u0150',
        '\u00d6',
        '\u015a',
        '\u0170',
        '\u00d9',
        '\u00da',
        '\u00db',
        '\u00dc',
        '\u0118',
        '\u021a',
        '\u00df',
        '\u00e0',
        '\u00e1',
        '\u00e2',
        '\u0103',
        '\u00e4',
        '\u0107',
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
        '\u0111',
        '\u0144',
        '\u00f2',
        '\u00f3',
        '\u00f4',
        '\u0151',
        '\u00f6',
        '\u015b',
        '\u0171',
        '\u00f9',
        '\u00fa',
        '\u00fb',
        '\u00fc',
        '\u0119',
        '\u021b',
        '\u00ff'
    };
    
    private static final String[] LABELS = {
        "iso-8859-16"
    };
    
    private static final String NAME = "iso-8859-16";
    
    static final Encoding INSTANCE = new Iso16();
    
    private Iso16() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new InfallibleSingleByteDecoder(this, TABLE);
    }

}
