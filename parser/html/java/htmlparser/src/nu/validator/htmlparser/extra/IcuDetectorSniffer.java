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
import java.io.InputStream;

import nu.validator.htmlparser.common.ByteReadable;
import nu.validator.htmlparser.io.Encoding;

import com.ibm.icu.text.CharsetDetector;
import com.ibm.icu.text.CharsetMatch;

public class IcuDetectorSniffer extends InputStream {

    private final ByteReadable source;

    /**
     * @param source
     */
    public IcuDetectorSniffer(final ByteReadable source) {
        this.source = source;
    }
    
    @Override
    public int read() throws IOException {
        return source.readByte();
    }
    
    public Encoding sniff() throws IOException {
        try {
            CharsetDetector detector = new CharsetDetector();
            detector.setText(this);
            CharsetMatch match = detector.detect();
            Encoding enc = Encoding.forName(match.getName());
            Encoding actual = enc.getActualHtmlEncoding();
            if (actual != null) {
                enc = actual;
            }
            if (enc != Encoding.WINDOWS1252 && enc.isAsciiSuperset()) {
                return enc;
            } else {
                return null;
            }
        } catch (Exception e) {
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
}
