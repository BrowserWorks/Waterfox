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

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.CharsetEncoder;
import java.nio.charset.CodingErrorAction;

import nu.validator.htmlparser.common.Heuristics;
import nu.validator.htmlparser.io.Encoding;
import nu.validator.htmlparser.io.HtmlInputStreamReader;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;

public class DecoderLoopTester {
    
    private static final int LEAD_OFFSET = 0xD800 - (0x10000 >> 10);

    private static final int NUMBER_OR_ASTRAL_CHARS = 24500;
    
    private void runTest(int padding) throws SAXException, IOException {
       Encoding utf8 = Encoding.forName("UTF-8");
       char[] charArr = new char[1 + padding + 2 * NUMBER_OR_ASTRAL_CHARS];
       byte[] byteArr;
       int i = 0;
       charArr[i++] = '\uFEFF';
       for (int j = 0; j < padding; j++) {
           charArr[i++] = 'x';           
       }
       for (int j = 0; j < NUMBER_OR_ASTRAL_CHARS; j++) {
            int value = 0x10000 + j;
            charArr[i++] = (char) (LEAD_OFFSET + (value >> 10));
            charArr[i++] = (char) (0xDC00 + (value & 0x3FF));
//            charArr[i++] = 'y';
//            charArr[i++] = 'z';

       }
       CharBuffer charBuffer = CharBuffer.wrap(charArr);
       CharsetEncoder enc = utf8.newEncoder();
       enc.onMalformedInput(CodingErrorAction.REPORT);
       enc.onUnmappableCharacter(CodingErrorAction.REPORT);
       ByteBuffer byteBuffer = enc.encode(charBuffer);
       byteArr = new byte[byteBuffer.limit()];
       byteBuffer.get(byteArr);
       
       ErrorHandler eh = new SystemErrErrorHandler();
       compare(new HtmlInputStreamReader(new ByteArrayInputStream(byteArr), eh, null, null, Heuristics.NONE), padding, charArr, byteArr);
       compare(new HtmlInputStreamReader(new ByteArrayInputStream(byteArr), eh, null, null, utf8), padding, charArr, byteArr);
    }

    /**
     * @param padding
     * @param charArr
     * @param byteArr
     * @throws SAXException
     * @throws IOException
     */
    private void compare(HtmlInputStreamReader reader, int padding, char[] charArr, byte[] byteArr) throws SAXException, IOException {
           char[] readBuffer = new char[2048];
           int offset = 0;
           int num = 0;
           int readNum = 0;
           while ((num = reader.read(readBuffer)) != -1) {
               for (int j = 0; j < num; j++) {
                   System.out.println(offset + j);
                   if (readBuffer[j] != charArr[offset + j]) {
                       throw new RuntimeException("Test failed. Char: " + Integer.toHexString(readBuffer[j]) + " j: " + j + " readNum: " + readNum);
                   }
               }
               offset += num;
               readNum++;
           }
    }
    
    void runTests() throws SAXException, IOException {
        for (int i = 0; i < 4; i++) {
            runTest(i);
        }
    }
    
    /**
     * @param args
     * @throws IOException 
     * @throws SAXException 
     */
    public static void main(String[] args) throws IOException, SAXException {
        new DecoderLoopTester().runTests();
    }

}
