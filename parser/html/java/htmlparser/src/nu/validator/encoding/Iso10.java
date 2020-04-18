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

class Iso10 extends Encoding {

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
        '\u0112',
        '\u0122',
        '\u012a',
        '\u0128',
        '\u0136',
        '\u00a7',
        '\u013b',
        '\u0110',
        '\u0160',
        '\u0166',
        '\u017d',
        '\u00ad',
        '\u016a',
        '\u014a',
        '\u00b0',
        '\u0105',
        '\u0113',
        '\u0123',
        '\u012b',
        '\u0129',
        '\u0137',
        '\u00b7',
        '\u013c',
        '\u0111',
        '\u0161',
        '\u0167',
        '\u017e',
        '\u2015',
        '\u016b',
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
        '\u00cf',
        '\u00d0',
        '\u0145',
        '\u014c',
        '\u00d3',
        '\u00d4',
        '\u00d5',
        '\u00d6',
        '\u0168',
        '\u00d8',
        '\u0172',
        '\u00da',
        '\u00db',
        '\u00dc',
        '\u00dd',
        '\u00de',
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
        '\u00ef',
        '\u00f0',
        '\u0146',
        '\u014d',
        '\u00f3',
        '\u00f4',
        '\u00f5',
        '\u00f6',
        '\u0169',
        '\u00f8',
        '\u0173',
        '\u00fa',
        '\u00fb',
        '\u00fc',
        '\u00fd',
        '\u00fe',
        '\u0138'
    };
    
    private static final String[] LABELS = {
        "csisolatin6",
        "iso-8859-10",
        "iso-ir-157",
        "iso8859-10",
        "iso885910",
        "l6",
        "latin6"
    };
    
    private static final String NAME = "iso-8859-10";
    
    static final Encoding INSTANCE = new Iso10();
    
    private Iso10() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new InfallibleSingleByteDecoder(this, TABLE);
    }

}
