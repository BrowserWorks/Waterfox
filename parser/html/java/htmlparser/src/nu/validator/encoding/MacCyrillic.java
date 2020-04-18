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

class MacCyrillic extends Encoding {

    private static final char[] TABLE = {
        '\u0410',
        '\u0411',
        '\u0412',
        '\u0413',
        '\u0414',
        '\u0415',
        '\u0416',
        '\u0417',
        '\u0418',
        '\u0419',
        '\u041a',
        '\u041b',
        '\u041c',
        '\u041d',
        '\u041e',
        '\u041f',
        '\u0420',
        '\u0421',
        '\u0422',
        '\u0423',
        '\u0424',
        '\u0425',
        '\u0426',
        '\u0427',
        '\u0428',
        '\u0429',
        '\u042a',
        '\u042b',
        '\u042c',
        '\u042d',
        '\u042e',
        '\u042f',
        '\u2020',
        '\u00b0',
        '\u0490',
        '\u00a3',
        '\u00a7',
        '\u2022',
        '\u00b6',
        '\u0406',
        '\u00ae',
        '\u00a9',
        '\u2122',
        '\u0402',
        '\u0452',
        '\u2260',
        '\u0403',
        '\u0453',
        '\u221e',
        '\u00b1',
        '\u2264',
        '\u2265',
        '\u0456',
        '\u00b5',
        '\u0491',
        '\u0408',
        '\u0404',
        '\u0454',
        '\u0407',
        '\u0457',
        '\u0409',
        '\u0459',
        '\u040a',
        '\u045a',
        '\u0458',
        '\u0405',
        '\u00ac',
        '\u221a',
        '\u0192',
        '\u2248',
        '\u2206',
        '\u00ab',
        '\u00bb',
        '\u2026',
        '\u00a0',
        '\u040b',
        '\u045b',
        '\u040c',
        '\u045c',
        '\u0455',
        '\u2013',
        '\u2014',
        '\u201c',
        '\u201d',
        '\u2018',
        '\u2019',
        '\u00f7',
        '\u201e',
        '\u040e',
        '\u045e',
        '\u040f',
        '\u045f',
        '\u2116',
        '\u0401',
        '\u0451',
        '\u044f',
        '\u0430',
        '\u0431',
        '\u0432',
        '\u0433',
        '\u0434',
        '\u0435',
        '\u0436',
        '\u0437',
        '\u0438',
        '\u0439',
        '\u043a',
        '\u043b',
        '\u043c',
        '\u043d',
        '\u043e',
        '\u043f',
        '\u0440',
        '\u0441',
        '\u0442',
        '\u0443',
        '\u0444',
        '\u0445',
        '\u0446',
        '\u0447',
        '\u0448',
        '\u0449',
        '\u044a',
        '\u044b',
        '\u044c',
        '\u044d',
        '\u044e',
        '\u20ac'
    };
    
    private static final String[] LABELS = {
        "x-mac-cyrillic",
        "x-mac-ukrainian"
    };
    
    private static final String NAME = "x-mac-cyrillic";
    
    static final Encoding INSTANCE = new MacCyrillic();
    
    private MacCyrillic() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new InfallibleSingleByteDecoder(this, TABLE);
    }

}
