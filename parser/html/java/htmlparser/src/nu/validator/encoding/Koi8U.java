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

class Koi8U extends Encoding {

    private static final char[] TABLE = {
        '\u2500',
        '\u2502',
        '\u250c',
        '\u2510',
        '\u2514',
        '\u2518',
        '\u251c',
        '\u2524',
        '\u252c',
        '\u2534',
        '\u253c',
        '\u2580',
        '\u2584',
        '\u2588',
        '\u258c',
        '\u2590',
        '\u2591',
        '\u2592',
        '\u2593',
        '\u2320',
        '\u25a0',
        '\u2219',
        '\u221a',
        '\u2248',
        '\u2264',
        '\u2265',
        '\u00a0',
        '\u2321',
        '\u00b0',
        '\u00b2',
        '\u00b7',
        '\u00f7',
        '\u2550',
        '\u2551',
        '\u2552',
        '\u0451',
        '\u0454',
        '\u2554',
        '\u0456',
        '\u0457',
        '\u2557',
        '\u2558',
        '\u2559',
        '\u255a',
        '\u255b',
        '\u0491',
        '\u045e',
        '\u255e',
        '\u255f',
        '\u2560',
        '\u2561',
        '\u0401',
        '\u0404',
        '\u2563',
        '\u0406',
        '\u0407',
        '\u2566',
        '\u2567',
        '\u2568',
        '\u2569',
        '\u256a',
        '\u0490',
        '\u040e',
        '\u00a9',
        '\u044e',
        '\u0430',
        '\u0431',
        '\u0446',
        '\u0434',
        '\u0435',
        '\u0444',
        '\u0433',
        '\u0445',
        '\u0438',
        '\u0439',
        '\u043a',
        '\u043b',
        '\u043c',
        '\u043d',
        '\u043e',
        '\u043f',
        '\u044f',
        '\u0440',
        '\u0441',
        '\u0442',
        '\u0443',
        '\u0436',
        '\u0432',
        '\u044c',
        '\u044b',
        '\u0437',
        '\u0448',
        '\u044d',
        '\u0449',
        '\u0447',
        '\u044a',
        '\u042e',
        '\u0410',
        '\u0411',
        '\u0426',
        '\u0414',
        '\u0415',
        '\u0424',
        '\u0413',
        '\u0425',
        '\u0418',
        '\u0419',
        '\u041a',
        '\u041b',
        '\u041c',
        '\u041d',
        '\u041e',
        '\u041f',
        '\u042f',
        '\u0420',
        '\u0421',
        '\u0422',
        '\u0423',
        '\u0416',
        '\u0412',
        '\u042c',
        '\u042b',
        '\u0417',
        '\u0428',
        '\u042d',
        '\u0429',
        '\u0427',
        '\u042a'
    };
    
    private static final String[] LABELS = {
        "koi8-ru",
        "koi8-u"
    };
    
    private static final String NAME = "koi8-u";
    
    static final Encoding INSTANCE = new Koi8U();
    
    private Koi8U() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new InfallibleSingleByteDecoder(this, TABLE);
    }

}
