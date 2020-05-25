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

class Iso6 extends Encoding {

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
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\u00a4',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\u060c',
        '\u00ad',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\u061b',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\u061f',
        '\ufffd',
        '\u0621',
        '\u0622',
        '\u0623',
        '\u0624',
        '\u0625',
        '\u0626',
        '\u0627',
        '\u0628',
        '\u0629',
        '\u062a',
        '\u062b',
        '\u062c',
        '\u062d',
        '\u062e',
        '\u062f',
        '\u0630',
        '\u0631',
        '\u0632',
        '\u0633',
        '\u0634',
        '\u0635',
        '\u0636',
        '\u0637',
        '\u0638',
        '\u0639',
        '\u063a',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\u0640',
        '\u0641',
        '\u0642',
        '\u0643',
        '\u0644',
        '\u0645',
        '\u0646',
        '\u0647',
        '\u0648',
        '\u0649',
        '\u064a',
        '\u064b',
        '\u064c',
        '\u064d',
        '\u064e',
        '\u064f',
        '\u0650',
        '\u0651',
        '\u0652',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd',
        '\ufffd'
    };
    
    private static final String[] LABELS = {
        "arabic",
        "asmo-708",
        "csiso88596e",
        "csiso88596i",
        "csisolatinarabic",
        "ecma-114",
        "iso-8859-6",
        "iso-8859-6-e",
        "iso-8859-6-i",
        "iso-ir-127",
        "iso8859-6",
        "iso88596",
        "iso_8859-6",
        "iso_8859-6:1987"
    };
    
    private static final String NAME = "iso-8859-6";
    
    static final Encoding INSTANCE = new Iso6();
    
    private Iso6() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new FallibleSingleByteDecoder(this, TABLE);
    }

}
