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

package nu.validator.htmlparser.test;

import java.util.LinkedList;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class ListErrorHandler implements ErrorHandler {

    private boolean fatal = false;
    
    private LinkedList<String> errors = new LinkedList<String>();
    
    public void error(SAXParseException spe) throws SAXException {
        errors.add(Integer.toString(spe.getColumnNumber()) + ": " + spe.getMessage());
    }

    public void fatalError(SAXParseException arg0) throws SAXException {
        fatal = true;
    }

    public void warning(SAXParseException arg0) throws SAXException {
    }

    /**
     * Returns the errors.
     * 
     * @return the errors
     */
    public LinkedList<String> getErrors() {
        return errors;
    }

    /**
     * Returns the fatal.
     * 
     * @return the fatal
     */
    public boolean isFatal() {
        return fatal;
    }

}
