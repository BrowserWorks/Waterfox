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

class Iso3 extends Encoding {

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
        '\u0126',
        '\u02d8',
        '\u00a3',
        '\u00a4',
        '\ufffd',
        '\u0124',
        '\u00a7',
        '\u00a8',
        '\u0130',
        '\u015e',
        '\u011e',
        '\u0134',
        '\u00ad',
        '\ufffd',
        '\u017b',
        '\u00b0',
        '\u0127',
        '\u00b2',
        '\u00b3',
        '\u00b4',
        '\u00b5',
        '\u0125',
        '\u00b7',
        '\u00b8',
        '\u0131',
        '\u015f',
        '\u011f',
        '\u0135',
        '\u00bd',
        '\ufffd',
        '\u017c',
        '\u00c0',
        '\u00c1',
        '\u00c2',
        '\ufffd',
        '\u00c4',
        '\u010a',
        '\u0108',
        '\u00c7',
        '\u00c8',
        '\u00c9',
        '\u00ca',
        '\u00cb',
        '\u00cc',
        '\u00cd',
        '\u00ce',
        '\u00cf',
        '\ufffd',
        '\u00d1',
        '\u00d2',
        '\u00d3',
        '\u00d4',
        '\u0120',
        '\u00d6',
        '\u00d7',
        '\u011c',
        '\u00d9',
        '\u00da',
        '\u00db',
        '\u00dc',
        '\u016c',
        '\u015c',
        '\u00df',
        '\u00e0',
        '\u00e1',
        '\u00e2',
        '\ufffd',
        '\u00e4',
        '\u010b',
        '\u0109',
        '\u00e7',
        '\u00e8',
        '\u00e9',
        '\u00ea',
        '\u00eb',
        '\u00ec',
        '\u00ed',
        '\u00ee',
        '\u00ef',
        '\ufffd',
        '\u00f1',
        '\u00f2',
        '\u00f3',
        '\u00f4',
        '\u0121',
        '\u00f6',
        '\u00f7',
        '\u011d',
        '\u00f9',
        '\u00fa',
        '\u00fb',
        '\u00fc',
        '\u016d',
        '\u015d',
        '\u02d9'
    };
    
    private static final String[] LABELS = {
        "csisolatin3",
        "iso-8859-3",
        "iso-ir-109",
        "iso8859-3",
        "iso88593",
        "iso_8859-3",
        "iso_8859-3:1988",
        "l3",
        "latin3"
    };
    
    private static final String NAME = "iso-8859-3";
    
    static final Encoding INSTANCE = new Iso3();
    
    private Iso3() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new FallibleSingleByteDecoder(this, TABLE);
    }

}
