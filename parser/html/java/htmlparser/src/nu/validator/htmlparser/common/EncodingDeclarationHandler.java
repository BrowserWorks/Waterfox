/*
 * Copyright (c) 2008-2010 Mozilla Foundation
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
 * An interface for communicating about character encoding names with the
 * environment of the parser.
 * 
 * @version $Id$
 * @author hsivonen
 */
public interface EncodingDeclarationHandler {

    /**
     * Indicates that the parser has found an internal encoding declaration with
     * the charset value <code>charset</code>.
     * 
     * @param charset
     *            the charset name found.
     * @return <code>true</code> if the value of <code>charset</code> was an 
     * encoding name for a supported ASCII-superset encoding.
     * @throws SAXException
     *             if something went wrong
     */
    public boolean internalEncodingDeclaration(String charset) throws SAXException;

    /**
     * Queries the environment for the encoding in use (for error reporting).
     * 
     * @return the encoding in use
     * @throws SAXException
     *             if something went wrong
     */
    public String getCharacterEncoding() throws SAXException;

}
