/*
 * Copyright (c) 2007 Henri Sivonen
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

package nu.validator.htmlparser.test;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;

import nu.validator.htmlparser.common.Heuristics;
import nu.validator.htmlparser.io.Encoding;
import nu.validator.htmlparser.io.HtmlInputStreamReader;

import org.xml.sax.SAXException;

public class EncodingTester {

    private final InputStream aggregateStream;

    private final StringBuilder builder = new StringBuilder();

    /**
     * @param aggregateStream
     */
    public EncodingTester(InputStream aggregateStream) {
        this.aggregateStream = aggregateStream;
    }

    private void runTests() throws IOException, SAXException {
        while (runTest()) {
            // spin
        }
    }

    private boolean runTest() throws IOException, SAXException {
        if (skipLabel()) {
            return false;
        }
        UntilHashInputStream stream = new UntilHashInputStream(aggregateStream);
        HtmlInputStreamReader reader = new HtmlInputStreamReader(stream, null,
                null, null, Heuristics.NONE);
        Charset charset = reader.getCharset();
        stream.close();
        if (skipLabel()) {
            System.err.println("Premature end of test data.");
            return false;
        }
        builder.setLength(0);
        loop: for (;;) {
            int b = aggregateStream.read();
            switch (b) {
                case '\n':
                    break loop;
                case -1:
                    System.err.println("Premature end of test data.");
                    return false;
                default:
                    builder.append(((char) b));
            }
        }
        String sniffed = charset.name();
        String expected = Encoding.forName(builder.toString()).newDecoder().charset().name();
        if (expected.equalsIgnoreCase(sniffed)) {
            System.err.println("Success.");
            // System.err.println(stream);
        } else {
            System.err.println("Failure. Expected: " + expected + " got "
                    + sniffed + ".");
            System.err.println(stream);
        }
        return true;
    }

    private boolean skipLabel() throws IOException {
        int b = aggregateStream.read();
        if (b == -1) {
            return true;
        }
        for (;;) {
            b = aggregateStream.read();
            if (b == -1) {
                return true;
            } else if (b == 0x0A) {
                return false;
            }
        }
    }

    /**
     * @param args
     * @throws SAXException
     * @throws IOException
     */
    public static void main(String[] args) throws IOException, SAXException {
        for (int i = 0; i < args.length; i++) {
            EncodingTester tester = new EncodingTester(new FileInputStream(
                    args[i]));
            tester.runTests();
        }
    }

}
