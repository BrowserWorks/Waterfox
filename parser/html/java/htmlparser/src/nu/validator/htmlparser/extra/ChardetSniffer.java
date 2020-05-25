/*
 * Copyright (c) 2008 Mozilla Foundation
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

package nu.validator.htmlparser.extra;

import java.io.IOException;
import java.nio.charset.UnsupportedCharsetException;

import nu.validator.htmlparser.io.Encoding;

import org.mozilla.intl.chardet.nsDetector;
import org.mozilla.intl.chardet.nsICharsetDetectionObserver;
import org.mozilla.intl.chardet.nsPSMDetector;

import com.ibm.icu.text.CharsetDetector;

public class ChardetSniffer implements nsICharsetDetectionObserver {

    private final byte[] source;

    private final int length;
    
    private Encoding returnValue = null;
    
    /**
     * @param source
     */
    public ChardetSniffer(final byte[] source, final int length) {
        this.source = source;
        this.length = length;
    }
    
    public Encoding sniff() throws IOException {
        nsDetector detector = new nsDetector(nsPSMDetector.ALL);
        detector.Init(this);
        detector.DoIt(source, length, false);
        detector.DataEnd();
        if (returnValue != null && returnValue != Encoding.WINDOWS1252 && returnValue.isAsciiSuperset()) {
            return returnValue;
        } else {
            return null;
        }
    }
    
    public static void main(String[] args) {
        String[] detectable = CharsetDetector.getAllDetectableCharsets();
        for (int i = 0; i < detectable.length; i++) {
            String charset = detectable[i];
            System.out.println(charset);
        }
    }

    public void Notify(String charsetName) {
        try {
            Encoding enc = Encoding.forName(charsetName);
            Encoding actual = enc.getActualHtmlEncoding();
            if (actual != null) {
                enc = actual;
            }
            returnValue = enc;
        } catch (UnsupportedCharsetException e) {
            returnValue = null;
        }
    }
}
