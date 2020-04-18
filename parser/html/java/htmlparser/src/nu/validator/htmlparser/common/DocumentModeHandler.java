/*
 * Copyright (c) 2007 Henri Sivonen
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
 * A callback interface for receiving notification about the document mode.
 * 
 * @version $Id$
 * @author hsivonen
 */
public interface DocumentModeHandler {
    
    /**
     * Receive notification of the document mode.
     * 
     * @param mode the document mode
     * @param publicIdentifier the public id of the doctype or <code>null</code> if unavailable
     * @param systemIdentifier the system id of the doctype or <code>null</code> if unavailable
     * @param html4SpecificAdditionalErrorChecks <code>true</code> if HTML 4-specific checks were enabled, <code>false</code> otherwise
     * @throws SAXException if things go wrong
     */
    public void documentMode(DocumentMode mode, String publicIdentifier, String systemIdentifier, boolean html4SpecificAdditionalErrorChecks) throws SAXException;
}
