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

class Windows1250 extends Encoding {

    private static final char[] TABLE = {
        '\u20ac',
        '\u0081',
        '\u201a',
        '\u0083',
        '\u201e',
        '\u2026',
        '\u2020',
        '\u2021',
        '\u0088',
        '\u2030',
        '\u0160',
        '\u2039',
        '\u015a',
        '\u0164',
        '\u017d',
        '\u0179',
        '\u0090',
        '\u2018',
        '\u2019',
        '\u201c',
        '\u201d',
        '\u2022',
        '\u2013',
        '\u2014',
        '\u0098',
        '\u2122',
        '\u0161',
        '\u203a',
        '\u015b',
        '\u0165',
        '\u017e',
        '\u017a',
        '\u00a0',
        '\u02c7',
        '\u02d8',
        '\u0141',
        '\u00a4',
        '\u0104',
        '\u00a6',
        '\u00a7',
        '\u00a8',
        '\u00a9',
        '\u015e',
        '\u00ab',
        '\u00ac',
        '\u00ad',
        '\u00ae',
        '\u017b',
        '\u00b0',
        '\u00b1',
        '\u02db',
        '\u0142',
        '\u00b4',
        '\u00b5',
        '\u00b6',
        '\u00b7',
        '\u00b8',
        '\u0105',
        '\u015f',
        '\u00bb',
        '\u013d',
        '\u02dd',
        '\u013e',
        '\u017c',
        '\u0154',
        '\u00c1',
        '\u00c2',
        '\u0102',
        '\u00c4',
        '\u0139',
        '\u0106',
        '\u00c7',
        '\u010c',
        '\u00c9',
        '\u0118',
        '\u00cb',
        '\u011a',
        '\u00cd',
        '\u00ce',
        '\u010e',
        '\u0110',
        '\u0143',
        '\u0147',
        '\u00d3',
        '\u00d4',
        '\u0150',
        '\u00d6',
        '\u00d7',
        '\u0158',
        '\u016e',
        '\u00da',
        '\u0170',
        '\u00dc',
        '\u00dd',
        '\u0162',
        '\u00df',
        '\u0155',
        '\u00e1',
        '\u00e2',
        '\u0103',
        '\u00e4',
        '\u013a',
        '\u0107',
        '\u00e7',
        '\u010d',
        '\u00e9',
        '\u0119',
        '\u00eb',
        '\u011b',
        '\u00ed',
        '\u00ee',
        '\u010f',
        '\u0111',
        '\u0144',
        '\u0148',
        '\u00f3',
        '\u00f4',
        '\u0151',
        '\u00f6',
        '\u00f7',
        '\u0159',
        '\u016f',
        '\u00fa',
        '\u0171',
        '\u00fc',
        '\u00fd',
        '\u0163',
        '\u02d9'
    };
    
    private static final String[] LABELS = {
        "cp1250",
        "windows-1250",
        "x-cp1250"
    };
    
    private static final String NAME = "windows-1250";
    
    static final Encoding INSTANCE = new Windows1250();
    
    private Windows1250() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new InfallibleSingleByteDecoder(this, TABLE);
    }

}
