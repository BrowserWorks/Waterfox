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

class Iso13 extends Encoding {

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
        '\u201d',
        '\u00a2',
        '\u00a3',
        '\u00a4',
        '\u201e',
        '\u00a6',
        '\u00a7',
        '\u00d8',
        '\u00a9',
        '\u0156',
        '\u00ab',
        '\u00ac',
        '\u00ad',
        '\u00ae',
        '\u00c6',
        '\u00b0',
        '\u00b1',
        '\u00b2',
        '\u00b3',
        '\u201c',
        '\u00b5',
        '\u00b6',
        '\u00b7',
        '\u00f8',
        '\u00b9',
        '\u0157',
        '\u00bb',
        '\u00bc',
        '\u00bd',
        '\u00be',
        '\u00e6',
        '\u0104',
        '\u012e',
        '\u0100',
        '\u0106',
        '\u00c4',
        '\u00c5',
        '\u0118',
        '\u0112',
        '\u010c',
        '\u00c9',
        '\u0179',
        '\u0116',
        '\u0122',
        '\u0136',
        '\u012a',
        '\u013b',
        '\u0160',
        '\u0143',
        '\u0145',
        '\u00d3',
        '\u014c',
        '\u00d5',
        '\u00d6',
        '\u00d7',
        '\u0172',
        '\u0141',
        '\u015a',
        '\u016a',
        '\u00dc',
        '\u017b',
        '\u017d',
        '\u00df',
        '\u0105',
        '\u012f',
        '\u0101',
        '\u0107',
        '\u00e4',
        '\u00e5',
        '\u0119',
        '\u0113',
        '\u010d',
        '\u00e9',
        '\u017a',
        '\u0117',
        '\u0123',
        '\u0137',
        '\u012b',
        '\u013c',
        '\u0161',
        '\u0144',
        '\u0146',
        '\u00f3',
        '\u014d',
        '\u00f5',
        '\u00f6',
        '\u00f7',
        '\u0173',
        '\u0142',
        '\u015b',
        '\u016b',
        '\u00fc',
        '\u017c',
        '\u017e',
        '\u2019'
    };
    
    private static final String[] LABELS = {
        "iso-8859-13",
        "iso8859-13",
        "iso885913"
    };
    
    private static final String NAME = "iso-8859-13";
    
    static final Encoding INSTANCE = new Iso13();
    
    private Iso13() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new InfallibleSingleByteDecoder(this, TABLE);
    }

}
