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

package nu.validator.saxtree;

import org.xml.sax.SAXException;
import org.xml.sax.ext.LexicalHandler;

/**
 * A lexical handler that does nothing.
 * @version $Id$
 * @author hsivonen
 */
final class NullLexicalHandler implements LexicalHandler {

    /**
     * 
     * @see org.xml.sax.ext.LexicalHandler#comment(char[], int, int)
     */
    public void comment(char[] arg0, int arg1, int arg2) throws SAXException {
    }

    /**
     * 
     * @see org.xml.sax.ext.LexicalHandler#endCDATA()
     */
    public void endCDATA() throws SAXException {
    }

    /**
     * 
     * @see org.xml.sax.ext.LexicalHandler#endDTD()
     */
    public void endDTD() throws SAXException {
    }

    /**
     * 
     * @see org.xml.sax.ext.LexicalHandler#endEntity(java.lang.String)
     */
    public void endEntity(String arg0) throws SAXException {
    }

    /**
     * 
     * @see org.xml.sax.ext.LexicalHandler#startCDATA()
     */
    public void startCDATA() throws SAXException {
    }

    /**
     * 
     * @see org.xml.sax.ext.LexicalHandler#startDTD(java.lang.String, java.lang.String, java.lang.String)
     */
    public void startDTD(String arg0, String arg1, String arg2) throws SAXException {
    }

    /**
     * 
     * @see org.xml.sax.ext.LexicalHandler#startEntity(java.lang.String)
     */
    public void startEntity(String arg0) throws SAXException {
    }

}
