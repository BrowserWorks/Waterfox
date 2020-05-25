/*
 * Copyright (c) 2007 Henri Sivonen
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

package nu.validator.saxtree;

import org.xml.sax.Locator;

/**
 * A locator implementation.
 * @version $Id$
 * @author hsivonen
 */
public final class LocatorImpl implements Locator {

    /**
     * The system id.
     */
    private final String systemId;
    
    /**
     * The public id.
     */
    private final String publicId;
    
    /**
     * The column.
     */
    private final int column;
    
    /**
     * The line.
     */
    private final int line;
    
    /**
     * The constructor.
     * @param locator the locator
     */
    public LocatorImpl(Locator locator) {
        if (locator == null) {
            this.systemId = null;
            this.publicId = null;
            this.column = -1;
            this.line = -1;
        } else {
            this.systemId = locator.getSystemId();
            this.publicId = locator.getPublicId();
            this.column = locator.getColumnNumber();
            this.line = locator.getLineNumber();
        }
    }
    
    /**
     * 
     * @see org.xml.sax.Locator#getColumnNumber()
     */
    public int getColumnNumber() {
        return column;
    }

    /**
     * 
     * @see org.xml.sax.Locator#getLineNumber()
     */
    public int getLineNumber() {
        return line;
    }

    /**
     * 
     * @see org.xml.sax.Locator#getPublicId()
     */
    public String getPublicId() {
        return publicId;
    }

    /**
     * 
     * @see org.xml.sax.Locator#getSystemId()
     */
    public String getSystemId() {
        return systemId;
    }
}
