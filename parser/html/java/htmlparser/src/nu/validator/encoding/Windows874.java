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

class Windows874 extends Encoding {

    private static final char[] TABLE = {
        '\u20ac',
        '\u0081',
        '\u0082',
        '\u0083',
        '\u0084',
        '\u2026',
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
        '\u2018',
        '\u2019',
        '\u201c',
        '\u201d',
        '\u2022',
        '\u2013',
        '\u2014',
        '\u0098',
        '\u0099',
        '\u009a',
        '\u009b',
        '\u009c',
        '\u009d',
        '\u009e',
        '\u009f',
        '\u00a0',
        '\u0e01',
        '\u0e02',
        '\u0e03',
        '\u0e04',
        '\u0e05',
        '\u0e06',
        '\u0e07',
        '\u0e08',
        '\u0e09',
        '\u0e0a',
        '\u0e0b',
        '\u0e0c',
        '\u0e0d',
        '\u0e0e',
        '\u0e0f',
        '\u0e10',
        '\u0e11',
        '\u0e12',
        '\u0e13',
        '\u0e14',
        '\u0e15',
        '\u0e16',
        '\u0e17',
        '\u0e18',
        '\u0e19',
        '\u0e1a',
        '\u0e1b',
        '\u0e1c',
        '\u0e1d',
        '\u0e1e',
        '\u0e1f',
        '\u0e20',
        '\u0e21',
        '\u0e22',
        '\u0e23',
        '\u0e24',
        '\u0e25',
        '\u0e26',
        '\u0e27',
        '\u0e28',
        '\u0e29',
        '\u0e2a',
        '\u0e2b',
        '\u0e2c',
        '\u0e2d',
        '\u0e2e',
        '\u0e2f',
        '\u0e30',
        '\u0e31',
        '\u0e32',
        '\u0e33',
        '\u0e34',
        '\u0e35',
        '\u0e36',
        '\u0e37',
        '\u0e38',
        '\u0e39',
        '\u0e3a',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\u0e3f',
        '\u0e40',
        '\u0e41',
        '\u0e42',
        '\u0e43',
        '\u0e44',
        '\u0e45',
        '\u0e46',
        '\u0e47',
        '\u0e48',
        '\u0e49',
        '\u0e4a',
        '\u0e4b',
        '\u0e4c',
        '\u0e4d',
        '\u0e4e',
        '\u0e4f',
        '\u0e50',
        '\u0e51',
        '\u0e52',
        '\u0e53',
        '\u0e54',
        '\u0e55',
        '\u0e56',
        '\u0e57',
        '\u0e58',
        '\u0e59',
        '\u0e5a',
        '\u0e5b',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd'
    };
    
    private static final String[] LABELS = {
        "dos-874",
        "iso-8859-11",
        "iso8859-11",
        "iso885911",
        "tis-620",
        "windows-874"
    };
    
    private static final String NAME = "windows-874";
    
    static final Encoding INSTANCE = new Windows874();
    
    private Windows874() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new FallibleSingleByteDecoder(this, TABLE);
    }

}
