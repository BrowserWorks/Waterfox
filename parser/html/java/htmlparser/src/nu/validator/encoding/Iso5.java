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

class Iso5 extends Encoding {

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
        '\u0401',
        '\u0402',
        '\u0403',
        '\u0404',
        '\u0405',
        '\u0406',
        '\u0407',
        '\u0408',
        '\u0409',
        '\u040a',
        '\u040b',
        '\u040c',
        '\u00ad',
        '\u040e',
        '\u040f',
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
        '\u2116',
        '\u0451',
        '\u0452',
        '\u0453',
        '\u0454',
        '\u0455',
        '\u0456',
        '\u0457',
        '\u0458',
        '\u0459',
        '\u045a',
        '\u045b',
        '\u045c',
        '\u00a7',
        '\u045e',
        '\u045f'
    };
    
    private static final String[] LABELS = {
        "csisolatincyrillic",
        "cyrillic",
        "iso-8859-5",
        "iso-ir-144",
        "iso8859-5",
        "iso88595",
        "iso_8859-5",
        "iso_8859-5:1988"
    };
    
    private static final String NAME = "iso-8859-5";
    
    static final Encoding INSTANCE = new Iso5();
    
    private Iso5() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new InfallibleSingleByteDecoder(this, TABLE);
    }

}
