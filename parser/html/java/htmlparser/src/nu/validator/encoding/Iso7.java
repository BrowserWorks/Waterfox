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

class Iso7 extends Encoding {

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
        '\u2018',
        '\u2019',
        '\u00a3',
        '\u20ac',
        '\u20af',
        '\u00a6',
        '\u00a7',
        '\u00a8',
        '\u00a9',
        '\u037a',
        '\u00ab',
        '\u00ac',
        '\u00ad',
        '\ufffd',
        '\u2015',
        '\u00b0',
        '\u00b1',
        '\u00b2',
        '\u00b3',
        '\u0384',
        '\u0385',
        '\u0386',
        '\u00b7',
        '\u0388',
        '\u0389',
        '\u038a',
        '\u00bb',
        '\u038c',
        '\u00bd',
        '\u038e',
        '\u038f',
        '\u0390',
        '\u0391',
        '\u0392',
        '\u0393',
        '\u0394',
        '\u0395',
        '\u0396',
        '\u0397',
        '\u0398',
        '\u0399',
        '\u039a',
        '\u039b',
        '\u039c',
        '\u039d',
        '\u039e',
        '\u039f',
        '\u03a0',
        '\u03a1',
        '\ufffd',
        '\u03a3',
        '\u03a4',
        '\u03a5',
        '\u03a6',
        '\u03a7',
        '\u03a8',
        '\u03a9',
        '\u03aa',
        '\u03ab',
        '\u03ac',
        '\u03ad',
        '\u03ae',
        '\u03af',
        '\u03b0',
        '\u03b1',
        '\u03b2',
        '\u03b3',
        '\u03b4',
        '\u03b5',
        '\u03b6',
        '\u03b7',
        '\u03b8',
        '\u03b9',
        '\u03ba',
        '\u03bb',
        '\u03bc',
        '\u03bd',
        '\u03be',
        '\u03bf',
        '\u03c0',
        '\u03c1',
        '\u03c2',
        '\u03c3',
        '\u03c4',
        '\u03c5',
        '\u03c6',
        '\u03c7',
        '\u03c8',
        '\u03c9',
        '\u03ca',
        '\u03cb',
        '\u03cc',
        '\u03cd',
        '\u03ce',
        '\ufffd'
    };
    
    private static final String[] LABELS = {
        "csisolatingreek",
        "ecma-118",
        "elot_928",
        "greek",
        "greek8",
        "iso-8859-7",
        "iso-ir-126",
        "iso8859-7",
        "iso88597",
        "iso_8859-7",
        "iso_8859-7:1987",
        "sun_eu_greek"
    };
    
    private static final String NAME = "iso-8859-7";
    
    static final Encoding INSTANCE = new Iso7();
    
    private Iso7() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new FallibleSingleByteDecoder(this, TABLE);
    }

}
