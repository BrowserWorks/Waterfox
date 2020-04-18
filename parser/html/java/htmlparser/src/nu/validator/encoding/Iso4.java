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

class Iso4 extends Encoding {

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
        '\u0138',
        '\u0156',
        '\u00a4',
        '\u0128',
        '\u013b',
        '\u00a7',
        '\u00a8',
        '\u0160',
        '\u0112',
        '\u0122',
        '\u0166',
        '\u00ad',
        '\u017d',
        '\u00af',
        '\u00b0',
        '\u0105',
        '\u02db',
        '\u0157',
        '\u00b4',
        '\u0129',
        '\u013c',
        '\u02c7',
        '\u00b8',
        '\u0161',
        '\u0113',
        '\u0123',
        '\u0167',
        '\u014a',
        '\u017e',
        '\u014b',
        '\u0100',
        '\u00c1',
        '\u00c2',
        '\u00c3',
        '\u00c4',
        '\u00c5',
        '\u00c6',
        '\u012e',
        '\u010c',
        '\u00c9',
        '\u0118',
        '\u00cb',
        '\u0116',
        '\u00cd',
        '\u00ce',
        '\u012a',
        '\u0110',
        '\u0145',
        '\u014c',
        '\u0136',
        '\u00d4',
        '\u00d5',
        '\u00d6',
        '\u00d7',
        '\u00d8',
        '\u0172',
        '\u00da',
        '\u00db',
        '\u00dc',
        '\u0168',
        '\u016a',
        '\u00df',
        '\u0101',
        '\u00e1',
        '\u00e2',
        '\u00e3',
        '\u00e4',
        '\u00e5',
        '\u00e6',
        '\u012f',
        '\u010d',
        '\u00e9',
        '\u0119',
        '\u00eb',
        '\u0117',
        '\u00ed',
        '\u00ee',
        '\u012b',
        '\u0111',
        '\u0146',
        '\u014d',
        '\u0137',
        '\u00f4',
        '\u00f5',
        '\u00f6',
        '\u00f7',
        '\u00f8',
        '\u0173',
        '\u00fa',
        '\u00fb',
        '\u00fc',
        '\u0169',
        '\u016b',
        '\u02d9'
    };
    
    private static final String[] LABELS = {
        "csisolatin4",
        "iso-8859-4",
        "iso-ir-110",
        "iso8859-4",
        "iso88594",
        "iso_8859-4",
        "iso_8859-4:1988",
        "l4",
        "latin4"
    };
    
    private static final String NAME = "iso-8859-4";
    
    static final Encoding INSTANCE = new Iso4();
    
    private Iso4() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new InfallibleSingleByteDecoder(this, TABLE);
    }

}
