/*
 * Copyright (c) 2007-2008 Mozilla Foundation
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

package nu.validator.htmlparser.common;

import org.xml.sax.SAXException;

/**
 * An interface for receiving notifications of UTF-16 code units read from a character stream.
 * 
 * @version $Id$
 * @author hsivonen
 */
public interface CharacterHandler {

    /**
     * Receive notification of a run of UTF-16 code units.
     * @param ch the buffer
     * @param start start index in the buffer
     * @param length the number of characters to process starting from <code>start</code>
     * @throws SAXException if things go wrong
     */
    public void characters(char[] ch, int start, int length)
            throws SAXException;

    /**
     * Signals the end of the stream. Can be used for cleanup. Doesn't mean that the stream ended successfully.
     * 
     * @throws SAXException if things go wrong
     */
    public void end() throws SAXException;

    /**
     * Signals the start of the stream. Can be used for setup.
     * 
     * @throws SAXException if things go wrong
     */
    public void start() throws SAXException;

}