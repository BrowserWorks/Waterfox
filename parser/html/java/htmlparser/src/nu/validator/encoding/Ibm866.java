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

class Ibm866 extends Encoding {

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
        '\u2591',
        '\u2592',
        '\u2593',
        '\u2502',
        '\u2524',
        '\u2561',
        '\u2562',
        '\u2556',
        '\u2555',
        '\u2563',
        '\u2551',
        '\u2557',
        '\u255d',
        '\u255c',
        '\u255b',
        '\u2510',
        '\u2514',
        '\u2534',
        '\u252c',
        '\u251c',
        '\u2500',
        '\u253c',
        '\u255e',
        '\u255f',
        '\u255a',
        '\u2554',
        '\u2569',
        '\u2566',
        '\u2560',
        '\u2550',
        '\u256c',
        '\u2567',
        '\u2568',
        '\u2564',
        '\u2565',
        '\u2559',
        '\u2558',
        '\u2552',
        '\u2553',
        '\u256b',
        '\u256a',
        '\u2518',
        '\u250c',
        '\u2588',
        '\u2584',
        '\u258c',
        '\u2590',
        '\u2580',
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
        '\u044f',
        '\u0401',
        '\u0451',
        '\u0404',
        '\u0454',
        '\u0407',
        '\u0457',
        '\u040e',
        '\u045e',
        '\u00b0',
        '\u2219',
        '\u00b7',
        '\u221a',
        '\u2116',
        '\u00a4',
        '\u25a0',
        '\u00a0'
    };
    
    private static final String[] LABELS = {
        "866",
        "cp866",
        "csibm866",
        "ibm866"
    };
    
    private static final String NAME = "ibm866";
    
    static final Encoding INSTANCE = new Ibm866();
    
    private Ibm866() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new InfallibleSingleByteDecoder(this, TABLE);
    }

}
